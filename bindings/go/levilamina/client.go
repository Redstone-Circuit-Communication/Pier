package levilamina

// The second client group: the local player, the screens, the HUD and the key registry.
// Every function returns a NotProvidedError on a server host or an older client host.

/*
#include <stdlib.h>
#include "sdk/abi.h"
#include "slots_gen.h"
#include "glue.h"
*/
import "C"

import (
	"fmt"
	"runtime/cgo"
)

// ClientProperty reads one numeric client property by its PIER_CPROP_* key. The error
// covers a key this host does not know and a key about the local player read while the
// client is not in a world.
func ClientProperty(prop int32) (float64, error) {
	v, ok, err := RawAPI{}.ClientGetNum(prop)
	if err != nil {
		return 0, err
	}
	if !ok {
		return 0, fmt.Errorf("client property %d could not be read: this host does not know the key, or it needs a world the client is not in", prop)
	}
	return v, nil
}

// ClientLocalPosition is the local player's feet position, x, y and z.
func ClientLocalPosition() ([3]float64, error) {
	var pos [3]float64
	for i, key := range []int32{C.PIER_CPROP_POS_X, C.PIER_CPROP_POS_Y, C.PIER_CPROP_POS_Z} {
		v, err := ClientProperty(key)
		if err != nil {
			return pos, err
		}
		pos[i] = v
	}
	return pos, nil
}

// ClientLocalRotation is the local player's pitch and yaw in degrees; a negative pitch
// looks up.
func ClientLocalRotation() (pitch, yaw float64, err error) {
	if pitch, err = ClientProperty(C.PIER_CPROP_PITCH); err != nil {
		return 0, 0, err
	}
	yaw, err = ClientProperty(C.PIER_CPROP_YAW)
	return pitch, yaw, err
}

// ClientRegisteredKeys lists every key binding name the key registry holds, whichever mod
// registered it.
func ClientRegisteredKeys() ([]string, error) {
	items, ok, err := RawAPI{}.ClientListKeys()
	if err != nil {
		return nil, err
	}
	if !ok {
		return nil, fmt.Errorf("the key registry could not be listed")
	}
	return items, nil
}

// ClientHasKey reports whether a key binding of this name is registered.
func ClientHasKey(name string) (bool, error) {
	keys, err := ClientRegisteredKeys()
	for _, k := range keys {
		if k == name {
			return true, err
		}
	}
	return false, err
}

// ClientOptions lists every client option as key and value, in the text form options.txt
// stores.
func ClientOptions() ([]KeyValue, error) {
	if api == nil || !bool(C.piergo_has_client_option_list(api)) {
		return nil, notProvided("client_option_list")
	}
	col := &kvCollector{}
	h := cgo.NewHandle(col)
	defer h.Delete()
	if !bool(C.piergo_call_client_option_list(api, handle(uintptr(h)), C.piergo_kv_sink())) {
		return nil, fmt.Errorf("the client options could not be listed: the client has no instance yet")
	}
	return col.pairs, nil
}

// ClientOption reads one client option by its options.txt key, such as "gfx_field_of_view".
func ClientOption(key string) (string, error) {
	out, ok, err := RawAPI{}.ClientOptionGet(key)
	if err != nil {
		return "", err
	}
	if !ok || len(out) == 0 {
		return "", fmt.Errorf("the client option %s does not exist, or the client has no instance yet", key)
	}
	return out[len(out)-1], nil
}

// SetClientOption writes one client option from its options.txt text form. The engine keeps
// what it can parse and reports nothing, so a caller that needs to know reads the key back.
func SetClientOption(key, value string) error {
	ok, err := RawAPI{}.ClientOptionSet(key, value)
	if err != nil {
		return err
	}
	if !ok {
		return fmt.Errorf("the client option %s was not written: it does not exist, it cannot be changed now, or the client has no instance yet", key)
	}
	return nil
}
