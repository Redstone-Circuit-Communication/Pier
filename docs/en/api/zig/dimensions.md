# Zig: Custom dimensions

## Declarations {#declarations}

### `dimensions.GenerateFn` {#dimensions.GenerateFn}

```zig
pub const GenerateFn = fn (user: ?*anyopaque, request: ChunkRequest) bool;
```

A generator for `addDimensionGenerated`. Returning false means the chunk could not be filled; the host writes air and logs it. It runs on chunk threads, so it must not touch state another thread writes.

## Functions {#functions}

### `dimensions.isAvailable` {#dimensions.isAvailable}

```zig
pub fn isAvailable() bool
```

Whether this host was built with the custom dimension capability. A host that answers true here can still refuse a registration when the engine's layout does not match.

- Return type: `bool`
- Slots: [`md_is_available`](../cpp/dimensions.md#md_is_available)

### `dimensions.dimensionId` {#dimensions.dimensionId}

```zig
pub fn dimensionId(name: []const u8) core.Error!?i32
```

Looks up a dimension id by name; null for a name nothing registered.

- Parameters:
    - name : `[]const u8`
- Return type: `core.Error!?i32`
- Slots: [`md_get_dimension_id`](../cpp/dimensions.md#md_get_dimension_id)

### `dimensions.list` {#dimensions.list}

```zig
pub fn list(allocator: Allocator) core.Error!types.Owned(ExistingDimension)
```

Every registered custom dimension.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(ExistingDimension)`
- Slots: [`md_list_dimensions`](../cpp/dimensions.md#md_list_dimensions)

### `dimensions.setRule` {#dimensions.setRule}

```zig
pub fn setRule(dimension: i32, which: Rule, allow: bool) core.Error!void
```

Sets one per-dimension rule.

- Parameters:
    - dimension : `i32`
    - which : `Rule`
    - allow : `bool`
- Return type: `core.Error!void`
- Slots: [`md_set_dimension_rule`](../cpp/dimensions.md#md_set_dimension_rule)

### `dimensions.rule` {#dimensions.rule}

```zig
pub fn rule(dimension: i32, which: Rule) core.Error!?bool
```

Reads one rule. A dimension with no explicit entry for that rule gives null, which is not the same as false.

- Parameters:
    - dimension : `i32`
    - which : `Rule`
- Return type: `core.Error!?bool`
- Slots: [`md_get_dimension_rule`](../cpp/dimensions.md#md_get_dimension_rule)

### `dimensions.clearRules` {#dimensions.clearRules}

```zig
pub fn clearRules(dimension: i32) core.Error!void
```

Clears every rule of a dimension, for when the world was deleted.

- Parameters:
    - dimension : `i32`
- Return type: `core.Error!void`
- Slots: [`md_clear_dimension_rules`](../cpp/dimensions.md#md_clear_dimension_rules)

### `dimensions.setPlotMerges` {#dimensions.setPlotMerges}

```zig
pub fn setPlotMerges(allocator: Allocator, dimension: i32, merges: []const PlotMerge) core.Error!void
```

Replaces the merge marks of a dimension as a whole. Only plots that carry a marker need to be listed.

- Parameters:
    - allocator : `Allocator`
    - dimension : `i32`
    - merges : `[]const PlotMerge`
- Return type: `core.Error!void`
- Slots: [`md_set_plot_merges`](../cpp/dimensions.md#md_set_plot_merges)

### `dimensions.addDimension` {#dimensions.addDimension}

```zig
pub fn addDimension(name: []const u8, spec_snbt: []const u8) core.Error!i32
```

Adds a custom dimension with a native terrain from one declarative spec, and returns its id. The reason for a refusal is in the host log.

- Parameters:
    - name : `[]const u8`
    - spec_snbt : `[]const u8`
- Return type: `core.Error!i32`
- Slots: [`md_add_dimension`](../cpp/dimensions.md#md_add_dimension)

### `dimensions.addDimensionPack` {#dimensions.addDimensionPack}

```zig
pub fn addDimensionPack(name: []const u8, config_path: []const u8, spec_snbt: []const u8) core.Error!PackResult
```

Adds a custom dimension whose terrain is a terrain pack: a directory with a config file and a binary built by tools/pier-pack. `config_path` is relative to the server root, with forward slashes, no `..` and not absolute.

- Parameters:
    - name : `[]const u8`
    - config_path : `[]const u8`
    - spec_snbt : `[]const u8`
- Return type: `core.Error!PackResult`
- Slots: [`md_add_dimension_pack`](../cpp/dimensions.md#md_add_dimension_pack)

### `dimensions.packInspect` {#dimensions.packInspect}

```zig
pub fn packInspect(allocator: Allocator, config_path: []const u8) core.Error!Inspection
```

- Parameters:
    - allocator : `Allocator`
    - config_path : `[]const u8`
- Return type: `core.Error!Inspection`
- Slots: [`md_pack_inspect`](../cpp/dimensions.md#md_pack_inspect)

### `dimensions.retireDimension` {#dimensions.retireDimension}

```zig
pub fn retireDimension(name: []const u8) core.Error!bool
```

Retires a custom dimension: it is dropped from the host's tables and from `dimension_config`.json, so nothing registers it on the next boot. The chunks it wrote stay. Returns whether one by that name was registered.

- Parameters:
    - name : `[]const u8`
- Return type: `core.Error!bool`
- Slots: [`md_retire_dimension`](../cpp/dimensions.md#md_retire_dimension)

### `dimensions.addDimensionGenerated` {#dimensions.addDimensionGenerated}

```zig
pub fn addDimensionGenerated(allocator: Allocator, name: []const u8, spec_snbt: []const u8, materials: []const []const u8, biomes: []const []const u8, user: ?*anyopaque, comptime generate: GenerateFn) core.Error!i32
```

Registers a dimension whose terrain the mod fills itself, and returns its id. `spec_snbt` carries only seed, height and sky. Entry 0 of `materials` must be "minecraft:air", which the host reads as nothing written. `user` must stay valid for as long as the dimension lives, which is the host's lifetime and not the mod's.

- Parameters:
    - allocator : `Allocator`
    - name : `[]const u8`
    - spec_snbt : `[]const u8`
    - materials : `[]const []const u8`
    - biomes : `[]const []const u8`
    - user : `?*anyopaque`
    - generate : `comptime GenerateFn`
- Return type: `core.Error!i32`
- Slots: [`md_add_dimension_generated`](../cpp/dimensions.md#md_add_dimension_generated)

### `dimensions.setDimensionCells` {#dimensions.setDimensionCells}

```zig
pub fn setDimensionCells(dim_id: i32, cell: i32, gap: i32) core.Error!void
```

Gives a generated dimension the cell geometry its confinement rules use. `cell` is the edge of a cell and `gap` the space between cells, both in blocks. A `cell` of 0 removes the geometry. Refused for a dimension this host did not register.

- Parameters:
    - dim_id : `i32`
    - cell : `i32`
    - gap : `i32`
- Return type: `core.Error!void`
- Slots: [`md_set_dimension_cells`](../cpp/dimensions.md#md_set_dimension_cells)

## `dimensions.GeneratorType` {#dimensions.GeneratorType}

```zig
pub const GeneratorType = enum(i32) {
    overworld = 1,
    flat = 2,
    nether = 3,
    the_end = 4,
    void = 5,
};
```

The vanilla generator of a `terrain:{kind:"native"}` spec.

### `dimensions.GeneratorType.fromInt` {#dimensions.GeneratorType.fromInt}

```zig
pub fn fromInt(v: i32) ?GeneratorType
```

- Parameters:
    - v : `i32`
- Return type: `?GeneratorType`

### `dimensions.GeneratorType.specName` {#dimensions.GeneratorType.specName}

```zig
pub fn specName(self: GeneratorType) []const u8
```

What `terrain.generator` and `sky.client` are spelled as in a spec.

- Return type: `[]const u8`

### `dimensions.GeneratorType.engineName` {#dimensions.GeneratorType.engineName}

```zig
pub fn engineName(self: GeneratorType) []const u8
```

What the engine itself calls this generator. Not the same string as `specName`.

- Return type: `[]const u8`

## `dimensions.PlotMerge` {#dimensions.PlotMerge}

```zig
pub const PlotMerge = struct {
    x: i32,
    z: i32,
    /// A bitset: 1 north, 2 east, 4 south, 8 west.
    mask: u32,
    // ...
};
```

The merge marks of one plot.

### `dimensions.PlotMerge.fromDirs` {#dimensions.PlotMerge.fromDirs}

```zig
pub fn fromDirs(x: i32, z: i32, dirs: [4]bool) PlotMerge
```

Assembles a mask from the four directions in the order north, east, south, west.

- Parameters:
    - x : `i32`
    - z : `i32`
    - dirs : `[4]bool`
- Return type: `PlotMerge`

### `dimensions.PlotMerge.isEmpty` {#dimensions.PlotMerge.isEmpty}

```zig
pub fn isEmpty(self: PlotMerge) bool
```

- Return type: `bool`

## `dimensions.PackStatus` {#dimensions.PackStatus}

```zig
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
};
```

Why the host refused a terrain pack; the values are `PIER_PACK_*`.

### `dimensions.PackStatus.fromCode` {#dimensions.PackStatus.fromCode}

```zig
pub fn fromCode(code: i32) PackStatus
```

- Parameters:
    - code : `i32`
- Return type: `PackStatus`

## `dimensions.Rule` {#dimensions.Rule}

```zig
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
```

Per-dimension rules. The values correspond to `PIER_DIMRULE_*`.

## `dimensions.ExistingDimension` {#dimensions.ExistingDimension}

```zig
pub const ExistingDimension = struct {
    name: []const u8,
    dim: i32 = 0,
    snbt: []const u8 = "",
    // ...
};
```

One custom dimension that has been registered.

## `dimensions.PackResult` {#dimensions.PackResult}

```zig
pub const PackResult = union(enum) {
    id: i32,
    refused: PackStatus,
    // ...
};
```

The outcome of registering a terrain pack: its dimension id, or why it was refused.

## `dimensions.Inspection` {#dimensions.Inspection}

```zig
pub const Inspection = union(enum) {
    json: []u8,
    refused: struct { status: PackStatus, problems: []u8 },
    // ...
};
```

What a pack asks for, as the JSON document `md_pack_inspect` describes, without registering anything. The text is owned by the caller. A refusal gives its status and, when the host wrote one, its reasons in `problems`, owned by the caller as well.

## `dimensions.ChunkRequest` {#dimensions.ChunkRequest}

```zig
pub const ChunkRequest = struct {
    dim_id: i32,
    chunk_x: i32,
    chunk_z: i32,
    min_y: i32,
    height: i32,
    materials: []u16,
    biomes: []u16,
    // ...
};
```

What the host asks a generator to fill: one chunk. `materials` has `256 * height` entries, indexed `(x * 16 + z) * height + y` with y counted from `min_y`, and `biomes` has 256, one per column. Both hold indices into the two palettes given at registration, and material 0 is air.
