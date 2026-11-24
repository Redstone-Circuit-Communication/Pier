# Zig：NBT 与键值数据库

## `kvdb.KvDb` {#kvdb.KvDb}

```zig
pub const KvDb = struct {
    handle: c.PierKvDbHandle,
    // ...
};
```

一个已打开的键值库。`close` 释放它。

### `kvdb.KvDb.open` {#kvdb.KvDb.open}

```zig
pub fn open(path: []const u8) core.Error!KvDb
```

打开它，不存在时创建。

- 参数：
    - path : `[]const u8`
- 返回值类型：`core.Error!KvDb`

### `kvdb.KvDb.openExisting` {#kvdb.KvDb.openExisting}

```zig
pub fn openExisting(path: []const u8) core.Error!KvDb
```

只打开已经存在的。库不存在时得到 `Refused`，不会替它创建一个空库。

- 参数：
    - path : `[]const u8`
- 返回值类型：`core.Error!KvDb`

### `kvdb.KvDb.close` {#kvdb.KvDb.close}

```zig
pub fn close(self: *KvDb) void
```

关闭这个库；调用两次也没有害处。

- 返回值类型：`void`
- 对应槽位：[`kvdb_close`](../cpp/data.md#kvdb_close)

### `kvdb.KvDb.get` {#kvdb.KvDb.get}

```zig
pub fn get(self: KvDb, allocator: Allocator, key: []const u8) core.Error!?[]u8
```

读取一个键，由调用方持有：键不存在时为 null。

- 参数：
    - allocator : `Allocator`
    - key : `[]const u8`
- 返回值类型：`core.Error!?[]u8`
- 对应槽位：[`kvdb_get`](../cpp/data.md#kvdb_get)

### `kvdb.KvDb.set` {#kvdb.KvDb.set}

```zig
pub fn set(self: KvDb, key: []const u8, value: []const u8) core.Error!void
```

- 参数：
    - key : `[]const u8`
    - value : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`kvdb_set`](../cpp/data.md#kvdb_set)

### `kvdb.KvDb.del` {#kvdb.KvDb.del}

```zig
pub fn del(self: KvDb, key: []const u8) core.Error!void
```

删除一个键。从来不存在的键也算成功。

- 参数：
    - key : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`kvdb_del`](../cpp/data.md#kvdb_del)

### `kvdb.KvDb.has` {#kvdb.KvDb.has}

```zig
pub fn has(self: KvDb, key: []const u8) core.Error!bool
```

- 参数：
    - key : `[]const u8`
- 返回值类型：`core.Error!bool`
- 对应槽位：[`kvdb_has`](../cpp/data.md#kvdb_has)

### `kvdb.KvDb.isEmpty` {#kvdb.KvDb.isEmpty}

```zig
pub fn isEmpty(self: KvDb) core.Error!bool
```

- 返回值类型：`core.Error!bool`
- 对应槽位：[`kvdb_is_empty`](../cpp/data.md#kvdb_is_empty)

### `kvdb.KvDb.pairs` {#kvdb.KvDb.pairs}

```zig
pub fn pairs(self: KvDb, allocator: Allocator) core.Error!types.Owned(Pair)
```

每个键和值。整个库会被读进内存，所以大的库要小心。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(Pair)`
- 对应槽位：[`kvdb_iter`](../cpp/data.md#kvdb_iter)

## `kvdb.Pair` {#kvdb.Pair}

```zig
pub const Pair = struct {
    key: []const u8,
    value: []const u8,
    // ...
};
```

一个键和它的值。
