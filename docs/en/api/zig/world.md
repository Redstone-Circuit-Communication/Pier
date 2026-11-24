# Zig: World

## Functions {#functions}

### `world.time` {#world.time}

```zig
pub fn time() core.Error!i64
```

The world time in ticks.

- Return type: `core.Error!i64`
- Slots: [`get_time`](../cpp/world.md#get_time)

### `world.setTime` {#world.setTime}

```zig
pub fn setTime(t: i64) core.Error!void
```

Sets the world time natively.

- Parameters:
    - t : `i64`
- Return type: `core.Error!void`
- Slots: [`set_time`](../cpp/world.md#set_time)

### `world.setWeather` {#world.setWeather}

```zig
pub fn setWeather(weather: types.Weather) core.Error!void
```

- Parameters:
    - weather : `types.Weather`
- Return type: `core.Error!void`
- Slots: [`set_weather`](../cpp/world.md#set_weather)

### `world.updateWeather` {#world.updateWeather}

```zig
pub fn updateWeather(rain_level: f32, rain_ticks: i32, lightning_level: f32, lightning_ticks: i32) core.Error!void
```

Sets the level and the remaining duration, in ticks, of rain and of lightning.

- Parameters:
    - rain_level : `f32`
    - rain_ticks : `i32`
    - lightning_level : `f32`
    - lightning_ticks : `i32`
- Return type: `core.Error!void`
- Slots: [`level_update_weather`](../cpp/world.md#level_update_weather)

### `world.difficulty` {#world.difficulty}

```zig
pub fn difficulty() core.Error!types.Difficulty
```

- Return type: `core.Error!types.Difficulty`
- Slots: [`get_difficulty`](../cpp/world.md#get_difficulty)

### `world.setDifficulty` {#world.setDifficulty}

```zig
pub fn setDifficulty(d: types.Difficulty) core.Error!void
```

- Parameters:
    - d : `types.Difficulty`
- Return type: `core.Error!void`
- Slots: [`set_difficulty`](../cpp/world.md#set_difficulty)

### `world.seed` {#world.seed}

```zig
pub fn seed() core.Error!i64
```

- Return type: `core.Error!i64`
- Slots: [`get_seed`](../cpp/world.md#get_seed)

### `world.gameRule` {#world.gameRule}

```zig
pub fn gameRule(allocator: Allocator, name: []const u8) core.Error!GameRuleValue
```

Reads one game rule. An unrecognized rule name is NoAnswer and not some default value.

- Parameters:
    - allocator : `Allocator`
    - name : `[]const u8`
- Return type: `core.Error!GameRuleValue`
- Slots: [`game_rule_get`](../cpp/world.md#game_rule_get)

### `world.setGameRule` {#world.setGameRule}

```zig
pub fn setGameRule(name: []const u8, value: []const u8) core.Error!void
```

Writes one game rule from its text form, such as "true" or "300".

- Parameters:
    - name : `[]const u8`
    - value : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`game_rule_set`](../cpp/world.md#game_rule_set)

### `world.defaultSpawn` {#world.defaultSpawn}

```zig
pub fn defaultSpawn() core.Error!Pos3
```

- Return type: `core.Error!Pos3`
- Slots: [`level_get_default_spawn`](../cpp/world.md#level_get_default_spawn)

### `world.setDefaultSpawn` {#world.setDefaultSpawn}

```zig
pub fn setDefaultSpawn(x: i32, y: i32, z: i32) core.Error!void
```

- Parameters:
    - x : `i32`
    - y : `i32`
    - z : `i32`
- Return type: `core.Error!void`
- Slots: [`level_set_default_spawn`](../cpp/world.md#level_set_default_spawn)

### `world.save` {#world.save}

```zig
pub fn save() core.Error!void
```

Saves to disk immediately.

- Return type: `core.Error!void`
- Slots: [`level_save`](../cpp/world.md#level_save)

### `world.sleepStatus` {#world.sleepStatus}

```zig
pub fn sleepStatus(allocator: Allocator) core.Error!SleepStatus
```

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!SleepStatus`
- Slots: [`level_get_sleep_status`](../cpp/world.md#level_get_sleep_status)

### `world.biome` {#world.biome}

```zig
pub fn biome(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error![]u8
```

The biome name at one cell, owned by the caller.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- Return type: `core.Error![]u8`
- Slots: [`level_get_biome`](../cpp/world.md#level_get_biome)

### `world.setBiome` {#world.setBiome}

```zig
pub fn setBiome(dim: i32, from_x: i32, from_z: i32, to_x: i32, to_z: i32, biome_name: []const u8) core.Error!i32
```

Sets the biome of a region, column by column, and returns how many columns were set.

The corners are given in either order and no y is taken, since Bedrock stores biomes per column. A return of 0 means none were set.

- Parameters:
    - dim : `i32`
    - from_x : `i32`
    - from_z : `i32`
    - to_x : `i32`
    - to_z : `i32`
    - biome_name : `[]const u8`
- Return type: `core.Error!i32`
- Slots: [`level_set_biome`](../cpp/world.md#level_set_biome)

### `world.villages` {#world.villages}

```zig
pub fn villages(allocator: Allocator, dim: i32) core.Error!types.Owned(Village)
```

The villages in one dimension.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
- Return type: `core.Error!types.Owned(Village)`
- Slots: [`villages`](../cpp/world.md#villages)

### `world.structuresNear` {#world.structuresNear}

```zig
pub fn structuresNear(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32, radius: i32) core.Error!types.Owned(Structure)
```

The hardcoded generation areas in the loaded chunks within a radius.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - radius : `i32`
- Return type: `core.Error!types.Owned(Structure)`
- Slots: [`structures_near`](../cpp/world.md#structures_near)

### `world.chunksLoaded` {#world.chunksLoaded}

```zig
pub fn chunksLoaded(dim: i32, min_x: i32, min_z: i32, max_x: i32, max_z: i32) core.Error!bool
```

Whether every chunk covered by the region is in memory.

- Parameters:
    - dim : `i32`
    - min_x : `i32`
    - min_z : `i32`
    - max_x : `i32`
    - max_z : `i32`
- Return type: `core.Error!bool`
- Slots: [`level_chunks_loaded`](../cpp/world.md#level_chunks_loaded)

### `world.deleteChunkKeys` {#world.deleteChunkKeys}

```zig
pub fn deleteChunkKeys(dim: i32, chunk_x: i32, chunk_z: i32) core.Error!i32
```

Deletes every save key of a chunk, so the engine regenerates it from the generator on its next load. Only an unloaded chunk can be restored this way. Returns how many keys went.

- Parameters:
    - dim : `i32`
    - chunk_x : `i32`
    - chunk_z : `i32`
- Return type: `core.Error!i32`
- Slots: [`level_delete_chunk_keys`](../cpp/world.md#level_delete_chunk_keys)

### `world.chunkKeys` {#world.chunkKeys}

```zig
pub fn chunkKeys(allocator: Allocator, dim: i32, chunk_x: i32, chunk_z: i32) core.Error![][]u8
```

Lists every save key of a chunk, each owned by the caller with the slice holding them.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - chunk_x : `i32`
    - chunk_z : `i32`
- Return type: `core.Error![][]u8`
- Slots: [`level_chunk_keys`](../cpp/world.md#level_chunk_keys)

### `world.deleteKey` {#world.deleteKey}

```zig
pub fn deleteKey(key: []const u8) core.Error!void
```

Deletes one save key byte for byte. The content is not interpreted.

- Parameters:
    - key : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`level_delete_key`](../cpp/world.md#level_delete_key)

### `world.findPath` {#world.findPath}

```zig
pub fn findPath(allocator: Allocator, who: props.Entity, x: i32, y: i32, z: i32) core.Error![]u8
```

Computes a path for an actor to a target cell, as the host's SNBT `{nodes, reached}`. Every current host answers NotProvided: pathfinding is not implemented.

- Parameters:
    - allocator : `Allocator`
    - who : `props.Entity`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- Return type: `core.Error![]u8`
- Slots: [`level_find_path`](../cpp/world.md#level_find_path)

### `world.getBlock` {#world.getBlock}

```zig
pub fn getBlock(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error!types.Owned(BlockInfo)
```

Reads one block. The name and the SNBT belong to the arena inside the result.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- Return type: `core.Error!types.Owned(BlockInfo)`
- Slots: [`get_block`](../cpp/world.md#get_block)

### `world.setBlock` {#world.setBlock}

```zig
pub fn setBlock(dim: i32, x: i32, y: i32, z: i32, spec: []const u8) core.Error!void
```

Places a block natively with the default update flags. `spec` is a bare name such as "minecraft:stone", or full SNBT. An unknown name fails instead of placing a placeholder.

- Parameters:
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - spec : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`set_block`](../cpp/world.md#set_block)

### `world.getExtraBlock` {#world.getExtraBlock}

```zig
pub fn getExtraBlock(allocator: Allocator, dim: i32, x: i32, y: i32, z: i32) core.Error![]u8
```

Reads the liquid layer of a cell as a block name; an empty layer gives air.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- Return type: `core.Error![]u8`
- Slots: [`get_extra_block`](../cpp/world.md#get_extra_block)

### `world.setExtraBlock` {#world.setExtraBlock}

```zig
pub fn setExtraBlock(dim: i32, x: i32, y: i32, z: i32, spec: []const u8, update: BlockUpdate) core.Error!void
```

Writes the liquid layer of a cell; write "minecraft:air" to clear it.

- Parameters:
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - spec : `[]const u8`
    - update : `BlockUpdate`
- Return type: `core.Error!void`
- Slots: [`set_extra_block`](../cpp/world.md#set_extra_block)

### `world.setBlockNbt` {#world.setBlockNbt}

```zig
pub fn setBlockNbt(dim: i32, x: i32, y: i32, z: i32, snbt: []const u8, update: BlockUpdate) core.Error!void
```

Writes a block from serialized NBT, the shape `getBlock` produces.

- Parameters:
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - snbt : `[]const u8`
    - update : `BlockUpdate`
- Return type: `core.Error!void`
- Slots: [`edit_set_block_nbt`](../cpp/edit.md#edit_set_block_nbt)

### `world.setBlockStates` {#world.setBlockStates}

```zig
pub fn setBlockStates(dim: i32, x: i32, y: i32, z: i32, name: []const u8, states_snbt: []const u8, update: BlockUpdate) core.Error!void
```

Writes a block from a name and optional partial states. An empty `states_snbt` means every state at its default.

- Parameters:
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - name : `[]const u8`
    - states_snbt : `[]const u8`
    - update : `BlockUpdate`
- Return type: `core.Error!void`
- Slots: [`edit_set_block_states`](../cpp/edit.md#edit_set_block_states)

### `world.setBlockEntity` {#world.setBlockEntity}

```zig
pub fn setBlockEntity(dim: i32, x: i32, y: i32, z: i32, snbt: []const u8) core.Error!void
```

Writes a block entity's NBT back. The cell must already hold the matching block.

- Parameters:
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - snbt : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`edit_set_block_entity`](../cpp/edit.md#edit_set_block_entity)

### `world.scan` {#world.scan}

```zig
pub fn scan(allocator: Allocator, dim: i32, bounds: Bounds) core.Error!Scan
```

Scans a region and collects every block and actor into memory.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - bounds : `Bounds`
- Return type: `core.Error!Scan`
- Slots: [`scan_region`](../cpp/world.md#scan_region)

### `world.scanIndexed` {#world.scanIndexed}

```zig
pub fn scanIndexed(allocator: Allocator, dim: i32, bounds: Bounds) core.Error!IndexedScan
```

Scans the blocks of a region into a palette plus cells. Each distinct block state is serialized once, so a region of a million stone cells costs one SNBT and not a million.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - bounds : `Bounds`
- Return type: `core.Error!IndexedScan`
- Slots: [`scan_region_indexed`](../cpp/world.md#scan_region_indexed)

### `world.fillRegion` {#world.fillRegion}

```zig
pub fn fillRegion(dim: i32, bounds: Bounds, spec: []const u8, update: BlockUpdate) core.Error!u64
```

Fills a box with one block and returns how many cells were written. `spec` is a bare name or full SNBT, resolved once for the whole box.

- Parameters:
    - dim : `i32`
    - bounds : `Bounds`
    - spec : `[]const u8`
    - update : `BlockUpdate`
- Return type: `core.Error!u64`
- Slots: [`edit_fill_region`](../cpp/edit.md#edit_fill_region)

### `world.setBlocks` {#world.setBlocks}

```zig
pub fn setBlocks(allocator: Allocator, dim: i32, palette: []const []const u8, cells: []const BlockCell, update: BlockUpdate) core.Error!u64
```

Writes many cells in one call and returns how many were written. Each entry of `palette` is a block spec resolved once; a cell whose index is out of range, or whose block did not resolve, is skipped.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
    - palette : `[]const []const u8`
    - cells : `[]const BlockCell`
    - update : `BlockUpdate`
- Return type: `core.Error!u64`
- Slots: [`edit_set_blocks`](../cpp/edit.md#edit_set_blocks)

### `world.spawnMob` {#world.spawnMob}

```zig
pub fn spawnMob(dim: i32, type_name: []const u8, x: f64, y: f64, z: f64) core.Error!props.Entity
```

Spawns a mob and returns it.

- Parameters:
    - dim : `i32`
    - type_name : `[]const u8`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- Return type: `core.Error!props.Entity`
- Slots: [`spawn_mob`](../cpp/entity.md#spawn_mob)

### `world.spawnEntityNbt` {#world.spawnEntityNbt}

```zig
pub fn spawnEntityNbt(dim: i32, snbt: []const u8, pos: ?types.Vec3) core.Error!props.Entity
```

Spawns an actor from full NBT, the inverse of `Entity.snapshot`. A `pos` overrides the Pos tag. Every current host answers NotProvided: the engine helper that gives a loaded actor a fresh unique id is not reachable.

- Parameters:
    - dim : `i32`
    - snbt : `[]const u8`
    - pos : `?types.Vec3`
- Return type: `core.Error!props.Entity`
- Slots: [`edit_spawn_entity_nbt`](../cpp/edit.md#edit_spawn_entity_nbt)

### `world.explode` {#world.explode}

```zig
pub fn explode(dim: i32, x: f64, y: f64, z: f64, options: ExplodeOptions) core.Error!void
```

Detonates at a point.

- Parameters:
    - dim : `i32`
    - x : `f64`
    - y : `f64`
    - z : `f64`
    - options : `ExplodeOptions`
- Return type: `core.Error!void`
- Slots: [`explode`](../cpp/world.md#explode)

### `world.spawnParticle` {#world.spawnParticle}

```zig
pub fn spawnParticle(dim: i32, effect: []const u8, x: f64, y: f64, z: f64) core.Error!void
```

A particle visible across the whole dimension. Showing it to one person only uses `spawnParticleFor`.

- Parameters:
    - dim : `i32`
    - effect : `[]const u8`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- Return type: `core.Error!void`
- Slots: [`spawn_particle`](../cpp/world.md#spawn_particle)

### `world.spawnParticleFor` {#world.spawnParticleFor}

```zig
pub fn spawnParticleFor(player: props.Player, dim: i32, effect: []const u8, x: f64, y: f64, z: f64) core.Error!void
```

A particle shown to one player.

- Parameters:
    - player : `props.Player`
    - dim : `i32`
    - effect : `[]const u8`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- Return type: `core.Error!void`
- Slots: [`spawn_particle_for`](../cpp/world.md#spawn_particle_for)

### `world.playerPosition` {#world.playerPosition}

```zig
pub fn playerPosition(name: []const u8) core.Error!types.PlayerPosition
```

Looks up the feet position and dimension of a connected player by name.

- Parameters:
    - name : `[]const u8`
- Return type: `core.Error!types.PlayerPosition`
- Slots: [`get_player_position`](../cpp/player.md#get_player_position)

### `world.weatherValue` {#world.weatherValue}

```zig
pub fn weatherValue(dim: i32, prop: i32) core.Error!f64
```

One weather value of a dimension by its PIER\_WPROP\_\* key.

- Parameters:
    - dim : `i32`
    - prop : `i32`
- Return type: `core.Error!f64`
- Slots: [`world_get_num`](../cpp/world.md#world_get_num)

### `world.rainLevel` {#world.rainLevel}

```zig
pub fn rainLevel(dim: i32) core.Error!f64
```

The rain level of a dimension, 0 for none to 1 for full rain.

- Parameters:
    - dim : `i32`
- Return type: `core.Error!f64`
- Slots: [`world_get_num`](../cpp/world.md#world_get_num)

### `world.targetRainLevel` {#world.targetRainLevel}

```zig
pub fn targetRainLevel(dim: i32) core.Error!f64
```

- Parameters:
    - dim : `i32`
- Return type: `core.Error!f64`
- Slots: [`world_get_num`](../cpp/world.md#world_get_num)

### `world.lightningLevel` {#world.lightningLevel}

```zig
pub fn lightningLevel(dim: i32) core.Error!f64
```

The lightning level of a dimension, 0 for none to 1 for a storm.

- Parameters:
    - dim : `i32`
- Return type: `core.Error!f64`
- Slots: [`world_get_num`](../cpp/world.md#world_get_num)

### `world.targetLightningLevel` {#world.targetLightningLevel}

```zig
pub fn targetLightningLevel(dim: i32) core.Error!f64
```

- Parameters:
    - dim : `i32`
- Return type: `core.Error!f64`
- Slots: [`world_get_num`](../cpp/world.md#world_get_num)

### `world.fogLevel` {#world.fogLevel}

```zig
pub fn fogLevel(dim: i32) core.Error!f64
```

- Parameters:
    - dim : `i32`
- Return type: `core.Error!f64`
- Slots: [`world_get_num`](../cpp/world.md#world_get_num)

### `world.skyFlashTime` {#world.skyFlashTime}

```zig
pub fn skyFlashTime(dim: i32) core.Error!f64
```

- Parameters:
    - dim : `i32`
- Return type: `core.Error!f64`
- Slots: [`world_get_num`](../cpp/world.md#world_get_num)

## Declarations {#declarations}

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

The result of one scan: every block of the region and every actor inside it.

### `world.Scan.deinit` {#world.Scan.deinit}

```zig
pub fn deinit(self: *Scan) void
```

- Return type: `void`

### `world.Scan.nonAirCount` {#world.Scan.nonAirCount}

```zig
pub fn nonAirCount(self: *const Scan) usize
```

Cells that are not air, by block name.

- Return type: `usize`

## `world.IndexedScan` {#world.IndexedScan}

```zig
pub const IndexedScan = struct {
    arena: std.heap.ArenaAllocator,
    palette: []const PaletteEntry,
    cells: []const BlockCell,
    // ...
};
```

The result of one `scanIndexed`: every distinct block state once, and one cell for each position holding an index into the palette.

### `world.IndexedScan.deinit` {#world.IndexedScan.deinit}

```zig
pub fn deinit(self: *IndexedScan) void
```

- Return type: `void`

### `world.IndexedScan.blockOf` {#world.IndexedScan.blockOf}

```zig
pub fn blockOf(self: *const IndexedScan, cell: BlockCell) ?PaletteEntry
```

The palette entry of a cell, or null for an index the palette does not have.

- Parameters:
    - cell : `BlockCell`
- Return type: `?PaletteEntry`

## `world.GameRuleValue` {#world.GameRuleValue}

```zig
pub const GameRuleValue = union(enum) {
    boolean: bool,
    int: i64,
    float: f64,
    // ...
};
```

The value of one game rule.

## `world.SleepStatus` {#world.SleepStatus}

```zig
pub const SleepStatus = struct {
    sleeping: bool,
    total_players: i32,
    active_sleeping: i32,
    // ...
};
```

The sleep status of the players.

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

One village.

## `world.Structure` {#world.Structure}

```zig
pub const Structure = struct {
    kind: []const u8,
    bounds: Bounds,
    // ...
};
```

One hardcoded generation area: a stronghold, a witch hut, an ocean monument or a similar structure.

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

One block as the host reports it.

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

One actor that fell inside the region during a scan.

## `world.PaletteEntry` {#world.PaletteEntry}

```zig
pub const PaletteEntry = struct {
    name: []const u8,
    snbt: []const u8,
    // ...
};
```

One distinct block state met by `scanIndexed`.

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

One cell of `scanIndexed` or `setBlocks`: a position and an index into a palette.

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

What an explosion does and who caused it.
