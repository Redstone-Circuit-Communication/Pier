# Go: Items and containers

## Functions {#functions}

### `ContainerItems` {#ContainerItems}

```go
func ContainerItems(ref ContainerRef) ([]SlotItem, error)
```

ContainerItems lists the occupied slots of a container. Server thread only.

- Parameters:
    - ref : `ContainerRef`
- Return type: `([]SlotItem, error)`
- Slots: [`container_get_items`](../cpp/item.md#container_get_items)

### `ItemOf` {#ItemOf}

```go
func ItemOf(snbt string) Item
```

ItemOf is the item stack these SNBT describe.

- Parameters:
    - snbt : `string`
- Return type: `Item`

## `Item` {#Item}

```go
type Item struct {
    SNBT string
}
```

Item is an item stack as SNBT, a value: reading it asks the host about that SNBT, and changing it produces a new Item.

### `Item.Payload` {#Item.Payload}

```go
func (i Item) Payload() (*Nbt, error)
```

Payload is the item's SNBT parsed.

- Return type: `(*Nbt, error)`

### `Item.Enchants` {#Item.Enchants}

```go
func (i Item) Enchants() (string, error)
```

Enchants lists the item's enchantments as SNBT.

- Return type: `(string, error)`
- Slots: [`item_get_enchants`](../cpp/item.md#item_get_enchants)

### `Item.Matches` {#Item.Matches}

```go
func (i Item) Matches(other Item) (bool, error)
```

Matches reports whether two items stack: the same item, data and user data.

- Parameters:
    - other : `Item`
- Return type: `(bool, error)`
- Slots: [`item_matches`](../cpp/item.md#item_matches)

### `Item.Transform` {#Item.Transform}

```go
func (i Item) Transform(op int32, sarg string, narg float64) (Item, error)
```

Transform applies one of the PIER\_IOP\_\* operations of abi.h and returns the new item.

- Parameters:
    - op : `int32`
    - sarg : `string`
    - narg : `float64`
- Return type: `(Item, error)`
- Slots: [`item_transform`](../cpp/item.md#item_transform)

### `Item.UserDataSNBT` {#Item.UserDataSNBT}

```go
func (i Item) UserDataSNBT() (string, error)
```

UserDataSNBT is the custom NBT of the item, its tag section, as SNBT.

- Return type: `(string, error)`
- Slots: [`item_get_user_data`](../cpp/item.md#item_get_user_data)

### `Item.EnchantList` {#Item.EnchantList}

```go
func (i Item) EnchantList() ([]Enchant, error)
```

EnchantList lists the enchantments of the item.

- Return type: `([]Enchant, error)`
- Slots: [`item_get_enchants`](../cpp/item.md#item_get_enchants)

### `Item.WithEnchants` {#Item.WithEnchants}

```go
func (i Item) WithEnchants(set []Enchant) (Item, error)
```

WithEnchants replaces the whole enchantment set and returns the new item. Every current host answers not provided: writing enchantments is not implemented, and Transform with the add-enchant operation is the way to add one.

- Parameters:
    - set : `[]Enchant`
- Return type: `(Item, error)`
- Slots: [`item_set_enchants`](../cpp/item.md#item_set_enchants)

### `Item.Count` {#Item.Count}

```go
func (i Item) Count() (float64, error)
```

Count reads `PIER_IPROP_COUNT`: `ItemStackBase::mCount`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.MaxStackSize` {#Item.MaxStackSize}

```go
func (i Item) MaxStackSize() (float64, error)
```

MaxStackSize reads `PIER_IPROP_MAX_STACK_SIZE`: `ItemStackBase::getMaxStackSize`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.AuxValue` {#Item.AuxValue}

```go
func (i Item) AuxValue() (float64, error)
```

AuxValue reads `PIER_IPROP_AUX_VALUE`: `ItemStackBase::getAuxValue`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.Id` {#Item.Id}

```go
func (i Item) Id() (float64, error)
```

Id reads `PIER_IPROP_ID`: `ItemStackBase::getId`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.Damage` {#Item.Damage}

```go
func (i Item) Damage() (float64, error)
```

Damage reads `PIER_IPROP_DAMAGE`: `ItemStackBase::getDamageValue`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsNull` {#Item.IsNull}

```go
func (i Item) IsNull() (bool, error)
```

IsNull reads `PIER_IPROP_IS_NULL`: `ItemStackBase::isNull`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsBlock` {#Item.IsBlock}

```go
func (i Item) IsBlock() (bool, error)
```

IsBlock reads `PIER_IPROP_IS_BLOCK`: `ItemStackBase::isBlock`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsEnchanted` {#Item.IsEnchanted}

```go
func (i Item) IsEnchanted() (bool, error)
```

IsEnchanted reads `PIER_IPROP_IS_ENCHANTED`: `ItemStackBase::isEnchanted`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsArmor` {#Item.IsArmor}

```go
func (i Item) IsArmor() (bool, error)
```

IsArmor reads `PIER_IPROP_IS_ARMOR`: `ItemStackBase::isArmorItem`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsDamageable` {#Item.IsDamageable}

```go
func (i Item) IsDamageable() (bool, error)
```

IsDamageable reads `PIER_IPROP_IS_DAMAGEABLE`: `ItemStackBase::isDamageableItem`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsDamaged` {#Item.IsDamaged}

```go
func (i Item) IsDamaged() (bool, error)
```

IsDamaged reads `PIER_IPROP_IS_DAMAGED`: `ItemStackBase::isDamaged`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.MaxDamage` {#Item.MaxDamage}

```go
func (i Item) MaxDamage() (float64, error)
```

MaxDamage reads `PIER_IPROP_MAX_DAMAGE`: `ItemStackBase::getMaxDamage`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsUnbreakable` {#Item.IsUnbreakable}

```go
func (i Item) IsUnbreakable() (bool, error)
```

IsUnbreakable reads `PIER_IPROP_IS_UNBREAKABLE`: `ItemStackBase::isUnbreakable`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.HasDurability` {#Item.HasDurability}

```go
func (i Item) HasDurability() (bool, error)
```

HasDurability reads `PIER_IPROP_HAS_DURABILITY`: `ItemStackBase::hasDurability`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsPotion` {#Item.IsPotion}

```go
func (i Item) IsPotion() (bool, error)
```

IsPotion reads `PIER_IPROP_IS_POTION`: `ItemStackBase::isPotionItem`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsThrowable` {#Item.IsThrowable}

```go
func (i Item) IsThrowable() (bool, error)
```

IsThrowable reads `PIER_IPROP_IS_THROWABLE`: `ItemStackBase::isThrowable`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsFireResistant` {#Item.IsFireResistant}

```go
func (i Item) IsFireResistant() (bool, error)
```

IsFireResistant reads `PIER_IPROP_IS_FIRE_RESISTANT`: `ItemStackBase::isFireResistant`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.AttackDamage` {#Item.AttackDamage}

```go
func (i Item) AttackDamage() (float64, error)
```

AttackDamage reads `PIER_IPROP_ATTACK_DAMAGE`: `ItemStackBase::getAttackDamage`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.RepairCost` {#Item.RepairCost}

```go
func (i Item) RepairCost() (float64, error)
```

RepairCost reads `PIER_IPROP_REPAIR_COST`: `ItemStackBase::getBaseRepairCost`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.EnchantValue` {#Item.EnchantValue}

```go
func (i Item) EnchantValue() (float64, error)
```

EnchantValue reads `PIER_IPROP_ENCHANT_VALUE`: `ItemStackBase::getEnchantValue`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsStackable` {#Item.IsStackable}

```go
func (i Item) IsStackable() (bool, error)
```

IsStackable reads `PIER_IPROP_IS_STACKABLE`: `ItemStackBase::isStackable`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsMusicDisc` {#Item.IsMusicDisc}

```go
func (i Item) IsMusicDisc() (bool, error)
```

IsMusicDisc reads `PIER_IPROP_IS_MUSIC_DISC`: `ItemStackBase::isMusicDiscItem`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsOffhand` {#Item.IsOffhand}

```go
func (i Item) IsOffhand() (bool, error)
```

IsOffhand reads `PIER_IPROP_IS_OFFHAND`: `ItemStackBase::isOffhandItem`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.UseDuration` {#Item.UseDuration}

```go
func (i Item) UseDuration() (float64, error)
```

UseDuration reads `PIER_IPROP_USE_DURATION`: `ItemStackBase::getMaxUseDuration`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsGlint` {#Item.IsGlint}

```go
func (i Item) IsGlint() (bool, error)
```

IsGlint reads `PIER_IPROP_IS_GLINT`: `ItemStackBase::isGlint`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsBundle` {#Item.IsBundle}

```go
func (i Item) IsBundle() (bool, error)
```

IsBundle reads `PIER_IPROP_IS_BUNDLE`: `ItemStackBase::isBundle`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.HasUserData` {#Item.HasUserData}

```go
func (i Item) HasUserData() (bool, error)
```

HasUserData reads `PIER_IPROP_HAS_USER_DATA`: `ItemStackBase::hasUserData`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.HasCustomName` {#Item.HasCustomName}

```go
func (i Item) HasCustomName() (bool, error)
```

HasCustomName reads `PIER_IPROP_HAS_CUSTOM_NAME`: `ItemStackBase::hasCustomHoverName`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsFood` {#Item.IsFood}

```go
func (i Item) IsFood() (bool, error)
```

IsFood reads `PIER_IPROP_IS_FOOD`: `Item::isFood`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsDyeable` {#Item.IsDyeable}

```go
func (i Item) IsDyeable() (bool, error)
```

IsDyeable reads `PIER_IPROP_IS_DYEABLE`: `Item::isDyeable`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsHandEquipped` {#Item.IsHandEquipped}

```go
func (i Item) IsHandEquipped() (bool, error)
```

IsHandEquipped reads `PIER_IPROP_IS_HAND_EQUIPPED`: `Item::isHandEquipped`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsLiquidClip` {#Item.IsLiquidClip}

```go
func (i Item) IsLiquidClip() (bool, error)
```

IsLiquidClip reads `PIER_IPROP_IS_LIQUID_CLIP`: `Item::isLiquidClipItem`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsStackedByData` {#Item.IsStackedByData}

```go
func (i Item) IsStackedByData() (bool, error)
```

IsStackedByData reads `PIER_IPROP_IS_STACKED_BY_DATA`: `Item::isStackedByData`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.CooldownDuration` {#Item.CooldownDuration}

```go
func (i Item) CooldownDuration() (float64, error)
```

CooldownDuration reads `PIER_IPROP_COOLDOWN_DURATION`: `Item::getCooldownDuration`, in ticks

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsComponentBased` {#Item.IsComponentBased}

```go
func (i Item) IsComponentBased() (bool, error)
```

IsComponentBased reads `PIER_IPROP_IS_COMPONENT_BASED`: `Item::isComponentBased`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsHumanoidArmor` {#Item.IsHumanoidArmor}

```go
func (i Item) IsHumanoidArmor() (bool, error)
```

IsHumanoidArmor reads `PIER_IPROP_IS_HUMANOID_ARMOR`: `Item::isHumanoidArmor`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.ArmorValue` {#Item.ArmorValue}

```go
func (i Item) ArmorValue() (float64, error)
```

ArmorValue reads `PIER_IPROP_ARMOR_VALUE`: `Item::getArmorValue`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.CanBeDepleted` {#Item.CanBeDepleted}

```go
func (i Item) CanBeDepleted() (bool, error)
```

CanBeDepleted reads `PIER_IPROP_CAN_BE_DEPLETED`: `Item::canBeDepleted`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.IsUseable` {#Item.IsUseable}

```go
func (i Item) IsUseable() (bool, error)
```

IsUseable reads `PIER_IPROP_IS_USEABLE`: `Item::isUseable`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.CanDestroyInCreative` {#Item.CanDestroyInCreative}

```go
func (i Item) CanDestroyInCreative() (bool, error)
```

CanDestroyInCreative reads `PIER_IPROP_CAN_DESTROY_IN_CREATIVE`: `Item::canDestroyInCreative`

- Return type: `(bool, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.ShowsDurabilityInCreative` {#Item.ShowsDurabilityInCreative}

```go
func (i Item) ShowsDurabilityInCreative() (float64, error)
```

ShowsDurabilityInCreative reads `PIER_IPROP_SHOWS_DURABILITY_IN_CREATIVE`: `Item::showsDurabilityInCreative`

- Return type: `(float64, error)`
- Slots: [`item_get_num`](../cpp/item.md#item_get_num)

### `Item.TypeName` {#Item.TypeName}

```go
func (i Item) TypeName() (string, error)
```

TypeName reads `PIER_ISTR_TYPE_NAME`: `ItemStackBase::getTypeName` ("minecraft:apple")

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.Name` {#Item.Name}

```go
func (i Item) Name() (string, error)
```

Name reads `PIER_ISTR_NAME`: `ItemStackBase::getName` (display)

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.CustomName` {#Item.CustomName}

```go
func (i Item) CustomName() (string, error)
```

CustomName reads `PIER_ISTR_CUSTOM_NAME`: `ItemStackBase::getCustomName`

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.RawNameId` {#Item.RawNameId}

```go
func (i Item) RawNameId() (string, error)
```

RawNameId reads `PIER_ISTR_RAW_NAME_ID`: `ItemStackBase::getRawNameId`

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.Lore` {#Item.Lore}

```go
func (i Item) Lore() (string, error)
```

Lore reads `PIER_ISTR_LORE`: SNBT list \["l1","l2"\] `ItemStackBase::getCustomLore`

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.CanDestroy` {#Item.CanDestroy}

```go
func (i Item) CanDestroy() (string, error)
```

CanDestroy reads `PIER_ISTR_CAN_DESTROY`: SNBT list \["minecraft:stone",…\]

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.CanPlaceOn` {#Item.CanPlaceOn}

```go
func (i Item) CanPlaceOn() (string, error)
```

CanPlaceOn reads `PIER_ISTR_CAN_PLACE_ON`: SNBT list

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.UserData` {#Item.UserData}

```go
func (i Item) UserData() (string, error)
```

UserData reads `PIER_ISTR_USER_DATA`: full NBT user data as SNBT

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.HoverName` {#Item.HoverName}

```go
func (i Item) HoverName() (string, error)
```

HoverName reads `PIER_ISTR_HOVER_NAME`: `ItemStackBase::getHoverName`

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.EffectName` {#Item.EffectName}

```go
func (i Item) EffectName() (string, error)
```

EffectName reads `PIER_ISTR_EFFECT_NAME`: `ItemStackBase::getEffectName`

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

### `Item.Color` {#Item.Color}

```go
func (i Item) Color() (string, error)
```

Color reads `PIER_ISTR_COLOR`: SNBT {r,g,b} `ItemStackBase::getColor`

- Return type: `(string, error)`
- Slots: [`item_get_str`](../cpp/item.md#item_get_str)

## `Container` {#Container}

```go
type Container struct {
    Ref ContainerRef
}
```

Container is a player's or a block's container.

### `Container.Size` {#Container.Size}

```go
func (c Container) Size() (int32, error)
```

Size is the number of slots.

- Return type: `(int32, error)`
- Slots: [`container_size`](../cpp/item.md#container_size)

### `Container.Item` {#Container.Item}

```go
func (c Container) Item(slot int32) (Item, error)
```

Item is the item in one slot.

- Parameters:
    - slot : `int32`
- Return type: `(Item, error)`
- Slots: [`container_get_item`](../cpp/item.md#container_get_item)

### `Container.SetItem` {#Container.SetItem}

```go
func (c Container) SetItem(slot int32, item Item) error
```

SetItem puts an item into one slot.

- Parameters:
    - slot : `int32`
    - item : `Item`
- Return type: `error`
- Slots: [`container_set_item`](../cpp/item.md#container_set_item)

### `Container.AddItem` {#Container.AddItem}

```go
func (c Container) AddItem(item Item) error
```

AddItem adds an item where it fits.

- Parameters:
    - item : `Item`
- Return type: `error`
- Slots: [`container_add_item`](../cpp/item.md#container_add_item)

### `Container.RemoveItem` {#Container.RemoveItem}

```go
func (c Container) RemoveItem(slot, count int32) error
```

RemoveItem removes count items from one slot.

- Parameters:
    - slot : `int32`
    - count : `int32`
- Return type: `error`
- Slots: [`container_remove_item`](../cpp/item.md#container_remove_item)

### `Container.Clear` {#Container.Clear}

```go
func (c Container) Clear() error
```

Clear empties the container.

- Return type: `error`
- Slots: [`container_clear`](../cpp/item.md#container_clear)

### `Container.Items` {#Container.Items}

```go
func (c Container) Items() ([]SlotItem, error)
```

Items lists the occupied slots.

- Return type: `([]SlotItem, error)`
- Slots: [`container_get_items`](../cpp/item.md#container_get_items)

### `Container.Refresh` {#Container.Refresh}

```go
func (c Container) Refresh() error
```

Refresh resends the whole container to its owner. A block container has no owner to resend to, and the host refuses it.

- Return type: `error`
- Slots: [`container_refresh`](../cpp/item.md#container_refresh)

## `SlotItem` {#SlotItem}

```go
type SlotItem struct {
    Slot int32
    SNBT string
}
```

SlotItem is one occupied slot of a container and its item as SNBT.

## `Enchant` {#Enchant}

```go
type Enchant struct {
    ID    string
    Level int32
}
```

Enchant is one enchantment.

## `ContainerRef` {#ContainerRef}

```go
type ContainerRef struct {
    Which   int32
    Player  PlayerSel
    Dim     int32
    X, Y, Z int32
}
```

ContainerRef names a container: a player's inventory, ender chest, armor or offhand, or the container of a block.

## `IProp*` {#IProp}

| Name | Value | Description |
|---|---|---|
| <span id="IPropCount"></span>`IPropCount` | `0` | IPropCount is `PIER_IPROP_COUNT`: `ItemStackBase::mCount` |
| <span id="IPropMaxStackSize"></span>`IPropMaxStackSize` | `1` | IPropMaxStackSize is `PIER_IPROP_MAX_STACK_SIZE`: `ItemStackBase::getMaxStackSize` |
| <span id="IPropAuxValue"></span>`IPropAuxValue` | `2` | IPropAuxValue is `PIER_IPROP_AUX_VALUE`: `ItemStackBase::getAuxValue` |
| <span id="IPropId"></span>`IPropId` | `3` | IPropId is `PIER_IPROP_ID`: `ItemStackBase::getId` |
| <span id="IPropDamage"></span>`IPropDamage` | `4` | IPropDamage is `PIER_IPROP_DAMAGE`: `ItemStackBase::getDamageValue` |
| <span id="IPropIsNull"></span>`IPropIsNull` | `5` | IPropIsNull is `PIER_IPROP_IS_NULL`: `ItemStackBase::isNull` |
| <span id="IPropIsBlock"></span>`IPropIsBlock` | `6` | IPropIsBlock is `PIER_IPROP_IS_BLOCK`: `ItemStackBase::isBlock` |
| <span id="IPropIsEnchanted"></span>`IPropIsEnchanted` | `7` | IPropIsEnchanted is `PIER_IPROP_IS_ENCHANTED`: `ItemStackBase::isEnchanted` |
| <span id="IPropIsArmor"></span>`IPropIsArmor` | `8` | IPropIsArmor is `PIER_IPROP_IS_ARMOR`: `ItemStackBase::isArmorItem` |
| <span id="IPropIsDamageable"></span>`IPropIsDamageable` | `9` | IPropIsDamageable is `PIER_IPROP_IS_DAMAGEABLE`: `ItemStackBase::isDamageableItem` |
| <span id="IPropIsDamaged"></span>`IPropIsDamaged` | `10` | IPropIsDamaged is `PIER_IPROP_IS_DAMAGED`: `ItemStackBase::isDamaged` |
| <span id="IPropMaxDamage"></span>`IPropMaxDamage` | `11` | IPropMaxDamage is `PIER_IPROP_MAX_DAMAGE`: `ItemStackBase::getMaxDamage` |
| <span id="IPropIsUnbreakable"></span>`IPropIsUnbreakable` | `12` | IPropIsUnbreakable is `PIER_IPROP_IS_UNBREAKABLE`: `ItemStackBase::isUnbreakable` |
| <span id="IPropHasDurability"></span>`IPropHasDurability` | `13` | IPropHasDurability is `PIER_IPROP_HAS_DURABILITY`: `ItemStackBase::hasDurability` |
| <span id="IPropIsPotion"></span>`IPropIsPotion` | `14` | IPropIsPotion is `PIER_IPROP_IS_POTION`: `ItemStackBase::isPotionItem` |
| <span id="IPropIsThrowable"></span>`IPropIsThrowable` | `15` | IPropIsThrowable is `PIER_IPROP_IS_THROWABLE`: `ItemStackBase::isThrowable` |
| <span id="IPropIsFireResistant"></span>`IPropIsFireResistant` | `16` | IPropIsFireResistant is `PIER_IPROP_IS_FIRE_RESISTANT`: `ItemStackBase::isFireResistant` |
| <span id="IPropAttackDamage"></span>`IPropAttackDamage` | `17` | IPropAttackDamage is `PIER_IPROP_ATTACK_DAMAGE`: `ItemStackBase::getAttackDamage` |
| <span id="IPropRepairCost"></span>`IPropRepairCost` | `18` | IPropRepairCost is `PIER_IPROP_REPAIR_COST`: `ItemStackBase::getBaseRepairCost` |
| <span id="IPropEnchantValue"></span>`IPropEnchantValue` | `19` | IPropEnchantValue is `PIER_IPROP_ENCHANT_VALUE`: `ItemStackBase::getEnchantValue` |
| <span id="IPropIsStackable"></span>`IPropIsStackable` | `20` | IPropIsStackable is `PIER_IPROP_IS_STACKABLE`: `ItemStackBase::isStackable` |
| <span id="IPropIsMusicDisc"></span>`IPropIsMusicDisc` | `21` | IPropIsMusicDisc is `PIER_IPROP_IS_MUSIC_DISC`: `ItemStackBase::isMusicDiscItem` |
| <span id="IPropIsOffhand"></span>`IPropIsOffhand` | `22` | IPropIsOffhand is `PIER_IPROP_IS_OFFHAND`: `ItemStackBase::isOffhandItem` |
| <span id="IPropUseDuration"></span>`IPropUseDuration` | `23` | IPropUseDuration is `PIER_IPROP_USE_DURATION`: `ItemStackBase::getMaxUseDuration` |
| <span id="IPropIsGlint"></span>`IPropIsGlint` | `24` | IPropIsGlint is `PIER_IPROP_IS_GLINT`: `ItemStackBase::isGlint` |
| <span id="IPropIsBundle"></span>`IPropIsBundle` | `25` | IPropIsBundle is `PIER_IPROP_IS_BUNDLE`: `ItemStackBase::isBundle` |
| <span id="IPropHasUserData"></span>`IPropHasUserData` | `26` | IPropHasUserData is `PIER_IPROP_HAS_USER_DATA`: `ItemStackBase::hasUserData` |
| <span id="IPropHasCustomName"></span>`IPropHasCustomName` | `27` | IPropHasCustomName is `PIER_IPROP_HAS_CUSTOM_NAME`: `ItemStackBase::hasCustomHoverName` |
| <span id="IPropIsFood"></span>`IPropIsFood` | `28` | IPropIsFood is `PIER_IPROP_IS_FOOD`: `Item::isFood` |
| <span id="IPropIsDyeable"></span>`IPropIsDyeable` | `29` | IPropIsDyeable is `PIER_IPROP_IS_DYEABLE`: `Item::isDyeable` |
| <span id="IPropIsHandEquipped"></span>`IPropIsHandEquipped` | `30` | IPropIsHandEquipped is `PIER_IPROP_IS_HAND_EQUIPPED`: `Item::isHandEquipped` |
| <span id="IPropIsLiquidClip"></span>`IPropIsLiquidClip` | `31` | IPropIsLiquidClip is `PIER_IPROP_IS_LIQUID_CLIP`: `Item::isLiquidClipItem` |
| <span id="IPropIsStackedByData"></span>`IPropIsStackedByData` | `32` | IPropIsStackedByData is `PIER_IPROP_IS_STACKED_BY_DATA`: `Item::isStackedByData` |
| <span id="IPropCooldownDuration"></span>`IPropCooldownDuration` | `33` | IPropCooldownDuration is `PIER_IPROP_COOLDOWN_DURATION`: `Item::getCooldownDuration`, in ticks |
| <span id="IPropIsComponentBased"></span>`IPropIsComponentBased` | `34` | IPropIsComponentBased is `PIER_IPROP_IS_COMPONENT_BASED`: `Item::isComponentBased` |
| <span id="IPropIsHumanoidArmor"></span>`IPropIsHumanoidArmor` | `35` | IPropIsHumanoidArmor is `PIER_IPROP_IS_HUMANOID_ARMOR`: `Item::isHumanoidArmor` |
| <span id="IPropArmorValue"></span>`IPropArmorValue` | `36` | IPropArmorValue is `PIER_IPROP_ARMOR_VALUE`: `Item::getArmorValue` |
| <span id="IPropCanBeDepleted"></span>`IPropCanBeDepleted` | `37` | IPropCanBeDepleted is `PIER_IPROP_CAN_BE_DEPLETED`: `Item::canBeDepleted` |
| <span id="IPropIsUseable"></span>`IPropIsUseable` | `38` | IPropIsUseable is `PIER_IPROP_IS_USEABLE`: `Item::isUseable` |
| <span id="IPropCanDestroyInCreative"></span>`IPropCanDestroyInCreative` | `39` | IPropCanDestroyInCreative is `PIER_IPROP_CAN_DESTROY_IN_CREATIVE`: `Item::canDestroyInCreative` |
| <span id="IPropShowsDurabilityInCreative"></span>`IPropShowsDurabilityInCreative` | `40` | IPropShowsDurabilityInCreative is `PIER_IPROP_SHOWS_DURABILITY_IN_CREATIVE`: `Item::showsDurabilityInCreative` |

## `IStr*` {#IStr}

| Name | Value | Description |
|---|---|---|
| <span id="IStrTypeName"></span>`IStrTypeName` | `0` | IStrTypeName is `PIER_ISTR_TYPE_NAME`: `ItemStackBase::getTypeName` ("minecraft:apple") |
| <span id="IStrName"></span>`IStrName` | `1` | IStrName is `PIER_ISTR_NAME`: `ItemStackBase::getName` (display) |
| <span id="IStrCustomName"></span>`IStrCustomName` | `2` | IStrCustomName is `PIER_ISTR_CUSTOM_NAME`: `ItemStackBase::getCustomName` |
| <span id="IStrRawNameId"></span>`IStrRawNameId` | `3` | IStrRawNameId is `PIER_ISTR_RAW_NAME_ID`: `ItemStackBase::getRawNameId` |
| <span id="IStrLore"></span>`IStrLore` | `4` | IStrLore is `PIER_ISTR_LORE`: SNBT list \["l1","l2"\] `ItemStackBase::getCustomLore` |
| <span id="IStrCanDestroy"></span>`IStrCanDestroy` | `5` | IStrCanDestroy is `PIER_ISTR_CAN_DESTROY`: SNBT list \["minecraft:stone",…\] |
| <span id="IStrCanPlaceOn"></span>`IStrCanPlaceOn` | `6` | IStrCanPlaceOn is `PIER_ISTR_CAN_PLACE_ON`: SNBT list |
| <span id="IStrUserData"></span>`IStrUserData` | `7` | IStrUserData is `PIER_ISTR_USER_DATA`: full NBT user data as SNBT |
| <span id="IStrHoverName"></span>`IStrHoverName` | `8` | IStrHoverName is `PIER_ISTR_HOVER_NAME`: `ItemStackBase::getHoverName` |
| <span id="IStrEffectName"></span>`IStrEffectName` | `9` | IStrEffectName is `PIER_ISTR_EFFECT_NAME`: `ItemStackBase::getEffectName` |
| <span id="IStrColor"></span>`IStrColor` | `10` | IStrColor is `PIER_ISTR_COLOR`: SNBT {r,g,b} `ItemStackBase::getColor` |

## `Container*` {#Container-values}

The values of ContainerRef.Which.

| Name | Value | Description |
|---|---|---|
| <span id="ContainerInventory"></span>`ContainerInventory` | `0` |  |
| <span id="ContainerEnderChest"></span>`ContainerEnderChest` | `1` |  |
| <span id="ContainerArmor"></span>`ContainerArmor` | `2` |  |
| <span id="ContainerOffhand"></span>`ContainerOffhand` | `3` |  |
| <span id="ContainerBlock"></span>`ContainerBlock` | `4` |  |
