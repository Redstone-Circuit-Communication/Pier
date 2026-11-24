# Go：自定义维度

## 函数 {#functions}

### `AddGeneratedDimension` {#AddGeneratedDimension}

```go
func AddGeneratedDimension(name, spec string, materials, biomes []string, fill func(*ChunkRequest) bool) (int32, error)
```

注册一个由 `fill` 写入地形的维度，返回它的 id。

`fill` 在宿主的区块工作线程上运行，同时可能有好几个：它必须能并发运行，对同一个区块永远给出同样的结果，并且除了请求本身，不调用这个包里的任何东西。返回 false 时，这个区块留给空气。`materials[0]` 必须是 `"minecraft:air"`。这个函数在维度的整个生命期里都会被保留。

- 参数：
    - name : `string`
    - spec : `string`
    - materials : `[]string`
    - biomes : `[]string`
    - fill : `func(*ChunkRequest) bool`
- 返回值类型：`(int32, error)`
- 对应槽位：[`md_add_dimension_generated`](../cpp/dimensions.md#md_add_dimension_generated)

### `DimensionsAvailable` {#DimensionsAvailable}

```go
func DimensionsAvailable() (bool, error)
```

判断这个宿主能不能注册自定义维度。

- 返回值类型：`(bool, error)`
- 对应槽位：[`md_is_available`](../cpp/dimensions.md#md_is_available)

### `AddDimension` {#AddDimension}

```go
func AddDimension(name, spec string) (int32, error)
```

用描述 SNBT 注册一个维度，返回它的 id。

- 参数：
    - name : `string`
    - spec : `string`
- 返回值类型：`(int32, error)`
- 对应槽位：[`md_add_dimension`](../cpp/dimensions.md#md_add_dimension)

### `DimensionID` {#DimensionID}

```go
func DimensionID(name string) (int32, error)
```

一个已注册维度的 id。

- 参数：
    - name : `string`
- 返回值类型：`(int32, error)`
- 对应槽位：[`md_get_dimension_id`](../cpp/dimensions.md#md_get_dimension_id)

### `ListDimensions` {#ListDimensions}

```go
func ListDimensions() ([]string, error)
```

列出已注册的自定义维度。

- 返回值类型：`([]string, error)`
- 对应槽位：[`md_list_dimensions`](../cpp/dimensions.md#md_list_dimensions)

### `SetDimensionRule` {#SetDimensionRule}

```go
func SetDimensionRule(dim, rule int32, allow bool) error
```

为一个维度设置一条规则，规则是某个 `PIER_DIMRULE_*` 值。

- 参数：
    - dim : `int32`
    - rule : `int32`
    - allow : `bool`
- 返回值类型：`error`
- 对应槽位：[`md_set_dimension_rule`](../cpp/dimensions.md#md_set_dimension_rule)

### `DimensionRule` {#DimensionRule}

```go
func DimensionRule(dim, rule int32) (allow, set bool, err error)
```

读取一条规则；这个维度在这条规则上沿用原版行为时 `set` 为 false，比这条规则更旧的宿主也这样回答。

- 参数：
    - dim : `int32`
    - rule : `int32`
- 返回值类型：`(allow, set bool, err error)`
- 对应槽位：[`md_get_dimension_rule`](../cpp/dimensions.md#md_get_dimension_rule)

### `ExistingDimensions` {#ExistingDimensions}

```go
func ExistingDimensions() ([]ExistingDimension, error)
```

ExistingDimensions 列出每个已注册的自定义维度。

- 返回值类型：`([]ExistingDimension, error)`
- 对应槽位：[`md_list_dimensions`](../cpp/dimensions.md#md_list_dimensions)

### `AddDimensionPack` {#AddDimensionPack}

```go
func AddDimensionPack(name, configPath, specSNBT string) (int32, error)
```

AddDimensionPack 添加一个地形来自地形包的自定义维度：地形包是一个目录，里面有一个配置文件和一个由 tools/pier-pack 生成的二进制文件。configPath 相对于服务器根目录，使用正斜杠，不含 ..，也不是绝对路径。被拒绝时错误是 *PackError。

- 参数：
    - name : `string`
    - configPath : `string`
    - specSNBT : `string`
- 返回值类型：`(int32, error)`
- 对应槽位：[`md_add_dimension_pack`](../cpp/dimensions.md#md_add_dimension_pack)

### `InspectPack` {#InspectPack}

```go
func InspectPack(configPath string) (string, error)
```

InspectPack 以 JSON 文档的形式读取一个地形包提出的要求，不会注册任何东西。被拒绝时错误是 *PackError。

- 参数：
    - configPath : `string`
- 返回值类型：`(string, error)`
- 对应槽位：[`md_pack_inspect`](../cpp/dimensions.md#md_pack_inspect)

### `RetireDimension` {#RetireDimension}

```go
func RetireDimension(name string) (bool, error)
```

RetireDimension 注销一个自定义维度：把它从宿主的表和 dimension_config.json 里去掉，下次启动时就不会再有东西注册它。它写出的区块保留。返回是否存在这个名字的已注册维度。

- 参数：
    - name : `string`
- 返回值类型：`(bool, error)`
- 对应槽位：[`md_retire_dimension`](../cpp/dimensions.md#md_retire_dimension)

### `ClearDimensionRules` {#ClearDimensionRules}

```go
func ClearDimensionRules(dim int32) error
```

ClearDimensionRules 清除一个维度的全部规则，用于它的世界被删除之后。

- 参数：
    - dim : `int32`
- 返回值类型：`error`
- 对应槽位：[`md_clear_dimension_rules`](../cpp/dimensions.md#md_clear_dimension_rules)

### `SetDimensionCells` {#SetDimensionCells}

```go
func SetDimensionCells(dimID, cell, gap int32) error
```

SetDimensionCells 给一个生成出来的维度设置它的限制规则所用的单元几何：cell 是单元的边长，gap 是单元之间的间隔，单位都是方块。cell 为 0 表示去掉这个几何。

- 参数：
    - dimID : `int32`
    - cell : `int32`
    - gap : `int32`
- 返回值类型：`error`
- 对应槽位：[`md_set_dimension_cells`](../cpp/dimensions.md#md_set_dimension_cells)

### `NewPlotMerge` {#NewPlotMerge}

```go
func NewPlotMerge(x, z int32, north, east, south, west bool) PlotMerge
```

NewPlotMerge 按北、东、南、西的顺序，用四个方向拼出一个掩码。

- 参数：
    - x : `int32`
    - z : `int32`
    - north : `bool`
    - east : `bool`
    - south : `bool`
    - west : `bool`
- 返回值类型：`PlotMerge`

### `SetPlotMerges` {#SetPlotMerges}

```go
func SetPlotMerges(dim int32, merges []PlotMerge) error
```

SetPlotMerges 整体替换一个维度的合并标记。只需要列出带标记的地块。

- 参数：
    - dim : `int32`
    - merges : `[]PlotMerge`
- 返回值类型：`error`
- 对应槽位：[`md_set_plot_merges`](../cpp/dimensions.md#md_set_plot_merges)

## `PackError` {#PackError}

```go
type PackError struct {
    Status   int32
    Problems string
}
```

PackError 是对一个地形包的拒绝：宿主给出的 PIER_PACK_* 状态，以及它写了原因的话，它的原因。

### `PackError.Error` {#PackError.Error}

```go
func (e *PackError) Error() string
```

- 返回值类型：`string`

## `ChunkRequest` {#ChunkRequest}

```go
type ChunkRequest struct {
    Dim, ChunkX, ChunkZ int32
    MinY, Height        int32
    Materials           []uint16
    Biomes              []uint16
}
```

自供地形的生成器要填充的一个区块。`Materials` 有 `256*Height` 项，下标是 `(x*16+z)*Height + (y-MinY)`；`Biomes` 有 256 项，每列一项；两者存的都是注册时给出的调色板里的索引，材料 0 是空气。

## `ExistingDimension` {#ExistingDimension}

```go
type ExistingDimension struct {
    Name string `json:"name"`
    Dim  int32  `json:"dim"`
    SNBT string `json:"snbt"`
}
```

ExistingDimension 是一个已注册的自定义维度。

## `PlotMerge` {#PlotMerge}

```go
type PlotMerge struct {
    X, Z int32
    // Mask is a bitset: 1 north, 2 east, 4 south, 8 west.
    Mask uint32
}
```

PlotMerge 保存一个地块的合并标记。
