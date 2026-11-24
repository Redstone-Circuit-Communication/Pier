# Zig：数据包

## 函数 {#functions}

### `packet.intercept` {#packet.intercept}

```zig
pub fn intercept(dirs: Directions, comptime handler: fn (*Packet) Verdict) core.Error!Hook
```

为所选方向上的每一个数据包注册一个拦截器，区块数据也在内，每个包都会调用一次。只关心某些 id 时 `interceptIds` 更省。

- 参数：
    - dirs : `Directions`
    - handler : `comptime fn (*Packet) Verdict`
- 返回值类型：`core.Error!Hook`
- 对应槽位：[`packet_hook_register`](../cpp/packet.md#packet_hook_register)

### `packet.interceptIds` {#packet.interceptIds}

```zig
pub fn interceptIds(dirs: Directions, ids: []const i32, comptime handler: fn (*Packet) Verdict) core.Error!Hook
```

同 `intercept`，但处理函数只对列出的数据包 id 运行，范围 0 到 1023。

- 参数：
    - dirs : `Directions`
    - ids : `[]const i32`
    - handler : `comptime fn (*Packet) Verdict`
- 返回值类型：`core.Error!Hook`
- 对应槽位：[`packet_hook_register_ids`](../cpp/packet.md#packet_hook_register_ids)

### `packet.onConnection` {#packet.onConnection}

```zig
pub fn onConnection(comptime handler: fn (conn_id: u64, address: []const u8, state: ConnectionState) void) core.Error!Hook
```

注册一个观察连接打开和关闭的回调。

- 参数：
    - handler : `comptime fn (conn_id: u64, address: []const u8, state: ConnectionState) void`
- 返回值类型：`core.Error!Hook`
- 对应槽位：[`packet_conn_hook_register`](../cpp/packet.md#packet_conn_hook_register)

### `packet.send` {#packet.send}

```zig
pub fn send(player: props.Player, packet_id: i32, body: []const u8) core.Error!void
```

向一名玩家发送一个数据包：id 和包体，不含包头。

- 参数：
    - player : `props.Player`
    - packet_id : `i32`
    - body : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`send_packet`](../cpp/packet.md#send_packet)

## `packet.Packet` {#packet.Packet}

```zig
pub const Packet = struct {
    event: *const c.PierPacketEvent,
    edit: *c.PierPacketEdit,
    replace_ctx: ?*anyopaque,
    replace: c.PierBytesSink,
    replaced: bool = false,
    // ...
};
```

处理函数收到的数据包。只在调用期间有效。

### `packet.Packet.direction` {#packet.Packet.direction}

```zig
pub fn direction(self: *const Packet) Direction
```

- 返回值类型：`Direction`

### `packet.Packet.connId` {#packet.Packet.connId}

```zig
pub fn connId(self: *const Packet) u64
```

这个连接的 id。在多个数据包之间保持不变，可以用作按连接保存状态的键。

- 返回值类型：`u64`

### `packet.Packet.address` {#packet.Packet.address}

```zig
pub fn address(self: *const Packet) []const u8
```

对端地址，形如 `ip:port`。用于诊断；要当键用请用 `connId`。

- 返回值类型：`[]const u8`

### `packet.Packet.packetId` {#packet.Packet.packetId}

```zig
pub fn packetId(self: *const Packet) i32
```

- 返回值类型：`i32`

### `packet.Packet.senderSubId` {#packet.Packet.senderSubId}

```zig
pub fn senderSubId(self: *const Packet) u8
```

- 返回值类型：`u8`

### `packet.Packet.targetSubId` {#packet.Packet.targetSubId}

```zig
pub fn targetSubId(self: *const Packet) u8
```

- 返回值类型：`u8`

### `packet.Packet.body` {#packet.Packet.body}

```zig
pub fn body(self: *const Packet) []const u8
```

包体，不含包头，因为数据包 id 和子 id 已经解码出来了。

- 返回值类型：`[]const u8`

### `packet.Packet.setBody` {#packet.Packet.setBody}

```zig
pub fn setBody(self: *Packet, bytes: []const u8) void
```

替换包体。一次调用里可以调用多次，以最后一次为准。

- 参数：
    - bytes : `[]const u8`
- 返回值类型：`void`

### `packet.Packet.setPacketId` {#packet.Packet.setPacketId}

```zig
pub fn setPacketId(self: *Packet, id: i32) void
```

改写数据包 id，用于映射到另一个版本的编号上。

- 参数：
    - id : `i32`
- 返回值类型：`void`

### `packet.Packet.setSenderSubId` {#packet.Packet.setSenderSubId}

```zig
pub fn setSenderSubId(self: *Packet, id: u8) void
```

- 参数：
    - id : `u8`
- 返回值类型：`void`

### `packet.Packet.setTargetSubId` {#packet.Packet.setTargetSubId}

```zig
pub fn setTargetSubId(self: *Packet, id: u8) void
```

- 参数：
    - id : `u8`
- 返回值类型：`void`

## `packet.Hook` {#packet.Hook}

```zig
pub const Hook = struct {
    handle: c.PierPacketHookHandle,
    connection: bool,
    // ...
};
```

一个已注册的数据包拦截器或连接观察器。

### `packet.Hook.unregister` {#packet.Hook.unregister}

```zig
pub fn unregister(self: *Hook) core.Error!void
```

注销它；调用两次也没有害处。在处理函数里面调用也是安全的。

- 返回值类型：`core.Error!void`
- 对应槽位：[`packet_conn_hook_unregister`](../cpp/packet.md#packet_conn_hook_unregister)、[`packet_hook_unregister`](../cpp/packet.md#packet_hook_unregister)

## `packet.Direction` {#packet.Direction}

```zig
pub const Direction = enum {
    /// Client to server.
    inbound,
    /// Server to client.
    outbound,
};
```

数据包的方向。

## `packet.Directions` {#packet.Directions}

```zig
pub const Directions = enum {
    inbound,
    outbound,
    both,
};
```

注册时选择哪些方向。

## `packet.Verdict` {#packet.Verdict}

```zig
pub const Verdict = enum {
    /// Forward it. A prior `setBody` or `setPacketId` takes effect.
    forward,
    /// Consume the packet entirely.
    drop,
};
```

处理函数对这个数据包做什么。

## `packet.ConnectionState` {#packet.ConnectionState}

```zig
pub const ConnectionState = enum {
    opened, closed
};
```

一个连接的两种状态。关闭是清理 mod 按连接保存的状态时唯一可靠的信号：没有完成登录握手的连接不会变成玩家，任何玩家事件都覆盖不到它。
