# Go: Native escape hatch

## Functions {#functions}

### `NativeEnabledNow` {#NativeEnabledNow}

```go
func NativeEnabledNow() bool
```

NativeEnabledNow reports whether the host answers the native calls, which its config.json decides.

- Return type: `bool`

### `NativeSymbol` {#NativeSymbol}

```go
func NativeSymbol(symbol string) (unsafe.Pointer, error)
```

NativeSymbol is the address of an engine function by its decorated symbol name.

- Parameters:
    - symbol : `string`
- Return type: `(unsafe.Pointer, error)`

### `NativeSignature` {#NativeSignature}

```go
func NativeSignature(pattern string) (unsafe.Pointer, error)
```

NativeSignature is the first match of a byte pattern such as "48 8B ?? 08" in the engine executable.

- Parameters:
    - pattern : `string`
- Return type: `(unsafe.Pointer, error)`

### `NativeExport` {#NativeExport}

```go
func NativeExport(module, name string) (unsafe.Pointer, error)
```

NativeExport is an export of a module already loaded into the process; an empty module names the engine executable. LeviLamina's API is an export of LeviLamina.dll.

- Parameters:
    - module : `string`
    - name : `string`
- Return type: `(unsafe.Pointer, error)`

### `NativeObjectOf` {#NativeObjectOf}

```go
func NativeObjectOf(kind NativeObjectKind) (unsafe.Pointer, error)
```

NativeObjectOf is the address of one engine service object.

- Parameters:
    - kind : `NativeObjectKind`
- Return type: `(unsafe.Pointer, error)`

### `NativePlayerOf` {#NativePlayerOf}

```go
func NativePlayerOf(p Player) (unsafe.Pointer, error)
```

NativePlayerOf is the engine's Player object of an online player, valid while the player stays online.

- Parameters:
    - p : `Player`
- Return type: `(unsafe.Pointer, error)`

### `NativeActorOf` {#NativeActorOf}

```go
func NativeActorOf(id ActorID) (unsafe.Pointer, error)
```

NativeActorOf is the engine's Actor object of a loaded actor.

- Parameters:
    - id : `ActorID`
- Return type: `(unsafe.Pointer, error)`

### `NativeDimensionOf` {#NativeDimensionOf}

```go
func NativeDimensionOf(dim int32) (unsafe.Pointer, error)
```

NativeDimensionOf is the engine's Dimension object of a dimension id.

- Parameters:
    - dim : `int32`
- Return type: `(unsafe.Pointer, error)`

### `NativeBlockSourceOf` {#NativeBlockSourceOf}

```go
func NativeBlockSourceOf(dim int32) (unsafe.Pointer, error)
```

NativeBlockSourceOf is the engine's BlockSource of a dimension id.

- Parameters:
    - dim : `int32`
- Return type: `(unsafe.Pointer, error)`

### `InstallNativeHook` {#InstallNativeHook}

```go
func InstallNativeHook(target, detour unsafe.Pointer, priority int32) (NativeHook, error)
```

InstallNativeHook installs detour on target at a HookPriority value. detour must be a C function with the exact signature and calling convention of target, and it reaches the engine through Original only. The host removes a detour this mod still holds when the mod unloads, and does not wait for a call already inside it on another thread.

- Parameters:
    - target : `unsafe.Pointer`
    - detour : `unsafe.Pointer`
    - priority : `int32`
- Return type: `(NativeHook, error)`

### `RemoveNativeHook` {#RemoveNativeHook}

```go
func RemoveNativeHook(h NativeHook) error
```

RemoveNativeHook removes a detour this mod installed.

- Parameters:
    - h : `NativeHook`
- Return type: `error`

## `NativeError` {#NativeError}

```go
type NativeError struct {
    Op   string
    Code int32
}
```

NativeError is the answer of a native slot other than `PIER_NATIVE_OK`.

### `NativeError.Disabled` {#NativeError.Disabled}

```go
func (e *NativeError) Disabled() bool
```

Disabled reports whether the host's config.json leaves `native_detour` off.

- Return type: `bool`

### `NativeError.Error` {#NativeError.Error}

```go
func (e *NativeError) Error() string
```

- Return type: `string`

## `NativeObjectKind` {#NativeObjectKind}

```go
type NativeObjectKind int32
```

NativeObjectKind names one engine service object for NativeObjectOf.

| Name | Value | Description |
|---|---|---|
| <span id="NativeMinecraft"></span>`NativeMinecraft` | `C.PIER_NATIVE_OBJ_MINECRAFT` |  |
| <span id="NativeLevel"></span>`NativeLevel` | `C.PIER_NATIVE_OBJ_LEVEL` |  |
| <span id="NativeServerNetworkHandler"></span>`NativeServerNetworkHandler` | `C.PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER` |  |
| <span id="NativeServerInstance"></span>`NativeServerInstance` | `C.PIER_NATIVE_OBJ_SERVER_INSTANCE` |  |
| <span id="NativeCommandRegistry"></span>`NativeCommandRegistry` | `C.PIER_NATIVE_OBJ_COMMAND_REGISTRY` |  |
| <span id="NativeNetworkSystem"></span>`NativeNetworkSystem` | `C.PIER_NATIVE_OBJ_NETWORK_SYSTEM` |  |
| <span id="NativeDBStorage"></span>`NativeDBStorage` | `C.PIER_NATIVE_OBJ_DB_STORAGE` |  |
| <span id="NativeClientInstance"></span>`NativeClientInstance` | `C.PIER_NATIVE_OBJ_CLIENT_INSTANCE` |  |
| <span id="NativeMultiPlayerLevel"></span>`NativeMultiPlayerLevel` | `C.PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL` |  |

## `NativeHook` {#NativeHook}

```go
type NativeHook struct {
    ID       uint64
    Original unsafe.Pointer
}
```

NativeHook is one installed detour: the id RemoveNativeHook takes, and the address through which the detour calls the next detour or the engine.

## `HookPriority*` {#HookPriority-values}

The priorities of `ll::memory::HookPriority`, for InstallNativeHook.

| Name | Value | Description |
|---|---|---|
| <span id="HookPriorityHighest"></span>`HookPriorityHighest` | `0` |  |
| <span id="HookPriorityHigh"></span>`HookPriorityHigh` | `100` |  |
| <span id="HookPriorityNormal"></span>`HookPriorityNormal` | `200` |  |
| <span id="HookPriorityLow"></span>`HookPriorityLow` | `300` |  |
| <span id="HookPriorityLowest"></span>`HookPriorityLowest` | `400` |  |
