/** Detours.cpp: native_hook_install and native_hook_remove, and removing what a mod left
 *  installed before its dll is unmapped. */
#include <algorithm>
#include <cstdint>
#include <mutex>
#include <vector>

#include "ll/api/memory/Hook.h"

#include "sdk/abi.h"

#include "pier/api/native.h"
#include "pier/host/hosted_mod.h"
#include "pier/host/spi.h"
#include "pier/support/guard.h"
#include "pier/support/i18n.h"
#include "pier/support/log.h"

namespace pier::native
{
    namespace
    {
        struct Installed
        {
            std::uint64_t id;
            /** Identity only, never dereferenced. */
            HostedMod* owner;
            void* target;
            void* detour;
        };

        /** Locked although the slots are documented for one thread: the teardown runs on
         *  whichever thread unloads the mod. */
        std::mutex gLock;
        std::vector<Installed> gInstalled;
        std::uint64_t gNextId = 1;

        std::int32_t api_native_hook_install(PierModHandle mod, void* target, void* detour,
                                             std::int32_t priority, void** outOriginal,
                                             std::uint64_t* outId)
        {
            PIER_API_GUARD_BEGIN
                if (outOriginal) *outOriginal = nullptr;
                if (outId) *outId = 0;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!target || !detour || !outOriginal || !outId) return PIER_NATIVE_REFUSED;
                if (priority < 0 || priority > 400) return PIER_NATIVE_REFUSED;
                std::lock_guard guard{gLock};
                // unhook identifies a detour by this pair, so a second install of it would
                // leave two records that one removal could not tell apart.
                for (auto const& h : gInstalled)
                {
                    if (h.target == target && h.detour == detour) return PIER_NATIVE_REFUSED;
                }
                void* original = nullptr;
                if (ll::memory::hook(target, detour, &original,
                                     static_cast<ll::memory::HookPriority>(priority)) != 0)
                {
                    return PIER_NATIVE_FAILED;
                }
                std::uint64_t const id = gNextId++;
                gInstalled.push_back(Installed{id, asMod(mod), target, detour});
                *outOriginal = original;
                *outId = id;
                return PIER_NATIVE_OK;
            PIER_API_GUARD_END_VAL(PIER_NATIVE_FAILED)
        }

        std::int32_t api_native_hook_remove(PierModHandle mod, std::uint64_t id)
        {
            PIER_API_GUARD_BEGIN
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                std::lock_guard guard{gLock};
                auto const it = std::find_if(gInstalled.begin(), gInstalled.end(), [&](Installed const& h)
                                             { return h.id == id && h.owner == asMod(mod); });
                if (it == gInstalled.end()) return PIER_NATIVE_NOT_FOUND;
                if (!ll::memory::unhook(it->target, it->detour)) return PIER_NATIVE_FAILED;
                gInstalled.erase(it);
                return PIER_NATIVE_OK;
            PIER_API_GUARD_END_VAL(PIER_NATIVE_FAILED)
        }

        /** Teardown at stage 5, ahead of everything else: a detour re-enters the mod from any
         *  engine path, so it goes before the dll does. A removal that fails is logged and
         *  dropped, since nothing after this point can keep the dll mapped. */
        void teardown(HostedMod* mod)
        {
            if (!mod) return;
            std::lock_guard guard{gLock};
            for (auto it = gInstalled.begin(); it != gInstalled.end();)
            {
                if (it->owner != mod)
                {
                    ++it;
                    continue;
                }
                if (!ll::memory::unhook(it->target, it->detour))
                {
                    hostLogger().error("[native] {}", trf("native.unhook_failed", it->id, mod->getName()));
                }
                it = gInstalled.erase(it);
            }
        }

        void fill(PierApi& api)
        {
            api.native_hook_install = &api_native_hook_install;
            api.native_hook_remove = &api_native_hook_remove;
        }

        spi::SlotPackReg regSlots{{"native-detours", &fill}};
        spi::TeardownReg regDown{{5, "native-detours", &teardown}};
    } // namespace
} // namespace pier::native
