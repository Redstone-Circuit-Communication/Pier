# Go：世界

## 函数 {#functions}

### `ScanRegion` {#ScanRegion}

```go
func ScanRegion(dim, x1, y1, z1, x2, y2, z2 int32) ([]BlockInfo, []EntityInfo, error)
```

读取一个长方体里的每个方块和实体。只能在服务器线程调用。

- 参数：
    - dim : `int32`
    - x1 : `int32`
    - y1 : `int32`
    - z1 : `int32`
    - x2 : `int32`
    - y2 : `int32`
    - z2 : `int32`
- 返回值类型：`([]BlockInfo, []EntityInfo, error)`
- 对应槽位：[`scan_region`](../cpp/world.md#scan_region)

### `ScanRegionIndexed` {#ScanRegionIndexed}

```go
func ScanRegionIndexed(dim, x1, y1, z1, x2, y2, z2 int32) ([]PaletteEntry, []BlockCell, error)
```

把一个长方体读成由不同方块状态组成的调色板，加上引用调色板的格子；长方体很大时，结果比 `ScanRegion` 小得多。只能在服务器线程调用。

- 参数：
    - dim : `int32`
    - x1 : `int32`
    - y1 : `int32`
    - z1 : `int32`
    - x2 : `int32`
    - y2 : `int32`
    - z2 : `int32`
- 返回值类型：`([]PaletteEntry, []BlockCell, error)`
- 对应槽位：[`scan_region_indexed`](../cpp/world.md#scan_region_indexed)

### `GetBlock` {#GetBlock}

```go
func GetBlock(dim, x, y, z int32) (BlockInfo, error)
```

读取一格的方块。只能在服务器线程调用。

- 参数：
    - dim : `int32`
    - x : `int32`
    - y : `int32`
    - z : `int32`
- 返回值类型：`(BlockInfo, error)`
- 对应槽位：[`get_block`](../cpp/world.md#get_block)

### `Seed` {#Seed}

```go
func Seed() (int64, error)
```

世界种子。

- 返回值类型：`(int64, error)`
- 对应槽位：[`get_seed`](../cpp/world.md#get_seed)

### `Difficulty` {#Difficulty}

```go
func Difficulty() (int32, error)
```

世界难度，从 0 和平到 3 困难。

- 返回值类型：`(int32, error)`
- 对应槽位：[`get_difficulty`](../cpp/world.md#get_difficulty)

### `SetDifficulty` {#SetDifficulty}

```go
func SetDifficulty(d int32) error
```

设置世界难度。

- 参数：
    - d : `int32`
- 返回值类型：`error`
- 对应槽位：[`set_difficulty`](../cpp/world.md#set_difficulty)

### `GameRule` {#GameRule}

```go
func GameRule(name string) (string, error)
```

以文本形式读取一条游戏规则。

- 参数：
    - name : `string`
- 返回值类型：`(string, error)`
- 对应槽位：[`game_rule_get`](../cpp/world.md#game_rule_get)

### `SetGameRule` {#SetGameRule}

```go
func SetGameRule(name, value string) error
```

以文本形式写入一条游戏规则。

- 参数：
    - name : `string`
    - value : `string`
- 返回值类型：`error`
- 对应槽位：[`game_rule_set`](../cpp/world.md#game_rule_set)

### `Time` {#Time}

```go
func Time() (int64, error)
```

一天中的时间，单位是刻。

- 返回值类型：`(int64, error)`
- 对应槽位：[`get_time`](../cpp/world.md#get_time)

### `SetTime` {#SetTime}

```go
func SetTime(t int64) error
```

设置一天中的时间，单位是刻。

- 参数：
    - t : `int64`
- 返回值类型：`error`
- 对应槽位：[`set_time`](../cpp/world.md#set_time)

### `SetWeather` {#SetWeather}

```go
func SetWeather(weather int32) error
```

设置天气：0 晴，1 雨，2 雷雨。

- 参数：
    - weather : `int32`
- 返回值类型：`error`
- 对应槽位：[`set_weather`](../cpp/world.md#set_weather)

### `SaveLevel` {#SaveLevel}

```go
func SaveLevel() error
```

立刻保存世界。

- 返回值类型：`error`
- 对应槽位：[`level_save`](../cpp/world.md#level_save)

### `SpawnParticle` {#SpawnParticle}

```go
func SpawnParticle(dim int32, effect string, x, y, z float64) error
```

向附近的所有人显示一个粒子效果。

- 参数：
    - dim : `int32`
    - effect : `string`
    - x : `float64`
    - y : `float64`
    - z : `float64`
- 返回值类型：`error`
- 对应槽位：[`spawn_particle`](../cpp/world.md#spawn_particle)

### `Explode` {#Explode}

```go
func Explode(dim int32, x, y, z float64, radius float32, o ExplodeOptions) error
```

按给定的半径制造一次爆炸。

- 参数：
    - dim : `int32`
    - x : `float64`
    - y : `float64`
    - z : `float64`
    - radius : `float32`
    - o : `ExplodeOptions`
- 返回值类型：`error`
- 对应槽位：[`explode`](../cpp/world.md#explode)

### `DefaultSpawn` {#DefaultSpawn}

```go
func DefaultSpawn() (x, y, z int32, err error)
```

世界的出生点。

- 返回值类型：`(x, y, z int32, err error)`
- 对应槽位：[`level_get_default_spawn`](../cpp/world.md#level_get_default_spawn)

### `SetDefaultSpawn` {#SetDefaultSpawn}

```go
func SetDefaultSpawn(x, y, z int32) error
```

移动世界的出生点。

- 参数：
    - x : `int32`
    - y : `int32`
    - z : `int32`
- 返回值类型：`error`
- 对应槽位：[`level_set_default_spawn`](../cpp/world.md#level_set_default_spawn)

### `SetBiome` {#SetBiome}

```go
func SetBiome(dim, minX, minZ, maxX, maxZ int32, biome string) (int32, error)
```

设置一个矩形内每一列的生物群系，返回改变了多少列。

- 参数：
    - dim : `int32`
    - minX : `int32`
    - minZ : `int32`
    - maxX : `int32`
    - maxZ : `int32`
    - biome : `string`
- 返回值类型：`(int32, error)`
- 对应槽位：[`level_set_biome`](../cpp/world.md#level_set_biome)

### `FindPath` {#FindPath}

```go
func FindPath(who Entity, x, y, z int32) (*Nbt, error)
```

FindPath 为一个实体计算前往目标格子的路径，结果是宿主的 SNBT。目前所有宿主都回答 not provided。

- 参数：
    - who : `Entity`
    - x : `int32`
    - y : `int32`
    - z : `int32`
- 返回值类型：`(*Nbt, error)`
- 对应槽位：[`level_find_path`](../cpp/world.md#level_find_path)

### `UpdateWeather` {#UpdateWeather}

```go
func UpdateWeather(rainLevel float32, rainTicks int32, lightningLevel float32, lightningTicks int32) error
```

UpdateWeather 设置雨和雷各自的强度与剩余 tick 数。

- 参数：
    - rainLevel : `float32`
    - rainTicks : `int32`
    - lightningLevel : `float32`
    - lightningTicks : `int32`
- 返回值类型：`error`
- 对应槽位：[`level_update_weather`](../cpp/world.md#level_update_weather)

### `LevelSleepStatus` {#LevelSleepStatus}

```go
func LevelSleepStatus() (SleepStatus, error)
```

LevelSleepStatus 读取玩家们的睡眠状态。

- 返回值类型：`(SleepStatus, error)`
- 对应槽位：[`level_get_sleep_status`](../cpp/world.md#level_get_sleep_status)

### `Villages` {#Villages}

```go
func Villages(dim int32) ([]Village, error)
```

Villages 列出一个维度里的村庄。

- 参数：
    - dim : `int32`
- 返回值类型：`([]Village, error)`
- 对应槽位：[`villages`](../cpp/world.md#villages)

### `StructuresNear` {#StructuresNear}

```go
func StructuresNear(dim, x, y, z, radius int32) ([]Structure, error)
```

StructuresNear 列出一个半径内、已加载区块里的硬编码生成区域。

- 参数：
    - dim : `int32`
    - x : `int32`
    - y : `int32`
    - z : `int32`
    - radius : `int32`
- 返回值类型：`([]Structure, error)`
- 对应槽位：[`structures_near`](../cpp/world.md#structures_near)

### `ChunksLoaded` {#ChunksLoaded}

```go
func ChunksLoaded(dim, minX, minZ, maxX, maxZ int32) (bool, error)
```

ChunksLoaded 报告区域覆盖的每个区块是否都在内存里。

- 参数：
    - dim : `int32`
    - minX : `int32`
    - minZ : `int32`
    - maxX : `int32`
    - maxZ : `int32`
- 返回值类型：`(bool, error)`
- 对应槽位：[`level_chunks_loaded`](../cpp/world.md#level_chunks_loaded)

### `DeleteChunkKeys` {#DeleteChunkKeys}

```go
func DeleteChunkKeys(dim, chunkX, chunkZ int32) (int32, error)
```

DeleteChunkKeys 删除一个区块的全部存档键，引擎会在下次加载它时从生成器重新生成，并返回删掉了多少个键。只有未加载的区块可以这样还原。

- 参数：
    - dim : `int32`
    - chunkX : `int32`
    - chunkZ : `int32`
- 返回值类型：`(int32, error)`
- 对应槽位：[`level_delete_chunk_keys`](../cpp/world.md#level_delete_chunk_keys)

### `ChunkKeys` {#ChunkKeys}

```go
func ChunkKeys(dim, chunkX, chunkZ int32) ([]string, error)
```

ChunkKeys 列出一个区块的全部存档键。键是二进制的，Go 字符串原样保存它。

- 参数：
    - dim : `int32`
    - chunkX : `int32`
    - chunkZ : `int32`
- 返回值类型：`([]string, error)`
- 对应槽位：[`level_chunk_keys`](../cpp/world.md#level_chunk_keys)

### `DeleteSaveKey` {#DeleteSaveKey}

```go
func DeleteSaveKey(key string) error
```

DeleteSaveKey 逐字节删除一个存档键。内容不会被解释。

- 参数：
    - key : `string`
- 返回值类型：`error`
- 对应槽位：[`level_delete_key`](../cpp/world.md#level_delete_key)

### `WorldWeather` {#WorldWeather}

```go
func WorldWeather(dim, prop int32) (float64, error)
```

WorldWeather 读取维度 dim 的一个 PIER_WPROP_* 值。键未知、维度不存在、或者 level 尚未就绪时返回错误。

- 参数：
    - dim : `int32`
    - prop : `int32`
- 返回值类型：`(float64, error)`

### `WorldRainLevel` {#WorldRainLevel}

```go
func WorldRainLevel(dim int32) (float64, error)
```

WorldRainLevel 是一个维度的降雨强度，0 表示无雨，1 表示满雨。

- 参数：
    - dim : `int32`
- 返回值类型：`(float64, error)`

### `WorldTargetRainLevel` {#WorldTargetRainLevel}

```go
func WorldTargetRainLevel(dim int32) (float64, error)
```

WorldTargetRainLevel 读取维度 dim 的 PIER_WPROP_TARGET_RAIN_LEVEL。

- 参数：
    - dim : `int32`
- 返回值类型：`(float64, error)`

### `WorldLightningLevel` {#WorldLightningLevel}

```go
func WorldLightningLevel(dim int32) (float64, error)
```

WorldLightningLevel 是一个维度的雷暴强度，0 表示无雷暴，1 表示雷暴。

- 参数：
    - dim : `int32`
- 返回值类型：`(float64, error)`

### `WorldTargetLightningLevel` {#WorldTargetLightningLevel}

```go
func WorldTargetLightningLevel(dim int32) (float64, error)
```

WorldTargetLightningLevel 读取维度 dim 的 PIER_WPROP_TARGET_LIGHTNING_LEVEL。

- 参数：
    - dim : `int32`
- 返回值类型：`(float64, error)`

### `WorldFogLevel` {#WorldFogLevel}

```go
func WorldFogLevel(dim int32) (float64, error)
```

WorldFogLevel 读取维度 dim 的 PIER_WPROP_FOG_LEVEL。

- 参数：
    - dim : `int32`
- 返回值类型：`(float64, error)`

### `WorldSkyFlashTime` {#WorldSkyFlashTime}

```go
func WorldSkyFlashTime(dim int32) (float64, error)
```

WorldSkyFlashTime 读取维度 dim 的 PIER_WPROP_SKY_FLASH_TIME。

- 参数：
    - dim : `int32`
- 返回值类型：`(float64, error)`

## `EntityInfo` {#EntityInfo}

```go
type EntityInfo struct {
    X, Y, Z int32
    Type    string
    SNBT    string
}
```

区域扫描找到的一个实体：它所在的格子、它的类型和它的 SNBT。

## `PaletteEntry` {#PaletteEntry}

```go
type PaletteEntry struct {
    Index uint32
    Name  string
    SNBT  string
}
```

带索引扫描里的一种不同的方块状态。

## `BlockCell` {#BlockCell}

```go
type BlockCell struct {
    X, Y, Z int32
    Index   uint32
}
```

一个格子加上调色板里的一个索引，供 `ScanRegionIndexed` 和 `SetBlocks` 使用。

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

爆炸的可选部分。

## `SleepStatus` {#SleepStatus}

```go
type SleepStatus struct {
    Sleeping       bool
    TotalPlayers   int32
    ActiveSleeping int32
}
```

SleepStatus 表示有多少玩家在睡觉。

## `Village` {#Village}

```go
type Village struct {
    UUID     string
    Center   [3]int32
    Min, Max [3]int32
    PoiCount int32
}
```

Village 是一个村庄。

## `Structure` {#Structure}

```go
type Structure struct {
    Kind     string
    Min, Max [3]int32
}
```

Structure 是一个硬编码的生成区域：要塞、女巫小屋、海底神殿或类似的结构。
