# Zig: Commands

## Declarations {#declarations}

### `command.Origin.player_kind` {#command.Origin.player_kind}

```zig
pub const player_kind: i32 = 0;
```

### `command.Origin.dedicated_server_kind` {#command.Origin.dedicated_server_kind}

```zig
pub const dedicated_server_kind: i32 = 7;
```

## Functions {#functions}

### `registerCommand` {#registerCommand}

```zig
pub fn registerCommand(name: []const u8, description: []const u8, permission: Permission, comptime handler: fn (*const Invocation) void) Error!void
```

Registers /name, whose text after the name reaches handler as args. Call it from enable.

- Parameters:
    - name : `[]const u8`
    - description : `[]const u8`
    - permission : `Permission`
    - handler : `comptime fn (*const Invocation) void`
- Return type: `Error!void`
- Slots: [`register_command`](../cpp/commands.md#register_command)

### `executeCommand` {#executeCommand}

```zig
pub fn executeCommand(cmd: []const u8) Error!void
```

Runs cmd as the console. Server thread only. The output lines are logged at debug level; a false from the host, a level that is not ready, is Refused.

- Parameters:
    - cmd : `[]const u8`
- Return type: `Error!void`
- Slots: [`execute_command`](../cpp/commands.md#execute_command), [`log`](../cpp/core.md#log)

### `command.registerEnum` {#command.registerEnum}

```zig
pub fn registerEnum(allocator: Allocator, name: []const u8, values: []const struct { []const u8, u64 }) core.Error!void
```

Registers a static enum, each value a name and a number, for a parameter to reference.

- Parameters:
    - allocator : `Allocator`
    - name : `[]const u8`
    - values : `[]const struct { []const u8, u64 }`
- Return type: `core.Error!void`
- Slots: [`register_command_enum`](../cpp/commands.md#register_command_enum)

### `command.registerSoftEnum` {#command.registerSoftEnum}

```zig
pub fn registerSoftEnum(allocator: Allocator, name: []const u8, values: []const []const u8) core.Error!void
```

Registers a soft enum, one whose values can change at runtime, for a parameter to reference.

- Parameters:
    - allocator : `Allocator`
    - name : `[]const u8`
    - values : `[]const []const u8`
- Return type: `core.Error!void`
- Slots: [`register_command_soft_enum`](../cpp/commands.md#register_command_soft_enum)

### `command.updateSoftEnum` {#command.updateSoftEnum}

```zig
pub fn updateSoftEnum(allocator: Allocator, name: []const u8, op: SoftEnumOp, values: []const []const u8) core.Error!void
```

Changes the values of a soft enum. Refused for a name that was never registered.

- Parameters:
    - allocator : `Allocator`
    - name : `[]const u8`
    - op : `SoftEnumOp`
    - values : `[]const []const u8`
- Return type: `core.Error!void`
- Slots: [`update_command_soft_enum`](../cpp/commands.md#update_command_soft_enum)

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

One run of a typed command. Valid during the handler only.

### `command.Call.raw` {#command.Call.raw}

```zig
pub fn raw(self: *const Call) []const u8
```

The raw argument text, the SNBT the host handed over.

- Return type: `[]const u8`

### `command.Call.success` {#command.Call.success}

```zig
pub fn success(self: *const Call, message: []const u8) void
```

Sends one success output.

- Parameters:
    - message : `[]const u8`
- Return type: `void`

### `command.Call.failure` {#command.Call.failure}

```zig
pub fn failure(self: *const Call, message: []const u8) void
```

Sends one error output, a separate channel the client colors differently.

- Parameters:
    - message : `[]const u8`
- Return type: `void`

### `command.Call.overload` {#command.Call.overload}

```zig
pub fn overload(self: *Call) ?i32
```

Which overload matched, counting from 0.

- Return type: `?i32`

### `command.Call.arg` {#command.Call.arg}

```zig
pub fn arg(self: *Call, name: []const u8) ?nbt.Value
```

Reads a named argument. An omitted optional argument gives null.

- Parameters:
    - name : `[]const u8`
- Return type: `?nbt.Value`

### `command.Call.argString` {#command.Call.argString}

```zig
pub fn argString(self: *Call, name: []const u8) ?[]const u8
```

- Parameters:
    - name : `[]const u8`
- Return type: `?[]const u8`

### `command.Call.argInt` {#command.Call.argInt}

```zig
pub fn argInt(self: *Call, name: []const u8) ?i64
```

- Parameters:
    - name : `[]const u8`
- Return type: `?i64`

### `command.Call.argFloat` {#command.Call.argFloat}

```zig
pub fn argFloat(self: *Call, name: []const u8) ?f64
```

- Parameters:
    - name : `[]const u8`
- Return type: `?f64`

### `command.Call.argBool` {#command.Call.argBool}

```zig
pub fn argBool(self: *Call, name: []const u8) ?bool
```

- Parameters:
    - name : `[]const u8`
- Return type: `?bool`

### `command.Call.origin` {#command.Call.origin}

```zig
pub fn origin(self: *Call) Origin
```

The origin of the run.

- Return type: `Origin`

## `command.Overload` {#command.Overload}

```zig
pub const Overload = struct {
    allocator: Allocator,
    params: std.ArrayList(u8) = .empty,
    // ...
};
```

The declaration of one overload.

### `command.Overload.init` {#command.Overload.init}

```zig
pub fn init(allocator: Allocator) Overload
```

- Parameters:
    - allocator : `Allocator`
- Return type: `Overload`

### `command.Overload.deinit` {#command.Overload.deinit}

```zig
pub fn deinit(self: *Overload) void
```

- Return type: `void`

### `command.Overload.required` {#command.Overload.required}

```zig
pub fn required(self: *Overload, name: []const u8, kind: ParamType) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - kind : `ParamType`
- Return type: `Allocator.Error!void`

### `command.Overload.optional` {#command.Overload.optional}

```zig
pub fn optional(self: *Overload, name: []const u8, kind: ParamType) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - kind : `ParamType`
- Return type: `Allocator.Error!void`

### `command.Overload.text` {#command.Overload.text}

```zig
pub fn text(self: *Overload, name: []const u8, literal: []const u8) Allocator.Error!void
```

A literal: a fixed word the player types, and a node in the command tree.

- Parameters:
    - name : `[]const u8`
    - literal : `[]const u8`
- Return type: `Allocator.Error!void`

### `command.Overload.requiredEnum` {#command.Overload.requiredEnum}

```zig
pub fn requiredEnum(self: *Overload, name: []const u8, kind: ParamType, enum_name: []const u8) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - kind : `ParamType`
    - enum_name : `[]const u8`
- Return type: `Allocator.Error!void`

### `command.Overload.optionalEnum` {#command.Overload.optionalEnum}

```zig
pub fn optionalEnum(self: *Overload, name: []const u8, kind: ParamType, enum_name: []const u8) Allocator.Error!void
```

- Parameters:
    - name : `[]const u8`
    - kind : `ParamType`
    - enum_name : `[]const u8`
- Return type: `Allocator.Error!void`

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

A command with typed overloads. `name` and `description` are borrowed and must outlive the registration.

### `command.Builder.init` {#command.Builder.init}

```zig
pub fn init(allocator: Allocator, name: []const u8, description: []const u8, permission: core.Permission) Builder
```

- Parameters:
    - allocator : `Allocator`
    - name : `[]const u8`
    - description : `[]const u8`
    - permission : `core.Permission`
- Return type: `Builder`

### `command.Builder.deinit` {#command.Builder.deinit}

```zig
pub fn deinit(self: *Builder) void
```

- Return type: `void`

### `command.Builder.addOverload` {#command.Builder.addOverload}

```zig
pub fn addOverload(self: *Builder, overload: *const Overload) Allocator.Error!void
```

Adds one overload. At least one is required.

- Parameters:
    - overload : `*const Overload`
- Return type: `Allocator.Error!void`

### `command.Builder.register` {#command.Builder.register}

```zig
pub fn register(self: *const Builder, comptime handler: fn (*Call) void) core.Error!void
```

Registers it, from enable. A command with no overload is Refused, since the host refuses outright; the plain `registerCommand` is for a command with no argument. A name that is taken with a different shape, or a misspelled parameter type, is Refused as well.

- Parameters:
    - handler : `comptime fn (*Call) void`
- Return type: `core.Error!void`
- Slots: [`register_command_ex`](../cpp/commands.md#register_command_ex)

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

One run of a command; valid during the callback only.

### `Invocation.success` {#Invocation.success}

```zig
pub fn success(self: *const Invocation, msg: []const u8) void
```

Sends a line of output.

- Parameters:
    - msg : `[]const u8`
- Return type: `void`

### `Invocation.failure` {#Invocation.failure}

```zig
pub fn failure(self: *const Invocation, msg: []const u8) void
```

Sends a line of error output.

- Parameters:
    - msg : `[]const u8`
- Return type: `void`

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

Where a command came from.

### `command.Origin.isConsole` {#command.Origin.isConsole}

```zig
pub fn isConsole(self: Origin) bool
```

- Return type: `bool`

### `command.Origin.playerName` {#command.Origin.playerName}

```zig
pub fn playerName(self: Origin) ?[]const u8
```

The player name when the origin is a player.

- Return type: `?[]const u8`

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

The type of one parameter inside one overload.

### `command.ParamType.name` {#command.ParamType.name}

```zig
pub fn name(self: ParamType) []const u8
```

The spelling on the ABI. The host dispatches on this string, and a typo drops the whole command.

- Return type: `[]const u8`

## `Permission` {#Permission}

```zig
pub const Permission = enum(i32) {
    any = 0, game_directors = 1, admin = 2, host = 3, owner = 4
};
```

Who may run a command, mirroring CommandPermissionLevel.

## `command.SoftEnumOp` {#command.SoftEnumOp}

```zig
pub const SoftEnumOp = enum(i32) {
    set = 0, add = 1, remove = 2
};
```

How `updateSoftEnum` changes the values of a soft enum.
