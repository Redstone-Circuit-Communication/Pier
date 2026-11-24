package levilamina

// The native escape hatch: engine addresses and native detours, for an engine call no other
// function wraps. The host checks nothing a mod does with an address, and its config.json
// has to set "native_detour": true; until it does, every call returns a NativeError whose
// Disabled method reports true. The raw methods of the slots taking an out pointer are
// written here, since tools/gen-go-api.py leaves those to hand-written code.

/*
#include <stdlib.h>
#include "sdk/abi.h"
#include "slots_gen.h"
#include "glue.h"
*/
import "C"

import (
	"fmt"
	"unsafe"
)

// The priorities of ll::memory::HookPriority, for InstallNativeHook.
const (
	HookPriorityHighest int32 = 0
	HookPriorityHigh    int32 = 100
	HookPriorityNormal  int32 = 200
	HookPriorityLow     int32 = 300
	HookPriorityLowest  int32 = 400
)

// NativeObjectKind names one engine service object for NativeObjectOf.
type NativeObjectKind int32

// The kinds of native_object. The two client kinds are not found on a server host.
const (
	NativeMinecraft            NativeObjectKind = C.PIER_NATIVE_OBJ_MINECRAFT
	NativeLevel                NativeObjectKind = C.PIER_NATIVE_OBJ_LEVEL
	NativeServerNetworkHandler NativeObjectKind = C.PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER
	NativeServerInstance       NativeObjectKind = C.PIER_NATIVE_OBJ_SERVER_INSTANCE
	NativeCommandRegistry      NativeObjectKind = C.PIER_NATIVE_OBJ_COMMAND_REGISTRY
	NativeNetworkSystem        NativeObjectKind = C.PIER_NATIVE_OBJ_NETWORK_SYSTEM
	NativeDBStorage            NativeObjectKind = C.PIER_NATIVE_OBJ_DB_STORAGE
	NativeClientInstance       NativeObjectKind = C.PIER_NATIVE_OBJ_CLIENT_INSTANCE
	NativeMultiPlayerLevel     NativeObjectKind = C.PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL
)

// NativeError is the answer of a native slot other than PIER_NATIVE_OK.
type NativeError struct {
	Op   string
	Code int32
}

// Disabled reports whether the host's config.json leaves native_detour off.
func (e *NativeError) Disabled() bool { return e.Code == C.PIER_NATIVE_DISABLED }

func (e *NativeError) Error() string {
	switch e.Code {
	case C.PIER_NATIVE_DISABLED:
		return e.Op + ": the pier host has not enabled this feature; check whether native_detour is true in its config.json"
	case C.PIER_NATIVE_NOT_FOUND:
		return e.Op + ": nothing by that name or id exists right now"
	case C.PIER_NATIVE_REFUSED:
		return e.Op + ": the host refused the arguments"
	case C.PIER_NATIVE_FAILED:
		return e.Op + ": the engine-side call failed"
	}
	return fmt.Sprintf("%s: the host answered %d, a code this binding does not know", e.Op, e.Code)
}

func nativeAddress(op string, p unsafe.Pointer, code int32, err error) (unsafe.Pointer, error) {
	if err != nil {
		return nil, err
	}
	if code != C.PIER_NATIVE_OK {
		return nil, &NativeError{Op: op, Code: code}
	}
	return p, nil
}

// NativeResolveSymbol calls the native_resolve_symbol slot.
//
// The address of an engine function by its decorated symbol name.
func (RawAPI) NativeResolveSymbol(symbol string) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_resolve_symbol(api)) {
		return nil, 0, notProvided("native_resolve_symbol")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_resolve_symbol(api, self, str(symbol), &out)
	return out, int32(r), nil
}

// NativeResolveSignature calls the native_resolve_signature slot.
//
// The first match of a byte pattern in the engine executable.
func (RawAPI) NativeResolveSignature(pattern string) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_resolve_signature(api)) {
		return nil, 0, notProvided("native_resolve_signature")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_resolve_signature(api, self, str(pattern), &out)
	return out, int32(r), nil
}

// NativeModuleExport calls the native_module_export slot.
//
// An export of a module already loaded into the process.
func (RawAPI) NativeModuleExport(module, name string) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_module_export(api)) {
		return nil, 0, notProvided("native_module_export")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_module_export(api, self, str(module), str(name), &out)
	return out, int32(r), nil
}

// NativeObject calls the native_object slot.
//
// The address of one engine service object.
func (RawAPI) NativeObject(kind int32) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_object(api)) {
		return nil, 0, notProvided("native_object")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_object(api, self, C.int32_t(kind), &out)
	return out, int32(r), nil
}

// NativePlayer calls the native_player slot.
//
// The Player object of an online player.
func (RawAPI) NativePlayer(p Player) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_player(api)) {
		return nil, 0, notProvided("native_player")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_player(api, self, p.Sel.c(), &out)
	return out, int32(r), nil
}

// NativeActor calls the native_actor slot.
//
// The Actor object of a loaded actor.
func (RawAPI) NativeActor(id ActorID) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_actor(api)) {
		return nil, 0, notProvided("native_actor")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_actor(api, self, C.PierActorId(id), &out)
	return out, int32(r), nil
}

// NativeDimension calls the native_dimension slot.
//
// The Dimension object of a dimension id.
func (RawAPI) NativeDimension(dim int32) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_dimension(api)) {
		return nil, 0, notProvided("native_dimension")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_dimension(api, self, C.int32_t(dim), &out)
	return out, int32(r), nil
}

// NativeBlockSource calls the native_block_source slot.
//
// The BlockSource of a dimension id.
func (RawAPI) NativeBlockSource(dim int32) (unsafe.Pointer, int32, error) {
	if api == nil || !bool(C.piergo_has_native_block_source(api)) {
		return nil, 0, notProvided("native_block_source")
	}
	var out unsafe.Pointer
	r := C.piergo_call_native_block_source(api, self, C.int32_t(dim), &out)
	return out, int32(r), nil
}

// NativeHookInstall calls the native_hook_install slot.
//
// Installs a native detour on target through ll::memory::hook.
func (RawAPI) NativeHookInstall(target, detour unsafe.Pointer, priority int32) (unsafe.Pointer, uint64, int32, error) {
	if api == nil || !bool(C.piergo_has_native_hook_install(api)) {
		return nil, 0, 0, notProvided("native_hook_install")
	}
	var original unsafe.Pointer
	var id C.uint64_t
	r := C.piergo_call_native_hook_install(api, self, target, detour, C.int32_t(priority), &original, &id)
	return original, uint64(id), int32(r), nil
}

// NativeEnabledNow reports whether the host answers the native calls, which its
// config.json decides.
func NativeEnabledNow() bool {
	ok, err := RawAPI{}.NativeEnabled()
	return err == nil && ok
}

// NativeSymbol is the address of an engine function by its decorated symbol name.
func NativeSymbol(symbol string) (unsafe.Pointer, error) {
	p, code, err := RawAPI{}.NativeResolveSymbol(symbol)
	return nativeAddress("resolving a native symbol", p, code, err)
}

// NativeSignature is the first match of a byte pattern such as "48 8B ?? 08" in the engine
// executable.
func NativeSignature(pattern string) (unsafe.Pointer, error) {
	p, code, err := RawAPI{}.NativeResolveSignature(pattern)
	return nativeAddress("resolving a byte pattern", p, code, err)
}

// NativeExport is an export of a module already loaded into the process; an empty module
// names the engine executable. LeviLamina's API is an export of LeviLamina.dll.
func NativeExport(module, name string) (unsafe.Pointer, error) {
	p, code, err := RawAPI{}.NativeModuleExport(module, name)
	return nativeAddress("reading a module export", p, code, err)
}

// NativeObjectOf is the address of one engine service object.
func NativeObjectOf(kind NativeObjectKind) (unsafe.Pointer, error) {
	p, code, err := RawAPI{}.NativeObject(int32(kind))
	return nativeAddress("reading a native object", p, code, err)
}

// NativePlayerOf is the engine's Player object of an online player, valid while the player
// stays online.
func NativePlayerOf(p Player) (unsafe.Pointer, error) {
	ptr, code, err := RawAPI{}.NativePlayer(p)
	return nativeAddress("reading a native player", ptr, code, err)
}

// NativeActorOf is the engine's Actor object of a loaded actor.
func NativeActorOf(id ActorID) (unsafe.Pointer, error) {
	p, code, err := RawAPI{}.NativeActor(id)
	return nativeAddress("reading a native actor", p, code, err)
}

// NativeDimensionOf is the engine's Dimension object of a dimension id.
func NativeDimensionOf(dim int32) (unsafe.Pointer, error) {
	p, code, err := RawAPI{}.NativeDimension(dim)
	return nativeAddress("reading a native dimension", p, code, err)
}

// NativeBlockSourceOf is the engine's BlockSource of a dimension id.
func NativeBlockSourceOf(dim int32) (unsafe.Pointer, error) {
	p, code, err := RawAPI{}.NativeBlockSource(dim)
	return nativeAddress("reading a native block source", p, code, err)
}

// NativeHook is one installed detour: the id RemoveNativeHook takes, and the address
// through which the detour calls the next detour or the engine.
type NativeHook struct {
	ID       uint64
	Original unsafe.Pointer
}

// InstallNativeHook installs detour on target at a HookPriority value. detour must be a C
// function with the exact signature and calling convention of target, and it reaches the
// engine through Original only. The host removes a detour this mod still holds when the
// mod unloads, and does not wait for a call already inside it on another thread.
func InstallNativeHook(target, detour unsafe.Pointer, priority int32) (NativeHook, error) {
	original, id, code, err := RawAPI{}.NativeHookInstall(target, detour, priority)
	if err != nil {
		return NativeHook{}, err
	}
	if code != C.PIER_NATIVE_OK {
		return NativeHook{}, &NativeError{Op: "installing a native detour", Code: code}
	}
	return NativeHook{ID: id, Original: original}, nil
}

// RemoveNativeHook removes a detour this mod installed.
func RemoveNativeHook(h NativeHook) error {
	code, err := RawAPI{}.NativeHookRemove(h.ID)
	if err != nil {
		return err
	}
	if code != C.PIER_NATIVE_OK {
		return &NativeError{Op: "removing a native detour", Code: code}
	}
	return nil
}
