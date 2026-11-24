# Zig：原生逃生口

## 函数 {#functions}

### `native.enabled` {#native.enabled}

```zig
pub fn enabled() bool
```

宿主是否响应原生调用，由它的 config.json 决定。

- 返回值类型：`bool`
- 对应槽位：[`native_enabled`](../cpp/native.md#native_enabled)

### `native.resolveSymbol` {#native.resolveSymbol}

```zig
pub fn resolveSymbol(symbol: []const u8) NativeError!*anyopaque
```

按修饰后的符号名得到一个引擎函数的地址。

- 参数：
    - symbol : `[]const u8`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_resolve_symbol`](../cpp/native.md#native_resolve_symbol)

### `native.resolveSignature` {#native.resolveSignature}

```zig
pub fn resolveSignature(pattern: []const u8) NativeError!*anyopaque
```

字节特征码（例如 "48 8B ?? 08"）在引擎可执行文件中的第一个匹配。

- 参数：
    - pattern : `[]const u8`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_resolve_signature`](../cpp/native.md#native_resolve_signature)

### `native.moduleExport` {#native.moduleExport}

```zig
pub fn moduleExport(module: []const u8, name: []const u8) NativeError!*anyopaque
```

进程中已加载模块的一个导出；`module` 为空表示引擎可执行文件。LeviLamina 的 API 是 LeviLamina.dll 的导出。

- 参数：
    - module : `[]const u8`
    - name : `[]const u8`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_module_export`](../cpp/native.md#native_module_export)

### `native.object` {#native.object}

```zig
pub fn object(kind: Object) NativeError!*anyopaque
```

一个引擎服务对象的地址。

- 参数：
    - kind : `Object`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_object`](../cpp/native.md#native_object)

### `native.player` {#native.player}

```zig
pub fn player(sel: c.PierPlayerSel) NativeError!*anyopaque
```

在线玩家对应的引擎 Player 对象，玩家在线期间有效。

- 参数：
    - sel : `c.PierPlayerSel`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_player`](../cpp/native.md#native_player)

### `native.actor` {#native.actor}

```zig
pub fn actor(id: c.PierActorId) NativeError!*anyopaque
```

已加载实体对应的引擎 Actor 对象。

- 参数：
    - id : `c.PierActorId`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_actor`](../cpp/native.md#native_actor)

### `native.dimension` {#native.dimension}

```zig
pub fn dimension(dim: i32) NativeError!*anyopaque
```

维度 id 对应的引擎 Dimension 对象。

- 参数：
    - dim : `i32`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_dimension`](../cpp/native.md#native_dimension)

### `native.blockSource` {#native.blockSource}

```zig
pub fn blockSource(dim: i32) NativeError!*anyopaque
```

维度 id 对应的引擎 BlockSource。

- 参数：
    - dim : `i32`
- 返回值类型：`NativeError!*anyopaque`
- 对应槽位：[`native_block_source`](../cpp/native.md#native_block_source)

### `native.hookInstall` {#native.hookInstall}

```zig
pub fn hookInstall(target: *anyopaque, detour: *anyopaque, priority: i32) NativeError!Hook
```

在 `target` 上以某个 priority_* 值安装 detour。detour 必须是与 target 签名完全一致的 callconv(.c) 函数，并且只能通过 original 调用引擎。mod 卸载时宿主会移除它仍持有的 detour，已经在其他线程上进入 detour 的调用不会被等待。

- 参数：
    - target : `*anyopaque`
    - detour : `*anyopaque`
    - priority : `i32`
- 返回值类型：`NativeError!Hook`
- 对应槽位：[`native_hook_install`](../cpp/native.md#native_hook_install)

### `native.hookRemove` {#native.hookRemove}

```zig
pub fn hookRemove(hook: Hook) NativeError!void
```

移除这个模组安装的一个 detour。

- 参数：
    - hook : `Hook`
- 返回值类型：`NativeError!void`
- 对应槽位：[`native_hook_remove`](../cpp/native.md#native_hook_remove)

## 声明 {#declarations}

### `native.NativeError` {#native.NativeError}

```zig
pub const NativeError = core.Error || error{ NativeDisabled, NativeNotFound, NativeRefused, NativeFailed };
```

core.Error 再加上原生槽位除 PIER_NATIVE_OK 之外的四种回答。

### `native.priority_highest` {#native.priority_highest}

```zig
pub const priority_highest: i32 = 0;
```

ll::memory::HookPriority 的各个优先级，供 hookInstall 使用。

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

`object` 能取得的引擎服务对象。两个仅客户端的种类在服务端宿主上找不到。

## `native.Hook` {#native.Hook}

```zig
pub const Hook = struct {
    id: u64,
    original: *anyopaque,
    // ...
};
```

一个已安装的 detour：hookRemove 使用的 id，以及 detour 用来调用下一个 detour 或引擎的地址。
