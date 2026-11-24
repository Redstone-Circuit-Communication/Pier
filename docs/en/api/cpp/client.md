# Client

??? note "Section notes in abi.h"

    **Capability group: client (client\_\*). All NULL on a server host.**

    Two capability groups follow, client and dimensions. They are unconditionally present in the layout; when the capability package was not built into the host, their slots are NULL (see the file header). New slots still go at the real end of the struct, never inside a capability group.

    Every callback fires on the client thread.

    **Client capability group, continued. NULL on a server host, like client\_\* above;**

    these sit here because a slot only ever goes at the end. Client thread only.

    **Client capability group, options. NULL on a server host. Client thread only. An**

    option is addressed by the key options.txt stores it under, and its value travels in the text form options.txt holds. The engine declares no names for OptionID, so each call walks the ids the registry reports valid.

## Slots {#slots}

### `client_get_local_player` {#client_get_local_player}

```c
bool (*client_get_local_player)(void* ctx, PierStrSink sink);
```

Local player's name via `ll::service::getClientInstance()`-&gt;getLocalPlayer(). sink receives the name, or the call returns false if not in a level.

- Call: `api->client_get_local_player(ctx, sink)`
- Parameters:
    - ctx : `void*`
    - sink : `PierStrSink`
- Return type: `bool`
- Section of abi.h: Capability group: client (client\_\*). All NULL on a server host.
- Position in the table: slot 140, counting from 0
- Callers in each binding:
    - Rust: [`client::local_player_name`](../rust/client.md#fn.local_player_name)
    - Go: [`ClientLocalPlayerName`](../go/client.md#ClientLocalPlayerName), [`Raw.ClientGetLocalPlayer`](../go/raw.md#Raw.ClientGetLocalPlayer)
    - Zig: [`client.localPlayerName`](../zig/client.md#client.localPlayerName)

### `client_is_in_level` {#client_is_in_level}

```c
bool (*client_is_in_level)(void);
```

True when the client is inside a level (a world is loaded).

- Call: `api->client_is_in_level()`
- Return type: `bool`
- Section of abi.h: Capability group: client (client\_\*). All NULL on a server host.
- Position in the table: slot 141, counting from 0
- Callers in each binding:
    - Rust: [`client::is_available`](../rust/client.md#fn.is_available), [`client::is_in_level`](../rust/client.md#fn.is_in_level)
    - Go: [`ClientIsInLevel`](../go/client.md#ClientIsInLevel), [`Raw.ClientIsInLevel`](../go/raw.md#Raw.ClientIsInLevel)
    - Zig: [`client.isInLevel`](../zig/client.md#client.isInLevel)

### `client_get_screen_name` {#client_get_screen_name}

```c
bool (*client_get_screen_name)(void* ctx, PierStrSink sink);
```

Current screen name through `IClientInstance::getScreenName`, such as "`hud_screen`" or "`pause_screen`". Returns false, sinking nothing, before the client has an instance. `PIER_CSTR_TOP_SCREEN_NAME` of `client_get_str` reads the topmost screen of the stack instead.

- Call: `api->client_get_screen_name(ctx, sink)`
- Parameters:
    - ctx : `void*`
    - sink : `PierStrSink`
- Return type: `bool`
- Section of abi.h: Capability group: client (client\_\*). All NULL on a server host.
- Position in the table: slot 142, counting from 0
- Callers in each binding:
    - Rust: [`client::screen_name`](../rust/client.md#fn.screen_name)
    - Go: [`Raw.ClientGetScreenName`](../go/raw.md#Raw.ClientGetScreenName)

### `client_register_key` {#client_register_key}

```c
PierKeyHandle (*client_register_key)(
    PierModHandle mod,
    PierStr name,
    int32_t const* key_codes,
    int32_t key_count,
    bool allow_remap,
    PierKeyCb down_cb,
    PierKeyCb up_cb,
    void* user
);
```

Register a key binding via `ll::input::KeyRegistry::getOrCreateKey`. Returns NULL on failure. The handle is owned by the caller; drop with `client_unregister_key`. `down_cb`/`up_cb` fire on the client thread.

- Call: `api->client_register_key(mod, name, key_codes, key_count, allow_remap, down_cb, up_cb, user)`
- Parameters:
    - mod : `PierModHandle`
    - name : `PierStr`
    - key_codes : `int32_t const*`
    - key_count : `int32_t`
    - allow_remap : `bool`
    - down_cb : `PierKeyCb`
    - up_cb : `PierKeyCb`
    - user : `void*`
- Return type: `PierKeyHandle`
- Section of abi.h: Capability group: client (client\_\*). All NULL on a server host.
- Position in the table: slot 143, counting from 0
- Callers in each binding:
    - Rust: [`client::register_key`](../rust/client.md#fn.register_key)
    - Go: [`RegisterKey`](../go/client.md#RegisterKey)
    - Zig: [`client.registerKey`](../zig/client.md#client.registerKey)

### `client_unregister_key` {#client_unregister_key}

```c
bool (*client_unregister_key)(PierKeyHandle handle);
```

Unregister a key binding: this mod's handler stops firing and the handle is freed. The `ll::input::KeyHandle` itself is not destroyed, since the key registry keeps one key per name and offers no removal; registering the same name again reuses that key.

- Call: `api->client_unregister_key(handle)`
- Parameters:
    - handle : `PierKeyHandle`
- Return type: `bool`
- Section of abi.h: Capability group: client (client\_\*). All NULL on a server host.
- Position in the table: slot 144, counting from 0
- Callers in each binding:
    - Go: [`KeyBinding.Unregister`](../go/client.md#KeyBinding.Unregister), [`Raw.ClientUnregisterKey`](../go/raw.md#Raw.ClientUnregisterKey)
    - Zig: [`client.KeyBinding.unregister`](../zig/client.md#client.KeyBinding.unregister)

### `client_get_key_codes` {#client_get_key_codes}

```c
bool (*client_get_key_codes)(PierKeyHandle handle, void* ctx, PierStrSink sink);
```

Currently assigned key codes (may differ from defaults if remapped). sink receives a JSON-style array string "\[1,2,3\]".

- Call: `api->client_get_key_codes(handle, ctx, sink)`
- Parameters:
    - handle : `PierKeyHandle`
    - ctx : `void*`
    - sink : `PierStrSink`
- Return type: `bool`
- Section of abi.h: Capability group: client (client\_\*). All NULL on a server host.
- Position in the table: slot 145, counting from 0
- Callers in each binding:
    - Rust: [`KeyBinding::key_codes`](../rust/client.md#KeyBinding.key_codes)
    - Go: [`KeyBinding.KeyCodes`](../go/client.md#KeyBinding.KeyCodes), [`Raw.ClientGetKeyCodes`](../go/raw.md#Raw.ClientGetKeyCodes)
    - Zig: [`client.KeyBinding.keyCodes`](../zig/client.md#client.KeyBinding.keyCodes)

### `client_get_num` {#client_get_num}

```c
bool (*client_get_num)(int32_t prop, double* out);
```

Reads one PIER\_CPROP\_\* value into \*out. Returns false, leaving \*out alone, for an unknown key, a null `out`, a client that has no instance yet, or a key about the local player while the client is not in a world. A flag reads 1 or 0.

- Call: `api->client_get_num(prop, out)`
- Parameters:
    - prop : `int32_t`
    - out : `double*`
- Return type: `bool`
- Section of abi.h: Client capability group, continued. NULL on a server host, like client\_\* above;
- Position in the table: slot 202, counting from 0
- Callers in each binding:
    - Rust: [`client::property`](../rust/client.md#fn.property), [`client::local_position`](../rust/client.md#fn.local_position), [`client::local_rotation`](../rust/client.md#fn.local_rotation), [`client::local_dimension`](../rust/client.md#fn.local_dimension), [`client::gui_scale`](../rust/client.md#fn.gui_scale), [`client::server_ping_ms`](../rust/client.md#fn.server_ping_ms) and more, 80 in all
    - Go: [`ClientPosX`](../go/client.md#ClientPosX), [`ClientPosY`](../go/client.md#ClientPosY), [`ClientPosZ`](../go/client.md#ClientPosZ), [`ClientPitch`](../go/client.md#ClientPitch), [`ClientYaw`](../go/client.md#ClientYaw), [`ClientDimension`](../go/client.md#ClientDimension) and more, 70 in all
    - Zig: [`client.property`](../zig/client.md#client.property), [`client.localPosition`](../zig/client.md#client.localPosition), [`client.localRotation`](../zig/client.md#client.localRotation), [`client.localDimension`](../zig/client.md#client.localDimension), [`client.guiScale`](../zig/client.md#client.guiScale), [`client.serverPingMs`](../zig/client.md#client.serverPingMs) and more, 67 in all

### `client_get_str` {#client_get_str}

```c
bool (*client_get_str)(int32_t prop, void* ctx, PierStrSink sink);
```

Reads one PIER\_CSTR\_\* value through `sink`, called once. Returns false, sinking nothing, for an unknown key, a null sink, or a client that has no instance yet.

- Call: `api->client_get_str(prop, ctx, sink)`
- Parameters:
    - prop : `int32_t`
    - ctx : `void*`
    - sink : `PierStrSink`
- Return type: `bool`
- Section of abi.h: Client capability group, continued. NULL on a server host, like client\_\* above;
- Position in the table: slot 203, counting from 0
- Callers in each binding:
    - Rust: [`client::top_screen_name`](../rust/client.md#fn.top_screen_name), [`Client::screen_name`](../rust/client.md#Client.screen_name), [`Client::top_screen_name`](../rust/client.md#Client.top_screen_name), [`Client::platform_id`](../rust/client.md#Client.platform_id), [`Client::platform_online_id`](../rust/client.md#Client.platform_online_id), [`Client::local_xuid`](../rust/client.md#Client.local_xuid) and more, 9 in all
    - Go: [`ClientScreenName`](../go/client.md#ClientScreenName), [`ClientTopScreenName`](../go/client.md#ClientTopScreenName), [`ClientPlatformId`](../go/client.md#ClientPlatformId), [`ClientPlatformOnlineId`](../go/client.md#ClientPlatformOnlineId), [`ClientLocalXuid`](../go/client.md#ClientLocalXuid), [`ClientLocalUuid`](../go/client.md#ClientLocalUuid) and more, 9 in all
    - Zig: [`client.topScreenName`](../zig/client.md#client.topScreenName), [`client.platformId`](../zig/client.md#client.platformId), [`client.platformOnlineId`](../zig/client.md#client.platformOnlineId), [`client.localXuid`](../zig/client.md#client.localXuid), [`client.localUuid`](../zig/client.md#client.localUuid), [`client.localNameTag`](../zig/client.md#client.localNameTag) and more, 7 in all

### `client_action` {#client_action}

```c
bool (*client_action)(int32_t action, PierStr sarg, double a, double b, double c);
```

Performs one PIER\_CACT\_\* verb on this client. Returns false for an unknown verb, a text verb given empty text, or a client that has no instance yet. The text verbs need the HUD, which exists once a world is loaded, and return false before that. True means the call reached the engine, which reports nothing back.

- Call: `api->client_action(action, sarg, a, b, c)`
- Parameters:
    - action : `int32_t`
    - sarg : `PierStr`
    - a : `double`
    - b : `double`
    - c : `double`
- Return type: `bool`
- Section of abi.h: Client capability group, continued. NULL on a server host, like client\_\* above;
- Position in the table: slot 204, counting from 0
- Callers in each binding:
    - Rust: [`client::show_message`](../rust/client.md#fn.show_message), [`client::set_title`](../rust/client.md#fn.set_title), [`client::set_subtitle`](../rust/client.md#fn.set_subtitle), [`client::set_action_bar`](../rust/client.md#fn.set_action_bar), [`client::show_tip`](../rust/client.md#fn.show_tip), [`client::play_ui_sound`](../rust/client.md#fn.play_ui_sound) and more, 25 in all
    - Go: [`ClientShowMessage`](../go/client.md#ClientShowMessage), [`ClientSetTitle`](../go/client.md#ClientSetTitle), [`ClientSetSubtitle`](../go/client.md#ClientSetSubtitle), [`ClientSetActionBar`](../go/client.md#ClientSetActionBar), [`ClientShowTip`](../go/client.md#ClientShowTip), [`ClientPlayUiSound`](../go/client.md#ClientPlayUiSound) and more, 26 in all
    - Zig: [`client.showMessage`](../zig/client.md#client.showMessage), [`client.setTitle`](../zig/client.md#client.setTitle), [`client.setSubtitle`](../zig/client.md#client.setSubtitle), [`client.setActionBar`](../zig/client.md#client.setActionBar), [`client.showTip`](../zig/client.md#client.showTip), [`client.playUiSound`](../zig/client.md#client.playUiSound) and more, 25 in all

### `client_list_keys` {#client_list_keys}

```c
bool (*client_list_keys)(void* ctx, PierStrSink sink);
```

Feeds the name of every binding `ll::input::KeyRegistry` holds to `sink`, one call each, whichever mod registered it. Returns false only for a null sink.

- Call: `api->client_list_keys(ctx, sink)`
- Parameters:
    - ctx : `void*`
    - sink : `PierStrSink`
- Return type: `bool`
- Section of abi.h: Client capability group, continued. NULL on a server host, like client\_\* above;
- Position in the table: slot 205, counting from 0
- Callers in each binding:
    - Rust: [`client::registered_keys`](../rust/client.md#fn.registered_keys), [`client::has_key`](../rust/client.md#fn.has_key)
    - Go: [`Raw.ClientListKeys`](../go/raw.md#Raw.ClientListKeys)
    - Zig: [`client.registeredKeys`](../zig/client.md#client.registeredKeys)

### `client_option_list` {#client_option_list}

```c
bool (*client_option_list)(void* ctx, PierKvSink sink);
```

Feeds every option to `sink`, one (key, value) pair each, as `Option::save` writes them. An option that stores several keys, such as one value per input mode, feeds each. Returns false for a null sink or a client that has no instance yet.

- Call: `api->client_option_list(ctx, sink)`
- Parameters:
    - ctx : `void*`
    - sink : `PierKvSink`
- Return type: `bool`
- Section of abi.h: Client capability group, options. NULL on a server host. Client thread only. An
- Position in the table: slot 217, counting from 0
- Callers in each binding:
    - Rust: [`client::options`](../rust/client.md#fn.options)
    - Go: [`ClientOptions`](../go/client.md#ClientOptions)
    - Zig: [`client.options`](../zig/client.md#client.options)

### `client_option_get` {#client_option_get}

```c
bool (*client_option_get)(PierStr key, void* ctx, PierStrSink sink);
```

Reads one option by its options.txt key through `sink`, called once. Returns false, sinking nothing, for an unknown key, a null sink, or a client that has no instance yet.

- Call: `api->client_option_get(key, ctx, sink)`
- Parameters:
    - key : `PierStr`
    - ctx : `void*`
    - sink : `PierStrSink`
- Return type: `bool`
- Section of abi.h: Client capability group, options. NULL on a server host. Client thread only. An
- Position in the table: slot 218, counting from 0
- Callers in each binding:
    - Rust: [`client::option`](../rust/client.md#fn.option)
    - Go: [`Raw.ClientOptionGet`](../go/raw.md#Raw.ClientOptionGet)
    - Zig: [`client.option`](../zig/client.md#client.option)

### `client_option_set` {#client_option_set}

```c
bool (*client_option_set)(PierStr key, PierStr value);
```

Writes the option that stores `key`, passing `value` to `Option::load`, the parser options.txt is read with. Returns false for an unknown key, an option the engine marks as not modifiable now, or a client that has no instance yet. The engine keeps what it can parse and reports nothing, so a caller that needs to know reads the key back. The host does not write options.txt itself.

- Call: `api->client_option_set(key, value)`
- Parameters:
    - key : `PierStr`
    - value : `PierStr`
- Return type: `bool`
- Section of abi.h: Client capability group, options. NULL on a server host. Client thread only. An
- Position in the table: slot 219, counting from 0
- Callers in each binding:
    - Rust: [`client::set_option`](../rust/client.md#fn.set_option)
    - Go: [`Raw.ClientOptionSet`](../go/raw.md#Raw.ClientOptionSet)
    - Zig: [`client.setOption`](../zig/client.md#client.setOption)

## Types {#types}

### `PierKeyHandle` {#PierKeyHandle}

```c
typedef void* PierKeyHandle;
```

Opaque handle to a registered key binding owned by the loader's `ll::input::KeyRegistry`. Drop via `client_unregister_key`.

### `PierKeyAction` {#PierKeyAction}

```c
typedef int32_t PierKeyAction;
```

Key action: 0 = released (up), 1 = pressed (down). Mirrors `ll::event::KeyInputEvent::Action`.

### `PierFocusImpact` {#PierFocusImpact}

```c
typedef int32_t PierFocusImpact;
```

Focus impact level: 0=Neutral 1=ActivateFocus 2=DeactivateFocus. Mirrors ::FocusImpact.

### `PierKeyCb` {#PierKeyCb}

```c
typedef void (*PierKeyCb)(void* user, PierKeyAction action, PierFocusImpact impact);
```

Callback for key press/release events. Runs on the client thread. user   — pointer passed to `client_register_key` action — 0=released 1=pressed (see PierKeyAction) impact — current focus impact (see PierFocusImpact)

## `PierClientNumProp` {#PierClientNumProp}

`client_get_num` keys. Each value is read from this client's own state, so on a remote server it describes what this client sees. APPEND-ONLY, like every key enumeration in this file; an unknown key makes the call return false. Keys 0 to 5 and 13 to 27 read the local player and fail while the client is not in a world.

| Name | Value | Description |
|---|---|---|
| <span id="PIER_CPROP_POS_X"></span>`PIER_CPROP_POS_X` | `0` | `Actor::getFeetPos` of the local player |
| <span id="PIER_CPROP_POS_Y"></span>`PIER_CPROP_POS_Y` | `1` | feet height, the same point `get_player_position` reports |
| <span id="PIER_CPROP_POS_Z"></span>`PIER_CPROP_POS_Z` | `2` |  |
| <span id="PIER_CPROP_PITCH"></span>`PIER_CPROP_PITCH` | `3` | `Actor::getRotation`, degrees; negative looks up |
| <span id="PIER_CPROP_YAW"></span>`PIER_CPROP_YAW` | `4` | `Actor::getRotation`, degrees |
| <span id="PIER_CPROP_DIMENSION"></span>`PIER_CPROP_DIMENSION` | `5` | `Actor::getDimensionId` of the local player |
| <span id="PIER_CPROP_GUI_SCALE"></span>`PIER_CPROP_GUI_SCALE` | `6` | `IClientInstance::getGuiScale` |
| <span id="PIER_CPROP_SERVER_PING_MS"></span>`PIER_CPROP_SERVER_PING_MS` | `7` | `IClientInstance::getServerPingTime` |
| <span id="PIER_CPROP_IS_SHOWING_MENU"></span>`PIER_CPROP_IS_SHOWING_MENU` | `8` | `IClientInstance::isShowingMenu`, 1 or 0 |
| <span id="PIER_CPROP_IS_SHOWING_PAUSE_SCREEN"></span>`PIER_CPROP_IS_SHOWING_PAUSE_SCREEN` | `9` | `IClientInstance::isShowingPauseScreen` |
| <span id="PIER_CPROP_IS_PLAYING"></span>`PIER_CPROP_IS_PLAYING` | `10` | `IClientInstance::isPlaying` |
| <span id="PIER_CPROP_IS_IN_REALM"></span>`PIER_CPROP_IS_IN_REALM` | `11` | `IClientInstance::isInRealm` |
| <span id="PIER_CPROP_IS_GAME_INPUT_ENABLED"></span>`PIER_CPROP_IS_GAME_INPUT_ENABLED` | `12` | `IClientInstance::isInGameInputEnabled` |
| <span id="PIER_CPROP_HEALTH"></span>`PIER_CPROP_HEALTH` | `13` | `Actor::getHealth` of the local player |
| <span id="PIER_CPROP_MAX_HEALTH"></span>`PIER_CPROP_MAX_HEALTH` | `14` | `Actor::getMaxHealth` of the local player |
| <span id="PIER_CPROP_IS_ON_GROUND"></span>`PIER_CPROP_IS_ON_GROUND` | `15` | `Actor::isOnGround` of the local player |
| <span id="PIER_CPROP_IS_IN_WATER"></span>`PIER_CPROP_IS_IN_WATER` | `16` | `Actor::isInWater` of the local player |
| <span id="PIER_CPROP_IS_SNEAKING"></span>`PIER_CPROP_IS_SNEAKING` | `17` | `Actor::isSneaking` of the local player |
| <span id="PIER_CPROP_IS_SPRINTING"></span>`PIER_CPROP_IS_SPRINTING` | `18` | `Actor::isSprinting` of the local player |
| <span id="PIER_CPROP_IS_SWIMMING"></span>`PIER_CPROP_IS_SWIMMING` | `19` | `Actor::isSwimming` of the local player |
| <span id="PIER_CPROP_IS_ON_FIRE"></span>`PIER_CPROP_IS_ON_FIRE` | `20` | `Actor::isOnFire` of the local player |
| <span id="PIER_CPROP_IS_FLYING"></span>`PIER_CPROP_IS_FLYING` | `21` | `Player::isFlying` of the local player |
| <span id="PIER_CPROP_GAME_TYPE"></span>`PIER_CPROP_GAME_TYPE` | `22` | `Player::getPlayerGameType` of the local player |
| <span id="PIER_CPROP_SELECTED_SLOT"></span>`PIER_CPROP_SELECTED_SLOT` | `23` | `Player::getSelectedItemSlot` of the local player |
| <span id="PIER_CPROP_VEL_X"></span>`PIER_CPROP_VEL_X` | `24` | `Actor::getPosDelta` of the local player, blocks per tick |
| <span id="PIER_CPROP_VEL_Y"></span>`PIER_CPROP_VEL_Y` | `25` | `Actor::getPosDelta`, the vertical part |
| <span id="PIER_CPROP_VEL_Z"></span>`PIER_CPROP_VEL_Z` | `26` | `Actor::getPosDelta`, the z part |
| <span id="PIER_CPROP_XP_NEEDED_NEXT_LEVEL"></span>`PIER_CPROP_XP_NEEDED_NEXT_LEVEL` | `27` | `Player::getXpNeededForNextLevel` of the local player |
| <span id="PIER_CPROP_IS_LEAVING_GAME"></span>`PIER_CPROP_IS_LEAVING_GAME` | `28` | `IClientInstance::isLeavingGame` |
| <span id="PIER_CPROP_IS_EXITING_LEVEL"></span>`PIER_CPROP_IS_EXITING_LEVEL` | `29` | `IClientInstance::isExitingLevel` |
| <span id="PIER_CPROP_IS_IN_BED_SCREEN"></span>`PIER_CPROP_IS_IN_BED_SCREEN` | `30` | `IClientInstance::isInBedScreen` |
| <span id="PIER_CPROP_IS_IN_DEATH_SCREEN"></span>`PIER_CPROP_IS_IN_DEATH_SCREEN` | `31` | `IClientInstance::isInDeathScreen` |
| <span id="PIER_CPROP_IS_SHOWING_LOADING_SCREEN"></span>`PIER_CPROP_IS_SHOWING_LOADING_SCREEN` | `32` | `IClientInstance::isShowingLoadingScreen` |
| <span id="PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN"></span>`PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN` | `33` | `IClientInstance::isShowingProgressScreen` |
| <span id="PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN"></span>`PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN` | `34` | `IClientInstance::isShowingWorldProgressScreen` |
| <span id="PIER_CPROP_IS_SHOWING_DEATH_SCREEN"></span>`PIER_CPROP_IS_SHOWING_DEATH_SCREEN` | `35` | `IClientInstance::isShowingDeathScreen` |
| <span id="PIER_CPROP_IS_SHOWING_SERVER_FORM"></span>`PIER_CPROP_IS_SHOWING_SERVER_FORM` | `36` | `IClientInstance::isShowingServerForm` |
| <span id="PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU"></span>`PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU` | `37` | `IClientInstance::isInWorldAndNotShowingAnyMenuScreens` |
| <span id="PIER_CPROP_IS_WORLD_ACTIVE"></span>`PIER_CPROP_IS_WORLD_ACTIVE` | `38` | `IClientInstance::isWorldActive` |
| <span id="PIER_CPROP_HAS_LEVEL"></span>`PIER_CPROP_HAS_LEVEL` | `39` | `IClientInstance::hasLevel` |
| <span id="PIER_CPROP_IS_PRE_GAME"></span>`PIER_CPROP_IS_PRE_GAME` | `40` | `IClientInstance::isPreGame` |
| <span id="PIER_CPROP_IS_IN_MULTIPLAYER_GAME"></span>`PIER_CPROP_IS_IN_MULTIPLAYER_GAME` | `41` | `IClientInstance::isInMultiplayerGame` |
| <span id="PIER_CPROP_IS_MULTIPLAYER_CLIENT"></span>`PIER_CPROP_IS_MULTIPLAYER_CLIENT` | `42` | `IClientInstance::isMultiPlayerClient` |
| <span id="PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER"></span>`PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER` | `43` | `IClientInstance::isPrimaryLevelMultiplayer` |
| <span id="PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM"></span>`PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM` | `44` | `IClientInstance::isPrimaryLevelCrossPlatformMultiplayer` |
| <span id="PIER_CPROP_IS_KEYBOARD_ENABLED"></span>`PIER_CPROP_IS_KEYBOARD_ENABLED` | `45` | `IClientInstance::isKeyboardEnabled` |
| <span id="PIER_CPROP_IS_USING_CONTROLLER"></span>`PIER_CPROP_IS_USING_CONTROLLER` | `46` | `IClientInstance::useController` |
| <span id="PIER_CPROP_IS_USING_TOUCHSCREEN"></span>`PIER_CPROP_IS_USING_TOUCHSCREEN` | `47` | `IClientInstance::useTouchscreen` |
| <span id="PIER_CPROP_IS_MOUSE_GRABBED"></span>`PIER_CPROP_IS_MOUSE_GRABBED` | `48` | `IClientInstance::getMouseGrabbed` |
| <span id="PIER_CPROP_IS_MOUSE_AND_KEYBOARD"></span>`PIER_CPROP_IS_MOUSE_AND_KEYBOARD` | `49` | `IClientInstance::currentInputModeIsMouseAndKeyboard` |
| <span id="PIER_CPROP_HAS_CONNECTED_CONTROLLER"></span>`PIER_CPROP_HAS_CONNECTED_CONTROLLER` | `50` | `IClientInstance::hasConnectedController` |
| <span id="PIER_CPROP_CONTROLLER_ID"></span>`PIER_CPROP_CONTROLLER_ID` | `51` | `IClientInstance::getControllerId` |
| <span id="PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED"></span>`PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED` | `52` | `IClientInstance::isTouchGameplayAllowed` |
| <span id="PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE"></span>`PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE` | `53` | `IClientInstance::isSplitScreenActive` |
| <span id="PIER_CPROP_SPLIT_SCREEN_COUNT"></span>`PIER_CPROP_SPLIT_SCREEN_COUNT` | `54` | `IClientInstance::getSplitScreenCount` |
| <span id="PIER_CPROP_GUI_SCALE_OFFSET"></span>`PIER_CPROP_GUI_SCALE_OFFSET` | `55` | `IClientInstance::getGuiScaleOffset` |
| <span id="PIER_CPROP_IS_EDU_MODE"></span>`PIER_CPROP_IS_EDU_MODE` | `56` | `IClientInstance::isEduMode` |
| <span id="PIER_CPROP_IS_IN_EDITOR"></span>`PIER_CPROP_IS_IN_EDITOR` | `57` | `IClientInstance::isPlayerInEditor` |
| <span id="PIER_CPROP_IS_READY_TO_RENDER"></span>`PIER_CPROP_IS_READY_TO_RENDER` | `58` | `IClientInstance::isReadyToRender` |
| <span id="PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK"></span>`PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK` | `59` | `IClientInstance::isFullVanillaPackOnStack` |
| <span id="PIER_CPROP_SERVER_CONNECTION_TIME"></span>`PIER_CPROP_SERVER_CONNECTION_TIME` | `60` | `IClientInstance::getServerConnectionTime` |
| <span id="PIER_CPROP_REMOTE_SERVER_TIME_MS"></span>`PIER_CPROP_REMOTE_SERVER_TIME_MS` | `61` | `IClientInstance::getRemoteServerTimeMs` |
| <span id="PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS"></span>`PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS` | `62` | `IClientInstance::getRemoteServerNetworkTimeMs` |
| <span id="PIER_CPROP_FRAME_ALPHA"></span>`PIER_CPROP_FRAME_ALPHA` | `63` | `IClientInstance::getFrameAlpha`, how far the frame is between two ticks |
| <span id="PIER_CPROP_GAME_UPDATE_SECONDS"></span>`PIER_CPROP_GAME_UPDATE_SECONDS` | `64` | `IClientInstance::getGameUpdateDurationInSeconds` |
| <span id="PIER_CPROP_IS_PRIMARY_CLIENT"></span>`PIER_CPROP_IS_PRIMARY_CLIENT` | `65` | `IClientInstance::isPrimaryClient` |
| <span id="PIER_CPROP_USER_ID"></span>`PIER_CPROP_USER_ID` | `66` | `IClientInstance::getUserId` |
| <span id="PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED"></span>`PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED` | `67` | `IClientInstance::isGamePlayTipsEnabled` |
| <span id="PIER_CPROP_HAS_COMMANDS"></span>`PIER_CPROP_HAS_COMMANDS` | `68` | `IClientInstance::hasCommands` |

## `PierClientStrProp` {#PierClientStrProp}

`client_get_str` keys.

| Name | Value | Description |
|---|---|---|
| <span id="PIER_CSTR_SCREEN_NAME"></span>`PIER_CSTR_SCREEN_NAME` | `0` | `IClientInstance::getScreenName`, as `client_get_screen_name` |
| <span id="PIER_CSTR_TOP_SCREEN_NAME"></span>`PIER_CSTR_TOP_SCREEN_NAME` | `1` | `IClientInstance::getTopScreenName` |
| <span id="PIER_CSTR_PLATFORM_ID"></span>`PIER_CSTR_PLATFORM_ID` | `2` | `IClientInstance::getPlatformId` |
| <span id="PIER_CSTR_PLATFORM_ONLINE_ID"></span>`PIER_CSTR_PLATFORM_ONLINE_ID` | `3` | `IClientInstance::getPlatformOnlineId` |
| <span id="PIER_CSTR_LOCAL_XUID"></span>`PIER_CSTR_LOCAL_XUID` | `4` | `Player::getXuid` of the local player; fails outside a world |
| <span id="PIER_CSTR_LOCAL_UUID"></span>`PIER_CSTR_LOCAL_UUID` | `5` | `Player::getUuid` of the local player in its canonical form |
| <span id="PIER_CSTR_LOCAL_NAME_TAG"></span>`PIER_CSTR_LOCAL_NAME_TAG` | `6` | `Actor::getNameTag` of the local player |
| <span id="PIER_CSTR_CLIPBOARD"></span>`PIER_CSTR_CLIPBOARD` | `7` | `AppPlatform::getClipboardText`, the system clipboard |

## `PierClientAction` {#PierClientAction}

`client_action` verbs. Args are (sarg, a, b, c); unused args are ignored. The text verbs write to this client's HUD only and send nothing to a server.

| Name | Value | Description |
|---|---|---|
| <span id="PIER_CACT_SHOW_MESSAGE"></span>`PIER_CACT_SHOW_MESSAGE` | `0` | sarg: text. `GuiData::displayClientMessage` |
| <span id="PIER_CACT_SET_TITLE"></span>`PIER_CACT_SET_TITLE` | `1` | sarg: text. `GuiData::setTitle` |
| <span id="PIER_CACT_SET_SUBTITLE"></span>`PIER_CACT_SET_SUBTITLE` | `2` | sarg: text. `GuiData::setSubtitle` |
| <span id="PIER_CACT_SET_ACTION_BAR"></span>`PIER_CACT_SET_ACTION_BAR` | `3` | sarg: text. `GuiData::setActionBarMessage` |
| <span id="PIER_CACT_SHOW_TIP"></span>`PIER_CACT_SHOW_TIP` | `4` | sarg: text. `GuiData::showTipMessage` |
| <span id="PIER_CACT_PLAY_UI_SOUND"></span>`PIER_CACT_PLAY_UI_SOUND` | `5` | sarg: sound name, a: volume, b: pitch. `IClientInstance::playUI` |
| <span id="PIER_CACT_GRAB_MOUSE"></span>`PIER_CACT_GRAB_MOUSE` | `6` | `IClientInstance::grabMouse` |
| <span id="PIER_CACT_RELEASE_MOUSE"></span>`PIER_CACT_RELEASE_MOUSE` | `7` | `IClientInstance::releaseMouse` |
| <span id="PIER_CACT_SET_INPUT_DISABLED"></span>`PIER_CACT_SET_INPUT_DISABLED` | `8` | a: non-zero disables game input. `IClientInstance::setDisableInput` |
| <span id="PIER_CACT_LEAVE_LEVEL"></span>`PIER_CACT_LEAVE_LEVEL` | `9` | `IClientInstance::requestLeaveGame`(true, false): leaves the world for the menus, asynchronously |
| <span id="PIER_CACT_SHOW_POPUP"></span>`PIER_CACT_SHOW_POPUP` | `10` | sarg: message, or message and subtitle split at the first newline. `GuiData::showPopupNotice` |
| <span id="PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE"></span>`PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE` | `11` | sarg: text. `GuiData::displayDevConsoleMessage` |
| <span id="PIER_CACT_SET_SUSPEND_INPUT"></span>`PIER_CACT_SET_SUSPEND_INPUT` | `12` | a: non-zero suspends input. `IClientInstance::setSuspendInput` |
| <span id="PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT"></span>`PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT` | `13` | a: non-zero suspends movement input. `IClientInstance::setSuspendDirectionalInput` |
| <span id="PIER_CACT_SET_GAME_INPUT_ENABLED"></span>`PIER_CACT_SET_GAME_INPUT_ENABLED` | `14` | a: non-zero enables. `IClientInstance::setInGameInputEnabled` |
| <span id="PIER_CACT_REFOCUS_MOUSE"></span>`PIER_CACT_REFOCUS_MOUSE` | `15` | a: non-zero when the mouse was lost. `IClientInstance::refocusMouse` |
| <span id="PIER_CACT_MUTE_AUDIO"></span>`PIER_CACT_MUTE_AUDIO` | `16` | `IClientInstance::muteAudio` |
| <span id="PIER_CACT_UNMUTE_AUDIO"></span>`PIER_CACT_UNMUTE_AUDIO` | `17` | `IClientInstance::unMuteAudio` |
| <span id="PIER_CACT_FADE_OUT_MUSIC"></span>`PIER_CACT_FADE_OUT_MUSIC` | `18` | `IClientInstance::fadeOutMusic` |
| <span id="PIER_CACT_SET_GUI_SCALE_OFFSET"></span>`PIER_CACT_SET_GUI_SCALE_OFFSET` | `19` | a: the offset. `IClientInstance::setGuiScaleOffset` |
| <span id="PIER_CACT_RESET_PLAYER_MOVEMENT"></span>`PIER_CACT_RESET_PLAYER_MOVEMENT` | `20` | `IClientInstance::resetPlayerMovement` |
| <span id="PIER_CACT_PUSH_LEAVE_GAME_SCREEN"></span>`PIER_CACT_PUSH_LEAVE_GAME_SCREEN` | `21` | `IClientInstance::tryPushLeaveGameScreen` |
| <span id="PIER_CACT_OPEN_CONTENT_LOG_HISTORY"></span>`PIER_CACT_OPEN_CONTENT_LOG_HISTORY` | `22` | `IClientInstance::openContentLogHistory` |
| <span id="PIER_CACT_SET_CLIPBOARD"></span>`PIER_CACT_SET_CLIPBOARD` | `23` | sarg: text, empty allowed. `AppPlatform::setClipboard` |
| <span id="PIER_CACT_NAVIGATE_HOW_TO_PLAY"></span>`PIER_CACT_NAVIGATE_HOW_TO_PLAY` | `24` | sarg: the topic, empty allowed. `IClientInstance::navigateToHowToPlayScreen` |
