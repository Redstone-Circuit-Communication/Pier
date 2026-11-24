/** WorldProps.cpp: world_get_num, the state of a dimension the other world slots only write. */
#include <memory>

#include "mc/world/level/BlockSource.h"
#include "mc/world/level/Weather.h"
#include "mc/world/level/dimension/Dimension.h"

#include "sdk/abi.h"

#include "pier/api/bridge.h"
#include "pier/host/spi.h"
#include "pier/support/guard.h"

namespace pier::api_impl
{
    namespace
    {
        bool api_world_get_num(int32_t dim, int32_t prop, double* out)
        {
            PIER_API_GUARD_BEGIN
                if (!out) return false;
                auto* source = bridge::blockSourceOf(dim);
                if (!source) return false;
                auto const& weather = static_cast<std::unique_ptr<Weather> const&>(source->getDimension().mWeather);
                if (!weather) return false;
                switch (prop)
                {
                case PIER_WPROP_RAIN_LEVEL: *out = static_cast<float>(weather->mRainLevel); return true;
                case PIER_WPROP_TARGET_RAIN_LEVEL: *out = static_cast<float>(weather->mTargetRainLevel); return true;
                case PIER_WPROP_LIGHTNING_LEVEL: *out = static_cast<float>(weather->mLightningLevel); return true;
                case PIER_WPROP_TARGET_LIGHTNING_LEVEL:
                    *out = static_cast<float>(weather->mTargetLightningLevel);
                    return true;
                case PIER_WPROP_FOG_LEVEL: *out = static_cast<float>(weather->mFogLevel); return true;
                case PIER_WPROP_SKY_FLASH_TIME: *out = static_cast<int>(weather->mSkyFlashTime); return true;
                case PIER_WPROP_WEATHER_TICK: *out = static_cast<int>(weather->mTick); return true;
                default: return false;
                }
            PIER_API_GUARD_END
        }

        void fill(PierApi& api) { api.world_get_num = &api_world_get_num; }

        spi::SlotPackReg regSlots{{"world-props", &fill}};
    } // namespace
} // namespace pier::api_impl
