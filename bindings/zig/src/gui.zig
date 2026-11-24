//! gui.zig: forms. A simple form is a column of buttons, a modal form is some text and two
//! buttons, and a custom form holds inputs, toggles, dropdowns and sliders.
//!
//! A form is built on the caller's allocator and sent once. The answer arrives in a handler
//! that receives the `user` pointer given at send, on the server thread; a handler that wants
//! to keep anything from the response copies it, since the strings are valid during the call.

const std = @import("std");
const core = @import("core.zig");
const nbt = @import("nbt.zig");
const props = @import("props_gen.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The value one control of a custom form returns.
pub const FormValue = union(enum) {
    index: usize,
    number: f64,
    text: []const u8,
    boolean: bool,

    /// The chosen position of a dropdown or a step slider.
    pub fn asIndex(self: FormValue) ?usize {
        return switch (self) {
            .index => |i| i,
            .number => |n| if (n >= 0) @intFromFloat(n) else null,
            else => null,
        };
    }

    pub fn asF64(self: FormValue) ?f64 {
        return switch (self) {
            .number => |n| n,
            .index => |i| @floatFromInt(i),
            .boolean => |b| if (b) 1.0 else 0.0,
            .text => null,
        };
    }

    pub fn asI64(self: FormValue) ?i64 {
        const n = self.asF64() orelse return null;
        return @intFromFloat(n);
    }

    pub fn asBool(self: FormValue) ?bool {
        return switch (self) {
            .boolean => |b| b,
            .number => |n| n != 0,
            .index => |i| i != 0,
            .text => null,
        };
    }

    pub fn asText(self: FormValue) ?[]const u8 {
        return switch (self) {
            .text => |t| t,
            else => null,
        };
    }
};

/// The answers of a custom form, one entry per named control.
pub const Custom = struct {
    entries: []const Entry,

    pub const Entry = struct {
        name: []const u8,
        value: FormValue,
        /// The text of the selected item, for a control that has one.
        text: ?[]const u8,
    };

    /// The value of one control.
    pub fn value(self: Custom, name: []const u8) ?FormValue {
        for (self.entries) |entry| {
            if (std.mem.eql(u8, entry.name, name)) return entry.value;
        }
        return null;
    }

    /// The text of the selected item of one control.
    pub fn text(self: Custom, name: []const u8) ?[]const u8 {
        for (self.entries) |entry| {
            if (std.mem.eql(u8, entry.name, name)) return entry.text;
        }
        return null;
    }
};

/// A player's answer to a form.
pub const Response = union(enum) {
    /// The player closed the form; the reason is the engine's cancel code, or -1.
    cancelled: i32,
    /// The index of the button a simple form's player pressed.
    button: usize,
    /// Whether the player pressed the upper button of a modal form.
    modal: bool,
    custom: Custom,
    /// An answer in a shape this binding does not know, as the host wrote it.
    unknown: []const u8,

    pub fn isCancelled(self: Response) bool {
        return self == .cancelled;
    }

    /// The value of one control of a custom form.
    pub fn value(self: Response, name: []const u8) ?FormValue {
        return switch (self) {
            .custom => |custom| custom.value(name),
            else => null,
        };
    }

    /// The text of the selected item of one control of a custom form.
    pub fn text(self: Response, name: []const u8) ?[]const u8 {
        return switch (self) {
            .custom => |custom| custom.text(name),
            else => null,
        };
    }
};

/// What a handler receives: the `user` pointer given at send and the answer.
pub const Handler = fn (user: ?*anyopaque, response: Response) void;

fn formValueOf(v: nbt.Value) FormValue {
    switch (v) {
        .string => |s| return .{ .text = s },
        .double => |d| return .{ .number = d },
        .float => |f| return .{ .number = f },
        else => {},
    }
    const wide: i64 = switch (v) {
        .byte => |n| n,
        .short => |n| n,
        .int => |n| n,
        .long => |n| n,
        else => return .{ .text = "" },
    };
    if (wide >= 0) return .{ .index = @intCast(wide) };
    return .{ .number = @floatFromInt(wide) };
}

fn parseResponse(arena: Allocator, raw: []const u8) Response {
    const v = nbt.parse(arena, raw) catch return .{ .unknown = raw };
    if (v.getBool("cancelled") orelse false) {
        return .{ .cancelled = std.math.cast(i32, v.getInt("reason") orelse -1) orelse -1 };
    }
    if (v.get("button")) |button| switch (button) {
        .string => |which| return .{ .modal = std.mem.eql(u8, which, "upper") },
        .byte, .short, .int, .long => {
            const n = v.getInt("button") orelse -1;
            if (n >= 0) return .{ .button = @intCast(n) };
        },
        else => {},
    };
    const values = v.get("values") orelse return .{ .unknown = raw };
    const compound = switch (values) {
        .compound => |entries| entries,
        else => return .{ .unknown = raw },
    };
    const texts: []const nbt.Entry = if (v.get("texts")) |t| switch (t) {
        .compound => |entries| entries,
        else => &.{},
    } else &.{};
    const out = arena.alloc(Custom.Entry, compound.len) catch return .{ .unknown = raw };
    for (compound, 0..) |entry, i| {
        var selected: ?[]const u8 = null;
        for (texts) |t| {
            if (std.mem.eql(u8, t.key, entry.key)) {
                selected = switch (t.value) {
                    .string => |s| s,
                    else => null,
                };
            }
        }
        out[i] = .{ .name = entry.key, .value = formValueOf(entry.value), .text = selected };
    }
    return .{ .custom = .{ .entries = out } };
}

fn submit(player: props.Player, kind: i32, spec: []const u8, user: ?*anyopaque, comptime handler: Handler) core.Error!void {
    const f = core.slot("form_send") orelse return error.NotProvided;
    const Trampoline = struct {
        fn call(user_ptr: ?*anyopaque, result: c.PierStr) callconv(.c) void {
            var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
            defer arena.deinit();
            handler(user_ptr, parseResponse(arena.allocator(), core.view(result)));
        }
    };
    if (!f(core.handle(), player.cSel(), kind, core.str(spec), &Trampoline.call, user)) return error.Refused;
}

/// Appends one element, as a compound of string entries, to the comma separated text a form
/// keeps its elements in.
fn element(allocator: Allocator, elements: *std.ArrayList(u8), kind: []const u8, pairs: []const [2][]const u8) Allocator.Error!void {
    var w = nbt.Writer.init(allocator);
    defer w.deinit();
    try w.beginCompound();
    try w.key("kind");
    try w.string(kind);
    for (pairs) |pair| {
        try w.key(pair[0]);
        try w.string(pair[1]);
    }
    try w.endCompound();
    if (elements.items.len != 0) try elements.append(allocator, ',');
    try elements.appendSlice(allocator, w.text());
}

/// A simple form: a column of buttons. `title` and `content` are borrowed and must outlive
/// the send.
pub const SimpleForm = struct {
    allocator: Allocator,
    title: []const u8,
    content: []const u8 = "",
    elements: std.ArrayList(u8) = .empty,
    buttons: usize = 0,

    pub fn init(allocator: Allocator, title: []const u8) SimpleForm {
        return .{ .allocator = allocator, .title = title };
    }

    pub fn deinit(self: *SimpleForm) void {
        self.elements.deinit(self.allocator);
    }

    pub fn setContent(self: *SimpleForm, content: []const u8) void {
        self.content = content;
    }

    pub fn button(self: *SimpleForm, text: []const u8) Allocator.Error!void {
        try element(self.allocator, &self.elements, "button", &.{.{ "text", text }});
        self.buttons += 1;
    }

    /// A button with an icon. `image_type` is "path" or "url".
    pub fn buttonWithImage(self: *SimpleForm, text: []const u8, image: []const u8, image_type: []const u8) Allocator.Error!void {
        try element(self.allocator, &self.elements, "button", &.{ .{ "text", text }, .{ "image", image }, .{ "image_type", image_type } });
        self.buttons += 1;
    }

    pub fn header(self: *SimpleForm, text: []const u8) Allocator.Error!void {
        try element(self.allocator, &self.elements, "header", &.{.{ "text", text }});
    }

    pub fn label(self: *SimpleForm, text: []const u8) Allocator.Error!void {
        try element(self.allocator, &self.elements, "label", &.{.{ "text", text }});
    }

    pub fn divider(self: *SimpleForm) Allocator.Error!void {
        try element(self.allocator, &self.elements, "divider", &.{});
    }

    /// Sends it. A form with no button at all is Refused, since a player cannot press it.
    pub fn send(self: *const SimpleForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void {
        if (self.buttons == 0) return error.Refused;
        var w = nbt.Writer.init(self.allocator);
        defer w.deinit();
        try w.beginCompound();
        try w.key("title");
        try w.string(self.title);
        try w.key("content");
        try w.string(self.content);
        try w.key("elements");
        try w.beginList();
        try w.raw(self.elements.items);
        try w.endList();
        try w.endCompound();
        try submit(player, 0, w.text(), user, handler);
    }
};

/// A modal form: some text and two buttons. Every string is borrowed and must outlive the
/// send.
pub const ModalForm = struct {
    allocator: Allocator,
    title: []const u8,
    content: []const u8,
    upper: []const u8 = "OK",
    lower: []const u8 = "Cancel",

    pub fn init(allocator: Allocator, title: []const u8, content: []const u8) ModalForm {
        return .{ .allocator = allocator, .title = title, .content = content };
    }

    pub fn send(self: *const ModalForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void {
        var w = nbt.Writer.init(self.allocator);
        defer w.deinit();
        try w.beginCompound();
        try w.key("title");
        try w.string(self.title);
        try w.key("content");
        try w.string(self.content);
        try w.key("upper");
        try w.string(self.upper);
        try w.key("lower");
        try w.string(self.lower);
        try w.endCompound();
        try submit(player, 2, w.text(), user, handler);
    }
};

/// A custom form: input fields, toggles, dropdowns and sliders, each named so the answer can
/// be read by name. `title` is borrowed and must outlive the send.
pub const CustomForm = struct {
    allocator: Allocator,
    title: []const u8,
    submit_text: ?[]const u8 = null,
    elements: std.ArrayList(u8) = .empty,

    pub fn init(allocator: Allocator, title: []const u8) CustomForm {
        return .{ .allocator = allocator, .title = title };
    }

    pub fn deinit(self: *CustomForm) void {
        self.elements.deinit(self.allocator);
    }

    /// The text of the submit button.
    pub fn setSubmit(self: *CustomForm, text: []const u8) void {
        self.submit_text = text;
    }

    pub fn header(self: *CustomForm, text: []const u8) Allocator.Error!void {
        try element(self.allocator, &self.elements, "header", &.{.{ "text", text }});
    }

    pub fn label(self: *CustomForm, text: []const u8) Allocator.Error!void {
        try element(self.allocator, &self.elements, "label", &.{.{ "text", text }});
    }

    pub fn divider(self: *CustomForm) Allocator.Error!void {
        try element(self.allocator, &self.elements, "divider", &.{});
    }

    pub fn input(self: *CustomForm, name: []const u8, text: []const u8, placeholder: []const u8, default: []const u8) Allocator.Error!void {
        try element(self.allocator, &self.elements, "input", &.{ .{ "name", name }, .{ "text", text }, .{ "placeholder", placeholder }, .{ "default", default } });
    }

    pub fn toggle(self: *CustomForm, name: []const u8, text: []const u8, default: bool) Allocator.Error!void {
        var w = nbt.Writer.init(self.allocator);
        defer w.deinit();
        try w.beginCompound();
        try w.key("kind");
        try w.string("toggle");
        try w.key("name");
        try w.string(name);
        try w.key("text");
        try w.string(text);
        try w.key("default");
        try w.double(if (default) 1 else 0);
        try w.endCompound();
        try self.append(w.text());
    }

    pub fn dropdown(self: *CustomForm, name: []const u8, text: []const u8, options: []const []const u8, default: usize) Allocator.Error!void {
        try self.choice("dropdown", name, text, options, default);
    }

    pub fn stepSlider(self: *CustomForm, name: []const u8, text: []const u8, steps: []const []const u8, default: usize) Allocator.Error!void {
        try self.choice("step_slider", name, text, steps, default);
    }

    pub fn slider(self: *CustomForm, name: []const u8, text: []const u8, min: f64, max: f64, step: f64, default: f64) Allocator.Error!void {
        var w = nbt.Writer.init(self.allocator);
        defer w.deinit();
        try w.beginCompound();
        try w.key("kind");
        try w.string("slider");
        try w.key("name");
        try w.string(name);
        try w.key("text");
        try w.string(text);
        try w.key("min");
        try w.double(min);
        try w.key("max");
        try w.double(max);
        try w.key("step");
        try w.double(step);
        try w.key("default");
        try w.double(default);
        try w.endCompound();
        try self.append(w.text());
    }

    fn choice(self: *CustomForm, kind: []const u8, name: []const u8, text: []const u8, options: []const []const u8, default: usize) Allocator.Error!void {
        var w = nbt.Writer.init(self.allocator);
        defer w.deinit();
        try w.beginCompound();
        try w.key("kind");
        try w.string(kind);
        try w.key("name");
        try w.string(name);
        try w.key("text");
        try w.string(text);
        try w.key("options");
        try w.beginList();
        for (options) |option| try w.string(option);
        try w.endList();
        try w.key("default");
        try w.double(@floatFromInt(default));
        try w.endCompound();
        try self.append(w.text());
    }

    fn append(self: *CustomForm, text: []const u8) Allocator.Error!void {
        if (self.elements.items.len != 0) try self.elements.append(self.allocator, ',');
        try self.elements.appendSlice(self.allocator, text);
    }

    pub fn send(self: *const CustomForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void {
        var w = nbt.Writer.init(self.allocator);
        defer w.deinit();
        try w.beginCompound();
        try w.key("title");
        try w.string(self.title);
        try w.key("elements");
        try w.beginList();
        try w.raw(self.elements.items);
        try w.endList();
        if (self.submit_text) |sub| {
            try w.key("submit");
            try w.string(sub);
        }
        try w.endCompound();
        try submit(player, 1, w.text(), user, handler);
    }
};
