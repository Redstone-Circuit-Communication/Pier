//! The native escape hatch: engine addresses and native detours, for an engine call no other
//! function wraps. The host checks nothing a mod does with an address. Its config.json has to
//! set "native_detour": true; until it does, every call returns error.NativeDisabled and the
//! host logs once, to this mod's logger, which setting to change.

const core = @import("core.zig");
const c = core.c;

/// core.Error plus the four answers of a native slot other than PIER_NATIVE_OK.
pub const NativeError = core.Error || error{ NativeDisabled, NativeNotFound, NativeRefused, NativeFailed };

/// The priorities of ll::memory::HookPriority, for hookInstall.
pub const priority_highest: i32 = 0;
pub const priority_high: i32 = 100;
pub const priority_normal: i32 = 200;
pub const priority_low: i32 = 300;
pub const priority_lowest: i32 = 400;

/// The engine service objects `object` hands out. The two client kinds are not found on a
/// server host.
pub const Object = enum(i32) {
    minecraft = 0,
    level = 1,
    server_network_handler = 2,
    server_instance = 3,
    command_registry = 4,
    network_system = 5,
    db_storage = 6,
    client_instance = 7,
    multiplayer_level = 8,
};

fn check(code: i32) NativeError!void {
    return switch (code) {
        c.PIER_NATIVE_OK => {},
        c.PIER_NATIVE_DISABLED => error.NativeDisabled,
        c.PIER_NATIVE_NOT_FOUND => error.NativeNotFound,
        c.PIER_NATIVE_REFUSED => error.NativeRefused,
        else => error.NativeFailed,
    };
}

fn address(code: i32, out: ?*anyopaque) NativeError!*anyopaque {
    try check(code);
    return out orelse error.NativeNotFound;
}

/// Whether the host answers the native calls, which its config.json decides.
pub fn enabled() bool {
    const get = core.slot("native_enabled") orelse return false;
    return get();
}

/// The address of an engine function by its decorated symbol name.
pub fn resolveSymbol(symbol: []const u8) NativeError!*anyopaque {
    const f = core.slot("native_resolve_symbol") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), core.str(symbol), &out), out);
}

/// The first match of a byte pattern such as "48 8B ?? 08" in the engine executable.
pub fn resolveSignature(pattern: []const u8) NativeError!*anyopaque {
    const f = core.slot("native_resolve_signature") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), core.str(pattern), &out), out);
}

/// An export of a module already loaded into the process; an empty module names the engine
/// executable. LeviLamina's API is an export of LeviLamina.dll.
pub fn moduleExport(module: []const u8, name: []const u8) NativeError!*anyopaque {
    const f = core.slot("native_module_export") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), core.str(module), core.str(name), &out), out);
}

/// The address of one engine service object.
pub fn object(kind: Object) NativeError!*anyopaque {
    const f = core.slot("native_object") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), @intFromEnum(kind), &out), out);
}

/// The engine's Player object of an online player, valid while the player stays online.
pub fn player(sel: c.PierPlayerSel) NativeError!*anyopaque {
    const f = core.slot("native_player") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), sel, &out), out);
}

/// The engine's Actor object of a loaded actor.
pub fn actor(id: c.PierActorId) NativeError!*anyopaque {
    const f = core.slot("native_actor") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), id, &out), out);
}

/// The engine's Dimension object of a dimension id.
pub fn dimension(dim: i32) NativeError!*anyopaque {
    const f = core.slot("native_dimension") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), dim, &out), out);
}

/// The engine's BlockSource of a dimension id.
pub fn blockSource(dim: i32) NativeError!*anyopaque {
    const f = core.slot("native_block_source") orelse return error.NotProvided;
    var out: ?*anyopaque = null;
    return address(f(core.handle(), dim, &out), out);
}

/// One installed detour: the id hookRemove takes, and the address through which the detour
/// calls the next detour or the engine.
pub const Hook = struct {
    id: u64,
    original: *anyopaque,
};

/// Installs detour on target at a priority_* value. detour must be a callconv(.c) function
/// with the exact signature of target, and it reaches the engine through original only. The
/// host removes a detour this mod still holds when the mod unloads, and does not wait for a
/// call already inside it on another thread.
pub fn hookInstall(target: *anyopaque, detour: *anyopaque, priority: i32) NativeError!Hook {
    const f = core.slot("native_hook_install") orelse return error.NotProvided;
    var original: ?*anyopaque = null;
    var id: u64 = 0;
    try check(f(core.handle(), target, detour, priority, &original, &id));
    return .{ .id = id, .original = original orelse return error.NativeFailed };
}

/// Removes a detour this mod installed.
pub fn hookRemove(hook: Hook) NativeError!void {
    const f = core.slot("native_hook_remove") orelse return error.NotProvided;
    try check(f(core.handle(), hook.id));
}
