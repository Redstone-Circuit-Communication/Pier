# Go：客户端

## 函数 {#functions}

### `RegisterKey` {#RegisterKey}

```go
func RegisterKey(name string, keyCodes []int32, allowRemap bool, fn func(pressed bool, impact int32)) (*KeyBinding, error)
```

在客户端上绑定按键：按下时以 `pressed` 为 true 调用 `fn`，松开时为 false，同时传入当前的焦点影响。只有客户端宿主支持；服务器会回答「没有提供」。

- 参数：
    - name : `string`
    - keyCodes : `[]int32`
    - allowRemap : `bool`
    - fn : `func(pressed bool, impact int32)`
- 返回值类型：`(*KeyBinding, error)`
- 对应槽位：[`client_register_key`](../cpp/client.md#client_register_key)

### `ClientProperty` {#ClientProperty}

```go
func ClientProperty(prop int32) (float64, error)
```

ClientProperty 按 PIER_CPROP_* 键读取一个数值型的客户端属性。宿主不认识这个键、或者客户端不在世界里时读取关于本地玩家的键，都会返回错误。

- 参数：
    - prop : `int32`
- 返回值类型：`(float64, error)`

### `ClientLocalPosition` {#ClientLocalPosition}

```go
func ClientLocalPosition() ([3]float64, error)
```

ClientLocalPosition 是本地玩家脚下的位置 x、y、z。

- 返回值类型：`([3]float64, error)`

### `ClientLocalRotation` {#ClientLocalRotation}

```go
func ClientLocalRotation() (pitch, yaw float64, err error)
```

ClientLocalRotation 是本地玩家的 pitch 和 yaw，单位为度；pitch 为负表示向上看。

- 返回值类型：`(pitch, yaw float64, err error)`

### `ClientRegisteredKeys` {#ClientRegisteredKeys}

```go
func ClientRegisteredKeys() ([]string, error)
```

ClientRegisteredKeys 列出按键注册表里所有按键绑定的名字，不论是哪个模组注册的。

- 返回值类型：`([]string, error)`

### `ClientHasKey` {#ClientHasKey}

```go
func ClientHasKey(name string) (bool, error)
```

ClientHasKey 报告是否注册了这个名字的按键绑定。

- 参数：
    - name : `string`
- 返回值类型：`(bool, error)`

### `ClientOptions` {#ClientOptions}

```go
func ClientOptions() ([]KeyValue, error)
```

ClientOptions 列出全部客户端选项的键和值，值是 options.txt 保存时用的文本形式。

- 返回值类型：`([]KeyValue, error)`
- 对应槽位：[`client_option_list`](../cpp/client.md#client_option_list)

### `ClientOption` {#ClientOption}

```go
func ClientOption(key string) (string, error)
```

ClientOption 按 options.txt 里的键读取一个客户端选项，例如 "gfx_field_of_view"。

- 参数：
    - key : `string`
- 返回值类型：`(string, error)`

### `SetClientOption` {#SetClientOption}

```go
func SetClientOption(key, value string) error
```

SetClientOption 用 options.txt 的文本形式写入一个客户端选项。引擎保留它能解析的部分，不报告任何结果，所以需要确认的调用方要把这个键读回来。

- 参数：
    - key : `string`
    - value : `string`
- 返回值类型：`error`

### `ClientIsInLevel` {#ClientIsInLevel}

```go
func ClientIsInLevel() (bool, error)
```

ClientIsInLevel 报告客户端是否在一个 level 里，也就是是否已经加载了世界。

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `ClientLocalPlayerName` {#ClientLocalPlayerName}

```go
func ClientLocalPlayerName() (string, error)
```

ClientLocalPlayerName 是本地玩家的名字。不在 level 里时宿主没有答案。

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_local_player`](../cpp/client.md#client_get_local_player)

### `ClientPosX` {#ClientPosX}

```go
func ClientPosX() (float64, error)
```

读取 `PIER_CPROP_POS_X`：本地玩家的 Actor::getFeetPos

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientPosY` {#ClientPosY}

```go
func ClientPosY() (float64, error)
```

读取 `PIER_CPROP_POS_Y`：脚下的高度，与 get_player_position 报告的是同一个点

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientPosZ` {#ClientPosZ}

```go
func ClientPosZ() (float64, error)
```

读取 `PIER_CPROP_POS_Z`：`PIER_CPROP_POS_Z`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientPitch` {#ClientPitch}

```go
func ClientPitch() (float64, error)
```

读取 `PIER_CPROP_PITCH`：Actor::getRotation，单位为度；为负表示向上看

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientYaw` {#ClientYaw}

```go
func ClientYaw() (float64, error)
```

读取 `PIER_CPROP_YAW`：Actor::getRotation，单位为度

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientDimension` {#ClientDimension}

```go
func ClientDimension() (float64, error)
```

读取 `PIER_CPROP_DIMENSION`：本地玩家的 Actor::getDimensionId

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGuiScale` {#ClientGuiScale}

```go
func ClientGuiScale() (float64, error)
```

读取 `PIER_CPROP_GUI_SCALE`：IClientInstance::getGuiScale

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientServerPingMs` {#ClientServerPingMs}

```go
func ClientServerPingMs() (float64, error)
```

读取 `PIER_CPROP_SERVER_PING_MS`：IClientInstance::getServerPingTime

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingMenu` {#ClientIsShowingMenu}

```go
func ClientIsShowingMenu() (bool, error)
```

读取 `PIER_CPROP_IS_SHOWING_MENU`：IClientInstance::isShowingMenu，1 或 0

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingPauseScreen` {#ClientIsShowingPauseScreen}

```go
func ClientIsShowingPauseScreen() (bool, error)
```

读取 `PIER_CPROP_IS_SHOWING_PAUSE_SCREEN`：IClientInstance::isShowingPauseScreen

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPlaying` {#ClientIsPlaying}

```go
func ClientIsPlaying() (bool, error)
```

读取 `PIER_CPROP_IS_PLAYING`：IClientInstance::isPlaying

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInRealm` {#ClientIsInRealm}

```go
func ClientIsInRealm() (bool, error)
```

读取 `PIER_CPROP_IS_IN_REALM`：IClientInstance::isInRealm

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsGameInputEnabled` {#ClientIsGameInputEnabled}

```go
func ClientIsGameInputEnabled() (bool, error)
```

读取 `PIER_CPROP_IS_GAME_INPUT_ENABLED`：IClientInstance::isInGameInputEnabled

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHealth` {#ClientHealth}

```go
func ClientHealth() (float64, error)
```

读取 `PIER_CPROP_HEALTH`：本地玩家的 `Actor::getHealth`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientMaxHealth` {#ClientMaxHealth}

```go
func ClientMaxHealth() (float64, error)
```

读取 `PIER_CPROP_MAX_HEALTH`：本地玩家的 `Actor::getMaxHealth`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsOnGround` {#ClientIsOnGround}

```go
func ClientIsOnGround() (bool, error)
```

读取 `PIER_CPROP_IS_ON_GROUND`：本地玩家的 `Actor::isOnGround`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInWater` {#ClientIsInWater}

```go
func ClientIsInWater() (bool, error)
```

读取 `PIER_CPROP_IS_IN_WATER`：本地玩家的 `Actor::isInWater`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSneaking` {#ClientIsSneaking}

```go
func ClientIsSneaking() (bool, error)
```

读取 `PIER_CPROP_IS_SNEAKING`：本地玩家的 `Actor::isSneaking`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSprinting` {#ClientIsSprinting}

```go
func ClientIsSprinting() (bool, error)
```

读取 `PIER_CPROP_IS_SPRINTING`：本地玩家的 `Actor::isSprinting`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSwimming` {#ClientIsSwimming}

```go
func ClientIsSwimming() (bool, error)
```

读取 `PIER_CPROP_IS_SWIMMING`：本地玩家的 `Actor::isSwimming`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsOnFire` {#ClientIsOnFire}

```go
func ClientIsOnFire() (bool, error)
```

读取 `PIER_CPROP_IS_ON_FIRE`：本地玩家的 `Actor::isOnFire`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsFlying` {#ClientIsFlying}

```go
func ClientIsFlying() (bool, error)
```

读取 `PIER_CPROP_IS_FLYING`：本地玩家的 `Player::isFlying`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGameType` {#ClientGameType}

```go
func ClientGameType() (float64, error)
```

读取 `PIER_CPROP_GAME_TYPE`：本地玩家的 `Player::getPlayerGameType`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientSelectedSlot` {#ClientSelectedSlot}

```go
func ClientSelectedSlot() (float64, error)
```

读取 `PIER_CPROP_SELECTED_SLOT`：本地玩家的 `Player::getSelectedItemSlot`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientVelX` {#ClientVelX}

```go
func ClientVelX() (float64, error)
```

读取 `PIER_CPROP_VEL_X`：本地玩家的 `Actor::getPosDelta`，单位为方块每刻

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientVelY` {#ClientVelY}

```go
func ClientVelY() (float64, error)
```

读取 `PIER_CPROP_VEL_Y`：`Actor::getPosDelta` 的竖直分量

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientVelZ` {#ClientVelZ}

```go
func ClientVelZ() (float64, error)
```

读取 `PIER_CPROP_VEL_Z`：`Actor::getPosDelta` 的 z 分量

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientXpNeededNextLevel` {#ClientXpNeededNextLevel}

```go
func ClientXpNeededNextLevel() (float64, error)
```

读取 `PIER_CPROP_XP_NEEDED_NEXT_LEVEL`：本地玩家的 `Player::getXpNeededForNextLevel`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsLeavingGame` {#ClientIsLeavingGame}

```go
func ClientIsLeavingGame() (bool, error)
```

读取 `PIER_CPROP_IS_LEAVING_GAME`：`IClientInstance::isLeavingGame`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsExitingLevel` {#ClientIsExitingLevel}

```go
func ClientIsExitingLevel() (bool, error)
```

读取 `PIER_CPROP_IS_EXITING_LEVEL`：`IClientInstance::isExitingLevel`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInBedScreen` {#ClientIsInBedScreen}

```go
func ClientIsInBedScreen() (bool, error)
```

读取 `PIER_CPROP_IS_IN_BED_SCREEN`：`IClientInstance::isInBedScreen`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInDeathScreen` {#ClientIsInDeathScreen}

```go
func ClientIsInDeathScreen() (bool, error)
```

读取 `PIER_CPROP_IS_IN_DEATH_SCREEN`：`IClientInstance::isInDeathScreen`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingLoadingScreen` {#ClientIsShowingLoadingScreen}

```go
func ClientIsShowingLoadingScreen() (bool, error)
```

读取 `PIER_CPROP_IS_SHOWING_LOADING_SCREEN`：`IClientInstance::isShowingLoadingScreen`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingProgressScreen` {#ClientIsShowingProgressScreen}

```go
func ClientIsShowingProgressScreen() (bool, error)
```

读取 `PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN`：`IClientInstance::isShowingProgressScreen`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingWorldProgressScreen` {#ClientIsShowingWorldProgressScreen}

```go
func ClientIsShowingWorldProgressScreen() (bool, error)
```

读取 `PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN`：`IClientInstance::isShowingWorldProgressScreen`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingDeathScreen` {#ClientIsShowingDeathScreen}

```go
func ClientIsShowingDeathScreen() (bool, error)
```

读取 `PIER_CPROP_IS_SHOWING_DEATH_SCREEN`：`IClientInstance::isShowingDeathScreen`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingServerForm` {#ClientIsShowingServerForm}

```go
func ClientIsShowingServerForm() (bool, error)
```

读取 `PIER_CPROP_IS_SHOWING_SERVER_FORM`：`IClientInstance::isShowingServerForm`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInWorldWithoutMenu` {#ClientIsInWorldWithoutMenu}

```go
func ClientIsInWorldWithoutMenu() (bool, error)
```

读取 `PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU`：`IClientInstance::isInWorldAndNotShowingAnyMenuScreens`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsWorldActive` {#ClientIsWorldActive}

```go
func ClientIsWorldActive() (bool, error)
```

读取 `PIER_CPROP_IS_WORLD_ACTIVE`：`IClientInstance::isWorldActive`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHasLevel` {#ClientHasLevel}

```go
func ClientHasLevel() (bool, error)
```

读取 `PIER_CPROP_HAS_LEVEL`：`IClientInstance::hasLevel`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPreGame` {#ClientIsPreGame}

```go
func ClientIsPreGame() (bool, error)
```

读取 `PIER_CPROP_IS_PRE_GAME`：`IClientInstance::isPreGame`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInMultiplayerGame` {#ClientIsInMultiplayerGame}

```go
func ClientIsInMultiplayerGame() (bool, error)
```

读取 `PIER_CPROP_IS_IN_MULTIPLAYER_GAME`：`IClientInstance::isInMultiplayerGame`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsMultiplayerClient` {#ClientIsMultiplayerClient}

```go
func ClientIsMultiplayerClient() (bool, error)
```

读取 `PIER_CPROP_IS_MULTIPLAYER_CLIENT`：`IClientInstance::isMultiPlayerClient`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPrimaryLevelMultiplayer` {#ClientIsPrimaryLevelMultiplayer}

```go
func ClientIsPrimaryLevelMultiplayer() (bool, error)
```

读取 `PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER`：`IClientInstance::isPrimaryLevelMultiplayer`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPrimaryLevelCrossPlatform` {#ClientIsPrimaryLevelCrossPlatform}

```go
func ClientIsPrimaryLevelCrossPlatform() (bool, error)
```

读取 `PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM`：`IClientInstance::isPrimaryLevelCrossPlatformMultiplayer`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsKeyboardEnabled` {#ClientIsKeyboardEnabled}

```go
func ClientIsKeyboardEnabled() (bool, error)
```

读取 `PIER_CPROP_IS_KEYBOARD_ENABLED`：`IClientInstance::isKeyboardEnabled`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsUsingController` {#ClientIsUsingController}

```go
func ClientIsUsingController() (bool, error)
```

读取 `PIER_CPROP_IS_USING_CONTROLLER`：`IClientInstance::useController`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsUsingTouchscreen` {#ClientIsUsingTouchscreen}

```go
func ClientIsUsingTouchscreen() (bool, error)
```

读取 `PIER_CPROP_IS_USING_TOUCHSCREEN`：`IClientInstance::useTouchscreen`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsMouseGrabbed` {#ClientIsMouseGrabbed}

```go
func ClientIsMouseGrabbed() (bool, error)
```

读取 `PIER_CPROP_IS_MOUSE_GRABBED`：`IClientInstance::getMouseGrabbed`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsMouseAndKeyboard` {#ClientIsMouseAndKeyboard}

```go
func ClientIsMouseAndKeyboard() (bool, error)
```

读取 `PIER_CPROP_IS_MOUSE_AND_KEYBOARD`：`IClientInstance::currentInputModeIsMouseAndKeyboard`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHasConnectedController` {#ClientHasConnectedController}

```go
func ClientHasConnectedController() (bool, error)
```

读取 `PIER_CPROP_HAS_CONNECTED_CONTROLLER`：`IClientInstance::hasConnectedController`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientControllerId` {#ClientControllerId}

```go
func ClientControllerId() (float64, error)
```

读取 `PIER_CPROP_CONTROLLER_ID`：`IClientInstance::getControllerId`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsTouchGameplayAllowed` {#ClientIsTouchGameplayAllowed}

```go
func ClientIsTouchGameplayAllowed() (bool, error)
```

读取 `PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED`：`IClientInstance::isTouchGameplayAllowed`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSplitScreenActive` {#ClientIsSplitScreenActive}

```go
func ClientIsSplitScreenActive() (bool, error)
```

读取 `PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE`：`IClientInstance::isSplitScreenActive`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientSplitScreenCount` {#ClientSplitScreenCount}

```go
func ClientSplitScreenCount() (float64, error)
```

读取 `PIER_CPROP_SPLIT_SCREEN_COUNT`：`IClientInstance::getSplitScreenCount`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGuiScaleOffset` {#ClientGuiScaleOffset}

```go
func ClientGuiScaleOffset() (float64, error)
```

读取 `PIER_CPROP_GUI_SCALE_OFFSET`：`IClientInstance::getGuiScaleOffset`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsEduMode` {#ClientIsEduMode}

```go
func ClientIsEduMode() (bool, error)
```

读取 `PIER_CPROP_IS_EDU_MODE`：`IClientInstance::isEduMode`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInEditor` {#ClientIsInEditor}

```go
func ClientIsInEditor() (bool, error)
```

读取 `PIER_CPROP_IS_IN_EDITOR`：`IClientInstance::isPlayerInEditor`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsReadyToRender` {#ClientIsReadyToRender}

```go
func ClientIsReadyToRender() (bool, error)
```

读取 `PIER_CPROP_IS_READY_TO_RENDER`：`IClientInstance::isReadyToRender`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsFullVanillaPackOnStack` {#ClientIsFullVanillaPackOnStack}

```go
func ClientIsFullVanillaPackOnStack() (bool, error)
```

读取 `PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK`：`IClientInstance::isFullVanillaPackOnStack`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientServerConnectionTime` {#ClientServerConnectionTime}

```go
func ClientServerConnectionTime() (float64, error)
```

读取 `PIER_CPROP_SERVER_CONNECTION_TIME`：`IClientInstance::getServerConnectionTime`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientRemoteServerTimeMs` {#ClientRemoteServerTimeMs}

```go
func ClientRemoteServerTimeMs() (float64, error)
```

读取 `PIER_CPROP_REMOTE_SERVER_TIME_MS`：`IClientInstance::getRemoteServerTimeMs`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientRemoteServerNetworkTimeMs` {#ClientRemoteServerNetworkTimeMs}

```go
func ClientRemoteServerNetworkTimeMs() (float64, error)
```

读取 `PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS`：`IClientInstance::getRemoteServerNetworkTimeMs`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientFrameAlpha` {#ClientFrameAlpha}

```go
func ClientFrameAlpha() (float64, error)
```

读取 `PIER_CPROP_FRAME_ALPHA`：`IClientInstance::getFrameAlpha`，当前帧处在两刻之间的位置

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGameUpdateSeconds` {#ClientGameUpdateSeconds}

```go
func ClientGameUpdateSeconds() (float64, error)
```

读取 `PIER_CPROP_GAME_UPDATE_SECONDS`：`IClientInstance::getGameUpdateDurationInSeconds`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPrimaryClient` {#ClientIsPrimaryClient}

```go
func ClientIsPrimaryClient() (bool, error)
```

读取 `PIER_CPROP_IS_PRIMARY_CLIENT`：`IClientInstance::isPrimaryClient`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientUserId` {#ClientUserId}

```go
func ClientUserId() (float64, error)
```

读取 `PIER_CPROP_USER_ID`：`IClientInstance::getUserId`

- 返回值类型：`(float64, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsGameplayTipsEnabled` {#ClientIsGameplayTipsEnabled}

```go
func ClientIsGameplayTipsEnabled() (bool, error)
```

读取 `PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED`：`IClientInstance::isGamePlayTipsEnabled`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHasCommands` {#ClientHasCommands}

```go
func ClientHasCommands() (bool, error)
```

读取 `PIER_CPROP_HAS_COMMANDS`：`IClientInstance::hasCommands`

- 返回值类型：`(bool, error)`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `ClientScreenName` {#ClientScreenName}

```go
func ClientScreenName() (string, error)
```

读取 `PIER_CSTR_SCREEN_NAME`：IClientInstance::getScreenName，与 client_get_screen_name 相同

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientTopScreenName` {#ClientTopScreenName}

```go
func ClientTopScreenName() (string, error)
```

读取 `PIER_CSTR_TOP_SCREEN_NAME`：IClientInstance::getTopScreenName

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientPlatformId` {#ClientPlatformId}

```go
func ClientPlatformId() (string, error)
```

读取 `PIER_CSTR_PLATFORM_ID`：`IClientInstance::getPlatformId`

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientPlatformOnlineId` {#ClientPlatformOnlineId}

```go
func ClientPlatformOnlineId() (string, error)
```

读取 `PIER_CSTR_PLATFORM_ONLINE_ID`：`IClientInstance::getPlatformOnlineId`

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientLocalXuid` {#ClientLocalXuid}

```go
func ClientLocalXuid() (string, error)
```

读取 `PIER_CSTR_LOCAL_XUID`：本地玩家的 `Player::getXuid`；不在世界里时失败

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientLocalUuid` {#ClientLocalUuid}

```go
func ClientLocalUuid() (string, error)
```

读取 `PIER_CSTR_LOCAL_UUID`：本地玩家的 `Player::getUuid`，规范字符串形式

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientLocalNameTag` {#ClientLocalNameTag}

```go
func ClientLocalNameTag() (string, error)
```

读取 `PIER_CSTR_LOCAL_NAME_TAG`：本地玩家的 `Actor::getNameTag`

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientClipboard` {#ClientClipboard}

```go
func ClientClipboard() (string, error)
```

读取 `PIER_CSTR_CLIPBOARD`：`AppPlatform::getClipboardText`，系统剪贴板

- 返回值类型：`(string, error)`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `ClientShowMessage` {#ClientShowMessage}

```go
func ClientShowMessage(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SHOW_MESSAGE`：sarg：文本。GuiData::displayClientMessage

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetTitle` {#ClientSetTitle}

```go
func ClientSetTitle(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_TITLE`：sarg：文本。GuiData::setTitle

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetSubtitle` {#ClientSetSubtitle}

```go
func ClientSetSubtitle(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_SUBTITLE`：sarg：文本。GuiData::setSubtitle

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetActionBar` {#ClientSetActionBar}

```go
func ClientSetActionBar(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_ACTION_BAR`：sarg：文本。GuiData::setActionBarMessage

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientShowTip` {#ClientShowTip}

```go
func ClientShowTip(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SHOW_TIP`：sarg：文本。GuiData::showTipMessage

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientPlayUiSound` {#ClientPlayUiSound}

```go
func ClientPlayUiSound(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_PLAY_UI_SOUND`：sarg：音效名，a：音量，b：音调。IClientInstance::playUI

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientGrabMouse` {#ClientGrabMouse}

```go
func ClientGrabMouse(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_GRAB_MOUSE`：IClientInstance::grabMouse

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientReleaseMouse` {#ClientReleaseMouse}

```go
func ClientReleaseMouse(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_RELEASE_MOUSE`：IClientInstance::releaseMouse

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetInputDisabled` {#ClientSetInputDisabled}

```go
func ClientSetInputDisabled(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_INPUT_DISABLED`：a：非零时禁用游戏输入。IClientInstance::setDisableInput

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientLeaveLevel` {#ClientLeaveLevel}

```go
func ClientLeaveLevel(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_LEAVE_LEVEL`：IClientInstance::requestLeaveGame(true, false)：离开世界回到菜单，异步完成

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientShowPopup` {#ClientShowPopup}

```go
func ClientShowPopup(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SHOW_POPUP`：sarg：消息，或者在第一个换行处分开的消息和副标题。`GuiData::showPopupNotice`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientShowDevConsoleMessage` {#ClientShowDevConsoleMessage}

```go
func ClientShowDevConsoleMessage(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE`：sarg：文本。`GuiData::displayDevConsoleMessage`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetSuspendInput` {#ClientSetSuspendInput}

```go
func ClientSetSuspendInput(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_SUSPEND_INPUT`：a：非零时暂停输入。`IClientInstance::setSuspendInput`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetSuspendDirectionalInput` {#ClientSetSuspendDirectionalInput}

```go
func ClientSetSuspendDirectionalInput(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT`：a：非零时暂停移动输入。`IClientInstance::setSuspendDirectionalInput`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetGameInputEnabled` {#ClientSetGameInputEnabled}

```go
func ClientSetGameInputEnabled(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_GAME_INPUT_ENABLED`：a：非零时启用。`IClientInstance::setInGameInputEnabled`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientRefocusMouse` {#ClientRefocusMouse}

```go
func ClientRefocusMouse(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_REFOCUS_MOUSE`：a：鼠标丢失时为非零。`IClientInstance::refocusMouse`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientMuteAudio` {#ClientMuteAudio}

```go
func ClientMuteAudio(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_MUTE_AUDIO`：`IClientInstance::muteAudio`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientUnmuteAudio` {#ClientUnmuteAudio}

```go
func ClientUnmuteAudio(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_UNMUTE_AUDIO`：`IClientInstance::unMuteAudio`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientFadeOutMusic` {#ClientFadeOutMusic}

```go
func ClientFadeOutMusic(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_FADE_OUT_MUSIC`：`IClientInstance::fadeOutMusic`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetGuiScaleOffset` {#ClientSetGuiScaleOffset}

```go
func ClientSetGuiScaleOffset(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_GUI_SCALE_OFFSET`：a：偏移量。`IClientInstance::setGuiScaleOffset`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientResetPlayerMovement` {#ClientResetPlayerMovement}

```go
func ClientResetPlayerMovement(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_RESET_PLAYER_MOVEMENT`：`IClientInstance::resetPlayerMovement`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientPushLeaveGameScreen` {#ClientPushLeaveGameScreen}

```go
func ClientPushLeaveGameScreen(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_PUSH_LEAVE_GAME_SCREEN`：`IClientInstance::tryPushLeaveGameScreen`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientOpenContentLogHistory` {#ClientOpenContentLogHistory}

```go
func ClientOpenContentLogHistory(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_OPEN_CONTENT_LOG_HISTORY`：`IClientInstance::openContentLogHistory`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientSetClipboard` {#ClientSetClipboard}

```go
func ClientSetClipboard(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_SET_CLIPBOARD`：sarg：文本，可以为空。`AppPlatform::setClipboard`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `ClientNavigateHowToPlay` {#ClientNavigateHowToPlay}

```go
func ClientNavigateHowToPlay(sarg string, a, b, c float64) error
```

执行 `PIER_CACT_NAVIGATE_HOW_TO_PLAY`：sarg：主题，可以为空。`IClientInstance::navigateToHowToPlayScreen`

每个参数的含义见 abi.h；用不到的参数会被忽略。

- 参数：
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- 返回值类型：`error`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

## `KeyBinding` {#KeyBinding}

```go
type KeyBinding struct {
    // unexported fields
}
```

一个已注册的客户端按键绑定。

### `KeyBinding.Unregister` {#KeyBinding.Unregister}

```go
func (k *KeyBinding) Unregister() error
```

停止这个绑定的回调。

- 返回值类型：`error`
- 对应槽位：[`client_unregister_key`](../cpp/client.md#client_unregister_key)

### `KeyBinding.KeyCodes` {#KeyBinding.KeyCodes}

```go
func (k *KeyBinding) KeyCodes() ([]int32, error)
```

KeyCodes 列出现在分配给这个绑定的按键码；玩家重新映射过按键时，它和默认值不同。

- 返回值类型：`([]int32, error)`
- 对应槽位：[`client_get_key_codes`](../cpp/client.md#client_get_key_codes)

## `KeyHandle` {#KeyHandle}

```go
type KeyHandle struct{ p unsafe.Pointer }
type KeyHandle struct{ p unsafe.Pointer }
```

一个已注册的客户端按键绑定。

### `KeyHandle.IsZero` {#KeyHandle.IsZero}

```go
func (h KeyHandle) IsZero() bool
```

判断这个句柄是否什么都不指向。

- 返回值类型：`bool`

## `CProp*` {#CProp}

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="CPropPosX"></span>`CPropPosX` | `0` | 即 `PIER_CPROP_POS_X`：本地玩家的 Actor::getFeetPos |
| <span id="CPropPosY"></span>`CPropPosY` | `1` | 即 `PIER_CPROP_POS_Y`：脚下的高度，与 get_player_position 报告的是同一个点 |
| <span id="CPropPosZ"></span>`CPropPosZ` | `2` | 即 `PIER_CPROP_POS_Z`：`PIER_CPROP_POS_Z` |
| <span id="CPropPitch"></span>`CPropPitch` | `3` | 即 `PIER_CPROP_PITCH`：Actor::getRotation，单位为度；为负表示向上看 |
| <span id="CPropYaw"></span>`CPropYaw` | `4` | 即 `PIER_CPROP_YAW`：Actor::getRotation，单位为度 |
| <span id="CPropDimension"></span>`CPropDimension` | `5` | 即 `PIER_CPROP_DIMENSION`：本地玩家的 Actor::getDimensionId |
| <span id="CPropGuiScale"></span>`CPropGuiScale` | `6` | 即 `PIER_CPROP_GUI_SCALE`：IClientInstance::getGuiScale |
| <span id="CPropServerPingMs"></span>`CPropServerPingMs` | `7` | 即 `PIER_CPROP_SERVER_PING_MS`：IClientInstance::getServerPingTime |
| <span id="CPropIsShowingMenu"></span>`CPropIsShowingMenu` | `8` | 即 `PIER_CPROP_IS_SHOWING_MENU`：IClientInstance::isShowingMenu，1 或 0 |
| <span id="CPropIsShowingPauseScreen"></span>`CPropIsShowingPauseScreen` | `9` | 即 `PIER_CPROP_IS_SHOWING_PAUSE_SCREEN`：IClientInstance::isShowingPauseScreen |
| <span id="CPropIsPlaying"></span>`CPropIsPlaying` | `10` | 即 `PIER_CPROP_IS_PLAYING`：IClientInstance::isPlaying |
| <span id="CPropIsInRealm"></span>`CPropIsInRealm` | `11` | 即 `PIER_CPROP_IS_IN_REALM`：IClientInstance::isInRealm |
| <span id="CPropIsGameInputEnabled"></span>`CPropIsGameInputEnabled` | `12` | 即 `PIER_CPROP_IS_GAME_INPUT_ENABLED`：IClientInstance::isInGameInputEnabled |
| <span id="CPropHealth"></span>`CPropHealth` | `13` | 即 `PIER_CPROP_HEALTH`：本地玩家的 `Actor::getHealth` |
| <span id="CPropMaxHealth"></span>`CPropMaxHealth` | `14` | 即 `PIER_CPROP_MAX_HEALTH`：本地玩家的 `Actor::getMaxHealth` |
| <span id="CPropIsOnGround"></span>`CPropIsOnGround` | `15` | 即 `PIER_CPROP_IS_ON_GROUND`：本地玩家的 `Actor::isOnGround` |
| <span id="CPropIsInWater"></span>`CPropIsInWater` | `16` | 即 `PIER_CPROP_IS_IN_WATER`：本地玩家的 `Actor::isInWater` |
| <span id="CPropIsSneaking"></span>`CPropIsSneaking` | `17` | 即 `PIER_CPROP_IS_SNEAKING`：本地玩家的 `Actor::isSneaking` |
| <span id="CPropIsSprinting"></span>`CPropIsSprinting` | `18` | 即 `PIER_CPROP_IS_SPRINTING`：本地玩家的 `Actor::isSprinting` |
| <span id="CPropIsSwimming"></span>`CPropIsSwimming` | `19` | 即 `PIER_CPROP_IS_SWIMMING`：本地玩家的 `Actor::isSwimming` |
| <span id="CPropIsOnFire"></span>`CPropIsOnFire` | `20` | 即 `PIER_CPROP_IS_ON_FIRE`：本地玩家的 `Actor::isOnFire` |
| <span id="CPropIsFlying"></span>`CPropIsFlying` | `21` | 即 `PIER_CPROP_IS_FLYING`：本地玩家的 `Player::isFlying` |
| <span id="CPropGameType"></span>`CPropGameType` | `22` | 即 `PIER_CPROP_GAME_TYPE`：本地玩家的 `Player::getPlayerGameType` |
| <span id="CPropSelectedSlot"></span>`CPropSelectedSlot` | `23` | 即 `PIER_CPROP_SELECTED_SLOT`：本地玩家的 `Player::getSelectedItemSlot` |
| <span id="CPropVelX"></span>`CPropVelX` | `24` | 即 `PIER_CPROP_VEL_X`：本地玩家的 `Actor::getPosDelta`，单位为方块每刻 |
| <span id="CPropVelY"></span>`CPropVelY` | `25` | 即 `PIER_CPROP_VEL_Y`：`Actor::getPosDelta` 的竖直分量 |
| <span id="CPropVelZ"></span>`CPropVelZ` | `26` | 即 `PIER_CPROP_VEL_Z`：`Actor::getPosDelta` 的 z 分量 |
| <span id="CPropXpNeededNextLevel"></span>`CPropXpNeededNextLevel` | `27` | 即 `PIER_CPROP_XP_NEEDED_NEXT_LEVEL`：本地玩家的 `Player::getXpNeededForNextLevel` |
| <span id="CPropIsLeavingGame"></span>`CPropIsLeavingGame` | `28` | 即 `PIER_CPROP_IS_LEAVING_GAME`：`IClientInstance::isLeavingGame` |
| <span id="CPropIsExitingLevel"></span>`CPropIsExitingLevel` | `29` | 即 `PIER_CPROP_IS_EXITING_LEVEL`：`IClientInstance::isExitingLevel` |
| <span id="CPropIsInBedScreen"></span>`CPropIsInBedScreen` | `30` | 即 `PIER_CPROP_IS_IN_BED_SCREEN`：`IClientInstance::isInBedScreen` |
| <span id="CPropIsInDeathScreen"></span>`CPropIsInDeathScreen` | `31` | 即 `PIER_CPROP_IS_IN_DEATH_SCREEN`：`IClientInstance::isInDeathScreen` |
| <span id="CPropIsShowingLoadingScreen"></span>`CPropIsShowingLoadingScreen` | `32` | 即 `PIER_CPROP_IS_SHOWING_LOADING_SCREEN`：`IClientInstance::isShowingLoadingScreen` |
| <span id="CPropIsShowingProgressScreen"></span>`CPropIsShowingProgressScreen` | `33` | 即 `PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN`：`IClientInstance::isShowingProgressScreen` |
| <span id="CPropIsShowingWorldProgressScreen"></span>`CPropIsShowingWorldProgressScreen` | `34` | 即 `PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN`：`IClientInstance::isShowingWorldProgressScreen` |
| <span id="CPropIsShowingDeathScreen"></span>`CPropIsShowingDeathScreen` | `35` | 即 `PIER_CPROP_IS_SHOWING_DEATH_SCREEN`：`IClientInstance::isShowingDeathScreen` |
| <span id="CPropIsShowingServerForm"></span>`CPropIsShowingServerForm` | `36` | 即 `PIER_CPROP_IS_SHOWING_SERVER_FORM`：`IClientInstance::isShowingServerForm` |
| <span id="CPropIsInWorldWithoutMenu"></span>`CPropIsInWorldWithoutMenu` | `37` | 即 `PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU`：`IClientInstance::isInWorldAndNotShowingAnyMenuScreens` |
| <span id="CPropIsWorldActive"></span>`CPropIsWorldActive` | `38` | 即 `PIER_CPROP_IS_WORLD_ACTIVE`：`IClientInstance::isWorldActive` |
| <span id="CPropHasLevel"></span>`CPropHasLevel` | `39` | 即 `PIER_CPROP_HAS_LEVEL`：`IClientInstance::hasLevel` |
| <span id="CPropIsPreGame"></span>`CPropIsPreGame` | `40` | 即 `PIER_CPROP_IS_PRE_GAME`：`IClientInstance::isPreGame` |
| <span id="CPropIsInMultiplayerGame"></span>`CPropIsInMultiplayerGame` | `41` | 即 `PIER_CPROP_IS_IN_MULTIPLAYER_GAME`：`IClientInstance::isInMultiplayerGame` |
| <span id="CPropIsMultiplayerClient"></span>`CPropIsMultiplayerClient` | `42` | 即 `PIER_CPROP_IS_MULTIPLAYER_CLIENT`：`IClientInstance::isMultiPlayerClient` |
| <span id="CPropIsPrimaryLevelMultiplayer"></span>`CPropIsPrimaryLevelMultiplayer` | `43` | 即 `PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER`：`IClientInstance::isPrimaryLevelMultiplayer` |
| <span id="CPropIsPrimaryLevelCrossPlatform"></span>`CPropIsPrimaryLevelCrossPlatform` | `44` | 即 `PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM`：`IClientInstance::isPrimaryLevelCrossPlatformMultiplayer` |
| <span id="CPropIsKeyboardEnabled"></span>`CPropIsKeyboardEnabled` | `45` | 即 `PIER_CPROP_IS_KEYBOARD_ENABLED`：`IClientInstance::isKeyboardEnabled` |
| <span id="CPropIsUsingController"></span>`CPropIsUsingController` | `46` | 即 `PIER_CPROP_IS_USING_CONTROLLER`：`IClientInstance::useController` |
| <span id="CPropIsUsingTouchscreen"></span>`CPropIsUsingTouchscreen` | `47` | 即 `PIER_CPROP_IS_USING_TOUCHSCREEN`：`IClientInstance::useTouchscreen` |
| <span id="CPropIsMouseGrabbed"></span>`CPropIsMouseGrabbed` | `48` | 即 `PIER_CPROP_IS_MOUSE_GRABBED`：`IClientInstance::getMouseGrabbed` |
| <span id="CPropIsMouseAndKeyboard"></span>`CPropIsMouseAndKeyboard` | `49` | 即 `PIER_CPROP_IS_MOUSE_AND_KEYBOARD`：`IClientInstance::currentInputModeIsMouseAndKeyboard` |
| <span id="CPropHasConnectedController"></span>`CPropHasConnectedController` | `50` | 即 `PIER_CPROP_HAS_CONNECTED_CONTROLLER`：`IClientInstance::hasConnectedController` |
| <span id="CPropControllerId"></span>`CPropControllerId` | `51` | 即 `PIER_CPROP_CONTROLLER_ID`：`IClientInstance::getControllerId` |
| <span id="CPropIsTouchGameplayAllowed"></span>`CPropIsTouchGameplayAllowed` | `52` | 即 `PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED`：`IClientInstance::isTouchGameplayAllowed` |
| <span id="CPropIsSplitScreenActive"></span>`CPropIsSplitScreenActive` | `53` | 即 `PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE`：`IClientInstance::isSplitScreenActive` |
| <span id="CPropSplitScreenCount"></span>`CPropSplitScreenCount` | `54` | 即 `PIER_CPROP_SPLIT_SCREEN_COUNT`：`IClientInstance::getSplitScreenCount` |
| <span id="CPropGuiScaleOffset"></span>`CPropGuiScaleOffset` | `55` | 即 `PIER_CPROP_GUI_SCALE_OFFSET`：`IClientInstance::getGuiScaleOffset` |
| <span id="CPropIsEduMode"></span>`CPropIsEduMode` | `56` | 即 `PIER_CPROP_IS_EDU_MODE`：`IClientInstance::isEduMode` |
| <span id="CPropIsInEditor"></span>`CPropIsInEditor` | `57` | 即 `PIER_CPROP_IS_IN_EDITOR`：`IClientInstance::isPlayerInEditor` |
| <span id="CPropIsReadyToRender"></span>`CPropIsReadyToRender` | `58` | 即 `PIER_CPROP_IS_READY_TO_RENDER`：`IClientInstance::isReadyToRender` |
| <span id="CPropIsFullVanillaPackOnStack"></span>`CPropIsFullVanillaPackOnStack` | `59` | 即 `PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK`：`IClientInstance::isFullVanillaPackOnStack` |
| <span id="CPropServerConnectionTime"></span>`CPropServerConnectionTime` | `60` | 即 `PIER_CPROP_SERVER_CONNECTION_TIME`：`IClientInstance::getServerConnectionTime` |
| <span id="CPropRemoteServerTimeMs"></span>`CPropRemoteServerTimeMs` | `61` | 即 `PIER_CPROP_REMOTE_SERVER_TIME_MS`：`IClientInstance::getRemoteServerTimeMs` |
| <span id="CPropRemoteServerNetworkTimeMs"></span>`CPropRemoteServerNetworkTimeMs` | `62` | 即 `PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS`：`IClientInstance::getRemoteServerNetworkTimeMs` |
| <span id="CPropFrameAlpha"></span>`CPropFrameAlpha` | `63` | 即 `PIER_CPROP_FRAME_ALPHA`：`IClientInstance::getFrameAlpha`，当前帧处在两刻之间的位置 |
| <span id="CPropGameUpdateSeconds"></span>`CPropGameUpdateSeconds` | `64` | 即 `PIER_CPROP_GAME_UPDATE_SECONDS`：`IClientInstance::getGameUpdateDurationInSeconds` |
| <span id="CPropIsPrimaryClient"></span>`CPropIsPrimaryClient` | `65` | 即 `PIER_CPROP_IS_PRIMARY_CLIENT`：`IClientInstance::isPrimaryClient` |
| <span id="CPropUserId"></span>`CPropUserId` | `66` | 即 `PIER_CPROP_USER_ID`：`IClientInstance::getUserId` |
| <span id="CPropIsGameplayTipsEnabled"></span>`CPropIsGameplayTipsEnabled` | `67` | 即 `PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED`：`IClientInstance::isGamePlayTipsEnabled` |
| <span id="CPropHasCommands"></span>`CPropHasCommands` | `68` | 即 `PIER_CPROP_HAS_COMMANDS`：`IClientInstance::hasCommands` |

## `CStr*` {#CStr}

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="CStrScreenName"></span>`CStrScreenName` | `0` | 即 `PIER_CSTR_SCREEN_NAME`：IClientInstance::getScreenName，与 client_get_screen_name 相同 |
| <span id="CStrTopScreenName"></span>`CStrTopScreenName` | `1` | 即 `PIER_CSTR_TOP_SCREEN_NAME`：IClientInstance::getTopScreenName |
| <span id="CStrPlatformId"></span>`CStrPlatformId` | `2` | 即 `PIER_CSTR_PLATFORM_ID`：`IClientInstance::getPlatformId` |
| <span id="CStrPlatformOnlineId"></span>`CStrPlatformOnlineId` | `3` | 即 `PIER_CSTR_PLATFORM_ONLINE_ID`：`IClientInstance::getPlatformOnlineId` |
| <span id="CStrLocalXuid"></span>`CStrLocalXuid` | `4` | 即 `PIER_CSTR_LOCAL_XUID`：本地玩家的 `Player::getXuid`；不在世界里时失败 |
| <span id="CStrLocalUuid"></span>`CStrLocalUuid` | `5` | 即 `PIER_CSTR_LOCAL_UUID`：本地玩家的 `Player::getUuid`，规范字符串形式 |
| <span id="CStrLocalNameTag"></span>`CStrLocalNameTag` | `6` | 即 `PIER_CSTR_LOCAL_NAME_TAG`：本地玩家的 `Actor::getNameTag` |
| <span id="CStrClipboard"></span>`CStrClipboard` | `7` | 即 `PIER_CSTR_CLIPBOARD`：`AppPlatform::getClipboardText`，系统剪贴板 |

## `CAct*` {#CAct}

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="CActShowMessage"></span>`CActShowMessage` | `0` | 即 `PIER_CACT_SHOW_MESSAGE`：sarg：文本。GuiData::displayClientMessage |
| <span id="CActSetTitle"></span>`CActSetTitle` | `1` | 即 `PIER_CACT_SET_TITLE`：sarg：文本。GuiData::setTitle |
| <span id="CActSetSubtitle"></span>`CActSetSubtitle` | `2` | 即 `PIER_CACT_SET_SUBTITLE`：sarg：文本。GuiData::setSubtitle |
| <span id="CActSetActionBar"></span>`CActSetActionBar` | `3` | 即 `PIER_CACT_SET_ACTION_BAR`：sarg：文本。GuiData::setActionBarMessage |
| <span id="CActShowTip"></span>`CActShowTip` | `4` | 即 `PIER_CACT_SHOW_TIP`：sarg：文本。GuiData::showTipMessage |
| <span id="CActPlayUiSound"></span>`CActPlayUiSound` | `5` | 即 `PIER_CACT_PLAY_UI_SOUND`：sarg：音效名，a：音量，b：音调。IClientInstance::playUI |
| <span id="CActGrabMouse"></span>`CActGrabMouse` | `6` | 即 `PIER_CACT_GRAB_MOUSE`：IClientInstance::grabMouse |
| <span id="CActReleaseMouse"></span>`CActReleaseMouse` | `7` | 即 `PIER_CACT_RELEASE_MOUSE`：IClientInstance::releaseMouse |
| <span id="CActSetInputDisabled"></span>`CActSetInputDisabled` | `8` | 即 `PIER_CACT_SET_INPUT_DISABLED`：a：非零时禁用游戏输入。IClientInstance::setDisableInput |
| <span id="CActLeaveLevel"></span>`CActLeaveLevel` | `9` | 即 `PIER_CACT_LEAVE_LEVEL`：IClientInstance::requestLeaveGame(true, false)：离开世界回到菜单，异步完成 |
| <span id="CActShowPopup"></span>`CActShowPopup` | `10` | 即 `PIER_CACT_SHOW_POPUP`：sarg：消息，或者在第一个换行处分开的消息和副标题。`GuiData::showPopupNotice` |
| <span id="CActShowDevConsoleMessage"></span>`CActShowDevConsoleMessage` | `11` | 即 `PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE`：sarg：文本。`GuiData::displayDevConsoleMessage` |
| <span id="CActSetSuspendInput"></span>`CActSetSuspendInput` | `12` | 即 `PIER_CACT_SET_SUSPEND_INPUT`：a：非零时暂停输入。`IClientInstance::setSuspendInput` |
| <span id="CActSetSuspendDirectionalInput"></span>`CActSetSuspendDirectionalInput` | `13` | 即 `PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT`：a：非零时暂停移动输入。`IClientInstance::setSuspendDirectionalInput` |
| <span id="CActSetGameInputEnabled"></span>`CActSetGameInputEnabled` | `14` | 即 `PIER_CACT_SET_GAME_INPUT_ENABLED`：a：非零时启用。`IClientInstance::setInGameInputEnabled` |
| <span id="CActRefocusMouse"></span>`CActRefocusMouse` | `15` | 即 `PIER_CACT_REFOCUS_MOUSE`：a：鼠标丢失时为非零。`IClientInstance::refocusMouse` |
| <span id="CActMuteAudio"></span>`CActMuteAudio` | `16` | 即 `PIER_CACT_MUTE_AUDIO`：`IClientInstance::muteAudio` |
| <span id="CActUnmuteAudio"></span>`CActUnmuteAudio` | `17` | 即 `PIER_CACT_UNMUTE_AUDIO`：`IClientInstance::unMuteAudio` |
| <span id="CActFadeOutMusic"></span>`CActFadeOutMusic` | `18` | 即 `PIER_CACT_FADE_OUT_MUSIC`：`IClientInstance::fadeOutMusic` |
| <span id="CActSetGuiScaleOffset"></span>`CActSetGuiScaleOffset` | `19` | 即 `PIER_CACT_SET_GUI_SCALE_OFFSET`：a：偏移量。`IClientInstance::setGuiScaleOffset` |
| <span id="CActResetPlayerMovement"></span>`CActResetPlayerMovement` | `20` | 即 `PIER_CACT_RESET_PLAYER_MOVEMENT`：`IClientInstance::resetPlayerMovement` |
| <span id="CActPushLeaveGameScreen"></span>`CActPushLeaveGameScreen` | `21` | 即 `PIER_CACT_PUSH_LEAVE_GAME_SCREEN`：`IClientInstance::tryPushLeaveGameScreen` |
| <span id="CActOpenContentLogHistory"></span>`CActOpenContentLogHistory` | `22` | 即 `PIER_CACT_OPEN_CONTENT_LOG_HISTORY`：`IClientInstance::openContentLogHistory` |
| <span id="CActSetClipboard"></span>`CActSetClipboard` | `23` | 即 `PIER_CACT_SET_CLIPBOARD`：sarg：文本，可以为空。`AppPlatform::setClipboard` |
| <span id="CActNavigateHowToPlay"></span>`CActNavigateHowToPlay` | `24` | 即 `PIER_CACT_NAVIGATE_HOW_TO_PLAY`：sarg：主题，可以为空。`IClientInstance::navigateToHowToPlayScreen` |
