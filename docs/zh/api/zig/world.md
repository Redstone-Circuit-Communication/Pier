# Zig：世界

## 函数 {#functions}

### `world.time` {#world.time}

```zig
pub fn time() core.Error!i64
```

世界时间，单位为 tick。

- 返回值类型：`core.Error!i64`
- 对应槽位：[`get_time`](../cpp/world.md#get_time)

### `world.setTime` {#world.setTime}

```zig
pub fn setTime(t: i64) core.Error!void
```

以原生方式设置世界时间。

- 参数：
    - t : `i64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`set_time`](../cpp/world.md#set_time)

### `world.setWeather` {#world.setWeather}

```zig
pub fn setWeather(weather: types.Weather) core.Error!void
```

- 参数：
    - weather : `types.Weather`
- 返回值类型：`core.Error!void`
- 对应槽位：[`set_weather`](../cpp/world.md#set_weather)

### `world.updateWeather` {#world.updateWeather}

```zig
pub fn updateWeather(rain_level: f32, rain_ticks: i32, lightning_level: f32, lightning_ticks: i32) core.Error!void
```

设置雨和雷各自的强度与剩余时长，时长单位为 tick。

- 参数：
    - rain_level : `f32`
    - rain_ticks : `i32`
    - lightning_level : `f32`
    - lightning_ticks : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`level_update_weather`](../cpp/world.md#level_update_weather)

### `world.difficulty` {#world.difficulty}

```zig
pub fn difficulty() core.Error!types.Difficulty
```

- 返回值类型：`core.Error!types.Difficulty`
- 对应槽位：[`get_difficulty`](../cpp/world.md#get_difficulty)

### `world.setDifficulty` {#world.setDifficulty}

```zig
pub fn setDifficulty(d: types.Difficulty) core.Error!void
```

- 参数：
    - d : `types.Difficulty`
- 返回值类型：`core.Error!void`
- 对应槽位：[`set_difficulty`](../cpp/world.md#set_difficulty)

### `world.seed` {#world.seed}

```zig
pub fn seed() core.Error!i64
```

- 返回值类型：`core.Error!i64`
- 对应槽位：[`get_seed`](../cpp/world.md#get_seed)

### `world.gameRule` {#world.gameRule}

```zig
pub fn gameRule(allocator: Allocator, name: []const u8) core.Error!GameRuleValue
```

读取一条游戏规则。规则名不认识时是 `NoAnswer`，不会给出某个默认值。

- 参数：
    - allocator : `Allocator`
    - name : `[]const u8`
- 返回值类型：`core.Error!GameRuleValue`
- 对应槽位：[`game_rule_get`](../cpp/world.md#game_rule_get)

### `world.setGameRule` {#world.setGameRule}

```zig
pub fn setGameRule(name: []const u8, value: []const u8) core.Error!void
```

用文本形式写入一条游戏规则，例如 "true" 或 "300"。

- 参数：
    - name : `[]const u8`
    - value : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`game_rule_set`](../cpp/world.md#game_rule_set)

### `world.defaultSpawn` {#world.defaultSpawn}

```zig
pub fn defaultSpawn() core.Error!Pos3
```

- 返回值类型：`core.Error!Pos3`
- 对应槽位：[`level_get_default_spawn`](../cpp/world.md#level_get_default_spawn)

### `world.setDefaultSpawn` {#world.setDefaultSpawn}

```zig
pub fn setDefaultSpawn(x: i32, y: i32, z: i32) core.Error!void
```

- 参数：
    - x : `i32`
    - y : `i32`
    - z : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`level_set_default_spawn`](../cpp/world.md#level_set_default_spawn)

### `world.save` {#world.save}

```zig
pub fn save() core.Error!void
```

立即保存到磁盘。

- 返回值类型：`core.Error!void`
- 对应槽位：[`level_save`](../cpp/world.md#level_save)

### `world.sleepStatus` {#world.sleepStatus}

```zig
pub fn sleepStatus(allocator: Allocator) core.Error!SleepStatus
```

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!SleepStatus`
- 对应槽位：[`level_get_sleep_status`](../cpp/world.md#level_get_sleep_status)

### `world.biome` {#world.biome}

```zig
pub fn biome(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error![]u8
```

一个格子处的生物群系名，由调用方持有。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`level_get_biome`](../cpp/world.md#level_get_biome)

### `world.setBiome` {#world.setBiome}

```zig
pub fn setBiome(dim: i32, from_x: i32, from_z: i32, to_x: i32, to_z: i32, biome_name: []const u8) core.Error!i32
```

逐列设置一个区域的生物群系，并返回设置了多少列。两个角可以按任意顺序给出，不需要 y，因为基岩版按列保存生物群系。返回 0 表示一列也没有设置。

- 参数：
    - dim : `i32`
    - from_x : `i32`
    - from_z : `i32`
    - to_x : `i32`
    - to_z : `i32`
    - biome_name : `[]const u8`
- 返回值类型：`core.Error!i32`
- 对应槽位：[`level_set_biome`](../cpp/world.md#level_set_biome)

### `world.villages` {#world.villages}

```zig
pub fn villages(allocator: Allocator, dim: i32) core.Error!types.Owned(Village)
```

一个维度里的村庄。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
- 返回值类型：`core.Error!types.Owned(Village)`
- 对应槽位：[`villages`](../cpp/world.md#villages)

### `world.structuresNear` {#world.structuresNear}

```zig
pub fn structuresNear(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32, radius: i32) core.Error!types.Owned(Structure)
```

一个半径内、已加载区块里的硬编码生成区域。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - radius : `i32`
- 返回值类型：`core.Error!types.Owned(Structure)`
- 对应槽位：[`structures_near`](../cpp/world.md#structures_near)

### `world.chunksLoaded` {#world.chunksLoaded}

```zig
pub fn chunksLoaded(dim: i32, min_x: i32, min_z: i32, max_x: i32, max_z: i32) core.Error!bool
```

区域覆盖的每个区块是否都在内存里。

- 参数：
    - dim : `i32`
    - min_x : `i32`
    - min_z : `i32`
    - max_x : `i32`
    - max_z : `i32`
- 返回值类型：`core.Error!bool`
- 对应槽位：[`level_chunks_loaded`](../cpp/world.md#level_chunks_loaded)

### `world.deleteChunkKeys` {#world.deleteChunkKeys}

```zig
pub fn deleteChunkKeys(dim: i32, chunk_x: i32, chunk_z: i32) core.Error!i32
```

删除一个区块的全部存档键，引擎会在下次加载它时从生成器重新生成。只有未加载的区块可以这样还原。返回删掉了多少个键。

- 参数：
    - dim : `i32`
    - chunk_x : `i32`
    - chunk_z : `i32`
- 返回值类型：`core.Error!i32`
- 对应槽位：[`level_delete_chunk_keys`](../cpp/world.md#level_delete_chunk_keys)

### `world.chunkKeys` {#world.chunkKeys}

```zig
pub fn chunkKeys(allocator: Allocator, dim: i32, chunk_x: i32, chunk_z: i32) core.Error![][]u8
```

列出一个区块的全部存档键，每个键由调用方持有，切片也一样。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - chunk_x : `i32`
    - chunk_z : `i32`
- 返回值类型：`core.Error![][]u8`
- 对应槽位：[`level_chunk_keys`](../cpp/world.md#level_chunk_keys)

### `world.deleteKey` {#world.deleteKey}

```zig
pub fn deleteKey(key: []const u8) core.Error!void
```

逐字节删除一个存档键。内容不会被解释。

- 参数：
    - key : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`level_delete_key`](../cpp/world.md#level_delete_key)

### `world.findPath` {#world.findPath}

```zig
pub fn findPath(allocator: Allocator, who: props.Entity, x: i32, y: i32, z: i32) core.Error![]u8
```

为一个实体计算前往目标格子的路径，结果是宿主的 SNBT `{nodes, reached}`。目前所有宿主都返回 `NotProvided`：寻路没有实现。

- 参数：
    - allocator : `Allocator`
    - who : `props.Entity`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`level_find_path`](../cpp/world.md#level_find_path)

### `world.getBlock` {#world.getBlock}

```zig
pub fn getBlock(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error!types.Owned(BlockInfo)
```

读取一个方块。名字和 SNBT 属于结果里的 arena。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- 返回值类型：`core.Error!types.Owned(BlockInfo)`
- 对应槽位：[`get_block`](../cpp/world.md#get_block)

### `world.setBlock` {#world.setBlock}

```zig
pub fn setBlock(dim: i32, x: i32, y: i32, z: i32, spec: []const u8) core.Error!void
```

用默认的更新标志以原生方式放置一个方块。`spec` 是裸名字（例如 "minecraft:stone"）或完整的 SNBT。名字不认识时会失败，而不是放一个占位方块。

- 参数：
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - spec : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`set_block`](../cpp/world.md#set_block)

### `world.getExtraBlock` {#world.getExtraBlock}

```zig
pub fn getExtraBlock(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error![]u8
```

以方块名的形式读取一个格子的液体层；空的液体层得到空气。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`get_extra_block`](../cpp/world.md#get_extra_block)

### `world.setExtraBlock` {#world.setExtraBlock}

```zig
pub fn setExtraBlock(dim: i32, x: i32, y: i32, z: i32, spec: []const u8, update: BlockUpdate) core.Error!void
```

写入一个格子的液体层；写 "minecraft:air" 可清除它。

- 参数：
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - spec : `[]const u8`
    - update : `BlockUpdate`
- 返回值类型：`core.Error!void`
- 对应槽位：[`set_extra_block`](../cpp/world.md#set_extra_block)

### `world.setBlockNbt` {#world.setBlockNbt}

```zig
pub fn setBlockNbt(dim: i32, x: i32, y: i32, z: i32, snbt: []const u8, update: BlockUpdate) core.Error!void
```

用序列化的 NBT 写入一个方块，格式就是 `getBlock` 产生的那种。

- 参数：
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - snbt : `[]const u8`
    - update : `BlockUpdate`
- 返回值类型：`core.Error!void`
- 对应槽位：[`edit_set_block_nbt`](../cpp/edit.md#edit_set_block_nbt)

### `world.setBlockStates` {#world.setBlockStates}

```zig
pub fn setBlockStates(dim: i32, x: i32, y: i32, z: i32, name: []const u8, states_snbt: []const u8, update: BlockUpdate) core.Error!void
```

用一个名字加可选的部分状态写入一个方块。`states_snbt` 为空表示每个状态都取默认值。

- 参数：
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - name : `[]const u8`
    - states_snbt : `[]const u8`
    - update : `BlockUpdate`
- 返回值类型：`core.Error!void`
- 对应槽位：[`edit_set_block_states`](../cpp/edit.md#edit_set_block_states)

### `world.setBlockEntity` {#world.setBlockEntity}

```zig
pub fn setBlockEntity(dim: i32, x: i32, y: i32, z: i32, snbt: []const u8) core.Error!void
```

把一个方块实体的 NBT 写回去。该格子里必须已经是对应的方块。

- 参数：
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - snbt : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`edit_set_block_entity`](../cpp/edit.md#edit_set_block_entity)

### `world.scan` {#world.scan}

```zig
pub fn scan(allocator: Allocator, dim: i32, bounds: Bounds) core.Error!Scan
```

扫描一个区域，把每个方块和每个实体收集到内存里。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - bounds : `Bounds`
- 返回值类型：`core.Error!Scan`
- 对应槽位：[`scan_region`](../cpp/world.md#scan_region)

### `world.scanIndexed` {#world.scanIndexed}

```zig
pub fn scanIndexed(allocator: Allocator, dim: i32, bounds: Bounds) core.Error!IndexedScan
```

把一个区域的方块扫描成调色板加格子。每种不同的方块状态只序列化一次，所以一百万个石头格子只花一次 SNBT 的代价，而不是一百万次。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - bounds : `Bounds`
- 返回值类型：`core.Error!IndexedScan`
- 对应槽位：[`scan_region_indexed`](../cpp/world.md#scan_region_indexed)

### `world.fillRegion` {#world.fillRegion}

```zig
pub fn fillRegion(dim: i32, bounds: Bounds, spec: []const u8, update: BlockUpdate) core.Error!u64
```

用同一种方块填满一个盒子，并返回写入了多少格。`spec` 是裸名字或完整的 SNBT，整个盒子只解析一次。

- 参数：
    - dim : `i32`
    - bounds : `Bounds`
    - spec : `[]const u8`
    - update : `BlockUpdate`
- 返回值类型：`core.Error!u64`
- 对应槽位：[`edit_fill_region`](../cpp/edit.md#edit_fill_region)

### `world.setBlocks` {#world.setBlocks}

```zig
pub fn setBlocks(allocator: Allocator, dim: i32, palette: []const []const u8, cells: []const BlockCell, update: BlockUpdate) core.Error!u64
```

一次调用写入许多格子，并返回写入了多少个。`palette` 的每一项是一个方块规格，只解析一次；索引超出范围、或方块没有解析出来的格子会被跳过。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
    - palette : `[]const []const u8`
    - cells : `[]const BlockCell`
    - update : `BlockUpdate`
- 返回值类型：`core.Error!u64`
- 对应槽位：[`edit_set_blocks`](../cpp/edit.md#edit_set_blocks)

### `world.spawnMob` {#world.spawnMob}

```zig
pub fn spawnMob(dim: i32, type_name: []const u8, x: f64, y: f64, z: f64) core.Error!props.Entity
```

生成一只生物并返回它。

- 参数：
    - dim : `i32`
    - type_name : `[]const u8`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- 返回值类型：`core.Error!props.Entity`
- 对应槽位：[`spawn_mob`](../cpp/entity.md#spawn_mob)

### `world.spawnEntityNbt` {#world.spawnEntityNbt}

```zig
pub fn spawnEntityNbt(dim: i32, snbt: []const u8, pos: ?types.Vec3) core.Error!props.Entity
```

用完整的 NBT 生成一个实体，是 `Entity.snapshot` 的逆操作。`pos` 会覆盖 Pos 标签。目前所有宿主都返回 `NotProvided`：让已加载实体获得新唯一 id 的引擎辅助函数无法访问。

- 参数：
    - dim : `i32`
    - snbt : `[]const u8`
    - pos : `?types.Vec3`
- 返回值类型：`core.Error!props.Entity`
- 对应槽位：[`edit_spawn_entity_nbt`](../cpp/edit.md#edit_spawn_entity_nbt)

### `world.explode` {#world.explode}

```zig
pub fn explode(dim: i32, x: f64, y: f64, z: f64, options: ExplodeOptions) core.Error!void
```

在一个点引爆。

- 参数：
    - dim : `i32`
    - x : `f64`
    - y : `f64`
    - z : `f64`
    - options : `ExplodeOptions`
- 返回值类型：`core.Error!void`
- 对应槽位：[`explode`](../cpp/world.md#explode)

### `world.spawnParticle` {#world.spawnParticle}

```zig
pub fn spawnParticle(dim: i32, effect: []const u8, x: f64, y: f64, z: f64) core.Error!void
```

整个维度都能看到的粒子。只给一个人看用 `spawnParticleFor`。

- 参数：
    - dim : `i32`
    - effect : `[]const u8`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`spawn_particle`](../cpp/world.md#spawn_particle)

### `world.spawnParticleFor` {#world.spawnParticleFor}

```zig
pub fn spawnParticleFor(player: props.Player, dim: i32, effect: []const u8, x: f64, y: f64, z: f64) core.Error!void
```

只给一名玩家看到的粒子。

- 参数：
    - player : `props.Player`
    - dim : `i32`
    - effect : `[]const u8`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`spawn_particle_for`](../cpp/world.md#spawn_particle_for)

### `world.playerPosition` {#world.playerPosition}

```zig
pub fn playerPosition(name: []const u8) core.Error!types.PlayerPosition
```

按名字查找一名已连接玩家的脚下位置和所在维度。

- 参数：
    - name : `[]const u8`
- 返回值类型：`core.Error!types.PlayerPosition`
- 对应槽位：[`get_player_position`](../cpp/player.md#get_player_position)

### `world.weatherValue` {#world.weatherValue}

```zig
pub fn weatherValue(dim: i32, prop: i32) core.Error!f64
```

按 PIER_WPROP_* 键读取一个维度的一项天气值。

- 参数：
    - dim : `i32`
    - prop : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`world_get_num`](../cpp/world.md#world_get_num)

### `world.rainLevel` {#world.rainLevel}

```zig
pub fn rainLevel(dim: i32) core.Error!f64
```

一个维度的降雨强度，0 表示无雨，1 表示满雨。

- 参数：
    - dim : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`world_get_num`](../cpp/world.md#world_get_num)

### `world.targetRainLevel` {#world.targetRainLevel}

```zig
pub fn targetRainLevel(dim: i32) core.Error!f64
```

- 参数：
    - dim : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`world_get_num`](../cpp/world.md#world_get_num)

### `world.lightningLevel` {#world.lightningLevel}

```zig
pub fn lightningLevel(dim: i32) core.Error!f64
```

一个维度的雷暴强度，0 表示无雷暴，1 表示雷暴。

- 参数：
    - dim : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`world_get_num`](../cpp/world.md#world_get_num)

### `world.targetLightningLevel` {#world.targetLightningLevel}

```zig
pub fn targetLightningLevel(dim: i32) core.Error!f64
```

- 参数：
    - dim : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`world_get_num`](../cpp/world.md#world_get_num)

### `world.fogLevel` {#world.fogLevel}

```zig
pub fn fogLevel(dim: i32) core.Error!f64
```

- 参数：
    - dim : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`world_get_num`](../cpp/world.md#world_get_num)

### `world.skyFlashTime` {#world.skyFlashTime}

```zig
pub fn skyFlashTime(dim: i32) core.Error!f64
```

- 参数：
    - dim : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`world_get_num`](../cpp/world.md#world_get_num)

## 声明 {#declarations}

### `world.Pos3` {#world.Pos3}

```zig
pub const Pos3 = types.Pos3;
```

### `world.Bounds` {#world.Bounds}

```zig
pub const Bounds = types.Bounds;
```

### `world.BlockUpdate` {#world.BlockUpdate}

```zig
pub const BlockUpdate = types.BlockUpdate;
```

## `world.Scan` {#world.Scan}

```zig
pub const Scan = struct {
    arena: std.heap.ArenaAllocator,
    blocks: []const BlockInfo,
    entities: []const EntityInfo,
    // ...
};
```

一次扫描的结果：区域里的每个方块，以及其中的每个实体。

### `world.Scan.deinit` {#world.Scan.deinit}

```zig
pub fn deinit(self: *Scan) void
```

- 返回值类型：`void`

### `world.Scan.nonAirCount` {#world.Scan.nonAirCount}

```zig
pub fn nonAirCount(self: *const Scan) usize
```

不是空气的格子数，按方块名判断。

- 返回值类型：`usize`

## `world.IndexedScan` {#world.IndexedScan}

```zig
pub const IndexedScan = struct {
    arena: std.heap.ArenaAllocator,
    palette: []const PaletteEntry,
    cells: []const BlockCell,
    // ...
};
```

一次 `scanIndexed` 的结果：每种不同的方块状态一份，以及每个位置一个指向调色板的索引。

### `world.IndexedScan.deinit` {#world.IndexedScan.deinit}

```zig
pub fn deinit(self: *IndexedScan) void
```

- 返回值类型：`void`

### `world.IndexedScan.blockOf` {#world.IndexedScan.blockOf}

```zig
pub fn blockOf(self: *const IndexedScan, cell: BlockCell) ?PaletteEntry
```

一个格子对应的调色板条目；索引不在调色板里时为 null。

- 参数：
    - cell : `BlockCell`
- 返回值类型：`?PaletteEntry`

## `world.GameRuleValue` {#world.GameRuleValue}

```zig
pub const GameRuleValue = union(enum) {
    boolean: bool,
    int: i64,
    float: f64,
    // ...
};
```

一条游戏规则的值。

## `world.SleepStatus` {#world.SleepStatus}

```zig
pub const SleepStatus = struct {
    sleeping: bool,
    total_players: i32,
    active_sleeping: i32,
    // ...
};
```

玩家们的睡眠状态。

## `world.Village` {#world.Village}

```zig
pub const Village = struct {
    uuid: []const u8,
    center: Pos3,
    bounds: Bounds,
    poi_count: i32,
    // ...
};
```

一个村庄。

## `world.Structure` {#world.Structure}

```zig
pub const Structure = struct {
    kind: []const u8,
    bounds: Bounds,
    // ...
};
```

一个硬编码的生成区域：要塞、女巫小屋、海底神殿或类似的结构。

## `world.BlockInfo` {#world.BlockInfo}

```zig
pub const BlockInfo = struct {
    x: i32,
    y: i32,
    z: i32,
    name: []const u8,
    snbt: []const u8,
    // ...
};
```

宿主报告的一个方块。

## `world.EntityInfo` {#world.EntityInfo}

```zig
pub const EntityInfo = struct {
    x: i32,
    y: i32,
    z: i32,
    type_name: []const u8,
    snbt: []const u8,
    // ...
};
```

扫描时落在区域里的一个实体。

## `world.PaletteEntry` {#world.PaletteEntry}

```zig
pub const PaletteEntry = struct {
    name: []const u8,
    snbt: []const u8,
    // ...
};
```

`scanIndexed` 遇到的一种不同的方块状态。

## `world.BlockCell` {#world.BlockCell}

```zig
pub const BlockCell = extern struct {
    x: i32,
    y: i32,
    z: i32,
    index: u32,
    // ...
};
```

`scanIndexed` 或 `setBlocks` 的一个格子：一个位置加上调色板里的一个索引。

## `world.ExplodeOptions` {#world.ExplodeOptions}

```zig
pub const ExplodeOptions = struct {
    radius: f32,
    max_resistance: f32 = 3.4028235e38,
    /// The actor blamed for the blast, or null for no source.
    source: ?props.Entity = null,
    fire: bool = false,
    breaks_blocks: bool = true,
    allow_underwater: bool = false,
    // ...
};
```

一次爆炸做什么、由谁引起。
