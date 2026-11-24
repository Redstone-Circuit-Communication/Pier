# Zig：玩家

## `Player` {#Player}

```zig
pub const Player = struct {
    sel_kind: SelKind,
    sel_value: []const u8,
    // ...
};
```

一名玩家，由选择器指定。

### `Player.byName` {#Player.byName}

```zig
pub fn byName(sel_name: []const u8) Player
```

- 参数：
    - sel_name : `[]const u8`
- 返回值类型：`Player`

### `Player.byXuid` {#Player.byXuid}

```zig
pub fn byXuid(sel_xuid: []const u8) Player
```

- 参数：
    - sel_xuid : `[]const u8`
- 返回值类型：`Player`

### `Player.byUuid` {#Player.byUuid}

```zig
pub fn byUuid(sel_uuid: []const u8) Player
```

- 参数：
    - sel_uuid : `[]const u8`
- 返回值类型：`Player`

### `Player.cSel` {#Player.cSel}

```zig
pub fn cSel(self: Player) core.c.PierPlayerSel
```

- 返回值类型：`core.c.PierPlayerSel`

### `Player.executeCommand` {#Player.executeCommand}

```zig
pub fn executeCommand(self: Player, cmd: []const u8) core.Error!void
```

以这个玩家的身份运行 `cmd`，用他自己的权限等级。只能在服务器线程调用。输出的每一行按 debug 级别记进日志；宿主返回 false（玩家不在线或世界还没就绪）时得到 `Refused`。

- 参数：
    - cmd : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_execute_command`](../cpp/player.md#player_execute_command)、[`log`](../cpp/core.md#log)

### `Player.gameType` {#Player.gameType}

```zig
pub fn gameType(self: Player) core.Error!f64
```

`PIER_PPROP_GAME_TYPE`：(G) `Player::getPlayerGameType`；写入用 `player_set_gamemode`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.level` {#Player.level}

```zig
pub fn level(self: Player) core.Error!f64
```

`PIER_PPROP_LEVEL`：(S) 属性 `Player::LEVEL()`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.setLevel` {#Player.setLevel}

```zig
pub fn setLevel(self: Player, new_value: f64) core.Error!void
```

写入 `PIER_PPROP_LEVEL`：(S) 属性 `Player::LEVEL()`

- 参数：
    - new_value : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_set_num`](../cpp/player.md#player_set_num)

### `Player.experience` {#Player.experience}

```zig
pub fn experience(self: Player) core.Error!f64
```

`PIER_PPROP_EXPERIENCE`：(S) 属性 `Player::EXPERIENCE()`（经验条进度，0 到 1）

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.setExperience` {#Player.setExperience}

```zig
pub fn setExperience(self: Player, new_value: f64) core.Error!void
```

写入 `PIER_PPROP_EXPERIENCE`：(S) 属性 `Player::EXPERIENCE()`（经验条进度，0 到 1）

- 参数：
    - new_value : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_set_num`](../cpp/player.md#player_set_num)

### `Player.hunger` {#Player.hunger}

```zig
pub fn hunger(self: Player) core.Error!f64
```

`PIER_PPROP_HUNGER`：(S) 属性 `Player::HUNGER()`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.setHunger` {#Player.setHunger}

```zig
pub fn setHunger(self: Player, new_value: f64) core.Error!void
```

写入 `PIER_PPROP_HUNGER`：(S) 属性 `Player::HUNGER()`

- 参数：
    - new_value : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_set_num`](../cpp/player.md#player_set_num)

### `Player.saturation` {#Player.saturation}

```zig
pub fn saturation(self: Player) core.Error!f64
```

`PIER_PPROP_SATURATION`：(S) 属性 `Player::SATURATION()`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.setSaturation` {#Player.setSaturation}

```zig
pub fn setSaturation(self: Player, new_value: f64) core.Error!void
```

写入 `PIER_PPROP_SATURATION`：(S) 属性 `Player::SATURATION()`

- 参数：
    - new_value : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_set_num`](../cpp/player.md#player_set_num)

### `Player.exhaustion` {#Player.exhaustion}

```zig
pub fn exhaustion(self: Player) core.Error!f64
```

`PIER_PPROP_EXHAUSTION`：(S) 属性 `Player::EXHAUSTION()`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.setExhaustion` {#Player.setExhaustion}

```zig
pub fn setExhaustion(self: Player, new_value: f64) core.Error!void
```

写入 `PIER_PPROP_EXHAUSTION`：(S) 属性 `Player::EXHAUSTION()`

- 参数：
    - new_value : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_set_num`](../cpp/player.md#player_set_num)

### `Player.xpNeededNextLevel` {#Player.xpNeededNextLevel}

```zig
pub fn xpNeededNextLevel(self: Player) core.Error!f64
```

`PIER_PPROP_XP_NEEDED_NEXT_LEVEL`：(G) `Player::getXpNeededForNextLevel`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.luck` {#Player.luck}

```zig
pub fn luck(self: Player) core.Error!f64
```

`PIER_PPROP_LUCK`：(G) `Player::getLuck`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.selectedSlot` {#Player.selectedSlot}

```zig
pub fn selectedSlot(self: Player) core.Error!f64
```

`PIER_PPROP_SELECTED_SLOT`：(G) `Player::getSelectedItemSlot`；设置用 `PIER_PACT_SET_SELECTED_SLOT`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isOperator` {#Player.isOperator}

```zig
pub fn isOperator(self: Player) core.Error!bool
```

`PIER_PPROP_IS_OPERATOR`：(G) `Player::isOperator`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.canUseOperatorBlocks` {#Player.canUseOperatorBlocks}

```zig
pub fn canUseOperatorBlocks(self: Player) core.Error!bool
```

`PIER_PPROP_CAN_USE_OPERATOR_BLOCKS`：(G) `Player::canUseOperatorBlocks`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isFlying` {#Player.isFlying}

```zig
pub fn isFlying(self: Player) core.Error!bool
```

`PIER_PPROP_IS_FLYING`：(G) `Player::isFlying`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.canJump` {#Player.canJump}

```zig
pub fn canJump(self: Player) core.Error!bool
```

`PIER_PPROP_CAN_JUMP`：(G) `Player::canJump`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isEmoting` {#Player.isEmoting}

```zig
pub fn isEmoting(self: Player) core.Error!bool
```

`PIER_PPROP_IS_EMOTING`：(G) `Player::isEmoting`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isInRaid` {#Player.isInRaid}

```zig
pub fn isInRaid(self: Player) core.Error!bool
```

`PIER_PPROP_IS_IN_RAID`：(G) `Player::isInRaid`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isHurt` {#Player.isHurt}

```zig
pub fn isHurt(self: Player) core.Error!bool
```

`PIER_PPROP_IS_HURT`：(G) `Player::isHurt`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isScoping` {#Player.isScoping}

```zig
pub fn isScoping(self: Player) core.Error!bool
```

`PIER_PPROP_IS_SCOPING`：(G) `Player::isScoping`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.canSleep` {#Player.canSleep}

```zig
pub fn canSleep(self: Player) core.Error!bool
```

`PIER_PPROP_CAN_SLEEP`：(G) `Player::canSleep`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.hasRespawnPosition` {#Player.hasRespawnPosition}

```zig
pub fn hasRespawnPosition(self: Player) core.Error!bool
```

`PIER_PPROP_HAS_RESPAWN_POSITION`：(G) `Player::hasRespawnPosition`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.clientSubId` {#Player.clientSubId}

```zig
pub fn clientSubId(self: Player) core.Error!f64
```

`PIER_PPROP_CLIENT_SUB_ID`：(G) `Player::getClientSubId`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.canUseAbility` {#Player.canUseAbility}

```zig
pub fn canUseAbility(self: Player) core.Error!bool
```

`PIER_PPROP_CAN_USE_ABILITY`：(G) `Player::canUseAbility`；能力编号要经 `player_action` 的读取路径传入，见 `PIER_PACT_CAN_USE_ABILITY`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.direction` {#Player.direction}

```zig
pub fn direction(self: Player) core.Error!f64
```

`PIER_PPROP_DIRECTION`：(G) `Player::getDirection`（0=南，1=西，2=北，3=东）

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.chunkRadius` {#Player.chunkRadius}

```zig
pub fn chunkRadius(self: Player) core.Error!f64
```

`PIER_PPROP_CHUNK_RADIUS`：(G) `Player::getChunkRadius`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.networkRtt` {#Player.networkRtt}

```zig
pub fn networkRtt(self: Player) core.Error!f64
```

`PIER_PPROP_NETWORK_RTT`：(G) `getNetworkStatus().mPing`（毫秒）

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.platform` {#Player.platform}

```zig
pub fn platform(self: Player) core.Error!f64
```

`PIER_PPROP_PLATFORM`：(G) `Player::getPlatform`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.enchantmentSeed` {#Player.enchantmentSeed}

```zig
pub fn enchantmentSeed(self: Player) core.Error!f64
```

`PIER_PPROP_ENCHANTMENT_SEED`：(G) `Player::getEnchantmentSeed`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isUsingItem` {#Player.isUsingItem}

```zig
pub fn isUsingItem(self: Player) core.Error!bool
```

`PIER_PPROP_IS_USING_ITEM`：(G) `Player::isUsingItem`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isBlocking` {#Player.isBlocking}

```zig
pub fn isBlocking(self: Player) core.Error!bool
```

`PIER_PPROP_IS_BLOCKING`：(G) `Player::isBlocking`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isGliding` {#Player.isGliding}

```zig
pub fn isGliding(self: Player) core.Error!bool
```

`PIER_PPROP_IS_GLIDING`：(G) `Player::isGliding`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isSwimming` {#Player.isSwimming}

```zig
pub fn isSwimming(self: Player) core.Error!bool
```

`PIER_PPROP_IS_SWIMMING`：(G) `Player::isSwimming`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.permissionLevel` {#Player.permissionLevel}

```zig
pub fn permissionLevel(self: Player) core.Error!f64
```

`PIER_PPROP_PERMISSION_LEVEL`：(G) `Player::getPlayerPermissionLevel`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.score` {#Player.score}

```zig
pub fn score(self: Player) core.Error!f64
```

`PIER_PPROP_SCORE`：(G) `Player::getScore`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.fallDistance` {#Player.fallDistance}

```zig
pub fn fallDistance(self: Player) core.Error!f64
```

`PIER_PPROP_FALL_DISTANCE`：(G) `Actor::getFallDistance`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isDead` {#Player.isDead}

```zig
pub fn isDead(self: Player) core.Error!bool
```

`PIER_PPROP_IS_DEAD`：(G) `Actor::isDead`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.hasDiedBefore` {#Player.hasDiedBefore}

```zig
pub fn hasDiedBefore(self: Player) core.Error!bool
```

`PIER_PPROP_HAS_DIED_BEFORE`：(G) `Player::hasDiedBefore`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.dimension` {#Player.dimension}

```zig
pub fn dimension(self: Player) core.Error!f64
```

`PIER_PPROP_DIMENSION`：(G) `Actor::getDimensionId`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isInitialized` {#Player.isInitialized}

```zig
pub fn isInitialized(self: Player) core.Error!bool
```

`PIER_PPROP_IS_INITIALIZED`：(G) `Player::isPlayerInitialized`；模拟玩家读到 1

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isSleeping` {#Player.isSleeping}

```zig
pub fn isSleeping(self: Player) core.Error!bool
```

`PIER_PPROP_IS_SLEEPING`：(G) `Player::isSleeping`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.isSimulated` {#Player.isSimulated}

```zig
pub fn isSimulated(self: Player) core.Error!bool
```

`PIER_PPROP_IS_SIMULATED`：(G) `Actor::isSimulatedPlayer`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.itemUseDuration` {#Player.itemUseDuration}

```zig
pub fn itemUseDuration(self: Player) core.Error!f64
```

`PIER_PPROP_ITEM_USE_DURATION`：(G) `Player::getItemUseDuration`，单位为刻

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.xpEarnedAtLevel` {#Player.xpEarnedAtLevel}

```zig
pub fn xpEarnedAtLevel(self: Player) core.Error!f64
```

`PIER_PPROP_XP_EARNED_AT_LEVEL`：(G) `Player::getXpEarnedAtCurrentLevel`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.canFly` {#Player.canFly}

```zig
pub fn canFly(self: Player) core.Error!bool
```

`PIER_PPROP_CAN_FLY`：(G) `Actor::canFly`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`player_get_num`](../cpp/player.md#player_get_num)

### `Player.realName` {#Player.realName}

```zig
pub fn realName(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_REAL_NAME`：取自 `Player::getRealName`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.uuid` {#Player.uuid}

```zig
pub fn uuid(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_UUID`：取自 `Player::getUuid().asString()`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.xuid` {#Player.xuid}

```zig
pub fn xuid(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_XUID`：取自 `Player::getXuid`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.ipAndPort` {#Player.ipAndPort}

```zig
pub fn ipAndPort(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_IP_AND_PORT`：取自 `Player::getIPAndPort`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.localeCode` {#Player.localeCode}

```zig
pub fn localeCode(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_LOCALE_CODE`：取自 `Player::getLocaleCode`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.nameTag` {#Player.nameTag}

```zig
pub fn nameTag(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_NAME_TAG`：取自 `Actor::getNameTag`（显示名）

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.lastDeathPos` {#Player.lastDeathPos}

```zig
pub fn lastDeathPos(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_LAST_DEATH_POS`：SNBT `{x,y,z}`；没有时为 `""`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.lastDeathDimension` {#Player.lastDeathDimension}

```zig
pub fn lastDeathDimension(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_LAST_DEATH_DIMENSION`：维度 id，以字符串表示

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.networkStatus` {#Player.networkStatus}

```zig
pub fn networkStatus(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_NETWORK_STATUS`：SNBT `{ping,avg_ping,packet_loss,max_ping}`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.platformOnlineId` {#Player.platformOnlineId}

```zig
pub fn platformOnlineId(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_PLATFORM_ONLINE_ID`：取自 `Player::getPlatformOnlineId`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.respawnPos` {#Player.respawnPos}

```zig
pub fn respawnPos(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_RESPAWN_POS`：SNBT `{x,y,z,dim}`：这名玩家会在哪里重生。不会为空：没有床的玩家报告的是世界出生点，这两种情况区分不开。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.selectedItem` {#Player.selectedItem}

```zig
pub fn selectedItem(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_SELECTED_ITEM`：`Player::getSelectedItem`，物品 SNBT

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.deviceModel` {#Player.deviceModel}

```zig
pub fn deviceModel(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_PSTR_DEVICE_MODEL`：`ConnectionRequest::getDeviceModel`；没有连接请求的玩家读取失败

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.setAbility` {#Player.setAbility}

```zig
pub fn setAbility(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SET_ABILITY`：`a` 为 `AbilitiesIndex`，`b` 为 0 或 1（布尔类的能力）或者浮点数（`FlySpeed` 等）。写完以后会把 `PlayerPermissionLevel` 恢复成写之前的值：引擎的 `LayeredAbilities::setAbility` 走的是「切换到自定义权限」那条路，会把玩家推到 Custom，而这个等级会和能力层一起放进 `UpdateAbilitiesPacket` 发给客户端。要改权限等级，用 `PIER_PACT_SET_PERMISSION_LEVEL`。玩家加入完成之前（`Player::isPlayerInitialized`）调用会被拒绝，返回 false：客户端还在加载时写入的能力会一直不同步，直到玩家重新进入。模拟玩家不受这个限制。

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.canUseAbilityAction` {#Player.canUseAbilityAction}

```zig
pub fn canUseAbilityAction(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_CAN_USE_ABILITY`：`a` 为 `AbilitiesIndex`，输出 `"0"` 或 `"1"`，调用 `Player::canUseAbility`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.setSelectedSlot` {#Player.setSelectedSlot}

```zig
pub fn setSelectedSlot(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SET_SELECTED_SLOT`：`a` 为槽位，调用 `Player::setSelectedSlot`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.giveItem` {#Player.giveItem}

```zig
pub fn giveItem(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_GIVE_ITEM`：`sarg` 为物品 SNBT，经 `ItemStack::fromTag` 和 `Player::addAndRefresh` 给出

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.setSpawnPoint` {#Player.setSpawnPoint}

```zig
pub fn setSpawnPoint(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SET_SPAWN_POINT`：`a`、`b`、`c` 为坐标，`sarg` 为维度 id（任何已注册的维度都可以）；原生调用 `Player::setRespawnPosition`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.clearTitle` {#Player.clearTitle}

```zig
pub fn clearTitle(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_CLEAR_TITLE`：原生发送 `SetTitlePacket(Clear)`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.setTitle` {#Player.setTitle}

```zig
pub fn setTitle(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SET_TITLE`：`sarg` 为文本，`a` 为位置（0 主标题，1 副标题，2 动作栏）；原生发送 `SetTitlePacket`，文本原样发送

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.addExperience` {#Player.addExperience}

```zig
pub fn addExperience(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_ADD_EXPERIENCE`：`a` 为经验值，调用 `Player::addExperience`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.addLevels` {#Player.addLevels}

```zig
pub fn addLevels(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_ADD_LEVELS`：`a` 为等级数，调用 `Player::addLevels`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.startCooldown` {#Player.startCooldown}

```zig
pub fn startCooldown(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_START_COOLDOWN`：`sarg` 为物品名，`a` 为刻数，调用 `Player::startItemCooldown`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.startRiding` {#Player.startRiding}

```zig
pub fn startRiding(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_START_RIDING`：`a` 为坐骑的 `ActorUniqueID`（低 64 位），调用 `Player::startRiding`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.stopRiding` {#Player.stopRiding}

```zig
pub fn stopRiding(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_STOP_RIDING`：调用 `Player::stopRiding`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.attack` {#Player.attack}

```zig
pub fn attack(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_ATTACK`：`a` 为目标的 `ActorUniqueID`（低 64 位），调用 `Player::attack`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.drop` {#Player.drop}

```zig
pub fn drop(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_DROP`：`sarg` 为物品 SNBT，`a` 为是否随机抛出（0 或 1），调用 `Player::drop`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.interact` {#Player.interact}

```zig
pub fn interact(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_INTERACT`：`a` 为目标的 `ActorUniqueID`，调用 `Player::interact`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.startUsingItem` {#Player.startUsingItem}

```zig
pub fn startUsingItem(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_START_USING_ITEM`：`sarg` 为物品 SNBT，`a` 为持续时间，调用 `Player::startUsingItem`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.stopUsingItem` {#Player.stopUsingItem}

```zig
pub fn stopUsingItem(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_STOP_USING_ITEM`：调用 `Player::stopUsingItem`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.setChunkRadius` {#Player.setChunkRadius}

```zig
pub fn setChunkRadius(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SET_CHUNK_RADIUS`：`a` 为半径，调用 `Player::setChunkRadius`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.setEnchantmentSeed` {#Player.setEnchantmentSeed}

```zig
pub fn setEnchantmentSeed(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SET_ENCHANTMENT_SEED`：`a` 为种子，调用 `Player::setEnchantmentSeed`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.registerTrackedBoss` {#Player.registerTrackedBoss}

```zig
pub fn registerTrackedBoss(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_REGISTER_TRACKED_BOSS`：`a` 为 Boss 的 `ActorUniqueID`，调用 `Player::registerTrackedBoss`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.unregisterTrackedBoss` {#Player.unregisterTrackedBoss}

```zig
pub fn unregisterTrackedBoss(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_UNREGISTER_TRACKED_BOSS`：`a` 为 Boss 的 `ActorUniqueID`，调用 `Player::unRegisterTrackedBoss`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.playEmote` {#Player.playEmote}

```zig
pub fn playEmote(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_PLAY_EMOTE`：`sarg` 为表情的 id，调用 `Player::playEmote`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.resendAllChunks` {#Player.resendAllChunks}

```zig
pub fn resendAllChunks(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_RESEND_ALL_CHUNKS`：调用 `Player::resendAllChunks`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.openInventory` {#Player.openInventory}

```zig
pub fn openInventory(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_OPEN_INVENTORY`：调用 `Player::openInventory`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.sidebarSet` {#Player.sidebarSet}

```zig
pub fn sidebarSet(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SIDEBAR_SET`：`sarg` 为 `"obj\ntitle\nline…"`，只对这名玩家显示的侧边栏

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.sidebarClear` {#Player.sidebarClear}

```zig
pub fn sidebarClear(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SIDEBAR_CLEAR`：`sarg` 为计分项，发送 `RemoveObjectivePacket`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.setPermissionLevel` {#Player.setPermissionLevel}

```zig
pub fn setPermissionLevel(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_SET_PERMISSION_LEVEL`：`a` 为 `PlayerPermissionLevel`（0 Visitor，1 Member，2 Operator，3 Custom）。调用 `LayeredAbilities::setPlayerPermissions` 并发送 `UpdateAbilitiesPacket`。读取一侧是 `PIER_PPROP_PERMISSION_LEVEL`。和 `PIER_PACT_SET_ABILITY` 一样，玩家加入完成之前调用会被拒绝。

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.stopSleeping` {#Player.stopSleeping}

```zig
pub fn stopSleeping(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_STOP_SLEEPING`：a：非零时强制唤醒。`Player::stopSleepInBed`；没在睡觉时返回 false

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.causeExhaustion` {#Player.causeExhaustion}

```zig
pub fn causeExhaustion(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_CAUSE_EXHAUSTION`：a：数量，必须为正。`Player::causeFoodExhaustion`

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.eat` {#Player.eat}

```zig
pub fn eat(self: Player, allocator: std.mem.Allocator, s_arg: []const u8, n_a: f64, n_b: f64, n_c: f64) core.Error![]u8
```

`PIER_PACT_EAT`：sarg：物品 SNBT。`Player::eat`，按这个物品的食物值进食

这个动作有输出时，输出就是返回值；每个参数的含义写在 abi.h 里这个常量的注释中。

- 参数：
    - allocator : `std.mem.Allocator`
    - s_arg : `[]const u8`
    - n_a : `f64`
    - n_b : `f64`
    - n_c : `f64`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_action`](../cpp/player.md#player_action)

### `Player.asEntity` {#Player.asEntity}

```zig
pub fn asEntity(self: Player) core.Error!Entity
```

把选择器解析成这名玩家对应的实体，这样就可以使用 `Entity` 的各个调用。玩家不在线时为 `NoAnswer`。

- 返回值类型：`core.Error!Entity`
- 对应槽位：[`player_resolve`](../cpp/player.md#player_resolve)

### `Player.isOnline` {#Player.isOnline}

```zig
pub fn isOnline(self: Player) bool
```

这个选择器现在是否能解析到某名在线玩家。

- 返回值类型：`bool`
- 对应槽位：[`player_resolve`](../cpp/player.md#player_resolve)

### `Player.connId` {#Player.connId}

```zig
pub fn connId(self: Player) core.Error!u64
```

这名玩家的连接 id，和数据包处理函数看到的是同一个数。玩家不在线、或者没有网络身份时为 `NoAnswer`。

- 返回值类型：`core.Error!u64`
- 对应槽位：[`player_conn_id`](../cpp/player.md#player_conn_id)

### `Player.teleport` {#Player.teleport}

```zig
pub fn teleport(self: Player, dim: i32, x: f64, y: f64, z: f64) core.Error!void
```

传送。自定义维度（id 为 3 或更大）也走这里，宿主会拒绝引擎实例对不上的维度。

- 参数：
    - dim : `i32`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_teleport`](../cpp/player.md#player_teleport)

### `Player.sendMessage` {#Player.sendMessage}

```zig
pub fn sendMessage(self: Player, msg: []const u8) core.Error!void
```

- 参数：
    - msg : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_send_message`](../cpp/player.md#player_send_message)

### `Player.tell` {#Player.tell}

```zig
pub fn tell(self: Player, msg: []const u8, kind: types.MessageType) core.Error!void
```

以给定的 `TextPacketType` 发送一条消息。

- 参数：
    - msg : `[]const u8`
    - kind : `types.MessageType`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_send_message_typed`](../cpp/player.md#player_send_message_typed)

### `Player.sendTitle` {#Player.sendTitle}

```zig
pub fn sendTitle(self: Player, kind: types.TitleKind, text: []const u8, times: ?types.TitleTimes) core.Error!void
```

发送一个标题。只有标题、副标题和动作栏带文字。`times` 为 null 时持续时间交给宿主决定。

- 参数：
    - kind : `types.TitleKind`
    - text : `[]const u8`
    - times : `?types.TitleTimes`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_send_title`](../cpp/player.md#player_send_title)

### `Player.setGameMode` {#Player.setGameMode}

```zig
pub fn setGameMode(self: Player, mode: types.GameMode) core.Error!void
```

- 参数：
    - mode : `types.GameMode`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_set_gamemode`](../cpp/player.md#player_set_gamemode)

### `Player.disconnect` {#Player.disconnect}

```zig
pub fn disconnect(self: Player, reason: []const u8) core.Error!void
```

把玩家踢下线，原因会显示在客户端上。

- 参数：
    - reason : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_disconnect`](../cpp/player.md#player_disconnect)

### `Player.item` {#Player.item}

```zig
pub fn item(self: Player, allocator: std.mem.Allocator, slot: i32) core.Error![]u8
```

一个背包格子，物品 SNBT 形式，由调用方持有。

- 参数：
    - allocator : `std.mem.Allocator`
    - slot : `i32`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_item`](../cpp/player.md#player_get_item)

### `Player.setItem` {#Player.setItem}

```zig
pub fn setItem(self: Player, slot: i32, item_snbt: []const u8) core.Error!void
```

写入一个背包格子。之后要刷新容器，否则客户端还会继续显示旧物品。

- 参数：
    - slot : `i32`
    - item_snbt : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_set_item`](../cpp/player.md#player_set_item)

### `Player.carriedItem` {#Player.carriedItem}

```zig
pub fn carriedItem(self: Player, allocator: std.mem.Allocator) core.Error![]u8
```

手里的物品，物品 SNBT 形式，由调用方持有。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`player_get_carried_item`](../cpp/player.md#player_get_carried_item)

### `Player.equipment` {#Player.equipment}

```zig
pub fn equipment(self: Player, allocator: std.mem.Allocator) core.Error!types.Owned(types.EquipmentEntry)
```

完整的装备。`slot` 的编号见 `types.EquipSlot`。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error!types.Owned(types.EquipmentEntry)`
- 对应槽位：[`player_get_equipment`](../cpp/player.md#player_get_equipment)

### `Player.cooldown` {#Player.cooldown}

```zig
pub fn cooldown(self: Player, item_name: []const u8) core.Error!?i32
```

一个物品还剩多少 tick 的冷却；不在冷却中时为 null。

- 参数：
    - item_name : `[]const u8`
- 返回值类型：`core.Error!?i32`
- 对应槽位：[`player_get_cooldown`](../cpp/player.md#player_get_cooldown)

### `Player.setCooldown` {#Player.setCooldown}

```zig
pub fn setCooldown(self: Player, item_name: []const u8, ticks: i32) core.Error!void
```

- 参数：
    - item_name : `[]const u8`
    - ticks : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`player_start_cooldown`](../cpp/player.md#player_start_cooldown)

### `Player.networkDetail` {#Player.networkDetail}

```zig
pub fn networkDetail(self: Player, allocator: std.mem.Allocator) core.Error!types.NetworkStatus
```

详细的网络状态。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error!types.NetworkStatus`
- 对应槽位：[`player_get_network_status`](../cpp/player.md#player_get_network_status)

### `Player.position` {#Player.position}

```zig
pub fn position(self: Player, allocator: std.mem.Allocator) core.Error!types.PlayerPosition
```

脚下位置和所在维度。它走专用槽位而不是属性编号，因为位置要同时给出三个数和一个 id。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error!types.PlayerPosition`
- 对应槽位：[`get_player_position`](../cpp/player.md#get_player_position)、[`player_get_str`](../cpp/player.md#player_get_str)

### `Player.inventory` {#Player.inventory}

```zig
pub fn inventory(self: Player) container.Container
```

- 返回值类型：`container.Container`

### `Player.enderChest` {#Player.enderChest}

```zig
pub fn enderChest(self: Player) container.Container
```

- 返回值类型：`container.Container`

### `Player.armor` {#Player.armor}

```zig
pub fn armor(self: Player) container.Container
```

- 返回值类型：`container.Container`

### `Player.offhandContainer` {#Player.offhandContainer}

```zig
pub fn offhandContainer(self: Player) container.Container
```

- 返回值类型：`container.Container`

## `SelKind` {#SelKind}

```zig
pub const SelKind = enum(i32) {
    name = 0, xuid = 1, uuid = 2
};
```

`Player` 选择器用什么来指定玩家。关于权限、金钱或归属的判断，要以 xuid 为键：名字会换主人。
