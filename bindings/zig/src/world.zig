//! world.zig: the level and its dimensions: time, weather, difficulty, game rules, blocks,
//! regions, mobs, particles and what the host reads about a dimension.
//!
//! A function that returns text or a list takes the allocator that owns the result, and a
//! structured answer comes as `types.Owned` or as a struct with its own `deinit`.

const std = @import("std");
const core = @import("core.zig");
const types = @import("types.zig");
const nbt = @import("nbt.zig");
const internal = @import("internal.zig");
const props = @import("props_gen.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

pub const Pos3 = types.Pos3;
pub const Bounds = types.Bounds;
pub const BlockUpdate = types.BlockUpdate;

/// The world time in ticks.
pub fn time() core.Error!i64 {
    const f = core.slot("get_time") orelse return error.NotProvided;
    var out: i64 = 0;
    if (!f(&out)) return error.NoAnswer;
    return out;
}

/// Sets the world time natively.
pub fn setTime(t: i64) core.Error!void {
    const f = core.slot("set_time") orelse return error.NotProvided;
    try core.expect(f(t));
}

pub fn setWeather(weather: types.Weather) core.Error!void {
    const f = core.slot("set_weather") orelse return error.NotProvided;
    try core.expect(f(@intFromEnum(weather)));
}

/// Sets the level and the remaining duration, in ticks, of rain and of lightning.
pub fn updateWeather(rain_level: f32, rain_ticks: i32, lightning_level: f32, lightning_ticks: i32) core.Error!void {
    const f = core.slot("level_update_weather") orelse return error.NotProvided;
    try core.expect(f(rain_level, rain_ticks, lightning_level, lightning_ticks));
}

pub fn difficulty() core.Error!types.Difficulty {
    const f = core.slot("get_difficulty") orelse return error.NotProvided;
    var out: i32 = 0;
    if (!f(&out)) return error.NoAnswer;
    return types.Difficulty.fromInt(out) orelse error.NoAnswer;
}

pub fn setDifficulty(d: types.Difficulty) core.Error!void {
    const f = core.slot("set_difficulty") orelse return error.NotProvided;
    try core.expect(f(@intFromEnum(d)));
}

pub fn seed() core.Error!i64 {
    const f = core.slot("get_seed") orelse return error.NotProvided;
    var out: i64 = 0;
    if (!f(&out)) return error.NoAnswer;
    return out;
}

/// The value of one game rule.
pub const GameRuleValue = union(enum) {
    boolean: bool,
    int: i64,
    float: f64,
};

/// Reads one game rule. An unrecognized rule name is NoAnswer and not some default value.
pub fn gameRule(allocator: Allocator, name: []const u8) core.Error!GameRuleValue {
    const f = core.slot("game_rule_get") orelse return error.NotProvided;
    const text = try core.sinkOne(allocator, f, .{core.str(name)});
    defer allocator.free(text);
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const v = try internal.parse(arena.allocator(), text);
    const kind = v.getString("type") orelse return error.NoAnswer;
    if (std.mem.eql(u8, kind, "bool")) return .{ .boolean = v.getBool("value") orelse return error.NoAnswer };
    if (std.mem.eql(u8, kind, "int")) return .{ .int = v.getInt("value") orelse return error.NoAnswer };
    if (std.mem.eql(u8, kind, "float")) return .{ .float = v.getFloat("value") orelse return error.NoAnswer };
    return error.NoAnswer;
}

/// Writes one game rule from its text form, such as "true" or "300".
pub fn setGameRule(name: []const u8, value: []const u8) core.Error!void {
    const f = core.slot("game_rule_set") orelse return error.NotProvided;
    try core.expect(f(core.str(name), core.str(value)));
}

pub fn defaultSpawn() core.Error!Pos3 {
    const f = core.slot("level_get_default_spawn") orelse return error.NotProvided;
    var x: i32 = 0;
    var y: i32 = 0;
    var z: i32 = 0;
    if (!f(&x, &y, &z)) return error.NoAnswer;
    return .{ .x = x, .y = y, .z = z };
}

pub fn setDefaultSpawn(x: i32, y: i32, z: i32) core.Error!void {
    const f = core.slot("level_set_default_spawn") orelse return error.NotProvided;
    try core.expect(f(x, y, z));
}

/// Saves to disk immediately.
pub fn save() core.Error!void {
    const f = core.slot("level_save") orelse return error.NotProvided;
    try core.expect(f());
}

/// The sleep status of the players.
pub const SleepStatus = struct {
    sleeping: bool,
    total_players: i32,
    active_sleeping: i32,
};

pub fn sleepStatus(allocator: Allocator) core.Error!SleepStatus {
    const f = core.slot("level_get_sleep_status") orelse return error.NotProvided;
    const text = try core.sinkOne(allocator, f, .{});
    defer allocator.free(text);
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const v = try internal.parse(arena.allocator(), text);
    return .{
        .sleeping = v.getBool("sleeping") orelse return error.NoAnswer,
        .total_players = std.math.cast(i32, v.getInt("total_players") orelse return error.NoAnswer) orelse return error.NoAnswer,
        .active_sleeping = std.math.cast(i32, v.getInt("active_sleeping") orelse return error.NoAnswer) orelse return error.NoAnswer,
    };
}

/// The biome name at one cell, owned by the caller.
pub fn biome(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error![]u8 {
    const f = core.slot("level_get_biome") orelse return error.NotProvided;
    return core.sinkOne(allocator, f, .{ dim, x, y, z });
}

/// Sets the biome of a region, column by column, and returns how many columns were set.
///
/// The corners are given in either order and no y is taken, since Bedrock stores biomes per
/// column. A return of 0 means none were set.
pub fn setBiome(dim: i32, from_x: i32, from_z: i32, to_x: i32, to_z: i32, biome_name: []const u8) core.Error!i32 {
    const f = core.slot("level_set_biome") orelse return error.NotProvided;
    return f(dim, @min(from_x, to_x), @min(from_z, to_z), @max(from_x, to_x), @max(from_z, to_z), core.str(biome_name));
}

/// One village.
pub const Village = struct {
    uuid: []const u8,
    center: Pos3,
    bounds: Bounds,
    poi_count: i32,
};

/// The villages in one dimension.
pub fn villages(allocator: Allocator, dim: i32) core.Error!types.Owned(Village) {
    const f = core.slot("villages") orelse return error.NotProvided;
    const pieces = try core.sinkAll(allocator, f, .{dim});
    defer core.freeList(allocator, pieces);
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var list: std.ArrayList(Village) = .empty;
    for (pieces) |piece| {
        const v = internal.parse(a, piece) catch continue;
        const center = internal.posOf(v.get("center") orelse continue) orelse continue;
        const bounds = internal.boundsAt(v, "bounds") orelse continue;
        try list.append(a, .{
            .uuid = try a.dupe(u8, v.getString("uuid") orelse ""),
            .center = center,
            .bounds = bounds,
            .poi_count = std.math.cast(i32, v.getInt("poi_count") orelse 0) orelse 0,
        });
    }
    return .{ .arena = arena, .items = try list.toOwnedSlice(a) };
}

/// One hardcoded generation area: a stronghold, a witch hut, an ocean monument or a similar structure.
pub const Structure = struct {
    kind: []const u8,
    bounds: Bounds,
};

/// The hardcoded generation areas in the loaded chunks within a radius.
pub fn structuresNear(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32, radius: i32) core.Error!types.Owned(Structure) {
    const f = core.slot("structures_near") orelse return error.NotProvided;
    const pieces = try core.sinkAll(allocator, f, .{ dim, x, y, z, radius });
    defer core.freeList(allocator, pieces);
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var list: std.ArrayList(Structure) = .empty;
    for (pieces) |piece| {
        const v = internal.parse(a, piece) catch continue;
        const bounds = internal.boundsAt(v, "bounds") orelse continue;
        try list.append(a, .{ .kind = try a.dupe(u8, v.getString("type") orelse ""), .bounds = bounds });
    }
    return .{ .arena = arena, .items = try list.toOwnedSlice(a) };
}

/// Whether every chunk covered by the region is in memory.
pub fn chunksLoaded(dim: i32, min_x: i32, min_z: i32, max_x: i32, max_z: i32) core.Error!bool {
    const f = core.slot("level_chunks_loaded") orelse return error.NotProvided;
    return switch (f(dim, min_x, min_z, max_x, max_z)) {
        1 => true,
        0 => false,
        else => error.NoAnswer,
    };
}

/// Deletes every save key of a chunk, so the engine regenerates it from the generator on its
/// next load. Only an unloaded chunk can be restored this way. Returns how many keys went.
pub fn deleteChunkKeys(dim: i32, chunk_x: i32, chunk_z: i32) core.Error!i32 {
    const f = core.slot("level_delete_chunk_keys") orelse return error.NotProvided;
    const n = f(dim, chunk_x, chunk_z);
    if (n < 0) return error.NoAnswer;
    return n;
}

/// Lists every save key of a chunk, each owned by the caller with the slice holding them.
pub fn chunkKeys(allocator: Allocator, dim: i32, chunk_x: i32, chunk_z: i32) core.Error![][]u8 {
    const f = core.slot("level_chunk_keys") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    if (f(dim, chunk_x, chunk_z, &col, &core.Collector.sink) < 0) return error.NoAnswer;
    return col.takeAll();
}

/// Deletes one save key byte for byte. The content is not interpreted.
pub fn deleteKey(key: []const u8) core.Error!void {
    const f = core.slot("level_delete_key") orelse return error.NotProvided;
    try core.expect(f(core.str(key)));
}

/// Computes a path for an actor to a target cell, as the host's SNBT `{nodes, reached}`. Every
/// current host answers NotProvided: pathfinding is not implemented.
pub fn findPath(allocator: Allocator, who: props.Entity, x: i32, y: i32, z: i32) core.Error![]u8 {
    const f = core.slot("level_find_path") orelse return error.NotProvided;
    return core.sinkOne(allocator, f, .{ who.actor_id, x, y, z });
}

/// One block as the host reports it.
pub const BlockInfo = struct {
    x: i32,
    y: i32,
    z: i32,
    name: []const u8,
    snbt: []const u8,
};

const BlockHolder = struct {
    arena: Allocator,
    found: ?BlockInfo = null,
    failed: bool = false,

    fn sink(ctx: ?*anyopaque, x: i32, y: i32, z: i32, name: c.PierStr, snbt: c.PierStr) callconv(.c) void {
        const self: *BlockHolder = @ptrCast(@alignCast(ctx orelse return));
        const n = self.arena.dupe(u8, core.view(name)) catch {
            self.failed = true;
            return;
        };
        const s = self.arena.dupe(u8, core.view(snbt)) catch {
            self.failed = true;
            return;
        };
        self.found = .{ .x = x, .y = y, .z = z, .name = n, .snbt = s };
    }
};

/// Reads one block. The name and the SNBT belong to the arena inside the result.
pub fn getBlock(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error!types.Owned(BlockInfo) {
    const f = core.slot("get_block") orelse return error.NotProvided;
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var holder = BlockHolder{ .arena = a };
    if (!f(dim, x, y, z, &holder, &BlockHolder.sink)) return error.NoAnswer;
    if (holder.failed) return error.OutOfMemory;
    const info = holder.found orelse return error.NoAnswer;
    const items = try a.alloc(BlockInfo, 1);
    items[0] = info;
    return .{ .arena = arena, .items = items };
}

/// Places a block natively with the default update flags. `spec` is a bare name such as
/// "minecraft:stone", or full SNBT. An unknown name fails instead of placing a placeholder.
pub fn setBlock(dim: i32, x: i32, y: i32, z: i32, spec: []const u8) core.Error!void {
    const f = core.slot("set_block") orelse return error.NotProvided;
    try core.expect(f(dim, x, y, z, core.str(spec)));
}

/// Reads the liquid layer of a cell as a block name; an empty layer gives air.
pub fn getExtraBlock(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error![]u8 {
    const f = core.slot("get_extra_block") orelse return error.NotProvided;
    return core.sinkOne(allocator, f, .{ dim, x, y, z });
}

/// Writes the liquid layer of a cell; write "minecraft:air" to clear it.
pub fn setExtraBlock(dim: i32, x: i32, y: i32, z: i32, spec: []const u8, update: BlockUpdate) core.Error!void {
    const f = core.slot("set_extra_block") orelse return error.NotProvided;
    try core.expect(f(dim, x, y, z, core.str(spec), update.bits));
}

/// Writes a block from serialized NBT, the shape `getBlock` produces.
pub fn setBlockNbt(dim: i32, x: i32, y: i32, z: i32, snbt: []const u8, update: BlockUpdate) core.Error!void {
    const f = core.slot("edit_set_block_nbt") orelse return error.NotProvided;
    try core.expect(f(dim, x, y, z, core.str(snbt), update.bits));
}

/// Writes a block from a name and optional partial states. An empty `states_snbt` means every
/// state at its default.
pub fn setBlockStates(dim: i32, x: i32, y: i32, z: i32, name: []const u8, states_snbt: []const u8, update: BlockUpdate) core.Error!void {
    const f = core.slot("edit_set_block_states") orelse return error.NotProvided;
    try core.expect(f(dim, x, y, z, core.str(name), core.str(states_snbt), update.bits));
}

/// Writes a block entity's NBT back. The cell must already hold the matching block.
pub fn setBlockEntity(dim: i32, x: i32, y: i32, z: i32, snbt: []const u8) core.Error!void {
    const f = core.slot("edit_set_block_entity") orelse return error.NotProvided;
    try core.expect(f(dim, x, y, z, core.str(snbt)));
}

/// One actor that fell inside the region during a scan.
pub const EntityInfo = struct {
    x: i32,
    y: i32,
    z: i32,
    type_name: []const u8,
    snbt: []const u8,
};

/// The result of one scan: every block of the region and every actor inside it.
pub const Scan = struct {
    arena: std.heap.ArenaAllocator,
    blocks: []const BlockInfo,
    entities: []const EntityInfo,

    pub fn deinit(self: *Scan) void {
        self.arena.deinit();
    }

    /// Cells that are not air, by block name.
    pub fn nonAirCount(self: *const Scan) usize {
        var n: usize = 0;
        for (self.blocks) |b| {
            if (!std.mem.eql(u8, b.name, "minecraft:air")) n += 1;
        }
        return n;
    }
};

const ScanState = struct {
    arena: Allocator,
    blocks: std.ArrayList(BlockInfo) = .empty,
    entities: std.ArrayList(EntityInfo) = .empty,
    failed: bool = false,

    fn block(ctx: ?*anyopaque, x: i32, y: i32, z: i32, name: c.PierStr, snbt: c.PierStr) callconv(.c) void {
        const self: *ScanState = @ptrCast(@alignCast(ctx orelse return));
        if (self.failed) return;
        const n = self.arena.dupe(u8, core.view(name)) catch return self.fail();
        const s = self.arena.dupe(u8, core.view(snbt)) catch return self.fail();
        self.blocks.append(self.arena, .{ .x = x, .y = y, .z = z, .name = n, .snbt = s }) catch self.fail();
    }

    fn entity(ctx: ?*anyopaque, x: i32, y: i32, z: i32, kind: c.PierStr, snbt: c.PierStr) callconv(.c) void {
        const self: *ScanState = @ptrCast(@alignCast(ctx orelse return));
        if (self.failed) return;
        const k = self.arena.dupe(u8, core.view(kind)) catch return self.fail();
        const s = self.arena.dupe(u8, core.view(snbt)) catch return self.fail();
        self.entities.append(self.arena, .{ .x = x, .y = y, .z = z, .type_name = k, .snbt = s }) catch self.fail();
    }

    fn fail(self: *ScanState) void {
        self.failed = true;
    }
};

/// Scans a region and collects every block and actor into memory.
pub fn scan(allocator: Allocator, dim: i32, bounds: Bounds) core.Error!Scan {
    const f = core.slot("scan_region") orelse return error.NotProvided;
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var state = ScanState{ .arena = a };
    const ok = f(dim, bounds.min.x, bounds.min.y, bounds.min.z, bounds.max.x, bounds.max.y, bounds.max.z, &state, &ScanState.block, &ScanState.entity);
    if (state.failed) return error.OutOfMemory;
    if (!ok) return error.Refused;
    return .{ .arena = arena, .blocks = try state.blocks.toOwnedSlice(a), .entities = try state.entities.toOwnedSlice(a) };
}

/// One distinct block state met by `scanIndexed`.
pub const PaletteEntry = struct {
    name: []const u8,
    snbt: []const u8,
};

/// One cell of `scanIndexed` or `setBlocks`: a position and an index into a palette.
pub const BlockCell = extern struct {
    x: i32,
    y: i32,
    z: i32,
    index: u32,
};

comptime {
    std.debug.assert(@sizeOf(BlockCell) == @sizeOf(c.PierBlockCell));
}

/// The result of one `scanIndexed`: every distinct block state once, and one cell for each
/// position holding an index into the palette.
pub const IndexedScan = struct {
    arena: std.heap.ArenaAllocator,
    palette: []const PaletteEntry,
    cells: []const BlockCell,

    pub fn deinit(self: *IndexedScan) void {
        self.arena.deinit();
    }

    /// The palette entry of a cell, or null for an index the palette does not have.
    pub fn blockOf(self: *const IndexedScan, cell: BlockCell) ?PaletteEntry {
        if (cell.index >= self.palette.len) return null;
        return self.palette[cell.index];
    }
};

const IndexState = struct {
    arena: Allocator,
    palette: std.ArrayList(PaletteEntry) = .empty,
    cells: std.ArrayList(BlockCell) = .empty,
    failed: bool = false,

    fn entry(ctx: ?*anyopaque, index: u32, name: c.PierStr, snbt: c.PierStr) callconv(.c) void {
        const self: *IndexState = @ptrCast(@alignCast(ctx orelse return));
        if (self.failed) return;
        // The host sinks entries in index order, and a cell names one by its position here.
        if (index != self.palette.items.len) return self.fail();
        const n = self.arena.dupe(u8, core.view(name)) catch return self.fail();
        const s = self.arena.dupe(u8, core.view(snbt)) catch return self.fail();
        self.palette.append(self.arena, .{ .name = n, .snbt = s }) catch self.fail();
    }

    fn cell(ctx: ?*anyopaque, x: i32, y: i32, z: i32, index: u32) callconv(.c) void {
        const self: *IndexState = @ptrCast(@alignCast(ctx orelse return));
        if (self.failed) return;
        self.cells.append(self.arena, .{ .x = x, .y = y, .z = z, .index = index }) catch self.fail();
    }

    fn fail(self: *IndexState) void {
        self.failed = true;
    }
};

/// Scans the blocks of a region into a palette plus cells. Each distinct block state is
/// serialized once, so a region of a million stone cells costs one SNBT and not a million.
pub fn scanIndexed(allocator: Allocator, dim: i32, bounds: Bounds) core.Error!IndexedScan {
    const f = core.slot("scan_region_indexed") orelse return error.NotProvided;
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var state = IndexState{ .arena = a };
    const ok = f(dim, bounds.min.x, bounds.min.y, bounds.min.z, bounds.max.x, bounds.max.y, bounds.max.z, &state, &IndexState.entry, &IndexState.cell);
    if (state.failed) return error.OutOfMemory;
    if (!ok) return error.Refused;
    return .{ .arena = arena, .palette = try state.palette.toOwnedSlice(a), .cells = try state.cells.toOwnedSlice(a) };
}

/// Fills a box with one block and returns how many cells were written. `spec` is a bare name
/// or full SNBT, resolved once for the whole box.
pub fn fillRegion(dim: i32, bounds: Bounds, spec: []const u8, update: BlockUpdate) core.Error!u64 {
    const f = core.slot("edit_fill_region") orelse return error.NotProvided;
    const n = f(dim, bounds.min.x, bounds.min.y, bounds.min.z, bounds.max.x, bounds.max.y, bounds.max.z, core.str(spec), update.bits);
    if (n < 0) return error.Refused;
    return @intCast(n);
}

/// Writes many cells in one call and returns how many were written. Each entry of `palette` is
/// a block spec resolved once; a cell whose index is out of range, or whose block did not
/// resolve, is skipped.
pub fn setBlocks(allocator: Allocator, dim: i32, palette: []const []const u8, cells: []const BlockCell, update: BlockUpdate) core.Error!u64 {
    const f = core.slot("edit_set_blocks") orelse return error.NotProvided;
    if (palette.len > std.math.maxInt(u32)) return error.Refused;
    const specs = try allocator.alloc(c.PierStr, palette.len);
    defer allocator.free(specs);
    for (palette, 0..) |spec, i| specs[i] = core.str(spec);
    const n = f(dim, specs.ptr, @intCast(specs.len), @ptrCast(cells.ptr), cells.len, update.bits);
    if (n < 0) return error.Refused;
    return @intCast(n);
}

/// Spawns a mob and returns it.
pub fn spawnMob(dim: i32, type_name: []const u8, x: f64, y: f64, z: f64) core.Error!props.Entity {
    const f = core.slot("spawn_mob") orelse return error.NotProvided;
    var out: i64 = 0;
    if (!f(dim, core.str(type_name), x, y, z, &out)) return error.Refused;
    return props.Entity.of(out);
}

/// Spawns an actor from full NBT, the inverse of `Entity.snapshot`. A `pos` overrides the Pos
/// tag. Every current host answers NotProvided: the engine helper that gives a loaded actor
/// a fresh unique id is not reachable.
pub fn spawnEntityNbt(dim: i32, snbt: []const u8, pos: ?types.Vec3) core.Error!props.Entity {
    const f = core.slot("edit_spawn_entity_nbt") orelse return error.NotProvided;
    const at = pos orelse types.Vec3{ .x = 0, .y = 0, .z = 0 };
    var out: i64 = 0;
    if (!f(dim, core.str(snbt), pos != null, at.x, at.y, at.z, &out)) return error.Refused;
    return props.Entity.of(out);
}

/// What an explosion does and who caused it.
pub const ExplodeOptions = struct {
    radius: f32,
    max_resistance: f32 = 3.4028235e38,
    /// The actor blamed for the blast, or null for no source.
    source: ?props.Entity = null,
    fire: bool = false,
    breaks_blocks: bool = true,
    allow_underwater: bool = false,
};

/// Detonates at a point.
pub fn explode(dim: i32, x: f64, y: f64, z: f64, options: ExplodeOptions) core.Error!void {
    const f = core.slot("explode") orelse return error.NotProvided;
    const source: i64 = if (options.source) |e| e.actor_id else 0;
    try core.expect(f(dim, x, y, z, options.radius, options.max_resistance, source, options.fire, options.breaks_blocks, options.allow_underwater));
}

/// A particle visible across the whole dimension. Showing it to one person only uses
/// `spawnParticleFor`.
pub fn spawnParticle(dim: i32, effect: []const u8, x: f64, y: f64, z: f64) core.Error!void {
    const f = core.slot("spawn_particle") orelse return error.NotProvided;
    try core.expect(f(dim, core.str(effect), x, y, z));
}

/// A particle shown to one player.
pub fn spawnParticleFor(player: props.Player, dim: i32, effect: []const u8, x: f64, y: f64, z: f64) core.Error!void {
    const f = core.slot("spawn_particle_for") orelse return error.NotProvided;
    try core.expect(f(player.cSel(), dim, core.str(effect), x, y, z));
}

/// Looks up the feet position and dimension of a connected player by name.
pub fn playerPosition(name: []const u8) core.Error!types.PlayerPosition {
    const f = core.slot("get_player_position") orelse return error.NotProvided;
    const p = f(core.str(name));
    if (!p.found) return error.NoAnswer;
    return .{ .pos = .{ .x = p.x, .y = p.y, .z = p.z }, .dim = p.dimension };
}

/// One weather value of a dimension by its PIER_WPROP_* key.
pub fn weatherValue(dim: i32, prop: i32) core.Error!f64 {
    const get = core.slot("world_get_num") orelse return error.NotProvided;
    var out: f64 = 0;
    if (!get(dim, prop, &out)) return error.NoAnswer;
    return out;
}

/// The rain level of a dimension, 0 for none to 1 for full rain.
pub fn rainLevel(dim: i32) core.Error!f64 {
    return weatherValue(dim, c.PIER_WPROP_RAIN_LEVEL);
}

pub fn targetRainLevel(dim: i32) core.Error!f64 {
    return weatherValue(dim, c.PIER_WPROP_TARGET_RAIN_LEVEL);
}

/// The lightning level of a dimension, 0 for none to 1 for a storm.
pub fn lightningLevel(dim: i32) core.Error!f64 {
    return weatherValue(dim, c.PIER_WPROP_LIGHTNING_LEVEL);
}

pub fn targetLightningLevel(dim: i32) core.Error!f64 {
    return weatherValue(dim, c.PIER_WPROP_TARGET_LIGHTNING_LEVEL);
}

pub fn fogLevel(dim: i32) core.Error!f64 {
    return weatherValue(dim, c.PIER_WPROP_FOG_LEVEL);
}

pub fn skyFlashTime(dim: i32) core.Error!f64 {
    return weatherValue(dim, c.PIER_WPROP_SKY_FLASH_TIME);
}
