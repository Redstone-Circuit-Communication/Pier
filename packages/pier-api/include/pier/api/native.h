/** native.h: the switch every native_* slot of pier-api consults first. */
#pragma once

#include <cstdint>

#include "sdk/abi.h"

namespace pier::native
{
    /** PIER_NATIVE_OK when config.json sets native_detour and `mod` is a handle. Otherwise
     *  the code the slot returns as it is: PIER_NATIVE_REFUSED for a null handle, and
     *  PIER_NATIVE_DISABLED after one warning per mod, written to that mod's logger. */
    [[nodiscard]] std::int32_t gate(PierModHandle mod);
} // namespace pier::native
