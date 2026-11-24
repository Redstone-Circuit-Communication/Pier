package levilamina

// The state of a dimension that the other world functions only write: its weather.

/*
#include <stdlib.h>
#include "sdk/abi.h"
#include "slots_gen.h"
#include "glue.h"
*/
import "C"

// WorldWeather reads one PIER_WPROP_* value of dimension dim. The error covers an unknown key,
// a dimension that does not exist and a level that is not ready.
func WorldWeather(dim, prop int32) (float64, error) {
	v, ok, err := RawAPI{}.WorldGetNum(dim, prop)
	if err != nil {
		return 0, err
	}
	if !ok {
		return 0, noAnswer("world_get_num")
	}
	return v, nil
}

// WorldRainLevel is the rain level of a dimension, 0 for none to 1 for full rain.
func WorldRainLevel(dim int32) (float64, error) { return WorldWeather(dim, C.PIER_WPROP_RAIN_LEVEL) }

// WorldTargetRainLevel reads PIER_WPROP_TARGET_RAIN_LEVEL of dimension dim.
func WorldTargetRainLevel(dim int32) (float64, error) {
	return WorldWeather(dim, C.PIER_WPROP_TARGET_RAIN_LEVEL)
}

// WorldLightningLevel is the lightning level of a dimension, 0 for none to 1 for a storm.
func WorldLightningLevel(dim int32) (float64, error) {
	return WorldWeather(dim, C.PIER_WPROP_LIGHTNING_LEVEL)
}

// WorldTargetLightningLevel reads PIER_WPROP_TARGET_LIGHTNING_LEVEL of dimension dim.
func WorldTargetLightningLevel(dim int32) (float64, error) {
	return WorldWeather(dim, C.PIER_WPROP_TARGET_LIGHTNING_LEVEL)
}

// WorldFogLevel reads PIER_WPROP_FOG_LEVEL of dimension dim.
func WorldFogLevel(dim int32) (float64, error) { return WorldWeather(dim, C.PIER_WPROP_FOG_LEVEL) }

// WorldSkyFlashTime reads PIER_WPROP_SKY_FLASH_TIME of dimension dim.
func WorldSkyFlashTime(dim int32) (float64, error) {
	return WorldWeather(dim, C.PIER_WPROP_SKY_FLASH_TIME)
}
