# Zig: Items and containers

## `Item` {#Item}

```zig
pub const Item = struct {
    item_snbt: []const u8,
    // ...
};
```

An item stack as SNBT, a value: reading it asks the host about that SNBT.

### `Item.of` {#Item.of}

```zig
pub fn of(item_snbt_value: []const u8) Item
```

- Parameters:
    - item_snbt_value : `[]const u8`
- Return type: `Item`

### `Item.count` {#Item.count}

```zig
pub fn count(self: Item) core.Error!f64
```

`PIER_IPROP_COUNT`: `ItemStackBase::mCount`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.maxStackSize` {#Item.maxStackSize}

```zig
pub fn maxStackSize(self: Item) core.Error!f64
```

`PIER_IPROP_MAX_STACK_SIZE`: `ItemStackBase::getMaxStackSize`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.auxValue` {#Item.auxValue}

```zig
pub fn auxValue(self: Item) core.Error!f64
```

`PIER_IPROP_AUX_VALUE`: `ItemStackBase::getAuxValue`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.id` {#Item.id}

```zig
pub fn id(self: Item) core.Error!f64
```

`PIER_IPROP_ID`: `ItemStackBase::getId`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.damage` {#Item.damage}

```zig
pub fn damage(self: Item) core.Error!f64
```

`PIER_IPROP_DAMAGE`: `ItemStackBase::getDamageValue`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isNull` {#Item.isNull}

```zig
pub fn isNull(self: Item) core.Error!bool
```

`PIER_IPROP_IS_NULL`: `ItemStackBase::isNull`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isBlock` {#Item.isBlock}

```zig
pub fn isBlock(self: Item) core.Error!bool
```

`PIER_IPROP_IS_BLOCK`: `ItemStackBase::isBlock`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isEnchanted` {#Item.isEnchanted}

```zig
pub fn isEnchanted(self: Item) core.Error!bool
```

`PIER_IPROP_IS_ENCHANTED`: `ItemStackBase::isEnchanted`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isArmor` {#Item.isArmor}

```zig
pub fn isArmor(self: Item) core.Error!bool
```

`PIER_IPROP_IS_ARMOR`: `ItemStackBase::isArmorItem`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isDamageable` {#Item.isDamageable}

```zig
pub fn isDamageable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_DAMAGEABLE`: `ItemStackBase::isDamageableItem`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isDamaged` {#Item.isDamaged}

```zig
pub fn isDamaged(self: Item) core.Error!bool
```

`PIER_IPROP_IS_DAMAGED`: `ItemStackBase::isDamaged`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.maxDamage` {#Item.maxDamage}

```zig
pub fn maxDamage(self: Item) core.Error!f64
```

`PIER_IPROP_MAX_DAMAGE`: `ItemStackBase::getMaxDamage`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isUnbreakable` {#Item.isUnbreakable}

```zig
pub fn isUnbreakable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_UNBREAKABLE`: `ItemStackBase::isUnbreakable`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.hasDurability` {#Item.hasDurability}

```zig
pub fn hasDurability(self: Item) core.Error!bool
```

`PIER_IPROP_HAS_DURABILITY`: `ItemStackBase::hasDurability`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isPotion` {#Item.isPotion}

```zig
pub fn isPotion(self: Item) core.Error!bool
```

`PIER_IPROP_IS_POTION`: `ItemStackBase::isPotionItem`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isThrowable` {#Item.isThrowable}

```zig
pub fn isThrowable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_THROWABLE`: `ItemStackBase::isThrowable`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isFireResistant` {#Item.isFireResistant}

```zig
pub fn isFireResistant(self: Item) core.Error!bool
```

`PIER_IPROP_IS_FIRE_RESISTANT`: `ItemStackBase::isFireResistant`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.attackDamage` {#Item.attackDamage}

```zig
pub fn attackDamage(self: Item) core.Error!f64
```

`PIER_IPROP_ATTACK_DAMAGE`: `ItemStackBase::getAttackDamage`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.repairCost` {#Item.repairCost}

```zig
pub fn repairCost(self: Item) core.Error!f64
```

`PIER_IPROP_REPAIR_COST`: `ItemStackBase::getBaseRepairCost`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.enchantValue` {#Item.enchantValue}

```zig
pub fn enchantValue(self: Item) core.Error!f64
```

`PIER_IPROP_ENCHANT_VALUE`: `ItemStackBase::getEnchantValue`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isStackable` {#Item.isStackable}

```zig
pub fn isStackable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_STACKABLE`: `ItemStackBase::isStackable`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isMusicDisc` {#Item.isMusicDisc}

```zig
pub fn isMusicDisc(self: Item) core.Error!bool
```

`PIER_IPROP_IS_MUSIC_DISC`: `ItemStackBase::isMusicDiscItem`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isOffhand` {#Item.isOffhand}

```zig
pub fn isOffhand(self: Item) core.Error!bool
```

`PIER_IPROP_IS_OFFHAND`: `ItemStackBase::isOffhandItem`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.useDuration` {#Item.useDuration}

```zig
pub fn useDuration(self: Item) core.Error!f64
```

`PIER_IPROP_USE_DURATION`: `ItemStackBase::getMaxUseDuration`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isGlint` {#Item.isGlint}

```zig
pub fn isGlint(self: Item) core.Error!bool
```

`PIER_IPROP_IS_GLINT`: `ItemStackBase::isGlint`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isBundle` {#Item.isBundle}

```zig
pub fn isBundle(self: Item) core.Error!bool
```

`PIER_IPROP_IS_BUNDLE`: `ItemStackBase::isBundle`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.hasUserData` {#Item.hasUserData}

```zig
pub fn hasUserData(self: Item) core.Error!bool
```

`PIER_IPROP_HAS_USER_DATA`: `ItemStackBase::hasUserData`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.hasCustomName` {#Item.hasCustomName}

```zig
pub fn hasCustomName(self: Item) core.Error!bool
```

`PIER_IPROP_HAS_CUSTOM_NAME`: `ItemStackBase::hasCustomHoverName`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isFood` {#Item.isFood}

```zig
pub fn isFood(self: Item) core.Error!bool
```

`PIER_IPROP_IS_FOOD`: `Item::isFood`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isDyeable` {#Item.isDyeable}

```zig
pub fn isDyeable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_DYEABLE`: `Item::isDyeable`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isHandEquipped` {#Item.isHandEquipped}

```zig
pub fn isHandEquipped(self: Item) core.Error!bool
```

`PIER_IPROP_IS_HAND_EQUIPPED`: `Item::isHandEquipped`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isLiquidClip` {#Item.isLiquidClip}

```zig
pub fn isLiquidClip(self: Item) core.Error!bool
```

`PIER_IPROP_IS_LIQUID_CLIP`: `Item::isLiquidClipItem`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isStackedByData` {#Item.isStackedByData}

```zig
pub fn isStackedByData(self: Item) core.Error!bool
```

`PIER_IPROP_IS_STACKED_BY_DATA`: `Item::isStackedByData`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.cooldownDuration` {#Item.cooldownDuration}

```zig
pub fn cooldownDuration(self: Item) core.Error!f64
```

`PIER_IPROP_COOLDOWN_DURATION`: `Item::getCooldownDuration`, in ticks

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isComponentBased` {#Item.isComponentBased}

```zig
pub fn isComponentBased(self: Item) core.Error!bool
```

`PIER_IPROP_IS_COMPONENT_BASED`: `Item::isComponentBased`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isHumanoidArmor` {#Item.isHumanoidArmor}

```zig
pub fn isHumanoidArmor(self: Item) core.Error!bool
```

`PIER_IPROP_IS_HUMANOID_ARMOR`: `Item::isHumanoidArmor`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.armorValue` {#Item.armorValue}

```zig
pub fn armorValue(self: Item) core.Error!f64
```

`PIER_IPROP_ARMOR_VALUE`: `Item::getArmorValue`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.canBeDepleted` {#Item.canBeDepleted}

```zig
pub fn canBeDepleted(self: Item) core.Error!bool
```

`PIER_IPROP_CAN_BE_DEPLETED`: `Item::canBeDepleted`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.isUseable` {#Item.isUseable}

```zig
pub fn isUseable(self: Item) core.Error!bool
```

`PIER_IPROP_IS_USEABLE`: `Item::isUseable`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.canDestroyInCreative` {#Item.canDestroyInCreative}

```zig
pub fn canDestroyInCreative(self: Item) core.Error!bool
```

`PIER_IPROP_CAN_DESTROY_IN_CREATIVE`: `Item::canDestroyInCreative`

- Return type: `core.Error!bool`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.showsDurabilityInCreative` {#Item.showsDurabilityInCreative}

```zig
pub fn showsDurabilityInCreative(self: Item) core.Error!f64
```

`PIER_IPROP_SHOWS_DURABILITY_IN_CREATIVE`: `Item::showsDurabilityInCreative`

- Return type: `core.Error!f64`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.typeName` {#Item.typeName}

```zig
pub fn typeName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_TYPE_NAME`: `ItemStackBase::getTypeName` ("minecraft:apple")

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.name` {#Item.name}

```zig
pub fn name(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_NAME`: `ItemStackBase::getName` (display)

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.customName` {#Item.customName}

```zig
pub fn customName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_CUSTOM_NAME`: `ItemStackBase::getCustomName`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.rawNameId` {#Item.rawNameId}

```zig
pub fn rawNameId(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_RAW_NAME_ID`: `ItemStackBase::getRawNameId`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.lore` {#Item.lore}

```zig
pub fn lore(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_LORE`: SNBT list \["l1","l2"\] `ItemStackBase::getCustomLore`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.canDestroy` {#Item.canDestroy}

```zig
pub fn canDestroy(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_CAN_DESTROY`: SNBT list \["minecraft:stone",…\]

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.canPlaceOn` {#Item.canPlaceOn}

```zig
pub fn canPlaceOn(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_CAN_PLACE_ON`: SNBT list

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.userData` {#Item.userData}

```zig
pub fn userData(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_USER_DATA`: full NBT user data as SNBT

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.hoverName` {#Item.hoverName}

```zig
pub fn hoverName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_HOVER_NAME`: `ItemStackBase::getHoverName`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.effectName` {#Item.effectName}

```zig
pub fn effectName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_EFFECT_NAME`: `ItemStackBase::getEffectName`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.color` {#Item.color}

```zig
pub fn color(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_ISTR_COLOR`: SNBT {r,g,b} `ItemStackBase::getColor`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.create` {#Item.create}

```zig
pub fn create(allocator: std.mem.Allocator, type_name: []const u8, amount: u8) std.mem.Allocator.Error![]u8
```

Builds an item from a type name and a count, as SNBT owned by the caller.

- Parameters:
    - allocator : `std.mem.Allocator`
    - type_name : `[]const u8`
    - amount : `u8`
- Return type: `std.mem.Allocator.Error![]u8`

### `Item.matches` {#Item.matches}

```zig
pub fn matches(self: Item, other: Item) core.Error!bool
```

Whether two items are the same kind of thing.

- Parameters:
    - other : `Item`
- Return type: `core.Error!bool`
- Slots: [`item_matches`](../cpp/item.md#item_matches)

### `Item.transform` {#Item.transform}

```zig
pub fn transform(self: Item, allocator: std.mem.Allocator, op: types.ItemOp, sarg: []const u8, narg: f64) core.Error![]u8
```

Runs one transform and returns the new item as SNBT, owned by the caller. This item is unchanged.

- Parameters:
    - allocator : `std.mem.Allocator`
    - op : `types.ItemOp`
    - sarg : `[]const u8`
    - narg : `f64`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withCustomName` {#Item.withCustomName}

```zig
pub fn withCustomName(self: Item, allocator: std.mem.Allocator, new_name: []const u8) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
    - new_name : `[]const u8`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withoutCustomName` {#Item.withoutCustomName}

```zig
pub fn withoutCustomName(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withDamage` {#Item.withDamage}

```zig
pub fn withDamage(self: Item, allocator: std.mem.Allocator, value: i32) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
    - value : `i32`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withCount` {#Item.withCount}

```zig
pub fn withCount(self: Item, allocator: std.mem.Allocator, amount: u8) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
    - amount : `u8`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withUnbreakable` {#Item.withUnbreakable}

```zig
pub fn withUnbreakable(self: Item, allocator: std.mem.Allocator, on: bool) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
    - on : `bool`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.hurtAndBreak` {#Item.hurtAndBreak}

```zig
pub fn hurtAndBreak(self: Item, allocator: std.mem.Allocator, wear: i32) core.Error![]u8
```

Wears the item down by `wear`, breaking it when it runs out.

- Parameters:
    - allocator : `std.mem.Allocator`
    - wear : `i32`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withRepairCost` {#Item.withRepairCost}

```zig
pub fn withRepairCost(self: Item, allocator: std.mem.Allocator, cost: i32) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
    - cost : `i32`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withLore` {#Item.withLore}

```zig
pub fn withLore(self: Item, allocator: std.mem.Allocator, lines: []const []const u8) core.Error![]u8
```

Sets the lore, one string per line.

- Parameters:
    - allocator : `std.mem.Allocator`
    - lines : `[]const []const u8`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withoutLore` {#Item.withoutLore}

```zig
pub fn withoutLore(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withEnchant` {#Item.withEnchant}

```zig
pub fn withEnchant(self: Item, allocator: std.mem.Allocator, enchant_id: []const u8, level: i32) core.Error![]u8
```

Adds an enchantment. A level of 0 removes it, as far as the engine is concerned.

- Parameters:
    - allocator : `std.mem.Allocator`
    - enchant_id : `[]const u8`
    - level : `i32`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withoutEnchants` {#Item.withoutEnchants}

```zig
pub fn withoutEnchants(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withCanDestroy` {#Item.withCanDestroy}

```zig
pub fn withCanDestroy(self: Item, allocator: std.mem.Allocator, blocks: []const []const u8) core.Error![]u8
```

The blocks the item may break in adventure mode.

- Parameters:
    - allocator : `std.mem.Allocator`
    - blocks : `[]const []const u8`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.withCanPlaceOn` {#Item.withCanPlaceOn}

```zig
pub fn withCanPlaceOn(self: Item, allocator: std.mem.Allocator, blocks: []const []const u8) core.Error![]u8
```

The blocks the item may be placed on in adventure mode.

- Parameters:
    - allocator : `std.mem.Allocator`
    - blocks : `[]const []const u8`
- Return type: `core.Error![]u8`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.enchants` {#Item.enchants}

```zig
pub fn enchants(self: Item, allocator: std.mem.Allocator) core.Error!types.Owned(types.Enchant)
```

The enchantments on the item.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error!types.Owned(types.Enchant)`
- Slots: [`item_get_enchants`](../cpp/item.md#item_get_enchants)

### `Item.withEnchants` {#Item.withEnchants}

```zig
pub fn withEnchants(self: Item, allocator: std.mem.Allocator, set: []const types.Enchant) core.Error![]u8
```

Replaces the whole enchantment set and returns the new item as SNBT, owned by the caller. Every current host answers NotProvided: writing enchantments is not implemented, and `withEnchant` is the way to add one.

- Parameters:
    - allocator : `std.mem.Allocator`
    - set : `[]const types.Enchant`
- Return type: `core.Error![]u8`
- Slots: [`item_set_enchants`](../cpp/item.md#item_set_enchants)

### `Item.userDataSnbt` {#Item.userDataSnbt}

```zig
pub fn userDataSnbt(self: Item, allocator: std.mem.Allocator) core.Error![]u8
```

The custom NBT of the item, the `tag` section, as SNBT owned by the caller. It goes through a dedicated slot and not a string property.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`item_get_user_data`](../cpp/item.md#item_get_user_data)

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

A reference to one container.

### `container.Container.ofPlayer` {#container.Container.ofPlayer}

```zig
pub fn ofPlayer(owner: props.Player, kind: Kind) Container
```

One container on a player.

- Parameters:
    - owner : `props.Player`
    - kind : `Kind`
- Return type: `Container`

### `container.Container.block` {#container.Container.block}

```zig
pub fn block(dim: i32, x: i32, y: i32, z: i32) Container
```

A block container at a coordinate in the world.

- Parameters:
    - dim : `i32`
    - x : `i32`
    - y : `i32`
    - z : `i32`
- Return type: `Container`

### `container.Container.size` {#container.Container.size}

```zig
pub fn size(self: Container) core.Error!i32
```

The slot count.

- Return type: `core.Error!i32`
- Slots: [`container_size`](../cpp/item.md#container_size)

### `container.Container.item` {#container.Container.item}

```zig
pub fn item(self: Container, allocator: Allocator, slot: i32) core.Error![]u8
```

What is in one slot, as item SNBT owned by the caller. An empty slot gives the SNBT of the air item and is not an error.

- Parameters:
    - allocator : `Allocator`
    - slot : `i32`
- Return type: `core.Error![]u8`
- Slots: [`container_get_item`](../cpp/item.md#container_get_item)

### `container.Container.items` {#container.Container.items}

```zig
pub fn items(self: Container, allocator: Allocator) core.Error![][]u8
```

Every slot as item SNBT in slot order, owned by the caller; `core.freeList` releases them.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error![][]u8`
- Slots: [`container_get_items`](../cpp/item.md#container_get_items)

### `container.Container.setItem` {#container.Container.setItem}

```zig
pub fn setItem(self: Container, slot: i32, item_snbt: []const u8) core.Error!void
```

Writes one slot. Call `refresh` afterwards for a player's container.

- Parameters:
    - slot : `i32`
    - item_snbt : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`container_set_item`](../cpp/item.md#container_set_item)

### `container.Container.addItem` {#container.Container.addItem}

```zig
pub fn addItem(self: Container, item_snbt: []const u8) core.Error!void
```

Puts one in and lets the engine pick the slot.

- Parameters:
    - item_snbt : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`container_add_item`](../cpp/item.md#container_add_item)

### `container.Container.removeItem` {#container.Container.removeItem}

```zig
pub fn removeItem(self: Container, slot: i32, count: i32) core.Error!void
```

Takes `count` items out of one slot.

- Parameters:
    - slot : `i32`
    - count : `i32`
- Return type: `core.Error!void`
- Slots: [`container_remove_item`](../cpp/item.md#container_remove_item)

### `container.Container.clear` {#container.Container.clear}

```zig
pub fn clear(self: Container) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`container_clear`](../cpp/item.md#container_clear)

### `container.Container.refresh` {#container.Container.refresh}

```zig
pub fn refresh(self: Container) core.Error!void
```

Resends the whole container to its owner. A block container has no owner to resend to and is Refused.

- Return type: `core.Error!void`
- Slots: [`container_refresh`](../cpp/item.md#container_refresh)

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

The kind of a container. The values align with `PierContainerRef::which`.

### `container.Kind.isPlayerOwned` {#container.Kind.isPlayerOwned}

```zig
pub fn isPlayerOwned(self: Kind) bool
```

A block container has no single owner and therefore cannot be resynchronized.

- Return type: `bool`
