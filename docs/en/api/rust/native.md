# levilamina::native

The native escape hatch: engine addresses and native detours, for an engine call that no
other module wraps.

The host checks nothing a mod does with an address. The caller answers for signatures,
calling conventions, the object layouts of this exact engine build, threads and
lifetimes. Getting an address is therefore safe and every use of it is `unsafe` at the
caller. The host's `config.json` has to set `"native_detour": true`; until it does,
every call returns an `Err` saying so and [`enabled`](native.md#fn.enabled) returns false.

## Functions {#functions}

### `native::enabled` {#fn.enabled}

```rust
pub fn enabled() -> bool
```

Whether the host answers the native calls, which its `config.json` decides.

- Return type: `bool`
- Slots: [`native_enabled`](../cpp/native.md#native_enabled), [`native_enabled`](../cpp/native.md#native_enabled)

### `native::resolve_symbol` {#fn.resolve_symbol}

```rust
pub fn resolve_symbol(symbol: &str) -> Result<*mut c_void>
```

The address of an engine function by its decorated symbol name.

- Parameters:
    - symbol : `&str`
- Return type: `Result<*mut c_void>`
- Slots: [`native_resolve_symbol`](../cpp/native.md#native_resolve_symbol)

### `native::resolve_signature` {#fn.resolve_signature}

```rust
pub fn resolve_signature(pattern: &str) -> Result<*mut c_void>
```

The first match of a byte pattern such as `"48 8B ?? 08"` in the engine executable.

- Parameters:
    - pattern : `&str`
- Return type: `Result<*mut c_void>`
- Slots: [`native_resolve_signature`](../cpp/native.md#native_resolve_signature)

### `native::module_export` {#fn.module_export}

```rust
pub fn module_export(module: &str, name: &str) -> Result<*mut c_void>
```

An export of a module already loaded into the process; an empty `module` names the
engine executable. LeviLamina's API is an export of `LeviLamina.dll`.

- Parameters:
    - module : `&str`
    - name : `&str`
- Return type: `Result<*mut c_void>`
- Slots: [`native_module_export`](../cpp/native.md#native_module_export)

### `native::object` {#fn.object}

```rust
pub fn object(kind: NativeObject) -> Result<*mut c_void>
```

The address of one engine service object. An `Err` while it does not exist yet.

- Parameters:
    - kind : `NativeObject`
- Return type: `Result<*mut c_void>`
- Slots: [`native_object`](../cpp/native.md#native_object)

### `native::player` {#fn.player}

```rust
pub fn player(player: &crate::Player) -> Result<*mut c_void>
```

The engine's Player object of an online player. Valid while the player stays online.

- Parameters:
    - player : `&crate::Player`
- Return type: `Result<*mut c_void>`
- Slots: [`native_player`](../cpp/native.md#native_player)

### `native::actor` {#fn.actor}

```rust
pub fn actor(entity: &crate::Entity) -> Result<*mut c_void>
```

The engine's Actor object of a loaded actor. Valid while the actor stays loaded.

- Parameters:
    - entity : `&crate::Entity`
- Return type: `Result<*mut c_void>`
- Slots: [`native_actor`](../cpp/native.md#native_actor)

### `native::dimension` {#fn.dimension}

```rust
pub fn dimension(dim: i32) -> Result<*mut c_void>
```

The engine's Dimension object of a dimension id, custom dimensions included.

- Parameters:
    - dim : `i32`
- Return type: `Result<*mut c_void>`
- Slots: [`native_dimension`](../cpp/native.md#native_dimension)

### `native::block_source` {#fn.block_source}

```rust
pub fn block_source(dim: i32) -> Result<*mut c_void>
```

The engine's BlockSource of a dimension id.

- Parameters:
    - dim : `i32`
- Return type: `Result<*mut c_void>`
- Slots: [`native_block_source`](../cpp/native.md#native_block_source)

### `native::hook_install` {#fn.hook_install}

```rust
pub unsafe fn hook_install(
    target: *mut c_void,
    detour: *mut c_void,
    priority: i32,
) -> Result<NativeHook>
```

Installs a detour on `target` through `ll::memory::hook`, at a `PRIORITY_*` value.

The host removes a detour this mod still holds when the mod unloads, before the dll is
unmapped, and does not wait for a call already inside it on another thread.

**Safety**
`detour` must be an `extern` function with the exact signature and calling convention of
`target`. It must not unwind, and it reaches the engine through `original` only.

- Parameters:
    - target : `*mut c_void`
    - detour : `*mut c_void`
    - priority : `i32`
- Return type: `Result<NativeHook>`
- Slots: [`native_hook_install`](../cpp/native.md#native_hook_install)

### `native::hook_remove` {#fn.hook_remove}

```rust
pub fn hook_remove(hook: NativeHook) -> Result<()>
```

Removes a detour this mod installed.

- Parameters:
    - hook : `NativeHook`
- Return type: `Result<()>`
- Slots: [`native_hook_remove`](../cpp/native.md#native_hook_remove)

## `NativeObject` {#NativeObject}

```rust
pub enum NativeObject {
        Minecraft,
        Level,
        ServerNetworkHandler,
        ServerInstance,
        CommandRegistry,
        NetworkSystem,
        DbStorage,
        /// Client hosts only.
        ClientInstance,
        /// Client hosts only: the level the client renders.
        MultiPlayerLevel,
}
```

The engine service objects [`object`](native.md#fn.object) hands out.

- Implements: `Debug`, `Clone`, `Copy`, `PartialEq`, `Eq`

## `NativeHook` {#NativeHook}

```rust
pub struct NativeHook {
    pub id: u64,
    pub original: *mut c_void,
}
```

One installed detour: the id [`hook_remove`](native.md#fn.hook_remove) takes, and the address through which the
detour calls the next detour or the engine.

- Implements: `Debug`, `Clone`, `Copy`, `PartialEq`, `Eq`

## Constants {#constants}

| Name | Value | Description |
|---|---|---|
| <span id="PRIORITY_HIGHEST"></span>`PRIORITY_HIGHEST` | `0` | `ll::memory::HookPriority::Highest`: runs first. |
| <span id="PRIORITY_HIGH"></span>`PRIORITY_HIGH` | `100` | `ll::memory::HookPriority::High`. |
| <span id="PRIORITY_NORMAL"></span>`PRIORITY_NORMAL` | `200` | `ll::memory::HookPriority::Normal`. |
| <span id="PRIORITY_LOW"></span>`PRIORITY_LOW` | `300` | `ll::memory::HookPriority::Low`. |
| <span id="PRIORITY_LOWEST"></span>`PRIORITY_LOWEST` | `400` | `ll::memory::HookPriority::Lowest`: runs last. |
