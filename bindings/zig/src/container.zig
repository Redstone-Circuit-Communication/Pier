//! container.zig: the items of a container, either one a player carries or one placed in the
//! world. An item crosses this boundary as SNBT, the form `levilamina.Item` wraps.

const std = @import("std");
const core = @import("core.zig");
const props = @import("props_gen.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The kind of a container. The values align with `PierContainerRef::which`.
pub const Kind = enum(i32) {
    inventory = 0,
    ender_chest = 1,
    armor = 2,
    off_hand = 3,
    block = 4,

    /// A block container has no single owner and therefore cannot be resynchronized.
    pub fn isPlayerOwned(self: Kind) bool {
        return self != .block;
    }
};

/// A reference to one container.
pub const Container = struct {
    kind: Kind,
    owner: props.Player,
    dim: i32 = 0,
    x: i32 = 0,
    y: i32 = 0,
    z: i32 = 0,

    /// One container on a player.
    pub fn ofPlayer(owner: props.Player, kind: Kind) Container {
        return .{ .kind = kind, .owner = owner };
    }

    /// A block container at a coordinate in the world.
    pub fn block(dim: i32, x: i32, y: i32, z: i32) Container {
        return .{ .kind = .block, .owner = props.Player.byName(""), .dim = dim, .x = x, .y = y, .z = z };
    }

    fn raw(self: Container) c.PierContainerRef {
        return .{ .which = @intFromEnum(self.kind), .player = self.owner.cSel(), .dim = self.dim, .x = self.x, .y = self.y, .z = self.z };
    }

    /// The slot count.
    pub fn size(self: Container) core.Error!i32 {
        const f = core.slot("container_size") orelse return error.NotProvided;
        var out: i32 = 0;
        if (!f(self.raw(), &out)) return error.NoAnswer;
        return out;
    }

    /// What is in one slot, as item SNBT owned by the caller. An empty slot gives the SNBT of
    /// the air item and is not an error.
    pub fn item(self: Container, allocator: Allocator, slot: i32) core.Error![]u8 {
        const f = core.slot("container_get_item") orelse return error.NotProvided;
        return core.sinkOne(allocator, f, .{ self.raw(), slot });
    }

    /// Every slot as item SNBT in slot order, owned by the caller; `core.freeList` releases them.
    pub fn items(self: Container, allocator: Allocator) core.Error![][]u8 {
        const f = core.slot("container_get_items") orelse return error.NotProvided;
        const Sink = struct {
            fn call(ctx: ?*anyopaque, _: i32, snbt: c.PierStr) callconv(.c) void {
                core.Collector.sink(ctx, snbt);
            }
        };
        var col = core.Collector.init(allocator);
        defer col.deinit();
        if (!f(self.raw(), &col, &Sink.call)) return error.NoAnswer;
        return col.takeAll();
    }

    /// Writes one slot. Call `refresh` afterwards for a player's container.
    pub fn setItem(self: Container, slot: i32, item_snbt: []const u8) core.Error!void {
        const f = core.slot("container_set_item") orelse return error.NotProvided;
        try core.expect(f(self.raw(), slot, core.str(item_snbt)));
    }

    /// Puts one in and lets the engine pick the slot.
    pub fn addItem(self: Container, item_snbt: []const u8) core.Error!void {
        const f = core.slot("container_add_item") orelse return error.NotProvided;
        try core.expect(f(self.raw(), core.str(item_snbt)));
    }

    /// Takes `count` items out of one slot.
    pub fn removeItem(self: Container, slot: i32, count: i32) core.Error!void {
        const f = core.slot("container_remove_item") orelse return error.NotProvided;
        try core.expect(f(self.raw(), slot, count));
    }

    pub fn clear(self: Container) core.Error!void {
        const f = core.slot("container_clear") orelse return error.NotProvided;
        try core.expect(f(self.raw()));
    }

    /// Resends the whole container to its owner. A block container has no owner to resend to
    /// and is Refused.
    pub fn refresh(self: Container) core.Error!void {
        const f = core.slot("container_refresh") orelse return error.NotProvided;
        if (!self.kind.isPlayerOwned()) return error.Refused;
        try core.expect(f(self.raw()));
    }
};
