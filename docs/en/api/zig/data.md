# Zig: NBT and the key-value database

## `kvdb.KvDb` {#kvdb.KvDb}

```zig
pub const KvDb = struct {
    handle: c.PierKvDbHandle,
    // ...
};
```

One open key-value store. `close` releases it.

### `kvdb.KvDb.open` {#kvdb.KvDb.open}

```zig
pub fn open(path: []const u8) core.Error!KvDb
```

Opens it, creating it when it does not exist.

- Parameters:
    - path : `[]const u8`
- Return type: `core.Error!KvDb`

### `kvdb.KvDb.openExisting` {#kvdb.KvDb.openExisting}

```zig
pub fn openExisting(path: []const u8) core.Error!KvDb
```

Opens an existing one only. A store that does not exist is Refused and no empty one is created in its place.

- Parameters:
    - path : `[]const u8`
- Return type: `core.Error!KvDb`

### `kvdb.KvDb.close` {#kvdb.KvDb.close}

```zig
pub fn close(self: *KvDb) void
```

Closes the store; calling it twice is harmless.

- Return type: `void`
- Slots: [`kvdb_close`](../cpp/data.md#kvdb_close)

### `kvdb.KvDb.get` {#kvdb.KvDb.get}

```zig
pub fn get(self: KvDb, allocator: Allocator, key: []const u8) core.Error!?[]u8
```

Reads one key, owned by the caller: null for a key that does not exist.

- Parameters:
    - allocator : `Allocator`
    - key : `[]const u8`
- Return type: `core.Error!?[]u8`
- Slots: [`kvdb_get`](../cpp/data.md#kvdb_get)

### `kvdb.KvDb.set` {#kvdb.KvDb.set}

```zig
pub fn set(self: KvDb, key: []const u8, value: []const u8) core.Error!void
```

- Parameters:
    - key : `[]const u8`
    - value : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`kvdb_set`](../cpp/data.md#kvdb_set)

### `kvdb.KvDb.del` {#kvdb.KvDb.del}

```zig
pub fn del(self: KvDb, key: []const u8) core.Error!void
```

Deletes one key. A key that never existed also counts as a success.

- Parameters:
    - key : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`kvdb_del`](../cpp/data.md#kvdb_del)

### `kvdb.KvDb.has` {#kvdb.KvDb.has}

```zig
pub fn has(self: KvDb, key: []const u8) core.Error!bool
```

- Parameters:
    - key : `[]const u8`
- Return type: `core.Error!bool`
- Slots: [`kvdb_has`](../cpp/data.md#kvdb_has)

### `kvdb.KvDb.isEmpty` {#kvdb.KvDb.isEmpty}

```zig
pub fn isEmpty(self: KvDb) core.Error!bool
```

- Return type: `core.Error!bool`
- Slots: [`kvdb_is_empty`](../cpp/data.md#kvdb_is_empty)

### `kvdb.KvDb.pairs` {#kvdb.KvDb.pairs}

```zig
pub fn pairs(self: KvDb, allocator: Allocator) core.Error!types.Owned(Pair)
```

Every key and value. The whole store is read into memory, so a large one needs care.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(Pair)`
- Slots: [`kvdb_iter`](../cpp/data.md#kvdb_iter)

## `kvdb.Pair` {#kvdb.Pair}

```zig
pub const Pair = struct {
    key: []const u8,
    value: []const u8,
    // ...
};
```

One key and its value.
