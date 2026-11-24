# 客户端

??? note "abi.h 里的分节说明"

    **能力组：客户端（`client_*`）。在服务器宿主上全部为 NULL（`Capability group: client (client_*). All NULL on a server host.`）**

    后面是两个能力组：客户端和维度。它们在布局里无条件存在；宿主没有编入对应的能力包时，它们的槽位为 NULL（见文件头）。新槽位仍然加在结构体真正的末尾，永远不加在能力组中间。

    所有回调都在客户端线程上触发。

    **客户端能力组（续）。和上面的 client_* 一样，在服务端宿主上为 NULL；（`Client capability group, continued. NULL on a server host, like client_* above;`）**

    放在这里是因为槽位只会追加在末尾。只能在客户端线程调用。

    **客户端能力组：选项。在服务端宿主上为 NULL，只能在客户端线程调用。（`Client capability group, options. NULL on a server host. Client thread only. An`）**

    选项用 options.txt 保存它时所用的键来指定，值以 options.txt 中的文本形式传递。引擎没有为 OptionID 声明任何名字，所以每次调用都会遍历注册表报告为有效的那些 id。

## 槽位 {#slots}

### `client_get_local_player` {#client_get_local_player}

```c
bool (*client_get_local_player)(void* ctx, PierStrSink sink);
```

通过 `ll::service::getClientInstance()->getLocalPlayer()` 取本地玩家的名字。输出回调收到名字；不在世界里时调用返回 false。

- 调用形式：`api->client_get_local_player(ctx, sink)`
- 参数：
    - ctx : `void*`
    - sink : `PierStrSink`
- 返回值类型：`bool`
- 所在分节：能力组：客户端（`client_*`）。在服务器宿主上全部为 NULL（`Capability group: client (client_*). All NULL on a server host.`）
- 表内序号：第 140 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::local_player_name`](../rust/client.md#fn.local_player_name)
    - Go：[`ClientLocalPlayerName`](../go/client.md#ClientLocalPlayerName)、[`Raw.ClientGetLocalPlayer`](../go/raw.md#Raw.ClientGetLocalPlayer)
    - Zig：[`client.localPlayerName`](../zig/client.md#client.localPlayerName)

### `client_is_in_level` {#client_is_in_level}

```c
bool (*client_is_in_level)(void);
```

客户端在世界里（已经加载了一个世界）时为 true。

- 调用形式：`api->client_is_in_level()`
- 返回值类型：`bool`
- 所在分节：能力组：客户端（`client_*`）。在服务器宿主上全部为 NULL（`Capability group: client (client_*). All NULL on a server host.`）
- 表内序号：第 141 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::is_available`](../rust/client.md#fn.is_available)、[`client::is_in_level`](../rust/client.md#fn.is_in_level)
    - Go：[`ClientIsInLevel`](../go/client.md#ClientIsInLevel)、[`Raw.ClientIsInLevel`](../go/raw.md#Raw.ClientIsInLevel)
    - Zig：[`client.isInLevel`](../zig/client.md#client.isInLevel)

### `client_get_screen_name` {#client_get_screen_name}

```c
bool (*client_get_screen_name)(void* ctx, PierStrSink sink);
```

通过 IClientInstance::getScreenName 读取当前界面名，例如 "hud_screen" 或 "pause_screen"。客户端还没有实例时返回 false，sink 不会被调用。client_get_str 的 PIER_CSTR_TOP_SCREEN_NAME 读取的则是界面栈最顶层的界面。

- 调用形式：`api->client_get_screen_name(ctx, sink)`
- 参数：
    - ctx : `void*`
    - sink : `PierStrSink`
- 返回值类型：`bool`
- 所在分节：能力组：客户端（`client_*`）。在服务器宿主上全部为 NULL（`Capability group: client (client_*). All NULL on a server host.`）
- 表内序号：第 142 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::screen_name`](../rust/client.md#fn.screen_name)
    - Go：[`Raw.ClientGetScreenName`](../go/raw.md#Raw.ClientGetScreenName)

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

通过 `ll::input::KeyRegistry::getOrCreateKey` 注册一个按键绑定。失败时返回 NULL。句柄归调用方所有，用 `client_unregister_key` 释放。`down_cb`/`up_cb` 在客户端线程上触发。

- 调用形式：`api->client_register_key(mod, name, key_codes, key_count, allow_remap, down_cb, up_cb, user)`
- 参数：
    - mod : `PierModHandle`
    - name : `PierStr`
    - key_codes : `int32_t const*`
    - key_count : `int32_t`
    - allow_remap : `bool`
    - down_cb : `PierKeyCb`
    - up_cb : `PierKeyCb`
    - user : `void*`
- 返回值类型：`PierKeyHandle`
- 所在分节：能力组：客户端（`client_*`）。在服务器宿主上全部为 NULL（`Capability group: client (client_*). All NULL on a server host.`）
- 表内序号：第 143 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::register_key`](../rust/client.md#fn.register_key)
    - Go：[`RegisterKey`](../go/client.md#RegisterKey)
    - Zig：[`client.registerKey`](../zig/client.md#client.registerKey)

### `client_unregister_key` {#client_unregister_key}

```c
bool (*client_unregister_key)(PierKeyHandle handle);
```

取消一个按键绑定：这个模组的处理函数不再触发，句柄被释放。`ll::input::KeyHandle` 本身不会被销毁，因为按键注册表每个名字只保留一个按键，也没有提供删除的办法；用同一个名字再注册时会复用那个按键。

- 调用形式：`api->client_unregister_key(handle)`
- 参数：
    - handle : `PierKeyHandle`
- 返回值类型：`bool`
- 所在分节：能力组：客户端（`client_*`）。在服务器宿主上全部为 NULL（`Capability group: client (client_*). All NULL on a server host.`）
- 表内序号：第 144 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Go：[`KeyBinding.Unregister`](../go/client.md#KeyBinding.Unregister)、[`Raw.ClientUnregisterKey`](../go/raw.md#Raw.ClientUnregisterKey)
    - Zig：[`client.KeyBinding.unregister`](../zig/client.md#client.KeyBinding.unregister)

### `client_get_key_codes` {#client_get_key_codes}

```c
bool (*client_get_key_codes)(PierKeyHandle handle, void* ctx, PierStrSink sink);
```

当前分配的按键码（被玩家重新映射过时可能和默认值不同）。输出回调收到一个 JSON 风格的数组字符串 `"[1,2,3]"`。

- 调用形式：`api->client_get_key_codes(handle, ctx, sink)`
- 参数：
    - handle : `PierKeyHandle`
    - ctx : `void*`
    - sink : `PierStrSink`
- 返回值类型：`bool`
- 所在分节：能力组：客户端（`client_*`）。在服务器宿主上全部为 NULL（`Capability group: client (client_*). All NULL on a server host.`）
- 表内序号：第 145 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`KeyBinding::key_codes`](../rust/client.md#KeyBinding.key_codes)
    - Go：[`KeyBinding.KeyCodes`](../go/client.md#KeyBinding.KeyCodes)、[`Raw.ClientGetKeyCodes`](../go/raw.md#Raw.ClientGetKeyCodes)
    - Zig：[`client.KeyBinding.keyCodes`](../zig/client.md#client.KeyBinding.keyCodes)

### `client_get_num` {#client_get_num}

```c
bool (*client_get_num)(int32_t prop, double* out);
```

把一个 PIER_CPROP_* 值读入 *out。键未知、`out` 为空、客户端还没有实例、或者客户端不在世界里时读取关于本地玩家的键，都返回 false，*out 保持不变。布尔类的值读出 1 或 0。

- 调用形式：`api->client_get_num(prop, out)`
- 参数：
    - prop : `int32_t`
    - out : `double*`
- 返回值类型：`bool`
- 所在分节：客户端能力组（续）。和上面的 client_* 一样，在服务端宿主上为 NULL；（`Client capability group, continued. NULL on a server host, like client_* above;`）
- 表内序号：第 202 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::property`](../rust/client.md#fn.property)、[`client::local_position`](../rust/client.md#fn.local_position)、[`client::local_rotation`](../rust/client.md#fn.local_rotation)、[`client::local_dimension`](../rust/client.md#fn.local_dimension)、[`client::gui_scale`](../rust/client.md#fn.gui_scale)、[`client::server_ping_ms`](../rust/client.md#fn.server_ping_ms) 等，共 80 个
    - Go：[`ClientPosX`](../go/client.md#ClientPosX)、[`ClientPosY`](../go/client.md#ClientPosY)、[`ClientPosZ`](../go/client.md#ClientPosZ)、[`ClientPitch`](../go/client.md#ClientPitch)、[`ClientYaw`](../go/client.md#ClientYaw)、[`ClientDimension`](../go/client.md#ClientDimension) 等，共 70 个
    - Zig：[`client.property`](../zig/client.md#client.property)、[`client.localPosition`](../zig/client.md#client.localPosition)、[`client.localRotation`](../zig/client.md#client.localRotation)、[`client.localDimension`](../zig/client.md#client.localDimension)、[`client.guiScale`](../zig/client.md#client.guiScale)、[`client.serverPingMs`](../zig/client.md#client.serverPingMs) 等，共 67 个

### `client_get_str` {#client_get_str}

```c
bool (*client_get_str)(int32_t prop, void* ctx, PierStrSink sink);
```

通过 `sink` 读取一个 PIER_CSTR_* 值，sink 只调用一次。键未知、sink 为空、或者客户端还没有实例时返回 false，sink 不会被调用。

- 调用形式：`api->client_get_str(prop, ctx, sink)`
- 参数：
    - prop : `int32_t`
    - ctx : `void*`
    - sink : `PierStrSink`
- 返回值类型：`bool`
- 所在分节：客户端能力组（续）。和上面的 client_* 一样，在服务端宿主上为 NULL；（`Client capability group, continued. NULL on a server host, like client_* above;`）
- 表内序号：第 203 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::top_screen_name`](../rust/client.md#fn.top_screen_name)、[`Client::screen_name`](../rust/client.md#Client.screen_name)、[`Client::top_screen_name`](../rust/client.md#Client.top_screen_name)、[`Client::platform_id`](../rust/client.md#Client.platform_id)、[`Client::platform_online_id`](../rust/client.md#Client.platform_online_id)、[`Client::local_xuid`](../rust/client.md#Client.local_xuid) 等，共 9 个
    - Go：[`ClientScreenName`](../go/client.md#ClientScreenName)、[`ClientTopScreenName`](../go/client.md#ClientTopScreenName)、[`ClientPlatformId`](../go/client.md#ClientPlatformId)、[`ClientPlatformOnlineId`](../go/client.md#ClientPlatformOnlineId)、[`ClientLocalXuid`](../go/client.md#ClientLocalXuid)、[`ClientLocalUuid`](../go/client.md#ClientLocalUuid) 等，共 9 个
    - Zig：[`client.topScreenName`](../zig/client.md#client.topScreenName)、[`client.platformId`](../zig/client.md#client.platformId)、[`client.platformOnlineId`](../zig/client.md#client.platformOnlineId)、[`client.localXuid`](../zig/client.md#client.localXuid)、[`client.localUuid`](../zig/client.md#client.localUuid)、[`client.localNameTag`](../zig/client.md#client.localNameTag) 等，共 7 个

### `client_action` {#client_action}

```c
bool (*client_action)(int32_t action, PierStr sarg, double a, double b, double c);
```

在这个客户端上执行一个 PIER_CACT_* 动作。动作未知、文本类动作给了空文本、或者客户端还没有实例时返回 false。文本类动作需要 HUD，HUD 在世界加载后才存在，之前一律返回 false。返回 true 表示调用到达了引擎，引擎不会回报任何结果。

- 调用形式：`api->client_action(action, sarg, a, b, c)`
- 参数：
    - action : `int32_t`
    - sarg : `PierStr`
    - a : `double`
    - b : `double`
    - c : `double`
- 返回值类型：`bool`
- 所在分节：客户端能力组（续）。和上面的 client_* 一样，在服务端宿主上为 NULL；（`Client capability group, continued. NULL on a server host, like client_* above;`）
- 表内序号：第 204 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::show_message`](../rust/client.md#fn.show_message)、[`client::set_title`](../rust/client.md#fn.set_title)、[`client::set_subtitle`](../rust/client.md#fn.set_subtitle)、[`client::set_action_bar`](../rust/client.md#fn.set_action_bar)、[`client::show_tip`](../rust/client.md#fn.show_tip)、[`client::play_ui_sound`](../rust/client.md#fn.play_ui_sound) 等，共 25 个
    - Go：[`ClientShowMessage`](../go/client.md#ClientShowMessage)、[`ClientSetTitle`](../go/client.md#ClientSetTitle)、[`ClientSetSubtitle`](../go/client.md#ClientSetSubtitle)、[`ClientSetActionBar`](../go/client.md#ClientSetActionBar)、[`ClientShowTip`](../go/client.md#ClientShowTip)、[`ClientPlayUiSound`](../go/client.md#ClientPlayUiSound) 等，共 26 个
    - Zig：[`client.showMessage`](../zig/client.md#client.showMessage)、[`client.setTitle`](../zig/client.md#client.setTitle)、[`client.setSubtitle`](../zig/client.md#client.setSubtitle)、[`client.setActionBar`](../zig/client.md#client.setActionBar)、[`client.showTip`](../zig/client.md#client.showTip)、[`client.playUiSound`](../zig/client.md#client.playUiSound) 等，共 25 个

### `client_list_keys` {#client_list_keys}

```c
bool (*client_list_keys)(void* ctx, PierStrSink sink);
```

把 ll::input::KeyRegistry 中每个绑定的名字逐个交给 `sink`，每个名字调用一次，不论是哪个模组注册的。只有 sink 为空时返回 false。

- 调用形式：`api->client_list_keys(ctx, sink)`
- 参数：
    - ctx : `void*`
    - sink : `PierStrSink`
- 返回值类型：`bool`
- 所在分节：客户端能力组（续）。和上面的 client_* 一样，在服务端宿主上为 NULL；（`Client capability group, continued. NULL on a server host, like client_* above;`）
- 表内序号：第 205 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::registered_keys`](../rust/client.md#fn.registered_keys)、[`client::has_key`](../rust/client.md#fn.has_key)
    - Go：[`Raw.ClientListKeys`](../go/raw.md#Raw.ClientListKeys)
    - Zig：[`client.registeredKeys`](../zig/client.md#client.registeredKeys)

### `client_option_list` {#client_option_list}

```c
bool (*client_option_list)(void* ctx, PierKvSink sink);
```

把每个选项逐个交给 `sink`，每个 (key, value) 对调用一次，内容与 Option::save 写出的相同。保存多个键的选项（例如每种输入方式各一个值）会把每个键都交出来。sink 为空或者客户端还没有实例时返回 false。

- 调用形式：`api->client_option_list(ctx, sink)`
- 参数：
    - ctx : `void*`
    - sink : `PierKvSink`
- 返回值类型：`bool`
- 所在分节：客户端能力组：选项。在服务端宿主上为 NULL，只能在客户端线程调用。（`Client capability group, options. NULL on a server host. Client thread only. An`）
- 表内序号：第 217 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::options`](../rust/client.md#fn.options)
    - Go：[`ClientOptions`](../go/client.md#ClientOptions)
    - Zig：[`client.options`](../zig/client.md#client.options)

### `client_option_get` {#client_option_get}

```c
bool (*client_option_get)(PierStr key, void* ctx, PierStrSink sink);
```

按 options.txt 里的键通过 `sink` 读取一个选项，sink 只调用一次。键未知、sink 为空、或者客户端还没有实例时返回 false，sink 不会被调用。

- 调用形式：`api->client_option_get(key, ctx, sink)`
- 参数：
    - key : `PierStr`
    - ctx : `void*`
    - sink : `PierStrSink`
- 返回值类型：`bool`
- 所在分节：客户端能力组：选项。在服务端宿主上为 NULL，只能在客户端线程调用。（`Client capability group, options. NULL on a server host. Client thread only. An`）
- 表内序号：第 218 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::option`](../rust/client.md#fn.option)
    - Go：[`Raw.ClientOptionGet`](../go/raw.md#Raw.ClientOptionGet)
    - Zig：[`client.option`](../zig/client.md#client.option)

### `client_option_set` {#client_option_set}

```c
bool (*client_option_set)(PierStr key, PierStr value);
```

写入保存着 `key` 的那个选项，把 `value` 交给 Option::load，也就是读取 options.txt 时用的解析器。键未知、引擎标记该选项此刻不可修改、或者客户端还没有实例时返回 false。引擎保留它能解析的部分，不报告任何结果，所以需要确认的调用方要把这个键读回来。宿主自己不会写 options.txt。

- 调用形式：`api->client_option_set(key, value)`
- 参数：
    - key : `PierStr`
    - value : `PierStr`
- 返回值类型：`bool`
- 所在分节：客户端能力组：选项。在服务端宿主上为 NULL，只能在客户端线程调用。（`Client capability group, options. NULL on a server host. Client thread only. An`）
- 表内序号：第 219 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`client::set_option`](../rust/client.md#fn.set_option)
    - Go：[`Raw.ClientOptionSet`](../go/raw.md#Raw.ClientOptionSet)
    - Zig：[`client.setOption`](../zig/client.md#client.setOption)

## 类型 {#types}

### `PierKeyHandle` {#PierKeyHandle}

```c
typedef void* PierKeyHandle;
```

指向一个已注册按键绑定的不透明句柄，绑定归加载器的 `ll::input::KeyRegistry` 所有。用 `client_unregister_key` 释放。

### `PierKeyAction` {#PierKeyAction}

```c
typedef int32_t PierKeyAction;
```

按键动作：0 = 松开（up），1 = 按下（down）。对应 `ll::event::KeyInputEvent::Action`。

### `PierFocusImpact` {#PierFocusImpact}

```c
typedef int32_t PierFocusImpact;
```

焦点影响级别：0=Neutral，1=ActivateFocus，2=DeactivateFocus。对应 `::FocusImpact`。

### `PierKeyCb` {#PierKeyCb}

```c
typedef void (*PierKeyCb)(void* user, PierKeyAction action, PierFocusImpact impact);
```

按键按下和松开事件的回调，在客户端线程上运行。

- `user`：传给 `client_register_key` 的指针
- `action`：0=松开，1=按下（见 `PierKeyAction`）
- `impact`：当前的焦点影响（见 `PierFocusImpact`）

## `PierClientNumProp` {#PierClientNumProp}

client_get_num 的键。每个值都读自这个客户端自身的状态，所以连接远程服务器时，它描述的是这个客户端看到的情况。只能追加，和本文件中所有键枚举一样；未知的键会让调用返回 false。键 0 到 5 以及 13 到 27 读取本地玩家，客户端不在世界里时会失败。

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="PIER_CPROP_POS_X"></span>`PIER_CPROP_POS_X` | `0` | 本地玩家的 Actor::getFeetPos |
| <span id="PIER_CPROP_POS_Y"></span>`PIER_CPROP_POS_Y` | `1` | 脚下的高度，与 get_player_position 报告的是同一个点 |
| <span id="PIER_CPROP_POS_Z"></span>`PIER_CPROP_POS_Z` | `2` |  |
| <span id="PIER_CPROP_PITCH"></span>`PIER_CPROP_PITCH` | `3` | Actor::getRotation，单位为度；为负表示向上看 |
| <span id="PIER_CPROP_YAW"></span>`PIER_CPROP_YAW` | `4` | Actor::getRotation，单位为度 |
| <span id="PIER_CPROP_DIMENSION"></span>`PIER_CPROP_DIMENSION` | `5` | 本地玩家的 Actor::getDimensionId |
| <span id="PIER_CPROP_GUI_SCALE"></span>`PIER_CPROP_GUI_SCALE` | `6` | IClientInstance::getGuiScale |
| <span id="PIER_CPROP_SERVER_PING_MS"></span>`PIER_CPROP_SERVER_PING_MS` | `7` | IClientInstance::getServerPingTime |
| <span id="PIER_CPROP_IS_SHOWING_MENU"></span>`PIER_CPROP_IS_SHOWING_MENU` | `8` | IClientInstance::isShowingMenu，1 或 0 |
| <span id="PIER_CPROP_IS_SHOWING_PAUSE_SCREEN"></span>`PIER_CPROP_IS_SHOWING_PAUSE_SCREEN` | `9` | IClientInstance::isShowingPauseScreen |
| <span id="PIER_CPROP_IS_PLAYING"></span>`PIER_CPROP_IS_PLAYING` | `10` | IClientInstance::isPlaying |
| <span id="PIER_CPROP_IS_IN_REALM"></span>`PIER_CPROP_IS_IN_REALM` | `11` | IClientInstance::isInRealm |
| <span id="PIER_CPROP_IS_GAME_INPUT_ENABLED"></span>`PIER_CPROP_IS_GAME_INPUT_ENABLED` | `12` | IClientInstance::isInGameInputEnabled |
| <span id="PIER_CPROP_HEALTH"></span>`PIER_CPROP_HEALTH` | `13` | 本地玩家的 `Actor::getHealth` |
| <span id="PIER_CPROP_MAX_HEALTH"></span>`PIER_CPROP_MAX_HEALTH` | `14` | 本地玩家的 `Actor::getMaxHealth` |
| <span id="PIER_CPROP_IS_ON_GROUND"></span>`PIER_CPROP_IS_ON_GROUND` | `15` | 本地玩家的 `Actor::isOnGround` |
| <span id="PIER_CPROP_IS_IN_WATER"></span>`PIER_CPROP_IS_IN_WATER` | `16` | 本地玩家的 `Actor::isInWater` |
| <span id="PIER_CPROP_IS_SNEAKING"></span>`PIER_CPROP_IS_SNEAKING` | `17` | 本地玩家的 `Actor::isSneaking` |
| <span id="PIER_CPROP_IS_SPRINTING"></span>`PIER_CPROP_IS_SPRINTING` | `18` | 本地玩家的 `Actor::isSprinting` |
| <span id="PIER_CPROP_IS_SWIMMING"></span>`PIER_CPROP_IS_SWIMMING` | `19` | 本地玩家的 `Actor::isSwimming` |
| <span id="PIER_CPROP_IS_ON_FIRE"></span>`PIER_CPROP_IS_ON_FIRE` | `20` | 本地玩家的 `Actor::isOnFire` |
| <span id="PIER_CPROP_IS_FLYING"></span>`PIER_CPROP_IS_FLYING` | `21` | 本地玩家的 `Player::isFlying` |
| <span id="PIER_CPROP_GAME_TYPE"></span>`PIER_CPROP_GAME_TYPE` | `22` | 本地玩家的 `Player::getPlayerGameType` |
| <span id="PIER_CPROP_SELECTED_SLOT"></span>`PIER_CPROP_SELECTED_SLOT` | `23` | 本地玩家的 `Player::getSelectedItemSlot` |
| <span id="PIER_CPROP_VEL_X"></span>`PIER_CPROP_VEL_X` | `24` | 本地玩家的 `Actor::getPosDelta`，单位为方块每刻 |
| <span id="PIER_CPROP_VEL_Y"></span>`PIER_CPROP_VEL_Y` | `25` | `Actor::getPosDelta` 的竖直分量 |
| <span id="PIER_CPROP_VEL_Z"></span>`PIER_CPROP_VEL_Z` | `26` | `Actor::getPosDelta` 的 z 分量 |
| <span id="PIER_CPROP_XP_NEEDED_NEXT_LEVEL"></span>`PIER_CPROP_XP_NEEDED_NEXT_LEVEL` | `27` | 本地玩家的 `Player::getXpNeededForNextLevel` |
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
| <span id="PIER_CPROP_FRAME_ALPHA"></span>`PIER_CPROP_FRAME_ALPHA` | `63` | `IClientInstance::getFrameAlpha`，当前帧处在两刻之间的位置 |
| <span id="PIER_CPROP_GAME_UPDATE_SECONDS"></span>`PIER_CPROP_GAME_UPDATE_SECONDS` | `64` | `IClientInstance::getGameUpdateDurationInSeconds` |
| <span id="PIER_CPROP_IS_PRIMARY_CLIENT"></span>`PIER_CPROP_IS_PRIMARY_CLIENT` | `65` | `IClientInstance::isPrimaryClient` |
| <span id="PIER_CPROP_USER_ID"></span>`PIER_CPROP_USER_ID` | `66` | `IClientInstance::getUserId` |
| <span id="PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED"></span>`PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED` | `67` | `IClientInstance::isGamePlayTipsEnabled` |
| <span id="PIER_CPROP_HAS_COMMANDS"></span>`PIER_CPROP_HAS_COMMANDS` | `68` | `IClientInstance::hasCommands` |

## `PierClientStrProp` {#PierClientStrProp}

client_get_str 的键。

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="PIER_CSTR_SCREEN_NAME"></span>`PIER_CSTR_SCREEN_NAME` | `0` | IClientInstance::getScreenName，与 client_get_screen_name 相同 |
| <span id="PIER_CSTR_TOP_SCREEN_NAME"></span>`PIER_CSTR_TOP_SCREEN_NAME` | `1` | IClientInstance::getTopScreenName |
| <span id="PIER_CSTR_PLATFORM_ID"></span>`PIER_CSTR_PLATFORM_ID` | `2` | `IClientInstance::getPlatformId` |
| <span id="PIER_CSTR_PLATFORM_ONLINE_ID"></span>`PIER_CSTR_PLATFORM_ONLINE_ID` | `3` | `IClientInstance::getPlatformOnlineId` |
| <span id="PIER_CSTR_LOCAL_XUID"></span>`PIER_CSTR_LOCAL_XUID` | `4` | 本地玩家的 `Player::getXuid`；不在世界里时失败 |
| <span id="PIER_CSTR_LOCAL_UUID"></span>`PIER_CSTR_LOCAL_UUID` | `5` | 本地玩家的 `Player::getUuid`，规范字符串形式 |
| <span id="PIER_CSTR_LOCAL_NAME_TAG"></span>`PIER_CSTR_LOCAL_NAME_TAG` | `6` | 本地玩家的 `Actor::getNameTag` |
| <span id="PIER_CSTR_CLIPBOARD"></span>`PIER_CSTR_CLIPBOARD` | `7` | `AppPlatform::getClipboardText`，系统剪贴板 |

## `PierClientAction` {#PierClientAction}

client_action 的动作。参数为 (sarg, a, b, c)，用不到的参数会被忽略。文本类动作只写到这个客户端的 HUD，不会向服务器发送任何东西。

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="PIER_CACT_SHOW_MESSAGE"></span>`PIER_CACT_SHOW_MESSAGE` | `0` | sarg：文本。GuiData::displayClientMessage |
| <span id="PIER_CACT_SET_TITLE"></span>`PIER_CACT_SET_TITLE` | `1` | sarg：文本。GuiData::setTitle |
| <span id="PIER_CACT_SET_SUBTITLE"></span>`PIER_CACT_SET_SUBTITLE` | `2` | sarg：文本。GuiData::setSubtitle |
| <span id="PIER_CACT_SET_ACTION_BAR"></span>`PIER_CACT_SET_ACTION_BAR` | `3` | sarg：文本。GuiData::setActionBarMessage |
| <span id="PIER_CACT_SHOW_TIP"></span>`PIER_CACT_SHOW_TIP` | `4` | sarg：文本。GuiData::showTipMessage |
| <span id="PIER_CACT_PLAY_UI_SOUND"></span>`PIER_CACT_PLAY_UI_SOUND` | `5` | sarg：音效名，a：音量，b：音调。IClientInstance::playUI |
| <span id="PIER_CACT_GRAB_MOUSE"></span>`PIER_CACT_GRAB_MOUSE` | `6` | IClientInstance::grabMouse |
| <span id="PIER_CACT_RELEASE_MOUSE"></span>`PIER_CACT_RELEASE_MOUSE` | `7` | IClientInstance::releaseMouse |
| <span id="PIER_CACT_SET_INPUT_DISABLED"></span>`PIER_CACT_SET_INPUT_DISABLED` | `8` | a：非零时禁用游戏输入。IClientInstance::setDisableInput |
| <span id="PIER_CACT_LEAVE_LEVEL"></span>`PIER_CACT_LEAVE_LEVEL` | `9` | IClientInstance::requestLeaveGame(true, false)：离开世界回到菜单，异步完成 |
| <span id="PIER_CACT_SHOW_POPUP"></span>`PIER_CACT_SHOW_POPUP` | `10` | sarg：消息，或者在第一个换行处分开的消息和副标题。`GuiData::showPopupNotice` |
| <span id="PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE"></span>`PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE` | `11` | sarg：文本。`GuiData::displayDevConsoleMessage` |
| <span id="PIER_CACT_SET_SUSPEND_INPUT"></span>`PIER_CACT_SET_SUSPEND_INPUT` | `12` | a：非零时暂停输入。`IClientInstance::setSuspendInput` |
| <span id="PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT"></span>`PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT` | `13` | a：非零时暂停移动输入。`IClientInstance::setSuspendDirectionalInput` |
| <span id="PIER_CACT_SET_GAME_INPUT_ENABLED"></span>`PIER_CACT_SET_GAME_INPUT_ENABLED` | `14` | a：非零时启用。`IClientInstance::setInGameInputEnabled` |
| <span id="PIER_CACT_REFOCUS_MOUSE"></span>`PIER_CACT_REFOCUS_MOUSE` | `15` | a：鼠标丢失时为非零。`IClientInstance::refocusMouse` |
| <span id="PIER_CACT_MUTE_AUDIO"></span>`PIER_CACT_MUTE_AUDIO` | `16` | `IClientInstance::muteAudio` |
| <span id="PIER_CACT_UNMUTE_AUDIO"></span>`PIER_CACT_UNMUTE_AUDIO` | `17` | `IClientInstance::unMuteAudio` |
| <span id="PIER_CACT_FADE_OUT_MUSIC"></span>`PIER_CACT_FADE_OUT_MUSIC` | `18` | `IClientInstance::fadeOutMusic` |
| <span id="PIER_CACT_SET_GUI_SCALE_OFFSET"></span>`PIER_CACT_SET_GUI_SCALE_OFFSET` | `19` | a：偏移量。`IClientInstance::setGuiScaleOffset` |
| <span id="PIER_CACT_RESET_PLAYER_MOVEMENT"></span>`PIER_CACT_RESET_PLAYER_MOVEMENT` | `20` | `IClientInstance::resetPlayerMovement` |
| <span id="PIER_CACT_PUSH_LEAVE_GAME_SCREEN"></span>`PIER_CACT_PUSH_LEAVE_GAME_SCREEN` | `21` | `IClientInstance::tryPushLeaveGameScreen` |
| <span id="PIER_CACT_OPEN_CONTENT_LOG_HISTORY"></span>`PIER_CACT_OPEN_CONTENT_LOG_HISTORY` | `22` | `IClientInstance::openContentLogHistory` |
| <span id="PIER_CACT_SET_CLIPBOARD"></span>`PIER_CACT_SET_CLIPBOARD` | `23` | sarg：文本，可以为空。`AppPlatform::setClipboard` |
| <span id="PIER_CACT_NAVIGATE_HOW_TO_PLAY"></span>`PIER_CACT_NAVIGATE_HOW_TO_PLAY` | `24` | sarg：主题，可以为空。`IClientInstance::navigateToHowToPlayScreen` |
