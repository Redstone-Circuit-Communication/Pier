# Zig：客户端

## 声明 {#declarations}

### `client.KeyHandler` {#client.KeyHandler}

```zig
pub const KeyHandler = fn (user: ?*anyopaque, action: KeyAction, impact: i32) void;
```

已注册按键每次按下和松开时在客户端线程上调用：注册时给出的 `user` 指针、动作，以及引擎报告的焦点影响。

## 函数 {#functions}

### `client.property` {#client.property}

```zig
pub fn property(prop: i32) core.Error!f64
```

按 PIER_CPROP_* 键读取一个数值型的客户端属性。宿主不认识这个键、或者客户端不在世界里时读取关于本地玩家的键，得到 `NoAnswer`。

- 参数：
    - prop : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.localPosition` {#client.localPosition}

```zig
pub fn localPosition() core.Error![3]f64
```

本地玩家脚下的位置：x、y、z。

- 返回值类型：`core.Error![3]f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.localRotation` {#client.localRotation}

```zig
pub fn localRotation() core.Error![2]f64
```

本地玩家的 pitch 和 yaw，单位为度；pitch 为负表示向上看。

- 返回值类型：`core.Error![2]f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.localDimension` {#client.localDimension}

```zig
pub fn localDimension() core.Error!i32
```

本地玩家所在维度的 id。

- 返回值类型：`core.Error!i32`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.guiScale` {#client.guiScale}

```zig
pub fn guiScale() core.Error!f64
```

这个客户端绘制界面所用的 GUI 缩放。

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.serverPingMs` {#client.serverPingMs}

```zig
pub fn serverPingMs() core.Error!f64
```

到服务器的往返延迟，单位毫秒，由这个客户端测得。

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingMenu` {#client.isShowingMenu}

```zig
pub fn isShowingMenu() core.Error!bool
```

是否正在显示菜单界面。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingPauseScreen` {#client.isShowingPauseScreen}

```zig
pub fn isShowingPauseScreen() core.Error!bool
```

是否正在显示暂停界面。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPlaying` {#client.isPlaying}

```zig
pub fn isPlaying() core.Error!bool
```

客户端是否正在游玩一个世界。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInRealm` {#client.isInRealm}

```zig
pub fn isInRealm() core.Error!bool
```

当前世界是否是 Realm。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isGameInputEnabled` {#client.isGameInputEnabled}

```zig
pub fn isGameInputEnabled() core.Error!bool
```

游戏输入是否能到达世界；上层有界面时就不能。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.topScreenName` {#client.topScreenName}

```zig
pub fn topScreenName(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

客户端界面栈最顶层的界面，由调用方持有。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client.registeredKeys` {#client.registeredKeys}

```zig
pub fn registeredKeys(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![][]u8
```

按键注册表里所有按键绑定的名字，不论是哪个 mod 注册的。每个名字和切片都由调用方释放。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![][]u8`
- 对应槽位：[`client_list_keys`](../cpp/client.md#client_list_keys)

### `client.showMessage` {#client.showMessage}

```zig
pub fn showMessage(text: []const u8) core.Error!void
```

在这个客户端的聊天栏里显示文字。不会向服务器发送任何东西。

- 参数：
    - text : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setTitle` {#client.setTitle}

```zig
pub fn setTitle(text: []const u8) core.Error!void
```

在这个客户端上把文字显示为标题。

- 参数：
    - text : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setSubtitle` {#client.setSubtitle}

```zig
pub fn setSubtitle(text: []const u8) core.Error!void
```

在这个客户端上把文字显示为副标题。

- 参数：
    - text : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setActionBar` {#client.setActionBar}

```zig
pub fn setActionBar(text: []const u8) core.Error!void
```

在这个客户端的快捷栏上方显示文字。

- 参数：
    - text : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.showTip` {#client.showTip}

```zig
pub fn showTip(text: []const u8) core.Error!void
```

在这个客户端上把文字显示为提示。

- 参数：
    - text : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.playUiSound` {#client.playUiSound}

```zig
pub fn playUiSound(name: []const u8, volume: f64, pitch: f64) core.Error!void
```

在这个客户端上按名字播放一个界面音效，例如 "random.click"。

- 参数：
    - name : `[]const u8`
    - volume : `f64`
    - pitch : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.grabMouse` {#client.grabMouse}

```zig
pub fn grabMouse() core.Error!void
```

让游戏捕获鼠标，效果和点击进入世界一样。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.releaseMouse` {#client.releaseMouse}

```zig
pub fn releaseMouse() core.Error!void
```

把鼠标释放给界面。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setInputDisabled` {#client.setInputDisabled}

```zig
pub fn setInputDisabled(disabled: bool) core.Error!void
```

禁用或启用游戏输入。

- 参数：
    - disabled : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.leaveLevel` {#client.leaveLevel}

```zig
pub fn leaveLevel() core.Error!void
```

离开当前世界回到菜单。引擎以异步方式完成。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.health` {#client.health}

```zig
pub fn health() core.Error!f64
```

本地玩家的 `Actor::getHealth`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.maxHealth` {#client.maxHealth}

```zig
pub fn maxHealth() core.Error!f64
```

本地玩家的 `Actor::getMaxHealth`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isOnGround` {#client.isOnGround}

```zig
pub fn isOnGround() core.Error!bool
```

本地玩家的 `Actor::isOnGround`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInWater` {#client.isInWater}

```zig
pub fn isInWater() core.Error!bool
```

本地玩家的 `Actor::isInWater`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSneaking` {#client.isSneaking}

```zig
pub fn isSneaking() core.Error!bool
```

本地玩家的 `Actor::isSneaking`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSprinting` {#client.isSprinting}

```zig
pub fn isSprinting() core.Error!bool
```

本地玩家的 `Actor::isSprinting`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSwimming` {#client.isSwimming}

```zig
pub fn isSwimming() core.Error!bool
```

本地玩家的 `Actor::isSwimming`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isOnFire` {#client.isOnFire}

```zig
pub fn isOnFire() core.Error!bool
```

本地玩家的 `Actor::isOnFire`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isFlying` {#client.isFlying}

```zig
pub fn isFlying() core.Error!bool
```

本地玩家的 `Player::isFlying`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.gameType` {#client.gameType}

```zig
pub fn gameType() core.Error!f64
```

本地玩家的 `Player::getPlayerGameType`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.selectedSlot` {#client.selectedSlot}

```zig
pub fn selectedSlot() core.Error!f64
```

本地玩家的 `Player::getSelectedItemSlot`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.velX` {#client.velX}

```zig
pub fn velX() core.Error!f64
```

本地玩家的 `Actor::getPosDelta`，单位为方块每刻

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.velY` {#client.velY}

```zig
pub fn velY() core.Error!f64
```

`Actor::getPosDelta` 的竖直分量

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.velZ` {#client.velZ}

```zig
pub fn velZ() core.Error!f64
```

`Actor::getPosDelta` 的 z 分量

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.xpNeededNextLevel` {#client.xpNeededNextLevel}

```zig
pub fn xpNeededNextLevel() core.Error!f64
```

本地玩家的 `Player::getXpNeededForNextLevel`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isLeavingGame` {#client.isLeavingGame}

```zig
pub fn isLeavingGame() core.Error!bool
```

`IClientInstance::isLeavingGame`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isExitingLevel` {#client.isExitingLevel}

```zig
pub fn isExitingLevel() core.Error!bool
```

`IClientInstance::isExitingLevel`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInBedScreen` {#client.isInBedScreen}

```zig
pub fn isInBedScreen() core.Error!bool
```

`IClientInstance::isInBedScreen`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInDeathScreen` {#client.isInDeathScreen}

```zig
pub fn isInDeathScreen() core.Error!bool
```

`IClientInstance::isInDeathScreen`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingLoadingScreen` {#client.isShowingLoadingScreen}

```zig
pub fn isShowingLoadingScreen() core.Error!bool
```

`IClientInstance::isShowingLoadingScreen`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingProgressScreen` {#client.isShowingProgressScreen}

```zig
pub fn isShowingProgressScreen() core.Error!bool
```

`IClientInstance::isShowingProgressScreen`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingWorldProgressScreen` {#client.isShowingWorldProgressScreen}

```zig
pub fn isShowingWorldProgressScreen() core.Error!bool
```

`IClientInstance::isShowingWorldProgressScreen`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingDeathScreen` {#client.isShowingDeathScreen}

```zig
pub fn isShowingDeathScreen() core.Error!bool
```

`IClientInstance::isShowingDeathScreen`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingServerForm` {#client.isShowingServerForm}

```zig
pub fn isShowingServerForm() core.Error!bool
```

`IClientInstance::isShowingServerForm`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInWorldWithoutMenu` {#client.isInWorldWithoutMenu}

```zig
pub fn isInWorldWithoutMenu() core.Error!bool
```

`IClientInstance::isInWorldAndNotShowingAnyMenuScreens`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isWorldActive` {#client.isWorldActive}

```zig
pub fn isWorldActive() core.Error!bool
```

`IClientInstance::isWorldActive`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.hasLevel` {#client.hasLevel}

```zig
pub fn hasLevel() core.Error!bool
```

`IClientInstance::hasLevel`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPreGame` {#client.isPreGame}

```zig
pub fn isPreGame() core.Error!bool
```

`IClientInstance::isPreGame`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInMultiplayerGame` {#client.isInMultiplayerGame}

```zig
pub fn isInMultiplayerGame() core.Error!bool
```

`IClientInstance::isInMultiplayerGame`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isMultiplayerClient` {#client.isMultiplayerClient}

```zig
pub fn isMultiplayerClient() core.Error!bool
```

`IClientInstance::isMultiPlayerClient`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPrimaryLevelMultiplayer` {#client.isPrimaryLevelMultiplayer}

```zig
pub fn isPrimaryLevelMultiplayer() core.Error!bool
```

`IClientInstance::isPrimaryLevelMultiplayer`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPrimaryLevelCrossPlatform` {#client.isPrimaryLevelCrossPlatform}

```zig
pub fn isPrimaryLevelCrossPlatform() core.Error!bool
```

`IClientInstance::isPrimaryLevelCrossPlatformMultiplayer`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isKeyboardEnabled` {#client.isKeyboardEnabled}

```zig
pub fn isKeyboardEnabled() core.Error!bool
```

`IClientInstance::isKeyboardEnabled`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isUsingController` {#client.isUsingController}

```zig
pub fn isUsingController() core.Error!bool
```

`IClientInstance::useController`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isUsingTouchscreen` {#client.isUsingTouchscreen}

```zig
pub fn isUsingTouchscreen() core.Error!bool
```

`IClientInstance::useTouchscreen`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isMouseGrabbed` {#client.isMouseGrabbed}

```zig
pub fn isMouseGrabbed() core.Error!bool
```

`IClientInstance::getMouseGrabbed`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isMouseAndKeyboard` {#client.isMouseAndKeyboard}

```zig
pub fn isMouseAndKeyboard() core.Error!bool
```

`IClientInstance::currentInputModeIsMouseAndKeyboard`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.hasConnectedController` {#client.hasConnectedController}

```zig
pub fn hasConnectedController() core.Error!bool
```

`IClientInstance::hasConnectedController`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.controllerId` {#client.controllerId}

```zig
pub fn controllerId() core.Error!f64
```

`IClientInstance::getControllerId`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isTouchGameplayAllowed` {#client.isTouchGameplayAllowed}

```zig
pub fn isTouchGameplayAllowed() core.Error!bool
```

`IClientInstance::isTouchGameplayAllowed`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSplitScreenActive` {#client.isSplitScreenActive}

```zig
pub fn isSplitScreenActive() core.Error!bool
```

`IClientInstance::isSplitScreenActive`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.splitScreenCount` {#client.splitScreenCount}

```zig
pub fn splitScreenCount() core.Error!f64
```

`IClientInstance::getSplitScreenCount`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.guiScaleOffset` {#client.guiScaleOffset}

```zig
pub fn guiScaleOffset() core.Error!f64
```

`IClientInstance::getGuiScaleOffset`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isEduMode` {#client.isEduMode}

```zig
pub fn isEduMode() core.Error!bool
```

`IClientInstance::isEduMode`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInEditor` {#client.isInEditor}

```zig
pub fn isInEditor() core.Error!bool
```

`IClientInstance::isPlayerInEditor`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isReadyToRender` {#client.isReadyToRender}

```zig
pub fn isReadyToRender() core.Error!bool
```

`IClientInstance::isReadyToRender`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isFullVanillaPackOnStack` {#client.isFullVanillaPackOnStack}

```zig
pub fn isFullVanillaPackOnStack() core.Error!bool
```

`IClientInstance::isFullVanillaPackOnStack`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.serverConnectionTime` {#client.serverConnectionTime}

```zig
pub fn serverConnectionTime() core.Error!f64
```

`IClientInstance::getServerConnectionTime`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.remoteServerTimeMs` {#client.remoteServerTimeMs}

```zig
pub fn remoteServerTimeMs() core.Error!f64
```

`IClientInstance::getRemoteServerTimeMs`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.remoteServerNetworkTimeMs` {#client.remoteServerNetworkTimeMs}

```zig
pub fn remoteServerNetworkTimeMs() core.Error!f64
```

`IClientInstance::getRemoteServerNetworkTimeMs`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.frameAlpha` {#client.frameAlpha}

```zig
pub fn frameAlpha() core.Error!f64
```

`IClientInstance::getFrameAlpha`，当前帧处在两刻之间的位置

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.gameUpdateSeconds` {#client.gameUpdateSeconds}

```zig
pub fn gameUpdateSeconds() core.Error!f64
```

`IClientInstance::getGameUpdateDurationInSeconds`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPrimaryClient` {#client.isPrimaryClient}

```zig
pub fn isPrimaryClient() core.Error!bool
```

`IClientInstance::isPrimaryClient`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.userId` {#client.userId}

```zig
pub fn userId() core.Error!f64
```

`IClientInstance::getUserId`

- 返回值类型：`core.Error!f64`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.isGameplayTipsEnabled` {#client.isGameplayTipsEnabled}

```zig
pub fn isGameplayTipsEnabled() core.Error!bool
```

`IClientInstance::isGamePlayTipsEnabled`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.hasCommands` {#client.hasCommands}

```zig
pub fn hasCommands() core.Error!bool
```

`IClientInstance::hasCommands`

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client.platformId` {#client.platformId}

```zig
pub fn platformId(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`IClientInstance::getPlatformId`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client.platformOnlineId` {#client.platformOnlineId}

```zig
pub fn platformOnlineId(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`IClientInstance::getPlatformOnlineId`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client.localXuid` {#client.localXuid}

```zig
pub fn localXuid(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

本地玩家的 `Player::getXuid`；不在世界里时失败

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client.localUuid` {#client.localUuid}

```zig
pub fn localUuid(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

本地玩家的 `Player::getUuid`，规范字符串形式

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client.localNameTag` {#client.localNameTag}

```zig
pub fn localNameTag(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

本地玩家的 `Actor::getNameTag`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client.clipboard` {#client.clipboard}

```zig
pub fn clipboard(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`AppPlatform::getClipboardText`，系统剪贴板

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client.showPopup` {#client.showPopup}

```zig
pub fn showPopup(text: []const u8) core.Error!void
```

显示一个弹出提示；文字里的换行把消息和副标题分开。

- 参数：
    - text : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.showDevConsoleMessage` {#client.showDevConsoleMessage}

```zig
pub fn showDevConsoleMessage(text: []const u8) core.Error!void
```

把文字写入开发者控制台。

- 参数：
    - text : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setSuspendInput` {#client.setSuspendInput}

```zig
pub fn setSuspendInput(suspended: bool) core.Error!void
```

暂停或恢复全部输入。

- 参数：
    - suspended : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setSuspendDirectionalInput` {#client.setSuspendDirectionalInput}

```zig
pub fn setSuspendDirectionalInput(suspended: bool) core.Error!void
```

暂停或恢复移动输入。

- 参数：
    - suspended : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setGameInputEnabled` {#client.setGameInputEnabled}

```zig
pub fn setGameInputEnabled(enabled: bool) core.Error!void
```

启用或禁用游戏输入。

- 参数：
    - enabled : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.refocusMouse` {#client.refocusMouse}

```zig
pub fn refocusMouse(lost: bool) core.Error!void
```

把鼠标交还给游戏。

- 参数：
    - lost : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.muteAudio` {#client.muteAudio}

```zig
pub fn muteAudio() core.Error!void
```

把客户端静音。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.unmuteAudio` {#client.unmuteAudio}

```zig
pub fn unmuteAudio() core.Error!void
```

取消客户端静音。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.fadeOutMusic` {#client.fadeOutMusic}

```zig
pub fn fadeOutMusic() core.Error!void
```

让正在播放的音乐淡出。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setGuiScaleOffset` {#client.setGuiScaleOffset}

```zig
pub fn setGuiScaleOffset(offset: i32) core.Error!void
```

设置 GUI 缩放偏移。

- 参数：
    - offset : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.resetPlayerMovement` {#client.resetPlayerMovement}

```zig
pub fn resetPlayerMovement() core.Error!void
```

重置本地玩家的移动输入。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.pushLeaveGameScreen` {#client.pushLeaveGameScreen}

```zig
pub fn pushLeaveGameScreen() core.Error!void
```

打开询问是否离开世界的界面。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.openContentLogHistory` {#client.openContentLogHistory}

```zig
pub fn openContentLogHistory() core.Error!void
```

打开内容日志历史。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.setClipboard` {#client.setClipboard}

```zig
pub fn setClipboard(value: []const u8) core.Error!void
```

把 value 写入系统剪贴板。

- 参数：
    - value : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.navigateHowToPlay` {#client.navigateHowToPlay}

```zig
pub fn navigateHowToPlay(topic: []const u8) core.Error!void
```

打开“游戏指南”并定位到 topic，主题为空时打开首页。

- 参数：
    - topic : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client.options` {#client.options}

```zig
pub fn options(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]OptionPair
```

全部客户端选项。每个键、每个值和切片都由调用方释放。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]OptionPair`
- 对应槽位：[`client_option_list`](../cpp/client.md#client_option_list)

### `client.option` {#client.option}

```zig
pub fn option(key: []const u8, allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

按 options.txt 里的键读取一个客户端选项，由调用方持有。

- 参数：
    - key : `[]const u8`
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_option_get`](../cpp/client.md#client_option_get)

### `client.setOption` {#client.setOption}

```zig
pub fn setOption(key: []const u8, value: []const u8) core.Error!void
```

用 options.txt 的文本形式写入一个客户端选项；读回来才能看到引擎保留了什么。

- 参数：
    - key : `[]const u8`
    - value : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`client_option_set`](../cpp/client.md#client_option_set)

### `client.registerKey` {#client.registerKey}

```zig
pub fn registerKey(name: []const u8, key_codes: []const i32, allow_remap: bool, user: ?*anyopaque, comptime handler: KeyHandler) core.Error!KeyBinding
```

以 `name` 注册一个按键绑定，默认按键码为 `key_codes`。`allow_remap` 允许玩家重新绑定。名字已被占用、或按键码列表为空时得到 `Refused`。

- 参数：
    - name : `[]const u8`
    - key_codes : `[]const i32`
    - allow_remap : `bool`
    - user : `?*anyopaque`
    - handler : `comptime KeyHandler`
- 返回值类型：`core.Error!KeyBinding`
- 对应槽位：[`client_register_key`](../cpp/client.md#client_register_key)

### `client.isInLevel` {#client.isInLevel}

```zig
pub fn isInLevel() core.Error!bool
```

客户端是否在一个 level 里，也就是是否已经加载了世界。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `client.localPlayerName` {#client.localPlayerName}

```zig
pub fn localPlayerName(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

本地玩家的名字，由调用方持有。不在 level 里时为 `NoAnswer`。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]u8`
- 对应槽位：[`client_get_local_player`](../cpp/client.md#client_get_local_player)

## `client.KeyBinding` {#client.KeyBinding}

```zig
pub const KeyBinding = struct {
    handle: c.PierKeyHandle,
    // ...
};
```

一个已注册的按键绑定，留着它是为了之后注销。

### `client.KeyBinding.keyCodes` {#client.KeyBinding.keyCodes}

```zig
pub fn keyCodes(self: KeyBinding, allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]i32
```

当前分配的按键码；玩家重新映射过按键时，它和默认值不同。由调用方持有。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`(core.Error || std.mem.Allocator.Error)![]i32`
- 对应槽位：[`client_get_key_codes`](../cpp/client.md#client_get_key_codes)

### `client.KeyBinding.unregister` {#client.KeyBinding.unregister}

```zig
pub fn unregister(self: *KeyBinding) core.Error!void
```

注销这个绑定：这个 mod 的处理函数不再触发。引擎对每个名字只保留一个按键，也没有移除的接口，所以再次注册同一个名字会复用它。调用两次也没有害处。

- 返回值类型：`core.Error!void`
- 对应槽位：[`client_unregister_key`](../cpp/client.md#client_unregister_key)

## `client.KeyAction` {#client.KeyAction}

```zig
pub const KeyAction = enum(i32) {
    up = 0,
    down = 1,
    _,
};
```

一个按键绑定上报的动作。

### `client.KeyAction.isDown` {#client.KeyAction.isDown}

```zig
pub fn isDown(self: KeyAction) bool
```

- 返回值类型：`bool`

## `client.OptionPair` {#client.OptionPair}

```zig
pub const OptionPair = struct {
    key: []u8,
    value: []u8,
    // ...
};
```

一个客户端选项：它在 options.txt 里的键，以及那种文本形式的值。
