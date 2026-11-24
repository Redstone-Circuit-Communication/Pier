//! dimensions.zig: custom dimensions: registering one from a spec, a terrain pack or a
//! generator the mod supplies, the rules that apply to one dimension only, and the cell
//! geometry of a plot world.

const std = @import("std");
const core = @import("core.zig");
const types = @import("types.zig");
const internal = @import("internal.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The vanilla generator of a `terrain:{kind:"native"}` spec.
pub const GeneratorType = enum(i32) {
    overworld = 1,
    flat = 2,
    nether = 3,
    the_end = 4,
    void = 5,

    pub fn fromInt(v: i32) ?GeneratorType {
        return std.meta.intToEnum(GeneratorType, v) catch null;
    }

    /// What `terrain.generator` and `sky.client` are spelled as in a spec.
    pub fn specName(self: GeneratorType) []const u8 {
        return switch (self) {
            .overworld => "overworld",
            .flat => "flat",
            .nether => "nether",
            .the_end => "end",
            .void => "void",
        };
    }

    /// What the engine itself calls this generator. Not the same string as `specName`.
    pub fn engineName(self: GeneratorType) []const u8 {
        return switch (self) {
            .overworld => "Overworld",
            .flat => "Flat",
            .nether => "Nether",
            .the_end => "TheEnd",
            .void => "Void",
        };
    }
};

/// Per-dimension rules. The values correspond to `PIER_DIMRULE_*`.
pub const Rule = enum(i32) {
    spawn_monster = c.PIER_DIMRULE_SPAWN_MONSTER,
    spawn_animal = c.PIER_DIMRULE_SPAWN_ANIMAL,
    spawn_spawner = c.PIER_DIMRULE_SPAWN_SPAWNER,
    explode_blocks = c.PIER_DIMRULE_EXPLODE_BLOCKS,
    fire_spread = c.PIER_DIMRULE_FIRE_SPREAD,
    mob_griefing = c.PIER_DIMRULE_MOB_GRIEFING,
    projectile = c.PIER_DIMRULE_PROJECTILE,
    piston_push = c.PIER_DIMRULE_PISTON_PUSH,
    liquid_flow = c.PIER_DIMRULE_LIQUID_FLOW,
    farmland_decay = c.PIER_DIMRULE_FARMLAND_DECAY,
    ride = c.PIER_DIMRULE_RIDE,
    piston_cross_cell = c.PIER_DIMRULE_PISTON_CROSS_CELL,
    entity_cross_cell = c.PIER_DIMRULE_ENTITY_CROSS_CELL,
};

/// Whether this host was built with the custom dimension capability. A host that answers
/// true here can still refuse a registration when the engine's layout does not match.
pub fn isAvailable() bool {
    const f = core.slot("md_is_available") orelse return false;
    return f();
}

/// Looks up a dimension id by name; null for a name nothing registered.
pub fn dimensionId(name: []const u8) core.Error!?i32 {
    const f = core.slot("md_get_dimension_id") orelse return error.NotProvided;
    const id = f(core.str(name));
    if (id < 0) return null;
    return id;
}

/// One custom dimension that has been registered.
pub const ExistingDimension = struct {
    name: []const u8,
    dim: i32 = 0,
    snbt: []const u8 = "",
};

/// Every registered custom dimension.
pub fn list(allocator: Allocator) core.Error!types.Owned(ExistingDimension) {
    const f = core.slot("md_list_dimensions") orelse return error.NotProvided;
    const pieces = try core.sinkAll(allocator, f, .{});
    defer core.freeList(allocator, pieces);
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var out: std.ArrayList(ExistingDimension) = .empty;
    for (pieces) |piece| {
        if (std.mem.trim(u8, piece, " \t\r\n").len == 0) continue;
        const parsed = std.json.parseFromSliceLeaky(std.json.Value, a, piece, .{}) catch continue;
        if (parsed != .object) continue;
        const entry = try internal.fromJson(ExistingDimension, a, parsed.object);
        if (entry.name.len == 0) continue;
        try out.append(a, entry);
    }
    return .{ .arena = arena, .items = try out.toOwnedSlice(a) };
}

/// Sets one per-dimension rule.
pub fn setRule(dimension: i32, which: Rule, allow: bool) core.Error!void {
    const f = core.slot("md_set_dimension_rule") orelse return error.NotProvided;
    f(dimension, @intFromEnum(which), allow);
}

/// Reads one rule. A dimension with no explicit entry for that rule gives null, which is
/// not the same as false.
pub fn rule(dimension: i32, which: Rule) core.Error!?bool {
    const f = core.slot("md_get_dimension_rule") orelse return error.NotProvided;
    var allow = false;
    if (!f(dimension, @intFromEnum(which), &allow)) return null;
    return allow;
}

/// Clears every rule of a dimension, for when the world was deleted.
pub fn clearRules(dimension: i32) core.Error!void {
    const f = core.slot("md_clear_dimension_rules") orelse return error.NotProvided;
    f(dimension);
}

/// The merge marks of one plot.
pub const PlotMerge = struct {
    x: i32,
    z: i32,
    /// A bitset: 1 north, 2 east, 4 south, 8 west.
    mask: u32,

    /// Assembles a mask from the four directions in the order north, east, south, west.
    pub fn fromDirs(x: i32, z: i32, dirs: [4]bool) PlotMerge {
        var mask: u32 = 0;
        for (dirs, 0..) |on, i| {
            if (on) mask |= @as(u32, 1) << @intCast(i);
        }
        return .{ .x = x, .z = z, .mask = mask };
    }

    pub fn isEmpty(self: PlotMerge) bool {
        return self.mask == 0;
    }
};

/// Replaces the merge marks of a dimension as a whole. Only plots that carry a marker need to
/// be listed.
pub fn setPlotMerges(allocator: Allocator, dimension: i32, merges: []const PlotMerge) core.Error!void {
    const f = core.slot("md_set_plot_merges") orelse return error.NotProvided;
    const triples = try allocator.alloc(i32, merges.len * 3);
    defer allocator.free(triples);
    for (merges, 0..) |m, i| {
        triples[i * 3] = m.x;
        triples[i * 3 + 1] = m.z;
        triples[i * 3 + 2] = @bitCast(m.mask);
    }
    f(dimension, triples.ptr, @intCast(merges.len));
}

/// Adds a custom dimension with a native terrain from one declarative spec, and returns its id.
/// The reason for a refusal is in the host log.
pub fn addDimension(name: []const u8, spec_snbt: []const u8) core.Error!i32 {
    const f = core.slot("md_add_dimension") orelse return error.NotProvided;
    const id = f(core.str(name), core.str(spec_snbt));
    if (id < 0) return error.Refused;
    return id;
}

/// Why the host refused a terrain pack; the values are `PIER_PACK_*`.
pub const PackStatus = enum {
    bad_path,
    config_unreadable,
    config_invalid,
    binary_unreadable,
    corrupt,
    kind_mismatch,
    hash_mismatch,
    unsupported,
    params,
    constraint,
    height,
    stored_mismatch,
    spec,
    host,
    other,

    pub fn fromCode(code: i32) PackStatus {
        return switch (code) {
            c.PIER_PACK_BAD_PATH => .bad_path,
            c.PIER_PACK_CONFIG_UNREADABLE => .config_unreadable,
            c.PIER_PACK_CONFIG_INVALID => .config_invalid,
            c.PIER_PACK_BINARY_UNREADABLE => .binary_unreadable,
            c.PIER_PACK_CORRUPT => .corrupt,
            c.PIER_PACK_KIND_MISMATCH => .kind_mismatch,
            c.PIER_PACK_HASH_MISMATCH => .hash_mismatch,
            c.PIER_PACK_UNSUPPORTED => .unsupported,
            c.PIER_PACK_PARAMS => .params,
            c.PIER_PACK_CONSTRAINT => .constraint,
            c.PIER_PACK_HEIGHT => .height,
            c.PIER_PACK_STORED_MISMATCH => .stored_mismatch,
            c.PIER_PACK_SPEC => .spec,
            c.PIER_PACK_HOST => .host,
            else => .other,
        };
    }
};

/// The outcome of registering a terrain pack: its dimension id, or why it was refused.
pub const PackResult = union(enum) {
    id: i32,
    refused: PackStatus,
};

/// Adds a custom dimension whose terrain is a terrain pack: a directory with a config file and
/// a binary built by tools/pier-pack. `config_path` is relative to the server root, with
/// forward slashes, no `..` and not absolute.
pub fn addDimensionPack(name: []const u8, config_path: []const u8, spec_snbt: []const u8) core.Error!PackResult {
    const f = core.slot("md_add_dimension_pack") orelse return error.NotProvided;
    const r = f(core.str(name), core.str(config_path), core.str(spec_snbt));
    if (r < 0) return .{ .refused = PackStatus.fromCode(r) };
    return .{ .id = r };
}

/// What a pack asks for, as the JSON document `md_pack_inspect` describes, without registering
/// anything. The text is owned by the caller. A refusal gives its status and, when the host
/// wrote one, its reasons in `problems`, owned by the caller as well.
pub const Inspection = union(enum) {
    json: []u8,
    refused: struct { status: PackStatus, problems: []u8 },
};

pub fn packInspect(allocator: Allocator, config_path: []const u8) core.Error!Inspection {
    const f = core.slot("md_pack_inspect") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    const r = f(core.str(config_path), &col, &core.Collector.sink);
    const text = try col.takeOrEmpty();
    if (r == 0) return .{ .json = text };
    return .{ .refused = .{ .status = PackStatus.fromCode(r), .problems = text } };
}

/// Retires a custom dimension: it is dropped from the host's tables and from
/// dimension_config.json, so nothing registers it on the next boot. The chunks it wrote stay.
/// Returns whether one by that name was registered.
pub fn retireDimension(name: []const u8) core.Error!bool {
    const f = core.slot("md_retire_dimension") orelse return error.NotProvided;
    return f(core.str(name));
}

/// What the host asks a generator to fill: one chunk. `materials` has `256 * height` entries,
/// indexed `(x * 16 + z) * height + y` with y counted from `min_y`, and `biomes` has 256, one
/// per column. Both hold indices into the two palettes given at registration, and material 0
/// is air.
pub const ChunkRequest = struct {
    dim_id: i32,
    chunk_x: i32,
    chunk_z: i32,
    min_y: i32,
    height: i32,
    materials: []u16,
    biomes: []u16,
};

/// A generator for `addDimensionGenerated`. Returning false means the chunk could not be
/// filled; the host writes air and logs it. It runs on chunk threads, so it must not touch
/// state another thread writes.
pub const GenerateFn = fn (user: ?*anyopaque, request: ChunkRequest) bool;

/// Registers a dimension whose terrain the mod fills itself, and returns its id. `spec_snbt`
/// carries only seed, height and sky. Entry 0 of `materials` must be "minecraft:air", which
/// the host reads as nothing written. `user` must stay valid for as long as the dimension
/// lives, which is the host's lifetime and not the mod's.
pub fn addDimensionGenerated(allocator: Allocator, name: []const u8, spec_snbt: []const u8, materials: []const []const u8, biomes: []const []const u8, user: ?*anyopaque, comptime generate: GenerateFn) core.Error!i32 {
    const f = core.slot("md_add_dimension_generated") orelse return error.NotProvided;
    if (materials.len == 0 or !std.mem.eql(u8, materials[0], "minecraft:air")) return error.Refused;
    const joined_materials = try std.mem.join(allocator, "\n", materials);
    defer allocator.free(joined_materials);
    const joined_biomes = try std.mem.join(allocator, "\n", biomes);
    defer allocator.free(joined_biomes);
    const Trampoline = struct {
        fn call(user_ptr: ?*anyopaque, request: [*c]const c.PierChunkRequest) callconv(.c) i32 {
            const req = request.*;
            if (req.height <= 0 or req.out_materials == null or req.out_biomes == null) return 0;
            const n: usize = 256 * @as(usize, @intCast(req.height));
            const chunk = ChunkRequest{
                .dim_id = req.dim_id,
                .chunk_x = req.chunk_x,
                .chunk_z = req.chunk_z,
                .min_y = req.min_y,
                .height = req.height,
                .materials = req.out_materials[0..n],
                .biomes = req.out_biomes[0..256],
            };
            return if (generate(user_ptr, chunk)) 1 else 0;
        }
    };
    const id = f(core.str(name), core.str(spec_snbt), core.str(joined_materials), core.str(joined_biomes), &Trampoline.call, user);
    if (id < 0) return error.Refused;
    return id;
}

/// Gives a generated dimension the cell geometry its confinement rules use. `cell` is the edge
/// of a cell and `gap` the space between cells, both in blocks. A `cell` of 0 removes the
/// geometry. Refused for a dimension this host did not register.
pub fn setDimensionCells(dim_id: i32, cell: i32, gap: i32) core.Error!void {
    const f = core.slot("md_set_dimension_cells") orelse return error.NotProvided;
    try core.expect(f(dim_id, cell, gap));
}
