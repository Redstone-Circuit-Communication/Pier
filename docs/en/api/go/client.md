# Go: Client

## Functions {#functions}

### `RegisterKey` {#RegisterKey}

```go
func RegisterKey(name string, keyCodes []int32, allowRemap bool, fn func(pressed bool, impact int32)) (*KeyBinding, error)
```

RegisterKey binds keys on the client: fn runs with pressed true on press and false on release, and the current focus impact. Client hosts only; a server answers not provided.

- Parameters:
    - name : `string`
    - keyCodes : `[]int32`
    - allowRemap : `bool`
    - fn : `func(pressed bool, impact int32)`
- Return type: `(*KeyBinding, error)`
- Slots: [`client_register_key`](../cpp/client.md#client_register_key)

### `ClientProperty` {#ClientProperty}

```go
func ClientProperty(prop int32) (float64, error)
```

ClientProperty reads one numeric client property by its PIER\_CPROP\_\* key. The error covers a key this host does not know and a key about the local player read while the client is not in a world.

- Parameters:
    - prop : `int32`
- Return type: `(float64, error)`

### `ClientLocalPosition` {#ClientLocalPosition}

```go
func ClientLocalPosition() ([3]float64, error)
```

ClientLocalPosition is the local player's feet position, x, y and z.

- Return type: `([3]float64, error)`

### `ClientLocalRotation` {#ClientLocalRotation}

```go
func ClientLocalRotation() (pitch, yaw float64, err error)
```

ClientLocalRotation is the local player's pitch and yaw in degrees; a negative pitch looks up.

- Return type: `(pitch, yaw float64, err error)`

### `ClientRegisteredKeys` {#ClientRegisteredKeys}

```go
func ClientRegisteredKeys() ([]string, error)
```

ClientRegisteredKeys lists every key binding name the key registry holds, whichever mod registered it.

- Return type: `([]string, error)`

### `ClientHasKey` {#ClientHasKey}

```go
func ClientHasKey(name string) (bool, error)
```

ClientHasKey reports whether a key binding of this name is registered.

- Parameters:
    - name : `string`
- Return type: `(bool, error)`

### `ClientOptions` {#ClientOptions}

```go
func ClientOptions() ([]KeyValue, error)
```

ClientOptions lists every client option as key and value, in the text form options.txt stores.

- Return type: `([]KeyValue, error)`
- Slots: [`client_option_list`](../cpp/client.md#client_option_list)

### `ClientOption` {#ClientOption}

```go
func ClientOption(key string) (string, error)
```

ClientOption reads one client option by its options.txt key, such as "`gfx_field_of_view`".

- Parameters:
    - key : `string`
- Return type: `(string, error)`

### `SetClientOption` {#SetClientOption}

```go
func SetClientOption(key, value string) error
```

SetClientOption writes one client option from its options.txt text form. The engine keeps what it can parse and reports nothing, so a caller that needs to know reads the key back.

- Parameters:
    - key : `string`
    - value : `string`
- Return type: `error`

### `ClientIsInLevel` {#ClientIsInLevel}

```go
func ClientIsInLevel() (bool, error)
```

ClientIsInLevel reports whether the client is inside a level, which means a world is loaded.

- Return type: `(bool, error)`
- Slots: [`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `ClientLocalPlayerName` {#ClientLocalPlayerName}

```go
func ClientLocalPlayerName() (string, error)
```

ClientLocalPlayerName is the name of the local player. The host has no answer outside a level.

- Return type: `(string, error)`
- Slots: [`client_get_local_player`](../cpp/client.md#client_get_local_player)

### `ClientPosX` {#ClientPosX}

```go
func ClientPosX() (float64, error)
```

ClientPosX reads `PIER_CPROP_POS_X`: `Actor::getFeetPos` of the local player

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientPosY` {#ClientPosY}

```go
func ClientPosY() (float64, error)
```

ClientPosY reads `PIER_CPROP_POS_Y`: feet height, the same point `get_player_position` reports

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientPosZ` {#ClientPosZ}

```go
func ClientPosZ() (float64, error)
```

ClientPosZ reads `PIER_CPROP_POS_Z`: `PIER_CPROP_POS_Z`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientPitch` {#ClientPitch}

```go
func ClientPitch() (float64, error)
```

ClientPitch reads `PIER_CPROP_PITCH`: `Actor::getRotation`, degrees; negative looks up

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientYaw` {#ClientYaw}

```go
func ClientYaw() (float64, error)
```

ClientYaw reads `PIER_CPROP_YAW`: `Actor::getRotation`, degrees

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientDimension` {#ClientDimension}

```go
func ClientDimension() (float64, error)
```

ClientDimension reads `PIER_CPROP_DIMENSION`: `Actor::getDimensionId` of the local player

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGuiScale` {#ClientGuiScale}

```go
func ClientGuiScale() (float64, error)
```

ClientGuiScale reads `PIER_CPROP_GUI_SCALE`: `IClientInstance::getGuiScale`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientServerPingMs` {#ClientServerPingMs}

```go
func ClientServerPingMs() (float64, error)
```

ClientServerPingMs reads `PIER_CPROP_SERVER_PING_MS`: `IClientInstance::getServerPingTime`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingMenu` {#ClientIsShowingMenu}

```go
func ClientIsShowingMenu() (bool, error)
```

ClientIsShowingMenu reads `PIER_CPROP_IS_SHOWING_MENU`: `IClientInstance::isShowingMenu`, 1 or 0

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingPauseScreen` {#ClientIsShowingPauseScreen}

```go
func ClientIsShowingPauseScreen() (bool, error)
```

ClientIsShowingPauseScreen reads `PIER_CPROP_IS_SHOWING_PAUSE_SCREEN`: `IClientInstance::isShowingPauseScreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPlaying` {#ClientIsPlaying}

```go
func ClientIsPlaying() (bool, error)
```

ClientIsPlaying reads `PIER_CPROP_IS_PLAYING`: `IClientInstance::isPlaying`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInRealm` {#ClientIsInRealm}

```go
func ClientIsInRealm() (bool, error)
```

ClientIsInRealm reads `PIER_CPROP_IS_IN_REALM`: `IClientInstance::isInRealm`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsGameInputEnabled` {#ClientIsGameInputEnabled}

```go
func ClientIsGameInputEnabled() (bool, error)
```

ClientIsGameInputEnabled reads `PIER_CPROP_IS_GAME_INPUT_ENABLED`: `IClientInstance::isInGameInputEnabled`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHealth` {#ClientHealth}

```go
func ClientHealth() (float64, error)
```

ClientHealth reads `PIER_CPROP_HEALTH`: `Actor::getHealth` of the local player

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientMaxHealth` {#ClientMaxHealth}

```go
func ClientMaxHealth() (float64, error)
```

ClientMaxHealth reads `PIER_CPROP_MAX_HEALTH`: `Actor::getMaxHealth` of the local player

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsOnGround` {#ClientIsOnGround}

```go
func ClientIsOnGround() (bool, error)
```

ClientIsOnGround reads `PIER_CPROP_IS_ON_GROUND`: `Actor::isOnGround` of the local player

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInWater` {#ClientIsInWater}

```go
func ClientIsInWater() (bool, error)
```

ClientIsInWater reads `PIER_CPROP_IS_IN_WATER`: `Actor::isInWater` of the local player

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSneaking` {#ClientIsSneaking}

```go
func ClientIsSneaking() (bool, error)
```

ClientIsSneaking reads `PIER_CPROP_IS_SNEAKING`: `Actor::isSneaking` of the local player

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSprinting` {#ClientIsSprinting}

```go
func ClientIsSprinting() (bool, error)
```

ClientIsSprinting reads `PIER_CPROP_IS_SPRINTING`: `Actor::isSprinting` of the local player

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSwimming` {#ClientIsSwimming}

```go
func ClientIsSwimming() (bool, error)
```

ClientIsSwimming reads `PIER_CPROP_IS_SWIMMING`: `Actor::isSwimming` of the local player

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsOnFire` {#ClientIsOnFire}

```go
func ClientIsOnFire() (bool, error)
```

ClientIsOnFire reads `PIER_CPROP_IS_ON_FIRE`: `Actor::isOnFire` of the local player

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsFlying` {#ClientIsFlying}

```go
func ClientIsFlying() (bool, error)
```

ClientIsFlying reads `PIER_CPROP_IS_FLYING`: `Player::isFlying` of the local player

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGameType` {#ClientGameType}

```go
func ClientGameType() (float64, error)
```

ClientGameType reads `PIER_CPROP_GAME_TYPE`: `Player::getPlayerGameType` of the local player

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientSelectedSlot` {#ClientSelectedSlot}

```go
func ClientSelectedSlot() (float64, error)
```

ClientSelectedSlot reads `PIER_CPROP_SELECTED_SLOT`: `Player::getSelectedItemSlot` of the local player

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientVelX` {#ClientVelX}

```go
func ClientVelX() (float64, error)
```

ClientVelX reads `PIER_CPROP_VEL_X`: `Actor::getPosDelta` of the local player, blocks per tick

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientVelY` {#ClientVelY}

```go
func ClientVelY() (float64, error)
```

ClientVelY reads `PIER_CPROP_VEL_Y`: `Actor::getPosDelta`, the vertical part

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientVelZ` {#ClientVelZ}

```go
func ClientVelZ() (float64, error)
```

ClientVelZ reads `PIER_CPROP_VEL_Z`: `Actor::getPosDelta`, the z part

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientXpNeededNextLevel` {#ClientXpNeededNextLevel}

```go
func ClientXpNeededNextLevel() (float64, error)
```

ClientXpNeededNextLevel reads `PIER_CPROP_XP_NEEDED_NEXT_LEVEL`: `Player::getXpNeededForNextLevel` of the local player

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsLeavingGame` {#ClientIsLeavingGame}

```go
func ClientIsLeavingGame() (bool, error)
```

ClientIsLeavingGame reads `PIER_CPROP_IS_LEAVING_GAME`: `IClientInstance::isLeavingGame`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsExitingLevel` {#ClientIsExitingLevel}

```go
func ClientIsExitingLevel() (bool, error)
```

ClientIsExitingLevel reads `PIER_CPROP_IS_EXITING_LEVEL`: `IClientInstance::isExitingLevel`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInBedScreen` {#ClientIsInBedScreen}

```go
func ClientIsInBedScreen() (bool, error)
```

ClientIsInBedScreen reads `PIER_CPROP_IS_IN_BED_SCREEN`: `IClientInstance::isInBedScreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInDeathScreen` {#ClientIsInDeathScreen}

```go
func ClientIsInDeathScreen() (bool, error)
```

ClientIsInDeathScreen reads `PIER_CPROP_IS_IN_DEATH_SCREEN`: `IClientInstance::isInDeathScreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingLoadingScreen` {#ClientIsShowingLoadingScreen}

```go
func ClientIsShowingLoadingScreen() (bool, error)
```

ClientIsShowingLoadingScreen reads `PIER_CPROP_IS_SHOWING_LOADING_SCREEN`: `IClientInstance::isShowingLoadingScreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingProgressScreen` {#ClientIsShowingProgressScreen}

```go
func ClientIsShowingProgressScreen() (bool, error)
```

ClientIsShowingProgressScreen reads `PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN`: `IClientInstance::isShowingProgressScreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingWorldProgressScreen` {#ClientIsShowingWorldProgressScreen}

```go
func ClientIsShowingWorldProgressScreen() (bool, error)
```

ClientIsShowingWorldProgressScreen reads `PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN`: `IClientInstance::isShowingWorldProgressScreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingDeathScreen` {#ClientIsShowingDeathScreen}

```go
func ClientIsShowingDeathScreen() (bool, error)
```

ClientIsShowingDeathScreen reads `PIER_CPROP_IS_SHOWING_DEATH_SCREEN`: `IClientInstance::isShowingDeathScreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsShowingServerForm` {#ClientIsShowingServerForm}

```go
func ClientIsShowingServerForm() (bool, error)
```

ClientIsShowingServerForm reads `PIER_CPROP_IS_SHOWING_SERVER_FORM`: `IClientInstance::isShowingServerForm`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInWorldWithoutMenu` {#ClientIsInWorldWithoutMenu}

```go
func ClientIsInWorldWithoutMenu() (bool, error)
```

ClientIsInWorldWithoutMenu reads `PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU`: `IClientInstance::isInWorldAndNotShowingAnyMenuScreens`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsWorldActive` {#ClientIsWorldActive}

```go
func ClientIsWorldActive() (bool, error)
```

ClientIsWorldActive reads `PIER_CPROP_IS_WORLD_ACTIVE`: `IClientInstance::isWorldActive`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHasLevel` {#ClientHasLevel}

```go
func ClientHasLevel() (bool, error)
```

ClientHasLevel reads `PIER_CPROP_HAS_LEVEL`: `IClientInstance::hasLevel`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPreGame` {#ClientIsPreGame}

```go
func ClientIsPreGame() (bool, error)
```

ClientIsPreGame reads `PIER_CPROP_IS_PRE_GAME`: `IClientInstance::isPreGame`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInMultiplayerGame` {#ClientIsInMultiplayerGame}

```go
func ClientIsInMultiplayerGame() (bool, error)
```

ClientIsInMultiplayerGame reads `PIER_CPROP_IS_IN_MULTIPLAYER_GAME`: `IClientInstance::isInMultiplayerGame`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsMultiplayerClient` {#ClientIsMultiplayerClient}

```go
func ClientIsMultiplayerClient() (bool, error)
```

ClientIsMultiplayerClient reads `PIER_CPROP_IS_MULTIPLAYER_CLIENT`: `IClientInstance::isMultiPlayerClient`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPrimaryLevelMultiplayer` {#ClientIsPrimaryLevelMultiplayer}

```go
func ClientIsPrimaryLevelMultiplayer() (bool, error)
```

ClientIsPrimaryLevelMultiplayer reads `PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER`: `IClientInstance::isPrimaryLevelMultiplayer`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPrimaryLevelCrossPlatform` {#ClientIsPrimaryLevelCrossPlatform}

```go
func ClientIsPrimaryLevelCrossPlatform() (bool, error)
```

ClientIsPrimaryLevelCrossPlatform reads `PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM`: `IClientInstance::isPrimaryLevelCrossPlatformMultiplayer`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsKeyboardEnabled` {#ClientIsKeyboardEnabled}

```go
func ClientIsKeyboardEnabled() (bool, error)
```

ClientIsKeyboardEnabled reads `PIER_CPROP_IS_KEYBOARD_ENABLED`: `IClientInstance::isKeyboardEnabled`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsUsingController` {#ClientIsUsingController}

```go
func ClientIsUsingController() (bool, error)
```

ClientIsUsingController reads `PIER_CPROP_IS_USING_CONTROLLER`: `IClientInstance::useController`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsUsingTouchscreen` {#ClientIsUsingTouchscreen}

```go
func ClientIsUsingTouchscreen() (bool, error)
```

ClientIsUsingTouchscreen reads `PIER_CPROP_IS_USING_TOUCHSCREEN`: `IClientInstance::useTouchscreen`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsMouseGrabbed` {#ClientIsMouseGrabbed}

```go
func ClientIsMouseGrabbed() (bool, error)
```

ClientIsMouseGrabbed reads `PIER_CPROP_IS_MOUSE_GRABBED`: `IClientInstance::getMouseGrabbed`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsMouseAndKeyboard` {#ClientIsMouseAndKeyboard}

```go
func ClientIsMouseAndKeyboard() (bool, error)
```

ClientIsMouseAndKeyboard reads `PIER_CPROP_IS_MOUSE_AND_KEYBOARD`: `IClientInstance::currentInputModeIsMouseAndKeyboard`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHasConnectedController` {#ClientHasConnectedController}

```go
func ClientHasConnectedController() (bool, error)
```

ClientHasConnectedController reads `PIER_CPROP_HAS_CONNECTED_CONTROLLER`: `IClientInstance::hasConnectedController`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientControllerId` {#ClientControllerId}

```go
func ClientControllerId() (float64, error)
```

ClientControllerId reads `PIER_CPROP_CONTROLLER_ID`: `IClientInstance::getControllerId`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsTouchGameplayAllowed` {#ClientIsTouchGameplayAllowed}

```go
func ClientIsTouchGameplayAllowed() (bool, error)
```

ClientIsTouchGameplayAllowed reads `PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED`: `IClientInstance::isTouchGameplayAllowed`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsSplitScreenActive` {#ClientIsSplitScreenActive}

```go
func ClientIsSplitScreenActive() (bool, error)
```

ClientIsSplitScreenActive reads `PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE`: `IClientInstance::isSplitScreenActive`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientSplitScreenCount` {#ClientSplitScreenCount}

```go
func ClientSplitScreenCount() (float64, error)
```

ClientSplitScreenCount reads `PIER_CPROP_SPLIT_SCREEN_COUNT`: `IClientInstance::getSplitScreenCount`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGuiScaleOffset` {#ClientGuiScaleOffset}

```go
func ClientGuiScaleOffset() (float64, error)
```

ClientGuiScaleOffset reads `PIER_CPROP_GUI_SCALE_OFFSET`: `IClientInstance::getGuiScaleOffset`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsEduMode` {#ClientIsEduMode}

```go
func ClientIsEduMode() (bool, error)
```

ClientIsEduMode reads `PIER_CPROP_IS_EDU_MODE`: `IClientInstance::isEduMode`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsInEditor` {#ClientIsInEditor}

```go
func ClientIsInEditor() (bool, error)
```

ClientIsInEditor reads `PIER_CPROP_IS_IN_EDITOR`: `IClientInstance::isPlayerInEditor`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsReadyToRender` {#ClientIsReadyToRender}

```go
func ClientIsReadyToRender() (bool, error)
```

ClientIsReadyToRender reads `PIER_CPROP_IS_READY_TO_RENDER`: `IClientInstance::isReadyToRender`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsFullVanillaPackOnStack` {#ClientIsFullVanillaPackOnStack}

```go
func ClientIsFullVanillaPackOnStack() (bool, error)
```

ClientIsFullVanillaPackOnStack reads `PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK`: `IClientInstance::isFullVanillaPackOnStack`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientServerConnectionTime` {#ClientServerConnectionTime}

```go
func ClientServerConnectionTime() (float64, error)
```

ClientServerConnectionTime reads `PIER_CPROP_SERVER_CONNECTION_TIME`: `IClientInstance::getServerConnectionTime`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientRemoteServerTimeMs` {#ClientRemoteServerTimeMs}

```go
func ClientRemoteServerTimeMs() (float64, error)
```

ClientRemoteServerTimeMs reads `PIER_CPROP_REMOTE_SERVER_TIME_MS`: `IClientInstance::getRemoteServerTimeMs`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientRemoteServerNetworkTimeMs` {#ClientRemoteServerNetworkTimeMs}

```go
func ClientRemoteServerNetworkTimeMs() (float64, error)
```

ClientRemoteServerNetworkTimeMs reads `PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS`: `IClientInstance::getRemoteServerNetworkTimeMs`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientFrameAlpha` {#ClientFrameAlpha}

```go
func ClientFrameAlpha() (float64, error)
```

ClientFrameAlpha reads `PIER_CPROP_FRAME_ALPHA`: `IClientInstance::getFrameAlpha`, how far the frame is between two ticks

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientGameUpdateSeconds` {#ClientGameUpdateSeconds}

```go
func ClientGameUpdateSeconds() (float64, error)
```

ClientGameUpdateSeconds reads `PIER_CPROP_GAME_UPDATE_SECONDS`: `IClientInstance::getGameUpdateDurationInSeconds`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsPrimaryClient` {#ClientIsPrimaryClient}

```go
func ClientIsPrimaryClient() (bool, error)
```

ClientIsPrimaryClient reads `PIER_CPROP_IS_PRIMARY_CLIENT`: `IClientInstance::isPrimaryClient`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientUserId` {#ClientUserId}

```go
func ClientUserId() (float64, error)
```

ClientUserId reads `PIER_CPROP_USER_ID`: `IClientInstance::getUserId`

- Return type: `(float64, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientIsGameplayTipsEnabled` {#ClientIsGameplayTipsEnabled}

```go
func ClientIsGameplayTipsEnabled() (bool, error)
```

ClientIsGameplayTipsEnabled reads `PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED`: `IClientInstance::isGamePlayTipsEnabled`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientHasCommands` {#ClientHasCommands}

```go
func ClientHasCommands() (bool, error)
```

ClientHasCommands reads `PIER_CPROP_HAS_COMMANDS`: `IClientInstance::hasCommands`

- Return type: `(bool, error)`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `ClientScreenName` {#ClientScreenName}

```go
func ClientScreenName() (string, error)
```

ClientScreenName reads `PIER_CSTR_SCREEN_NAME`: `IClientInstance::getScreenName`, as `client_get_screen_name`

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientTopScreenName` {#ClientTopScreenName}

```go
func ClientTopScreenName() (string, error)
```

ClientTopScreenName reads `PIER_CSTR_TOP_SCREEN_NAME`: `IClientInstance::getTopScreenName`

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientPlatformId` {#ClientPlatformId}

```go
func ClientPlatformId() (string, error)
```

ClientPlatformId reads `PIER_CSTR_PLATFORM_ID`: `IClientInstance::getPlatformId`

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientPlatformOnlineId` {#ClientPlatformOnlineId}

```go
func ClientPlatformOnlineId() (string, error)
```

ClientPlatformOnlineId reads `PIER_CSTR_PLATFORM_ONLINE_ID`: `IClientInstance::getPlatformOnlineId`

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientLocalXuid` {#ClientLocalXuid}

```go
func ClientLocalXuid() (string, error)
```

ClientLocalXuid reads `PIER_CSTR_LOCAL_XUID`: `Player::getXuid` of the local player; fails outside a world

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientLocalUuid` {#ClientLocalUuid}

```go
func ClientLocalUuid() (string, error)
```

ClientLocalUuid reads `PIER_CSTR_LOCAL_UUID`: `Player::getUuid` of the local player in its canonical form

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientLocalNameTag` {#ClientLocalNameTag}

```go
func ClientLocalNameTag() (string, error)
```

ClientLocalNameTag reads `PIER_CSTR_LOCAL_NAME_TAG`: `Actor::getNameTag` of the local player

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientClipboard` {#ClientClipboard}

```go
func ClientClipboard() (string, error)
```

ClientClipboard reads `PIER_CSTR_CLIPBOARD`: `AppPlatform::getClipboardText`, the system clipboard

- Return type: `(string, error)`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `ClientShowMessage` {#ClientShowMessage}

```go
func ClientShowMessage(sarg string, a, b, c float64) error
```

ClientShowMessage runs `PIER_CACT_SHOW_MESSAGE`: sarg: text. `GuiData::displayClientMessage`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetTitle` {#ClientSetTitle}

```go
func ClientSetTitle(sarg string, a, b, c float64) error
```

ClientSetTitle runs `PIER_CACT_SET_TITLE`: sarg: text. `GuiData::setTitle`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetSubtitle` {#ClientSetSubtitle}

```go
func ClientSetSubtitle(sarg string, a, b, c float64) error
```

ClientSetSubtitle runs `PIER_CACT_SET_SUBTITLE`: sarg: text. `GuiData::setSubtitle`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetActionBar` {#ClientSetActionBar}

```go
func ClientSetActionBar(sarg string, a, b, c float64) error
```

ClientSetActionBar runs `PIER_CACT_SET_ACTION_BAR`: sarg: text. `GuiData::setActionBarMessage`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientShowTip` {#ClientShowTip}

```go
func ClientShowTip(sarg string, a, b, c float64) error
```

ClientShowTip runs `PIER_CACT_SHOW_TIP`: sarg: text. `GuiData::showTipMessage`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientPlayUiSound` {#ClientPlayUiSound}

```go
func ClientPlayUiSound(sarg string, a, b, c float64) error
```

ClientPlayUiSound runs `PIER_CACT_PLAY_UI_SOUND`: sarg: sound name, a: volume, b: pitch. `IClientInstance::playUI`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientGrabMouse` {#ClientGrabMouse}

```go
func ClientGrabMouse(sarg string, a, b, c float64) error
```

ClientGrabMouse runs `PIER_CACT_GRAB_MOUSE`: `IClientInstance::grabMouse`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientReleaseMouse` {#ClientReleaseMouse}

```go
func ClientReleaseMouse(sarg string, a, b, c float64) error
```

ClientReleaseMouse runs `PIER_CACT_RELEASE_MOUSE`: `IClientInstance::releaseMouse`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetInputDisabled` {#ClientSetInputDisabled}

```go
func ClientSetInputDisabled(sarg string, a, b, c float64) error
```

ClientSetInputDisabled runs `PIER_CACT_SET_INPUT_DISABLED`: a: non-zero disables game input. `IClientInstance::setDisableInput`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientLeaveLevel` {#ClientLeaveLevel}

```go
func ClientLeaveLevel(sarg string, a, b, c float64) error
```

ClientLeaveLevel runs `PIER_CACT_LEAVE_LEVEL`: `IClientInstance::requestLeaveGame`(true, false): leaves the world for the menus, asynchronously

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientShowPopup` {#ClientShowPopup}

```go
func ClientShowPopup(sarg string, a, b, c float64) error
```

ClientShowPopup runs `PIER_CACT_SHOW_POPUP`: sarg: message, or message and subtitle split at the first newline. `GuiData::showPopupNotice`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientShowDevConsoleMessage` {#ClientShowDevConsoleMessage}

```go
func ClientShowDevConsoleMessage(sarg string, a, b, c float64) error
```

ClientShowDevConsoleMessage runs `PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE`: sarg: text. `GuiData::displayDevConsoleMessage`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetSuspendInput` {#ClientSetSuspendInput}

```go
func ClientSetSuspendInput(sarg string, a, b, c float64) error
```

ClientSetSuspendInput runs `PIER_CACT_SET_SUSPEND_INPUT`: a: non-zero suspends input. `IClientInstance::setSuspendInput`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetSuspendDirectionalInput` {#ClientSetSuspendDirectionalInput}

```go
func ClientSetSuspendDirectionalInput(sarg string, a, b, c float64) error
```

ClientSetSuspendDirectionalInput runs `PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT`: a: non-zero suspends movement input. `IClientInstance::setSuspendDirectionalInput`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetGameInputEnabled` {#ClientSetGameInputEnabled}

```go
func ClientSetGameInputEnabled(sarg string, a, b, c float64) error
```

ClientSetGameInputEnabled runs `PIER_CACT_SET_GAME_INPUT_ENABLED`: a: non-zero enables. `IClientInstance::setInGameInputEnabled`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientRefocusMouse` {#ClientRefocusMouse}

```go
func ClientRefocusMouse(sarg string, a, b, c float64) error
```

ClientRefocusMouse runs `PIER_CACT_REFOCUS_MOUSE`: a: non-zero when the mouse was lost. `IClientInstance::refocusMouse`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientMuteAudio` {#ClientMuteAudio}

```go
func ClientMuteAudio(sarg string, a, b, c float64) error
```

ClientMuteAudio runs `PIER_CACT_MUTE_AUDIO`: `IClientInstance::muteAudio`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientUnmuteAudio` {#ClientUnmuteAudio}

```go
func ClientUnmuteAudio(sarg string, a, b, c float64) error
```

ClientUnmuteAudio runs `PIER_CACT_UNMUTE_AUDIO`: `IClientInstance::unMuteAudio`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientFadeOutMusic` {#ClientFadeOutMusic}

```go
func ClientFadeOutMusic(sarg string, a, b, c float64) error
```

ClientFadeOutMusic runs `PIER_CACT_FADE_OUT_MUSIC`: `IClientInstance::fadeOutMusic`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetGuiScaleOffset` {#ClientSetGuiScaleOffset}

```go
func ClientSetGuiScaleOffset(sarg string, a, b, c float64) error
```

ClientSetGuiScaleOffset runs `PIER_CACT_SET_GUI_SCALE_OFFSET`: a: the offset. `IClientInstance::setGuiScaleOffset`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientResetPlayerMovement` {#ClientResetPlayerMovement}

```go
func ClientResetPlayerMovement(sarg string, a, b, c float64) error
```

ClientResetPlayerMovement runs `PIER_CACT_RESET_PLAYER_MOVEMENT`: `IClientInstance::resetPlayerMovement`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientPushLeaveGameScreen` {#ClientPushLeaveGameScreen}

```go
func ClientPushLeaveGameScreen(sarg string, a, b, c float64) error
```

ClientPushLeaveGameScreen runs `PIER_CACT_PUSH_LEAVE_GAME_SCREEN`: `IClientInstance::tryPushLeaveGameScreen`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientOpenContentLogHistory` {#ClientOpenContentLogHistory}

```go
func ClientOpenContentLogHistory(sarg string, a, b, c float64) error
```

ClientOpenContentLogHistory runs `PIER_CACT_OPEN_CONTENT_LOG_HISTORY`: `IClientInstance::openContentLogHistory`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientSetClipboard` {#ClientSetClipboard}

```go
func ClientSetClipboard(sarg string, a, b, c float64) error
```

ClientSetClipboard runs `PIER_CACT_SET_CLIPBOARD`: sarg: text, empty allowed. `AppPlatform::setClipboard`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `ClientNavigateHowToPlay` {#ClientNavigateHowToPlay}

```go
func ClientNavigateHowToPlay(sarg string, a, b, c float64) error
```

ClientNavigateHowToPlay runs `PIER_CACT_NAVIGATE_HOW_TO_PLAY`: sarg: the topic, empty allowed. `IClientInstance::navigateToHowToPlayScreen`

abi.h names each argument; an unused one is ignored.

- Parameters:
    - sarg : `string`
    - a : `float64`
    - b : `float64`
    - c : `float64`
- Return type: `error`
- Slots: [`client_action`](../cpp/client.md#client_action)

## `KeyBinding` {#KeyBinding}

```go
type KeyBinding struct {
    // unexported fields
}
```

KeyBinding is a registered client key binding.

### `KeyBinding.Unregister` {#KeyBinding.Unregister}

```go
func (k *KeyBinding) Unregister() error
```

Unregister stops the binding's callbacks.

- Return type: `error`
- Slots: [`client_unregister_key`](../cpp/client.md#client_unregister_key)

### `KeyBinding.KeyCodes` {#KeyBinding.KeyCodes}

```go
func (k *KeyBinding) KeyCodes() ([]int32, error)
```

KeyCodes lists the key codes now assigned to the binding, which differ from the defaults when the player remapped the key.

- Return type: `([]int32, error)`
- Slots: [`client_get_key_codes`](../cpp/client.md#client_get_key_codes)

## `KeyHandle` {#KeyHandle}

```go
type KeyHandle struct{ p unsafe.Pointer }
type KeyHandle struct{ p unsafe.Pointer }
```

KeyHandle is a registered client key binding.

### `KeyHandle.IsZero` {#KeyHandle.IsZero}

```go
func (h KeyHandle) IsZero() bool
```

IsZero reports whether the handle names nothing.

- Return type: `bool`

## `CProp*` {#CProp}

| Name | Value | Description |
|---|---|---|
| <span id="CPropPosX"></span>`CPropPosX` | `0` | CPropPosX is `PIER_CPROP_POS_X`: `Actor::getFeetPos` of the local player |
| <span id="CPropPosY"></span>`CPropPosY` | `1` | CPropPosY is `PIER_CPROP_POS_Y`: feet height, the same point `get_player_position` reports |
| <span id="CPropPosZ"></span>`CPropPosZ` | `2` | CPropPosZ is `PIER_CPROP_POS_Z`: `PIER_CPROP_POS_Z` |
| <span id="CPropPitch"></span>`CPropPitch` | `3` | CPropPitch is `PIER_CPROP_PITCH`: `Actor::getRotation`, degrees; negative looks up |
| <span id="CPropYaw"></span>`CPropYaw` | `4` | CPropYaw is `PIER_CPROP_YAW`: `Actor::getRotation`, degrees |
| <span id="CPropDimension"></span>`CPropDimension` | `5` | CPropDimension is `PIER_CPROP_DIMENSION`: `Actor::getDimensionId` of the local player |
| <span id="CPropGuiScale"></span>`CPropGuiScale` | `6` | CPropGuiScale is `PIER_CPROP_GUI_SCALE`: `IClientInstance::getGuiScale` |
| <span id="CPropServerPingMs"></span>`CPropServerPingMs` | `7` | CPropServerPingMs is `PIER_CPROP_SERVER_PING_MS`: `IClientInstance::getServerPingTime` |
| <span id="CPropIsShowingMenu"></span>`CPropIsShowingMenu` | `8` | CPropIsShowingMenu is `PIER_CPROP_IS_SHOWING_MENU`: `IClientInstance::isShowingMenu`, 1 or 0 |
| <span id="CPropIsShowingPauseScreen"></span>`CPropIsShowingPauseScreen` | `9` | CPropIsShowingPauseScreen is `PIER_CPROP_IS_SHOWING_PAUSE_SCREEN`: `IClientInstance::isShowingPauseScreen` |
| <span id="CPropIsPlaying"></span>`CPropIsPlaying` | `10` | CPropIsPlaying is `PIER_CPROP_IS_PLAYING`: `IClientInstance::isPlaying` |
| <span id="CPropIsInRealm"></span>`CPropIsInRealm` | `11` | CPropIsInRealm is `PIER_CPROP_IS_IN_REALM`: `IClientInstance::isInRealm` |
| <span id="CPropIsGameInputEnabled"></span>`CPropIsGameInputEnabled` | `12` | CPropIsGameInputEnabled is `PIER_CPROP_IS_GAME_INPUT_ENABLED`: `IClientInstance::isInGameInputEnabled` |
| <span id="CPropHealth"></span>`CPropHealth` | `13` | CPropHealth is `PIER_CPROP_HEALTH`: `Actor::getHealth` of the local player |
| <span id="CPropMaxHealth"></span>`CPropMaxHealth` | `14` | CPropMaxHealth is `PIER_CPROP_MAX_HEALTH`: `Actor::getMaxHealth` of the local player |
| <span id="CPropIsOnGround"></span>`CPropIsOnGround` | `15` | CPropIsOnGround is `PIER_CPROP_IS_ON_GROUND`: `Actor::isOnGround` of the local player |
| <span id="CPropIsInWater"></span>`CPropIsInWater` | `16` | CPropIsInWater is `PIER_CPROP_IS_IN_WATER`: `Actor::isInWater` of the local player |
| <span id="CPropIsSneaking"></span>`CPropIsSneaking` | `17` | CPropIsSneaking is `PIER_CPROP_IS_SNEAKING`: `Actor::isSneaking` of the local player |
| <span id="CPropIsSprinting"></span>`CPropIsSprinting` | `18` | CPropIsSprinting is `PIER_CPROP_IS_SPRINTING`: `Actor::isSprinting` of the local player |
| <span id="CPropIsSwimming"></span>`CPropIsSwimming` | `19` | CPropIsSwimming is `PIER_CPROP_IS_SWIMMING`: `Actor::isSwimming` of the local player |
| <span id="CPropIsOnFire"></span>`CPropIsOnFire` | `20` | CPropIsOnFire is `PIER_CPROP_IS_ON_FIRE`: `Actor::isOnFire` of the local player |
| <span id="CPropIsFlying"></span>`CPropIsFlying` | `21` | CPropIsFlying is `PIER_CPROP_IS_FLYING`: `Player::isFlying` of the local player |
| <span id="CPropGameType"></span>`CPropGameType` | `22` | CPropGameType is `PIER_CPROP_GAME_TYPE`: `Player::getPlayerGameType` of the local player |
| <span id="CPropSelectedSlot"></span>`CPropSelectedSlot` | `23` | CPropSelectedSlot is `PIER_CPROP_SELECTED_SLOT`: `Player::getSelectedItemSlot` of the local player |
| <span id="CPropVelX"></span>`CPropVelX` | `24` | CPropVelX is `PIER_CPROP_VEL_X`: `Actor::getPosDelta` of the local player, blocks per tick |
| <span id="CPropVelY"></span>`CPropVelY` | `25` | CPropVelY is `PIER_CPROP_VEL_Y`: `Actor::getPosDelta`, the vertical part |
| <span id="CPropVelZ"></span>`CPropVelZ` | `26` | CPropVelZ is `PIER_CPROP_VEL_Z`: `Actor::getPosDelta`, the z part |
| <span id="CPropXpNeededNextLevel"></span>`CPropXpNeededNextLevel` | `27` | CPropXpNeededNextLevel is `PIER_CPROP_XP_NEEDED_NEXT_LEVEL`: `Player::getXpNeededForNextLevel` of the local player |
| <span id="CPropIsLeavingGame"></span>`CPropIsLeavingGame` | `28` | CPropIsLeavingGame is `PIER_CPROP_IS_LEAVING_GAME`: `IClientInstance::isLeavingGame` |
| <span id="CPropIsExitingLevel"></span>`CPropIsExitingLevel` | `29` | CPropIsExitingLevel is `PIER_CPROP_IS_EXITING_LEVEL`: `IClientInstance::isExitingLevel` |
| <span id="CPropIsInBedScreen"></span>`CPropIsInBedScreen` | `30` | CPropIsInBedScreen is `PIER_CPROP_IS_IN_BED_SCREEN`: `IClientInstance::isInBedScreen` |
| <span id="CPropIsInDeathScreen"></span>`CPropIsInDeathScreen` | `31` | CPropIsInDeathScreen is `PIER_CPROP_IS_IN_DEATH_SCREEN`: `IClientInstance::isInDeathScreen` |
| <span id="CPropIsShowingLoadingScreen"></span>`CPropIsShowingLoadingScreen` | `32` | CPropIsShowingLoadingScreen is `PIER_CPROP_IS_SHOWING_LOADING_SCREEN`: `IClientInstance::isShowingLoadingScreen` |
| <span id="CPropIsShowingProgressScreen"></span>`CPropIsShowingProgressScreen` | `33` | CPropIsShowingProgressScreen is `PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN`: `IClientInstance::isShowingProgressScreen` |
| <span id="CPropIsShowingWorldProgressScreen"></span>`CPropIsShowingWorldProgressScreen` | `34` | CPropIsShowingWorldProgressScreen is `PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN`: `IClientInstance::isShowingWorldProgressScreen` |
| <span id="CPropIsShowingDeathScreen"></span>`CPropIsShowingDeathScreen` | `35` | CPropIsShowingDeathScreen is `PIER_CPROP_IS_SHOWING_DEATH_SCREEN`: `IClientInstance::isShowingDeathScreen` |
| <span id="CPropIsShowingServerForm"></span>`CPropIsShowingServerForm` | `36` | CPropIsShowingServerForm is `PIER_CPROP_IS_SHOWING_SERVER_FORM`: `IClientInstance::isShowingServerForm` |
| <span id="CPropIsInWorldWithoutMenu"></span>`CPropIsInWorldWithoutMenu` | `37` | CPropIsInWorldWithoutMenu is `PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU`: `IClientInstance::isInWorldAndNotShowingAnyMenuScreens` |
| <span id="CPropIsWorldActive"></span>`CPropIsWorldActive` | `38` | CPropIsWorldActive is `PIER_CPROP_IS_WORLD_ACTIVE`: `IClientInstance::isWorldActive` |
| <span id="CPropHasLevel"></span>`CPropHasLevel` | `39` | CPropHasLevel is `PIER_CPROP_HAS_LEVEL`: `IClientInstance::hasLevel` |
| <span id="CPropIsPreGame"></span>`CPropIsPreGame` | `40` | CPropIsPreGame is `PIER_CPROP_IS_PRE_GAME`: `IClientInstance::isPreGame` |
| <span id="CPropIsInMultiplayerGame"></span>`CPropIsInMultiplayerGame` | `41` | CPropIsInMultiplayerGame is `PIER_CPROP_IS_IN_MULTIPLAYER_GAME`: `IClientInstance::isInMultiplayerGame` |
| <span id="CPropIsMultiplayerClient"></span>`CPropIsMultiplayerClient` | `42` | CPropIsMultiplayerClient is `PIER_CPROP_IS_MULTIPLAYER_CLIENT`: `IClientInstance::isMultiPlayerClient` |
| <span id="CPropIsPrimaryLevelMultiplayer"></span>`CPropIsPrimaryLevelMultiplayer` | `43` | CPropIsPrimaryLevelMultiplayer is `PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER`: `IClientInstance::isPrimaryLevelMultiplayer` |
| <span id="CPropIsPrimaryLevelCrossPlatform"></span>`CPropIsPrimaryLevelCrossPlatform` | `44` | CPropIsPrimaryLevelCrossPlatform is `PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM`: `IClientInstance::isPrimaryLevelCrossPlatformMultiplayer` |
| <span id="CPropIsKeyboardEnabled"></span>`CPropIsKeyboardEnabled` | `45` | CPropIsKeyboardEnabled is `PIER_CPROP_IS_KEYBOARD_ENABLED`: `IClientInstance::isKeyboardEnabled` |
| <span id="CPropIsUsingController"></span>`CPropIsUsingController` | `46` | CPropIsUsingController is `PIER_CPROP_IS_USING_CONTROLLER`: `IClientInstance::useController` |
| <span id="CPropIsUsingTouchscreen"></span>`CPropIsUsingTouchscreen` | `47` | CPropIsUsingTouchscreen is `PIER_CPROP_IS_USING_TOUCHSCREEN`: `IClientInstance::useTouchscreen` |
| <span id="CPropIsMouseGrabbed"></span>`CPropIsMouseGrabbed` | `48` | CPropIsMouseGrabbed is `PIER_CPROP_IS_MOUSE_GRABBED`: `IClientInstance::getMouseGrabbed` |
| <span id="CPropIsMouseAndKeyboard"></span>`CPropIsMouseAndKeyboard` | `49` | CPropIsMouseAndKeyboard is `PIER_CPROP_IS_MOUSE_AND_KEYBOARD`: `IClientInstance::currentInputModeIsMouseAndKeyboard` |
| <span id="CPropHasConnectedController"></span>`CPropHasConnectedController` | `50` | CPropHasConnectedController is `PIER_CPROP_HAS_CONNECTED_CONTROLLER`: `IClientInstance::hasConnectedController` |
| <span id="CPropControllerId"></span>`CPropControllerId` | `51` | CPropControllerId is `PIER_CPROP_CONTROLLER_ID`: `IClientInstance::getControllerId` |
| <span id="CPropIsTouchGameplayAllowed"></span>`CPropIsTouchGameplayAllowed` | `52` | CPropIsTouchGameplayAllowed is `PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED`: `IClientInstance::isTouchGameplayAllowed` |
| <span id="CPropIsSplitScreenActive"></span>`CPropIsSplitScreenActive` | `53` | CPropIsSplitScreenActive is `PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE`: `IClientInstance::isSplitScreenActive` |
| <span id="CPropSplitScreenCount"></span>`CPropSplitScreenCount` | `54` | CPropSplitScreenCount is `PIER_CPROP_SPLIT_SCREEN_COUNT`: `IClientInstance::getSplitScreenCount` |
| <span id="CPropGuiScaleOffset"></span>`CPropGuiScaleOffset` | `55` | CPropGuiScaleOffset is `PIER_CPROP_GUI_SCALE_OFFSET`: `IClientInstance::getGuiScaleOffset` |
| <span id="CPropIsEduMode"></span>`CPropIsEduMode` | `56` | CPropIsEduMode is `PIER_CPROP_IS_EDU_MODE`: `IClientInstance::isEduMode` |
| <span id="CPropIsInEditor"></span>`CPropIsInEditor` | `57` | CPropIsInEditor is `PIER_CPROP_IS_IN_EDITOR`: `IClientInstance::isPlayerInEditor` |
| <span id="CPropIsReadyToRender"></span>`CPropIsReadyToRender` | `58` | CPropIsReadyToRender is `PIER_CPROP_IS_READY_TO_RENDER`: `IClientInstance::isReadyToRender` |
| <span id="CPropIsFullVanillaPackOnStack"></span>`CPropIsFullVanillaPackOnStack` | `59` | CPropIsFullVanillaPackOnStack is `PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK`: `IClientInstance::isFullVanillaPackOnStack` |
| <span id="CPropServerConnectionTime"></span>`CPropServerConnectionTime` | `60` | CPropServerConnectionTime is `PIER_CPROP_SERVER_CONNECTION_TIME`: `IClientInstance::getServerConnectionTime` |
| <span id="CPropRemoteServerTimeMs"></span>`CPropRemoteServerTimeMs` | `61` | CPropRemoteServerTimeMs is `PIER_CPROP_REMOTE_SERVER_TIME_MS`: `IClientInstance::getRemoteServerTimeMs` |
| <span id="CPropRemoteServerNetworkTimeMs"></span>`CPropRemoteServerNetworkTimeMs` | `62` | CPropRemoteServerNetworkTimeMs is `PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS`: `IClientInstance::getRemoteServerNetworkTimeMs` |
| <span id="CPropFrameAlpha"></span>`CPropFrameAlpha` | `63` | CPropFrameAlpha is `PIER_CPROP_FRAME_ALPHA`: `IClientInstance::getFrameAlpha`, how far the frame is between two ticks |
| <span id="CPropGameUpdateSeconds"></span>`CPropGameUpdateSeconds` | `64` | CPropGameUpdateSeconds is `PIER_CPROP_GAME_UPDATE_SECONDS`: `IClientInstance::getGameUpdateDurationInSeconds` |
| <span id="CPropIsPrimaryClient"></span>`CPropIsPrimaryClient` | `65` | CPropIsPrimaryClient is `PIER_CPROP_IS_PRIMARY_CLIENT`: `IClientInstance::isPrimaryClient` |
| <span id="CPropUserId"></span>`CPropUserId` | `66` | CPropUserId is `PIER_CPROP_USER_ID`: `IClientInstance::getUserId` |
| <span id="CPropIsGameplayTipsEnabled"></span>`CPropIsGameplayTipsEnabled` | `67` | CPropIsGameplayTipsEnabled is `PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED`: `IClientInstance::isGamePlayTipsEnabled` |
| <span id="CPropHasCommands"></span>`CPropHasCommands` | `68` | CPropHasCommands is `PIER_CPROP_HAS_COMMANDS`: `IClientInstance::hasCommands` |

## `CStr*` {#CStr}

| Name | Value | Description |
|---|---|---|
| <span id="CStrScreenName"></span>`CStrScreenName` | `0` | CStrScreenName is `PIER_CSTR_SCREEN_NAME`: `IClientInstance::getScreenName`, as `client_get_screen_name` |
| <span id="CStrTopScreenName"></span>`CStrTopScreenName` | `1` | CStrTopScreenName is `PIER_CSTR_TOP_SCREEN_NAME`: `IClientInstance::getTopScreenName` |
| <span id="CStrPlatformId"></span>`CStrPlatformId` | `2` | CStrPlatformId is `PIER_CSTR_PLATFORM_ID`: `IClientInstance::getPlatformId` |
| <span id="CStrPlatformOnlineId"></span>`CStrPlatformOnlineId` | `3` | CStrPlatformOnlineId is `PIER_CSTR_PLATFORM_ONLINE_ID`: `IClientInstance::getPlatformOnlineId` |
| <span id="CStrLocalXuid"></span>`CStrLocalXuid` | `4` | CStrLocalXuid is `PIER_CSTR_LOCAL_XUID`: `Player::getXuid` of the local player; fails outside a world |
| <span id="CStrLocalUuid"></span>`CStrLocalUuid` | `5` | CStrLocalUuid is `PIER_CSTR_LOCAL_UUID`: `Player::getUuid` of the local player in its canonical form |
| <span id="CStrLocalNameTag"></span>`CStrLocalNameTag` | `6` | CStrLocalNameTag is `PIER_CSTR_LOCAL_NAME_TAG`: `Actor::getNameTag` of the local player |
| <span id="CStrClipboard"></span>`CStrClipboard` | `7` | CStrClipboard is `PIER_CSTR_CLIPBOARD`: `AppPlatform::getClipboardText`, the system clipboard |

## `CAct*` {#CAct}

| Name | Value | Description |
|---|---|---|
| <span id="CActShowMessage"></span>`CActShowMessage` | `0` | CActShowMessage is `PIER_CACT_SHOW_MESSAGE`: sarg: text. `GuiData::displayClientMessage` |
| <span id="CActSetTitle"></span>`CActSetTitle` | `1` | CActSetTitle is `PIER_CACT_SET_TITLE`: sarg: text. `GuiData::setTitle` |
| <span id="CActSetSubtitle"></span>`CActSetSubtitle` | `2` | CActSetSubtitle is `PIER_CACT_SET_SUBTITLE`: sarg: text. `GuiData::setSubtitle` |
| <span id="CActSetActionBar"></span>`CActSetActionBar` | `3` | CActSetActionBar is `PIER_CACT_SET_ACTION_BAR`: sarg: text. `GuiData::setActionBarMessage` |
| <span id="CActShowTip"></span>`CActShowTip` | `4` | CActShowTip is `PIER_CACT_SHOW_TIP`: sarg: text. `GuiData::showTipMessage` |
| <span id="CActPlayUiSound"></span>`CActPlayUiSound` | `5` | CActPlayUiSound is `PIER_CACT_PLAY_UI_SOUND`: sarg: sound name, a: volume, b: pitch. `IClientInstance::playUI` |
| <span id="CActGrabMouse"></span>`CActGrabMouse` | `6` | CActGrabMouse is `PIER_CACT_GRAB_MOUSE`: `IClientInstance::grabMouse` |
| <span id="CActReleaseMouse"></span>`CActReleaseMouse` | `7` | CActReleaseMouse is `PIER_CACT_RELEASE_MOUSE`: `IClientInstance::releaseMouse` |
| <span id="CActSetInputDisabled"></span>`CActSetInputDisabled` | `8` | CActSetInputDisabled is `PIER_CACT_SET_INPUT_DISABLED`: a: non-zero disables game input. `IClientInstance::setDisableInput` |
| <span id="CActLeaveLevel"></span>`CActLeaveLevel` | `9` | CActLeaveLevel is `PIER_CACT_LEAVE_LEVEL`: `IClientInstance::requestLeaveGame`(true, false): leaves the world for the menus, asynchronously |
| <span id="CActShowPopup"></span>`CActShowPopup` | `10` | CActShowPopup is `PIER_CACT_SHOW_POPUP`: sarg: message, or message and subtitle split at the first newline. `GuiData::showPopupNotice` |
| <span id="CActShowDevConsoleMessage"></span>`CActShowDevConsoleMessage` | `11` | CActShowDevConsoleMessage is `PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE`: sarg: text. `GuiData::displayDevConsoleMessage` |
| <span id="CActSetSuspendInput"></span>`CActSetSuspendInput` | `12` | CActSetSuspendInput is `PIER_CACT_SET_SUSPEND_INPUT`: a: non-zero suspends input. `IClientInstance::setSuspendInput` |
| <span id="CActSetSuspendDirectionalInput"></span>`CActSetSuspendDirectionalInput` | `13` | CActSetSuspendDirectionalInput is `PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT`: a: non-zero suspends movement input. `IClientInstance::setSuspendDirectionalInput` |
| <span id="CActSetGameInputEnabled"></span>`CActSetGameInputEnabled` | `14` | CActSetGameInputEnabled is `PIER_CACT_SET_GAME_INPUT_ENABLED`: a: non-zero enables. `IClientInstance::setInGameInputEnabled` |
| <span id="CActRefocusMouse"></span>`CActRefocusMouse` | `15` | CActRefocusMouse is `PIER_CACT_REFOCUS_MOUSE`: a: non-zero when the mouse was lost. `IClientInstance::refocusMouse` |
| <span id="CActMuteAudio"></span>`CActMuteAudio` | `16` | CActMuteAudio is `PIER_CACT_MUTE_AUDIO`: `IClientInstance::muteAudio` |
| <span id="CActUnmuteAudio"></span>`CActUnmuteAudio` | `17` | CActUnmuteAudio is `PIER_CACT_UNMUTE_AUDIO`: `IClientInstance::unMuteAudio` |
| <span id="CActFadeOutMusic"></span>`CActFadeOutMusic` | `18` | CActFadeOutMusic is `PIER_CACT_FADE_OUT_MUSIC`: `IClientInstance::fadeOutMusic` |
| <span id="CActSetGuiScaleOffset"></span>`CActSetGuiScaleOffset` | `19` | CActSetGuiScaleOffset is `PIER_CACT_SET_GUI_SCALE_OFFSET`: a: the offset. `IClientInstance::setGuiScaleOffset` |
| <span id="CActResetPlayerMovement"></span>`CActResetPlayerMovement` | `20` | CActResetPlayerMovement is `PIER_CACT_RESET_PLAYER_MOVEMENT`: `IClientInstance::resetPlayerMovement` |
| <span id="CActPushLeaveGameScreen"></span>`CActPushLeaveGameScreen` | `21` | CActPushLeaveGameScreen is `PIER_CACT_PUSH_LEAVE_GAME_SCREEN`: `IClientInstance::tryPushLeaveGameScreen` |
| <span id="CActOpenContentLogHistory"></span>`CActOpenContentLogHistory` | `22` | CActOpenContentLogHistory is `PIER_CACT_OPEN_CONTENT_LOG_HISTORY`: `IClientInstance::openContentLogHistory` |
| <span id="CActSetClipboard"></span>`CActSetClipboard` | `23` | CActSetClipboard is `PIER_CACT_SET_CLIPBOARD`: sarg: text, empty allowed. `AppPlatform::setClipboard` |
| <span id="CActNavigateHowToPlay"></span>`CActNavigateHowToPlay` | `24` | CActNavigateHowToPlay is `PIER_CACT_NAVIGATE_HOW_TO_PLAY`: sarg: the topic, empty allowed. `IClientInstance::navigateToHowToPlayScreen` |
