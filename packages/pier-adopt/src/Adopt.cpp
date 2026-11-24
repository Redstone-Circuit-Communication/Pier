/** Adopt.cpp: loads the pier mods LeviLamina refused for naming the host "pier".
 *
 * LeviLamina resolves `dependencies` against the manifests on disk, by exact name and
 * before any mod runs. A mod naming "pier" is refused while the host's manifest says
 * "Pier", and so is every mod depending on such a mod, and no mod can change that
 * resolution. This TU waits for the host's own enable, which comes after the startup
 * pass, finds those mods on disk and brings each one up through ModHost::controlLoad once
 * everything it depends on is enabled. Each one is named in a warning that says which
 * manifest to correct, since LeviLamina refuses it again on every start until then.
 *
 * An adopted mod lives in the host's table and outside LeviLamina's dependency graph, the
 * same as one brought up by /pier load. config.json `mods.adopt: false` turns this off.
 */
#include <algorithm>
#include <cstddef>
#include <memory>
#include <optional>
#include <set>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "ll/api/data/Version.h"
#include "ll/api/data/VersionRequirement.h"
#include "ll/api/mod/Manifest.h"
#include "ll/api/mod/Mod.h"
#include "ll/api/mod/ModManagerRegistry.h"
#include "ll/api/mod/NativeMod.h"
#include "ll/api/utils/ErrorUtils.h"
#include "ll/api/utils/StringUtils.h"

#include "pier/host/mod_control.h"
#include "pier/host/mod_host.h"
#include "pier/host/spi.h"
#include "pier/support/config.h"
#include "pier/support/i18n.h"
#include "pier/support/log.h"

namespace pier::adopt
{
    namespace
    {
        /** The spelling the documentation used before the manifest name was the rule. Only
         *  this one: a looser match would load a mod that names some other mod. */
        constexpr std::string_view kAlias = "pier";

        struct Orphan
        {
            ll::mod::Manifest manifest;
            /** Empty when the mod names kAlias itself. Otherwise the adopted mod whose
             *  refusal took this one down with it. */
            std::string via;
        };

        struct State
        {
            std::string host;
            std::optional<ll::data::Version> hostVersion;
            bool scanned = false;
            bool running = false;
            /** Names whose enable is in progress further up this thread's stack.
             *  Mod::onEnable runs the registry callbacks before it sets the state, so
             *  isEnabled() is still false for each of them. */
            std::vector<std::string> enabling;
            std::vector<Orphan> pending;
            std::set<std::string> failed;
        };

        /** Touched only from the enable callback, which LeviLamina runs on the one thread
         *  that enables mods. */
        State& state()
        {
            static State s;
            return s;
        }

        bool isHostName(std::string_view name) { return name == kAlias || name == state().host; }

        bool versionFits(ll::mod::Dependency const& dep, std::optional<ll::data::Version> const& have)
        {
            return !dep.version || (have && dep.version->matches(*have));
        }

        /** The test LeviLamina applies before it plans anything, so a mod it refused for
         *  the platform is never brought up here. */
        bool platformFits(ll::mod::Manifest const& m)
        {
            if (!m.platform || *m.platform == "universal") return true;
#ifdef PIER_BUILD_CLIENT
            return *m.platform == "client";
#else
            return *m.platform == "server";
#endif
        }

        /** LeviLamina's registry first, then the host's own table, which is where a mod
         *  adopted earlier or brought up by /pier load is. */
        std::shared_ptr<ll::mod::Mod> loadedMod(std::string const& name)
        {
            if (auto m = ll::mod::ModManagerRegistry::getInstance().getMod(name)) return m;
            if (auto* host = ModHost::instance()) return host->getMod(name);
            return {};
        }

        bool isEnabledNow(std::string const& name)
        {
            auto const& s = state();
            if (std::find(s.enabling.begin(), s.enabling.end(), name) != s.enabling.end()) return true;
            auto const m = loadedMod(name);
            return m && m->isEnabled();
        }

        /** Every pier mod on disk that LeviLamina refused because of kAlias, directly or
         *  through a dependency, in the order /pier list shows them. */
        std::vector<Orphan> findOrphans()
        {
            auto const& s = state();
            std::vector<ll::mod::Manifest> loose;
            for (auto const& c : mod_control::rescan())
            {
                // A manifest with a problem, a mod that is loaded and a mod the operator
                // disabled each stay with the path that already reports them.
                if (!c.problem.empty() || mod_control::isLoadedAnywhere(c.name) || modDisabled(c.name)) continue;
                auto m = mod_control::readManifest(c.name);
                if (!m || !platformFits(*m)) continue;
                loose.push_back(std::move(*m));
            }

            std::vector<Orphan> found;
            auto adopted = [&found](std::string const& name) -> Orphan const*
            {
                for (auto const& o : found)
                {
                    if (o.manifest.name == name) return &o;
                }
                return nullptr;
            };
            // A fixed point: a mod joins once each dependency is the host under either name,
            // a loaded mod, or a mod that already joined, each at a version that fits.
            for (bool grew = true; grew;)
            {
                grew = false;
                for (auto const& m : loose)
                {
                    if (m.name.empty() || adopted(m.name)) continue;
                    bool fits = true;
                    bool named = false;
                    std::string via;
                    if (m.dependencies)
                    {
                        for (auto const& d : *m.dependencies)
                        {
                            if (isHostName(d.name))
                            {
                                fits = fits && versionFits(d, s.hostVersion);
                                named = named || d.name == kAlias;
                            }
                            else if (auto const live = loadedMod(d.name))
                            {
                                fits = fits && versionFits(d, live->getManifest().version);
                            }
                            else if (auto const* o = adopted(d.name))
                            {
                                fits = fits && versionFits(d, o->manifest.version);
                                via = d.name;
                            }
                            else
                            {
                                fits = false;
                            }
                        }
                    }
                    // A mod that fits without kAlias anywhere was refused for some other
                    // reason, and loading it here would overrule that refusal.
                    if (!fits || (!named && via.empty())) continue;
                    found.push_back(Orphan{m, named ? std::string{} : via});
                    grew = true;
                }
            }

            // LeviLamina loads a passive mod only for a mod that depends on it, and so does
            // this: a passive orphan stays when an orphan that is not passive reaches it.
            std::set<std::string> reached;
            std::vector<std::string> stack;
            for (auto const& o : found)
            {
                if (o.manifest.passive != true) stack.push_back(o.manifest.name);
            }
            while (!stack.empty())
            {
                auto name = std::move(stack.back());
                stack.pop_back();
                if (!reached.insert(name).second) continue;
                auto const* o = adopted(name);
                if (!o || !o->manifest.dependencies) continue;
                for (auto const& d : *o->manifest.dependencies)
                {
                    if (adopted(d.name)) stack.push_back(d.name);
                }
            }
            std::erase_if(found, [&reached](Orphan const& o) { return !reached.contains(o.manifest.name); });
            return found;
        }

        /** 1 when every dependency is enabled, 0 while one is not yet, -1 when one failed
         *  to load, with its name in `blocker`. */
        int readiness(Orphan const& o, std::string& blocker)
        {
            auto const& s = state();
            if (!o.manifest.dependencies) return 1;
            for (auto const& d : *o.manifest.dependencies)
            {
                std::string const name = isHostName(d.name) ? s.host : d.name;
                if (s.failed.contains(name))
                {
                    blocker = name;
                    return -1;
                }
                if (!isEnabledNow(name)) return 0;
            }
            return 1;
        }

        void bringUp(Orphan o)
        {
            auto& s = state();
            std::string const name = o.manifest.name;
            std::string const named = o.via.empty() ? std::string{kAlias} : o.via;
            auto* host = ModHost::instance();
            auto const result = host ? host->controlLoad(std::move(o.manifest))
                                     : ll::Expected<>{ll::makeStringError("the pier mod manager is gone")};
            if (!result)
            {
                s.failed.insert(name);
                hostLogger().error("[adopt] {}", trf("adopt.failed", name, named, result.error().message()));
                return;
            }
            if (o.via.empty())
            {
                auto const file = ll::mod::getModsRoot() / ll::string_utils::sv2u8sv(name) / u8"manifest.json";
                hostLogger().warn("[adopt] {}", trf("adopt.loaded", name, kAlias, s.host,
                                                    ll::string_utils::u8str2str(file.u8string())));
            }
            else
            {
                hostLogger().warn("[adopt] {}", trf("adopt.loaded_via", name, o.via, kAlias, name));
            }
        }

        /** Brings up whatever is ready, one at a time, rescanning after each, since one
         *  brought up can be what the next is waiting for. */
        void advance()
        {
            auto& s = state();
            for (bool moved = true; moved;)
            {
                moved = false;
                for (std::size_t i = 0; i < s.pending.size(); ++i)
                {
                    std::string blocker;
                    int const ready = readiness(s.pending[i], blocker);
                    if (ready == 0) continue;
                    Orphan o = std::move(s.pending[i]);
                    s.pending.erase(s.pending.begin() + static_cast<std::ptrdiff_t>(i));
                    if (ready < 0)
                    {
                        s.failed.insert(o.manifest.name);
                        hostLogger().error("[adopt] {}", trf("adopt.stuck", o.manifest.name, blocker));
                    }
                    else
                    {
                        bringUp(std::move(o));
                    }
                    moved = true;
                    break;
                }
            }
        }

        void onEnabled(std::string_view name) noexcept
        {
            auto& s = state();
            try
            {
                if (!s.scanned)
                {
                    if (name != s.host) return;
                    s.scanned = true;
                    s.pending = findOrphans();
                }
                if (s.pending.empty()) return;
                // controlLoad enables what it loads, and that enable calls back in here on
                // this thread. The inner call only marks its mod as enabling; the loop of
                // the outer call picks up whatever that unblocked.
                s.enabling.emplace_back(name);
                if (!s.running)
                {
                    s.running = true;
                    advance();
                    s.running = false;
                }
                s.enabling.pop_back();
            }
            catch (...)
            {
                // Caught here because a throw would reach Mod::onEnable as an error and fail
                // the enable of the mod named, the host itself included.
                s.running = false;
                s.enabling.clear();
                ll::error_utils::printCurrentException(hostLogger());
            }
        }

        void bootstrap()
        {
            if (!config().adoptMods) return;
            auto const self = ll::mod::NativeMod::current();
            if (!self) return;
            auto& s = state();
            s.host = self->getName();
            s.hostVersion = self->getManifest().version;
            ll::mod::ModManagerRegistry::getInstance().executeOnModEnable(
                [](std::string_view name) { onEnabled(name); });
        }

        spi::BootstrapReg regBoot{{200, "adopt", &bootstrap}};
    } // namespace
} // namespace pier::adopt
