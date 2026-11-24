# Zig：物品与容器

## `Item` {#Item}

```zig
pub const Item = struct {
    item_snbt: []const u8,
    // ...
};
```

以 SNBT 表示的物品堆，是一个值：读取它，就是拿这段 SNBT 去问宿主。

### `Item.of` {#Item.of}

```zig
pub fn of(item_snbt_value: []const u8) Item
```

- 参数：
    - item_snbt_value : `[]const u8`
- 返回值类型：`Item`

### `Item.count` {#Item.count}

```zig
pub fn count(self: Item) core.Error!f64
```

`PIER_IPROP_COUNT`：取自 `ItemStackBase::mCount`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.maxStackSize` {#Item.maxStackSize}

```zig
pub fn maxStackSize(self: Item) core.Error!f64
```

`PIER_IPROP_MAX_STACK_SIZE`：取自 `ItemStackBase::getMaxStackSize`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.auxValue` {#Item.auxValue}

```zig
pub fn auxValue(self: Item) core.Error!f64
```

`PIER_IPROP_AUX_VALUE`：取自 `ItemStackBase::getAuxValue`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.id` {#Item.id}

```zig
pub fn id(self: Item) core.Error!f64
```

`PIER_IPROP_ID`：取自 `ItemStackBase::getId`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.damage` {#Item.damage}

```zig
pub fn damage(self: Item) core.Error!f64
```

`PIER_IPROP_DAMAGE`：取自 `ItemStackBase::getDamageValue`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isNull` {#Item.isNull}

```zig
pub fn isNull(self: Item) core.Error!bool
```

`PIER_IPROP_IS_NULL`：取自 `ItemStackBase::isNull`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isBlock` {#Item.isBlock}

```zig
pub fn isBlock(self: Item) core.Error!bool
```

`PIER_IPROP_IS_BLOCK`：取自 `ItemStackBase::isBlock`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isEnchanted` {#Item.isEnchanted}

```zig
pub fn isEnchanted(self: Item) core.Error!bool
```

`PIER_IPROP_IS_ENCHANTED`：取自 `ItemStackBase::isEnchanted`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isArmor` {#Item.isArmor}

```zig
pub fn isArmor(self: Item) core.Error!bool
```

`PIER_IPROP_IS_ARMOR`：取自 `ItemStackBase::isArmorItem`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isDamageable` {#Item.isDamageable}

```zig
pub fn isDamageable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_DAMAGEABLE`：取自 `ItemStackBase::isDamageableItem`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isDamaged` {#Item.isDamaged}

```zig
pub fn isDamaged(self: Item) core.Error!bool
```

`PIER_IPROP_IS_DAMAGED`：取自 `ItemStackBase::isDamaged`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.maxDamage` {#Item.maxDamage}

```zig
pub fn maxDamage(self: Item) core.Error!f64
```

`PIER_IPROP_MAX_DAMAGE`：取自 `ItemStackBase::getMaxDamage`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isUnbreakable` {#Item.isUnbreakable}

```zig
pub fn isUnbreakable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_UNBREAKABLE`：取自 `ItemStackBase::isUnbreakable`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.hasDurability` {#Item.hasDurability}

```zig
pub fn hasDurability(self: Item) core.Error!bool
```

`PIER_IPROP_HAS_DURABILITY`：取自 `ItemStackBase::hasDurability`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isPotion` {#Item.isPotion}

```zig
pub fn isPotion(self: Item) core.Error!bool
```

`PIER_IPROP_IS_POTION`：取自 `ItemStackBase::isPotionItem`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isThrowable` {#Item.isThrowable}

```zig
pub fn isThrowable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_THROWABLE`：取自 `ItemStackBase::isThrowable`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isFireResistant` {#Item.isFireResistant}

```zig
pub fn isFireResistant(self: Item) core.Error!bool
```

`PIER_IPROP_IS_FIRE_RESISTANT`：取自 `ItemStackBase::isFireResistant`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.attackDamage` {#Item.attackDamage}

```zig
pub fn attackDamage(self: Item) core.Error!f64
```

`PIER_IPROP_ATTACK_DAMAGE`：取自 `ItemStackBase::getAttackDamage`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.repairCost` {#Item.repairCost}

```zig
pub fn repairCost(self: Item) core.Error!f64
```

`PIER_IPROP_REPAIR_COST`：取自 `ItemStackBase::getBaseRepairCost`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.enchantValue` {#Item.enchantValue}

```zig
pub fn enchantValue(self: Item) core.Error!f64
```

`PIER_IPROP_ENCHANT_VALUE`：取自 `ItemStackBase::getEnchantValue`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isStackable` {#Item.isStackable}

```zig
pub fn isStackable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_STACKABLE`：取自 `ItemStackBase::isStackable`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isMusicDisc` {#Item.isMusicDisc}

```zig
pub fn isMusicDisc(self: Item) core.Error!bool
```

`PIER_IPROP_IS_MUSIC_DISC`：取自 `ItemStackBase::isMusicDiscItem`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isOffhand` {#Item.isOffhand}

```zig
pub fn isOffhand(self: Item) core.Error!bool
```

`PIER_IPROP_IS_OFFHAND`：取自 `ItemStackBase::isOffhandItem`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.useDuration` {#Item.useDuration}

```zig
pub fn useDuration(self: Item) core.Error!f64
```

`PIER_IPROP_USE_DURATION`：取自 `ItemStackBase::getMaxUseDuration`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isGlint` {#Item.isGlint}

```zig
pub fn isGlint(self: Item) core.Error!bool
```

`PIER_IPROP_IS_GLINT`：取自 `ItemStackBase::isGlint`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isBundle` {#Item.isBundle}

```zig
pub fn isBundle(self: Item) core.Error!bool
```

`PIER_IPROP_IS_BUNDLE`：取自 `ItemStackBase::isBundle`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.hasUserData` {#Item.hasUserData}

```zig
pub fn hasUserData(self: Item) core.Error!bool
```

`PIER_IPROP_HAS_USER_DATA`：取自 `ItemStackBase::hasUserData`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.hasCustomName` {#Item.hasCustomName}

```zig
pub fn hasCustomName(self: Item) core.Error!bool
```

`PIER_IPROP_HAS_CUSTOM_NAME`：取自 `ItemStackBase::hasCustomHoverName`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isFood` {#Item.isFood}

```zig
pub fn isFood(self: Item) core.Error!bool
```

`PIER_IPROP_IS_FOOD`：`Item::isFood`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isDyeable` {#Item.isDyeable}

```zig
pub fn isDyeable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_DYEABLE`：`Item::isDyeable`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isHandEquipped` {#Item.isHandEquipped}

```zig
pub fn isHandEquipped(self: Item) core.Error!bool
```

`PIER_IPROP_IS_HAND_EQUIPPED`：`Item::isHandEquipped`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isLiquidClip` {#Item.isLiquidClip}

```zig
pub fn isLiquidClip(self: Item) core.Error!bool
```

`PIER_IPROP_IS_LIQUID_CLIP`：`Item::isLiquidClipItem`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isStackedByData` {#Item.isStackedByData}

```zig
pub fn isStackedByData(self: Item) core.Error!bool
```

`PIER_IPROP_IS_STACKED_BY_DATA`：`Item::isStackedByData`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.cooldownDuration` {#Item.cooldownDuration}

```zig
pub fn cooldownDuration(self: Item) core.Error!f64
```

`PIER_IPROP_COOLDOWN_DURATION`：`Item::getCooldownDuration`，单位为刻

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isComponentBased` {#Item.isComponentBased}

```zig
pub fn isComponentBased(self: Item) core.Error!bool
```

`PIER_IPROP_IS_COMPONENT_BASED`：`Item::isComponentBased`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isHumanoidArmor` {#Item.isHumanoidArmor}

```zig
pub fn isHumanoidArmor(self: Item) core.Error!bool
```

`PIER_IPROP_IS_HUMANOID_ARMOR`：`Item::isHumanoidArmor`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.armorValue` {#Item.armorValue}

```zig
pub fn armorValue(self: Item) core.Error!f64
```

`PIER_IPROP_ARMOR_VALUE`：`Item::getArmorValue`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.canBeDepleted` {#Item.canBeDepleted}

```zig
pub fn canBeDepleted(self: Item) core.Error!bool
```

`PIER_IPROP_CAN_BE_DEPLETED`：`Item::canBeDepleted`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isUseable` {#Item.isUseable}

```zig
pub fn isUseable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_USEABLE`：`Item::isUseable`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.canDestroyInCreative` {#Item.canDestroyInCreative}

```zig
pub fn canDestroyInCreative(self: Item) core.Error!bool
```

`PIER_IPROP_CAN_DESTROY_IN_CREATIVE`：`Item::canDestroyInCreative`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.showsDurabilityInCreative` {#Item.showsDurabilityInCreative}

```zig
pub fn showsDurabilityInCreative(self: Item) core.Error!f64
```

`PIER_IPROP_SHOWS_DURABILITY_IN_CREATIVE`：`Item::showsDurabilityInCreative`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`item_get_num`](../cpp/item.md#item_get_num)

### `Item.typeName` {#Item.typeName}

```zig
pub fn typeName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_TYPE_NAME`：取自 `ItemStackBase::getTypeName`（形如 `"minecraft:apple"`）

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.name` {#Item.name}

```zig
pub fn name(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_NAME`：取自 `ItemStackBase::getName`（显示名）

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.customName` {#Item.customName}

```zig
pub fn customName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_CUSTOM_NAME`：取自 `ItemStackBase::getCustomName`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.rawNameId` {#Item.rawNameId}

```zig
pub fn rawNameId(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_RAW_NAME_ID`：取自 `ItemStackBase::getRawNameId`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.lore` {#Item.lore}

```zig
pub fn lore(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_LORE`：SNBT 列表 `["l1","l2"]`，取自 `ItemStackBase::getCustomLore`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.canDestroy` {#Item.canDestroy}

```zig
pub fn canDestroy(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_CAN_DESTROY`：SNBT 列表 `["minecraft:stone",…]`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.canPlaceOn` {#Item.canPlaceOn}

```zig
pub fn canPlaceOn(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_CAN_PLACE_ON`：SNBT 列表

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.userData` {#Item.userData}

```zig
pub fn userData(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_USER_DATA`：完整的 NBT 用户数据，以 SNBT 表示

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.hoverName` {#Item.hoverName}

```zig
pub fn hoverName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_HOVER_NAME`：取自 `ItemStackBase::getHoverName`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.effectName` {#Item.effectName}

```zig
pub fn effectName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_EFFECT_NAME`：取自 `ItemStackBase::getEffectName`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.color` {#Item.color}

```zig
pub fn color(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_COLOR`：SNBT `{r,g,b}`，取自 `ItemStackBase::getColor`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_str`](../cpp/item.md#item_get_str)

### `Item.create` {#Item.create}

```zig
pub fn create(allocator: std.mem.Allocator, type_name: []const u8, amount: u8) std.mem.Allocator.Error![]u8
```

用类型名和数量构造一个物品，SNBT 形式，由调用方持有。

- 参数：
    - allocator : `std.mem.Allocator`
    - type_name : `[]const u8`
    - amount : `u8`
- 返回值类型：`std.mem.Allocator.Error![]u8`

### `Item.matches` {#Item.matches}

```zig
pub fn matches(self: Item, other: Item) core.Error!bool
```

两个物品是否是同一种东西。

- 参数：
    - other : `Item`
- 返回值类型：`core.Error!bool`
- 对应槽位：[`item_matches`](../cpp/item.md#item_matches)

### `Item.transform` {#Item.transform}

```zig
pub fn transform(self: Item, allocator: std.mem.Allocator, op: types.ItemOp, sarg: []const u8, narg: f64) core.Error![]u8
```

执行一次变换，并返回新物品的 SNBT，由调用方持有。原物品不变。

- 参数：
    - allocator : `std.mem.Allocator`
    - op : `types.ItemOp`
    - sarg : `[]const u8`
    - narg : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withCustomName` {#Item.withCustomName}

```zig
pub fn withCustomName(self: Item, allocator: std.mem.Allocator, new_name: []const u8) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
    - new_name : `[]const u8`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withoutCustomName` {#Item.withoutCustomName}

```zig
pub fn withoutCustomName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withDamage` {#Item.withDamage}

```zig
pub fn withDamage(self: Item, allocator: std.mem.Allocator, value: i32) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
    - value : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withCount` {#Item.withCount}

```zig
pub fn withCount(self: Item, allocator: std.mem.Allocator, amount: u8) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
    - amount : `u8`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withUnbreakable` {#Item.withUnbreakable}

```zig
pub fn withUnbreakable(self: Item, allocator: std.mem.Allocator, on: bool) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
    - on : `bool`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.hurtAndBreak` {#Item.hurtAndBreak}

```zig
pub fn hurtAndBreak(self: Item, allocator: std.mem.Allocator, wear: i32) core.Error![]u8
```

让物品磨损 `wear` 点，磨完时物品会损坏。

- 参数：
    - allocator : `std.mem.Allocator`
    - wear : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withRepairCost` {#Item.withRepairCost}

```zig
pub fn withRepairCost(self: Item, allocator: std.mem.Allocator, cost: i32) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
    - cost : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withLore` {#Item.withLore}

```zig
pub fn withLore(self: Item, allocator: std.mem.Allocator, lines: []const []const u8) core.Error![]u8
```

设置物品说明文字，每行一个字符串。

- 参数：
    - allocator : `std.mem.Allocator`
    - lines : `[]const []const u8`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withoutLore` {#Item.withoutLore}

```zig
pub fn withoutLore(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withEnchant` {#Item.withEnchant}

```zig
pub fn withEnchant(self: Item, allocator: std.mem.Allocator, enchant_id: []const u8, level: i32) core.Error![]u8
```

添加一个附魔。等级为 0 时，在引擎看来就是移除它。

- 参数：
    - allocator : `std.mem.Allocator`
    - enchant_id : `[]const u8`
    - level : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withoutEnchants` {#Item.withoutEnchants}

```zig
pub fn withoutEnchants(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withCanDestroy` {#Item.withCanDestroy}

```zig
pub fn withCanDestroy(self: Item, allocator: std.mem.Allocator, blocks: []const []const u8) core.Error![]u8
```

物品在冒险模式下可以破坏的方块。

- 参数：
    - allocator : `std.mem.Allocator`
    - blocks : `[]const []const u8`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.withCanPlaceOn` {#Item.withCanPlaceOn}

```zig
pub fn withCanPlaceOn(self: Item, allocator: std.mem.Allocator, blocks: []const []const u8) core.Error![]u8
```

物品在冒险模式下可以放置到的方块上。

- 参数：
    - allocator : `std.mem.Allocator`
    - blocks : `[]const []const u8`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_transform`](../cpp/item.md#item_transform)

### `Item.enchants` {#Item.enchants}

```zig
pub fn enchants(self: Item, allocator: std.mem.Allocator) core.Error!types.Owned(types.Enchant)
```

物品上的附魔。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error!types.Owned(types.Enchant)`
- 对应槽位：[`item_get_enchants`](../cpp/item.md#item_get_enchants)

### `Item.withEnchants` {#Item.withEnchants}

```zig
pub fn withEnchants(self: Item, allocator: std.mem.Allocator, set: []const types.Enchant) core.Error![]u8
```

替换整套附魔，并返回新物品的 SNBT，由调用方持有。目前所有宿主都返回 `NotProvided`：写入附魔没有实现，要添加一个附魔请用 `withEnchant`。

- 参数：
    - allocator : `std.mem.Allocator`
    - set : `[]const types.Enchant`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_set_enchants`](../cpp/item.md#item_set_enchants)

### `Item.userDataSnbt` {#Item.userDataSnbt}

```zig
pub fn userDataSnbt(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

物品的自定义 NBT，也就是 `tag` 部分，SNBT 形式，由调用方持有。它走专用槽位，而不是字符串属性。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`item_get_user_data`](../cpp/item.md#item_get_user_data)

## `container.Container` {#container.Container}

```zig
pub const Container = struct {
    kind: Kind,
    owner: props.Player,
    dim: i32 = 0,
    x: i32 = 0,
    y: i32 = 0,
    z: i32 = 0,
    // ...
};
```

对一个容器的引用。

### `container.Container.ofPlayer` {#container.Container.ofPlayer}

```zig
pub fn ofPlayer(owner: props.Player, kind: Kind) Container
```

玩家身上的一个容器。

- 参数：
    - owner : `props.Player`
    - kind : `Kind`
- 返回值类型：`Container`

### `container.Container.block` {#container.Container.block}

```zig
pub fn block(dim: i32, x: i32, y: i32, z: i32) Container
```

世界里某个坐标处的方块容器。

- 参数：
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- 返回值类型：`Container`

### `container.Container.size` {#container.Container.size}

```zig
pub fn size(self: Container) core.Error!i32
```

槽位数。

- 返回值类型：`core.Error!i32`
- 对应槽位：[`container_size`](../cpp/item.md#container_size)

### `container.Container.item` {#container.Container.item}

```zig
pub fn item(self: Container, allocator: Allocator, slot: i32) core.Error![]u8
```

一个槽位里的内容，物品 SNBT 形式，由调用方持有。空槽位给出空气物品的 SNBT，不是错误。

- 参数：
    - allocator : `Allocator`
    - slot : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`container_get_item`](../cpp/item.md#container_get_item)

### `container.Container.items` {#container.Container.items}

```zig
pub fn items(self: Container, allocator: Allocator) core.Error![][]u8
```

按槽位顺序给出每个槽位，物品 SNBT 形式，由调用方持有；用 `core.freeList` 释放。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error![][]u8`
- 对应槽位：[`container_get_items`](../cpp/item.md#container_get_items)

### `container.Container.setItem` {#container.Container.setItem}

```zig
pub fn setItem(self: Container, slot: i32, item_snbt: []const u8) core.Error!void
```

写入一个槽位。玩家的容器写完后要调用 `refresh`。

- 参数：
    - slot : `i32`
    - item_snbt : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`container_set_item`](../cpp/item.md#container_set_item)

### `container.Container.addItem` {#container.Container.addItem}

```zig
pub fn addItem(self: Container, item_snbt: []const u8) core.Error!void
```

放进去一个，槽位由引擎挑选。

- 参数：
    - item_snbt : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`container_add_item`](../cpp/item.md#container_add_item)

### `container.Container.removeItem` {#container.Container.removeItem}

```zig
pub fn removeItem(self: Container, slot: i32, count: i32) core.Error!void
```

从某一格取出 `count` 个物品。

- 参数：
    - slot : `i32`
    - count : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`container_remove_item`](../cpp/item.md#container_remove_item)

### `container.Container.clear` {#container.Container.clear}

```zig
pub fn clear(self: Container) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`container_clear`](../cpp/item.md#container_clear)

### `container.Container.refresh` {#container.Container.refresh}

```zig
pub fn refresh(self: Container) core.Error!void
```

把整个容器重新发给它的主人。方块容器没有主人可发，会得到 `Refused`。

- 返回值类型：`core.Error!void`
- 对应槽位：[`container_refresh`](../cpp/item.md#container_refresh)

## `container.Kind` {#container.Kind}

```zig
pub const Kind = enum(i32) {
    inventory = 0,
    ender_chest = 1,
    armor = 2,
    off_hand = 3,
    block = 4,
};
```

容器的种类。取值和 `PierContainerRef::which` 对齐。

### `container.Kind.isPlayerOwned` {#container.Kind.isPlayerOwned}

```zig
pub fn isPlayerOwned(self: Kind) bool
```

方块容器没有唯一的主人，所以无法重新同步。

- 返回值类型：`bool`
