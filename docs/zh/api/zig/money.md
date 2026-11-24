# Zig：经济

## 函数 {#functions}

### `money.balance` {#money.balance}

```zig
pub fn balance(xuid: []const u8) core.Error!i64
```

一个账户的余额。宿主说不出时为 `NoAnswer`：xuid 为空、数据库出错或没有后端。读取一个没人开过的账户，会按默认值把它开出来。

- 参数：
    - xuid : `[]const u8`
- 返回值类型：`core.Error!i64`
- 对应槽位：[`get_money`](../cpp/money.md#get_money)

### `money.set` {#money.set}

```zig
pub fn set(xuid: []const u8, amount: i64) core.Error!void
```

把余额设为目标值。

- 参数：
    - xuid : `[]const u8`
    - amount : `i64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`set_money`](../cpp/money.md#set_money)

### `money.add` {#money.add}

```zig
pub fn add(xuid: []const u8, delta: i64) core.Error!void
```

- 参数：
    - xuid : `[]const u8`
    - delta : `i64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`add_money`](../cpp/money.md#add_money)

### `money.reduce` {#money.reduce}

```zig
pub fn reduce(xuid: []const u8, delta: i64) core.Error!void
```

- 参数：
    - xuid : `[]const u8`
    - delta : `i64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`reduce_money`](../cpp/money.md#reduce_money)

### `money.transfer` {#money.transfer}

```zig
pub fn transfer(from: []const u8, to: []const u8, value: i64, note: []const u8) core.Error!void
```

在两个账户之间转账。`from` 或 `to` 为空表示从无到有地创造、或销毁为无。`from` 等于 `to` 会被后端拒绝，收款方实际收到的金额要扣除配置的税。

- 参数：
    - from : `[]const u8`
    - to : `[]const u8`
    - value : `i64`
    - note : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`trans_money`](../cpp/money.md#trans_money)

### `money.history` {#money.history}

```zig
pub fn history(allocator: Allocator, xuid: []const u8, seconds: i32) core.Error![][]u8
```

最近 `seconds` 秒的交易，每行一条，由调用方持有；用 `core.freeList` 释放。

- 参数：
    - allocator : `Allocator`
    - xuid : `[]const u8`
    - seconds : `i32`
- 返回值类型：`core.Error![][]u8`
- 对应槽位：[`money_get_hist`](../cpp/money.md#money_get_hist)

### `money.clearHistory` {#money.clearHistory}

```zig
pub fn clearHistory(seconds: i32) core.Error!void
```

清除早于 `seconds` 秒的交易。

- 参数：
    - seconds : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`money_clear_hist`](../cpp/money.md#money_clear_hist)

### `money.ranking` {#money.ranking}

```zig
pub fn ranking(allocator: Allocator, top_n: u16) core.Error![][]u8
```

富豪榜的前 `top_n` 名，每行一条，由调用方持有；用 `core.freeList` 释放。

- 参数：
    - allocator : `Allocator`
    - top_n : `u16`
- 返回值类型：`core.Error![][]u8`
- 对应槽位：[`money_ranking`](../cpp/money.md#money_ranking)

### `money.onBefore` {#money.onBefore}

```zig
pub fn onBefore(comptime handler: fn (Event) bool) core.Error!void
```

注册一个在事件之前运行的回调，返回 false 就否决它。多个 mod 可以各注册一个，这个 mod 卸载时加载器会移除它。

- 参数：
    - handler : `comptime fn (Event) bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`money_listen_before_event`](../cpp/money.md#money_listen_before_event)

### `money.onAfter` {#money.onAfter}

```zig
pub fn onAfter(comptime handler: fn (Event) void) core.Error!void
```

注册一个在事件之后运行的回调。返回值被忽略。

- 参数：
    - handler : `comptime fn (Event) void`
- 返回值类型：`core.Error!void`
- 对应槽位：[`money_listen_after_event`](../cpp/money.md#money_listen_after_event)

## `money.EventKind` {#money.EventKind}

```zig
pub const EventKind = enum {
    set, add, reduce, transfer, unknown
};
```

一个经济事件做什么。

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

一个经济事件。两个字符串只在回调期间有效。
