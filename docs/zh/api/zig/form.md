# Zig：表单

## 声明 {#declarations}

### `gui.Handler` {#gui.Handler}

```zig
pub const Handler = fn (user: ?*anyopaque, response: Response) void;
```

处理函数收到的东西：发送时给出的 `user` 指针，以及玩家的回答。

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

自定义表单：输入框、开关、下拉框和滑块，每个控件都有名字，回答可以按名字读取。`title` 只是借用，必须比发送活得更久。

### `gui.CustomForm.init` {#gui.CustomForm.init}

```zig
pub fn init(allocator: Allocator, title: []const u8) CustomForm
```

- 参数：
    - allocator : `Allocator`
    - title : `[]const u8`
- 返回值类型：`CustomForm`

### `gui.CustomForm.deinit` {#gui.CustomForm.deinit}

```zig
pub fn deinit(self: *CustomForm) void
```

- 返回值类型：`void`

### `gui.CustomForm.setSubmit` {#gui.CustomForm.setSubmit}

```zig
pub fn setSubmit(self: *CustomForm, text: []const u8) void
```

提交按钮上的文字。

- 参数：
    - text : `[]const u8`
- 返回值类型：`void`

### `gui.CustomForm.header` {#gui.CustomForm.header}

```zig
pub fn header(self: *CustomForm, text: []const u8) Allocator.Error!void
```

- 参数：
    - text : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.label` {#gui.CustomForm.label}

```zig
pub fn label(self: *CustomForm, text: []const u8) Allocator.Error!void
```

- 参数：
    - text : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.divider` {#gui.CustomForm.divider}

```zig
pub fn divider(self: *CustomForm) Allocator.Error!void
```

- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.input` {#gui.CustomForm.input}

```zig
pub fn input(self: *CustomForm, name: []const u8, text: []const u8, placeholder: []const u8, default: []const u8) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - text : `[]const u8`
    - placeholder : `[]const u8`
    - default : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.toggle` {#gui.CustomForm.toggle}

```zig
pub fn toggle(self: *CustomForm, name: []const u8, text: []const u8, default: bool) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - text : `[]const u8`
    - default : `bool`
- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.dropdown` {#gui.CustomForm.dropdown}

```zig
pub fn dropdown(self: *CustomForm, name: []const u8, text: []const u8, options: []const []const u8, default: usize) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - text : `[]const u8`
    - options : `[]const []const u8`
    - default : `usize`
- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.stepSlider` {#gui.CustomForm.stepSlider}

```zig
pub fn stepSlider(self: *CustomForm, name: []const u8, text: []const u8, steps: []const []const u8, default: usize) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - text : `[]const u8`
    - steps : `[]const []const u8`
    - default : `usize`
- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.slider` {#gui.CustomForm.slider}

```zig
pub fn slider(self: *CustomForm, name: []const u8, text: []const u8, min: f64, max: f64, step: f64, default: f64) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - text : `[]const u8`
    - min : `f64`
    - max : `f64`
    - step : `f64`
    - default : `f64`
- 返回值类型：`Allocator.Error!void`

### `gui.CustomForm.send` {#gui.CustomForm.send}

```zig
pub fn send(self: *const CustomForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void
```

- 参数：
    - player : `props.Player`
    - user : `?*anyopaque`
    - handler : `comptime Handler`
- 返回值类型：`core.Error!void`
- 对应槽位：[`form_send`](../cpp/form.md#form_send)

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

简单表单：一列按钮。`title` 和 `content` 只是借用，必须比发送活得更久。

### `gui.SimpleForm.init` {#gui.SimpleForm.init}

```zig
pub fn init(allocator: Allocator, title: []const u8) SimpleForm
```

- 参数：
    - allocator : `Allocator`
    - title : `[]const u8`
- 返回值类型：`SimpleForm`

### `gui.SimpleForm.deinit` {#gui.SimpleForm.deinit}

```zig
pub fn deinit(self: *SimpleForm) void
```

- 返回值类型：`void`

### `gui.SimpleForm.setContent` {#gui.SimpleForm.setContent}

```zig
pub fn setContent(self: *SimpleForm, content: []const u8) void
```

- 参数：
    - content : `[]const u8`
- 返回值类型：`void`

### `gui.SimpleForm.button` {#gui.SimpleForm.button}

```zig
pub fn button(self: *SimpleForm, text: []const u8) Allocator.Error!void
```

- 参数：
    - text : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `gui.SimpleForm.buttonWithImage` {#gui.SimpleForm.buttonWithImage}

```zig
pub fn buttonWithImage(self: *SimpleForm, text: []const u8, image: []const u8, image_type: []const u8) Allocator.Error!void
```

带图标的按钮。`image_type` 是 "path" 或 "url"。

- 参数：
    - text : `[]const u8`
    - image : `[]const u8`
    - image_type : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `gui.SimpleForm.header` {#gui.SimpleForm.header}

```zig
pub fn header(self: *SimpleForm, text: []const u8) Allocator.Error!void
```

- 参数：
    - text : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `gui.SimpleForm.label` {#gui.SimpleForm.label}

```zig
pub fn label(self: *SimpleForm, text: []const u8) Allocator.Error!void
```

- 参数：
    - text : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `gui.SimpleForm.divider` {#gui.SimpleForm.divider}

```zig
pub fn divider(self: *SimpleForm) Allocator.Error!void
```

- 返回值类型：`Allocator.Error!void`

### `gui.SimpleForm.send` {#gui.SimpleForm.send}

```zig
pub fn send(self: *const SimpleForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void
```

发送它。一个按钮也没有的表单会得到 `Refused`，因为玩家无法按下它。

- 参数：
    - player : `props.Player`
    - user : `?*anyopaque`
    - handler : `comptime Handler`
- 返回值类型：`core.Error!void`
- 对应槽位：[`form_send`](../cpp/form.md#form_send)

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

自定义表单里一个控件返回的值。

### `gui.FormValue.asIndex` {#gui.FormValue.asIndex}

```zig
pub fn asIndex(self: FormValue) ?usize
```

下拉框或步进滑块选中的位置。

- 返回值类型：`?usize`

### `gui.FormValue.asF64` {#gui.FormValue.asF64}

```zig
pub fn asF64(self: FormValue) ?f64
```

- 返回值类型：`?f64`

### `gui.FormValue.asI64` {#gui.FormValue.asI64}

```zig
pub fn asI64(self: FormValue) ?i64
```

- 返回值类型：`?i64`

### `gui.FormValue.asBool` {#gui.FormValue.asBool}

```zig
pub fn asBool(self: FormValue) ?bool
```

- 返回值类型：`?bool`

### `gui.FormValue.asText` {#gui.FormValue.asText}

```zig
pub fn asText(self: FormValue) ?[]const u8
```

- 返回值类型：`?[]const u8`

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

玩家对一个表单的回答。

### `gui.Response.isCancelled` {#gui.Response.isCancelled}

```zig
pub fn isCancelled(self: Response) bool
```

- 返回值类型：`bool`

### `gui.Response.value` {#gui.Response.value}

```zig
pub fn value(self: Response, name: []const u8) ?FormValue
```

自定义表单里一个控件的值。

- 参数：
    - name : `[]const u8`
- 返回值类型：`?FormValue`

### `gui.Response.text` {#gui.Response.text}

```zig
pub fn text(self: Response, name: []const u8) ?[]const u8
```

自定义表单里一个控件所选项的文字。

- 参数：
    - name : `[]const u8`
- 返回值类型：`?[]const u8`

## `gui.Custom` {#gui.Custom}

```zig
pub const Custom = struct {
    entries: []const Entry,
    // ...
};
```

自定义表单的回答，每个有名字的控件一项。

### `gui.Custom.value` {#gui.Custom.value}

```zig
pub fn value(self: Custom, name: []const u8) ?FormValue
```

一个控件的值。

- 参数：
    - name : `[]const u8`
- 返回值类型：`?FormValue`

### `gui.Custom.text` {#gui.Custom.text}

```zig
pub fn text(self: Custom, name: []const u8) ?[]const u8
```

一个控件所选项的文字。

- 参数：
    - name : `[]const u8`
- 返回值类型：`?[]const u8`

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

模态表单：一段文字加两个按钮。每个字符串都只是借用，必须比发送活得更久。

### `gui.ModalForm.init` {#gui.ModalForm.init}

```zig
pub fn init(allocator: Allocator, title: []const u8, content: []const u8) ModalForm
```

- 参数：
    - allocator : `Allocator`
    - title : `[]const u8`
    - content : `[]const u8`
- 返回值类型：`ModalForm`

### `gui.ModalForm.send` {#gui.ModalForm.send}

```zig
pub fn send(self: *const ModalForm, player: props.Player, user: ?*anyopaque, comptime handler: Handler) core.Error!void
```

- 参数：
    - player : `props.Player`
    - user : `?*anyopaque`
    - handler : `comptime Handler`
- 返回值类型：`core.Error!void`
- 对应槽位：[`form_send`](../cpp/form.md#form_send)

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
