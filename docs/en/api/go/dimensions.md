# Go: Custom dimensions

## Functions {#functions}

### `AddGeneratedDimension` {#AddGeneratedDimension}

```go
func AddGeneratedDimension(name, spec string, materials, biomes []string, fill func(*ChunkRequest) bool) (int32, error)
```

AddGeneratedDimension registers a dimension whose terrain fill writes, and returns its id.

fill runs on the host's chunk worker threads, several at once: it must be safe to run concurrently, give the same answer for the same chunk forever, and call nothing on this package but the request itself. Returning false leaves the chunk to air. materials\[0\] must be "minecraft:air". The function is kept for the dimension's whole life.

- Parameters:
    - name : `string`
    - spec : `string`
    - materials : `[]string`
    - biomes : `[]string`
    - fill : `func(*ChunkRequest) bool`
- Return type: `(int32, error)`
- Slots: [`md_add_dimension_generated`](../cpp/dimensions.md#md_add_dimension_generated)

### `DimensionsAvailable` {#DimensionsAvailable}

```go
func DimensionsAvailable() (bool, error)
```

DimensionsAvailable reports whether this host can register custom dimensions.

- Return type: `(bool, error)`
- Slots: [`md_is_available`](../cpp/dimensions.md#md_is_available)

### `AddDimension` {#AddDimension}

```go
func AddDimension(name, spec string) (int32, error)
```

AddDimension registers a dimension from spec SNBT and returns its id.

- Parameters:
    - name : `string`
    - spec : `string`
- Return type: `(int32, error)`
- Slots: [`md_add_dimension`](../cpp/dimensions.md#md_add_dimension)

### `DimensionID` {#DimensionID}

```go
func DimensionID(name string) (int32, error)
```

DimensionID is the id of a registered dimension.

- Parameters:
    - name : `string`
- Return type: `(int32, error)`
- Slots: [`md_get_dimension_id`](../cpp/dimensions.md#md_get_dimension_id)

### `ListDimensions` {#ListDimensions}

```go
func ListDimensions() ([]string, error)
```

ListDimensions lists the registered custom dimensions.

- Return type: `([]string, error)`
- Slots: [`md_list_dimensions`](../cpp/dimensions.md#md_list_dimensions)

### `SetDimensionRule` {#SetDimensionRule}

```go
func SetDimensionRule(dim, rule int32, allow bool) error
```

SetDimensionRule sets one rule, a PIER\_DIMRULE\_\* value, for one dimension.

- Parameters:
    - dim : `int32`
    - rule : `int32`
    - allow : `bool`
- Return type: `error`
- Slots: [`md_set_dimension_rule`](../cpp/dimensions.md#md_set_dimension_rule)

### `DimensionRule` {#DimensionRule}

```go
func DimensionRule(dim, rule int32) (allow, set bool, err error)
```

DimensionRule reads one rule; set is false when the dimension follows vanilla for it, which a host older than the rule also answers.

- Parameters:
    - dim : `int32`
    - rule : `int32`
- Return type: `(allow, set bool, err error)`
- Slots: [`md_get_dimension_rule`](../cpp/dimensions.md#md_get_dimension_rule)

### `ExistingDimensions` {#ExistingDimensions}

```go
func ExistingDimensions() ([]ExistingDimension, error)
```

ExistingDimensions lists every registered custom dimension.

- Return type: `([]ExistingDimension, error)`
- Slots: [`md_list_dimensions`](../cpp/dimensions.md#md_list_dimensions)

### `AddDimensionPack` {#AddDimensionPack}

```go
func AddDimensionPack(name, configPath, specSNBT string) (int32, error)
```

AddDimensionPack adds a custom dimension whose terrain is a terrain pack: a directory with a config file and a binary built by tools/pier-pack. configPath is relative to the server root, with forward slashes, no .. and not absolute. A refusal is a \*PackError.

- Parameters:
    - name : `string`
    - configPath : `string`
    - specSNBT : `string`
- Return type: `(int32, error)`
- Slots: [`md_add_dimension_pack`](../cpp/dimensions.md#md_add_dimension_pack)

### `InspectPack` {#InspectPack}

```go
func InspectPack(configPath string) (string, error)
```

InspectPack reads what a terrain pack asks for, as a JSON document, without registering anything. A refusal is a \*PackError.

- Parameters:
    - configPath : `string`
- Return type: `(string, error)`
- Slots: [`md_pack_inspect`](../cpp/dimensions.md#md_pack_inspect)

### `RetireDimension` {#RetireDimension}

```go
func RetireDimension(name string) (bool, error)
```

RetireDimension retires a custom dimension: it is dropped from the host's tables and from `dimension_config`.json, so nothing registers it on the next boot. The chunks it wrote stay. It reports whether one by that name was registered.

- Parameters:
    - name : `string`
- Return type: `(bool, error)`
- Slots: [`md_retire_dimension`](../cpp/dimensions.md#md_retire_dimension)

### `ClearDimensionRules` {#ClearDimensionRules}

```go
func ClearDimensionRules(dim int32) error
```

ClearDimensionRules clears every rule of a dimension, for when its world was deleted.

- Parameters:
    - dim : `int32`
- Return type: `error`
- Slots: [`md_clear_dimension_rules`](../cpp/dimensions.md#md_clear_dimension_rules)

### `SetDimensionCells` {#SetDimensionCells}

```go
func SetDimensionCells(dimID, cell, gap int32) error
```

SetDimensionCells gives a generated dimension the cell geometry its confinement rules use: cell is the edge of a cell and gap the space between cells, both in blocks. A cell of 0 removes the geometry.

- Parameters:
    - dimID : `int32`
    - cell : `int32`
    - gap : `int32`
- Return type: `error`
- Slots: [`md_set_dimension_cells`](../cpp/dimensions.md#md_set_dimension_cells)

### `NewPlotMerge` {#NewPlotMerge}

```go
func NewPlotMerge(x, z int32, north, east, south, west bool) PlotMerge
```

NewPlotMerge assembles a mask from the four directions in the order north, east, south, west.

- Parameters:
    - x : `int32`
    - z : `int32`
    - north : `bool`
    - east : `bool`
    - south : `bool`
    - west : `bool`
- Return type: `PlotMerge`

### `SetPlotMerges` {#SetPlotMerges}

```go
func SetPlotMerges(dim int32, merges []PlotMerge) error
```

SetPlotMerges replaces the merge marks of a dimension as a whole. Only plots that carry a marker need to be listed.

- Parameters:
    - dim : `int32`
    - merges : `[]PlotMerge`
- Return type: `error`
- Slots: [`md_set_plot_merges`](../cpp/dimensions.md#md_set_plot_merges)

## `PackError` {#PackError}

```go
type PackError struct {
    Status   int32
    Problems string
}
```

PackError is the refusal of a terrain pack: the PIER\_PACK\_\* status the host gave and, when it wrote one, its reasons.

### `PackError.Error` {#PackError.Error}

```go
func (e *PackError) Error() string
```

- Return type: `string`

## `ChunkRequest` {#ChunkRequest}

```go
type ChunkRequest struct {
    Dim, ChunkX, ChunkZ int32
    MinY, Height        int32
    Materials           []uint16
    Biomes              []uint16
}
```

ChunkRequest is one chunk a supplied-terrain generator fills. Materials has 256\*Height entries indexed (x\*16+z)\*Height + (y-MinY), and Biomes 256, one per column; both hold indices into the palettes given at registration, and material 0 is air.

## `ExistingDimension` {#ExistingDimension}

```go
type ExistingDimension struct {
    Name string `json:"name"`
    Dim  int32  `json:"dim"`
    SNBT string `json:"snbt"`
}
```

ExistingDimension is one custom dimension that has been registered.

## `PlotMerge` {#PlotMerge}

```go
type PlotMerge struct {
    X, Z int32
    // Mask is a bitset: 1 north, 2 east, 4 south, 8 west.
    Mask uint32
}
```

PlotMerge holds the merge marks of one plot.
