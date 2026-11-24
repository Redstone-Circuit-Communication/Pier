# Zig: Registries

## Functions {#functions}

### `registry.blocks` {#registry.blocks}

```zig
pub fn blocks(allocator: Allocator) core.Error!types.Owned(BlockType)
```

Every block type.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(BlockType)`
- Slots: [`registry_list`](../cpp/registry.md#registry_list)

### `registry.items` {#registry.items}

```zig
pub fn items(allocator: Allocator) core.Error!types.Owned(ItemType)
```

Every item, each once under its own full name.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(ItemType)`
- Slots: [`registry_list`](../cpp/registry.md#registry_list)

### `registry.entities` {#registry.entities}

```zig
pub fn entities(allocator: Allocator) core.Error!types.Owned(EntityType)
```

Every entity the level knows.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(EntityType)`
- Slots: [`registry_list`](../cpp/registry.md#registry_list)

### `registry.commands` {#registry.commands}

```zig
pub fn commands(allocator: Allocator) core.Error!types.Owned(CommandType)
```

Every command the engine's registry holds, whichever mod registered it.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(CommandType)`
- Slots: [`registry_list`](../cpp/registry.md#registry_list)

## Declarations {#declarations}

### `registry.EntityType.json_keys` {#registry.EntityType.json_keys}

```zig
pub const json_keys = .{ .type_id = "type" };
```

## `registry.EntityType` {#registry.EntityType}

```zig
pub const EntityType = struct {
    name: []const u8 = "",
    spawn_egg: bool = false,
    summonable: bool = false,
    experimental: bool = false,
    type_id: i64 = 0,
    // ...
};
```

One entity the level knows.

### `registry.EntityType.isMob` {#registry.EntityType.isMob}

```zig
pub fn isMob(self: EntityType) bool
```

- Return type: `bool`

### `registry.EntityType.isMonster` {#registry.EntityType.isMonster}

```zig
pub fn isMonster(self: EntityType) bool
```

- Return type: `bool`

### `registry.EntityType.isAnimal` {#registry.EntityType.isAnimal}

```zig
pub fn isAnimal(self: EntityType) bool
```

A land animal: the animal bit without the water-animal one.

- Return type: `bool`

### `registry.EntityType.isWaterAnimal` {#registry.EntityType.isWaterAnimal}

```zig
pub fn isWaterAnimal(self: EntityType) bool
```

- Return type: `bool`

## `registry.BlockType` {#registry.BlockType}

```zig
pub const BlockType = struct {
    name: []const u8 = "",
    category: i32 = 0,
    solid: bool = false,
    vanilla: bool = false,
    container: bool = false,
    signal: bool = false,
    fence: bool = false,
    rail: bool = false,
    slab: bool = false,
    wall: bool = false,
    crop: bool = false,
    entity: bool = false,
    destroy: f64 = 0,
    resistance: f64 = 0,
    light: i32 = 0,
    description: []const u8 = "",
    // ...
};
```

One block type, read from its default state.

## `registry.ItemType` {#registry.ItemType}

```zig
pub const ItemType = struct {
    name: []const u8 = "",
    rarity: i32 = 0,
    stack: i32 = 0,
    category: i32 = 0,
    hidden: bool = false,
    // ...
};
```

One item.

## `registry.CommandType` {#registry.CommandType}

```zig
pub const CommandType = struct {
    name: []const u8 = "",
    description: []const u8 = "",
    permission: i32 = 0,
    flags: i32 = 0,
    hidden: bool = false,
    aliases: []const []const u8 = &.{},
    // ...
};
```

One command the engine's registry holds.
