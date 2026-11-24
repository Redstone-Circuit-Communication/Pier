# Zig: Client

## Declarations {#declarations}

### `client.KeyHandler` {#client.KeyHandler}

```zig
pub const KeyHandler = fn (user: ?*anyopaque, action: KeyAction, impact: i32) void;
```

Called on the client thread for each press and release of a registered key: the `user` pointer given at registration, the action, and the focus impact the engine reports.

## Functions {#functions}

### `client.property` {#client.property}

```zig
pub fn property(prop: i32) core.Error!f64
```

One numeric client property by its PIER\_CPROP\_\* key. NoAnswer for a key this host does not know, or a key about the local player while the client is not in a world.

- Parameters:
    - prop : `i32`
- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.localPosition` {#client.localPosition}

```zig
pub fn localPosition() core.Error![3]f64
```

The local player's feet position: x, y and z.

- Return type: `core.Error![3]f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.localRotation` {#client.localRotation}

```zig
pub fn localRotation() core.Error![2]f64
```

The local player's pitch and yaw in degrees; a negative pitch looks up.

- Return type: `core.Error![2]f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.localDimension` {#client.localDimension}

```zig
pub fn localDimension() core.Error!i32
```

The id of the dimension the local player is in.

- Return type: `core.Error!i32`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.guiScale` {#client.guiScale}

```zig
pub fn guiScale() core.Error!f64
```

The GUI scale this client draws with.

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.serverPingMs` {#client.serverPingMs}

```zig
pub fn serverPingMs() core.Error!f64
```

The round trip to the server in milliseconds, as this client measures it.

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingMenu` {#client.isShowingMenu}

```zig
pub fn isShowingMenu() core.Error!bool
```

Whether a menu screen is showing.

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingPauseScreen` {#client.isShowingPauseScreen}

```zig
pub fn isShowingPauseScreen() core.Error!bool
```

Whether the pause screen is showing.

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPlaying` {#client.isPlaying}

```zig
pub fn isPlaying() core.Error!bool
```

Whether the client is playing a world.

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInRealm` {#client.isInRealm}

```zig
pub fn isInRealm() core.Error!bool
```

Whether the world is a Realm.

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isGameInputEnabled` {#client.isGameInputEnabled}

```zig
pub fn isGameInputEnabled() core.Error!bool
```

Whether game input reaches the world, which a screen on top takes away.

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.topScreenName` {#client.topScreenName}

```zig
pub fn topScreenName(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

The topmost screen of the client's screen stack, owned by the caller.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client.registeredKeys` {#client.registeredKeys}

```zig
pub fn registeredKeys(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![][]u8
```

Every key binding name the key registry holds, whichever mod registered it. The caller frees each name and the slice.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![][]u8`
- Slots: [`client_list_keys`](../cpp/client.md#client_list_keys)

### `client.showMessage` {#client.showMessage}

```zig
pub fn showMessage(text: []const u8) core.Error!void
```

Shows text in this client's chat. Nothing is sent to a server.

- Parameters:
    - text : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setTitle` {#client.setTitle}

```zig
pub fn setTitle(text: []const u8) core.Error!void
```

Shows text as the title on this client.

- Parameters:
    - text : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setSubtitle` {#client.setSubtitle}

```zig
pub fn setSubtitle(text: []const u8) core.Error!void
```

Shows text as the subtitle on this client.

- Parameters:
    - text : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setActionBar` {#client.setActionBar}

```zig
pub fn setActionBar(text: []const u8) core.Error!void
```

Shows text above the hotbar on this client.

- Parameters:
    - text : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.showTip` {#client.showTip}

```zig
pub fn showTip(text: []const u8) core.Error!void
```

Shows text as a tip on this client.

- Parameters:
    - text : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.playUiSound` {#client.playUiSound}

```zig
pub fn playUiSound(name: []const u8, volume: f64, pitch: f64) core.Error!void
```

Plays a UI sound by name on this client, such as "random.click".

- Parameters:
    - name : `[]const u8`
    - volume : `f64`
    - pitch : `f64`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.grabMouse` {#client.grabMouse}

```zig
pub fn grabMouse() core.Error!void
```

Captures the mouse for the game, as a click into the world does.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.releaseMouse` {#client.releaseMouse}

```zig
pub fn releaseMouse() core.Error!void
```

Releases the mouse to the screen.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setInputDisabled` {#client.setInputDisabled}

```zig
pub fn setInputDisabled(disabled: bool) core.Error!void
```

Disables or enables game input.

- Parameters:
    - disabled : `bool`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.leaveLevel` {#client.leaveLevel}

```zig
pub fn leaveLevel() core.Error!void
```

Leaves the current world for the menus. The engine does it asynchronously.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.health` {#client.health}

```zig
pub fn health() core.Error!f64
```

`Actor::getHealth` of the local player

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.maxHealth` {#client.maxHealth}

```zig
pub fn maxHealth() core.Error!f64
```

`Actor::getMaxHealth` of the local player

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isOnGround` {#client.isOnGround}

```zig
pub fn isOnGround() core.Error!bool
```

`Actor::isOnGround` of the local player

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInWater` {#client.isInWater}

```zig
pub fn isInWater() core.Error!bool
```

`Actor::isInWater` of the local player

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSneaking` {#client.isSneaking}

```zig
pub fn isSneaking() core.Error!bool
```

`Actor::isSneaking` of the local player

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSprinting` {#client.isSprinting}

```zig
pub fn isSprinting() core.Error!bool
```

`Actor::isSprinting` of the local player

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSwimming` {#client.isSwimming}

```zig
pub fn isSwimming() core.Error!bool
```

`Actor::isSwimming` of the local player

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isOnFire` {#client.isOnFire}

```zig
pub fn isOnFire() core.Error!bool
```

`Actor::isOnFire` of the local player

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isFlying` {#client.isFlying}

```zig
pub fn isFlying() core.Error!bool
```

`Player::isFlying` of the local player

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.gameType` {#client.gameType}

```zig
pub fn gameType() core.Error!f64
```

`Player::getPlayerGameType` of the local player

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.selectedSlot` {#client.selectedSlot}

```zig
pub fn selectedSlot() core.Error!f64
```

`Player::getSelectedItemSlot` of the local player

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.velX` {#client.velX}

```zig
pub fn velX() core.Error!f64
```

`Actor::getPosDelta` of the local player, blocks per tick

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.velY` {#client.velY}

```zig
pub fn velY() core.Error!f64
```

`Actor::getPosDelta`, the vertical part

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.velZ` {#client.velZ}

```zig
pub fn velZ() core.Error!f64
```

`Actor::getPosDelta`, the z part

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.xpNeededNextLevel` {#client.xpNeededNextLevel}

```zig
pub fn xpNeededNextLevel() core.Error!f64
```

`Player::getXpNeededForNextLevel` of the local player

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isLeavingGame` {#client.isLeavingGame}

```zig
pub fn isLeavingGame() core.Error!bool
```

`IClientInstance::isLeavingGame`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isExitingLevel` {#client.isExitingLevel}

```zig
pub fn isExitingLevel() core.Error!bool
```

`IClientInstance::isExitingLevel`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInBedScreen` {#client.isInBedScreen}

```zig
pub fn isInBedScreen() core.Error!bool
```

`IClientInstance::isInBedScreen`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInDeathScreen` {#client.isInDeathScreen}

```zig
pub fn isInDeathScreen() core.Error!bool
```

`IClientInstance::isInDeathScreen`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingLoadingScreen` {#client.isShowingLoadingScreen}

```zig
pub fn isShowingLoadingScreen() core.Error!bool
```

`IClientInstance::isShowingLoadingScreen`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingProgressScreen` {#client.isShowingProgressScreen}

```zig
pub fn isShowingProgressScreen() core.Error!bool
```

`IClientInstance::isShowingProgressScreen`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingWorldProgressScreen` {#client.isShowingWorldProgressScreen}

```zig
pub fn isShowingWorldProgressScreen() core.Error!bool
```

`IClientInstance::isShowingWorldProgressScreen`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingDeathScreen` {#client.isShowingDeathScreen}

```zig
pub fn isShowingDeathScreen() core.Error!bool
```

`IClientInstance::isShowingDeathScreen`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isShowingServerForm` {#client.isShowingServerForm}

```zig
pub fn isShowingServerForm() core.Error!bool
```

`IClientInstance::isShowingServerForm`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInWorldWithoutMenu` {#client.isInWorldWithoutMenu}

```zig
pub fn isInWorldWithoutMenu() core.Error!bool
```

`IClientInstance::isInWorldAndNotShowingAnyMenuScreens`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isWorldActive` {#client.isWorldActive}

```zig
pub fn isWorldActive() core.Error!bool
```

`IClientInstance::isWorldActive`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.hasLevel` {#client.hasLevel}

```zig
pub fn hasLevel() core.Error!bool
```

`IClientInstance::hasLevel`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPreGame` {#client.isPreGame}

```zig
pub fn isPreGame() core.Error!bool
```

`IClientInstance::isPreGame`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInMultiplayerGame` {#client.isInMultiplayerGame}

```zig
pub fn isInMultiplayerGame() core.Error!bool
```

`IClientInstance::isInMultiplayerGame`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isMultiplayerClient` {#client.isMultiplayerClient}

```zig
pub fn isMultiplayerClient() core.Error!bool
```

`IClientInstance::isMultiPlayerClient`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPrimaryLevelMultiplayer` {#client.isPrimaryLevelMultiplayer}

```zig
pub fn isPrimaryLevelMultiplayer() core.Error!bool
```

`IClientInstance::isPrimaryLevelMultiplayer`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPrimaryLevelCrossPlatform` {#client.isPrimaryLevelCrossPlatform}

```zig
pub fn isPrimaryLevelCrossPlatform() core.Error!bool
```

`IClientInstance::isPrimaryLevelCrossPlatformMultiplayer`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isKeyboardEnabled` {#client.isKeyboardEnabled}

```zig
pub fn isKeyboardEnabled() core.Error!bool
```

`IClientInstance::isKeyboardEnabled`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isUsingController` {#client.isUsingController}

```zig
pub fn isUsingController() core.Error!bool
```

`IClientInstance::useController`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isUsingTouchscreen` {#client.isUsingTouchscreen}

```zig
pub fn isUsingTouchscreen() core.Error!bool
```

`IClientInstance::useTouchscreen`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isMouseGrabbed` {#client.isMouseGrabbed}

```zig
pub fn isMouseGrabbed() core.Error!bool
```

`IClientInstance::getMouseGrabbed`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isMouseAndKeyboard` {#client.isMouseAndKeyboard}

```zig
pub fn isMouseAndKeyboard() core.Error!bool
```

`IClientInstance::currentInputModeIsMouseAndKeyboard`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.hasConnectedController` {#client.hasConnectedController}

```zig
pub fn hasConnectedController() core.Error!bool
```

`IClientInstance::hasConnectedController`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.controllerId` {#client.controllerId}

```zig
pub fn controllerId() core.Error!f64
```

`IClientInstance::getControllerId`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isTouchGameplayAllowed` {#client.isTouchGameplayAllowed}

```zig
pub fn isTouchGameplayAllowed() core.Error!bool
```

`IClientInstance::isTouchGameplayAllowed`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isSplitScreenActive` {#client.isSplitScreenActive}

```zig
pub fn isSplitScreenActive() core.Error!bool
```

`IClientInstance::isSplitScreenActive`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.splitScreenCount` {#client.splitScreenCount}

```zig
pub fn splitScreenCount() core.Error!f64
```

`IClientInstance::getSplitScreenCount`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.guiScaleOffset` {#client.guiScaleOffset}

```zig
pub fn guiScaleOffset() core.Error!f64
```

`IClientInstance::getGuiScaleOffset`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isEduMode` {#client.isEduMode}

```zig
pub fn isEduMode() core.Error!bool
```

`IClientInstance::isEduMode`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isInEditor` {#client.isInEditor}

```zig
pub fn isInEditor() core.Error!bool
```

`IClientInstance::isPlayerInEditor`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isReadyToRender` {#client.isReadyToRender}

```zig
pub fn isReadyToRender() core.Error!bool
```

`IClientInstance::isReadyToRender`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isFullVanillaPackOnStack` {#client.isFullVanillaPackOnStack}

```zig
pub fn isFullVanillaPackOnStack() core.Error!bool
```

`IClientInstance::isFullVanillaPackOnStack`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.serverConnectionTime` {#client.serverConnectionTime}

```zig
pub fn serverConnectionTime() core.Error!f64
```

`IClientInstance::getServerConnectionTime`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.remoteServerTimeMs` {#client.remoteServerTimeMs}

```zig
pub fn remoteServerTimeMs() core.Error!f64
```

`IClientInstance::getRemoteServerTimeMs`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.remoteServerNetworkTimeMs` {#client.remoteServerNetworkTimeMs}

```zig
pub fn remoteServerNetworkTimeMs() core.Error!f64
```

`IClientInstance::getRemoteServerNetworkTimeMs`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.frameAlpha` {#client.frameAlpha}

```zig
pub fn frameAlpha() core.Error!f64
```

`IClientInstance::getFrameAlpha`, how far the frame is between two ticks

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.gameUpdateSeconds` {#client.gameUpdateSeconds}

```zig
pub fn gameUpdateSeconds() core.Error!f64
```

`IClientInstance::getGameUpdateDurationInSeconds`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isPrimaryClient` {#client.isPrimaryClient}

```zig
pub fn isPrimaryClient() core.Error!bool
```

`IClientInstance::isPrimaryClient`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.userId` {#client.userId}

```zig
pub fn userId() core.Error!f64
```

`IClientInstance::getUserId`

- Return type: `core.Error!f64`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.isGameplayTipsEnabled` {#client.isGameplayTipsEnabled}

```zig
pub fn isGameplayTipsEnabled() core.Error!bool
```

`IClientInstance::isGamePlayTipsEnabled`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.hasCommands` {#client.hasCommands}

```zig
pub fn hasCommands() core.Error!bool
```

`IClientInstance::hasCommands`

- Return type: `core.Error!bool`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client.platformId` {#client.platformId}

```zig
pub fn platformId(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`IClientInstance::getPlatformId`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client.platformOnlineId` {#client.platformOnlineId}

```zig
pub fn platformOnlineId(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`IClientInstance::getPlatformOnlineId`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client.localXuid` {#client.localXuid}

```zig
pub fn localXuid(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`Player::getXuid` of the local player; fails outside a world

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client.localUuid` {#client.localUuid}

```zig
pub fn localUuid(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`Player::getUuid` of the local player in its canonical form

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client.localNameTag` {#client.localNameTag}

```zig
pub fn localNameTag(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`Actor::getNameTag` of the local player

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client.clipboard` {#client.clipboard}

```zig
pub fn clipboard(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

`AppPlatform::getClipboardText`, the system clipboard

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client.showPopup` {#client.showPopup}

```zig
pub fn showPopup(text: []const u8) core.Error!void
```

Shows a popup; a newline in text separates the message from a subtitle.

- Parameters:
    - text : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.showDevConsoleMessage` {#client.showDevConsoleMessage}

```zig
pub fn showDevConsoleMessage(text: []const u8) core.Error!void
```

Writes text to the developer console.

- Parameters:
    - text : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setSuspendInput` {#client.setSuspendInput}

```zig
pub fn setSuspendInput(suspended: bool) core.Error!void
```

Suspends or resumes all input.

- Parameters:
    - suspended : `bool`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setSuspendDirectionalInput` {#client.setSuspendDirectionalInput}

```zig
pub fn setSuspendDirectionalInput(suspended: bool) core.Error!void
```

Suspends or resumes movement input.

- Parameters:
    - suspended : `bool`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setGameInputEnabled` {#client.setGameInputEnabled}

```zig
pub fn setGameInputEnabled(enabled: bool) core.Error!void
```

Enables or disables game input.

- Parameters:
    - enabled : `bool`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.refocusMouse` {#client.refocusMouse}

```zig
pub fn refocusMouse(lost: bool) core.Error!void
```

Gives the mouse back to the game.

- Parameters:
    - lost : `bool`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.muteAudio` {#client.muteAudio}

```zig
pub fn muteAudio() core.Error!void
```

Mutes the client audio.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.unmuteAudio` {#client.unmuteAudio}

```zig
pub fn unmuteAudio() core.Error!void
```

Unmutes the client audio.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.fadeOutMusic` {#client.fadeOutMusic}

```zig
pub fn fadeOutMusic() core.Error!void
```

Fades out the music that is playing.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setGuiScaleOffset` {#client.setGuiScaleOffset}

```zig
pub fn setGuiScaleOffset(offset: i32) core.Error!void
```

Sets the GUI scale offset.

- Parameters:
    - offset : `i32`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.resetPlayerMovement` {#client.resetPlayerMovement}

```zig
pub fn resetPlayerMovement() core.Error!void
```

Resets the movement input of the local player.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.pushLeaveGameScreen` {#client.pushLeaveGameScreen}

```zig
pub fn pushLeaveGameScreen() core.Error!void
```

Opens the screen that asks whether to leave the world.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.openContentLogHistory` {#client.openContentLogHistory}

```zig
pub fn openContentLogHistory() core.Error!void
```

Opens the content log history.

- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.setClipboard` {#client.setClipboard}

```zig
pub fn setClipboard(value: []const u8) core.Error!void
```

Writes value to the system clipboard.

- Parameters:
    - value : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.navigateHowToPlay` {#client.navigateHowToPlay}

```zig
pub fn navigateHowToPlay(topic: []const u8) core.Error!void
```

Opens How to Play at topic, or at its start for an empty topic.

- Parameters:
    - topic : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client.options` {#client.options}

```zig
pub fn options(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]OptionPair
```

Every client option. The caller frees each key, each value and the slice.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]OptionPair`
- Slots: [`client_option_list`](../cpp/client.md#client_option_list)

### `client.option` {#client.option}

```zig
pub fn option(key: []const u8, allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

One client option by its options.txt key, owned by the caller.

- Parameters:
    - key : `[]const u8`
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_option_get`](../cpp/client.md#client_option_get)

### `client.setOption` {#client.setOption}

```zig
pub fn setOption(key: []const u8, value: []const u8) core.Error!void
```

Writes one client option from its options.txt text form; read it back to see what the engine kept.

- Parameters:
    - key : `[]const u8`
    - value : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`client_option_set`](../cpp/client.md#client_option_set)

### `client.registerKey` {#client.registerKey}

```zig
pub fn registerKey(name: []const u8, key_codes: []const i32, allow_remap: bool, user: ?*anyopaque, comptime handler: KeyHandler) core.Error!KeyBinding
```

Registers a key binding under `name` with its default `key_codes`. `allow_remap` lets the player rebind it. A name that is taken, or an empty code list, is Refused.

- Parameters:
    - name : `[]const u8`
    - key_codes : `[]const i32`
    - allow_remap : `bool`
    - user : `?*anyopaque`
    - handler : `comptime KeyHandler`
- Return type: `core.Error!KeyBinding`
- Slots: [`client_register_key`](../cpp/client.md#client_register_key)

### `client.isInLevel` {#client.isInLevel}

```zig
pub fn isInLevel() core.Error!bool
```

Whether the client is inside a level, which means a world is loaded.

- Return type: `core.Error!bool`
- Slots: [`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `client.localPlayerName` {#client.localPlayerName}

```zig
pub fn localPlayerName(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8
```

The name of the local player, owned by the caller. NoAnswer outside a level.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]u8`
- Slots: [`client_get_local_player`](../cpp/client.md#client_get_local_player)

## `client.KeyBinding` {#client.KeyBinding}

```zig
pub const KeyBinding = struct {
    handle: c.PierKeyHandle,
    // ...
};
```

One registered key binding, kept to drop it.

### `client.KeyBinding.keyCodes` {#client.KeyBinding.keyCodes}

```zig
pub fn keyCodes(self: KeyBinding, allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]i32
```

The key codes currently assigned, which differ from the defaults when the player remapped the key. Owned by the caller.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `(core.Error || std.mem.Allocator.Error)![]i32`
- Slots: [`client_get_key_codes`](../cpp/client.md#client_get_key_codes)

### `client.KeyBinding.unregister` {#client.KeyBinding.unregister}

```zig
pub fn unregister(self: *KeyBinding) core.Error!void
```

Drops the binding: this mod's handler stops firing. The engine keeps one key per name and offers no removal, so registering the same name again reuses it. Calling it twice is harmless.

- Return type: `core.Error!void`
- Slots: [`client_unregister_key`](../cpp/client.md#client_unregister_key)

## `client.KeyAction` {#client.KeyAction}

```zig
pub const KeyAction = enum(i32) {
    up = 0,
    down = 1,
    _,
};
```

What a key binding reports.

### `client.KeyAction.isDown` {#client.KeyAction.isDown}

```zig
pub fn isDown(self: KeyAction) bool
```

- Return type: `bool`

## `client.OptionPair` {#client.OptionPair}

```zig
pub const OptionPair = struct {
    key: []u8,
    value: []u8,
    // ...
};
```

One client option: its options.txt key and its value in that text form.
