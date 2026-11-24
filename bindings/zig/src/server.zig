//! server.zig: the server runtime: ticks and their speed, performance, the run stage, the
//! environment of the process, and the lists of players, actors and events the host keeps.

const std = @import("std");
const core = @import("core.zig");
const types = @import("types.zig");
const internal = @import("internal.zig");
const props = @import("props_gen.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The run stage of the server, mirroring `ll::GamingStatus`.
pub const GamingStatus = enum(i32) {
    default = 0,
    starting = 1,
    running = 2,
    stopping = 3,
    _,
};

/// Which stage the server is in. Thread safe: any thread may ask.
pub fn gamingStatus() core.Error!GamingStatus {
    const f = core.slot("gaming_status") orelse return error.NotProvided;
    return @enumFromInt(f());
}

/// The current server tick. NoAnswer while the level is not ready.
pub fn currentTick() core.Error!u64 {
    const f = core.slot("get_current_tick") orelse return error.NotProvided;
    const tick = f();
    if (tick == 0) return error.NoAnswer;
    return tick;
}

/// How many players are connected.
pub fn playerCount() core.Error!i32 {
    const f = core.slot("get_player_count") orelse return error.NotProvided;
    return f();
}

/// Whether the simulation is paused.
pub fn isSimPaused() core.Error!bool {
    const f = core.slot("get_sim_paused") orelse return error.NotProvided;
    return f();
}

/// The wall-clock period of the last frame in seconds. At 20 TPS it is 0.05.
pub fn tickDeltaTime() core.Error!f64 {
    const f = core.slot("get_tick_delta_time") orelse return error.NotProvided;
    return f();
}

/// Ticks per second over the last 5 seconds of wall clock.
pub fn tps() core.Error!f64 {
    return tpsOver(5);
}

/// As `tps`, over a window of `window_seconds`, from 1 to 60 and clipped by the host.
pub fn tpsOver(window_seconds: i32) core.Error!f64 {
    const f = core.slot("get_tps") orelse return error.NotProvided;
    return f(window_seconds);
}

/// Milliseconds spent computing each tick, averaged over the last 5 seconds.
pub fn mspt() core.Error!f64 {
    return msptOver(5);
}

/// As `mspt`, over a window of `window_seconds`, from 1 to 60 and clipped by the host.
pub fn msptOver(window_seconds: i32) core.Error!f64 {
    const f = core.slot("get_mspt") orelse return error.NotProvided;
    return f(window_seconds);
}

/// Freezes or unfreezes the world.
pub fn setTickFreeze(on: bool) core.Error!void {
    const f = core.slot("tick_freeze") orelse return error.NotProvided;
    try core.expect(f(on));
}

/// Valid only while frozen: lets `n` more frames through.
pub fn stepTicks(n: u32) core.Error!void {
    const f = core.slot("tick_step") orelse return error.NotProvided;
    try core.expect(f(n));
}

/// The time warp. `0 < factor <= 100`, below 1 is slow motion and 1.0 is normal.
pub fn setTickWarp(factor: f64) core.Error!void {
    const f = core.slot("tick_warp") orelse return error.NotProvided;
    try core.expect(f(factor));
}

/// Opens a sampling window of `ticks` frames, from 1 to 12000. Only one window at a time.
pub fn beginProfile(ticks: u32) core.Error!void {
    const f = core.slot("profile_begin") orelse return error.NotProvided;
    try core.expect(f(ticks));
}

/// Takes the sampling report as SNBT, owned by the caller; null while the window is still
/// open or none was armed. The report is handed out once per window.
pub fn takeProfile(allocator: Allocator) core.Error!?[]u8 {
    const f = core.slot("profile_take") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    if (!f(&col, &core.Collector.sink)) return null;
    return try col.take();
}

/// Reads an environment variable of this process, owned by the caller.
pub fn env(allocator: Allocator, name: []const u8) core.Error![]u8 {
    const f = core.slot("sys_get_env") orelse return error.NotProvided;
    return core.sinkOne(allocator, f, .{core.str(name)});
}

/// Sets an environment variable. It affects this process only.
pub fn setEnv(name: []const u8, value: []const u8) core.Error!void {
    const f = core.slot("sys_set_env") orelse return error.NotProvided;
    try core.expect(f(core.str(name), core.str(value)));
}

/// Whether this host runs under Wine.
pub fn isWine() core.Error!bool {
    const f = core.slot("sys_is_wine") orelse return error.NotProvided;
    return f();
}

fn number(comptime T: type, allocator: Allocator, text: []u8) core.Error!T {
    defer allocator.free(text);
    return std.fmt.parseInt(T, std.mem.trim(u8, text, " \t\r\n"), 10) catch error.NoAnswer;
}

/// The network protocol version of the server, derived from the running build's game version.
pub fn protocolVersion(allocator: Allocator) core.Error!u32 {
    return number(u32, allocator, try props.srvProtocolVersion(allocator));
}

/// The protocol the level was last written by. It says how old the save is, not what the
/// server speaks.
pub fn levelProtocolVersion(allocator: Allocator) core.Error!u32 {
    return number(u32, allocator, try props.srvLevelProtocolVersion(allocator));
}

/// The id of the server process.
pub fn processId(allocator: Allocator) core.Error!u32 {
    return number(u32, allocator, try props.sysProcessId(allocator));
}

/// How many times the world has been opened.
pub fn worldStartCount(allocator: Allocator) core.Error!u32 {
    return number(u32, allocator, try props.srvWorldStartCount(allocator));
}

pub fn isHardcore(allocator: Allocator) core.Error!bool {
    const text = try props.srvIsHardcore(allocator);
    defer allocator.free(text);
    return std.mem.eql(u8, text, "1");
}

pub fn educationFeaturesEnabled(allocator: Allocator) core.Error!bool {
    const text = try props.srvEducationFeatures(allocator);
    defer allocator.free(text);
    return std.mem.eql(u8, text, "1");
}

/// The local time of the server.
pub fn localTime(allocator: Allocator) core.Error!types.LocalTime {
    const text = try props.sysLocalTime(allocator);
    defer allocator.free(text);
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const v = try internal.parse(arena.allocator(), text);
    return .{
        .year = try field(v, "year"),
        .month = try field(v, "month"),
        .day = try field(v, "day"),
        .hour = try field(v, "hour"),
        .minute = try field(v, "minute"),
        .second = try field(v, "second"),
        .ms = try field(v, "ms"),
    };
}

fn field(v: @import("nbt.zig").Value, name: []const u8) core.Error!i32 {
    return std.math.cast(i32, v.getInt(name) orelse return error.NoAnswer) orelse error.NoAnswer;
}

/// Every event id the host can currently resolve, each owned by the caller with the slice
/// holding them; free them with `core.freeList`.
pub fn listEvents(allocator: Allocator) core.Error![][]u8 {
    const f = core.slot("list_events") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    f(&col, &core.Collector.sink);
    return col.takeAll();
}

/// One online player.
pub const PlayerInfo = struct {
    name: []const u8,
    xuid: []const u8,
    uuid: []const u8,
    dim: i32,
    x: f64,
    y: f64,
    z: f64,
};

/// Every online player.
pub fn listPlayers(allocator: Allocator) core.Error!types.Owned(PlayerInfo) {
    const f = core.slot("list_players") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    f(&col, &core.Collector.sink);
    const pieces = try col.takeAll();
    defer core.freeList(allocator, pieces);
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var list: std.ArrayList(PlayerInfo) = .empty;
    for (pieces) |piece| {
        const v = internal.parse(a, piece) catch continue;
        try list.append(a, .{
            .name = try a.dupe(u8, v.getString("name") orelse continue),
            .xuid = try a.dupe(u8, v.getString("xuid") orelse ""),
            .uuid = try a.dupe(u8, v.getString("uuid") orelse ""),
            .dim = std.math.cast(i32, v.getInt("dim") orelse 0) orelse 0,
            .x = v.getFloat("x") orelse 0,
            .y = v.getFloat("y") orelse 0,
            .z = v.getFloat("z") orelse 0,
        });
    }
    return .{ .arena = arena, .items = try list.toOwnedSlice(a) };
}

/// One live actor of a listing.
pub const ActorEntry = struct {
    id: i64,
    type_name: []const u8,
};

const ActorCollector = struct {
    arena: Allocator,
    list: std.ArrayList(ActorEntry) = .empty,
    failed: bool = false,

    fn sink(ctx: ?*anyopaque, id: i64, type_name: c.PierStr) callconv(.c) void {
        const self: *ActorCollector = @ptrCast(@alignCast(ctx orelse return));
        if (self.failed) return;
        const copy = self.arena.dupe(u8, core.view(type_name)) catch {
            self.failed = true;
            return;
        };
        self.list.append(self.arena, .{ .id = id, .type_name = copy }) catch {
            self.failed = true;
        };
    }
};

/// The live actors of a dimension; -1 lists every dimension.
pub fn listActors(allocator: Allocator, dim: i32) core.Error!types.Owned(ActorEntry) {
    const f = core.slot("list_actors") orelse return error.NotProvided;
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var state = ActorCollector{ .arena = a };
    f(dim, &state, &ActorCollector.sink);
    if (state.failed) return error.OutOfMemory;
    return .{ .arena = arena, .items = try state.list.toOwnedSlice(a) };
}

/// Sends a message to every online player.
pub fn broadcast(message: []const u8) core.Error!void {
    const f = core.slot("broadcast_message") orelse return error.NotProvided;
    f(core.str(message));
}
