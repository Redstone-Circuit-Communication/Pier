//! host_test.zig: the wrappers run against a table the test fills in, so what the type check
//! cannot see is exercised: the parsing of what a slot sinks, the strings a builder sends, and who
//! owns each piece of memory. std.testing.allocator fails a test that leaks.

const std = @import("std");
const lev = @import("levilamina.zig");
const c = lev.c;

extern fn pier_main(table: ?*const c.PierApi, handle: c.PierModHandle, out: ?*c.PierModVTable) callconv(.c) bool;

var api: c.PierApi = undefined;
var vtable: c.PierModVTable = undefined;
var installed = false;

fn emit(ctx: ?*anyopaque, sink: c.PierStrSink, text: []const u8) void {
    if (sink) |s| s(ctx, lev.str(text));
}

fn same(s: c.PierStr, text: []const u8) bool {
    return std.mem.eql(u8, lev.view(s), text);
}

fn fakeLog(_: c.PierModHandle, _: i32, _: c.PierStr) callconv(.c) void {}

fn fakeGetTime(out: [*c]i64) callconv(.c) bool {
    out.* = 4242;
    return true;
}

fn fakeGetDifficulty(out: [*c]i32) callconv(.c) bool {
    out.* = 2;
    return true;
}

fn fakeGameRule(name: c.PierStr, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) bool {
    if (same(name, "doDaylightCycle")) return emitTrue(ctx, sink, "{type:\"bool\",value:1b}");
    if (same(name, "randomTickSpeed")) return emitTrue(ctx, sink, "{type:\"int\",value:3}");
    return false;
}

fn emitTrue(ctx: ?*anyopaque, sink: c.PierStrSink, text: []const u8) bool {
    emit(ctx, sink, text);
    return true;
}

fn fakeVillages(_: i32, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) void {
    emit(ctx, sink, "{uuid:\"v1\",center:[10,64,20],bounds:{min:[0,60,0],max:[32,80,40]},poi_count:7}");
    emit(ctx, sink, "{uuid:\"broken\"}");
}

fn fakeListPlayers(ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) void {
    emit(ctx, sink, "{name:\"Steve\",xuid:\"2535\",uuid:\"u-1\",dim:1,x:1.5d,y:64.0d,z:-2.5d}");
}

fn fakeRegistry(kind: i32, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) bool {
    switch (kind) {
        c.PIER_REGISTRY_BLOCKS => emit(ctx, sink, "{\"name\":\"minecraft:stone\",\"category\":1.0,\"solid\":true,\"destroy\":1.5,\"light\":0}"),
        c.PIER_REGISTRY_ENTITIES => {
            emit(ctx, sink, "{\"name\":\"minecraft:zombie\",\"type\":2304,\"spawn_egg\":true}");
            emit(ctx, sink, "{\"name\":\"minecraft:cod\",\"type\":8448}");
        },
        c.PIER_REGISTRY_COMMANDS => emit(ctx, sink, "{\"name\":\"tp\",\"permission\":1,\"aliases\":[\"teleport\",\"tele\"]}"),
        else => return false,
    }
    return true;
}

fn fakeScoreboard(op: i32, a: c.PierStr, _: c.PierStr, n: i64, ctx: ?*anyopaque, out: c.PierStrSink) callconv(.c) bool {
    switch (op) {
        c.PIER_SB_ADD_OBJECTIVE => return !same(a, "taken"),
        c.PIER_SB_GET_SCORE => {
            emit(ctx, out, "7");
            return true;
        },
        c.PIER_SB_SET_SCORE, c.PIER_SB_ADD_SCORE => {
            var buf: [24]u8 = undefined;
            emit(ctx, out, std.fmt.bufPrint(&buf, "{d}", .{n}) catch return false);
            return true;
        },
        c.PIER_SB_LIST_OBJECTIVES => {
            emit(ctx, out, "[{name:\"kills\",display:\"Kills\"},{name:\"deaths\"}]");
            return true;
        },
        else => return false,
    }
}

var sent_form: [512]u8 = undefined;
var sent_form_len: usize = 0;
var sent_form_kind: i32 = -1;
var form_cb: c.PierFormResultCb = null;
var form_user: ?*anyopaque = null;

fn fakeFormSend(_: c.PierModHandle, _: c.PierPlayerSel, kind: i32, spec: c.PierStr, cb: c.PierFormResultCb, user: ?*anyopaque) callconv(.c) bool {
    const text = lev.view(spec);
    @memcpy(sent_form[0..text.len], text);
    sent_form_len = text.len;
    sent_form_kind = kind;
    form_cb = cb;
    form_user = user;
    return true;
}

var sent_command: [512]u8 = undefined;
var sent_command_len: usize = 0;
var command_cb: c.PierCommandCb = null;

fn fakeRegisterCommandEx(_: c.PierModHandle, _: c.PierStr, _: c.PierStr, _: i32, overloads: c.PierStr, cb: c.PierCommandCb, _: ?*anyopaque) callconv(.c) bool {
    const text = lev.view(overloads);
    @memcpy(sent_command[0..text.len], text);
    sent_command_len = text.len;
    command_cb = cb;
    return true;
}

fn fakeKvOpen(_: c.PierModHandle, _: c.PierStr, _: bool) callconv(.c) c.PierKvDbHandle {
    return @ptrFromInt(0x10);
}

fn fakeKvClose(_: c.PierKvDbHandle) callconv(.c) void {}

fn fakeKvGet(_: c.PierKvDbHandle, key: c.PierStr, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) bool {
    if (!same(key, "k1")) return false;
    emit(ctx, sink, "v1");
    return true;
}

fn fakeKvIter(_: c.PierKvDbHandle, ctx: ?*anyopaque, sink: c.PierKvSink) callconv(.c) void {
    const s = sink orelse return;
    s(ctx, lev.str("a"), lev.str("1"));
    s(ctx, lev.str("b"), lev.str("2"));
}

var lane_alive: u32 = 1;
var lane_busy: u32 = 0;
var lane_table: u32 = 99;

fn fakeLaneAcquire(_: c.PierModHandle, name: c.PierStr, fingerprint: u64, out: [*c]c.PierLaneRef) callconv(.c) i32 {
    if (!same(name, "demo")) return c.PIER_LANE_NOT_FOUND;
    if (fingerprint != 0xABCD) {
        out.*.fingerprint = 0x1234;
        return c.PIER_LANE_FINGERPRINT;
    }
    out.*.lease = 5;
    out.*.fingerprint = fingerprint;
    out.*.vtable = &lane_table;
    out.*.alive = &lane_alive;
    out.*.busy = &lane_busy;
    return c.PIER_LANE_OK;
}

fn fakeMdList(ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) void {
    emit(ctx, sink, "{\"name\":\"plot_world\",\"dim\":1000,\"snbt\":\"{seed:1}\"}");
    emit(ctx, sink, "not json");
}

fn fakeEffects(_: i64, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) bool {
    emit(ctx, sink, "[{id:\"speed\",ticks:200,amplifier:1,visible:1b},{id:5,ticks:10,amplifier:0}]");
    return true;
}

fn fakeRay(_: i64, _: f32, _: bool, _: bool, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) bool {
    emit(ctx, sink, "{type:\"block\",pos:[1.5d,64.0d,2.5d],block_name:\"minecraft:stone\",facing:1}");
    return true;
}

fn fakeEquipment(_: c.PierPlayerSel, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) bool {
    emit(ctx, sink, "[{slot:0,item_snbt:\"{Name:\\\"minecraft:apple\\\"}\"},{slot:2,item_snbt:\"{}\"}]");
    return true;
}

fn fakeNetwork(_: c.PierPlayerSel, ctx: ?*anyopaque, sink: c.PierStrSink) callconv(.c) bool {
    emit(ctx, sink, "{ping:40,avg_ping:35}");
    return true;
}

fn fakeCooldown(_: c.PierPlayerSel, item: c.PierStr) callconv(.c) i32 {
    return if (same(item, "minecraft:ender_pearl")) 60 else -1;
}

var packet_cb: c.PierPacketCb = null;

fn fakePacketRegister(_: c.PierModHandle, _: i32, cb: c.PierPacketCb, _: ?*anyopaque) callconv(.c) c.PierPacketHookHandle {
    packet_cb = cb;
    return @ptrFromInt(0x20);
}

fn install() !void {
    if (installed) return;
    api = std.mem.zeroes(c.PierApi);
    api.struct_size = @sizeOf(c.PierApi);
    api.abi_version = c.PIER_ABI_VERSION;
    api.log = &fakeLog;
    api.get_time = &fakeGetTime;
    api.get_difficulty = &fakeGetDifficulty;
    api.game_rule_get = &fakeGameRule;
    api.villages = &fakeVillages;
    api.list_players = &fakeListPlayers;
    api.registry_list = &fakeRegistry;
    api.scoreboard_op = &fakeScoreboard;
    api.form_send = &fakeFormSend;
    api.register_command_ex = &fakeRegisterCommandEx;
    api.kvdb_open = &fakeKvOpen;
    api.kvdb_close = &fakeKvClose;
    api.kvdb_get = &fakeKvGet;
    api.kvdb_iter = &fakeKvIter;
    api.lane_acquire = &fakeLaneAcquire;
    api.md_list_dimensions = &fakeMdList;
    api.actor_get_effects = &fakeEffects;
    api.actor_trace_ray = &fakeRay;
    api.player_get_equipment = &fakeEquipment;
    api.player_get_network_status = &fakeNetwork;
    api.player_get_cooldown = &fakeCooldown;
    api.packet_hook_register = &fakePacketRegister;
    if (!pier_main(&api, @ptrFromInt(0x1000), &vtable)) return error.HostRefusedTheTable;
    installed = true;
}

const alloc = std.testing.allocator;

test "a slot the table has is called and one it lacks is NotProvided" {
    try install();
    try std.testing.expectEqual(@as(i64, 4242), try lev.world.time());
    try std.testing.expectEqual(lev.types.Difficulty.normal, try lev.world.difficulty());
    try std.testing.expectError(error.NotProvided, lev.world.seed());
    try std.testing.expectError(error.NotProvided, lev.server.tps());
}

test "a game rule is read by the type the host names" {
    try install();
    try std.testing.expectEqual(true, (try lev.world.gameRule(alloc, "doDaylightCycle")).boolean);
    try std.testing.expectEqual(@as(i64, 3), (try lev.world.gameRule(alloc, "randomTickSpeed")).int);
    try std.testing.expectError(error.NoAnswer, lev.world.gameRule(alloc, "nonsense"));
}

test "a listing parses what it can and owns every string in one arena" {
    try install();
    var villages = try lev.world.villages(alloc, 0);
    defer villages.deinit();
    try std.testing.expectEqual(@as(usize, 1), villages.items.len);
    try std.testing.expectEqualStrings("v1", villages.items[0].uuid);
    try std.testing.expectEqual(@as(i32, 64), villages.items[0].center.y);
    try std.testing.expectEqual(@as(i32, 40), villages.items[0].bounds.max.z);
    try std.testing.expectEqual(@as(i32, 7), villages.items[0].poi_count);

    var players = try lev.server.listPlayers(alloc);
    defer players.deinit();
    try std.testing.expectEqualStrings("Steve", players.items[0].name);
    try std.testing.expectEqual(@as(f64, -2.5), players.items[0].z);
}

test "the registries are read from JSON with the defaults of the struct" {
    try install();
    var blocks = try lev.registry.blocks(alloc);
    defer blocks.deinit();
    try std.testing.expectEqualStrings("minecraft:stone", blocks.items[0].name);
    try std.testing.expectEqual(@as(i32, 1), blocks.items[0].category);
    try std.testing.expect(blocks.items[0].solid);
    try std.testing.expect(!blocks.items[0].vanilla);
    try std.testing.expectEqual(@as(f64, 1.5), blocks.items[0].destroy);

    var entities = try lev.registry.entities(alloc);
    defer entities.deinit();
    try std.testing.expect(entities.items[0].isMonster());
    try std.testing.expect(entities.items[0].spawn_egg);
    try std.testing.expect(entities.items[1].isWaterAnimal());
    try std.testing.expect(!entities.items[1].isAnimal());

    var commands = try lev.registry.commands(alloc);
    defer commands.deinit();
    try std.testing.expectEqual(@as(usize, 2), commands.items[0].aliases.len);
    try std.testing.expectEqualStrings("tele", commands.items[0].aliases[1]);
}

test "the scoreboard reads numbers and lists without an allocator for a number" {
    try install();
    try std.testing.expectEqual(@as(?i64, 7), try lev.scoreboard.score("kills", "Steve"));
    try std.testing.expectEqual(@as(i64, 12), try lev.scoreboard.setScore("kills", "Steve", 12));
    try lev.scoreboard.addObjective("fresh", "Fresh");
    try std.testing.expectError(error.Refused, lev.scoreboard.addObjective("taken", "Taken"));
    var objectives = try lev.scoreboard.objectives(alloc);
    defer objectives.deinit();
    try std.testing.expectEqual(@as(usize, 2), objectives.items.len);
    try std.testing.expectEqualStrings("Kills", objectives.items[0].display_name);
    try std.testing.expectEqualStrings("deaths", objectives.items[1].display_name);
}

var seen_button: ?usize = null;
var seen_name: [32]u8 = undefined;
var seen_name_len: usize = 0;
var seen_hard: bool = false;
var seen_cancel: bool = false;

fn onAnswer(_: ?*anyopaque, response: lev.gui.Response) void {
    seen_cancel = response.isCancelled();
    switch (response) {
        .button => |i| seen_button = i,
        .custom => {
            const name = response.value("name").?.asText().?;
            @memcpy(seen_name[0..name.len], name);
            seen_name_len = name.len;
            seen_hard = std.mem.eql(u8, response.text("level").?, "Hard") and response.value("level").?.asIndex().? == 2 and response.value("on").?.asBool().?;
        },
        else => {},
    }
}

fn callForm(answer: []const u8) void {
    form_cb.?(form_user, lev.str(answer));
}

test "a simple form is sent in the wire format and its answer is parsed" {
    try install();
    var form = lev.gui.SimpleForm.init(alloc, "Menu");
    defer form.deinit();
    form.setContent("Pick one");
    try form.button("A");
    try form.buttonWithImage("B", "textures/x", "path");
    try form.send(lev.Player.byName("Steve"), null, onAnswer);
    try std.testing.expectEqual(@as(i32, 0), sent_form_kind);
    try std.testing.expectEqualStrings(
        "{\"title\":\"Menu\",\"content\":\"Pick one\",\"elements\":[{\"kind\":\"button\",\"text\":\"A\"},{\"kind\":\"button\",\"text\":\"B\",\"image\":\"textures/x\",\"image_type\":\"path\"}]}",
        sent_form[0..sent_form_len],
    );
    callForm("{button:1}");
    try std.testing.expectEqual(@as(?usize, 1), seen_button);

    var empty = lev.gui.SimpleForm.init(alloc, "Nothing");
    defer empty.deinit();
    try std.testing.expectError(error.Refused, empty.send(lev.Player.byName("Steve"), null, onAnswer));
}

test "a custom form is sent with its controls and answered by name" {
    try install();
    var form = lev.gui.CustomForm.init(alloc, "Settings");
    defer form.deinit();
    form.setSubmit("Save");
    try form.input("name", "Name", "type here", "");
    try form.toggle("on", "Enabled", true);
    try form.dropdown("level", "Level", &.{ "Easy", "Normal", "Hard" }, 1);
    try form.slider("amount", "Amount", 0, 10, 0.5, 2);
    try form.send(lev.Player.byName("Steve"), null, onAnswer);
    try std.testing.expectEqual(@as(i32, 1), sent_form_kind);
    const sent = sent_form[0..sent_form_len];
    try std.testing.expect(std.mem.indexOf(u8, sent, "\"submit\":\"Save\"") != null);
    try std.testing.expect(std.mem.indexOf(u8, sent, "{\"kind\":\"toggle\",\"name\":\"on\",\"text\":\"Enabled\",\"default\":1.0d}") != null);
    try std.testing.expect(std.mem.indexOf(u8, sent, "\"options\":[\"Easy\",\"Normal\",\"Hard\"],\"default\":1.0d") != null);
    try std.testing.expect(std.mem.indexOf(u8, sent, "\"min\":0.0d,\"max\":10.0d,\"step\":0.5d,\"default\":2.0d") != null);
    callForm("{values:{name:\"Alex\",on:1b,level:2},texts:{level:\"Hard\"}}");
    try std.testing.expectEqualStrings("Alex", seen_name[0..seen_name_len]);
    try std.testing.expect(seen_hard);
    callForm("{cancelled:1b,reason:1}");
    try std.testing.expect(seen_cancel);
}

var typed_total: i64 = 0;
var typed_overload: i32 = -1;
var typed_player: [16]u8 = undefined;
var typed_player_len: usize = 0;

fn onTyped(call: *lev.command.Call) void {
    typed_total += call.argInt("amount") orelse 0;
    typed_overload = call.overload() orelse -1;
    const origin = call.origin();
    if (origin.playerName()) |who| {
        @memcpy(typed_player[0..who.len], who);
        typed_player_len = who.len;
    }
}

test "a typed command sends its overloads and reads its arguments by name" {
    try install();
    var pay = lev.command.Overload.init(alloc);
    defer pay.deinit();
    try pay.text("verb", "pay");
    try pay.required("amount", .int);
    try pay.optional("who", .player);
    var builder = lev.command.Builder.init(alloc, "money", "money commands", .any);
    defer builder.deinit();
    try builder.addOverload(&pay);
    try builder.register(onTyped);
    try std.testing.expectEqualStrings(
        "{\"overloads\":[[{\"name\":\"verb\",\"kind\":\"text\",\"text\":\"pay\"},{\"name\":\"amount\",\"kind\":\"int\",\"optional\":0b},{\"name\":\"who\",\"kind\":\"player\",\"optional\":1b}]]}",
        sent_command[0..sent_command_len],
    );
    command_cb.?(null, lev.str("{overload:0,args:{amount:25}}"), lev.str("{name:\"Steve\",type:0,dim:0,x:1.0d,y:2.0d,z:3.0d}"), null, null, null);
    try std.testing.expectEqual(@as(i64, 25), typed_total);
    try std.testing.expectEqual(@as(i32, 0), typed_overload);
    try std.testing.expectEqualStrings("Steve", typed_player[0..typed_player_len]);

    var empty = lev.command.Builder.init(alloc, "none", "", .any);
    defer empty.deinit();
    try std.testing.expectError(error.Refused, empty.register(onTyped));
}

test "the key-value store gives back what it holds and owns what it returns" {
    try install();
    var db = try lev.kvdb.KvDb.open("data/test.db");
    defer db.close();
    const value = (try db.get(alloc, "k1")).?;
    defer alloc.free(value);
    try std.testing.expectEqualStrings("v1", value);
    try std.testing.expectEqual(@as(?[]u8, null), try db.get(alloc, "missing"));
    var pairs = try db.pairs(alloc);
    defer pairs.deinit();
    try std.testing.expectEqual(@as(usize, 2), pairs.items.len);
    try std.testing.expectEqualStrings("2", pairs.items[1].value);
}

test "a lane lease keeps the provider from unloading under a call" {
    try install();
    switch (try lev.lane.acquire("missing", 0xABCD)) {
        .not_found => {},
        else => return error.WrongOutcome,
    }
    switch (try lev.lane.acquire("demo", 0x9999)) {
        .fingerprint => |theirs| try std.testing.expectEqual(@as(u64, 0x1234), theirs),
        else => return error.WrongOutcome,
    }
    var lease = switch (try lev.lane.acquire("demo", 0xABCD)) {
        .lease => |l| l,
        else => return error.WrongOutcome,
    };
    try std.testing.expect(lease.isAlive());
    {
        const inside = lease.enter().?;
        defer inside.leave();
        try std.testing.expectEqual(@as(u32, 1), lane_busy);
        try std.testing.expectEqual(@as(u32, 99), inside.table(u32).*);
    }
    try std.testing.expectEqual(@as(u32, 0), lane_busy);
    lane_alive = 0;
    try std.testing.expect(lease.enter() == null);
    try std.testing.expectEqual(@as(u32, 0), lane_busy);
    lane_alive = 1;
    _ = &lease;
}

test "dimensions and the effects of an actor are parsed from what the host sinks" {
    try install();
    var dims = try lev.dimensions.list(alloc);
    defer dims.deinit();
    try std.testing.expectEqual(@as(usize, 1), dims.items.len);
    try std.testing.expectEqual(@as(i32, 1000), dims.items[0].dim);
    try std.testing.expectEqualStrings("{seed:1}", dims.items[0].snbt);

    const who = lev.Entity.of(77);
    var effects = try who.effects(alloc);
    defer effects.deinit();
    try std.testing.expectEqual(@as(usize, 2), effects.items.len);
    try std.testing.expectEqualStrings("speed", effects.items[0].id);
    try std.testing.expectEqual(@as(i32, 200), effects.items[0].ticks);
    try std.testing.expectEqualStrings("5", effects.items[1].id);
    try std.testing.expect(effects.items[1].visible);

    const hit = try who.traceRay(alloc, 5, true, true);
    defer hit.deinit(alloc);
    try std.testing.expectEqualStrings("minecraft:stone", hit.block.name);
    try std.testing.expectEqual(@as(i32, 64), hit.block.block.y);
    try std.testing.expectEqual(@as(i32, 1), hit.block.facing);
}

test "a player's equipment, network status and cooldown come back typed" {
    try install();
    const steve = lev.Player.byName("Steve");
    var equipment = try steve.equipment(alloc);
    defer equipment.deinit();
    try std.testing.expectEqual(@as(usize, 2), equipment.items.len);
    try std.testing.expectEqual(@as(i32, 2), equipment.items[1].slot);
    const net = try steve.networkDetail(alloc);
    try std.testing.expectEqual(@as(i32, 40), net.ping);
    try std.testing.expectEqual(@as(i32, -1), net.max_ping);
    try std.testing.expectEqual(@as(?i32, 60), try steve.cooldown("minecraft:ender_pearl"));
    try std.testing.expectEqual(@as(?i32, null), try steve.cooldown("minecraft:apple"));
}

var packet_seen_id: i32 = -1;

fn onPacket(packet: *lev.packet.Packet) lev.packet.Verdict {
    packet_seen_id = packet.packetId();
    if (packet.packetId() == 7) return .drop;
    packet.setPacketId(9);
    return .forward;
}

test "a packet handler's verdict becomes the code the host expects" {
    try install();
    var hook = try lev.packet.intercept(.both, onPacket);
    _ = &hook;
    var edit = std.mem.zeroes(c.PierPacketEdit);
    var ev = std.mem.zeroes(c.PierPacketEvent);
    ev.struct_size = @sizeOf(c.PierPacketEvent);
    ev.packet_id = 3;
    try std.testing.expectEqual(@as(i32, c.PIER_PKT_PASS), packet_cb.?(null, &ev, &edit, null, null));
    try std.testing.expectEqual(@as(i32, 9), edit.packet_id);
    ev.packet_id = 7;
    try std.testing.expectEqual(@as(i32, c.PIER_PKT_DROP), packet_cb.?(null, &ev, &edit, null, null));
    try std.testing.expectEqual(@as(i32, 7), packet_seen_id);
}

test "an item is built and its enchantment list is typed" {
    try install();
    const snbt = try lev.Item.create(alloc, "minecraft:apple", 200);
    defer alloc.free(snbt);
    try std.testing.expectEqualStrings("{\"Name\":\"minecraft:apple\",\"Count\":127b}", snbt);
    const bounds = lev.types.Bounds.init(.{ .x = 5, .y = 10, .z = -3 }, .{ .x = 1, .y = 12, .z = -1 });
    try std.testing.expectEqual(@as(u64, 45), bounds.volume());
    try std.testing.expect(bounds.contains(.{ .x = 5, .y = 12, .z = -1 }));
    try std.testing.expect(!bounds.contains(.{ .x = 6, .y = 10, .z = -3 }));
}
