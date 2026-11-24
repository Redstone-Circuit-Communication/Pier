# Go: World

## Functions {#functions}

### `ScanRegion` {#ScanRegion}

```go
func ScanRegion(dim, x1, y1, z1, x2, y2, z2 int32) ([]BlockInfo, []EntityInfo, error)
```

ScanRegion reads every block and entity in a box. Server thread only.

- Parameters:
    - dim : `int32`
    - x1 : `int32`
    - y1 : `int32`
    - z1 : `int32`
    - x2 : `int32`
    - y2 : `int32`
    - z2 : `int32`
- Return type: `([]BlockInfo, []EntityInfo, error)`
- Slots: [`scan_region`](../cpp/world.md#scan_region)

### `ScanRegionIndexed` {#ScanRegionIndexed}

```go
func ScanRegionIndexed(dim, x1, y1, z1, x2, y2, z2 int32) ([]PaletteEntry, []BlockCell, error)
```

ScanRegionIndexed reads a box as a palette of distinct block states and the cells that index it, which is far smaller than ScanRegion for a large box. Server thread only.

- Parameters:
    - dim : `int32`
    - x1 : `int32`
    - y1 : `int32`
    - z1 : `int32`
    - x2 : `int32`
    - y2 : `int32`
    - z2 : `int32`
- Return type: `([]PaletteEntry, []BlockCell, error)`
- Slots: [`scan_region_indexed`](../cpp/world.md#scan_region_indexed)

### `GetBlock` {#GetBlock}

```go
func GetBlock(dim, x, y, z int32) (BlockInfo, error)
```

GetBlock reads the block at a cell. Server thread only.

- Parameters:
    - dim : `int32`
    - x : `int32`
    - y : `int32`
    - z : `int32`
- Return type: `(BlockInfo, error)`
- Slots: [`get_block`](../cpp/world.md#get_block)

### `Seed` {#Seed}

```go
func Seed() (int64, error)
```

Seed is the level seed.

- Return type: `(int64, error)`
- Slots: [`get_seed`](../cpp/world.md#get_seed)

### `Difficulty` {#Difficulty}

```go
func Difficulty() (int32, error)
```

Difficulty is the level difficulty, 0 peaceful to 3 hard.

- Return type: `(int32, error)`
- Slots: [`get_difficulty`](../cpp/world.md#get_difficulty)

### `SetDifficulty` {#SetDifficulty}

```go
func SetDifficulty(d int32) error
```

SetDifficulty sets the level difficulty.

- Parameters:
    - d : `int32`
- Return type: `error`
- Slots: [`set_difficulty`](../cpp/world.md#set_difficulty)

### `GameRule` {#GameRule}

```go
func GameRule(name string) (string, error)
```

GameRule reads a game rule as text.

- Parameters:
    - name : `string`
- Return type: `(string, error)`
- Slots: [`game_rule_get`](../cpp/world.md#game_rule_get)

### `SetGameRule` {#SetGameRule}

```go
func SetGameRule(name, value string) error
```

SetGameRule writes a game rule from text.

- Parameters:
    - name : `string`
    - value : `string`
- Return type: `error`
- Slots: [`game_rule_set`](../cpp/world.md#game_rule_set)

### `Time` {#Time}

```go
func Time() (int64, error)
```

Time is the time of day in ticks.

- Return type: `(int64, error)`
- Slots: [`get_time`](../cpp/world.md#get_time)

### `SetTime` {#SetTime}

```go
func SetTime(t int64) error
```

SetTime sets the time of day in ticks.

- Parameters:
    - t : `int64`
- Return type: `error`
- Slots: [`set_time`](../cpp/world.md#set_time)

### `SetWeather` {#SetWeather}

```go
func SetWeather(weather int32) error
```

SetWeather sets the weather: 0 clear, 1 rain, 2 thunder.

- Parameters:
    - weather : `int32`
- Return type: `error`
- Slots: [`set_weather`](../cpp/world.md#set_weather)

### `SaveLevel` {#SaveLevel}

```go
func SaveLevel() error
```

SaveLevel saves the level now.

- Return type: `error`
- Slots: [`level_save`](../cpp/world.md#level_save)

### `SpawnParticle` {#SpawnParticle}

```go
func SpawnParticle(dim int32, effect string, x, y, z float64) error
```

SpawnParticle shows a particle effect to everyone near it.

- Parameters:
    - dim : `int32`
    - effect : `string`
    - x : `float64`
    - y : `float64`
    - z : `float64`
- Return type: `error`
- Slots: [`spawn_particle`](../cpp/world.md#spawn_particle)

### `Explode` {#Explode}

```go
func Explode(dim int32, x, y, z float64, radius float32, o ExplodeOptions) error
```

Explode makes an explosion of the given radius.

- Parameters:
    - dim : `int32`
    - x : `float64`
    - y : `float64`
    - z : `float64`
    - radius : `float32`
    - o : `ExplodeOptions`
- Return type: `error`
- Slots: [`explode`](../cpp/world.md#explode)

### `DefaultSpawn` {#DefaultSpawn}

```go
func DefaultSpawn() (x, y, z int32, err error)
```

DefaultSpawn is the level's world spawn.

- Return type: `(x, y, z int32, err error)`
- Slots: [`level_get_default_spawn`](../cpp/world.md#level_get_default_spawn)

### `SetDefaultSpawn` {#SetDefaultSpawn}

```go
func SetDefaultSpawn(x, y, z int32) error
```

SetDefaultSpawn moves the level's world spawn.

- Parameters:
    - x : `int32`
    - y : `int32`
    - z : `int32`
- Return type: `error`
- Slots: [`level_set_default_spawn`](../cpp/world.md#level_set_default_spawn)

### `SetBiome` {#SetBiome}

```go
func SetBiome(dim, minX, minZ, maxX, maxZ int32, biome string) (int32, error)
```

SetBiome sets the biome of every column in a rectangle and returns how many changed.

- Parameters:
    - dim : `int32`
    - minX : `int32`
    - minZ : `int32`
    - maxX : `int32`
    - maxZ : `int32`
    - biome : `string`
- Return type: `(int32, error)`
- Slots: [`level_set_biome`](../cpp/world.md#level_set_biome)

### `FindPath` {#FindPath}

```go
func FindPath(who Entity, x, y, z int32) (*Nbt, error)
```

FindPath computes a path for an actor to a target cell, as the host's SNBT. Every current host answers not provided.

- Parameters:
    - who : `Entity`
    - x : `int32`
    - y : `int32`
    - z : `int32`
- Return type: `(*Nbt, error)`
- Slots: [`level_find_path`](../cpp/world.md#level_find_path)

### `UpdateWeather` {#UpdateWeather}

```go
func UpdateWeather(rainLevel float32, rainTicks int32, lightningLevel float32, lightningTicks int32) error
```

UpdateWeather sets the level and the remaining ticks of rain and of lightning.

- Parameters:
    - rainLevel : `float32`
    - rainTicks : `int32`
    - lightningLevel : `float32`
    - lightningTicks : `int32`
- Return type: `error`
- Slots: [`level_update_weather`](../cpp/world.md#level_update_weather)

### `LevelSleepStatus` {#LevelSleepStatus}

```go
func LevelSleepStatus() (SleepStatus, error)
```

LevelSleepStatus reads the sleep status of the players.

- Return type: `(SleepStatus, error)`
- Slots: [`level_get_sleep_status`](../cpp/world.md#level_get_sleep_status)

### `Villages` {#Villages}

```go
func Villages(dim int32) ([]Village, error)
```

Villages lists the villages of one dimension.

- Parameters:
    - dim : `int32`
- Return type: `([]Village, error)`
- Slots: [`villages`](../cpp/world.md#villages)

### `StructuresNear` {#StructuresNear}

```go
func StructuresNear(dim, x, y, z, radius int32) ([]Structure, error)
```

StructuresNear lists the hardcoded generation areas of the loaded chunks within a radius.

- Parameters:
    - dim : `int32`
    - x : `int32`
    - y : `int32`
    - z : `int32`
    - radius : `int32`
- Return type: `([]Structure, error)`
- Slots: [`structures_near`](../cpp/world.md#structures_near)

### `ChunksLoaded` {#ChunksLoaded}

```go
func ChunksLoaded(dim, minX, minZ, maxX, maxZ int32) (bool, error)
```

ChunksLoaded reports whether every chunk covered by the region is in memory.

- Parameters:
    - dim : `int32`
    - minX : `int32`
    - minZ : `int32`
    - maxX : `int32`
    - maxZ : `int32`
- Return type: `(bool, error)`
- Slots: [`level_chunks_loaded`](../cpp/world.md#level_chunks_loaded)

### `DeleteChunkKeys` {#DeleteChunkKeys}

```go
func DeleteChunkKeys(dim, chunkX, chunkZ int32) (int32, error)
```

DeleteChunkKeys deletes every save key of a chunk, so the engine regenerates it from the generator on its next load, and returns how many keys went. Only an unloaded chunk can be restored this way.

- Parameters:
    - dim : `int32`
    - chunkX : `int32`
    - chunkZ : `int32`
- Return type: `(int32, error)`
- Slots: [`level_delete_chunk_keys`](../cpp/world.md#level_delete_chunk_keys)

### `ChunkKeys` {#ChunkKeys}

```go
func ChunkKeys(dim, chunkX, chunkZ int32) ([]string, error)
```

ChunkKeys lists every save key of a chunk. A key is binary, and a Go string holds it as it is.

- Parameters:
    - dim : `int32`
    - chunkX : `int32`
    - chunkZ : `int32`
- Return type: `([]string, error)`
- Slots: [`level_chunk_keys`](../cpp/world.md#level_chunk_keys)

### `DeleteSaveKey` {#DeleteSaveKey}

```go
func DeleteSaveKey(key string) error
```

DeleteSaveKey deletes one save key byte for byte. The content is not interpreted.

- Parameters:
    - key : `string`
- Return type: `error`
- Slots: [`level_delete_key`](../cpp/world.md#level_delete_key)

### `WorldWeather` {#WorldWeather}

```go
func WorldWeather(dim, prop int32) (float64, error)
```

WorldWeather reads one PIER\_WPROP\_\* value of dimension dim. The error covers an unknown key, a dimension that does not exist and a level that is not ready.

- Parameters:
    - dim : `int32`
    - prop : `int32`
- Return type: `(float64, error)`

### `WorldRainLevel` {#WorldRainLevel}

```go
func WorldRainLevel(dim int32) (float64, error)
```

WorldRainLevel is the rain level of a dimension, 0 for none to 1 for full rain.

- Parameters:
    - dim : `int32`
- Return type: `(float64, error)`

### `WorldTargetRainLevel` {#WorldTargetRainLevel}

```go
func WorldTargetRainLevel(dim int32) (float64, error)
```

WorldTargetRainLevel reads `PIER_WPROP_TARGET_RAIN_LEVEL` of dimension dim.

- Parameters:
    - dim : `int32`
- Return type: `(float64, error)`

### `WorldLightningLevel` {#WorldLightningLevel}

```go
func WorldLightningLevel(dim int32) (float64, error)
```

WorldLightningLevel is the lightning level of a dimension, 0 for none to 1 for a storm.

- Parameters:
    - dim : `int32`
- Return type: `(float64, error)`

### `WorldTargetLightningLevel` {#WorldTargetLightningLevel}

```go
func WorldTargetLightningLevel(dim int32) (float64, error)
```

WorldTargetLightningLevel reads `PIER_WPROP_TARGET_LIGHTNING_LEVEL` of dimension dim.

- Parameters:
    - dim : `int32`
- Return type: `(float64, error)`

### `WorldFogLevel` {#WorldFogLevel}

```go
func WorldFogLevel(dim int32) (float64, error)
```

WorldFogLevel reads `PIER_WPROP_FOG_LEVEL` of dimension dim.

- Parameters:
    - dim : `int32`
- Return type: `(float64, error)`

### `WorldSkyFlashTime` {#WorldSkyFlashTime}

```go
func WorldSkyFlashTime(dim int32) (float64, error)
```

WorldSkyFlashTime reads `PIER_WPROP_SKY_FLASH_TIME` of dimension dim.

- Parameters:
    - dim : `int32`
- Return type: `(float64, error)`

## `EntityInfo` {#EntityInfo}

```go
type EntityInfo struct {
    X, Y, Z int32
    Type    string
    SNBT    string
}
```

EntityInfo is one entity a region scan found: the cell holding it, its type and its SNBT.

## `PaletteEntry` {#PaletteEntry}

```go
type PaletteEntry struct {
    Index uint32
    Name  string
    SNBT  string
}
```

PaletteEntry is one distinct block state of an indexed scan.

## `BlockCell` {#BlockCell}

```go
type BlockCell struct {
    X, Y, Z int32
    Index   uint32
}
```

BlockCell is one cell and an index into a palette, for ScanRegionIndexed and SetBlocks.

## `ExplodeOptions` {#ExplodeOptions}

```go
type ExplodeOptions struct {
    MaxResistance   float32
    Source          ActorID
    Fire            bool
    BreaksBlocks    bool
    AllowUnderwater bool
}
```

ExplodeOptions are the optional parts of an explosion.

## `SleepStatus` {#SleepStatus}

```go
type SleepStatus struct {
    Sleeping       bool
    TotalPlayers   int32
    ActiveSleeping int32
}
```

SleepStatus is how many players sleep.

## `Village` {#Village}

```go
type Village struct {
    UUID     string
    Center   [3]int32
    Min, Max [3]int32
    PoiCount int32
}
```

Village is one village.

## `Structure` {#Structure}

```go
type Structure struct {
    Kind     string
    Min, Max [3]int32
}
```

Structure is one hardcoded generation area: a stronghold, a witch hut, an ocean monument or a similar structure.
