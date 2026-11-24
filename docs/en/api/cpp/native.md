# Native escape hatch

??? note "Section notes in abi.h"

    **Native escape hatch (native\_\*); its section near the top of this file is the**

    contract. Filled on every host. While config.json leaves `native_detour` off, each slot but `native_enabled` answers `PIER_NATIVE_DISABLED`. Call them on the thread the host calls the mod on: the server thread, or the client thread on a client host. Every `out` is set to NULL or 0 first and written on `PIER_NATIVE_OK` only.

## Slots {#slots}

### `native_enabled` {#native_enabled}

```c
bool (*native_enabled)(void);
```

Whether `native_detour` is on, so the other native\_\* slots can answer. Logs nothing.

- Call: `api->native_enabled()`
- Return type: `bool`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 206, counting from 0
- Callers in each binding:
    - Rust: [`native::enabled`](../rust/native.md#fn.enabled), [`native::enabled`](../rust/native.md#fn.enabled)
    - Go: [`Raw.NativeEnabled`](../go/raw.md#Raw.NativeEnabled)
    - Zig: [`native.enabled`](../zig/native.md#native.enabled)

### `native_resolve_symbol` {#native_resolve_symbol}

```c
int32_t (*native_resolve_symbol)(PierModHandle mod, PierStr symbol, void** out);
```

The address of an engine function by its decorated symbol name, through the host's own resolution, `ll::memory::SymbolView::resolve`.

- Call: `api->native_resolve_symbol(mod, symbol, out)`
- Parameters:
    - mod : `PierModHandle`
    - symbol : `PierStr`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 207, counting from 0
- Callers in each binding:
    - Rust: [`native::resolve_symbol`](../rust/native.md#fn.resolve_symbol)
    - Go: [`Raw.NativeResolveSymbol`](../go/raw.md#Raw.NativeResolveSymbol)
    - Zig: [`native.resolveSymbol`](../zig/native.md#native.resolveSymbol)

### `native_resolve_signature` {#native_resolve_signature}

```c
int32_t (*native_resolve_signature)(PierModHandle mod, PierStr pattern, void** out);
```

The first match of a byte pattern in the engine executable. `pattern` is tokens separated by spaces, each two hexadecimal digits or a wildcard written "?" or "??", such as "48 8B ?? 08". A token of any other shape refuses the call; it is never read as a byte.

- Call: `api->native_resolve_signature(mod, pattern, out)`
- Parameters:
    - mod : `PierModHandle`
    - pattern : `PierStr`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 208, counting from 0
- Callers in each binding:
    - Rust: [`native::resolve_signature`](../rust/native.md#fn.resolve_signature)
    - Go: [`Raw.NativeResolveSignature`](../go/raw.md#Raw.NativeResolveSignature)
    - Zig: [`native.resolveSignature`](../zig/native.md#native.resolveSignature)

### `native_module_export` {#native_module_export}

```c
int32_t (*native_module_export)(PierModHandle mod, PierStr module, PierStr name,
                                void** out);
```

An export of a module already loaded into the process, through GetModuleHandle and GetProcAddress. An empty `module` names the engine executable. LeviLamina's own API is reached this way, as an export of LeviLamina.dll under its decorated name. The host never loads a module for this call.

- Call: `api->native_module_export(mod, module, name, out)`
- Parameters:
    - mod : `PierModHandle`
    - module : `PierStr`
    - name : `PierStr`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 209, counting from 0
- Callers in each binding:
    - Rust: [`native::module_export`](../rust/native.md#fn.module_export)
    - Go: [`Raw.NativeModuleExport`](../go/raw.md#Raw.NativeModuleExport)
    - Zig: [`native.moduleExport`](../zig/native.md#native.moduleExport)

### `native_object` {#native_object}

```c
int32_t (*native_object)(PierModHandle mod, int32_t kind, void** out);
```

The address of one engine service object, `kind` a PIER\_NATIVE\_OBJ\_\* value. `PIER_NATIVE_NOT_FOUND` while the object does not exist, as the level before a world loads, and for a client-only kind on a server host.

- Call: `api->native_object(mod, kind, out)`
- Parameters:
    - mod : `PierModHandle`
    - kind : `int32_t`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 210, counting from 0
- Callers in each binding:
    - Rust: [`native::object`](../rust/native.md#fn.object)
    - Go: [`Raw.NativeObject`](../go/raw.md#Raw.NativeObject)
    - Zig: [`native.object`](../zig/native.md#native.object)

### `native_player` {#native_player}

```c
int32_t (*native_player)(PierModHandle mod, PierPlayerSel sel, void** out);
```

The Player object of an online player, resolved like every other selector.

- Call: `api->native_player(mod, sel, out)`
- Parameters:
    - mod : `PierModHandle`
    - sel : `PierPlayerSel`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 211, counting from 0
- Callers in each binding:
    - Rust: [`native::player`](../rust/native.md#fn.player)
    - Go: [`Raw.NativePlayer`](../go/raw.md#Raw.NativePlayer)
    - Zig: [`native.player`](../zig/native.md#native.player)

### `native_actor` {#native_actor}

```c
int32_t (*native_actor)(PierModHandle mod, PierActorId id, void** out);
```

The Actor object of a loaded actor.

- Call: `api->native_actor(mod, id, out)`
- Parameters:
    - mod : `PierModHandle`
    - id : `PierActorId`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 212, counting from 0
- Callers in each binding:
    - Rust: [`native::actor`](../rust/native.md#fn.actor)
    - Go: [`Raw.NativeActor`](../go/raw.md#Raw.NativeActor)
    - Zig: [`native.actor`](../zig/native.md#native.actor)

### `native_dimension` {#native_dimension}

```c
int32_t (*native_dimension)(PierModHandle mod, int32_t dim, void** out);
```

The Dimension object of a dimension id, custom dimensions included. A custom dimension the engine has not built yet is built by this call, the same as a block write into it would build it.

- Call: `api->native_dimension(mod, dim, out)`
- Parameters:
    - mod : `PierModHandle`
    - dim : `int32_t`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 213, counting from 0
- Callers in each binding:
    - Rust: [`native::dimension`](../rust/native.md#fn.dimension)
    - Go: [`Raw.NativeDimension`](../go/raw.md#Raw.NativeDimension)
    - Zig: [`native.dimension`](../zig/native.md#native.dimension)

### `native_block_source` {#native_block_source}

```c
int32_t (*native_block_source)(PierModHandle mod, int32_t dim, void** out);
```

The BlockSource of a dimension id, under the same rule as `native_dimension`.

- Call: `api->native_block_source(mod, dim, out)`
- Parameters:
    - mod : `PierModHandle`
    - dim : `int32_t`
    - out : `void**`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 214, counting from 0
- Callers in each binding:
    - Rust: [`native::block_source`](../rust/native.md#fn.block_source)
    - Go: [`Raw.NativeBlockSource`](../go/raw.md#Raw.NativeBlockSource)
    - Zig: [`native.blockSource`](../zig/native.md#native.blockSource)

### `native_hook_install` {#native_hook_install}

```c
int32_t (*native_hook_install)(PierModHandle mod, void* target, void* detour,
                               int32_t priority, void** out_original, uint64_t* out_id);
```

Installs a native detour on `target` through `ll::memory::hook`.

`detour` must have the exact signature and calling convention of `target`, which the host cannot check. `priority` is 0 highest to 400 lowest with 200 normal, the values of `ll::memory::HookPriority`; a value outside 0..400 refuses the call. On `PIER_NATIVE_OK` \*out\_original receives the address through which the detour calls the next detour or the engine, and \*out\_id the id `native_hook_remove` takes.

The host records which mod installed what. When a mod unloads, every detour it still holds is removed before its dll is unmapped. A call already running inside a detour on another thread is not waited for, so a mod unloaded at runtime removes its detours itself first or keeps them off other threads. One (target, detour) pair installs once; a second install of the same pair is refused.

- Call: `api->native_hook_install(mod, target, detour, priority, out_original, out_id)`
- Parameters:
    - mod : `PierModHandle`
    - target : `void*`
    - detour : `void*`
    - priority : `int32_t`
    - out_original : `void**`
    - out_id : `uint64_t*`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 215, counting from 0
- Callers in each binding:
    - Rust: [`native::hook_install`](../rust/native.md#fn.hook_install)
    - Go: [`Raw.NativeHookInstall`](../go/raw.md#Raw.NativeHookInstall)
    - Zig: [`native.hookInstall`](../zig/native.md#native.hookInstall)

### `native_hook_remove` {#native_hook_remove}

```c
int32_t (*native_hook_remove)(PierModHandle mod, uint64_t id);
```

Removes a detour this mod installed. `PIER_NATIVE_NOT_FOUND` for an id this mod does not hold, one already removed included. `PIER_NATIVE_FAILED` when the engine-side removal fails; the detour then stays recorded and is tried again at unload.

- Call: `api->native_hook_remove(mod, id)`
- Parameters:
    - mod : `PierModHandle`
    - id : `uint64_t`
- Return type: `int32_t`
- Section of abi.h: Native escape hatch (native\_\*); its section near the top of this file is the
- Position in the table: slot 216, counting from 0
- Callers in each binding:
    - Rust: [`native::hook_remove`](../rust/native.md#fn.hook_remove)
    - Go: [`Raw.NativeHookRemove`](../go/raw.md#Raw.NativeHookRemove)
    - Zig: [`native.hookRemove`](../zig/native.md#native.hookRemove)

## `PierNativeObject` {#PierNativeObject}

`native_object` kinds.

| Name | Value | Description |
|---|---|---|
| <span id="PIER_NATIVE_OBJ_MINECRAFT"></span>`PIER_NATIVE_OBJ_MINECRAFT` | `0` | `ll::service::getMinecraft` |
| <span id="PIER_NATIVE_OBJ_LEVEL"></span>`PIER_NATIVE_OBJ_LEVEL` | `1` | `ll::service::getLevel` |
| <span id="PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER"></span>`PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER` | `2` | `ll::service::getServerNetworkHandler` |
| <span id="PIER_NATIVE_OBJ_SERVER_INSTANCE"></span>`PIER_NATIVE_OBJ_SERVER_INSTANCE` | `3` | `ll::service::getServerInstance` |
| <span id="PIER_NATIVE_OBJ_COMMAND_REGISTRY"></span>`PIER_NATIVE_OBJ_COMMAND_REGISTRY` | `4` | `ll::service::getCommandRegistry` |
| <span id="PIER_NATIVE_OBJ_NETWORK_SYSTEM"></span>`PIER_NATIVE_OBJ_NETWORK_SYSTEM` | `5` | `ll::service::getNetworkSystem` |
| <span id="PIER_NATIVE_OBJ_DB_STORAGE"></span>`PIER_NATIVE_OBJ_DB_STORAGE` | `6` | `ll::service::getDBStorage` |
| <span id="PIER_NATIVE_OBJ_CLIENT_INSTANCE"></span>`PIER_NATIVE_OBJ_CLIENT_INSTANCE` | `7` | `ll::service::getClientInstance`, client hosts |
| <span id="PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL"></span>`PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL` | `8` | `ll::service::getMultiPlayerLevel`, client hosts: the level the client renders |

## `PIER_NATIVE_*` {#PIER_NATIVE_OK-group}

native\_\* return codes.

| Name | Value | Description |
|---|---|---|
| <span id="PIER_NATIVE_OK"></span>`PIER_NATIVE_OK` | `0` | done; the outputs are written |
| <span id="PIER_NATIVE_DISABLED"></span>`PIER_NATIVE_DISABLED` | `1` | config.json of the host does not set `native_detour` to true |
| <span id="PIER_NATIVE_NOT_FOUND"></span>`PIER_NATIVE_NOT_FOUND` | `2` | no such symbol, pattern match, export, object or actor now |
| <span id="PIER_NATIVE_REFUSED"></span>`PIER_NATIVE_REFUSED` | `3` | a null or malformed argument, an unknown kind, a foreign id |
| <span id="PIER_NATIVE_FAILED"></span>`PIER_NATIVE_FAILED` | `4` | the engine-side call failed: a detour that did not install |
