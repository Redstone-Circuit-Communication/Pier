//! packet.zig: raw packet interception and injection, and observers of connections opening
//! and closing. A packet reaches the handler as its id, its two sub ids and its body; the
//! handler may rewrite them or drop the packet.

const std = @import("std");
const core = @import("core.zig");
const props = @import("props_gen.zig");

const c = core.c;

/// The direction of a packet.
pub const Direction = enum {
    /// Client to server.
    inbound,
    /// Server to client.
    outbound,
};

/// Which directions to select at registration.
pub const Directions = enum {
    inbound,
    outbound,
    both,

    fn mask(self: Directions) i32 {
        return switch (self) {
            .inbound => c.PIER_PKT_MASK_INBOUND,
            .outbound => c.PIER_PKT_MASK_OUTBOUND,
            .both => c.PIER_PKT_MASK_INBOUND | c.PIER_PKT_MASK_OUTBOUND,
        };
    }
};

/// What the handler does with this packet.
pub const Verdict = enum {
    /// Forward it. A prior `setBody` or `setPacketId` takes effect.
    forward,
    /// Consume the packet entirely.
    drop,
};

/// The two states of a connection. A close is the only reliable signal to clear what a mod
/// keeps per connection: one that never completed the login handshake never becomes a
/// player, and no player event covers it.
pub const ConnectionState = enum { opened, closed };

/// The packet a handler receives. Valid only during the call.
pub const Packet = struct {
    event: *const c.PierPacketEvent,
    edit: *c.PierPacketEdit,
    replace_ctx: ?*anyopaque,
    replace: c.PierBytesSink,
    replaced: bool = false,

    pub fn direction(self: *const Packet) Direction {
        // The ABI has only the two values. A third would mean a host newer than this binding,
        // and outbound is the safer guess: it is the more common, and rewriting an outbound
        // packet is less risky than rewriting an inbound one.
        return if (self.event.direction == c.PIER_PKT_INBOUND) .inbound else .outbound;
    }

    /// The id of this connection. Stable across packets and usable as the key of per-connection
    /// state.
    pub fn connId(self: *const Packet) u64 {
        return self.event.conn_id;
    }

    /// The peer address as `ip:port`. For diagnostics; use `connId` as a key.
    pub fn address(self: *const Packet) []const u8 {
        return core.view(self.event.address);
    }

    pub fn packetId(self: *const Packet) i32 {
        return self.event.packet_id;
    }

    pub fn senderSubId(self: *const Packet) u8 {
        return self.event.sender_sub_id;
    }

    pub fn targetSubId(self: *const Packet) u8 {
        return self.event.target_sub_id;
    }

    /// The body, without the header, since the packet id and sub ids are already decoded.
    pub fn body(self: *const Packet) []const u8 {
        if (self.event.body == null or self.event.body_len == 0) return "";
        return self.event.body[0..self.event.body_len];
    }

    /// Replaces the body. It may be called several times in one call and the last one wins.
    pub fn setBody(self: *Packet, bytes: []const u8) void {
        const sink = self.replace orelse return;
        sink(self.replace_ctx, bytes.ptr, bytes.len);
        self.replaced = true;
    }

    /// Rewrites the packet id, for remapping onto the numbering of another version.
    pub fn setPacketId(self: *Packet, id: i32) void {
        self.edit.packet_id = id;
    }

    pub fn setSenderSubId(self: *Packet, id: u8) void {
        self.edit.sender_sub_id = id;
    }

    pub fn setTargetSubId(self: *Packet, id: u8) void {
        self.edit.target_sub_id = id;
    }
};

/// A registered packet interceptor or connection observer.
pub const Hook = struct {
    handle: c.PierPacketHookHandle,
    connection: bool,

    /// Deregisters it; calling it twice is harmless. Safe to call from inside the handler.
    pub fn unregister(self: *Hook) core.Error!void {
        if (self.handle == null) return;
        const handle = self.handle;
        self.handle = null;
        if (self.connection) {
            const f = core.slot("packet_conn_hook_unregister") orelse return error.NotProvided;
            try core.expect(f(core.handle(), handle));
        } else {
            const f = core.slot("packet_hook_unregister") orelse return error.NotProvided;
            try core.expect(f(core.handle(), handle));
        }
    }
};

fn verdictOf(packet: *const Packet, verdict: Verdict) i32 {
    return switch (verdict) {
        .drop => c.PIER_PKT_DROP,
        .forward => if (packet.replaced) c.PIER_PKT_REPLACE else c.PIER_PKT_PASS,
    };
}

fn trampoline(comptime handler: fn (*Packet) Verdict) *const fn (?*anyopaque, [*c]const c.PierPacketEvent, [*c]c.PierPacketEdit, ?*anyopaque, c.PierBytesSink) callconv(.c) i32 {
    return &struct {
        fn call(_: ?*anyopaque, ev: [*c]const c.PierPacketEvent, edit: [*c]c.PierPacketEdit, replace_ctx: ?*anyopaque, replace: c.PierBytesSink) callconv(.c) i32 {
            var packet = Packet{ .event = ev, .edit = edit, .replace_ctx = replace_ctx, .replace = replace };
            const verdict = handler(&packet);
            return verdictOf(&packet, verdict);
        }
    }.call;
}

/// Registers an interceptor for every packet in the chosen directions, chunk data included,
/// which costs one call per packet. `interceptIds` costs less when only some ids matter.
pub fn intercept(dirs: Directions, comptime handler: fn (*Packet) Verdict) core.Error!Hook {
    const f = core.slot("packet_hook_register") orelse return error.NotProvided;
    const handle = f(core.handle(), dirs.mask(), trampoline(handler), null);
    if (handle == null) return error.Refused;
    return .{ .handle = handle, .connection = false };
}

/// As `intercept`, but the handler runs only for the listed packet ids, 0 to 1023.
pub fn interceptIds(dirs: Directions, ids: []const i32, comptime handler: fn (*Packet) Verdict) core.Error!Hook {
    const f = core.slot("packet_hook_register_ids") orelse return error.NotProvided;
    const handle = f(core.handle(), dirs.mask(), ids.ptr, ids.len, trampoline(handler), null);
    if (handle == null) return error.Refused;
    return .{ .handle = handle, .connection = false };
}

/// Registers an observer of connection opens and closes.
pub fn onConnection(comptime handler: fn (conn_id: u64, address: []const u8, state: ConnectionState) void) core.Error!Hook {
    const f = core.slot("packet_conn_hook_register") orelse return error.NotProvided;
    const Trampoline = struct {
        fn call(_: ?*anyopaque, conn_id: u64, address: c.PierStr, opened: bool) callconv(.c) void {
            handler(conn_id, core.view(address), if (opened) .opened else .closed);
        }
    };
    const handle = f(core.handle(), &Trampoline.call, null);
    if (handle == null) return error.Refused;
    return .{ .handle = handle, .connection = true };
}

/// Sends one packet to a player: the id and the body, without the header.
pub fn send(player: props.Player, packet_id: i32, body: []const u8) core.Error!void {
    const f = core.slot("send_packet") orelse return error.NotProvided;
    try core.expect(f(player.cSel(), packet_id, body.ptr, body.len));
}
