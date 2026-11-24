/** Gate.cpp: the config switch over the native escape hatch, and native_enabled. */
#include <mutex>
#include <set>
#include <string>

#include "ll/api/mod/NativeMod.h"
#include "ll/api/utils/StringUtils.h"

#include "sdk/abi.h"

#include "pier/api/native.h"
#include "pier/host/hosted_mod.h"
#include "pier/host/spi.h"
#include "pier/support/config.h"
#include "pier/support/i18n.h"

namespace pier::native
{
    namespace
    {
        bool api_native_enabled() { return config().nativeDetour; }

        void fill(PierApi& api) { api.native_enabled = &api_native_enabled; }

        spi::SlotPackReg regSlots{{"native", &fill}};
    } // namespace

    std::int32_t gate(PierModHandle handle)
    {
        auto* mod = asMod(handle);
        if (!mod) return PIER_NATIVE_REFUSED;
        if (config().nativeDetour) return PIER_NATIVE_OK;
        // Once per mod name. A mod that probes in a loop would otherwise fill the log, and
        // the first line already names the setting to change.
        static std::mutex lock;
        static std::set<std::string> told;
        std::lock_guard guard{lock};
        if (told.insert(mod->getName()).second)
        {
            auto const file = ll::mod::NativeMod::current()->getModDir() / u8"config.json";
            mod->getLogger().warn("{}", trf("native.disabled", ll::string_utils::u8str2str(file.u8string())));
        }
        return PIER_NATIVE_DISABLED;
    }
} // namespace pier::native
