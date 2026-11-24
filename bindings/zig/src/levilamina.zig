//! Pier's Zig binding: LeviLamina mods in Zig, on Pier's C ABI.
//!
//! A mod is a dynamic library whose root file declares the mod type and calls exportMod:
//!
//!     const levilamina = @import("levilamina");
//!     const MyMod = struct {
//!         pub fn enable(ctx: *levilamina.Context) !void { ctx.info("enabled"); }
//!     };
//!     comptime { levilamina.exportMod(MyMod, "my-mod"); }
//!
//! Every slot of abi.h is reachable through `slot`, gated by both checks of contract
//! section 10. The rest is built on it: lifecycle, logging, tasks, events, commands, the bus
//! and services, one method per property and verb on Player, Entity, BlockAt and Item, and
//! SNBT in `nbt`.

const std = @import("std");
const core = @import("core.zig");

pub const nbt = @import("nbt.zig");
pub const props = @import("props_gen.zig");
pub const client = @import("client.zig");
pub const native = @import("native.zig");
pub const world = @import("world.zig");
pub const server = @import("server.zig");
pub const types = @import("types.zig");
pub const container = @import("container.zig");
pub const kvdb = @import("kvdb.zig");
pub const money = @import("money.zig");
pub const scoreboard = @import("scoreboard.zig");
pub const gui = @import("gui.zig");
pub const packet = @import("packet.zig");
pub const sim = @import("sim.zig");
pub const dimensions = @import("dimensions.zig");
pub const registry = @import("registry.zig");
pub const lane = @import("lane.zig");
pub const command = @import("command.zig");

pub const c = core.c;
pub const Error = core.Error;
pub const slot = core.slot;
pub const handle = core.handle;
pub const str = core.str;
pub const view = core.view;
pub const Collector = core.Collector;

pub const Level = core.Level;
pub const log = core.log;
pub const logf = core.logf;
pub const Context = core.Context;
pub const exportMod = core.exportMod;

pub const TaskId = core.TaskId;
pub const schedule = core.schedule;
pub const scheduleAfter = core.scheduleAfter;
pub const cancel = core.cancel;
pub const pendingTasks = core.pendingTasks;

pub const Priority = core.Priority;
pub const Event = core.Event;
pub const Listener = core.Listener;
pub const subscribe = core.subscribe;

pub const Permission = core.Permission;
pub const Invocation = core.Invocation;
pub const registerCommand = core.registerCommand;
pub const executeCommand = core.executeCommand;

pub const Subscription = core.Subscription;
pub const busSubscribe = core.busSubscribe;
pub const busPublish = core.busPublish;
pub const Vetoable = core.Vetoable;
pub const busPublishVetoable = core.busPublishVetoable;
pub const busSubscriberCount = core.busSubscriberCount;

pub const Reply = core.Reply;
pub const ServiceRegistration = core.ServiceRegistration;
pub const registerService = core.registerService;
pub const CallCode = core.CallCode;
pub const CallOutcome = core.CallOutcome;
pub const callService = core.callService;
pub const listServicesJson = core.listServicesJson;
pub const serviceCaller = core.serviceCaller;

pub const SelKind = props.SelKind;
pub const Player = props.Player;
pub const Entity = props.Entity;
pub const BlockAt = props.BlockAt;
pub const Item = props.Item;

// The tests make the compiler analyze every function of the binding against the table that
// translate-c read from abi.h, which is the check this binding gets on a machine without a
// server: a slot name that does not exist, or an argument of the wrong type, fails here.

const TypeCheck = struct {
    fn onEvent(_: *const Event) void {}
    fn onCommand(_: *const Invocation) void {}
    fn onBus(_: []const u8, _: []const u8) bool {
        return false;
    }
    fn provide(_: []const u8, _: *const Reply) bool {
        return true;
    }
    fn task() void {}
    pub fn enable(_: *Context) error{Refused}!void {}
    fn onForm(_: ?*anyopaque, _: gui.Response) void {}
    fn onPacket(_: *packet.Packet) packet.Verdict {
        return .forward;
    }
    fn onConnection(_: u64, _: []const u8, _: packet.ConnectionState) void {}
    fn onMoneyBefore(_: money.Event) bool {
        return false;
    }
    fn onMoneyAfter(_: money.Event) void {}
    fn generate(_: ?*anyopaque, _: dimensions.ChunkRequest) bool {
        return false;
    }
    fn onTypedCommand(_: *command.Call) void {}
    fn onKey(_: ?*anyopaque, _: client.KeyAction, _: i32) void {}
};

fn instantiateGenerics() void {
    if (subscribe("type-check", .normal, TypeCheck.onEvent)) |_| {} else |_| {}
    if (registerCommand("type-check", "", .any, TypeCheck.onCommand)) |_| {} else |_| {}
    if (busSubscribe("type-check", TypeCheck.onBus)) |_| {} else |_| {}
    if (registerService("type-check", TypeCheck.provide)) |_| {} else |_| {}
    if (schedule(TypeCheck.task)) |_| {} else |_| {}
    if (scheduleAfter(1, TypeCheck.task)) |_| {} else |_| {}
    if (packet.intercept(.both, TypeCheck.onPacket)) |_| {} else |_| {}
    if (packet.interceptIds(.both, &.{1}, TypeCheck.onPacket)) |_| {} else |_| {}
    if (packet.onConnection(TypeCheck.onConnection)) |_| {} else |_| {}
    if (money.onBefore(TypeCheck.onMoneyBefore)) |_| {} else |_| {}
    if (money.onAfter(TypeCheck.onMoneyAfter)) |_| {} else |_| {}
    if (dimensions.addDimensionGenerated(std.testing.allocator, "type-check", "{}", &.{"minecraft:air"}, &.{"minecraft:plains"}, null, TypeCheck.generate)) |_| {} else |_| {}
    var typed = command.Builder.init(std.testing.allocator, "type-check", "", .any);
    if (typed.register(TypeCheck.onTypedCommand)) |_| {} else |_| {}
    if (client.registerKey("type-check", &.{1}, false, null, TypeCheck.onKey)) |_| {} else |_| {}
    const who = Player.byName("type-check");
    var simple = gui.SimpleForm.init(std.testing.allocator, "type-check");
    if (simple.send(who, null, TypeCheck.onForm)) |_| {} else |_| {}
    const modal = gui.ModalForm.init(std.testing.allocator, "type-check", "type-check");
    if (modal.send(who, null, TypeCheck.onForm)) |_| {} else |_| {}
    var custom = gui.CustomForm.init(std.testing.allocator, "type-check");
    if (custom.send(who, null, TypeCheck.onForm)) |_| {} else |_| {}
}

test "the whole binding type-checks against abi.h" {
    std.testing.refAllDecls(core);
    std.testing.refAllDeclsRecursive(props);
    std.testing.refAllDecls(client);
    std.testing.refAllDecls(native);
    std.testing.refAllDecls(world);
    std.testing.refAllDecls(server);
    std.testing.refAllDecls(types);
    std.testing.refAllDecls(container);
    std.testing.refAllDecls(kvdb);
    std.testing.refAllDecls(money);
    std.testing.refAllDecls(scoreboard);
    std.testing.refAllDeclsRecursive(gui);
    std.testing.refAllDeclsRecursive(packet);
    std.testing.refAllDeclsRecursive(sim);
    std.testing.refAllDeclsRecursive(dimensions);
    std.testing.refAllDeclsRecursive(registry);
    std.testing.refAllDeclsRecursive(lane);
    std.testing.refAllDeclsRecursive(command);
    _ = &instantiateGenerics;
    comptime exportMod(TypeCheck, "type-check");
    // No host table in a test, so every slot is absent: the gate answers null, not a call.
    try std.testing.expect(slot("log") == null);
}

test {
    _ = nbt;
}

// Declared after the test above, which asserts that no table is installed: these install one.
test {
    _ = @import("host_test.zig");
}
