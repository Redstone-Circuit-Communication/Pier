# Zig：计分板

## 函数 {#functions}

### `scoreboard.addObjective` {#scoreboard.addObjective}

```zig
pub fn addObjective(name: []const u8, display_name: []const u8) core.Error!void
```

创建一个 dummy 计分项。同名的已经存在时得到 `Refused`。

- 参数：
    - name : `[]const u8`
    - display_name : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.removeObjective` {#scoreboard.removeObjective}

```zig
pub fn removeObjective(name: []const u8) core.Error!void
```

- 参数：
    - name : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.objectives` {#scoreboard.objectives}

```zig
pub fn objectives(allocator: Allocator) core.Error!types.Owned(Objective)
```

计分板上的每个计分项。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(Objective)`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.score` {#scoreboard.score}

```zig
pub fn score(objective: []const u8, who: []const u8) core.Error!?i64
```

读取一个分数；这个名字在该计分项上没有分数时为 null。

- 参数：
    - objective : `[]const u8`
    - who : `[]const u8`
- 返回值类型：`core.Error!?i64`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.setScore` {#scoreboard.setScore}

```zig
pub fn setScore(objective: []const u8, who: []const u8, value: i64) core.Error!i64
```

设置一个分数，并返回写入后的值。

- 参数：
    - objective : `[]const u8`
    - who : `[]const u8`
    - value : `i64`
- 返回值类型：`core.Error!i64`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.addScore` {#scoreboard.addScore}

```zig
pub fn addScore(objective: []const u8, who: []const u8, delta: i64) core.Error!i64
```

- 参数：
    - objective : `[]const u8`
    - who : `[]const u8`
    - delta : `i64`
- 返回值类型：`core.Error!i64`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.reduceScore` {#scoreboard.reduceScore}

```zig
pub fn reduceScore(objective: []const u8, who: []const u8, delta: i64) core.Error!i64
```

- 参数：
    - objective : `[]const u8`
    - who : `[]const u8`
    - delta : `i64`
- 返回值类型：`core.Error!i64`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.resetScore` {#scoreboard.resetScore}

```zig
pub fn resetScore(objective: []const u8, who: []const u8) core.Error!void
```

抹掉这个名字在该计分项上的分数，这和把它设为 0 不是一回事。

- 参数：
    - objective : `[]const u8`
    - who : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.setDisplay` {#scoreboard.setDisplay}

```zig
pub fn setDisplay(slot: DisplaySlot, objective: []const u8) core.Error!void
```

- 参数：
    - slot : `DisplaySlot`
    - objective : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.clearDisplay` {#scoreboard.clearDisplay}

```zig
pub fn clearDisplay(slot: DisplaySlot) core.Error!void
```

- 参数：
    - slot : `DisplaySlot`
- 返回值类型：`core.Error!void`
- 对应槽位：[`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

## `scoreboard.DisplaySlot` {#scoreboard.DisplaySlot}

```zig
pub const DisplaySlot = enum {
    sidebar,
    list,
    below_name,
};
```

计分板的显示位置。

### `scoreboard.DisplaySlot.name` {#scoreboard.DisplaySlot.name}

```zig
pub fn name(self: DisplaySlot) []const u8
```

宿主据以分派的名字。

- 返回值类型：`[]const u8`

## `scoreboard.Objective` {#scoreboard.Objective}

```zig
pub const Objective = struct {
    name: []const u8,
    display_name: []const u8,
    // ...
};
```

一个计分项。
