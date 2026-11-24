# Zig: Economy

## Functions {#functions}

### `money.balance` {#money.balance}

```zig
pub fn balance(xuid: []const u8) core.Error!i64
```

The balance of an account. NoAnswer when the host cannot say: an empty xuid, a database error or no backend. Reading an account no one has opened opens it at the default.

- Parameters:
    - xuid : `[]const u8`
- Return type: `core.Error!i64`
- Slots: [`get_money`](../cpp/money.md#get_money)

### `money.set` {#money.set}

```zig
pub fn set(xuid: []const u8, amount: i64) core.Error!void
```

Sets the balance to a target.

- Parameters:
    - xuid : `[]const u8`
    - amount : `i64`
- Return type: `core.Error!void`
- Slots: [`set_money`](../cpp/money.md#set_money)

### `money.add` {#money.add}

```zig
pub fn add(xuid: []const u8, delta: i64) core.Error!void
```

- Parameters:
    - xuid : `[]const u8`
    - delta : `i64`
- Return type: `core.Error!void`
- Slots: [`add_money`](../cpp/money.md#add_money)

### `money.reduce` {#money.reduce}

```zig
pub fn reduce(xuid: []const u8, delta: i64) core.Error!void
```

- Parameters:
    - xuid : `[]const u8`
    - delta : `i64`
- Return type: `core.Error!void`
- Slots: [`reduce_money`](../cpp/money.md#reduce_money)

### `money.transfer` {#money.transfer}

```zig
pub fn transfer(from: []const u8, to: []const u8, value: i64, note: []const u8) core.Error!void
```

Transfers between two accounts. An empty `from` or `to` means created from or destroyed into nothing. A `from` equal to `to` is refused by the backend, and the amount the payee receives is reduced by the configured tax.

- Parameters:
    - from : `[]const u8`
    - to : `[]const u8`
    - value : `i64`
    - note : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`trans_money`](../cpp/money.md#trans_money)

### `money.history` {#money.history}

```zig
pub fn history(allocator: Allocator, xuid: []const u8, seconds: i32) core.Error![][]u8
```

The transactions of the last `seconds` seconds, one per line, owned by the caller; `core.freeList` releases them.

- Parameters:
    - allocator : `Allocator`
    - xuid : `[]const u8`
    - seconds : `i32`
- Return type: `core.Error![][]u8`
- Slots: [`money_get_hist`](../cpp/money.md#money_get_hist)

### `money.clearHistory` {#money.clearHistory}

```zig
pub fn clearHistory(seconds: i32) core.Error!void
```

Clears transactions older than `seconds` seconds.

- Parameters:
    - seconds : `i32`
- Return type: `core.Error!void`
- Slots: [`money_clear_hist`](../cpp/money.md#money_clear_hist)

### `money.ranking` {#money.ranking}

```zig
pub fn ranking(allocator: Allocator, top_n: u16) core.Error![][]u8
```

The top `top_n` of the rich list, one per line, owned by the caller; `core.freeList` releases them.

- Parameters:
    - allocator : `Allocator`
    - top_n : `u16`
- Return type: `core.Error![][]u8`
- Slots: [`money_ranking`](../cpp/money.md#money_ranking)

### `money.onBefore` {#money.onBefore}

```zig
pub fn onBefore(comptime handler: fn (Event) bool) core.Error!void
```

Registers a callback that runs before the event, where returning false vetoes it. Several mods may each register one, and the loader removes it when this mod unloads.

- Parameters:
    - handler : `comptime fn (Event) bool`
- Return type: `core.Error!void`
- Slots: [`money_listen_before_event`](../cpp/money.md#money_listen_before_event)

### `money.onAfter` {#money.onAfter}

```zig
pub fn onAfter(comptime handler: fn (Event) void) core.Error!void
```

Registers a callback that runs after the event. The return value is ignored.

- Parameters:
    - handler : `comptime fn (Event) void`
- Return type: `core.Error!void`
- Slots: [`money_listen_after_event`](../cpp/money.md#money_listen_after_event)

## `money.EventKind` {#money.EventKind}

```zig
pub const EventKind = enum {
    set, add, reduce, transfer, unknown
};
```

What an economy event does.

## `money.Event` {#money.Event}

```zig
pub const Event = struct {
    kind: EventKind,
    from: []const u8,
    to: []const u8,
    value: i64,
    // ...
};
```

One economy event. The two strings are valid during the callback only.
