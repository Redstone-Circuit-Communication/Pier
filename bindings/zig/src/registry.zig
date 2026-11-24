//! registry.zig: the engine's registries of block types, item types, entity types and
//! commands, read once as lists. Each answer is a `types.Owned` list: its strings belong to
//! the arena inside, and `deinit` frees them.

const std = @import("std");
const core = @import("core.zig");
const types = @import("types.zig");
const internal = @import("internal.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// One block type, read from its default state.
pub const BlockType = struct {
    name: []const u8 = "",
    category: i32 = 0,
    solid: bool = false,
    vanilla: bool = false,
    container: bool = false,
    signal: bool = false,
    fence: bool = false,
    rail: bool = false,
    slab: bool = false,
    wall: bool = false,
    crop: bool = false,
    entity: bool = false,
    destroy: f64 = 0,
    resistance: f64 = 0,
    light: i32 = 0,
    description: []const u8 = "",
};

/// One item.
pub const ItemType = struct {
    name: []const u8 = "",
    rarity: i32 = 0,
    stack: i32 = 0,
    category: i32 = 0,
    hidden: bool = false,
};

/// One entity the level knows.
pub const EntityType = struct {
    name: []const u8 = "",
    spawn_egg: bool = false,
    summonable: bool = false,
    experimental: bool = false,
    type_id: i64 = 0,

    pub const json_keys = .{ .type_id = "type" };

    const mob_bit: i64 = 0x100;
    const monster_bit: i64 = 0x800;
    const animal_bit: i64 = 0x1000;
    const water_animal_bit: i64 = 0x2000;

    pub fn isMob(self: EntityType) bool {
        return self.type_id & mob_bit != 0;
    }

    pub fn isMonster(self: EntityType) bool {
        return self.type_id & monster_bit != 0;
    }

    /// A land animal: the animal bit without the water-animal one.
    pub fn isAnimal(self: EntityType) bool {
        return self.type_id & animal_bit != 0 and self.type_id & water_animal_bit == 0;
    }

    pub fn isWaterAnimal(self: EntityType) bool {
        return self.type_id & water_animal_bit != 0;
    }
};

/// One command the engine's registry holds.
pub const CommandType = struct {
    name: []const u8 = "",
    description: []const u8 = "",
    permission: i32 = 0,
    flags: i32 = 0,
    hidden: bool = false,
    aliases: []const []const u8 = &.{},
};

fn read(comptime T: type, allocator: Allocator, kind: i32) core.Error!types.Owned(T) {
    const f = core.slot("registry_list") orelse return error.NotProvided;
    const pieces = try core.sinkAll(allocator, f, .{kind});
    defer core.freeList(allocator, pieces);
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var out: std.ArrayList(T) = .empty;
    for (pieces) |piece| {
        const value = std.json.parseFromSliceLeaky(std.json.Value, a, piece, .{}) catch continue;
        if (value != .object) continue;
        const entry = try internal.fromJson(T, a, value.object);
        if (entry.name.len == 0) continue;
        try out.append(a, entry);
    }
    return .{ .arena = arena, .items = try out.toOwnedSlice(a) };
}

/// Every block type.
pub fn blocks(allocator: Allocator) core.Error!types.Owned(BlockType) {
    return read(BlockType, allocator, c.PIER_REGISTRY_BLOCKS);
}

/// Every item, each once under its own full name.
pub fn items(allocator: Allocator) core.Error!types.Owned(ItemType) {
    return read(ItemType, allocator, c.PIER_REGISTRY_ITEMS);
}

/// Every entity the level knows.
pub fn entities(allocator: Allocator) core.Error!types.Owned(EntityType) {
    return read(EntityType, allocator, c.PIER_REGISTRY_ENTITIES);
}

/// Every command the engine's registry holds, whichever mod registered it.
pub fn commands(allocator: Allocator) core.Error!types.Owned(CommandType) {
    return read(CommandType, allocator, c.PIER_REGISTRY_COMMANDS);
}
