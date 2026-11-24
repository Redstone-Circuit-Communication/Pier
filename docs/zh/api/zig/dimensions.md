# Zig：自定义维度

## 声明 {#declarations}

### `dimensions.GenerateFn` {#dimensions.GenerateFn}

```zig
pub const GenerateFn = fn (user: ?*anyopaque, request: ChunkRequest) bool;
```

`addDimensionGenerated` 用的生成器。返回 false 表示这个区块没能填充；宿主会写入空气并记一条日志。它运行在区块线程上，所以不能碰别的线程会写的状态。

## 函数 {#functions}

### `dimensions.isAvailable` {#dimensions.isAvailable}

```zig
pub fn isAvailable() bool
```

这个宿主是否带有自定义维度的能力。这里回答 true 的宿主，在引擎布局对不上时仍然可能拒绝一次注册。

- 返回值类型：`bool`
- 对应槽位：[`md_is_available`](../cpp/dimensions.md#md_is_available)

### `dimensions.dimensionId` {#dimensions.dimensionId}

```zig
pub fn dimensionId(name: []const u8) core.Error!?i32
```

按名字查找维度 id；没有任何东西注册过这个名字时为 null。

- 参数：
    - name : `[]const u8`
- 返回值类型：`core.Error!?i32`
- 对应槽位：[`md_get_dimension_id`](../cpp/dimensions.md#md_get_dimension_id)

### `dimensions.list` {#dimensions.list}

```zig
pub fn list(allocator: Allocator) core.Error!types.Owned(ExistingDimension)
```

每个已注册的自定义维度。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(ExistingDimension)`
- 对应槽位：[`md_list_dimensions`](../cpp/dimensions.md#md_list_dimensions)

### `dimensions.setRule` {#dimensions.setRule}

```zig
pub fn setRule(dimension: i32, which: Rule, allow: bool) core.Error!void
```

设置一条按维度生效的规则。

- 参数：
    - dimension : `i32`
    - which : `Rule`
    - allow : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`md_set_dimension_rule`](../cpp/dimensions.md#md_set_dimension_rule)

### `dimensions.rule` {#dimensions.rule}

```zig
pub fn rule(dimension: i32, which: Rule) core.Error!?bool
```

读取一条规则。某个维度没有该规则的显式条目时给出 null，这和 false 不是一回事。

- 参数：
    - dimension : `i32`
    - which : `Rule`
- 返回值类型：`core.Error!?bool`
- 对应槽位：[`md_get_dimension_rule`](../cpp/dimensions.md#md_get_dimension_rule)

### `dimensions.clearRules` {#dimensions.clearRules}

```zig
pub fn clearRules(dimension: i32) core.Error!void
```

清除一个维度的所有规则，用于世界被删除的时候。

- 参数：
    - dimension : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`md_clear_dimension_rules`](../cpp/dimensions.md#md_clear_dimension_rules)

### `dimensions.setPlotMerges` {#dimensions.setPlotMerges}

```zig
pub fn setPlotMerges(allocator: Allocator, dimension: i32, merges: []const PlotMerge) core.Error!void
```

整体替换一个维度的合并标记。只需要列出带标记的地块。

- 参数：
    - allocator : `Allocator`
    - dimension : `i32`
    - merges : `[]const PlotMerge`
- 返回值类型：`core.Error!void`
- 对应槽位：[`md_set_plot_merges`](../cpp/dimensions.md#md_set_plot_merges)

### `dimensions.addDimension` {#dimensions.addDimension}

```zig
pub fn addDimension(name: []const u8, spec_snbt: []const u8) core.Error!i32
```

用一份声明式规格添加一个原生地形的自定义维度，并返回它的 id。被拒绝的原因在宿主日志里。

- 参数：
    - name : `[]const u8`
    - spec_snbt : `[]const u8`
- 返回值类型：`core.Error!i32`
- 对应槽位：[`md_add_dimension`](../cpp/dimensions.md#md_add_dimension)

### `dimensions.addDimensionPack` {#dimensions.addDimensionPack}

```zig
pub fn addDimensionPack(name: []const u8, config_path: []const u8, spec_snbt: []const u8) core.Error!PackResult
```

添加一个地形来自地形包的自定义维度：地形包是一个目录，里面有一个配置文件和一个由 tools/pier-pack 生成的二进制文件。`config_path` 相对于服务器根目录，使用正斜杠，不含 `..`，也不是绝对路径。

- 参数：
    - name : `[]const u8`
    - config_path : `[]const u8`
    - spec_snbt : `[]const u8`
- 返回值类型：`core.Error!PackResult`
- 对应槽位：[`md_add_dimension_pack`](../cpp/dimensions.md#md_add_dimension_pack)

### `dimensions.packInspect` {#dimensions.packInspect}

```zig
pub fn packInspect(allocator: Allocator, config_path: []const u8) core.Error!Inspection
```

- 参数：
    - allocator : `Allocator`
    - config_path : `[]const u8`
- 返回值类型：`core.Error!Inspection`
- 对应槽位：[`md_pack_inspect`](../cpp/dimensions.md#md_pack_inspect)

### `dimensions.retireDimension` {#dimensions.retireDimension}

```zig
pub fn retireDimension(name: []const u8) core.Error!bool
```

注销一个自定义维度：把它从宿主的表和 dimension_config.json 里去掉，下次启动时就不会再有东西注册它。它写出的区块保留。返回是否存在这个名字的已注册维度。

- 参数：
    - name : `[]const u8`
- 返回值类型：`core.Error!bool`
- 对应槽位：[`md_retire_dimension`](../cpp/dimensions.md#md_retire_dimension)

### `dimensions.addDimensionGenerated` {#dimensions.addDimensionGenerated}

```zig
pub fn addDimensionGenerated(allocator: Allocator, name: []const u8, spec_snbt: []const u8, materials: []const []const u8, biomes: []const []const u8, user: ?*anyopaque, comptime generate: GenerateFn) core.Error!i32
```

注册一个地形由 mod 自己填充的维度，并返回它的 id。`spec_snbt` 只带种子、高度和天空。`materials` 的第 0 项必须是 "minecraft:air"，宿主把它读作“没有写入”。`user` 必须在维度存活期间一直有效，这是宿主的生命周期，不是 mod 的。

- 参数：
    - allocator : `Allocator`
    - name : `[]const u8`
    - spec_snbt : `[]const u8`
    - materials : `[]const []const u8`
    - biomes : `[]const []const u8`
    - user : `?*anyopaque`
    - generate : `comptime GenerateFn`
- 返回值类型：`core.Error!i32`
- 对应槽位：[`md_add_dimension_generated`](../cpp/dimensions.md#md_add_dimension_generated)

### `dimensions.setDimensionCells` {#dimensions.setDimensionCells}

```zig
pub fn setDimensionCells(dim_id: i32, cell: i32, gap: i32) core.Error!void
```

给一个生成出来的维度设置它的限制规则所用的单元几何。`cell` 是单元的边长，`gap` 是单元之间的间隔，单位都是方块。`cell` 为 0 表示去掉这个几何。对这个宿主没有注册过的维度得到 `Refused`。

- 参数：
    - dim_id : `i32`
    - cell : `i32`
    - gap : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`md_set_dimension_cells`](../cpp/dimensions.md#md_set_dimension_cells)

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

`terrain:{kind:"native"}` 规格所用的原版生成器。

### `dimensions.GeneratorType.fromInt` {#dimensions.GeneratorType.fromInt}

```zig
pub fn fromInt(v: i32) ?GeneratorType
```

- 参数：
    - v : `i32`
- 返回值类型：`?GeneratorType`

### `dimensions.GeneratorType.specName` {#dimensions.GeneratorType.specName}

```zig
pub fn specName(self: GeneratorType) []const u8
```

在描述里，`terrain.generator` 和 `sky.client` 的写法。

- 返回值类型：`[]const u8`

### `dimensions.GeneratorType.engineName` {#dimensions.GeneratorType.engineName}

```zig
pub fn engineName(self: GeneratorType) []const u8
```

引擎自己对这个生成器的叫法。和 `specName` 不是同一个字符串。

- 返回值类型：`[]const u8`

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

一块地皮的合并标记。

### `dimensions.PlotMerge.fromDirs` {#dimensions.PlotMerge.fromDirs}

```zig
pub fn fromDirs(x: i32, z: i32, dirs: [4]bool) PlotMerge
```

按北、东、南、西的顺序，用四个方向拼出一个掩码。

- 参数：
    - x : `i32`
    - z : `i32`
    - dirs : `[4]bool`
- 返回值类型：`PlotMerge`

### `dimensions.PlotMerge.isEmpty` {#dimensions.PlotMerge.isEmpty}

```zig
pub fn isEmpty(self: PlotMerge) bool
```

- 返回值类型：`bool`

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

宿主为什么拒绝一个地形包；取值是 `PIER_PACK_*`。

### `dimensions.PackStatus.fromCode` {#dimensions.PackStatus.fromCode}

```zig
pub fn fromCode(code: i32) PackStatus
```

- 参数：
    - code : `i32`
- 返回值类型：`PackStatus`

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

按维度生效的规则。取值对应 `PIER_DIMRULE_*`。

## `dimensions.ExistingDimension` {#dimensions.ExistingDimension}

```zig
pub const ExistingDimension = struct {
    name: []const u8,
    dim: i32 = 0,
    snbt: []const u8 = "",
    // ...
};
```

一个已经注册的自定义维度。

## `dimensions.PackResult` {#dimensions.PackResult}

```zig
pub const PackResult = union(enum) {
    id: i32,
    refused: PackStatus,
    // ...
};
```

注册一个地形包的结果：它的维度 id，或者被拒绝的原因。

## `dimensions.Inspection` {#dimensions.Inspection}

```zig
pub const Inspection = union(enum) {
    json: []u8,
    refused: struct { status: PackStatus, problems: []u8 },
    // ...
};
```

一个地形包提出的要求，格式是 `md_pack_inspect` 描述的那份 JSON 文档，不会注册任何东西。文本由调用方持有。被拒绝时给出状态，宿主写了原因的话还给出 `problems`，同样由调用方持有。

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

宿主要求生成器填充的内容：一个区块。`materials` 有 `256 * height` 项，按 `(x * 16 + z) * height + y` 索引，y 从 `min_y` 起算；`biomes` 有 256 项，每列一项。两者存的都是注册时给出的两张调色板里的索引，材质 0 是空气。
