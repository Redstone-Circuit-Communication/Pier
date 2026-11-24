//! scoreboard.zig: objectives, scores and display slots of the level's scoreboard.

const std = @import("std");
const core = @import("core.zig");
const types = @import("types.zig");
const internal = @import("internal.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The display slot of a scoreboard.
pub const DisplaySlot = enum {
    sidebar,
    list,
    below_name,

    /// The name the host dispatches on.
    pub fn name(self: DisplaySlot) []const u8 {
        return switch (self) {
            .sidebar => "sidebar",
            .list => "list",
            .below_name => "belowname",
        };
    }
};

/// One objective.
pub const Objective = struct {
    name: []const u8,
    display_name: []const u8,
};

fn discard(_: ?*anyopaque, _: c.PierStr) callconv(.c) void {}

fn run(op: i32, a: []const u8, b: []const u8, n: i64) core.Error!void {
    const f = core.slot("scoreboard_op") orelse return error.NotProvided;
    if (!f(op, core.str(a), core.str(b), n, null, &discard)) return error.Refused;
}

fn runNumber(op: i32, a: []const u8, b: []const u8, n: i64) core.Error!i64 {
    const f = core.slot("scoreboard_op") orelse return error.NotProvided;
    var out = internal.SmallText{};
    if (!f(op, core.str(a), core.str(b), n, &out, &internal.SmallText.sink)) return error.Refused;
    return std.fmt.parseInt(i64, std.mem.trim(u8, out.text(), " \t\r\n"), 10) catch error.NoAnswer;
}

/// Creates a dummy objective. It is Refused when one of that name already exists.
pub fn addObjective(name: []const u8, display_name: []const u8) core.Error!void {
    return run(c.PIER_SB_ADD_OBJECTIVE, name, display_name, 0);
}

pub fn removeObjective(name: []const u8) core.Error!void {
    return run(c.PIER_SB_REMOVE_OBJECTIVE, name, "", 0);
}

/// Every objective of the scoreboard.
pub fn objectives(allocator: Allocator) core.Error!types.Owned(Objective) {
    const f = core.slot("scoreboard_op") orelse return error.NotProvided;
    const text = core.sinkOne(allocator, f, .{ @as(i32, c.PIER_SB_LIST_OBJECTIVES), core.str(""), core.str(""), @as(i64, 0) }) catch |err| switch (err) {
        error.NoAnswer => return error.Refused,
        else => return err,
    };
    defer allocator.free(text);
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var list: std.ArrayList(Objective) = .empty;
    if (std.mem.trim(u8, text, " \t\r\n").len != 0) {
        const v = try internal.parse(a, text);
        const items = switch (v) {
            .list => |l| l,
            else => return error.NoAnswer,
        };
        for (items) |o| {
            const name = o.getString("name") orelse continue;
            try list.append(a, .{ .name = try a.dupe(u8, name), .display_name = try a.dupe(u8, o.getString("display") orelse name) });
        }
    }
    return .{ .arena = arena, .items = try list.toOwnedSlice(a) };
}

/// Reads one score; null for a name that has none on this objective.
pub fn score(objective: []const u8, who: []const u8) core.Error!?i64 {
    const f = core.slot("scoreboard_op") orelse return error.NotProvided;
    var out = internal.SmallText{};
    if (!f(c.PIER_SB_GET_SCORE, core.str(objective), core.str(who), 0, &out, &internal.SmallText.sink)) return error.Refused;
    const text = std.mem.trim(u8, out.text(), " \t\r\n");
    if (text.len == 0) return null;
    return std.fmt.parseInt(i64, text, 10) catch error.NoAnswer;
}

/// Sets a score and returns the value after the write.
pub fn setScore(objective: []const u8, who: []const u8, value: i64) core.Error!i64 {
    return runNumber(c.PIER_SB_SET_SCORE, objective, who, value);
}

pub fn addScore(objective: []const u8, who: []const u8, delta: i64) core.Error!i64 {
    return runNumber(c.PIER_SB_ADD_SCORE, objective, who, delta);
}

pub fn reduceScore(objective: []const u8, who: []const u8, delta: i64) core.Error!i64 {
    return runNumber(c.PIER_SB_REDUCE_SCORE, objective, who, delta);
}

/// Erases the score of this name on this objective, which is not setting it to 0.
pub fn resetScore(objective: []const u8, who: []const u8) core.Error!void {
    return run(c.PIER_SB_RESET_SCORE, objective, who, 0);
}

pub fn setDisplay(slot: DisplaySlot, objective: []const u8) core.Error!void {
    return run(c.PIER_SB_SET_DISPLAY, slot.name(), objective, 0);
}

pub fn clearDisplay(slot: DisplaySlot) core.Error!void {
    return run(c.PIER_SB_CLEAR_DISPLAY, slot.name(), "", 0);
}
