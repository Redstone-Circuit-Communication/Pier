# Zig: Forms

## Declarations {#declarations}

### `gui.Handler` {#gui.Handler}

```zig
pub const Handler = fn (user: ?*anyopaque, response: Response) void;
```

What a handler receives: the `user` pointer given at send and the answer.

## `gui.CustomForm` {#gui.CustomForm}

```zig
pub const CustomForm = struct {
    allocator: Allocator,
    title: []const u8,
    submit_text: ?[]const u8 = null,
    elements: std.ArrayList(u8) = .empty,
    // ...
};
```

A custom form: input fields, toggles, dropdowns and sliders, each named so the answer can be read by name. `title` is borrowed and must outlive the send.

### `gui.CustomForm.init` {#gui.CustomForm.init}

```zig
pub fn init(allocator: Allocator, title: []const u8) CustomForm
```

- Parameters:
    - allocator : `Allocator`
    - title : `[]const u8`
- Return type: `CustomForm`

### `gui.CustomForm.deinit` {#gui.CustomForm.deinit}

```zig
pub fn deinit(self: *CustomForm) void
```

- Return type: `void`

### `gui.CustomForm.setSubmit` {#gui.CustomForm.setSubmit}

```zig
pub fn setSubmit(self: *CustomForm, text: []const u8) void
```

The text of the submit button.

- Parameters:
    - text : `[]const u8`
- Return type: `void`

### `gui.CustomForm.header` {#gui.CustomForm.header}

```zig
pub fn header(self: *CustomForm, text: []const u8) Allocator.Error!void
```

- Parameters:
    - text : `[]const u8`
- Return type: `Allocator.Error!void`

### `gui.CustomForm.label` {#gui.CustomForm.label}

```zig
pub fn label(self: *CustomForm, text: []const u8) Allocator.Error!void
```

- Parameters:
    - text : `[]const u8`
- Return type: `Allocator.Error!void`

### `gui.CustomForm.divider` {#gui.CustomForm.divider}

```zig
pub fn divider(self: *CustomForm) Allocator.Error!void
```

- Return type: `Allocator.Error!void`

### `gui.CustomForm.input` {#gui.CustomForm.input}

```zig
pub fn input(self: *CustomForm, name: []const u8, text: []const u8, placeholder: []const u8, default: []const u8) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - text : `[]const u8`
    - placeholder : `[]const u8`
    - default : `[]const u8`
- Return type: `Allocator.Error!void`

### `gui.CustomForm.toggle` {#gui.CustomForm.toggle}

```zig
pub fn toggle(self: *CustomForm, name: []const u8, text: []const u8, default: bool) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - text : `[]const u8`
    - default : `bool`
- Return type: `Allocator.Error!void`

### `gui.CustomForm.dropdown` {#gui.CustomForm.dropdown}

```zig
pub fn dropdown(self: *CustomForm, name: []const u8, text: []const u8, options: []const []const u8, default: usize) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - text : `[]const u8`
    - options : `[]const []const u8`
    - default : `usize`
- Return type: `Allocator.Error!void`

### `gui.CustomForm.stepSlider` {#gui.CustomForm.stepSlider}

```zig
pub fn stepSlider(self: *CustomForm, name: []const u8, text: []const u8, steps: []const []const u8, default: usize) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - text : `[]const u8`
    - steps : `[]const []const u8`
    - default : `usize`
- Return type: `Allocator.Error!void`

### `gui.CustomForm.slider` {#gui.CustomForm.slider}

```zig
pub fn slider(self: *CustomForm, name: []const u8, text: []const u8, min: f64, max: f64, step: f64, default: f64) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - text : `[]const u8`
    - min : `f64`
    - max : `f64`
    - step : `f64`
    - default : `f64`
- Return type: `Allocator.Error!void`

### `gui.CustomForm.send` {#gui.CustomForm.send}

```zig
pub fn send(self: *const CustomForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void
```

- Parameters:
    - player : `props.Player`
    - user : `?*anyopaque`
    - handler : `comptime Handler`
- Return type: `core.Error!void`
- Slots: [`form_send`](../cpp/form.md#form_send)

## `gui.SimpleForm` {#gui.SimpleForm}

```zig
pub const SimpleForm = struct {
    allocator: Allocator,
    title: []const u8,
    content: []const u8 = "",
    elements: std.ArrayList(u8) = .empty,
    buttons: usize = 0,
    // ...
};
```

A simple form: a column of buttons. `title` and `content` are borrowed and must outlive the send.

### `gui.SimpleForm.init` {#gui.SimpleForm.init}

```zig
pub fn init(allocator: Allocator, title: []const u8) SimpleForm
```

- Parameters:
    - allocator : `Allocator`
    - title : `[]const u8`
- Return type: `SimpleForm`

### `gui.SimpleForm.deinit` {#gui.SimpleForm.deinit}

```zig
pub fn deinit(self: *SimpleForm) void
```

- Return type: `void`

### `gui.SimpleForm.setContent` {#gui.SimpleForm.setContent}

```zig
pub fn setContent(self: *SimpleForm, content: []const u8) void
```

- Parameters:
    - content : `[]const u8`
- Return type: `void`

### `gui.SimpleForm.button` {#gui.SimpleForm.button}

```zig
pub fn button(self: *SimpleForm, text: []const u8) Allocator.Error!void
```

- Parameters:
    - text : `[]const u8`
- Return type: `Allocator.Error!void`

### `gui.SimpleForm.buttonWithImage` {#gui.SimpleForm.buttonWithImage}

```zig
pub fn buttonWithImage(self: *SimpleForm, text: []const u8, image: []const u8, image_type: []const u8) Allocator.Error!void
```

A button with an icon. `image_type` is "path" or "url".

- Parameters:
    - text : `[]const u8`
    - image : `[]const u8`
    - image_type : `[]const u8`
- Return type: `Allocator.Error!void`

### `gui.SimpleForm.header` {#gui.SimpleForm.header}

```zig
pub fn header(self: *SimpleForm, text: []const u8) Allocator.Error!void
```

- Parameters:
    - text : `[]const u8`
- Return type: `Allocator.Error!void`

### `gui.SimpleForm.label` {#gui.SimpleForm.label}

```zig
pub fn label(self: *SimpleForm, text: []const u8) Allocator.Error!void
```

- Parameters:
    - text : `[]const u8`
- Return type: `Allocator.Error!void`

### `gui.SimpleForm.divider` {#gui.SimpleForm.divider}

```zig
pub fn divider(self: *SimpleForm) Allocator.Error!void
```

- Return type: `Allocator.Error!void`

### `gui.SimpleForm.send` {#gui.SimpleForm.send}

```zig
pub fn send(self: *const SimpleForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void
```

Sends it. A form with no button at all is Refused, since a player cannot press it.

- Parameters:
    - player : `props.Player`
    - user : `?*anyopaque`
    - handler : `comptime Handler`
- Return type: `core.Error!void`
- Slots: [`form_send`](../cpp/form.md#form_send)

## `gui.FormValue` {#gui.FormValue}

```zig
pub const FormValue = union(enum) {
    index: usize,
    number: f64,
    text: []const u8,
    boolean: bool,
    // ...
};
```

The value one control of a custom form returns.

### `gui.FormValue.asIndex` {#gui.FormValue.asIndex}

```zig
pub fn asIndex(self: FormValue) ?usize
```

The chosen position of a dropdown or a step slider.

- Return type: `?usize`

### `gui.FormValue.asF64` {#gui.FormValue.asF64}

```zig
pub fn asF64(self: FormValue) ?f64
```

- Return type: `?f64`

### `gui.FormValue.asI64` {#gui.FormValue.asI64}

```zig
pub fn asI64(self: FormValue) ?i64
```

- Return type: `?i64`

### `gui.FormValue.asBool` {#gui.FormValue.asBool}

```zig
pub fn asBool(self: FormValue) ?bool
```

- Return type: `?bool`

### `gui.FormValue.asText` {#gui.FormValue.asText}

```zig
pub fn asText(self: FormValue) ?[]const u8
```

- Return type: `?[]const u8`

## `gui.Response` {#gui.Response}

```zig
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
    // ...
};
```

A player's answer to a form.

### `gui.Response.isCancelled` {#gui.Response.isCancelled}

```zig
pub fn isCancelled(self: Response) bool
```

- Return type: `bool`

### `gui.Response.value` {#gui.Response.value}

```zig
pub fn value(self: Response, name: []const u8) ?FormValue
```

The value of one control of a custom form.

- Parameters:
    - name : `[]const u8`
- Return type: `?FormValue`

### `gui.Response.text` {#gui.Response.text}

```zig
pub fn text(self: Response, name: []const u8) ?[]const u8
```

The text of the selected item of one control of a custom form.

- Parameters:
    - name : `[]const u8`
- Return type: `?[]const u8`

## `gui.Custom` {#gui.Custom}

```zig
pub const Custom = struct {
    entries: []const Entry,
    // ...
};
```

The answers of a custom form, one entry per named control.

### `gui.Custom.value` {#gui.Custom.value}

```zig
pub fn value(self: Custom, name: []const u8) ?FormValue
```

The value of one control.

- Parameters:
    - name : `[]const u8`
- Return type: `?FormValue`

### `gui.Custom.text` {#gui.Custom.text}

```zig
pub fn text(self: Custom, name: []const u8) ?[]const u8
```

The text of the selected item of one control.

- Parameters:
    - name : `[]const u8`
- Return type: `?[]const u8`

## `gui.ModalForm` {#gui.ModalForm}

```zig
pub const ModalForm = struct {
    allocator: Allocator,
    title: []const u8,
    content: []const u8,
    upper: []const u8 = "OK",
    lower: []const u8 = "Cancel",
    // ...
};
```

A modal form: some text and two buttons. Every string is borrowed and must outlive the send.

### `gui.ModalForm.init` {#gui.ModalForm.init}

```zig
pub fn init(allocator: Allocator, title: []const u8, content: []const u8) ModalForm
```

- Parameters:
    - allocator : `Allocator`
    - title : `[]const u8`
    - content : `[]const u8`
- Return type: `ModalForm`

### `gui.ModalForm.send` {#gui.ModalForm.send}

```zig
pub fn send(self: *const ModalForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void
```

- Parameters:
    - player : `props.Player`
    - user : `?*anyopaque`
    - handler : `comptime Handler`
- Return type: `core.Error!void`
- Slots: [`form_send`](../cpp/form.md#form_send)

## `gui.Custom.Entry` {#gui.Custom.Entry}

```zig
pub const Entry = struct {
    name: []const u8,
    value: FormValue,
    /// The text of the selected item, for a control that has one.
    text: ?[]const u8,
    // ...
};
```
