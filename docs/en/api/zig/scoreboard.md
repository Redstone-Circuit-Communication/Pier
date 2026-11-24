# Zig: Scoreboard

## Functions {#functions}

### `scoreboard.addObjective` {#scoreboard.addObjective}

```zig
pub fn addObjective(name: []const u8, display_name: []const u8) core.Error!void
```

Creates a dummy objective. It is Refused when one of that name already exists.

- Parameters:
    - name : `[]const u8`
    - display_name : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.removeObjective` {#scoreboard.removeObjective}

```zig
pub fn removeObjective(name: []const u8) core.Error!void
```

- Parameters:
    - name : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.objectives` {#scoreboard.objectives}

```zig
pub fn objectives(allocator: Allocator) core.Error!types.Owned(Objective)
```

Every objective of the scoreboard.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(Objective)`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.score` {#scoreboard.score}

```zig
pub fn score(objective: []const u8, who: []const u8) core.Error!?i64
```

Reads one score; null for a name that has none on this objective.

- Parameters:
    - objective : `[]const u8`
    - who : `[]const u8`
- Return type: `core.Error!?i64`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.setScore` {#scoreboard.setScore}

```zig
pub fn setScore(objective: []const u8, who: []const u8, value: i64) core.Error!i64
```

Sets a score and returns the value after the write.

- Parameters:
    - objective : `[]const u8`
    - who : `[]const u8`
    - value : `i64`
- Return type: `core.Error!i64`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.addScore` {#scoreboard.addScore}

```zig
pub fn addScore(objective: []const u8, who: []const u8, delta: i64) core.Error!i64
```

- Parameters:
    - objective : `[]const u8`
    - who : `[]const u8`
    - delta : `i64`
- Return type: `core.Error!i64`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.reduceScore` {#scoreboard.reduceScore}

```zig
pub fn reduceScore(objective: []const u8, who: []const u8, delta: i64) core.Error!i64
```

- Parameters:
    - objective : `[]const u8`
    - who : `[]const u8`
    - delta : `i64`
- Return type: `core.Error!i64`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.resetScore` {#scoreboard.resetScore}

```zig
pub fn resetScore(objective: []const u8, who: []const u8) core.Error!void
```

Erases the score of this name on this objective, which is not setting it to 0.

- Parameters:
    - objective : `[]const u8`
    - who : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.setDisplay` {#scoreboard.setDisplay}

```zig
pub fn setDisplay(slot: DisplaySlot, objective: []const u8) core.Error!void
```

- Parameters:
    - slot : `DisplaySlot`
    - objective : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

### `scoreboard.clearDisplay` {#scoreboard.clearDisplay}

```zig
pub fn clearDisplay(slot: DisplaySlot) core.Error!void
```

- Parameters:
    - slot : `DisplaySlot`
- Return type: `core.Error!void`
- Slots: [`scoreboard_op`](../cpp/scoreboard.md#scoreboard_op)

## `scoreboard.DisplaySlot` {#scoreboard.DisplaySlot}

```zig
pub const DisplaySlot = enum {
    sidebar,
    list,
    below_name,
};
```

The display slot of a scoreboard.

### `scoreboard.DisplaySlot.name` {#scoreboard.DisplaySlot.name}

```zig
pub fn name(self: DisplaySlot) []const u8
```

The name the host dispatches on.

- Return type: `[]const u8`

## `scoreboard.Objective` {#scoreboard.Objective}

```zig
pub const Objective = struct {
    name: []const u8,
    display_name: []const u8,
    // ...
};
```

One objective.
