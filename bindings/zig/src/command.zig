//! command.zig: commands with typed overloads, and the enums their parameters can name. A
//! command registered here declares its parameters, so the engine parses, completes and checks
//! what the player types, and the handler reads each argument by name.

const std = @import("std");
const core = @import("core.zig");
const nbt = @import("nbt.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The type of one parameter inside one overload.
pub const ParamType = enum {
    int,
    boolean,
    float,
    string,
    enumeration,
    soft_enum,
    actor,
    player,
    block_pos,
    vec3,
    raw_text,
    message,
    json,
    item,
    block_name,
    effect,
    actor_type,
    command,
    relative_float,
    file_path,

    /// The spelling on the ABI. The host dispatches on this string, and a typo drops the whole
    /// command.
    pub fn name(self: ParamType) []const u8 {
        return switch (self) {
            .boolean => "bool",
            .enumeration => "enum",
            else => @tagName(self),
        };
    }
};

/// Where a command came from.
pub const Origin = struct {
    name: []const u8,
    /// The engine's origin type: 0 for a player, 7 for the console, -1 when the host sent only
    /// a name.
    kind: i32,
    /// The dimension and the position the command ran at, when the host gave them.
    at: ?struct { dim: i32, x: f64, y: f64, z: f64 },

    pub const player_kind: i32 = 0;
    pub const dedicated_server_kind: i32 = 7;

    pub fn isConsole(self: Origin) bool {
        return self.kind == dedicated_server_kind;
    }

    /// The player name when the origin is a player.
    pub fn playerName(self: Origin) ?[]const u8 {
        return if (self.kind == player_kind) self.name else null;
    }
};

/// One run of a typed command. Valid during the handler only.
pub const Call = struct {
    invocation: *const core.Invocation,
    arena: std.heap.ArenaAllocator,
    parsed: ?nbt.Value = null,
    parse_failed: bool = false,

    /// The raw argument text, the SNBT the host handed over.
    pub fn raw(self: *const Call) []const u8 {
        return self.invocation.args;
    }

    /// Sends one success output.
    pub fn success(self: *const Call, message: []const u8) void {
        self.invocation.success(message);
    }

    /// Sends one error output, a separate channel the client colors differently.
    pub fn failure(self: *const Call, message: []const u8) void {
        self.invocation.failure(message);
    }

    fn root(self: *Call) ?nbt.Value {
        if (self.parsed) |v| return v;
        if (self.parse_failed) return null;
        const v = nbt.parse(self.arena.allocator(), self.invocation.args) catch {
            self.parse_failed = true;
            return null;
        };
        self.parsed = v;
        return v;
    }

    /// Which overload matched, counting from 0.
    pub fn overload(self: *Call) ?i32 {
        const r = self.root() orelse return null;
        return std.math.cast(i32, r.getInt("overload") orelse return null);
    }

    /// Reads a named argument. An omitted optional argument gives null.
    pub fn arg(self: *Call, name: []const u8) ?nbt.Value {
        const r = self.root() orelse return null;
        var path_buf: [128]u8 = undefined;
        const path = std.fmt.bufPrint(&path_buf, "args.{s}", .{name}) catch return null;
        return r.get(path);
    }

    pub fn argString(self: *Call, name: []const u8) ?[]const u8 {
        const v = self.arg(name) orelse return null;
        return switch (v) {
            .string => |s| s,
            else => null,
        };
    }

    pub fn argInt(self: *Call, name: []const u8) ?i64 {
        const v = self.arg(name) orelse return null;
        return switch (v) {
            .byte => |n| n,
            .short => |n| n,
            .int => |n| n,
            .long => |n| n,
            else => null,
        };
    }

    pub fn argFloat(self: *Call, name: []const u8) ?f64 {
        const v = self.arg(name) orelse return null;
        return switch (v) {
            .float => |x| x,
            .double => |x| x,
            .byte => |n| @floatFromInt(n),
            .short => |n| @floatFromInt(n),
            .int => |n| @floatFromInt(n),
            .long => |n| @floatFromInt(n),
            else => null,
        };
    }

    pub fn argBool(self: *Call, name: []const u8) ?bool {
        const v = self.arg(name) orelse return null;
        return switch (v) {
            .byte => |n| n != 0,
            else => null,
        };
    }

    /// The origin of the run.
    pub fn origin(self: *Call) Origin {
        const text = self.invocation.origin;
        const v = nbt.parse(self.arena.allocator(), text) catch return .{ .name = text, .kind = -1, .at = null };
        const who = v.getString("name") orelse return .{ .name = text, .kind = -1, .at = null };
        const at: @FieldType(Origin, "at") = blk: {
            const dim = v.getInt("dim") orelse break :blk null;
            const x = v.getFloat("x") orelse break :blk null;
            const y = v.getFloat("y") orelse break :blk null;
            const z = v.getFloat("z") orelse break :blk null;
            break :blk .{ .dim = std.math.cast(i32, dim) orelse break :blk null, .x = x, .y = y, .z = z };
        };
        return .{ .name = who, .kind = std.math.cast(i32, v.getInt("type") orelse -1) orelse -1, .at = at };
    }
};

fn parameter(allocator: Allocator, text: *std.ArrayList(u8), name: []const u8, kind: []const u8, optional: ?bool, enum_name: ?[]const u8, literal: ?[]const u8) Allocator.Error!void {
    var w = nbt.Writer.init(allocator);
    defer w.deinit();
    try w.beginCompound();
    try w.key("name");
    try w.string(name);
    try w.key("kind");
    try w.string(kind);
    if (optional) |o| {
        try w.key("optional");
        try w.boolean(o);
    }
    if (enum_name) |e| {
        try w.key("enum");
        try w.string(e);
    }
    if (literal) |l| {
        try w.key("text");
        try w.string(l);
    }
    try w.endCompound();
    if (text.items.len != 0) try text.append(allocator, ',');
    try text.appendSlice(allocator, w.text());
}

/// The declaration of one overload.
pub const Overload = struct {
    allocator: Allocator,
    params: std.ArrayList(u8) = .empty,

    pub fn init(allocator: Allocator) Overload {
        return .{ .allocator = allocator };
    }

    pub fn deinit(self: *Overload) void {
        self.params.deinit(self.allocator);
    }

    pub fn required(self: *Overload, name: []const u8, kind: ParamType) Allocator.Error!void {
        try parameter(self.allocator, &self.params, name, kind.name(), false, null, null);
    }

    pub fn optional(self: *Overload, name: []const u8, kind: ParamType) Allocator.Error!void {
        try parameter(self.allocator, &self.params, name, kind.name(), true, null, null);
    }

    /// A literal: a fixed word the player types, and a node in the command tree.
    pub fn text(self: *Overload, name: []const u8, literal: []const u8) Allocator.Error!void {
        try parameter(self.allocator, &self.params, name, "text", null, null, literal);
    }

    pub fn requiredEnum(self: *Overload, name: []const u8, kind: ParamType, enum_name: []const u8) Allocator.Error!void {
        try parameter(self.allocator, &self.params, name, kind.name(), false, enum_name, null);
    }

    pub fn optionalEnum(self: *Overload, name: []const u8, kind: ParamType, enum_name: []const u8) Allocator.Error!void {
        try parameter(self.allocator, &self.params, name, kind.name(), true, enum_name, null);
    }
};

/// A command with typed overloads. `name` and `description` are borrowed and must outlive the
/// registration.
pub const Builder = struct {
    allocator: Allocator,
    name: []const u8,
    description: []const u8,
    permission: core.Permission,
    overloads: std.ArrayList(u8) = .empty,
    count: usize = 0,

    pub fn init(allocator: Allocator, name: []const u8, description: []const u8, permission: core.Permission) Builder {
        return .{ .allocator = allocator, .name = name, .description = description, .permission = permission };
    }

    pub fn deinit(self: *Builder) void {
        self.overloads.deinit(self.allocator);
    }

    /// Adds one overload. At least one is required.
    pub fn addOverload(self: *Builder, overload: *const Overload) Allocator.Error!void {
        if (self.overloads.items.len != 0) try self.overloads.append(self.allocator, ',');
        try self.overloads.append(self.allocator, '[');
        try self.overloads.appendSlice(self.allocator, overload.params.items);
        try self.overloads.append(self.allocator, ']');
        self.count += 1;
    }

    /// Registers it, from enable. A command with no overload is Refused, since the host refuses
    /// outright; the plain `registerCommand` is for a command with no argument. A name that is
    /// taken with a different shape, or a misspelled parameter type, is Refused as well.
    pub fn register(self: *const Builder, comptime handler: fn (*Call) void) core.Error!void {
        const f = core.slot("register_command_ex") orelse return error.NotProvided;
        if (self.count == 0) return error.Refused;
        var w = nbt.Writer.init(self.allocator);
        defer w.deinit();
        try w.beginCompound();
        try w.key("overloads");
        try w.beginList();
        try w.raw(self.overloads.items);
        try w.endList();
        try w.endCompound();
        const Trampoline = struct {
            fn call(_: ?*anyopaque, args: c.PierStr, origin: c.PierStr, ctx: ?*anyopaque, ok: c.PierStrSink, fail: c.PierStrSink) callconv(.c) void {
                const inv = core.Invocation{ .args = core.view(args), .origin = core.view(origin), .ctx = ctx, .ok = ok, .fail = fail };
                var typed = Call{ .invocation = &inv, .arena = std.heap.ArenaAllocator.init(std.heap.page_allocator) };
                defer typed.arena.deinit();
                handler(&typed);
            }
        };
        try core.expect(f(core.handle(), core.str(self.name), core.str(self.description), @intFromEnum(self.permission), core.str(w.text()), &Trampoline.call, null));
    }
};

/// Registers a static enum, each value a name and a number, for a parameter to reference.
pub fn registerEnum(allocator: Allocator, name: []const u8, values: []const struct { []const u8, u64 }) core.Error!void {
    const f = core.slot("register_command_enum") orelse return error.NotProvided;
    var w = nbt.Writer.init(allocator);
    defer w.deinit();
    try w.beginCompound();
    try w.key("values");
    try w.beginList();
    for (values) |entry| {
        try w.beginList();
        try w.string(entry[0]);
        try w.long(@bitCast(entry[1]));
        try w.endList();
    }
    try w.endList();
    try w.endCompound();
    try core.expect(f(core.str(name), core.str(w.text())));
}

fn softEnumText(allocator: Allocator, w: *nbt.Writer, values: []const []const u8) Allocator.Error!void {
    _ = allocator;
    try w.beginCompound();
    try w.key("values");
    try w.beginList();
    for (values) |value| try w.string(value);
    try w.endList();
    try w.endCompound();
}

/// Registers a soft enum, one whose values can change at runtime, for a parameter to reference.
pub fn registerSoftEnum(allocator: Allocator, name: []const u8, values: []const []const u8) core.Error!void {
    const f = core.slot("register_command_soft_enum") orelse return error.NotProvided;
    var w = nbt.Writer.init(allocator);
    defer w.deinit();
    try softEnumText(allocator, &w, values);
    try core.expect(f(core.str(name), core.str(w.text())));
}

/// How `updateSoftEnum` changes the values of a soft enum.
pub const SoftEnumOp = enum(i32) { set = 0, add = 1, remove = 2 };

/// Changes the values of a soft enum. Refused for a name that was never registered.
pub fn updateSoftEnum(allocator: Allocator, name: []const u8, op: SoftEnumOp, values: []const []const u8) core.Error!void {
    const f = core.slot("update_command_soft_enum") orelse return error.NotProvided;
    var w = nbt.Writer.init(allocator);
    defer w.deinit();
    try softEnumText(allocator, &w, values);
    try core.expect(f(core.str(name), @intFromEnum(op), core.str(w.text())));
}
