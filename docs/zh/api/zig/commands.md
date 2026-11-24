# Zig：命令

## 声明 {#declarations}

### `command.Origin.player_kind` {#command.Origin.player_kind}

```zig
pub const player_kind: i32 = 0;
```

### `command.Origin.dedicated_server_kind` {#command.Origin.dedicated_server_kind}

```zig
pub const dedicated_server_kind: i32 = 7;
```

## 函数 {#functions}

### `registerCommand` {#registerCommand}

```zig
pub fn registerCommand(name: []const u8, description: []const u8, permission: Permission, comptime handler: fn (*const Invocation) void) Error!void
```

注册 `/name`，命令名之后的文本作为 `args` 交给 `handler`。请在 `enable` 里调用。

- 参数：
    - name : `[]const u8`
    - description : `[]const u8`
    - permission : `Permission`
    - handler : `comptime fn (*const Invocation) void`
- 返回值类型：`Error!void`
- 对应槽位：[`register_command`](../cpp/commands.md#register_command)

### `executeCommand` {#executeCommand}

```zig
pub fn executeCommand(cmd: []const u8) Error!void
```

以控制台的身份运行 `cmd`。只能在服务器线程调用。输出的每一行按 debug 级别记进日志；宿主返回 false（世界还没就绪）时得到 `Refused`。

- 参数：
    - cmd : `[]const u8`
- 返回值类型：`Error!void`
- 对应槽位：[`execute_command`](../cpp/commands.md#execute_command)、[`log`](../cpp/core.md#log)

### `command.registerEnum` {#command.registerEnum}

```zig
pub fn registerEnum(allocator: Allocator, name: []const u8, values: []const struct { []const u8, u64 }) core.Error!void
```

注册一个静态枚举，每个值是一个名字加一个数字，供参数引用。

- 参数：
    - allocator : `Allocator`
    - name : `[]const u8`
    - values : `[]const struct { []const u8, u64 }`
- 返回值类型：`core.Error!void`
- 对应槽位：[`register_command_enum`](../cpp/commands.md#register_command_enum)

### `command.registerSoftEnum` {#command.registerSoftEnum}

```zig
pub fn registerSoftEnum(allocator: Allocator, name: []const u8, values: []const []const u8) core.Error!void
```

注册一个软枚举，它的值可以在运行时改变，供参数引用。

- 参数：
    - allocator : `Allocator`
    - name : `[]const u8`
    - values : `[]const []const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`register_command_soft_enum`](../cpp/commands.md#register_command_soft_enum)

### `command.updateSoftEnum` {#command.updateSoftEnum}

```zig
pub fn updateSoftEnum(allocator: Allocator, name: []const u8, op: SoftEnumOp, values: []const []const u8) core.Error!void
```

修改软枚举的值。名字从未注册过时返回 `Refused`。

- 参数：
    - allocator : `Allocator`
    - name : `[]const u8`
    - op : `SoftEnumOp`
    - values : `[]const []const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`update_command_soft_enum`](../cpp/commands.md#update_command_soft_enum)

## `command.Call` {#command.Call}

```zig
pub const Call = struct {
    invocation: *const core.Invocation,
    arena: std.heap.ArenaAllocator,
    parsed: ?nbt.Value = null,
    parse_failed: bool = false,
    // ...
};
```

一个带类型的命令的一次运行。只在处理函数执行期间有效。

### `command.Call.raw` {#command.Call.raw}

```zig
pub fn raw(self: *const Call) []const u8
```

原始的参数文本，也就是宿主交过来的 SNBT。

- 返回值类型：`[]const u8`

### `command.Call.success` {#command.Call.success}

```zig
pub fn success(self: *const Call, message: []const u8) void
```

发送一条成功输出。

- 参数：
    - message : `[]const u8`
- 返回值类型：`void`

### `command.Call.failure` {#command.Call.failure}

```zig
pub fn failure(self: *const Call, message: []const u8) void
```

发送一条错误输出，这是一条独立的通道，客户端会用不同的颜色显示。

- 参数：
    - message : `[]const u8`
- 返回值类型：`void`

### `command.Call.overload` {#command.Call.overload}

```zig
pub fn overload(self: *Call) ?i32
```

匹配到的是第几个重载，从 0 数起。

- 返回值类型：`?i32`

### `command.Call.arg` {#command.Call.arg}

```zig
pub fn arg(self: *Call, name: []const u8) ?nbt.Value
```

按名字读取一个参数。省略了的可选参数得到 null。

- 参数：
    - name : `[]const u8`
- 返回值类型：`?nbt.Value`

### `command.Call.argString` {#command.Call.argString}

```zig
pub fn argString(self: *Call, name: []const u8) ?[]const u8
```

- 参数：
    - name : `[]const u8`
- 返回值类型：`?[]const u8`

### `command.Call.argInt` {#command.Call.argInt}

```zig
pub fn argInt(self: *Call, name: []const u8) ?i64
```

- 参数：
    - name : `[]const u8`
- 返回值类型：`?i64`

### `command.Call.argFloat` {#command.Call.argFloat}

```zig
pub fn argFloat(self: *Call, name: []const u8) ?f64
```

- 参数：
    - name : `[]const u8`
- 返回值类型：`?f64`

### `command.Call.argBool` {#command.Call.argBool}

```zig
pub fn argBool(self: *Call, name: []const u8) ?bool
```

- 参数：
    - name : `[]const u8`
- 返回值类型：`?bool`

### `command.Call.origin` {#command.Call.origin}

```zig
pub fn origin(self: *Call) Origin
```

这次运行的来源。

- 返回值类型：`Origin`

## `command.Overload` {#command.Overload}

```zig
pub const Overload = struct {
    allocator: Allocator,
    params: std.ArrayList(u8) = .empty,
    // ...
};
```

一个重载的声明。

### `command.Overload.init` {#command.Overload.init}

```zig
pub fn init(allocator: Allocator) Overload
```

- 参数：
    - allocator : `Allocator`
- 返回值类型：`Overload`

### `command.Overload.deinit` {#command.Overload.deinit}

```zig
pub fn deinit(self: *Overload) void
```

- 返回值类型：`void`

### `command.Overload.required` {#command.Overload.required}

```zig
pub fn required(self: *Overload, name: []const u8, kind: ParamType) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - kind : `ParamType`
- 返回值类型：`Allocator.Error!void`

### `command.Overload.optional` {#command.Overload.optional}

```zig
pub fn optional(self: *Overload, name: []const u8, kind: ParamType) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - kind : `ParamType`
- 返回值类型：`Allocator.Error!void`

### `command.Overload.text` {#command.Overload.text}

```zig
pub fn text(self: *Overload, name: []const u8, literal: []const u8) Allocator.Error!void
```

字面量：玩家要输入的一个固定单词，也是命令树里的一个节点。

- 参数：
    - name : `[]const u8`
    - literal : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `command.Overload.requiredEnum` {#command.Overload.requiredEnum}

```zig
pub fn requiredEnum(self: *Overload, name: []const u8, kind: ParamType, enum_name: []const u8) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - kind : `ParamType`
    - enum_name : `[]const u8`
- 返回值类型：`Allocator.Error!void`

### `command.Overload.optionalEnum` {#command.Overload.optionalEnum}

```zig
pub fn optionalEnum(self: *Overload, name: []const u8, kind: ParamType, enum_name: []const u8) Allocator.Error!void
```

- 参数：
    - name : `[]const u8`
    - kind : `ParamType`
    - enum_name : `[]const u8`
- 返回值类型：`Allocator.Error!void`

## `command.Builder` {#command.Builder}

```zig
pub const Builder = struct {
    allocator: Allocator,
    name: []const u8,
    description: []const u8,
    permission: core.Permission,
    overloads: std.ArrayList(u8) = .empty,
    count: usize = 0,
    // ...
};
```

带类型重载的命令。`name` 和 `description` 只是借用，必须比注册活得更久。

### `command.Builder.init` {#command.Builder.init}

```zig
pub fn init(allocator: Allocator, name: []const u8, description: []const u8, permission: core.Permission) Builder
```

- 参数：
    - allocator : `Allocator`
    - name : `[]const u8`
    - description : `[]const u8`
    - permission : `core.Permission`
- 返回值类型：`Builder`

### `command.Builder.deinit` {#command.Builder.deinit}

```zig
pub fn deinit(self: *Builder) void
```

- 返回值类型：`void`

### `command.Builder.addOverload` {#command.Builder.addOverload}

```zig
pub fn addOverload(self: *Builder, overload: *const Overload) Allocator.Error!void
```

添加一个重载。至少需要一个。

- 参数：
    - overload : `*const Overload`
- 返回值类型：`Allocator.Error!void`

### `command.Builder.register` {#command.Builder.register}

```zig
pub fn register(self: *const Builder, comptime handler: fn (*Call) void) core.Error!void
```

注册它，在 enable 里调用。没有任何重载的命令会得到 `Refused`，因为宿主会直接拒绝；没有参数的命令用普通的 `registerCommand`。名字已被占用而形状不同，或者参数类型拼错了，同样得到 `Refused`。

- 参数：
    - handler : `comptime fn (*Call) void`
- 返回值类型：`core.Error!void`
- 对应槽位：[`register_command_ex`](../cpp/commands.md#register_command_ex)

## `Invocation` {#Invocation}

```zig
pub const Invocation = struct {
    args: []const u8,
    origin: []const u8,
    ctx: ?*anyopaque,
    ok: c.PierStrSink,
    fail: c.PierStrSink,
    // ...
};
```

一次命令的执行；只在回调期间有效。

### `Invocation.success` {#Invocation.success}

```zig
pub fn success(self: *const Invocation, msg: []const u8) void
```

发送一行输出。

- 参数：
    - msg : `[]const u8`
- 返回值类型：`void`

### `Invocation.failure` {#Invocation.failure}

```zig
pub fn failure(self: *const Invocation, msg: []const u8) void
```

发送一行错误输出。

- 参数：
    - msg : `[]const u8`
- 返回值类型：`void`

## `command.Origin` {#command.Origin}

```zig
pub const Origin = struct {
    name: []const u8,
    /// The engine's origin type: 0 for a player, 7 for the console, -1 when the host sent only
    /// a name.
    kind: i32,
    /// The dimension and the position the command ran at, when the host gave them.
    at: ?struct { dim: i32, x: f64, y: f64, z: f64 },
    // ...
};
```

命令从哪里来。

### `command.Origin.isConsole` {#command.Origin.isConsole}

```zig
pub fn isConsole(self: Origin) bool
```

- 返回值类型：`bool`

### `command.Origin.playerName` {#command.Origin.playerName}

```zig
pub fn playerName(self: Origin) ?[]const u8
```

来源是玩家时的玩家名。

- 返回值类型：`?[]const u8`

## `command.ParamType` {#command.ParamType}

```zig
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
};
```

一个重载里某个参数的类型。

### `command.ParamType.name` {#command.ParamType.name}

```zig
pub fn name(self: ParamType) []const u8
```

它在 ABI 上的拼写。宿主按这个字符串分派，拼错一个字母整条命令都会被丢掉。

- 返回值类型：`[]const u8`

## `Permission` {#Permission}

```zig
pub const Permission = enum(i32) {
    any = 0, game_directors = 1, admin = 2, host = 3, owner = 4
};
```

谁可以运行一条命令，对应 `CommandPermissionLevel`。

## `command.SoftEnumOp` {#command.SoftEnumOp}

```zig
pub const SoftEnumOp = enum(i32) {
    set = 0, add = 1, remove = 2
};
```

`updateSoftEnum` 怎样修改软枚举的值。
