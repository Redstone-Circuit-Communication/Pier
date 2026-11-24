//! Client-only capabilities.
//!
//! # On a server host this whole family is empty slots
//!
//! Not a compile error but a runtime `Err`. Contract §2.1: the layout is identical on every
//! target and an absent capability is a NULL slot, so the same mod source compiles for both
//! targets and loading onto the wrong one is refused explicitly by the host during the
//! handshake, from `mod_flags`.
//!
//! Decide with [`is_available`] and not with a `cfg`.
//!
//! # A callback runs on the client thread
//!
//! Not the server thread. A hotkey callback must not touch server state.

use core::ffi::c_void;

use crate::rt::accessors::accessors;
use crate::rt::error::{Error, Result};
use crate::rt::ffi::{call_out_str, collect_kv, collect_strs, s};
use crate::rt::handle::Handle;
use crate::rt::logger::Logger;
use crate::rt::runtime::rt;
use crate::sys;

/// A key action.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum KeyAction {
    Up,
    Down,
    /// The host reported an action code this side does not recognize.
    Unknown(i32),
}

impl KeyAction {
    pub fn from_i32(v: i32) -> KeyAction {
        match v {
            0 => KeyAction::Up,
            1 => KeyAction::Down,
            other => KeyAction::Unknown(other),
        }
    }

    pub fn is_down(self) -> bool {
        matches!(self, KeyAction::Down)
    }
}

/// Whether this host was built for the client target, meaning whether the `client_*` slots
/// are filled.
pub fn is_available() -> bool {
    crate::has_slot!(client_is_in_level)
}

/// Whether the client is currently in a world.
pub fn is_in_level() -> Result<bool> {
    let f = crate::require_slot!(
        client_is_in_level,
        "querying whether the client is in a world"
    );
    Ok(unsafe { f() })
}

/// The name of the local player. Not being in a world is an `Err`.
pub fn local_player_name() -> Result<String> {
    let f = crate::require_slot!(client_get_local_player, "reading the local player");
    call_out_str(|ctx, sink| unsafe { f(ctx, sink) })
        .ok_or_else(|| Error("the client is not in any world yet".to_owned()))
}

/// The current screen name, such as `"hud_screen"` or `"pause_screen"`.
pub fn screen_name() -> Result<String> {
    let f = crate::require_slot!(client_get_screen_name, "reading the current screen name");
    call_out_str(|ctx, sink| unsafe { f(ctx, sink) })
        .ok_or_else(|| Error("the current screen name could not be read".to_owned()))
}

/// One registered hotkey. Dropping it deregisters.
#[must_use = "dropping it deregisters the key; keep it, or call forget() to keep it until the mod unloads"]
pub struct KeyBinding {
    handle: Handle,
    forgotten: bool,
    name: String,
    /// Only held and dropped. It holds the `Box` of the two callbacks.
    owned: Option<Box<dyn std::any::Any + Send>>,
}

impl KeyBinding {
    pub fn name(&self) -> &str {
        &self.name
    }

    /// The key codes currently bound. They differ from the defaults once the player has
    /// rebound them.
    pub fn key_codes(&self) -> Result<Vec<i32>> {
        let f = crate::require_slot!(client_get_key_codes, "reading the key codes of a hotkey");
        let text = call_out_str(|ctx, sink| unsafe { f(self.handle.get(), ctx, sink) })
            .ok_or_else(|| {
                Error(format!(
                    "the key codes of hotkey {} could not be read",
                    self.name
                ))
            })?;
        // The host gives an array literal such as "[1,2,3]".
        Ok(text
            .trim()
            .trim_start_matches('[')
            .trim_end_matches(']')
            .split(',')
            .filter_map(|p| p.trim().parse::<i32>().ok())
            .collect())
    }

    /// Keeps it alive until the mod unloads, when the host clears it.
    pub fn forget(mut self) {
        if let Some(o) = self.owned.take() {
            std::mem::forget(o);
        }
        self.forgotten = true;
    }
}

impl Drop for KeyBinding {
    fn drop(&mut self) {
        if self.forgotten || self.handle.is_null() {
            return;
        }
        if !crate::has_slot!(client_unregister_key) {
            return;
        }
        let Some(f) = crate::__rt::api().client_unregister_key else {
            return;
        };
        if !unsafe { f(self.handle.get()) } {
            Logger::get().error(&format!(
                "deregistering hotkey {} failed; it may still be attached to the host, so the callbacks are leaked rather than freed.",
                self.name
            ));
            if let Some(o) = self.owned.take() {
                std::mem::forget(o);
            }
        }
    }
}

type KeyHandler = dyn FnMut(KeyAction, i32) + Send + 'static;

/// Registers a hotkey.
///
/// `key_codes` is the default binding and `allow_remap` decides whether the player may
/// change it in the settings.
/// The callback receives (action, focus impact) and both run on the client thread.
pub fn register_key(
    name: &str,
    key_codes: &[i32],
    allow_remap: bool,
    handler: impl FnMut(KeyAction, i32) + Send + 'static,
) -> Result<KeyBinding> {
    let f = crate::require_slot!(client_register_key, "registering a hotkey");
    let boxed: Box<Box<KeyHandler>> = Box::new(Box::new(handler));
    let user = Box::into_raw(boxed);
    let handle = unsafe {
        f(
            rt().handle(),
            s(name),
            key_codes.as_ptr(),
            key_codes.len() as i32,
            allow_remap,
            on_down,
            on_up,
            user.cast(),
        )
    };
    if handle.is_null() {
        drop(unsafe { Box::from_raw(user) });
        return Err(Error(format!(
            "registering hotkey {name} failed: the name is taken, or the key code list is empty"
        )));
    }
    Ok(KeyBinding {
        handle: Handle::new(handle),
        forgotten: false,
        name: name.to_owned(),
        owned: Some(unsafe { Box::from_raw(user) }),
    })
}

/// # Safety
/// `user` must come from the `Box<Box<KeyHandler>>::into_raw` inside `register_key`.
unsafe extern "C" fn on_down(
    user: *mut c_void,
    action: sys::PierKeyAction,
    impact: sys::PierFocusImpact,
) {
    dispatch(user, action, impact);
}

/// # Safety
/// As `on_down`.
unsafe extern "C" fn on_up(
    user: *mut c_void,
    action: sys::PierKeyAction,
    impact: sys::PierFocusImpact,
) {
    dispatch(user, action, impact);
}

/// Both entry points share one callback: the ABI wants a non-null function pointer for
/// down and for up, while the action code already tells press from release, and splitting
/// into two closures would only make a caller write it twice.
///
/// # Safety
/// `user` must come from that `Box<Box<KeyHandler>>::into_raw` inside `register_key`.
unsafe fn dispatch(user: *mut c_void, action: sys::PierKeyAction, impact: sys::PierFocusImpact) {
    if user.is_null() {
        return;
    }
    let f = &mut *(user as *mut Box<KeyHandler>);
    let outcome = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        f(KeyAction::from_i32(action), impact)
    }));
    if outcome.is_err() {
        Logger::get().error(
            "a hotkey callback panicked. It was caught here and this key press was discarded.",
        );
    }
}

/// One numeric client property by its `PIER_CPROP_*` key.
///
/// An `Err` covers a host without the slot, a key this host does not know, and a key about
/// the local player read while the client is not in a world.
pub fn property(prop: i32) -> Result<f64> {
    let f = crate::require_slot!(client_get_num, "reading a client property");
    let mut out = 0.0f64;
    if unsafe { f(prop, &mut out) } {
        Ok(out)
    } else {
        Err(Error(format!(
            "client property {prop} could not be read: this host does not know the key, or it needs a world the client is not in"
        )))
    }
}

fn flag(prop: i32) -> Result<bool> {
    Ok(property(prop)? != 0.0)
}

/// The local player's feet position as `[x, y, z]`, the point `get_player_position` reports.
pub fn local_position() -> Result<[f64; 3]> {
    Ok([
        property(sys::PIER_CPROP_POS_X)?,
        property(sys::PIER_CPROP_POS_Y)?,
        property(sys::PIER_CPROP_POS_Z)?,
    ])
}

/// The local player's `(pitch, yaw)` in degrees; a negative pitch looks up.
pub fn local_rotation() -> Result<(f32, f32)> {
    Ok((
        property(sys::PIER_CPROP_PITCH)? as f32,
        property(sys::PIER_CPROP_YAW)? as f32,
    ))
}

/// The id of the dimension the local player is in.
pub fn local_dimension() -> Result<i32> {
    Ok(property(sys::PIER_CPROP_DIMENSION)? as i32)
}

/// The GUI scale this client draws with.
pub fn gui_scale() -> Result<f32> {
    Ok(property(sys::PIER_CPROP_GUI_SCALE)? as f32)
}

/// The round trip to the server in milliseconds, as this client measures it.
pub fn server_ping_ms() -> Result<u64> {
    Ok(property(sys::PIER_CPROP_SERVER_PING_MS)?.max(0.0) as u64)
}

/// Whether a menu screen is showing.
pub fn is_showing_menu() -> Result<bool> {
    flag(sys::PIER_CPROP_IS_SHOWING_MENU)
}

/// Whether the pause screen is showing.
pub fn is_showing_pause_screen() -> Result<bool> {
    flag(sys::PIER_CPROP_IS_SHOWING_PAUSE_SCREEN)
}

/// Whether the client is playing a world.
pub fn is_playing() -> Result<bool> {
    flag(sys::PIER_CPROP_IS_PLAYING)
}

/// Whether the world is a Realm.
pub fn is_in_realm() -> Result<bool> {
    flag(sys::PIER_CPROP_IS_IN_REALM)
}

/// Whether game input reaches the world, which a screen on top takes away.
pub fn is_game_input_enabled() -> Result<bool> {
    flag(sys::PIER_CPROP_IS_GAME_INPUT_ENABLED)
}

/// The topmost screen of the client's screen stack.
pub fn top_screen_name() -> Result<String> {
    let f = crate::require_slot!(client_get_str, "reading the top screen name");
    call_out_str(|ctx, sink| unsafe { f(sys::PIER_CSTR_TOP_SCREEN_NAME, ctx, sink) })
        .ok_or_else(|| Error("the top screen name could not be read".to_owned()))
}

fn act(action: i32, text: &str, a: f64, b: f64, what: &str) -> Result<()> {
    let f = crate::require_slot!(client_action, "performing a client action");
    if unsafe { f(action, s(text), a, b, 0.0) } {
        Ok(())
    } else {
        Err(Error(format!(
            "{what} failed: the client has no world loaded, the text is empty, or this host does not know the action"
        )))
    }
}

/// Shows `text` in this client's chat. Nothing is sent to a server.
pub fn show_message(text: &str) -> Result<()> {
    act(
        sys::PIER_CACT_SHOW_MESSAGE,
        text,
        0.0,
        0.0,
        "showing a client message",
    )
}

/// Shows `text` as the title on this client.
pub fn set_title(text: &str) -> Result<()> {
    act(
        sys::PIER_CACT_SET_TITLE,
        text,
        0.0,
        0.0,
        "setting the title",
    )
}

/// Shows `text` as the subtitle on this client.
pub fn set_subtitle(text: &str) -> Result<()> {
    act(
        sys::PIER_CACT_SET_SUBTITLE,
        text,
        0.0,
        0.0,
        "setting the subtitle",
    )
}

/// Shows `text` above the hotbar on this client.
pub fn set_action_bar(text: &str) -> Result<()> {
    act(
        sys::PIER_CACT_SET_ACTION_BAR,
        text,
        0.0,
        0.0,
        "setting the action bar",
    )
}

/// Shows `text` as a tip on this client.
pub fn show_tip(text: &str) -> Result<()> {
    act(sys::PIER_CACT_SHOW_TIP, text, 0.0, 0.0, "showing a tip")
}

/// Plays a UI sound by name on this client, such as `"random.click"`.
pub fn play_ui_sound(name: &str, volume: f32, pitch: f32) -> Result<()> {
    act(
        sys::PIER_CACT_PLAY_UI_SOUND,
        name,
        f64::from(volume),
        f64::from(pitch),
        "playing a UI sound",
    )
}

/// Captures the mouse for the game, as a click into the world does.
pub fn grab_mouse() -> Result<()> {
    act(
        sys::PIER_CACT_GRAB_MOUSE,
        "",
        0.0,
        0.0,
        "grabbing the mouse",
    )
}

/// Releases the mouse to the screen.
pub fn release_mouse() -> Result<()> {
    act(
        sys::PIER_CACT_RELEASE_MOUSE,
        "",
        0.0,
        0.0,
        "releasing the mouse",
    )
}

/// Disables or enables game input.
pub fn set_input_disabled(disabled: bool) -> Result<()> {
    let a = if disabled { 1.0 } else { 0.0 };
    act(
        sys::PIER_CACT_SET_INPUT_DISABLED,
        "",
        a,
        0.0,
        "switching game input",
    )
}

/// Leaves the current world for the menus. The engine does it asynchronously.
pub fn leave_level() -> Result<()> {
    act(
        sys::PIER_CACT_LEAVE_LEVEL,
        "",
        0.0,
        0.0,
        "leaving the world",
    )
}

/// Every key binding name the key registry holds, whichever mod registered it.
pub fn registered_keys() -> Result<Vec<String>> {
    let f = crate::require_slot!(client_list_keys, "listing the registered key bindings");
    Ok(collect_strs(|ctx, sink| {
        unsafe { f(ctx, sink) };
    }))
}

/// Whether a key binding of this name is registered.
pub fn has_key(name: &str) -> Result<bool> {
    Ok(registered_keys()?.iter().any(|k| k == name))
}

fn text_property(prop: i32) -> Result<String> {
    let f = crate::require_slot!(client_get_str, "reading a client text property");
    call_out_str(|ctx, sink| unsafe { f(prop, ctx, sink) }).ok_or_else(|| {
        Error(format!(
            "client text property {prop} could not be read: this host does not know the key, or it needs a world the client is not in"
        ))
    })
}

/// The client as a value, for the property table below: `Client.health()` reads the local
/// player's health and `Client.is_mouse_grabbed()` asks the client instance.
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct Client;

impl Client {
    fn num(&self, prop: i32) -> Result<f64> {
        property(prop)
    }

    fn text(&self, prop: i32) -> Result<String> {
        text_property(prop)
    }
}

accessors! { Client;
    f64  pos_x                              = PIER_CPROP_POS_X;
    f64  pos_y                              = PIER_CPROP_POS_Y;
    f64  pos_z                              = PIER_CPROP_POS_Z;
    f64  pitch                              = PIER_CPROP_PITCH;
    f64  yaw                                = PIER_CPROP_YAW;
    i32  dimension                          = PIER_CPROP_DIMENSION;
    f64  gui_scale                          = PIER_CPROP_GUI_SCALE;
    f64  server_ping_ms                     = PIER_CPROP_SERVER_PING_MS;
    bool is_showing_menu                    = PIER_CPROP_IS_SHOWING_MENU;
    bool is_showing_pause_screen            = PIER_CPROP_IS_SHOWING_PAUSE_SCREEN;
    bool is_playing                         = PIER_CPROP_IS_PLAYING;
    bool is_in_realm                        = PIER_CPROP_IS_IN_REALM;
    bool is_game_input_enabled              = PIER_CPROP_IS_GAME_INPUT_ENABLED;
    f64  health                             = PIER_CPROP_HEALTH;
    f64  max_health                         = PIER_CPROP_MAX_HEALTH;
    bool is_on_ground                       = PIER_CPROP_IS_ON_GROUND;
    bool is_in_water                        = PIER_CPROP_IS_IN_WATER;
    bool is_sneaking                        = PIER_CPROP_IS_SNEAKING;
    bool is_sprinting                       = PIER_CPROP_IS_SPRINTING;
    bool is_swimming                        = PIER_CPROP_IS_SWIMMING;
    bool is_on_fire                         = PIER_CPROP_IS_ON_FIRE;
    bool is_flying                          = PIER_CPROP_IS_FLYING;
    i32  game_type                          = PIER_CPROP_GAME_TYPE;
    i32  selected_slot                      = PIER_CPROP_SELECTED_SLOT;
    f64  vel_x                              = PIER_CPROP_VEL_X;
    f64  vel_y                              = PIER_CPROP_VEL_Y;
    f64  vel_z                              = PIER_CPROP_VEL_Z;
    f64  xp_needed_next_level               = PIER_CPROP_XP_NEEDED_NEXT_LEVEL;
    bool is_leaving_game                    = PIER_CPROP_IS_LEAVING_GAME;
    bool is_exiting_level                   = PIER_CPROP_IS_EXITING_LEVEL;
    bool is_in_bed_screen                   = PIER_CPROP_IS_IN_BED_SCREEN;
    bool is_in_death_screen                 = PIER_CPROP_IS_IN_DEATH_SCREEN;
    bool is_showing_loading_screen          = PIER_CPROP_IS_SHOWING_LOADING_SCREEN;
    bool is_showing_progress_screen         = PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN;
    bool is_showing_world_progress_screen   = PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN;
    bool is_showing_death_screen            = PIER_CPROP_IS_SHOWING_DEATH_SCREEN;
    bool is_showing_server_form             = PIER_CPROP_IS_SHOWING_SERVER_FORM;
    bool is_in_world_without_menu           = PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU;
    bool is_world_active                    = PIER_CPROP_IS_WORLD_ACTIVE;
    bool has_level                          = PIER_CPROP_HAS_LEVEL;
    bool is_pre_game                        = PIER_CPROP_IS_PRE_GAME;
    bool is_in_multiplayer_game             = PIER_CPROP_IS_IN_MULTIPLAYER_GAME;
    bool is_multiplayer_client              = PIER_CPROP_IS_MULTIPLAYER_CLIENT;
    bool is_primary_level_multiplayer       = PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER;
    bool is_primary_level_cross_platform    = PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM;
    bool is_keyboard_enabled                = PIER_CPROP_IS_KEYBOARD_ENABLED;
    bool is_using_controller                = PIER_CPROP_IS_USING_CONTROLLER;
    bool is_using_touchscreen               = PIER_CPROP_IS_USING_TOUCHSCREEN;
    bool is_mouse_grabbed                   = PIER_CPROP_IS_MOUSE_GRABBED;
    bool is_mouse_and_keyboard              = PIER_CPROP_IS_MOUSE_AND_KEYBOARD;
    bool has_connected_controller           = PIER_CPROP_HAS_CONNECTED_CONTROLLER;
    i32  controller_id                      = PIER_CPROP_CONTROLLER_ID;
    bool is_touch_gameplay_allowed          = PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED;
    bool is_split_screen_active             = PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE;
    i32  split_screen_count                 = PIER_CPROP_SPLIT_SCREEN_COUNT;
    i32  gui_scale_offset                   = PIER_CPROP_GUI_SCALE_OFFSET;
    bool is_edu_mode                        = PIER_CPROP_IS_EDU_MODE;
    bool is_in_editor                       = PIER_CPROP_IS_IN_EDITOR;
    bool is_ready_to_render                 = PIER_CPROP_IS_READY_TO_RENDER;
    bool is_full_vanilla_pack_on_stack      = PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK;
    f64  server_connection_time             = PIER_CPROP_SERVER_CONNECTION_TIME;
    f64  remote_server_time_ms              = PIER_CPROP_REMOTE_SERVER_TIME_MS;
    f64  remote_server_network_time_ms      = PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS;
    f64  frame_alpha                        = PIER_CPROP_FRAME_ALPHA;
    f64  game_update_seconds                = PIER_CPROP_GAME_UPDATE_SECONDS;
    bool is_primary_client                  = PIER_CPROP_IS_PRIMARY_CLIENT;
    i32  user_id                            = PIER_CPROP_USER_ID;
    bool is_gameplay_tips_enabled           = PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED;
    bool has_commands                       = PIER_CPROP_HAS_COMMANDS;
    str  screen_name                        = PIER_CSTR_SCREEN_NAME;
    str  top_screen_name                    = PIER_CSTR_TOP_SCREEN_NAME;
    str  platform_id                        = PIER_CSTR_PLATFORM_ID;
    str  platform_online_id                 = PIER_CSTR_PLATFORM_ONLINE_ID;
    str  local_xuid                         = PIER_CSTR_LOCAL_XUID;
    str  local_uuid                         = PIER_CSTR_LOCAL_UUID;
    str  local_name_tag                     = PIER_CSTR_LOCAL_NAME_TAG;
    str  clipboard                          = PIER_CSTR_CLIPBOARD;
}

/// Shows a popup with an optional subtitle on this client.
pub fn show_popup(message: &str, subtitle: &str) -> Result<()> {
    let text = if subtitle.is_empty() {
        message.to_owned()
    } else {
        format!("{message}\n{subtitle}")
    };
    act(
        sys::PIER_CACT_SHOW_POPUP,
        &text,
        0.0,
        0.0,
        "showing a popup",
    )
}

/// Writes `text` to the client's developer console.
pub fn show_dev_console_message(text: &str) -> Result<()> {
    act(
        sys::PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE,
        text,
        0.0,
        0.0,
        "writing to the dev console",
    )
}

/// Suspends or resumes all input.
pub fn set_suspend_input(suspended: bool) -> Result<()> {
    act(
        sys::PIER_CACT_SET_SUSPEND_INPUT,
        "",
        f64::from(u8::from(suspended)),
        0.0,
        "suspending input",
    )
}

/// Suspends or resumes movement input.
pub fn set_suspend_directional_input(suspended: bool) -> Result<()> {
    act(
        sys::PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT,
        "",
        f64::from(u8::from(suspended)),
        0.0,
        "suspending movement input",
    )
}

/// Enables or disables game input.
pub fn set_game_input_enabled(enabled: bool) -> Result<()> {
    act(
        sys::PIER_CACT_SET_GAME_INPUT_ENABLED,
        "",
        f64::from(u8::from(enabled)),
        0.0,
        "switching game input",
    )
}

/// Gives the mouse back to the game; `lost` tells the engine the focus was lost.
pub fn refocus_mouse(lost: bool) -> Result<()> {
    act(
        sys::PIER_CACT_REFOCUS_MOUSE,
        "",
        f64::from(u8::from(lost)),
        0.0,
        "refocusing the mouse",
    )
}

/// Mutes the client's audio.
pub fn mute_audio() -> Result<()> {
    act(sys::PIER_CACT_MUTE_AUDIO, "", 0.0, 0.0, "muting audio")
}

/// Unmutes the client's audio.
pub fn unmute_audio() -> Result<()> {
    act(sys::PIER_CACT_UNMUTE_AUDIO, "", 0.0, 0.0, "unmuting audio")
}

/// Fades out the music that is playing.
pub fn fade_out_music() -> Result<()> {
    act(
        sys::PIER_CACT_FADE_OUT_MUSIC,
        "",
        0.0,
        0.0,
        "fading out music",
    )
}

/// Sets the GUI scale offset.
pub fn set_gui_scale_offset(offset: i32) -> Result<()> {
    act(
        sys::PIER_CACT_SET_GUI_SCALE_OFFSET,
        "",
        f64::from(offset),
        0.0,
        "setting the GUI scale offset",
    )
}

/// Resets the local player's movement input.
pub fn reset_player_movement() -> Result<()> {
    act(
        sys::PIER_CACT_RESET_PLAYER_MOVEMENT,
        "",
        0.0,
        0.0,
        "resetting player movement",
    )
}

/// Opens the screen that asks whether to leave the world.
pub fn push_leave_game_screen() -> Result<()> {
    act(
        sys::PIER_CACT_PUSH_LEAVE_GAME_SCREEN,
        "",
        0.0,
        0.0,
        "opening the leave-game screen",
    )
}

/// Opens the content log history.
pub fn open_content_log_history() -> Result<()> {
    act(
        sys::PIER_CACT_OPEN_CONTENT_LOG_HISTORY,
        "",
        0.0,
        0.0,
        "opening the content log",
    )
}

/// Writes `text` to the system clipboard.
pub fn set_clipboard(text: &str) -> Result<()> {
    act(
        sys::PIER_CACT_SET_CLIPBOARD,
        text,
        0.0,
        0.0,
        "writing the clipboard",
    )
}

/// Opens the How to Play screen at `topic`, or at its start for an empty topic.
pub fn navigate_how_to_play(topic: &str) -> Result<()> {
    act(
        sys::PIER_CACT_NAVIGATE_HOW_TO_PLAY,
        topic,
        0.0,
        0.0,
        "opening How to Play",
    )
}

/// Every client option as `(key, value)` pairs, in the text form `options.txt` stores.
pub fn options() -> Result<Vec<(String, String)>> {
    let f = crate::require_slot!(client_option_list, "listing the client options");
    let mut ok = false;
    let pairs = collect_kv(|ctx, sink| ok = unsafe { f(ctx, sink) });
    if ok {
        Ok(pairs)
    } else {
        Err(Error(
            "the client options could not be listed: the client has no instance yet".to_owned(),
        ))
    }
}

/// One client option by its `options.txt` key, such as `"gfx_field_of_view"`.
pub fn option(key: &str) -> Result<String> {
    let f = crate::require_slot!(client_option_get, "reading a client option");
    call_out_str(|ctx, sink| unsafe { f(s(key), ctx, sink) }).ok_or_else(|| {
        Error(format!(
            "the client option {key} does not exist, or the client has no instance yet"
        ))
    })
}

/// Writes one client option from its `options.txt` text form. The engine keeps what it can
/// parse and reports nothing, so a caller that needs to know reads the key back.
pub fn set_option(key: &str, value: &str) -> Result<()> {
    let f = crate::require_slot!(client_option_set, "writing a client option");
    if unsafe { f(s(key), s(value)) } {
        Ok(())
    } else {
        Err(Error(format!(
            "the client option {key} was not written: it does not exist, it cannot be changed now, or the client has no instance yet"
        )))
    }
}

impl core::fmt::Debug for KeyBinding {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("KeyBinding")
            .field("name", &self.name)
            .field("forgotten", &self.forgotten)
            .finish_non_exhaustive()
    }
}
