# levilamina::client · 客户端

只在客户端可用的能力。

**在服务器宿主上，这一整组都是空槽位**

在服务器宿主上调用，得到的是运行时的 `Err`，编译不会报错。契约 §2.1：所有目标上的布局都一样，缺少的能力就是 NULL 槽位，所以同一份模组源码能为两个目标编译；加载到错误的目标上时，宿主会在握手时根据 `mod_flags` 明确拒绝。

用 [`is_available`](client.md#fn.is_available) 判断，不要用 `cfg`。

**回调在客户端线程上运行**

不在服务器线程上。热键回调不能碰服务器的状态。

## 函数 {#functions}

### `client::is_available` {#fn.is_available}

```rust
pub fn is_available() -> bool
```

这个宿主是不是为客户端目标构建的，也就是 `client_*` 槽位有没有填上。

- 返回值类型：`bool`
- 对应槽位：[`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `client::is_in_level` {#fn.is_in_level}

```rust
pub fn is_in_level() -> Result<bool>
```

客户端当前是否在一个世界里。

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `client::local_player_name` {#fn.local_player_name}

```rust
pub fn local_player_name() -> Result<String>
```

本地玩家的名字。不在世界里时返回 `Err`。

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_local_player`](../cpp/client.md#client_get_local_player)

### `client::screen_name` {#fn.screen_name}

```rust
pub fn screen_name() -> Result<String>
```

当前界面的名字，比如 `"hud_screen"` 或 `"pause_screen"`。

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_screen_name`](../cpp/client.md#client_get_screen_name)

### `client::register_key` {#fn.register_key}

```rust
pub fn register_key(
    name: &str,
    key_codes: &[i32],
    allow_remap: bool,
    handler: impl FnMut(KeyAction, i32) + Send + 'static,
) -> Result<KeyBinding>
```

注册一个热键。

`key_codes` 是默认的绑定，`allow_remap` 决定玩家能不能在设置里改它。回调收到（动作，焦点影响），两者都在客户端线程上运行。

- 参数：
    - name : `&str`
    - key_codes : `&[i32]`
    - allow_remap : `bool`
    - handler : `impl FnMut(KeyAction, i32) + Send + 'static`
- 返回值类型：`Result<KeyBinding>`
- 对应槽位：[`client_register_key`](../cpp/client.md#client_register_key)

### `client::property` {#fn.property}

```rust
pub fn property(prop: i32) -> Result<f64>
```

按 `PIER_CPROP_*` 键读取一个数值型的客户端属性。

宿主没有这个槽位、宿主不认识这个键、或者客户端不在世界里时读取关于本地玩家的键，都会得到 `Err`。

- 参数：
    - prop : `i32`
- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::local_position` {#fn.local_position}

```rust
pub fn local_position() -> Result<[f64; 3]>
```

本地玩家脚下的位置 `[x, y, z]`，与 `get_player_position` 报告的是同一个点。

- 返回值类型：`Result<[f64; 3]>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::local_rotation` {#fn.local_rotation}

```rust
pub fn local_rotation() -> Result<(f32, f32)>
```

本地玩家的 `(pitch, yaw)`，单位为度；pitch 为负表示向上看。

- 返回值类型：`Result<(f32, f32)>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::local_dimension` {#fn.local_dimension}

```rust
pub fn local_dimension() -> Result<i32>
```

本地玩家所在维度的 id。

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::gui_scale` {#fn.gui_scale}

```rust
pub fn gui_scale() -> Result<f32>
```

这个客户端绘制界面所用的 GUI 缩放。

- 返回值类型：`Result<f32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::server_ping_ms` {#fn.server_ping_ms}

```rust
pub fn server_ping_ms() -> Result<u64>
```

到服务器的往返延迟，单位毫秒，由这个客户端测得。

- 返回值类型：`Result<u64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_showing_menu` {#fn.is_showing_menu}

```rust
pub fn is_showing_menu() -> Result<bool>
```

是否正在显示菜单界面。

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_showing_pause_screen` {#fn.is_showing_pause_screen}

```rust
pub fn is_showing_pause_screen() -> Result<bool>
```

是否正在显示暂停界面。

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_playing` {#fn.is_playing}

```rust
pub fn is_playing() -> Result<bool>
```

客户端是否正在游玩一个世界。

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_in_realm` {#fn.is_in_realm}

```rust
pub fn is_in_realm() -> Result<bool>
```

当前世界是否是 Realm。

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_game_input_enabled` {#fn.is_game_input_enabled}

```rust
pub fn is_game_input_enabled() -> Result<bool>
```

游戏输入是否能到达世界；上层有界面时就不能。

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `client::top_screen_name` {#fn.top_screen_name}

```rust
pub fn top_screen_name() -> Result<String>
```

客户端界面栈最顶层的界面。

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `client::show_message` {#fn.show_message}

```rust
pub fn show_message(text: &str) -> Result<()>
```

在这个客户端的聊天栏里显示 `text`，不会发送给服务器。

- 参数：
    - text : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_title` {#fn.set_title}

```rust
pub fn set_title(text: &str) -> Result<()>
```

在这个客户端上把 `text` 显示为标题。

- 参数：
    - text : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_subtitle` {#fn.set_subtitle}

```rust
pub fn set_subtitle(text: &str) -> Result<()>
```

在这个客户端上把 `text` 显示为副标题。

- 参数：
    - text : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_action_bar` {#fn.set_action_bar}

```rust
pub fn set_action_bar(text: &str) -> Result<()>
```

在这个客户端的快捷栏上方显示 `text`。

- 参数：
    - text : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::show_tip` {#fn.show_tip}

```rust
pub fn show_tip(text: &str) -> Result<()>
```

在这个客户端上把 `text` 显示为提示。

- 参数：
    - text : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::play_ui_sound` {#fn.play_ui_sound}

```rust
pub fn play_ui_sound(name: &str, volume: f32, pitch: f32) -> Result<()>
```

在这个客户端上按名字播放一个界面音效，例如 `"random.click"`。

- 参数：
    - name : `&str`
    - volume : `f32`
    - pitch : `f32`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::grab_mouse` {#fn.grab_mouse}

```rust
pub fn grab_mouse() -> Result<()>
```

让游戏捕获鼠标，效果和点击进入世界一样。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::release_mouse` {#fn.release_mouse}

```rust
pub fn release_mouse() -> Result<()>
```

把鼠标释放给界面。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_input_disabled` {#fn.set_input_disabled}

```rust
pub fn set_input_disabled(disabled: bool) -> Result<()>
```

禁用或启用游戏输入。

- 参数：
    - disabled : `bool`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::leave_level` {#fn.leave_level}

```rust
pub fn leave_level() -> Result<()>
```

离开当前世界回到菜单。引擎以异步方式完成。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::registered_keys` {#fn.registered_keys}

```rust
pub fn registered_keys() -> Result<Vec<String>>
```

按键注册表里所有按键绑定的名字，不论是哪个模组注册的。

- 返回值类型：`Result<Vec<String>>`
- 对应槽位：[`client_list_keys`](../cpp/client.md#client_list_keys)

### `client::has_key` {#fn.has_key}

```rust
pub fn has_key(name: &str) -> Result<bool>
```

是否注册了这个名字的按键绑定。

- 参数：
    - name : `&str`
- 返回值类型：`Result<bool>`
- 对应槽位：[`client_list_keys`](../cpp/client.md#client_list_keys)

### `client::show_popup` {#fn.show_popup}

```rust
pub fn show_popup(message: &str, subtitle: &str) -> Result<()>
```

在这个客户端上显示一个弹出提示，副标题可以为空。

- 参数：
    - message : `&str`
    - subtitle : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::show_dev_console_message` {#fn.show_dev_console_message}

```rust
pub fn show_dev_console_message(text: &str) -> Result<()>
```

把 `text` 写入客户端的开发者控制台。

- 参数：
    - text : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_suspend_input` {#fn.set_suspend_input}

```rust
pub fn set_suspend_input(suspended: bool) -> Result<()>
```

暂停或恢复全部输入。

- 参数：
    - suspended : `bool`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_suspend_directional_input` {#fn.set_suspend_directional_input}

```rust
pub fn set_suspend_directional_input(suspended: bool) -> Result<()>
```

暂停或恢复移动输入。

- 参数：
    - suspended : `bool`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_game_input_enabled` {#fn.set_game_input_enabled}

```rust
pub fn set_game_input_enabled(enabled: bool) -> Result<()>
```

启用或禁用游戏输入。

- 参数：
    - enabled : `bool`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::refocus_mouse` {#fn.refocus_mouse}

```rust
pub fn refocus_mouse(lost: bool) -> Result<()>
```

把鼠标交还给游戏；`lost` 告诉引擎焦点曾经丢失。

- 参数：
    - lost : `bool`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::mute_audio` {#fn.mute_audio}

```rust
pub fn mute_audio() -> Result<()>
```

把客户端静音。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::unmute_audio` {#fn.unmute_audio}

```rust
pub fn unmute_audio() -> Result<()>
```

取消客户端静音。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::fade_out_music` {#fn.fade_out_music}

```rust
pub fn fade_out_music() -> Result<()>
```

让正在播放的音乐淡出。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_gui_scale_offset` {#fn.set_gui_scale_offset}

```rust
pub fn set_gui_scale_offset(offset: i32) -> Result<()>
```

设置 GUI 缩放偏移。

- 参数：
    - offset : `i32`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::reset_player_movement` {#fn.reset_player_movement}

```rust
pub fn reset_player_movement() -> Result<()>
```

重置本地玩家的移动输入。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::push_leave_game_screen` {#fn.push_leave_game_screen}

```rust
pub fn push_leave_game_screen() -> Result<()>
```

打开询问是否离开世界的界面。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::open_content_log_history` {#fn.open_content_log_history}

```rust
pub fn open_content_log_history() -> Result<()>
```

打开内容日志历史。

- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::set_clipboard` {#fn.set_clipboard}

```rust
pub fn set_clipboard(text: &str) -> Result<()>
```

把 `text` 写入系统剪贴板。

- 参数：
    - text : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::navigate_how_to_play` {#fn.navigate_how_to_play}

```rust
pub fn navigate_how_to_play(topic: &str) -> Result<()>
```

打开“游戏指南”界面并定位到 `topic`，主题为空时打开首页。

- 参数：
    - topic : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_action`](../cpp/client.md#client_action)

### `client::options` {#fn.options}

```rust
pub fn options() -> Result<Vec<(String, String)>>
```

全部客户端选项，以 `(key, value)` 对的形式给出，值是 `options.txt` 保存时用的文本形式。

- 返回值类型：`Result<Vec<(String, String)>>`
- 对应槽位：[`client_option_list`](../cpp/client.md#client_option_list)

### `client::option` {#fn.option}

```rust
pub fn option(key: &str) -> Result<String>
```

按 `options.txt` 里的键读取一个客户端选项，例如 `"gfx_field_of_view"`。

- 参数：
    - key : `&str`
- 返回值类型：`Result<String>`
- 对应槽位：[`client_option_get`](../cpp/client.md#client_option_get)

### `client::set_option` {#fn.set_option}

```rust
pub fn set_option(key: &str, value: &str) -> Result<()>
```

用 `options.txt` 的文本形式写入一个客户端选项。引擎保留它能解析的部分，不报告任何结果，所以需要确认的调用方要把这个键读回来。

- 参数：
    - key : `&str`
    - value : `&str`
- 返回值类型：`Result<()>`
- 对应槽位：[`client_option_set`](../cpp/client.md#client_option_set)

## `Client` {#Client}

```rust
pub struct Client;
```

把客户端当作一个值，供下面的属性表使用：`Client.health()` 读取本地玩家的生命值，`Client.is_mouse_grabbed()` 向客户端实例询问。

- 实现的 trait：`Debug`、`Clone`、`Copy`、`Default`、`PartialEq`、`Eq`

### `Client::pos_x` {#Client.pos_x}

```rust
pub fn pos_x(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::pos_y` {#Client.pos_y}

```rust
pub fn pos_y(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::pos_z` {#Client.pos_z}

```rust
pub fn pos_z(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::pitch` {#Client.pitch}

```rust
pub fn pitch(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::yaw` {#Client.yaw}

```rust
pub fn yaw(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::dimension` {#Client.dimension}

```rust
pub fn dimension(&self) -> Result<i32>
```

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::gui_scale` {#Client.gui_scale}

```rust
pub fn gui_scale(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::server_ping_ms` {#Client.server_ping_ms}

```rust
pub fn server_ping_ms(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_menu` {#Client.is_showing_menu}

```rust
pub fn is_showing_menu(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_pause_screen` {#Client.is_showing_pause_screen}

```rust
pub fn is_showing_pause_screen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_playing` {#Client.is_playing}

```rust
pub fn is_playing(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_realm` {#Client.is_in_realm}

```rust
pub fn is_in_realm(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_game_input_enabled` {#Client.is_game_input_enabled}

```rust
pub fn is_game_input_enabled(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::health` {#Client.health}

```rust
pub fn health(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::max_health` {#Client.max_health}

```rust
pub fn max_health(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_on_ground` {#Client.is_on_ground}

```rust
pub fn is_on_ground(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_water` {#Client.is_in_water}

```rust
pub fn is_in_water(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_sneaking` {#Client.is_sneaking}

```rust
pub fn is_sneaking(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_sprinting` {#Client.is_sprinting}

```rust
pub fn is_sprinting(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_swimming` {#Client.is_swimming}

```rust
pub fn is_swimming(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_on_fire` {#Client.is_on_fire}

```rust
pub fn is_on_fire(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_flying` {#Client.is_flying}

```rust
pub fn is_flying(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::game_type` {#Client.game_type}

```rust
pub fn game_type(&self) -> Result<i32>
```

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::selected_slot` {#Client.selected_slot}

```rust
pub fn selected_slot(&self) -> Result<i32>
```

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::vel_x` {#Client.vel_x}

```rust
pub fn vel_x(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::vel_y` {#Client.vel_y}

```rust
pub fn vel_y(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::vel_z` {#Client.vel_z}

```rust
pub fn vel_z(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::xp_needed_next_level` {#Client.xp_needed_next_level}

```rust
pub fn xp_needed_next_level(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_leaving_game` {#Client.is_leaving_game}

```rust
pub fn is_leaving_game(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_exiting_level` {#Client.is_exiting_level}

```rust
pub fn is_exiting_level(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_bed_screen` {#Client.is_in_bed_screen}

```rust
pub fn is_in_bed_screen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_death_screen` {#Client.is_in_death_screen}

```rust
pub fn is_in_death_screen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_loading_screen` {#Client.is_showing_loading_screen}

```rust
pub fn is_showing_loading_screen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_progress_screen` {#Client.is_showing_progress_screen}

```rust
pub fn is_showing_progress_screen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_world_progress_screen` {#Client.is_showing_world_progress_screen}

```rust
pub fn is_showing_world_progress_screen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_death_screen` {#Client.is_showing_death_screen}

```rust
pub fn is_showing_death_screen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_server_form` {#Client.is_showing_server_form}

```rust
pub fn is_showing_server_form(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_world_without_menu` {#Client.is_in_world_without_menu}

```rust
pub fn is_in_world_without_menu(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_world_active` {#Client.is_world_active}

```rust
pub fn is_world_active(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::has_level` {#Client.has_level}

```rust
pub fn has_level(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_pre_game` {#Client.is_pre_game}

```rust
pub fn is_pre_game(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_multiplayer_game` {#Client.is_in_multiplayer_game}

```rust
pub fn is_in_multiplayer_game(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_multiplayer_client` {#Client.is_multiplayer_client}

```rust
pub fn is_multiplayer_client(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_primary_level_multiplayer` {#Client.is_primary_level_multiplayer}

```rust
pub fn is_primary_level_multiplayer(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_primary_level_cross_platform` {#Client.is_primary_level_cross_platform}

```rust
pub fn is_primary_level_cross_platform(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_keyboard_enabled` {#Client.is_keyboard_enabled}

```rust
pub fn is_keyboard_enabled(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_using_controller` {#Client.is_using_controller}

```rust
pub fn is_using_controller(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_using_touchscreen` {#Client.is_using_touchscreen}

```rust
pub fn is_using_touchscreen(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_mouse_grabbed` {#Client.is_mouse_grabbed}

```rust
pub fn is_mouse_grabbed(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_mouse_and_keyboard` {#Client.is_mouse_and_keyboard}

```rust
pub fn is_mouse_and_keyboard(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::has_connected_controller` {#Client.has_connected_controller}

```rust
pub fn has_connected_controller(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::controller_id` {#Client.controller_id}

```rust
pub fn controller_id(&self) -> Result<i32>
```

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_touch_gameplay_allowed` {#Client.is_touch_gameplay_allowed}

```rust
pub fn is_touch_gameplay_allowed(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_split_screen_active` {#Client.is_split_screen_active}

```rust
pub fn is_split_screen_active(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::split_screen_count` {#Client.split_screen_count}

```rust
pub fn split_screen_count(&self) -> Result<i32>
```

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::gui_scale_offset` {#Client.gui_scale_offset}

```rust
pub fn gui_scale_offset(&self) -> Result<i32>
```

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_edu_mode` {#Client.is_edu_mode}

```rust
pub fn is_edu_mode(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_editor` {#Client.is_in_editor}

```rust
pub fn is_in_editor(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_ready_to_render` {#Client.is_ready_to_render}

```rust
pub fn is_ready_to_render(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_full_vanilla_pack_on_stack` {#Client.is_full_vanilla_pack_on_stack}

```rust
pub fn is_full_vanilla_pack_on_stack(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::server_connection_time` {#Client.server_connection_time}

```rust
pub fn server_connection_time(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::remote_server_time_ms` {#Client.remote_server_time_ms}

```rust
pub fn remote_server_time_ms(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::remote_server_network_time_ms` {#Client.remote_server_network_time_ms}

```rust
pub fn remote_server_network_time_ms(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::frame_alpha` {#Client.frame_alpha}

```rust
pub fn frame_alpha(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::game_update_seconds` {#Client.game_update_seconds}

```rust
pub fn game_update_seconds(&self) -> Result<f64>
```

- 返回值类型：`Result<f64>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_primary_client` {#Client.is_primary_client}

```rust
pub fn is_primary_client(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::user_id` {#Client.user_id}

```rust
pub fn user_id(&self) -> Result<i32>
```

- 返回值类型：`Result<i32>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_gameplay_tips_enabled` {#Client.is_gameplay_tips_enabled}

```rust
pub fn is_gameplay_tips_enabled(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::has_commands` {#Client.has_commands}

```rust
pub fn has_commands(&self) -> Result<bool>
```

- 返回值类型：`Result<bool>`
- 对应槽位：[`client_get_num`](../cpp/client.md#client_get_num)

### `Client::screen_name` {#Client.screen_name}

```rust
pub fn screen_name(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `Client::top_screen_name` {#Client.top_screen_name}

```rust
pub fn top_screen_name(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `Client::platform_id` {#Client.platform_id}

```rust
pub fn platform_id(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `Client::platform_online_id` {#Client.platform_online_id}

```rust
pub fn platform_online_id(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `Client::local_xuid` {#Client.local_xuid}

```rust
pub fn local_xuid(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `Client::local_uuid` {#Client.local_uuid}

```rust
pub fn local_uuid(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `Client::local_name_tag` {#Client.local_name_tag}

```rust
pub fn local_name_tag(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

### `Client::clipboard` {#Client.clipboard}

```rust
pub fn clipboard(&self) -> Result<String>
```

- 返回值类型：`Result<String>`
- 对应槽位：[`client_get_str`](../cpp/client.md#client_get_str)

## `KeyBinding` {#KeyBinding}

```rust
pub struct KeyBinding {
    // private fields
}
```

一个已注册的热键。丢弃它就会注销。

- 实现的 trait：`Drop`、`Debug`

### `KeyBinding::name` {#KeyBinding.name}

```rust
pub fn name(&self) -> &str
```

- 返回值类型：`&str`

### `KeyBinding::key_codes` {#KeyBinding.key_codes}

```rust
pub fn key_codes(&self) -> Result<Vec<i32>>
```

当前绑定的按键码。玩家重新绑定以后，就和默认值不同了。

- 返回值类型：`Result<Vec<i32>>`
- 对应槽位：[`client_get_key_codes`](../cpp/client.md#client_get_key_codes)

### `KeyBinding::forget` {#KeyBinding.forget}

```rust
pub fn forget(mut self)
```

让它一直存活到模组卸载，那时由宿主清掉。

## `KeyAction` {#KeyAction}

```rust
pub enum KeyAction {
        Up,
        Down,
        /// The host reported an action code this side does not recognize.
        Unknown(i32),
}
```

一个按键动作。

- 实现的 trait：`Debug`、`Clone`、`Copy`、`PartialEq`、`Eq`

### `KeyAction::from_i32` {#KeyAction.from_i32}

```rust
pub fn from_i32(v: i32) -> KeyAction
```

- 参数：
    - v : `i32`
- 返回值类型：`KeyAction`

### `KeyAction::is_down` {#KeyAction.is_down}

```rust
pub fn is_down(self) -> bool
```

- 返回值类型：`bool`
