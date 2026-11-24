//! The second client group: the local player, the screens, the HUD and the key registry.
//! Every function returns error.NotProvided on a server host or an older client host.

const std = @import("std");
const core = @import("core.zig");
const c = core.c;

/// One numeric client property by its PIER_CPROP_* key. NoAnswer for a key this host does
/// not know, or a key about the local player while the client is not in a world.
pub fn property(prop: i32) core.Error!f64 {
    const get = core.slot("client_get_num") orelse return error.NotProvided;
    var out: f64 = 0;
    if (!get(prop, &out)) return error.NoAnswer;
    return out;
}

fn flag(prop: i32) core.Error!bool {
    return (try property(prop)) != 0;
}

/// The local player's feet position: x, y and z.
pub fn localPosition() core.Error![3]f64 {
    return .{ try property(c.PIER_CPROP_POS_X), try property(c.PIER_CPROP_POS_Y), try property(c.PIER_CPROP_POS_Z) };
}

/// The local player's pitch and yaw in degrees; a negative pitch looks up.
pub fn localRotation() core.Error![2]f64 {
    return .{ try property(c.PIER_CPROP_PITCH), try property(c.PIER_CPROP_YAW) };
}

/// The id of the dimension the local player is in.
pub fn localDimension() core.Error!i32 {
    return @intFromFloat(try property(c.PIER_CPROP_DIMENSION));
}

/// The GUI scale this client draws with.
pub fn guiScale() core.Error!f64 {
    return property(c.PIER_CPROP_GUI_SCALE);
}

/// The round trip to the server in milliseconds, as this client measures it.
pub fn serverPingMs() core.Error!f64 {
    return property(c.PIER_CPROP_SERVER_PING_MS);
}

/// Whether a menu screen is showing.
pub fn isShowingMenu() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SHOWING_MENU);
}

/// Whether the pause screen is showing.
pub fn isShowingPauseScreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SHOWING_PAUSE_SCREEN);
}

/// Whether the client is playing a world.
pub fn isPlaying() core.Error!bool {
    return flag(c.PIER_CPROP_IS_PLAYING);
}

/// Whether the world is a Realm.
pub fn isInRealm() core.Error!bool {
    return flag(c.PIER_CPROP_IS_IN_REALM);
}

/// Whether game input reaches the world, which a screen on top takes away.
pub fn isGameInputEnabled() core.Error!bool {
    return flag(c.PIER_CPROP_IS_GAME_INPUT_ENABLED);
}

/// Copies of what a string sink received, allocated with the caller's allocator.
const Texts = struct {
    allocator: std.mem.Allocator,
    items: std.ArrayList([]u8) = .empty,
    failed: bool = false,

    fn sink(ctx: ?*anyopaque, s: c.PierStr) callconv(.c) void {
        const self: *Texts = @ptrCast(@alignCast(ctx.?));
        const copy = self.allocator.dupe(u8, core.view(s)) catch {
            self.failed = true;
            return;
        };
        self.items.append(self.allocator, copy) catch {
            self.allocator.free(copy);
            self.failed = true;
        };
    }

    fn deinit(self: *Texts) void {
        for (self.items.items) |item| self.allocator.free(item);
        self.items.deinit(self.allocator);
    }
};

/// The topmost screen of the client's screen stack, owned by the caller.
pub fn topScreenName(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    const get = core.slot("client_get_str") orelse return error.NotProvided;
    var out = Texts{ .allocator = allocator };
    defer out.deinit();
    if (!get(c.PIER_CSTR_TOP_SCREEN_NAME, &out, &Texts.sink)) return error.NoAnswer;
    if (out.failed) return error.OutOfMemory;
    return out.items.pop() orelse error.NoAnswer;
}

/// Every key binding name the key registry holds, whichever mod registered it. The caller
/// frees each name and the slice.
pub fn registeredKeys(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![][]u8 {
    const list = core.slot("client_list_keys") orelse return error.NotProvided;
    var out = Texts{ .allocator = allocator };
    defer out.deinit();
    if (!list(&out, &Texts.sink)) return error.NoAnswer;
    if (out.failed) return error.OutOfMemory;
    return out.items.toOwnedSlice(allocator);
}

fn act(action: i32, text: []const u8, a: f64, b: f64) core.Error!void {
    const run = core.slot("client_action") orelse return error.NotProvided;
    if (!run(action, core.str(text), a, b, 0)) return error.Refused;
}

/// Shows text in this client's chat. Nothing is sent to a server.
pub fn showMessage(text: []const u8) core.Error!void {
    return act(c.PIER_CACT_SHOW_MESSAGE, text, 0, 0);
}

/// Shows text as the title on this client.
pub fn setTitle(text: []const u8) core.Error!void {
    return act(c.PIER_CACT_SET_TITLE, text, 0, 0);
}

/// Shows text as the subtitle on this client.
pub fn setSubtitle(text: []const u8) core.Error!void {
    return act(c.PIER_CACT_SET_SUBTITLE, text, 0, 0);
}

/// Shows text above the hotbar on this client.
pub fn setActionBar(text: []const u8) core.Error!void {
    return act(c.PIER_CACT_SET_ACTION_BAR, text, 0, 0);
}

/// Shows text as a tip on this client.
pub fn showTip(text: []const u8) core.Error!void {
    return act(c.PIER_CACT_SHOW_TIP, text, 0, 0);
}

/// Plays a UI sound by name on this client, such as "random.click".
pub fn playUiSound(name: []const u8, volume: f64, pitch: f64) core.Error!void {
    return act(c.PIER_CACT_PLAY_UI_SOUND, name, volume, pitch);
}

/// Captures the mouse for the game, as a click into the world does.
pub fn grabMouse() core.Error!void {
    return act(c.PIER_CACT_GRAB_MOUSE, "", 0, 0);
}

/// Releases the mouse to the screen.
pub fn releaseMouse() core.Error!void {
    return act(c.PIER_CACT_RELEASE_MOUSE, "", 0, 0);
}

/// Disables or enables game input.
pub fn setInputDisabled(disabled: bool) core.Error!void {
    return act(c.PIER_CACT_SET_INPUT_DISABLED, "", if (disabled) 1 else 0, 0);
}

/// Leaves the current world for the menus. The engine does it asynchronously.
pub fn leaveLevel() core.Error!void {
    return act(c.PIER_CACT_LEAVE_LEVEL, "", 0, 0);
}

/// Actor::getHealth of the local player
pub fn health() core.Error!f64 {
    return property(c.PIER_CPROP_HEALTH);
}

/// Actor::getMaxHealth of the local player
pub fn maxHealth() core.Error!f64 {
    return property(c.PIER_CPROP_MAX_HEALTH);
}

/// Actor::isOnGround of the local player
pub fn isOnGround() core.Error!bool {
    return flag(c.PIER_CPROP_IS_ON_GROUND);
}

/// Actor::isInWater of the local player
pub fn isInWater() core.Error!bool {
    return flag(c.PIER_CPROP_IS_IN_WATER);
}

/// Actor::isSneaking of the local player
pub fn isSneaking() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SNEAKING);
}

/// Actor::isSprinting of the local player
pub fn isSprinting() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SPRINTING);
}

/// Actor::isSwimming of the local player
pub fn isSwimming() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SWIMMING);
}

/// Actor::isOnFire of the local player
pub fn isOnFire() core.Error!bool {
    return flag(c.PIER_CPROP_IS_ON_FIRE);
}

/// Player::isFlying of the local player
pub fn isFlying() core.Error!bool {
    return flag(c.PIER_CPROP_IS_FLYING);
}

/// Player::getPlayerGameType of the local player
pub fn gameType() core.Error!f64 {
    return property(c.PIER_CPROP_GAME_TYPE);
}

/// Player::getSelectedItemSlot of the local player
pub fn selectedSlot() core.Error!f64 {
    return property(c.PIER_CPROP_SELECTED_SLOT);
}

/// Actor::getPosDelta of the local player, blocks per tick
pub fn velX() core.Error!f64 {
    return property(c.PIER_CPROP_VEL_X);
}

/// Actor::getPosDelta, the vertical part
pub fn velY() core.Error!f64 {
    return property(c.PIER_CPROP_VEL_Y);
}

/// Actor::getPosDelta, the z part
pub fn velZ() core.Error!f64 {
    return property(c.PIER_CPROP_VEL_Z);
}

/// Player::getXpNeededForNextLevel of the local player
pub fn xpNeededNextLevel() core.Error!f64 {
    return property(c.PIER_CPROP_XP_NEEDED_NEXT_LEVEL);
}

/// IClientInstance::isLeavingGame
pub fn isLeavingGame() core.Error!bool {
    return flag(c.PIER_CPROP_IS_LEAVING_GAME);
}

/// IClientInstance::isExitingLevel
pub fn isExitingLevel() core.Error!bool {
    return flag(c.PIER_CPROP_IS_EXITING_LEVEL);
}

/// IClientInstance::isInBedScreen
pub fn isInBedScreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_IN_BED_SCREEN);
}

/// IClientInstance::isInDeathScreen
pub fn isInDeathScreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_IN_DEATH_SCREEN);
}

/// IClientInstance::isShowingLoadingScreen
pub fn isShowingLoadingScreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SHOWING_LOADING_SCREEN);
}

/// IClientInstance::isShowingProgressScreen
pub fn isShowingProgressScreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN);
}

/// IClientInstance::isShowingWorldProgressScreen
pub fn isShowingWorldProgressScreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN);
}

/// IClientInstance::isShowingDeathScreen
pub fn isShowingDeathScreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SHOWING_DEATH_SCREEN);
}

/// IClientInstance::isShowingServerForm
pub fn isShowingServerForm() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SHOWING_SERVER_FORM);
}

/// IClientInstance::isInWorldAndNotShowingAnyMenuScreens
pub fn isInWorldWithoutMenu() core.Error!bool {
    return flag(c.PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU);
}

/// IClientInstance::isWorldActive
pub fn isWorldActive() core.Error!bool {
    return flag(c.PIER_CPROP_IS_WORLD_ACTIVE);
}

/// IClientInstance::hasLevel
pub fn hasLevel() core.Error!bool {
    return flag(c.PIER_CPROP_HAS_LEVEL);
}

/// IClientInstance::isPreGame
pub fn isPreGame() core.Error!bool {
    return flag(c.PIER_CPROP_IS_PRE_GAME);
}

/// IClientInstance::isInMultiplayerGame
pub fn isInMultiplayerGame() core.Error!bool {
    return flag(c.PIER_CPROP_IS_IN_MULTIPLAYER_GAME);
}

/// IClientInstance::isMultiPlayerClient
pub fn isMultiplayerClient() core.Error!bool {
    return flag(c.PIER_CPROP_IS_MULTIPLAYER_CLIENT);
}

/// IClientInstance::isPrimaryLevelMultiplayer
pub fn isPrimaryLevelMultiplayer() core.Error!bool {
    return flag(c.PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER);
}

/// IClientInstance::isPrimaryLevelCrossPlatformMultiplayer
pub fn isPrimaryLevelCrossPlatform() core.Error!bool {
    return flag(c.PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM);
}

/// IClientInstance::isKeyboardEnabled
pub fn isKeyboardEnabled() core.Error!bool {
    return flag(c.PIER_CPROP_IS_KEYBOARD_ENABLED);
}

/// IClientInstance::useController
pub fn isUsingController() core.Error!bool {
    return flag(c.PIER_CPROP_IS_USING_CONTROLLER);
}

/// IClientInstance::useTouchscreen
pub fn isUsingTouchscreen() core.Error!bool {
    return flag(c.PIER_CPROP_IS_USING_TOUCHSCREEN);
}

/// IClientInstance::getMouseGrabbed
pub fn isMouseGrabbed() core.Error!bool {
    return flag(c.PIER_CPROP_IS_MOUSE_GRABBED);
}

/// IClientInstance::currentInputModeIsMouseAndKeyboard
pub fn isMouseAndKeyboard() core.Error!bool {
    return flag(c.PIER_CPROP_IS_MOUSE_AND_KEYBOARD);
}

/// IClientInstance::hasConnectedController
pub fn hasConnectedController() core.Error!bool {
    return flag(c.PIER_CPROP_HAS_CONNECTED_CONTROLLER);
}

/// IClientInstance::getControllerId
pub fn controllerId() core.Error!f64 {
    return property(c.PIER_CPROP_CONTROLLER_ID);
}

/// IClientInstance::isTouchGameplayAllowed
pub fn isTouchGameplayAllowed() core.Error!bool {
    return flag(c.PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED);
}

/// IClientInstance::isSplitScreenActive
pub fn isSplitScreenActive() core.Error!bool {
    return flag(c.PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE);
}

/// IClientInstance::getSplitScreenCount
pub fn splitScreenCount() core.Error!f64 {
    return property(c.PIER_CPROP_SPLIT_SCREEN_COUNT);
}

/// IClientInstance::getGuiScaleOffset
pub fn guiScaleOffset() core.Error!f64 {
    return property(c.PIER_CPROP_GUI_SCALE_OFFSET);
}

/// IClientInstance::isEduMode
pub fn isEduMode() core.Error!bool {
    return flag(c.PIER_CPROP_IS_EDU_MODE);
}

/// IClientInstance::isPlayerInEditor
pub fn isInEditor() core.Error!bool {
    return flag(c.PIER_CPROP_IS_IN_EDITOR);
}

/// IClientInstance::isReadyToRender
pub fn isReadyToRender() core.Error!bool {
    return flag(c.PIER_CPROP_IS_READY_TO_RENDER);
}

/// IClientInstance::isFullVanillaPackOnStack
pub fn isFullVanillaPackOnStack() core.Error!bool {
    return flag(c.PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK);
}

/// IClientInstance::getServerConnectionTime
pub fn serverConnectionTime() core.Error!f64 {
    return property(c.PIER_CPROP_SERVER_CONNECTION_TIME);
}

/// IClientInstance::getRemoteServerTimeMs
pub fn remoteServerTimeMs() core.Error!f64 {
    return property(c.PIER_CPROP_REMOTE_SERVER_TIME_MS);
}

/// IClientInstance::getRemoteServerNetworkTimeMs
pub fn remoteServerNetworkTimeMs() core.Error!f64 {
    return property(c.PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS);
}

/// IClientInstance::getFrameAlpha, how far the frame is between two ticks
pub fn frameAlpha() core.Error!f64 {
    return property(c.PIER_CPROP_FRAME_ALPHA);
}

/// IClientInstance::getGameUpdateDurationInSeconds
pub fn gameUpdateSeconds() core.Error!f64 {
    return property(c.PIER_CPROP_GAME_UPDATE_SECONDS);
}

/// IClientInstance::isPrimaryClient
pub fn isPrimaryClient() core.Error!bool {
    return flag(c.PIER_CPROP_IS_PRIMARY_CLIENT);
}

/// IClientInstance::getUserId
pub fn userId() core.Error!f64 {
    return property(c.PIER_CPROP_USER_ID);
}

/// IClientInstance::isGamePlayTipsEnabled
pub fn isGameplayTipsEnabled() core.Error!bool {
    return flag(c.PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED);
}

/// IClientInstance::hasCommands
pub fn hasCommands() core.Error!bool {
    return flag(c.PIER_CPROP_HAS_COMMANDS);
}

fn readText(prop: i32, allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    const get = core.slot("client_get_str") orelse return error.NotProvided;
    var out = Texts{ .allocator = allocator };
    defer out.deinit();
    if (!get(prop, &out, &Texts.sink)) return error.NoAnswer;
    if (out.failed) return error.OutOfMemory;
    return out.items.pop() orelse error.NoAnswer;
}

/// IClientInstance::getPlatformId
pub fn platformId(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    return readText(c.PIER_CSTR_PLATFORM_ID, allocator);
}

/// IClientInstance::getPlatformOnlineId
pub fn platformOnlineId(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    return readText(c.PIER_CSTR_PLATFORM_ONLINE_ID, allocator);
}

/// Player::getXuid of the local player; fails outside a world
pub fn localXuid(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    return readText(c.PIER_CSTR_LOCAL_XUID, allocator);
}

/// Player::getUuid of the local player in its canonical form
pub fn localUuid(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    return readText(c.PIER_CSTR_LOCAL_UUID, allocator);
}

/// Actor::getNameTag of the local player
pub fn localNameTag(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    return readText(c.PIER_CSTR_LOCAL_NAME_TAG, allocator);
}

/// AppPlatform::getClipboardText, the system clipboard
pub fn clipboard(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    return readText(c.PIER_CSTR_CLIPBOARD, allocator);
}

/// Shows a popup; a newline in text separates the message from a subtitle.
pub fn showPopup(text: []const u8) core.Error!void {
    return act(c.PIER_CACT_SHOW_POPUP, text, 0, 0);
}

/// Writes text to the developer console.
pub fn showDevConsoleMessage(text: []const u8) core.Error!void {
    return act(c.PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE, text, 0, 0);
}

/// Suspends or resumes all input.
pub fn setSuspendInput(suspended: bool) core.Error!void {
    return act(c.PIER_CACT_SET_SUSPEND_INPUT, "", if (suspended) 1 else 0, 0);
}

/// Suspends or resumes movement input.
pub fn setSuspendDirectionalInput(suspended: bool) core.Error!void {
    return act(c.PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT, "", if (suspended) 1 else 0, 0);
}

/// Enables or disables game input.
pub fn setGameInputEnabled(enabled: bool) core.Error!void {
    return act(c.PIER_CACT_SET_GAME_INPUT_ENABLED, "", if (enabled) 1 else 0, 0);
}

/// Gives the mouse back to the game.
pub fn refocusMouse(lost: bool) core.Error!void {
    return act(c.PIER_CACT_REFOCUS_MOUSE, "", if (lost) 1 else 0, 0);
}

/// Mutes the client audio.
pub fn muteAudio() core.Error!void {
    return act(c.PIER_CACT_MUTE_AUDIO, "", 0, 0);
}

/// Unmutes the client audio.
pub fn unmuteAudio() core.Error!void {
    return act(c.PIER_CACT_UNMUTE_AUDIO, "", 0, 0);
}

/// Fades out the music that is playing.
pub fn fadeOutMusic() core.Error!void {
    return act(c.PIER_CACT_FADE_OUT_MUSIC, "", 0, 0);
}

/// Sets the GUI scale offset.
pub fn setGuiScaleOffset(offset: i32) core.Error!void {
    return act(c.PIER_CACT_SET_GUI_SCALE_OFFSET, "", @floatFromInt(offset), 0);
}

/// Resets the movement input of the local player.
pub fn resetPlayerMovement() core.Error!void {
    return act(c.PIER_CACT_RESET_PLAYER_MOVEMENT, "", 0, 0);
}

/// Opens the screen that asks whether to leave the world.
pub fn pushLeaveGameScreen() core.Error!void {
    return act(c.PIER_CACT_PUSH_LEAVE_GAME_SCREEN, "", 0, 0);
}

/// Opens the content log history.
pub fn openContentLogHistory() core.Error!void {
    return act(c.PIER_CACT_OPEN_CONTENT_LOG_HISTORY, "", 0, 0);
}

/// Writes value to the system clipboard.
pub fn setClipboard(value: []const u8) core.Error!void {
    return act(c.PIER_CACT_SET_CLIPBOARD, value, 0, 0);
}

/// Opens How to Play at topic, or at its start for an empty topic.
pub fn navigateHowToPlay(topic: []const u8) core.Error!void {
    return act(c.PIER_CACT_NAVIGATE_HOW_TO_PLAY, topic, 0, 0);
}

/// One client option: its options.txt key and its value in that text form.
pub const OptionPair = struct {
    key: []u8,
    value: []u8,
};

const Pairs = struct {
    allocator: std.mem.Allocator,
    items: std.ArrayList(OptionPair) = .empty,
    failed: bool = false,

    fn sink(ctx: ?*anyopaque, k: c.PierStr, v: c.PierStr) callconv(.c) void {
        const self: *Pairs = @ptrCast(@alignCast(ctx.?));
        const key_copy = self.allocator.dupe(u8, core.view(k)) catch {
            self.failed = true;
            return;
        };
        const value_copy = self.allocator.dupe(u8, core.view(v)) catch {
            self.allocator.free(key_copy);
            self.failed = true;
            return;
        };
        self.items.append(self.allocator, .{ .key = key_copy, .value = value_copy }) catch {
            self.allocator.free(key_copy);
            self.allocator.free(value_copy);
            self.failed = true;
        };
    }

    fn deinit(self: *Pairs) void {
        for (self.items.items) |pair| {
            self.allocator.free(pair.key);
            self.allocator.free(pair.value);
        }
        self.items.deinit(self.allocator);
    }
};

/// Every client option. The caller frees each key, each value and the slice.
pub fn options(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]OptionPair {
    const list = core.slot("client_option_list") orelse return error.NotProvided;
    var out = Pairs{ .allocator = allocator };
    defer out.deinit();
    if (!list(&out, &Pairs.sink)) return error.NoAnswer;
    if (out.failed) return error.OutOfMemory;
    return out.items.toOwnedSlice(allocator);
}

/// One client option by its options.txt key, owned by the caller.
pub fn option(key: []const u8, allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    const get = core.slot("client_option_get") orelse return error.NotProvided;
    var out = Texts{ .allocator = allocator };
    defer out.deinit();
    if (!get(core.str(key), &out, &Texts.sink)) return error.NoAnswer;
    if (out.failed) return error.OutOfMemory;
    return out.items.pop() orelse error.NoAnswer;
}

/// Writes one client option from its options.txt text form; read it back to see what the
/// engine kept.
pub fn setOption(key: []const u8, value: []const u8) core.Error!void {
    const set = core.slot("client_option_set") orelse return error.NotProvided;
    if (!set(core.str(key), core.str(value))) return error.Refused;
}

/// What a key binding reports.
pub const KeyAction = enum(i32) {
    up = 0,
    down = 1,
    _,

    pub fn isDown(self: KeyAction) bool {
        return self == .down;
    }
};

/// Called on the client thread for each press and release of a registered key: the `user`
/// pointer given at registration, the action, and the focus impact the engine reports.
pub const KeyHandler = fn (user: ?*anyopaque, action: KeyAction, impact: i32) void;

/// One registered key binding, kept to drop it.
pub const KeyBinding = struct {
    handle: c.PierKeyHandle,

    /// The key codes currently assigned, which differ from the defaults when the player
    /// remapped the key. Owned by the caller.
    pub fn keyCodes(self: KeyBinding, allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]i32 {
        const f = core.slot("client_get_key_codes") orelse return error.NotProvided;
        var out = Texts{ .allocator = allocator };
        defer out.deinit();
        if (!f(self.handle, &out, &Texts.sink)) return error.NoAnswer;
        if (out.failed) return error.OutOfMemory;
        const text = out.items.pop() orelse return error.NoAnswer;
        defer allocator.free(text);
        var codes: std.ArrayList(i32) = .empty;
        errdefer codes.deinit(allocator);
        var parts = std.mem.splitScalar(u8, std.mem.trim(u8, text, " []"), ',');
        while (parts.next()) |part| {
            const piece = std.mem.trim(u8, part, " ");
            if (piece.len == 0) continue;
            try codes.append(allocator, std.fmt.parseInt(i32, piece, 10) catch continue);
        }
        return codes.toOwnedSlice(allocator);
    }

    /// Drops the binding: this mod's handler stops firing. The engine keeps one key per name and
    /// offers no removal, so registering the same name again reuses it. Calling it twice is
    /// harmless.
    pub fn unregister(self: *KeyBinding) core.Error!void {
        if (self.handle == null) return;
        const f = core.slot("client_unregister_key") orelse return error.NotProvided;
        const handle = self.handle;
        self.handle = null;
        try core.expect(f(handle));
    }
};

/// Registers a key binding under `name` with its default `key_codes`. `allow_remap` lets the
/// player rebind it. A name that is taken, or an empty code list, is Refused.
pub fn registerKey(name: []const u8, key_codes: []const i32, allow_remap: bool, user: ?*anyopaque, comptime handler: KeyHandler) core.Error!KeyBinding {
    const f = core.slot("client_register_key") orelse return error.NotProvided;
    const Trampoline = struct {
        fn call(user_ptr: ?*anyopaque, action: c.PierKeyAction, impact: c.PierFocusImpact) callconv(.c) void {
            handler(user_ptr, @enumFromInt(action), impact);
        }
    };
    const handle = f(core.handle(), core.str(name), key_codes.ptr, @intCast(key_codes.len), allow_remap, &Trampoline.call, &Trampoline.call, user);
    if (handle == null) return error.Refused;
    return .{ .handle = handle };
}

/// Whether the client is inside a level, which means a world is loaded.
pub fn isInLevel() core.Error!bool {
    const f = core.slot("client_is_in_level") orelse return error.NotProvided;
    return f();
}

/// The name of the local player, owned by the caller. NoAnswer outside a level.
pub fn localPlayerName(allocator: std.mem.Allocator) (core.Error || std.mem.Allocator.Error)![]u8 {
    const f = core.slot("client_get_local_player") orelse return error.NotProvided;
    var out = Texts{ .allocator = allocator };
    defer out.deinit();
    if (!f(&out, &Texts.sink)) return error.NoAnswer;
    if (out.failed) return error.OutOfMemory;
    return out.items.pop() orelse error.NoAnswer;
}
