# levilamina::client

Client-only capabilities.

**On a server host this whole family is empty slots**

Not a compile error but a runtime `Err`. Contract §2.1: the layout is identical on every
target and an absent capability is a NULL slot, so the same mod source compiles for both
targets and loading onto the wrong one is refused explicitly by the host during the
handshake, from `mod_flags`.

Decide with [`is_available`](client.md#fn.is_available) and not with a `cfg`.

**A callback runs on the client thread**

Not the server thread. A hotkey callback must not touch server state.

## Functions {#functions}

### `client::is_available` {#fn.is_available}

```rust
pub fn is_available() -> bool
```

Whether this host was built for the client target, meaning whether the `client_*` slots
are filled.

- Return type: `bool`
- Slots: [`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `client::is_in_level` {#fn.is_in_level}

```rust
pub fn is_in_level() -> Result<bool>
```

Whether the client is currently in a world.

- Return type: `Result<bool>`
- Slots: [`client_is_in_level`](../cpp/client.md#client_is_in_level)

### `client::local_player_name` {#fn.local_player_name}

```rust
pub fn local_player_name() -> Result<String>
```

The name of the local player. Not being in a world is an `Err`.

- Return type: `Result<String>`
- Slots: [`client_get_local_player`](../cpp/client.md#client_get_local_player)

### `client::screen_name` {#fn.screen_name}

```rust
pub fn screen_name() -> Result<String>
```

The current screen name, such as `"hud_screen"` or `"pause_screen"`.

- Return type: `Result<String>`
- Slots: [`client_get_screen_name`](../cpp/client.md#client_get_screen_name)

### `client::register_key` {#fn.register_key}

```rust
pub fn register_key(
    name: &str,
    key_codes: &[i32],
    allow_remap: bool,
    handler: impl FnMut(KeyAction, i32) + Send + 'static,
) -> Result<KeyBinding>
```

Registers a hotkey.

`key_codes` is the default binding and `allow_remap` decides whether the player may
change it in the settings.
The callback receives (action, focus impact) and both run on the client thread.

- Parameters:
    - name : `&str`
    - key_codes : `&[i32]`
    - allow_remap : `bool`
    - handler : `impl FnMut(KeyAction, i32) + Send + 'static`
- Return type: `Result<KeyBinding>`
- Slots: [`client_register_key`](../cpp/client.md#client_register_key)

### `client::property` {#fn.property}

```rust
pub fn property(prop: i32) -> Result<f64>
```

One numeric client property by its `PIER_CPROP_*` key.

An `Err` covers a host without the slot, a key this host does not know, and a key about
the local player read while the client is not in a world.

- Parameters:
    - prop : `i32`
- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::local_position` {#fn.local_position}

```rust
pub fn local_position() -> Result<[f64; 3]>
```

The local player's feet position as `[x, y, z]`, the point `get_player_position` reports.

- Return type: `Result<[f64; 3]>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::local_rotation` {#fn.local_rotation}

```rust
pub fn local_rotation() -> Result<(f32, f32)>
```

The local player's `(pitch, yaw)` in degrees; a negative pitch looks up.

- Return type: `Result<(f32, f32)>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::local_dimension` {#fn.local_dimension}

```rust
pub fn local_dimension() -> Result<i32>
```

The id of the dimension the local player is in.

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::gui_scale` {#fn.gui_scale}

```rust
pub fn gui_scale() -> Result<f32>
```

The GUI scale this client draws with.

- Return type: `Result<f32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::server_ping_ms` {#fn.server_ping_ms}

```rust
pub fn server_ping_ms() -> Result<u64>
```

The round trip to the server in milliseconds, as this client measures it.

- Return type: `Result<u64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_showing_menu` {#fn.is_showing_menu}

```rust
pub fn is_showing_menu() -> Result<bool>
```

Whether a menu screen is showing.

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_showing_pause_screen` {#fn.is_showing_pause_screen}

```rust
pub fn is_showing_pause_screen() -> Result<bool>
```

Whether the pause screen is showing.

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_playing` {#fn.is_playing}

```rust
pub fn is_playing() -> Result<bool>
```

Whether the client is playing a world.

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_in_realm` {#fn.is_in_realm}

```rust
pub fn is_in_realm() -> Result<bool>
```

Whether the world is a Realm.

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::is_game_input_enabled` {#fn.is_game_input_enabled}

```rust
pub fn is_game_input_enabled() -> Result<bool>
```

Whether game input reaches the world, which a screen on top takes away.

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `client::top_screen_name` {#fn.top_screen_name}

```rust
pub fn top_screen_name() -> Result<String>
```

The topmost screen of the client's screen stack.

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `client::show_message` {#fn.show_message}

```rust
pub fn show_message(text: &str) -> Result<()>
```

Shows `text` in this client's chat. Nothing is sent to a server.

- Parameters:
    - text : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_title` {#fn.set_title}

```rust
pub fn set_title(text: &str) -> Result<()>
```

Shows `text` as the title on this client.

- Parameters:
    - text : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_subtitle` {#fn.set_subtitle}

```rust
pub fn set_subtitle(text: &str) -> Result<()>
```

Shows `text` as the subtitle on this client.

- Parameters:
    - text : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_action_bar` {#fn.set_action_bar}

```rust
pub fn set_action_bar(text: &str) -> Result<()>
```

Shows `text` above the hotbar on this client.

- Parameters:
    - text : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::show_tip` {#fn.show_tip}

```rust
pub fn show_tip(text: &str) -> Result<()>
```

Shows `text` as a tip on this client.

- Parameters:
    - text : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::play_ui_sound` {#fn.play_ui_sound}

```rust
pub fn play_ui_sound(name: &str, volume: f32, pitch: f32) -> Result<()>
```

Plays a UI sound by name on this client, such as `"random.click"`.

- Parameters:
    - name : `&str`
    - volume : `f32`
    - pitch : `f32`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::grab_mouse` {#fn.grab_mouse}

```rust
pub fn grab_mouse() -> Result<()>
```

Captures the mouse for the game, as a click into the world does.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::release_mouse` {#fn.release_mouse}

```rust
pub fn release_mouse() -> Result<()>
```

Releases the mouse to the screen.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_input_disabled` {#fn.set_input_disabled}

```rust
pub fn set_input_disabled(disabled: bool) -> Result<()>
```

Disables or enables game input.

- Parameters:
    - disabled : `bool`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::leave_level` {#fn.leave_level}

```rust
pub fn leave_level() -> Result<()>
```

Leaves the current world for the menus. The engine does it asynchronously.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::registered_keys` {#fn.registered_keys}

```rust
pub fn registered_keys() -> Result<Vec<String>>
```

Every key binding name the key registry holds, whichever mod registered it.

- Return type: `Result<Vec<String>>`
- Slots: [`client_list_keys`](../cpp/client.md#client_list_keys)

### `client::has_key` {#fn.has_key}

```rust
pub fn has_key(name: &str) -> Result<bool>
```

Whether a key binding of this name is registered.

- Parameters:
    - name : `&str`
- Return type: `Result<bool>`
- Slots: [`client_list_keys`](../cpp/client.md#client_list_keys)

### `client::show_popup` {#fn.show_popup}

```rust
pub fn show_popup(message: &str, subtitle: &str) -> Result<()>
```

Shows a popup with an optional subtitle on this client.

- Parameters:
    - message : `&str`
    - subtitle : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::show_dev_console_message` {#fn.show_dev_console_message}

```rust
pub fn show_dev_console_message(text: &str) -> Result<()>
```

Writes `text` to the client's developer console.

- Parameters:
    - text : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_suspend_input` {#fn.set_suspend_input}

```rust
pub fn set_suspend_input(suspended: bool) -> Result<()>
```

Suspends or resumes all input.

- Parameters:
    - suspended : `bool`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_suspend_directional_input` {#fn.set_suspend_directional_input}

```rust
pub fn set_suspend_directional_input(suspended: bool) -> Result<()>
```

Suspends or resumes movement input.

- Parameters:
    - suspended : `bool`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_game_input_enabled` {#fn.set_game_input_enabled}

```rust
pub fn set_game_input_enabled(enabled: bool) -> Result<()>
```

Enables or disables game input.

- Parameters:
    - enabled : `bool`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::refocus_mouse` {#fn.refocus_mouse}

```rust
pub fn refocus_mouse(lost: bool) -> Result<()>
```

Gives the mouse back to the game; `lost` tells the engine the focus was lost.

- Parameters:
    - lost : `bool`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::mute_audio` {#fn.mute_audio}

```rust
pub fn mute_audio() -> Result<()>
```

Mutes the client's audio.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::unmute_audio` {#fn.unmute_audio}

```rust
pub fn unmute_audio() -> Result<()>
```

Unmutes the client's audio.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::fade_out_music` {#fn.fade_out_music}

```rust
pub fn fade_out_music() -> Result<()>
```

Fades out the music that is playing.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_gui_scale_offset` {#fn.set_gui_scale_offset}

```rust
pub fn set_gui_scale_offset(offset: i32) -> Result<()>
```

Sets the GUI scale offset.

- Parameters:
    - offset : `i32`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::reset_player_movement` {#fn.reset_player_movement}

```rust
pub fn reset_player_movement() -> Result<()>
```

Resets the local player's movement input.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::push_leave_game_screen` {#fn.push_leave_game_screen}

```rust
pub fn push_leave_game_screen() -> Result<()>
```

Opens the screen that asks whether to leave the world.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::open_content_log_history` {#fn.open_content_log_history}

```rust
pub fn open_content_log_history() -> Result<()>
```

Opens the content log history.

- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::set_clipboard` {#fn.set_clipboard}

```rust
pub fn set_clipboard(text: &str) -> Result<()>
```

Writes `text` to the system clipboard.

- Parameters:
    - text : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::navigate_how_to_play` {#fn.navigate_how_to_play}

```rust
pub fn navigate_how_to_play(topic: &str) -> Result<()>
```

Opens the How to Play screen at `topic`, or at its start for an empty topic.

- Parameters:
    - topic : `&str`
- Return type: `Result<()>`
- Slots: [`client_action`](../cpp/client.md#client_action)

### `client::options` {#fn.options}

```rust
pub fn options() -> Result<Vec<(String, String)>>
```

Every client option as `(key, value)` pairs, in the text form `options.txt` stores.

- Return type: `Result<Vec<(String, String)>>`
- Slots: [`client_option_list`](../cpp/client.md#client_option_list)

### `client::option` {#fn.option}

```rust
pub fn option(key: &str) -> Result<String>
```

One client option by its `options.txt` key, such as `"gfx_field_of_view"`.

- Parameters:
    - key : `&str`
- Return type: `Result<String>`
- Slots: [`client_option_get`](../cpp/client.md#client_option_get)

### `client::set_option` {#fn.set_option}

```rust
pub fn set_option(key: &str, value: &str) -> Result<()>
```

Writes one client option from its `options.txt` text form. The engine keeps what it can
parse and reports nothing, so a caller that needs to know reads the key back.

- Parameters:
    - key : `&str`
    - value : `&str`
- Return type: `Result<()>`
- Slots: [`client_option_set`](../cpp/client.md#client_option_set)

## `Client` {#Client}

```rust
pub struct Client;
```

The client as a value, for the property table below: `Client.health()` reads the local
player's health and `Client.is_mouse_grabbed()` asks the client instance.

- Implements: `Debug`, `Clone`, `Copy`, `Default`, `PartialEq`, `Eq`

### `Client::pos_x` {#Client.pos_x}

```rust
pub fn pos_x(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::pos_y` {#Client.pos_y}

```rust
pub fn pos_y(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::pos_z` {#Client.pos_z}

```rust
pub fn pos_z(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::pitch` {#Client.pitch}

```rust
pub fn pitch(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::yaw` {#Client.yaw}

```rust
pub fn yaw(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::dimension` {#Client.dimension}

```rust
pub fn dimension(&self) -> Result<i32>
```

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::gui_scale` {#Client.gui_scale}

```rust
pub fn gui_scale(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::server_ping_ms` {#Client.server_ping_ms}

```rust
pub fn server_ping_ms(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_menu` {#Client.is_showing_menu}

```rust
pub fn is_showing_menu(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_pause_screen` {#Client.is_showing_pause_screen}

```rust
pub fn is_showing_pause_screen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_playing` {#Client.is_playing}

```rust
pub fn is_playing(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_realm` {#Client.is_in_realm}

```rust
pub fn is_in_realm(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_game_input_enabled` {#Client.is_game_input_enabled}

```rust
pub fn is_game_input_enabled(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::health` {#Client.health}

```rust
pub fn health(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::max_health` {#Client.max_health}

```rust
pub fn max_health(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_on_ground` {#Client.is_on_ground}

```rust
pub fn is_on_ground(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_water` {#Client.is_in_water}

```rust
pub fn is_in_water(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_sneaking` {#Client.is_sneaking}

```rust
pub fn is_sneaking(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_sprinting` {#Client.is_sprinting}

```rust
pub fn is_sprinting(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_swimming` {#Client.is_swimming}

```rust
pub fn is_swimming(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_on_fire` {#Client.is_on_fire}

```rust
pub fn is_on_fire(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_flying` {#Client.is_flying}

```rust
pub fn is_flying(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::game_type` {#Client.game_type}

```rust
pub fn game_type(&self) -> Result<i32>
```

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::selected_slot` {#Client.selected_slot}

```rust
pub fn selected_slot(&self) -> Result<i32>
```

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::vel_x` {#Client.vel_x}

```rust
pub fn vel_x(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::vel_y` {#Client.vel_y}

```rust
pub fn vel_y(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::vel_z` {#Client.vel_z}

```rust
pub fn vel_z(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::xp_needed_next_level` {#Client.xp_needed_next_level}

```rust
pub fn xp_needed_next_level(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_leaving_game` {#Client.is_leaving_game}

```rust
pub fn is_leaving_game(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_exiting_level` {#Client.is_exiting_level}

```rust
pub fn is_exiting_level(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_bed_screen` {#Client.is_in_bed_screen}

```rust
pub fn is_in_bed_screen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_death_screen` {#Client.is_in_death_screen}

```rust
pub fn is_in_death_screen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_loading_screen` {#Client.is_showing_loading_screen}

```rust
pub fn is_showing_loading_screen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_progress_screen` {#Client.is_showing_progress_screen}

```rust
pub fn is_showing_progress_screen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_world_progress_screen` {#Client.is_showing_world_progress_screen}

```rust
pub fn is_showing_world_progress_screen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_death_screen` {#Client.is_showing_death_screen}

```rust
pub fn is_showing_death_screen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_showing_server_form` {#Client.is_showing_server_form}

```rust
pub fn is_showing_server_form(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_world_without_menu` {#Client.is_in_world_without_menu}

```rust
pub fn is_in_world_without_menu(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_world_active` {#Client.is_world_active}

```rust
pub fn is_world_active(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::has_level` {#Client.has_level}

```rust
pub fn has_level(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_pre_game` {#Client.is_pre_game}

```rust
pub fn is_pre_game(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_multiplayer_game` {#Client.is_in_multiplayer_game}

```rust
pub fn is_in_multiplayer_game(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_multiplayer_client` {#Client.is_multiplayer_client}

```rust
pub fn is_multiplayer_client(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_primary_level_multiplayer` {#Client.is_primary_level_multiplayer}

```rust
pub fn is_primary_level_multiplayer(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_primary_level_cross_platform` {#Client.is_primary_level_cross_platform}

```rust
pub fn is_primary_level_cross_platform(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_keyboard_enabled` {#Client.is_keyboard_enabled}

```rust
pub fn is_keyboard_enabled(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_using_controller` {#Client.is_using_controller}

```rust
pub fn is_using_controller(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_using_touchscreen` {#Client.is_using_touchscreen}

```rust
pub fn is_using_touchscreen(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_mouse_grabbed` {#Client.is_mouse_grabbed}

```rust
pub fn is_mouse_grabbed(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_mouse_and_keyboard` {#Client.is_mouse_and_keyboard}

```rust
pub fn is_mouse_and_keyboard(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::has_connected_controller` {#Client.has_connected_controller}

```rust
pub fn has_connected_controller(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::controller_id` {#Client.controller_id}

```rust
pub fn controller_id(&self) -> Result<i32>
```

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_touch_gameplay_allowed` {#Client.is_touch_gameplay_allowed}

```rust
pub fn is_touch_gameplay_allowed(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_split_screen_active` {#Client.is_split_screen_active}

```rust
pub fn is_split_screen_active(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::split_screen_count` {#Client.split_screen_count}

```rust
pub fn split_screen_count(&self) -> Result<i32>
```

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::gui_scale_offset` {#Client.gui_scale_offset}

```rust
pub fn gui_scale_offset(&self) -> Result<i32>
```

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_edu_mode` {#Client.is_edu_mode}

```rust
pub fn is_edu_mode(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_in_editor` {#Client.is_in_editor}

```rust
pub fn is_in_editor(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_ready_to_render` {#Client.is_ready_to_render}

```rust
pub fn is_ready_to_render(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_full_vanilla_pack_on_stack` {#Client.is_full_vanilla_pack_on_stack}

```rust
pub fn is_full_vanilla_pack_on_stack(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::server_connection_time` {#Client.server_connection_time}

```rust
pub fn server_connection_time(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::remote_server_time_ms` {#Client.remote_server_time_ms}

```rust
pub fn remote_server_time_ms(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::remote_server_network_time_ms` {#Client.remote_server_network_time_ms}

```rust
pub fn remote_server_network_time_ms(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::frame_alpha` {#Client.frame_alpha}

```rust
pub fn frame_alpha(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::game_update_seconds` {#Client.game_update_seconds}

```rust
pub fn game_update_seconds(&self) -> Result<f64>
```

- Return type: `Result<f64>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_primary_client` {#Client.is_primary_client}

```rust
pub fn is_primary_client(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::user_id` {#Client.user_id}

```rust
pub fn user_id(&self) -> Result<i32>
```

- Return type: `Result<i32>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::is_gameplay_tips_enabled` {#Client.is_gameplay_tips_enabled}

```rust
pub fn is_gameplay_tips_enabled(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::has_commands` {#Client.has_commands}

```rust
pub fn has_commands(&self) -> Result<bool>
```

- Return type: `Result<bool>`
- Slots: [`client_get_num`](../cpp/client.md#client_get_num)

### `Client::screen_name` {#Client.screen_name}

```rust
pub fn screen_name(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `Client::top_screen_name` {#Client.top_screen_name}

```rust
pub fn top_screen_name(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `Client::platform_id` {#Client.platform_id}

```rust
pub fn platform_id(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `Client::platform_online_id` {#Client.platform_online_id}

```rust
pub fn platform_online_id(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `Client::local_xuid` {#Client.local_xuid}

```rust
pub fn local_xuid(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `Client::local_uuid` {#Client.local_uuid}

```rust
pub fn local_uuid(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `Client::local_name_tag` {#Client.local_name_tag}

```rust
pub fn local_name_tag(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

### `Client::clipboard` {#Client.clipboard}

```rust
pub fn clipboard(&self) -> Result<String>
```

- Return type: `Result<String>`
- Slots: [`client_get_str`](../cpp/client.md#client_get_str)

## `KeyBinding` {#KeyBinding}

```rust
pub struct KeyBinding {
    // private fields
}
```

One registered hotkey. Dropping it deregisters.

- Implements: `Drop`, `Debug`

### `KeyBinding::name` {#KeyBinding.name}

```rust
pub fn name(&self) -> &str
```

- Return type: `&str`

### `KeyBinding::key_codes` {#KeyBinding.key_codes}

```rust
pub fn key_codes(&self) -> Result<Vec<i32>>
```

The key codes currently bound. They differ from the defaults once the player has
rebound them.

- Return type: `Result<Vec<i32>>`
- Slots: [`client_get_key_codes`](../cpp/client.md#client_get_key_codes)

### `KeyBinding::forget` {#KeyBinding.forget}

```rust
pub fn forget(mut self)
```

Keeps it alive until the mod unloads, when the host clears it.

## `KeyAction` {#KeyAction}

```rust
pub enum KeyAction {
        Up,
        Down,
        /// The host reported an action code this side does not recognize.
        Unknown(i32),
}
```

A key action.

- Implements: `Debug`, `Clone`, `Copy`, `PartialEq`, `Eq`

### `KeyAction::from_i32` {#KeyAction.from_i32}

```rust
pub fn from_i32(v: i32) -> KeyAction
```

- Parameters:
    - v : `i32`
- Return type: `KeyAction`

### `KeyAction::is_down` {#KeyAction.is_down}

```rust
pub fn is_down(self) -> bool
```

- Return type: `bool`
