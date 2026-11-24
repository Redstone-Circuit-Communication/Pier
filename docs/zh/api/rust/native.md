# levilamina::native · 原生逃生口

原生逃生口：引擎地址和原生 detour，用于调用没有其他模块封装的引擎功能。

模组拿地址做什么，宿主一概不检查。签名、调用约定、这个确切引擎版本上的对象布局、线程和生命周期都由调用方负责。因此获取地址是安全的，而对地址的每次使用在调用方都是 `unsafe`。宿主的 `config.json` 必须设置 `"native_detour": true`；在此之前，每次调用都会返回一个说明原因的 `Err`，[`enabled`](native.md#fn.enabled) 返回 false。

## 函数 {#functions}

### `native::enabled` {#fn.enabled}

```rust
pub fn enabled() -> bool
```

宿主是否响应原生调用，由它的 `config.json` 决定。

- 返回值类型：`bool`
- 对应槽位：[`native_enabled`](../cpp/native.md#native_enabled)、[`native_enabled`](../cpp/native.md#native_enabled)

### `native::resolve_symbol` {#fn.resolve_symbol}

```rust
pub fn resolve_symbol(symbol: &str) -> Result<*mut c_void>
```

按修饰后的符号名得到一个引擎函数的地址。

- 参数：
    - symbol : `&str`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_resolve_symbol`](../cpp/native.md#native_resolve_symbol)

### `native::resolve_signature` {#fn.resolve_signature}

```rust
pub fn resolve_signature(pattern: &str) -> Result<*mut c_void>
```

字节特征码（例如 `"48 8B ?? 08"`）在引擎可执行文件中的第一个匹配。

- 参数：
    - pattern : `&str`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_resolve_signature`](../cpp/native.md#native_resolve_signature)

### `native::module_export` {#fn.module_export}

```rust
pub fn module_export(module: &str, name: &str) -> Result<*mut c_void>
```

进程中已加载模块的一个导出；`module` 为空表示引擎可执行文件。LeviLamina 的 API 是 `LeviLamina.dll` 的导出。

- 参数：
    - module : `&str`
    - name : `&str`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_module_export`](../cpp/native.md#native_module_export)

### `native::object` {#fn.object}

```rust
pub fn object(kind: NativeObject) -> Result<*mut c_void>
```

一个引擎服务对象的地址。对象尚不存在时返回 `Err`。

- 参数：
    - kind : `NativeObject`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_object`](../cpp/native.md#native_object)

### `native::player` {#fn.player}

```rust
pub fn player(player: &crate::Player) -> Result<*mut c_void>
```

在线玩家对应的引擎 Player 对象。玩家在线期间有效。

- 参数：
    - player : `&crate::Player`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_player`](../cpp/native.md#native_player)

### `native::actor` {#fn.actor}

```rust
pub fn actor(entity: &crate::Entity) -> Result<*mut c_void>
```

已加载实体对应的引擎 Actor 对象。实体保持加载期间有效。

- 参数：
    - entity : `&crate::Entity`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_actor`](../cpp/native.md#native_actor)

### `native::dimension` {#fn.dimension}

```rust
pub fn dimension(dim: i32) -> Result<*mut c_void>
```

维度 id 对应的引擎 Dimension 对象，包括自定义维度。

- 参数：
    - dim : `i32`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_dimension`](../cpp/native.md#native_dimension)

### `native::block_source` {#fn.block_source}

```rust
pub fn block_source(dim: i32) -> Result<*mut c_void>
```

维度 id 对应的引擎 BlockSource。

- 参数：
    - dim : `i32`
- 返回值类型：`Result<*mut c_void>`
- 对应槽位：[`native_block_source`](../cpp/native.md#native_block_source)

### `native::hook_install` {#fn.hook_install}

```rust
pub unsafe fn hook_install(
    target: *mut c_void,
    detour: *mut c_void,
    priority: i32,
) -> Result<NativeHook>
```

通过 `ll::memory::hook` 在 `target` 上安装一个 detour，优先级取 `PRIORITY_*` 之一。

模组卸载时，宿主会在卸载它的 dll 之前移除它仍持有的 detour；已经在其他线程上进入 detour 的调用不会被等待。

# Safety

`detour` 必须是与 `target` 签名和调用约定完全一致的 `extern` 函数。它不能展开，并且只能通过 `original` 调用引擎。

- 参数：
    - target : `*mut c_void`
    - detour : `*mut c_void`
    - priority : `i32`
- 返回值类型：`Result<NativeHook>`
- 对应槽位：[`native_hook_install`](../cpp/native.md#native_hook_install)

### `native::hook_remove` {#fn.hook_remove}

```rust
pub fn hook_remove(hook: NativeHook) -> Result<()>
```

移除这个模组安装的一个 detour。

- 参数：
    - hook : `NativeHook`
- 返回值类型：`Result<()>`
- 对应槽位：[`native_hook_remove`](../cpp/native.md#native_hook_remove)

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

[`object`](native.md#fn.object) 能取得的引擎服务对象。

- 实现的 trait：`Debug`、`Clone`、`Copy`、`PartialEq`、`Eq`

## `NativeHook` {#NativeHook}

```rust
pub struct NativeHook {
    pub id: u64,
    pub original: *mut c_void,
}
```

一个已安装的 detour：[`hook_remove`](native.md#fn.hook_remove) 使用的 id，以及 detour 用来调用下一个 detour 或引擎的地址。

- 实现的 trait：`Debug`、`Clone`、`Copy`、`PartialEq`、`Eq`

## 常量 {#constants}

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="PRIORITY_HIGHEST"></span>`PRIORITY_HIGHEST` | `0` | `ll::memory::HookPriority::Highest`：最先运行。 |
| <span id="PRIORITY_HIGH"></span>`PRIORITY_HIGH` | `100` | `ll::memory::HookPriority::High`。 |
| <span id="PRIORITY_NORMAL"></span>`PRIORITY_NORMAL` | `200` | `ll::memory::HookPriority::Normal`。 |
| <span id="PRIORITY_LOW"></span>`PRIORITY_LOW` | `300` | `ll::memory::HookPriority::Low`。 |
| <span id="PRIORITY_LOWEST"></span>`PRIORITY_LOWEST` | `400` | `ll::memory::HookPriority::Lowest`：最后运行。 |
