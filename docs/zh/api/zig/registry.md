# Zig：注册表

## 函数 {#functions}

### `registry.blocks` {#registry.blocks}

```zig
pub fn blocks(allocator: Allocator) core.Error!types.Owned(BlockType)
```

所有方块类型。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(BlockType)`
- 对应槽位：[`registry_list`](../cpp/registry.md#registry_list)

### `registry.items` {#registry.items}

```zig
pub fn items(allocator: Allocator) core.Error!types.Owned(ItemType)
```

所有物品，每种以它完整的名字出现一次。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(ItemType)`
- 对应槽位：[`registry_list`](../cpp/registry.md#registry_list)

### `registry.entities` {#registry.entities}

```zig
pub fn entities(allocator: Allocator) core.Error!types.Owned(EntityType)
```

关卡知道的所有实体。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(EntityType)`
- 对应槽位：[`registry_list`](../cpp/registry.md#registry_list)

### `registry.commands` {#registry.commands}

```zig
pub fn commands(allocator: Allocator) core.Error!types.Owned(CommandType)
```

引擎注册表里的每一条命令，不论是哪个 mod 注册的。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(CommandType)`
- 对应槽位：[`registry_list`](../cpp/registry.md#registry_list)

## 声明 {#declarations}

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

关卡知道的一种实体。

### `registry.EntityType.isMob` {#registry.EntityType.isMob}

```zig
pub fn isMob(self: EntityType) bool
```

- 返回值类型：`bool`

### `registry.EntityType.isMonster` {#registry.EntityType.isMonster}

```zig
pub fn isMonster(self: EntityType) bool
```

- 返回值类型：`bool`

### `registry.EntityType.isAnimal` {#registry.EntityType.isAnimal}

```zig
pub fn isAnimal(self: EntityType) bool
```

陆地动物：有动物位，没有水生动物位。

- 返回值类型：`bool`

### `registry.EntityType.isWaterAnimal` {#registry.EntityType.isWaterAnimal}

```zig
pub fn isWaterAnimal(self: EntityType) bool
```

- 返回值类型：`bool`

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

一种方块，按它的默认状态读取。

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

一种物品。

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

引擎注册表里的一条命令。
