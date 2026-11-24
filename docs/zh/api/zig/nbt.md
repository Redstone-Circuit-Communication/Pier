# Zig：SNBT 值

nbt.zig：Zig 模组的 SNBT 解析和写出，规则和 Rust、Go 绑定一样：不带后缀的数字依次尝试 int、long、double；后缀 b、s、l、f 或 d 指定类型；true 和 false 是字节；其他不带引号的单词是字符串。

## 函数 {#functions}

### `nbt.parse` {#nbt.parse}

```zig
pub fn parse(arena: std.mem.Allocator, text: []const u8) ParseError!Value
```

解析 SNBT。每个节点都用 `arena` 分配，由调用方整体释放；不带引号的字符串或键也可能直接指向 `text`，所以 `text` 必须比结果存活得更久。

- 参数：
    - arena : `std.mem.Allocator`
    - text : `[]const u8`
- 返回值类型：`ParseError!Value`

### `nbt.snbtToBinary` {#nbt.snbtToBinary}

```zig
pub fn snbtToBinary(allocator: std.mem.Allocator, snbt: []const u8, format: Format) core.Error![]u8
```

把 SNBT 编码成二进制 NBT，由调用方持有。宿主解析不了的文本得到 `Refused`。

- 参数：
    - allocator : `std.mem.Allocator`
    - snbt : `[]const u8`
    - format : `Format`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`nbt_snbt_to_binary`](../cpp/data.md#nbt_snbt_to_binary)

### `nbt.binaryToSnbt` {#nbt.binaryToSnbt}

```zig
pub fn binaryToSnbt(allocator: std.mem.Allocator, data: []const u8, format: Format) core.Error![]u8
```

把二进制 NBT 解码成 SNBT，由调用方持有。不是 NBT 的字节得到 `Refused`。

- 参数：
    - allocator : `std.mem.Allocator`
    - data : `[]const u8`
    - format : `Format`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`nbt_binary_to_snbt`](../cpp/data.md#nbt_binary_to_snbt)

## 声明 {#declarations}

### `nbt.max_depth` {#nbt.max_depth}

```zig
pub const max_depth = 512;
```

接受的最大嵌套深度，和 Minecraft 对 NBT 的上限一样。更深的数据会被拒绝，以免耗尽宿主线程的栈。

## `nbt.Writer` {#nbt.Writer}

```zig
pub const Writer = struct {
    allocator: std.mem.Allocator,
    out: std.ArrayList(u8) = .empty,
    /// One entry per open container: true while it has no element yet.
    empty: std.ArrayList(bool) = .empty,
    after_key: bool = false,
    // ...
};
```

按 Rust 和 Go 绑定的写法生成 SNBT 文本，这样宿主更严格的解析器才会接受：每个键都加引号，每个数字都带类型后缀，控制字符写成 `\uXXXX`。打开一个容器，往里写，再关闭它；复合标签里每个值前面要先写键。写入器不检查调用是否配对。

### `nbt.Writer.init` {#nbt.Writer.init}

```zig
pub fn init(allocator: std.mem.Allocator) Writer
```

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`Writer`

### `nbt.Writer.deinit` {#nbt.Writer.deinit}

```zig
pub fn deinit(self: *Writer) void
```

- 返回值类型：`void`

### `nbt.Writer.text` {#nbt.Writer.text}

```zig
pub fn text(self: *const Writer) []const u8
```

到目前为止写入的文本。

- 返回值类型：`[]const u8`

### `nbt.Writer.toOwnedSlice` {#nbt.Writer.toOwnedSlice}

```zig
pub fn toOwnedSlice(self: *Writer) std.mem.Allocator.Error![]u8
```

写完的文本，由调用方持有。之后写入器是空的。

- 返回值类型：`std.mem.Allocator.Error![]u8`

### `nbt.Writer.beginCompound` {#nbt.Writer.beginCompound}

```zig
pub fn beginCompound(self: *Writer) std.mem.Allocator.Error!void
```

- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.endCompound` {#nbt.Writer.endCompound}

```zig
pub fn endCompound(self: *Writer) std.mem.Allocator.Error!void
```

- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.beginList` {#nbt.Writer.beginList}

```zig
pub fn beginList(self: *Writer) std.mem.Allocator.Error!void
```

- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.endList` {#nbt.Writer.endList}

```zig
pub fn endList(self: *Writer) std.mem.Allocator.Error!void
```

- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.key` {#nbt.Writer.key}

```zig
pub fn key(self: *Writer, name: []const u8) std.mem.Allocator.Error!void
```

写下打开着的复合标签里下一项的键。

- 参数：
    - name : `[]const u8`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.string` {#nbt.Writer.string}

```zig
pub fn string(self: *Writer, value: []const u8) std.mem.Allocator.Error!void
```

- 参数：
    - value : `[]const u8`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.byte` {#nbt.Writer.byte}

```zig
pub fn byte(self: *Writer, value: i8) std.mem.Allocator.Error!void
```

- 参数：
    - value : `i8`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.short` {#nbt.Writer.short}

```zig
pub fn short(self: *Writer, value: i16) std.mem.Allocator.Error!void
```

- 参数：
    - value : `i16`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.int` {#nbt.Writer.int}

```zig
pub fn int(self: *Writer, value: i32) std.mem.Allocator.Error!void
```

- 参数：
    - value : `i32`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.long` {#nbt.Writer.long}

```zig
pub fn long(self: *Writer, value: i64) std.mem.Allocator.Error!void
```

- 参数：
    - value : `i64`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.boolean` {#nbt.Writer.boolean}

```zig
pub fn boolean(self: *Writer, value: bool) std.mem.Allocator.Error!void
```

布尔值是一个字节，1b 或 0b。

- 参数：
    - value : `bool`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.float` {#nbt.Writer.float}

```zig
pub fn float(self: *Writer, value: f32) std.mem.Allocator.Error!void
```

- 参数：
    - value : `f32`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.double` {#nbt.Writer.double}

```zig
pub fn double(self: *Writer, value: f64) std.mem.Allocator.Error!void
```

double 总是带着小数点和 `d`。SNBT 表达不了的值，NaN 或无穷大，写成 0.0。

- 参数：
    - value : `f64`
- 返回值类型：`std.mem.Allocator.Error!void`

### `nbt.Writer.raw` {#nbt.Writer.raw}

```zig
pub fn raw(self: *Writer, snbt: []const u8) std.mem.Allocator.Error!void
```

插入已经是 SNBT 的文本，可以是一个值，也可以是用逗号分隔的多个值，占据一个值的位置。

- 参数：
    - snbt : `[]const u8`
- 返回值类型：`std.mem.Allocator.Error!void`

## `nbt.Value` {#nbt.Value}

```zig
pub const Value = union(enum) {
    byte: i8,
    short: i16,
    int: i32,
    long: i64,
    float: f32,
    double: f64,
    string: []const u8,
    list: []Value,
    compound: []Entry,
    byte_array: []i64,
    int_array: []i64,
    long_array: []i64,
    // ...
};
```

一个 SNBT 值。带类型的数组不论元素多宽，都用 i64 保存数字。

### `nbt.Value.get` {#nbt.Value.get}

```zig
pub fn get(self: Value, path: []const u8) ?Value
```

沿着用点分隔的路径穿过复合标签；某一步不存在时返回 null。

- 参数：
    - path : `[]const u8`
- 返回值类型：`?Value`

### `nbt.Value.getString` {#nbt.Value.getString}

```zig
pub fn getString(self: Value, path: []const u8) ?[]const u8
```

`path` 处的字符串；不存在或者不是字符串时返回 null。

- 参数：
    - path : `[]const u8`
- 返回值类型：`?[]const u8`

### `nbt.Value.getInt` {#nbt.Value.getInt}

```zig
pub fn getInt(self: Value, path: []const u8) ?i64
```

`path` 处任意宽度的整数；不存在或者不是整数时返回 null。

- 参数：
    - path : `[]const u8`
- 返回值类型：`?i64`

### `nbt.Value.getFloat` {#nbt.Value.getFloat}

```zig
pub fn getFloat(self: Value, path: []const u8) ?f64
```

`path` 处的数字，整数或浮点数都可以；不存在时返回 null。

- 参数：
    - path : `[]const u8`
- 返回值类型：`?f64`

### `nbt.Value.getBool` {#nbt.Value.getBool}

```zig
pub fn getBool(self: Value, path: []const u8) ?bool
```

把 `path` 处的字节当作布尔值读取；不存在，或者不是 0 或 1 时返回 null。

- 参数：
    - path : `[]const u8`
- 返回值类型：`?bool`

## `nbt.Entry` {#nbt.Entry}

```zig
pub const Entry = struct {
    key: []const u8,
    value: Value,
    // ...
};
```

复合标签的一个键和它的值。

## `nbt.ParseError` {#nbt.ParseError}

```zig
pub const ParseError = error{ Malformed, TooDeep, OutOfMemory };
```

## `nbt.Format` {#nbt.Format}

```zig
pub const Format = enum(i32) {
    /// Little-endian, as a level stores it on disk.
    disk = 0,
    /// The network encoding.
    network = 1,
};
```

一份 NBT 数据的二进制形式。
