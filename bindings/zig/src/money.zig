//! money.zig: the economy of the host's LegacyMoney backend: balances, transfers, history and
//! the events a mod can watch or veto.

const std = @import("std");
const core = @import("core.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The balance of an account. NoAnswer when the host cannot say: an empty xuid, a database
/// error or no backend. Reading an account no one has opened opens it at the default.
pub fn balance(xuid: []const u8) core.Error!i64 {
    const f = core.slot("get_money") orelse return error.NotProvided;
    const n = f(core.str(xuid));
    if (n < 0) return error.NoAnswer;
    return n;
}

/// Sets the balance to a target.
pub fn set(xuid: []const u8, amount: i64) core.Error!void {
    const f = core.slot("set_money") orelse return error.NotProvided;
    try core.expect(f(core.str(xuid), amount));
}

pub fn add(xuid: []const u8, delta: i64) core.Error!void {
    const f = core.slot("add_money") orelse return error.NotProvided;
    try core.expect(f(core.str(xuid), delta));
}

pub fn reduce(xuid: []const u8, delta: i64) core.Error!void {
    const f = core.slot("reduce_money") orelse return error.NotProvided;
    try core.expect(f(core.str(xuid), delta));
}

/// Transfers between two accounts. An empty `from` or `to` means created from or destroyed
/// into nothing. A `from` equal to `to` is refused by the backend, and the amount the payee
/// receives is reduced by the configured tax.
pub fn transfer(from: []const u8, to: []const u8, value: i64, note: []const u8) core.Error!void {
    const f = core.slot("trans_money") orelse return error.NotProvided;
    try core.expect(f(core.str(from), core.str(to), value, core.str(note)));
}

/// The transactions of the last `seconds` seconds, one per line, owned by the caller;
/// `core.freeList` releases them.
pub fn history(allocator: Allocator, xuid: []const u8, seconds: i32) core.Error![][]u8 {
    const f = core.slot("money_get_hist") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    f(core.str(xuid), seconds, &col, &core.Collector.sink);
    return col.takeAll();
}

/// Clears transactions older than `seconds` seconds.
pub fn clearHistory(seconds: i32) core.Error!void {
    const f = core.slot("money_clear_hist") orelse return error.NotProvided;
    f(seconds);
}

/// The top `top_n` of the rich list, one per line, owned by the caller; `core.freeList`
/// releases them.
pub fn ranking(allocator: Allocator, top_n: u16) core.Error![][]u8 {
    const f = core.slot("money_ranking") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    f(top_n, &col, &core.Collector.sink);
    return col.takeAll();
}

/// What an economy event does.
pub const EventKind = enum { set, add, reduce, transfer, unknown };

/// One economy event. The two strings are valid during the callback only.
pub const Event = struct {
    kind: EventKind,
    from: []const u8,
    to: []const u8,
    value: i64,
};

fn eventOf(kind: c.PierMoneyEvent, from: c.PierStr, to: c.PierStr, value: i64) Event {
    const k: EventKind = switch (kind) {
        c.PIER_MONEY_SET => .set,
        c.PIER_MONEY_ADD => .add,
        c.PIER_MONEY_REDUCE => .reduce,
        c.PIER_MONEY_TRANS => .transfer,
        else => .unknown,
    };
    return .{ .kind = k, .from = core.view(from), .to = core.view(to), .value = value };
}

/// Registers a callback that runs before the event, where returning false vetoes it. Several
/// mods may each register one, and the loader removes it when this mod unloads.
pub fn onBefore(comptime handler: fn (Event) bool) core.Error!void {
    const f = core.slot("money_listen_before_event") orelse return error.NotProvided;
    const Trampoline = struct {
        fn call(kind: c.PierMoneyEvent, from: c.PierStr, to: c.PierStr, value: i64) callconv(.c) bool {
            return handler(eventOf(kind, from, to, value));
        }
    };
    f(&Trampoline.call);
}

/// Registers a callback that runs after the event. The return value is ignored.
pub fn onAfter(comptime handler: fn (Event) void) core.Error!void {
    const f = core.slot("money_listen_after_event") orelse return error.NotProvided;
    const Trampoline = struct {
        fn call(kind: c.PierMoneyEvent, from: c.PierStr, to: c.PierStr, value: i64) callconv(.c) bool {
            handler(eventOf(kind, from, to, value));
            return true;
        }
    };
    f(&Trampoline.call);
}
