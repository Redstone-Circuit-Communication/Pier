# Zig: Native escape hatch

## Functions {#functions}

### `native.enabled` {#native.enabled}

```zig
pub fn enabled() bool
```

Whether the host answers the native calls, which its config.json decides.

- Return type: `bool`
- Slots: [`native_enabled`](../cpp/native.md#native_enabled)

### `native.resolveSymbol` {#native.resolveSymbol}

```zig
pub fn resolveSymbol(symbol: []const u8) NativeError!*anyopaque
```

The address of an engine function by its decorated symbol name.

- Parameters:
    - symbol : `[]const u8`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_resolve_symbol`](../cpp/native.md#native_resolve_symbol)

### `native.resolveSignature` {#native.resolveSignature}

```zig
pub fn resolveSignature(pattern: []const u8) NativeError!*anyopaque
```

The first match of a byte pattern such as "48 8B ?? 08" in the engine executable.

- Parameters:
    - pattern : `[]const u8`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_resolve_signature`](../cpp/native.md#native_resolve_signature)

### `native.moduleExport` {#native.moduleExport}

```zig
pub fn moduleExport(module: []const u8, name: []const u8) NativeError!*anyopaque
```

An export of a module already loaded into the process; an empty module names the engine executable. LeviLamina's API is an export of LeviLamina.dll.

- Parameters:
    - module : `[]const u8`
    - name : `[]const u8`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_module_export`](../cpp/native.md#native_module_export)

### `native.object` {#native.object}

```zig
pub fn object(kind: Object) NativeError!*anyopaque
```

The address of one engine service object.

- Parameters:
    - kind : `Object`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_object`](../cpp/native.md#native_object)

### `native.player` {#native.player}

```zig
pub fn player(sel: c.PierPlayerSel) NativeError!*anyopaque
```

The engine's Player object of an online player, valid while the player stays online.

- Parameters:
    - sel : `c.PierPlayerSel`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_player`](../cpp/native.md#native_player)

### `native.actor` {#native.actor}

```zig
pub fn actor(id: c.PierActorId) NativeError!*anyopaque
```

The engine's Actor object of a loaded actor.

- Parameters:
    - id : `c.PierActorId`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_actor`](../cpp/native.md#native_actor)

### `native.dimension` {#native.dimension}

```zig
pub fn dimension(dim: i32) NativeError!*anyopaque
```

The engine's Dimension object of a dimension id.

- Parameters:
    - dim : `i32`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_dimension`](../cpp/native.md#native_dimension)

### `native.blockSource` {#native.blockSource}

```zig
pub fn blockSource(dim: i32) NativeError!*anyopaque
```

The engine's BlockSource of a dimension id.

- Parameters:
    - dim : `i32`
- Return type: `NativeError!*anyopaque`
- Slots: [`native_block_source`](../cpp/native.md#native_block_source)

### `native.hookInstall` {#native.hookInstall}

```zig
pub fn hookInstall(target: *anyopaque, detour: *anyopaque, priority: i32) NativeError!Hook
```

Installs detour on target at a priority\_\* value. detour must be a callconv(.c) function with the exact signature of target, and it reaches the engine through original only. The host removes a detour this mod still holds when the mod unloads, and does not wait for a call already inside it on another thread.

- Parameters:
    - target : `*anyopaque`
    - detour : `*anyopaque`
    - priority : `i32`
- Return type: `NativeError!Hook`
- Slots: [`native_hook_install`](../cpp/native.md#native_hook_install)

### `native.hookRemove` {#native.hookRemove}

```zig
pub fn hookRemove(hook: Hook) NativeError!void
```

Removes a detour this mod installed.

- Parameters:
    - hook : `Hook`
- Return type: `NativeError!void`
- Slots: [`native_hook_remove`](../cpp/native.md#native_hook_remove)

## Declarations {#declarations}

### `native.NativeError` {#native.NativeError}

```zig
pub const NativeError = core.Error || error{ NativeDisabled, NativeNotFound, NativeRefused, NativeFailed };
```

core.Error plus the four answers of a native slot other than `PIER_NATIVE_OK`.

### `native.priority_highest` {#native.priority_highest}

```zig
pub const priority_highest: i32 = 0;
```

The priorities of `ll::memory::HookPriority`, for hookInstall.

### `native.priority_high` {#native.priority_high}

```zig
pub const priority_high: i32 = 100;
```

### `native.priority_normal` {#native.priority_normal}

```zig
pub const priority_normal: i32 = 200;
```

### `native.priority_low` {#native.priority_low}

```zig
pub const priority_low: i32 = 300;
```

### `native.priority_lowest` {#native.priority_lowest}

```zig
pub const priority_lowest: i32 = 400;
```

## `native.Object` {#native.Object}

```zig
pub const Object = enum(i32) {
    minecraft = 0,
    level = 1,
    server_network_handler = 2,
    server_instance = 3,
    command_registry = 4,
    network_system = 5,
    db_storage = 6,
    client_instance = 7,
    multiplayer_level = 8,
};
```

The engine service objects `object` hands out. The two client kinds are not found on a server host.

## `native.Hook` {#native.Hook}

```zig
pub const Hook = struct {
    id: u64,
    original: *anyopaque,
    // ...
};
```

One installed detour: the id hookRemove takes, and the address through which the detour calls the next detour or the engine.
