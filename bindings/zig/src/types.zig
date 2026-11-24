//! types.zig: the values the modules of the binding share: positions, a box, the engine's own
//! numberings as enums, and the arena-backed list the host's structured answers come in.

const std = @import("std");

/// A block coordinate.
pub const Pos3 = struct { x: i32, y: i32, z: i32 };

/// An actor or exact coordinate.
pub const Vec3 = struct { x: f64, y: f64, z: f64 };

/// A closed box, with both corners included.
pub const Bounds = struct {
    min: Pos3,
    max: Pos3,

    /// The box spanned by two corners given in either order.
    pub fn init(a: Pos3, b: Pos3) Bounds {
        return .{
            .min = .{ .x = @min(a.x, b.x), .y = @min(a.y, b.y), .z = @min(a.z, b.z) },
            .max = .{ .x = @max(a.x, b.x), .y = @max(a.y, b.y), .z = @max(a.z, b.z) },
        };
    }

    /// The number of cells along each axis.
    pub fn size(self: Bounds) [3]u64 {
        return .{ span(self.min.x, self.max.x), span(self.min.y, self.max.y), span(self.min.z, self.max.z) };
    }

    /// The number of cells in the box.
    pub fn volume(self: Bounds) u64 {
        const s = self.size();
        return s[0] *| s[1] *| s[2];
    }

    /// Whether the cell is inside the box.
    pub fn contains(self: Bounds, p: Pos3) bool {
        return p.x >= self.min.x and p.x <= self.max.x and p.y >= self.min.y and p.y <= self.max.y and p.z >= self.min.z and p.z <= self.max.z;
    }

    fn span(lo: i32, hi: i32) u64 {
        const n = @as(i64, hi) - @as(i64, lo) + 1;
        return if (n <= 0) 0 else @intCast(n);
    }
};

/// A list or a record the host produced, whose memory belongs to one arena: `deinit` frees all
/// of it, every string included.
pub fn Owned(comptime T: type) type {
    return struct {
        arena: std.heap.ArenaAllocator,
        items: []const T,

        pub fn deinit(self: *@This()) void {
            self.arena.deinit();
        }
    };
}

/// The game mode. The values are part of the ABI, through `player_set_gamemode`.
///
/// Note that `spectator` is 6 and not 3: the values in between mean other things in the
/// engine, and guessing one from the order sets the player to a different mode.
pub const GameMode = enum(i32) {
    survival = 0,
    creative = 1,
    adventure = 2,
    spectator = 6,

    pub fn fromInt(v: i32) ?GameMode {
        return std.meta.intToEnum(GameMode, v) catch null;
    }
};

/// The player permission level, through `PIER_PACT_SET_PERMISSION_LEVEL` and `PIER_PPROP_PERMISSION_LEVEL`.
pub const PlayerPermission = enum(i32) {
    visitor = 0,
    member = 1,
    operator = 2,
    custom = 3,

    pub fn fromInt(v: i32) ?PlayerPermission {
        return std.meta.intToEnum(PlayerPermission, v) catch null;
    }
};

/// The weather. The three states of `set_weather`.
pub const Weather = enum(i32) {
    clear = 0,
    rain = 1,
    thunder = 2,

    pub fn fromInt(v: i32) ?Weather {
        return std.meta.intToEnum(Weather, v) catch null;
    }
};

/// The difficulty.
pub const Difficulty = enum(i32) {
    peaceful = 0,
    easy = 1,
    normal = 2,
    hard = 3,

    pub fn fromInt(v: i32) ?Difficulty {
        return std.meta.intToEnum(Difficulty, v) catch null;
    }
};

/// The `TextPacketType` of `player_send_message_typed`.
///
/// The host falls back to `raw` on an out-of-range value, so no fallback branch is needed here.
pub const MessageType = enum(i32) {
    raw = 0,
    chat = 1,
    translate = 2,
    popup = 3,
    jukebox_popup = 4,
    tip = 5,
    system_message = 6,
    whisper = 7,
    announcement = 8,
    text_object_whisper = 9,
    text_object = 10,
    text_object_announcement = 11,
};

/// The `SetTitlePacketPayload::TitleType` of `player_send_title`.
pub const TitleKind = enum(i32) {
    clear = 0,
    reset = 1,
    title = 2,
    subtitle = 3,
    actionbar = 4,
    times = 5,

    /// Whether this kind carries text.
    pub fn usesText(self: TitleKind) bool {
        return self == .title or self == .subtitle or self == .actionbar;
    }
};

/// The three title durations, in ticks.
///
/// All three are given together or not at all: the host refuses a half-specified combination
/// rather than guessing the rest for the caller.
pub const TitleTimes = struct {
    fade_in: i32 = 10,
    stay: i32 = 60,
    fade_out: i32 = 10,
};

/// Tells the engine which follow-up work a block write needs.
pub const BlockUpdate = struct {
    bits: i32,

    /// Notify the neighbors, meaning redstone, liquid flow and block updates.
    pub const neighbors: BlockUpdate = .{ .bits = 1 };
    /// Synchronize to the client.
    pub const network: BlockUpdate = .{ .bits = 2 };
    /// Both, equivalent to `/setblock`.
    pub const default: BlockUpdate = .{ .bits = 3 };
    /// Neither. For a bulk fill, resynchronizing afterwards.
    pub const none: BlockUpdate = .{ .bits = 0 };
};

/// An equipment slot. The numbering `actor_get_equipped_item` and `player_get_equipment` use.
pub const EquipSlot = enum(i32) {
    main_hand = 0,
    off_hand = 1,
    helmet = 2,
    chestplate = 3,
    leggings = 4,
    boots = 5,

    pub fn fromInt(v: i32) ?EquipSlot {
        return std.meta.intToEnum(EquipSlot, v) catch null;
    }
};

/// A player ability bit. The index of `PIER_PACT_SET_ABILITY` and `PIER_PACT_CAN_USE_ABILITY`.
///
/// The three carrying `speed` are floating-point abilities and the rest are boolean.
pub const Ability = enum(i32) {
    build = 0,
    mine = 1,
    doors_and_switches = 2,
    open_containers = 3,
    attack_players = 4,
    attack_mobs = 5,
    operator = 6,
    teleport = 7,
    invulnerable = 8,
    flying = 9,
    may_fly = 10,
    instabuild = 11,
    lightning = 12,
    fly_speed = 13,
    walk_speed = 14,
    muted = 15,
    world_builder = 16,
    no_clip = 17,
    privileged_builder = 18,
    vertical_fly_speed = 19,

    /// Whether the ability holds a number and not a flag.
    pub fn isFloat(self: Ability) bool {
        return self == .fly_speed or self == .walk_speed or self == .vertical_fly_speed;
    }
};

/// The result of one ray trace, from `actor_trace_ray` or `edit_trace_ray`.
pub const RayHit = union(enum) {
    entity: struct { id: i64, pos: Vec3 },
    block: struct { block: Pos3, facing: i32, name: []u8, pos: Vec3 },
    none,

    /// The cell of a block hit.
    pub fn blockPos(self: RayHit) ?Pos3 {
        return switch (self) {
            .block => |hit| hit.block,
            else => null,
        };
    }

    /// The id of an actor hit.
    pub fn entityId(self: RayHit) ?i64 {
        return switch (self) {
            .entity => |hit| hit.id,
            else => null,
        };
    }

    /// Frees the block name, which belongs to the allocator the trace was given.
    pub fn deinit(self: RayHit, allocator: std.mem.Allocator) void {
        switch (self) {
            .block => |hit| allocator.free(hit.name),
            else => {},
        }
    }
};

/// The local time, from `PIER_SYS_LOCAL_TIME`.
pub const LocalTime = struct {
    year: i32,
    month: i32,
    day: i32,
    hour: i32,
    minute: i32,
    second: i32,
    ms: i32,
};

/// One attribute of an entity as `Entity.attributeInfo` reads it.
pub const AttributeValue = struct {
    current: f64,
    min: f64,
    max: f64,
    default: f64,
};

/// The axis-aligned bounding box of an actor.
pub const Aabb = struct {
    min: Vec3,
    max: Vec3,
};

/// One status effect.
pub const Effect = struct {
    /// The effect's name, or its number written out when the host gives one.
    id: []const u8,
    ticks: i32,
    amplifier: i32,
    visible: bool,
};

/// One enchantment.
pub const Enchant = struct {
    id: []const u8,
    level: i32,
};

/// The network status of a player, from `PIER_PSTR_NETWORK_STATUS`. A value the host could not
/// measure is -1.
pub const NetworkStatus = struct {
    ping: i32,
    avg_ping: i32,
    max_ping: i32,
    packet_loss: i32,
};

/// One slot of a player's equipment.
pub const EquipmentEntry = struct {
    slot: i32,
    item_snbt: []const u8,
};

/// A player's feet position and the dimension it is in.
pub const PlayerPosition = struct {
    pos: Vec3,
    dim: i32,
};

/// The operations of `Item.transform`, the numbering of `item_transform`.
pub const ItemOp = enum(i32) {
    set_custom_name = 0,
    set_damage = 1,
    set_count = 2,
    set_lore = 3,
    set_unbreakable = 4,
    hurt_and_break = 5,
    set_repair_cost = 6,
    add_enchant = 7,
    remove_enchants = 8,
    clear_lore = 9,
    reset_name = 10,
    set_can_destroy = 11,
    set_can_place_on = 12,
};
