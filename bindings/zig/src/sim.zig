//! sim.zig: simulated players, the bots the engine drives as if a client were playing. A
//! simulated player is also an ordinary player: `player` gives the full player API.

const std = @import("std");
const core = @import("core.zig");
const nbt = @import("nbt.zig");
const props = @import("props_gen.zig");
const types = @import("types.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// One simulated player, named. The name is borrowed and must outlive the value.
pub const SimPlayer = struct {
    name: []const u8,

    /// Builds a simulated player. It fails when the name is taken by a real player.
    pub fn spawn(name: []const u8, dim: i32, x: f64, y: f64, z: f64) core.Error!SimPlayer {
        const f = core.slot("sim_spawn") orelse return error.NotProvided;
        try core.expect(f(core.str(name), dim, x, y, z));
        return .{ .name = name };
    }

    /// Attaches by name to a simulated player that already exists. It does not check whether one
    /// does; `isSimulated` does.
    pub fn byName(name: []const u8) SimPlayer {
        return .{ .name = name };
    }

    /// Uses it as an ordinary player, giving the full player API.
    pub fn player(self: SimPlayer) props.Player {
        return props.Player.byName(self.name);
    }

    /// Whether this name currently points at a live simulated player.
    pub fn isSimulated(self: SimPlayer) core.Error!bool {
        const f = core.slot("sim_is") orelse return error.NotProvided;
        return f(self.player().cSel());
    }

    /// Runs one verb. The argument is SNBT, and "{}" is passed when there is none.
    pub fn act(self: SimPlayer, verb: []const u8, args_snbt: []const u8) core.Error!void {
        const f = core.slot("sim_do") orelse return error.NotProvided;
        try core.expect(f(self.player().cSel(), core.str(verb), core.str(args_snbt)));
    }

    pub fn despawn(self: SimPlayer) core.Error!void {
        return self.act("despawn", "{}");
    }

    pub fn stop(self: SimPlayer) core.Error!void {
        return self.act("stop", "{}");
    }

    pub fn jump(self: SimPlayer) core.Error!void {
        return self.act("jump", "{}");
    }

    pub fn attack(self: SimPlayer) core.Error!void {
        return self.act("attack", "{}");
    }

    pub fn interact(self: SimPlayer) core.Error!void {
        return self.act("interact", "{}");
    }

    pub fn useItem(self: SimPlayer) core.Error!void {
        return self.act("use_item", "{}");
    }

    pub fn dropSelected(self: SimPlayer) core.Error!void {
        return self.act("drop", "{}");
    }

    pub fn respawn(self: SimPlayer) core.Error!void {
        return self.act("respawn", "{}");
    }

    pub fn stopDestroying(self: SimPlayer) core.Error!void {
        return self.act("stop_destroy", "{}");
    }

    /// Walks straight there. `face_target` decides whether it faces the target while walking.
    pub fn moveTo(self: SimPlayer, x: f64, y: f64, z: f64, speed: f64, face_target: bool) core.Error!void {
        var sfa = std.heap.stackFallback(512, std.heap.page_allocator);
        var w = nbt.Writer.init(sfa.get());
        defer w.deinit();
        try w.beginCompound();
        try w.key("x");
        try w.double(x);
        try w.key("y");
        try w.double(y);
        try w.key("z");
        try w.double(z);
        try w.key("speed");
        try w.double(speed);
        try w.key("face_target");
        try w.boolean(face_target);
        try w.endCompound();
        return self.act("move_to", w.text());
    }

    /// Paths there. Unlike `moveTo` it goes around obstacles.
    pub fn navigateTo(self: SimPlayer, x: f64, y: f64, z: f64, speed: f64) core.Error!void {
        var sfa = std.heap.stackFallback(512, std.heap.page_allocator);
        var w = nbt.Writer.init(sfa.get());
        defer w.deinit();
        try w.beginCompound();
        try w.key("x");
        try w.double(x);
        try w.key("y");
        try w.double(y);
        try w.key("z");
        try w.double(z);
        try w.key("speed");
        try w.double(speed);
        try w.endCompound();
        return self.act("navigate_to", w.text());
    }

    pub fn lookAt(self: SimPlayer, x: f64, y: f64, z: f64) core.Error!void {
        var sfa = std.heap.stackFallback(256, std.heap.page_allocator);
        var w = nbt.Writer.init(sfa.get());
        defer w.deinit();
        try w.beginList();
        try w.double(x);
        try w.double(y);
        try w.double(z);
        try w.endList();
        return self.act("look_at", w.text());
    }

    /// Mines one block. `face` is the face, 1 meaning up.
    pub fn destroyBlock(self: SimPlayer, x: i32, y: i32, z: i32, face: i32) core.Error!void {
        return self.blockVerb("destroy_block", x, y, z, face);
    }

    pub fn interactBlock(self: SimPlayer, x: i32, y: i32, z: i32, face: i32) core.Error!void {
        return self.blockVerb("interact_block", x, y, z, face);
    }

    /// Mines the block in the line of sight. `hand` is the reach, in blocks.
    pub fn destroyLookAt(self: SimPlayer, hand: f64) core.Error!void {
        var sfa = std.heap.stackFallback(128, std.heap.page_allocator);
        var w = nbt.Writer.init(sfa.get());
        defer w.deinit();
        try w.beginCompound();
        try w.key("hand");
        try w.double(hand);
        try w.endCompound();
        return self.act("destroy_look", w.text());
    }

    pub fn setSneaking(self: SimPlayer, on: bool) core.Error!void {
        return self.toggleVerb("sneak", on);
    }

    pub fn setFlying(self: SimPlayer, on: bool) core.Error!void {
        return self.toggleVerb("fly", on);
    }

    pub fn chat(self: SimPlayer, message: []const u8) core.Error!void {
        var sfa = std.heap.stackFallback(512, std.heap.page_allocator);
        var w = nbt.Writer.init(sfa.get());
        defer w.deinit();
        try w.beginCompound();
        try w.key("msg");
        try w.string(message);
        try w.endCompound();
        return self.act("chat", w.text());
    }

    fn blockVerb(self: SimPlayer, verb: []const u8, x: i32, y: i32, z: i32, face: i32) core.Error!void {
        var sfa = std.heap.stackFallback(256, std.heap.page_allocator);
        var w = nbt.Writer.init(sfa.get());
        defer w.deinit();
        try w.beginCompound();
        try w.key("x");
        try w.int(x);
        try w.key("y");
        try w.int(y);
        try w.key("z");
        try w.int(z);
        try w.key("face");
        try w.int(face);
        try w.endCompound();
        return self.act(verb, w.text());
    }

    fn toggleVerb(self: SimPlayer, verb: []const u8, on: bool) core.Error!void {
        var sfa = std.heap.stackFallback(128, std.heap.page_allocator);
        var w = nbt.Writer.init(sfa.get());
        defer w.deinit();
        try w.beginCompound();
        try w.key("on");
        try w.boolean(on);
        try w.endCompound();
        return self.act(verb, w.text());
    }
};

/// The names of the simulated players alive now, owned by the caller; `core.freeList` releases
/// them. A bot that outlived the session that spawned it is found again by name.
pub fn list(allocator: Allocator) core.Error![][]u8 {
    const f = core.slot("sim_list") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    f(&col, &core.Collector.sink);
    return col.takeAll();
}
