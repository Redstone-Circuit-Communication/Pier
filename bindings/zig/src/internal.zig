//! internal.zig: parsing helpers the modules of the binding share. Not part of the public
//! surface: levilamina.zig does not re-export it.

const std = @import("std");
const core = @import("core.zig");
const nbt = @import("nbt.zig");
const types = @import("types.zig");

/// SNBT from the host as a value, allocated with arena. A text the parser refuses is NoAnswer,
/// since the host sent something that is not the shape its slot documents.
pub fn parse(arena: std.mem.Allocator, text: []const u8) core.Error!nbt.Value {
    return nbt.parse(arena, text) catch |parse_err| switch (parse_err) {
        error.OutOfMemory => error.OutOfMemory,
        else => error.NoAnswer,
    };
}

pub fn intOf(v: nbt.Value) ?i32 {
    const wide: i64 = switch (v) {
        .byte => |n| n,
        .short => |n| n,
        .int => |n| n,
        .long => |n| n,
        else => return null,
    };
    return std.math.cast(i32, wide);
}

pub fn floatOf(v: nbt.Value) ?f64 {
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

/// A list of three numbers as a block position.
pub fn posOf(v: nbt.Value) ?types.Pos3 {
    const list = switch (v) {
        .list => |items| items,
        else => return null,
    };
    if (list.len != 3) return null;
    return .{ .x = intOf(list[0]) orelse return null, .y = intOf(list[1]) orelse return null, .z = intOf(list[2]) orelse return null };
}

/// A list of three numbers as a point.
pub fn vecOf(v: nbt.Value) ?types.Vec3 {
    const list = switch (v) {
        .list => |items| items,
        else => return null,
    };
    if (list.len != 3) return null;
    return .{ .x = floatOf(list[0]) orelse return null, .y = floatOf(list[1]) orelse return null, .z = floatOf(list[2]) orelse return null };
}

/// The compound at `path` read as `{min:[x,y,z], max:[x,y,z]}`.
pub fn boundsAt(v: nbt.Value, path: []const u8) ?types.Bounds {
    const at = v.get(path) orelse return null;
    const lo = posOf(at.get("min") orelse return null) orelse return null;
    const hi = posOf(at.get("max") orelse return null) orelse return null;
    return .{ .min = lo, .max = hi };
}

/// The last piece a sink received, kept in a fixed buffer, for the slots that answer with a
/// number or a short word, where an allocator would be more than the answer is worth.
pub const SmallText = struct {
    buf: [128]u8 = undefined,
    len: usize = 0,
    got: bool = false,
    overflow: bool = false,

    pub fn sink(ctx: ?*anyopaque, piece: core.c.PierStr) callconv(.c) void {
        const self: *SmallText = @ptrCast(@alignCast(ctx orelse return));
        const bytes = core.view(piece);
        const n = @min(bytes.len, self.buf.len);
        @memcpy(self.buf[0..n], bytes[0..n]);
        self.len = n;
        self.got = true;
        self.overflow = bytes.len > self.buf.len;
    }

    pub fn text(self: *const SmallText) []const u8 {
        return self.buf[0..self.len];
    }
};

/// Reads a JSON object into a struct by field name, with the struct's own defaults for what
/// the object lacks. Booleans, integers, floats, strings and lists of strings are the field
/// types it knows; a number that is whole is accepted for an integer field whatever its
/// spelling, since the host writes some counts as `3.0`. Strings and lists are copied with
/// `arena`. A struct whose key differs from its field name says so in a `json_keys` declaration,
/// such as `.{ .type_id = "type" }`.
pub fn fromJson(comptime T: type, arena: std.mem.Allocator, object: std.json.ObjectMap) std.mem.Allocator.Error!T {
    var out: T = undefined;
    inline for (@typeInfo(T).@"struct".fields) |field| {
        const key = comptime jsonKey(T, field.name);
        const present = object.get(key);
        @field(out, field.name) = if (field.defaultValue()) |d| d else std.mem.zeroes(field.type);
        if (present) |value| {
            switch (@typeInfo(field.type)) {
                .bool => if (value == .bool) {
                    @field(out, field.name) = value.bool;
                },
                .int => if (wholeOf(value)) |n| {
                    if (std.math.cast(field.type, n)) |narrow| @field(out, field.name) = narrow;
                },
                .float => switch (value) {
                    .float => |x| @field(out, field.name) = @floatCast(x),
                    .integer => |n| @field(out, field.name) = @floatFromInt(n),
                    else => {},
                },
                .pointer => |ptr| if (ptr.child == u8) {
                    if (value == .string) @field(out, field.name) = try arena.dupe(u8, value.string);
                } else if (value == .array) {
                    const items = try arena.alloc([]const u8, value.array.items.len);
                    var n: usize = 0;
                    for (value.array.items) |item| {
                        if (item != .string) continue;
                        items[n] = try arena.dupe(u8, item.string);
                        n += 1;
                    }
                    @field(out, field.name) = items[0..n];
                },
                else => {},
            }
        }
    }
    return out;
}

fn jsonKey(comptime T: type, comptime name: []const u8) []const u8 {
    if (@hasDecl(T, "json_keys") and @hasField(@TypeOf(T.json_keys), name)) return @field(T.json_keys, name);
    return name;
}

fn wholeOf(value: std.json.Value) ?i64 {
    return switch (value) {
        .integer => |n| n,
        .float => |x| if (@floor(x) == x and @abs(x) < 9.0e18) @as(i64, @intFromFloat(x)) else null,
        else => null,
    };
}
