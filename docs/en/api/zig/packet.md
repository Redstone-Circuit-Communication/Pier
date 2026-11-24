# Zig: Packets

## Functions {#functions}

### `packet.intercept` {#packet.intercept}

```zig
pub fn intercept(dirs: Directions, comptime handler: fn (*Packet) Verdict) core.Error!Hook
```

Registers an interceptor for every packet in the chosen directions, chunk data included, which costs one call per packet. `interceptIds` costs less when only some ids matter.

- Parameters:
    - dirs : `Directions`
    - handler : `comptime fn (*Packet) Verdict`
- Return type: `core.Error!Hook`
- Slots: [`packet_hook_register`](../cpp/packet.md#packet_hook_register)

### `packet.interceptIds` {#packet.interceptIds}

```zig
pub fn interceptIds(dirs: Directions, ids: []const i32, comptime handler: fn (*Packet) Verdict) core.Error!Hook
```

As `intercept`, but the handler runs only for the listed packet ids, 0 to 1023.

- Parameters:
    - dirs : `Directions`
    - ids : `[]const i32`
    - handler : `comptime fn (*Packet) Verdict`
- Return type: `core.Error!Hook`
- Slots: [`packet_hook_register_ids`](../cpp/packet.md#packet_hook_register_ids)

### `packet.onConnection` {#packet.onConnection}

```zig
pub fn onConnection(comptime handler: fn (conn_id: u64, address: []const u8, state: ConnectionState) void) core.Error!Hook
```

Registers an observer of connection opens and closes.

- Parameters:
    - handler : `comptime fn (conn_id: u64, address: []const u8, state: ConnectionState) void`
- Return type: `core.Error!Hook`
- Slots: [`packet_conn_hook_register`](../cpp/packet.md#packet_conn_hook_register)

### `packet.send` {#packet.send}

```zig
pub fn send(player: props.Player, packet_id: i32, body: []const u8) core.Error!void
```

Sends one packet to a player: the id and the body, without the header.

- Parameters:
    - player : `props.Player`
    - packet_id : `i32`
    - body : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`send_packet`](../cpp/packet.md#send_packet)

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

The packet a handler receives. Valid only during the call.

### `packet.Packet.direction` {#packet.Packet.direction}

```zig
pub fn direction(self: *const Packet) Direction
```

- Return type: `Direction`

### `packet.Packet.connId` {#packet.Packet.connId}

```zig
pub fn connId(self: *const Packet) u64
```

The id of this connection. Stable across packets and usable as the key of per-connection state.

- Return type: `u64`

### `packet.Packet.address` {#packet.Packet.address}

```zig
pub fn address(self: *const Packet) []const u8
```

The peer address as `ip:port`. For diagnostics; use `connId` as a key.

- Return type: `[]const u8`

### `packet.Packet.packetId` {#packet.Packet.packetId}

```zig
pub fn packetId(self: *const Packet) i32
```

- Return type: `i32`

### `packet.Packet.senderSubId` {#packet.Packet.senderSubId}

```zig
pub fn senderSubId(self: *const Packet) u8
```

- Return type: `u8`

### `packet.Packet.targetSubId` {#packet.Packet.targetSubId}

```zig
pub fn targetSubId(self: *const Packet) u8
```

- Return type: `u8`

### `packet.Packet.body` {#packet.Packet.body}

```zig
pub fn body(self: *const Packet) []const u8
```

The body, without the header, since the packet id and sub ids are already decoded.

- Return type: `[]const u8`

### `packet.Packet.setBody` {#packet.Packet.setBody}

```zig
pub fn setBody(self: *Packet, bytes: []const u8) void
```

Replaces the body. It may be called several times in one call and the last one wins.

- Parameters:
    - bytes : `[]const u8`
- Return type: `void`

### `packet.Packet.setPacketId` {#packet.Packet.setPacketId}

```zig
pub fn setPacketId(self: *Packet, id: i32) void
```

Rewrites the packet id, for remapping onto the numbering of another version.

- Parameters:
    - id : `i32`
- Return type: `void`

### `packet.Packet.setSenderSubId` {#packet.Packet.setSenderSubId}

```zig
pub fn setSenderSubId(self: *Packet, id: u8) void
```

- Parameters:
    - id : `u8`
- Return type: `void`

### `packet.Packet.setTargetSubId` {#packet.Packet.setTargetSubId}

```zig
pub fn setTargetSubId(self: *Packet, id: u8) void
```

- Parameters:
    - id : `u8`
- Return type: `void`

## `packet.Hook` {#packet.Hook}

```zig
pub const Hook = struct {
    handle: c.PierPacketHookHandle,
    connection: bool,
    // ...
};
```

A registered packet interceptor or connection observer.

### `packet.Hook.unregister` {#packet.Hook.unregister}

```zig
pub fn unregister(self: *Hook) core.Error!void
```

Deregisters it; calling it twice is harmless. Safe to call from inside the handler.

- Return type: `core.Error!void`
- Slots: [`packet_conn_hook_unregister`](../cpp/packet.md#packet_conn_hook_unregister), [`packet_hook_unregister`](../cpp/packet.md#packet_hook_unregister)

## `packet.Direction` {#packet.Direction}

```zig
pub const Direction = enum {
    /// Client to server.
    inbound,
    /// Server to client.
    outbound,
};
```

The direction of a packet.

## `packet.Directions` {#packet.Directions}

```zig
pub const Directions = enum {
    inbound,
    outbound,
    both,
};
```

Which directions to select at registration.

## `packet.Verdict` {#packet.Verdict}

```zig
pub const Verdict = enum {
    /// Forward it. A prior `setBody` or `setPacketId` takes effect.
    forward,
    /// Consume the packet entirely.
    drop,
};
```

What the handler does with this packet.

## `packet.ConnectionState` {#packet.ConnectionState}

```zig
pub const ConnectionState = enum {
    opened, closed
};
```

The two states of a connection. A close is the only reliable signal to clear what a mod keeps per connection: one that never completed the login handshake never becomes a player, and no player event covers it.
