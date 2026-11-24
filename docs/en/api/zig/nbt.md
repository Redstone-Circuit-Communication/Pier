# Zig: SNBT values

nbt.zig: SNBT parsing and writing for Zig mods, with the rules of the Rust and Go bindings: a bare number is an int, then a long, then a double; a suffix b, s, l, f or d fixes the type; true and false are bytes; any other bare word is a string.

## Functions {#functions}

### `nbt.parse` {#nbt.parse}

```zig
pub fn parse(arena: std.mem.Allocator, text: []const u8) ParseError!Value
```

Parses SNBT. Every node is allocated with `arena`, which the caller frees as a whole; a bare string or key may also point into `text`, which must outlive the result.

- Parameters:
    - arena : `std.mem.Allocator`
    - text : `[]const u8`
- Return type: `ParseError!Value`

### `nbt.snbtToBinary` {#nbt.snbtToBinary}

```zig
pub fn snbtToBinary(allocator: std.mem.Allocator, snbt: []const u8, format: Format) core.Error![]u8
```

Encodes SNBT as binary NBT, owned by the caller. Refused for text the host cannot parse.

- Parameters:
    - allocator : `std.mem.Allocator`
    - snbt : `[]const u8`
    - format : `Format`
- Return type: `core.Error![]u8`
- Slots: [`nbt_snbt_to_binary`](../cpp/data.md#nbt_snbt_to_binary)

### `nbt.binaryToSnbt` {#nbt.binaryToSnbt}

```zig
pub fn binaryToSnbt(allocator: std.mem.Allocator, data: []const u8, format: Format) core.Error![]u8
```

Decodes binary NBT as SNBT, owned by the caller. Refused for bytes that are not NBT.

- Parameters:
    - allocator : `std.mem.Allocator`
    - data : `[]const u8`
    - format : `Format`
- Return type: `core.Error![]u8`
- Slots: [`nbt_binary_to_snbt`](../cpp/data.md#nbt_binary_to_snbt)

## Declarations {#declarations}

### `nbt.max_depth` {#nbt.max_depth}

```zig
pub const max_depth = 512;
```

The deepest nesting accepted, the cap Minecraft puts on NBT. A deeper payload is refused instead of exhausting the stack of a host thread.

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

Builds SNBT text the way the Rust and Go bindings write it, so the host's stricter parser accepts it: every key is quoted, every number carries its type suffix, and a control character is written as `\uXXXX`.

Open a container, write into it, close it; a key goes before each value of a compound. The writer does not check that the calls balance.

### `nbt.Writer.init` {#nbt.Writer.init}

```zig
pub fn init(allocator: std.mem.Allocator) Writer
```

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `Writer`

### `nbt.Writer.deinit` {#nbt.Writer.deinit}

```zig
pub fn deinit(self: *Writer) void
```

- Return type: `void`

### `nbt.Writer.text` {#nbt.Writer.text}

```zig
pub fn text(self: *const Writer) []const u8
```

The text written so far.

- Return type: `[]const u8`

### `nbt.Writer.toOwnedSlice` {#nbt.Writer.toOwnedSlice}

```zig
pub fn toOwnedSlice(self: *Writer) std.mem.Allocator.Error![]u8
```

The finished text, owned by the caller. The writer is empty afterwards.

- Return type: `std.mem.Allocator.Error![]u8`

### `nbt.Writer.beginCompound` {#nbt.Writer.beginCompound}

```zig
pub fn beginCompound(self: *Writer) std.mem.Allocator.Error!void
```

- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.endCompound` {#nbt.Writer.endCompound}

```zig
pub fn endCompound(self: *Writer) std.mem.Allocator.Error!void
```

- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.beginList` {#nbt.Writer.beginList}

```zig
pub fn beginList(self: *Writer) std.mem.Allocator.Error!void
```

- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.endList` {#nbt.Writer.endList}

```zig
pub fn endList(self: *Writer) std.mem.Allocator.Error!void
```

- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.key` {#nbt.Writer.key}

```zig
pub fn key(self: *Writer, name: []const u8) std.mem.Allocator.Error!void
```

Writes the key of the next entry of the open compound.

- Parameters:
    - name : `[]const u8`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.string` {#nbt.Writer.string}

```zig
pub fn string(self: *Writer, value: []const u8) std.mem.Allocator.Error!void
```

- Parameters:
    - value : `[]const u8`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.byte` {#nbt.Writer.byte}

```zig
pub fn byte(self: *Writer, value: i8) std.mem.Allocator.Error!void
```

- Parameters:
    - value : `i8`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.short` {#nbt.Writer.short}

```zig
pub fn short(self: *Writer, value: i16) std.mem.Allocator.Error!void
```

- Parameters:
    - value : `i16`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.int` {#nbt.Writer.int}

```zig
pub fn int(self: *Writer, value: i32) std.mem.Allocator.Error!void
```

- Parameters:
    - value : `i32`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.long` {#nbt.Writer.long}

```zig
pub fn long(self: *Writer, value: i64) std.mem.Allocator.Error!void
```

- Parameters:
    - value : `i64`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.boolean` {#nbt.Writer.boolean}

```zig
pub fn boolean(self: *Writer, value: bool) std.mem.Allocator.Error!void
```

A boolean is a byte, 1b or 0b.

- Parameters:
    - value : `bool`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.float` {#nbt.Writer.float}

```zig
pub fn float(self: *Writer, value: f32) std.mem.Allocator.Error!void
```

- Parameters:
    - value : `f32`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.double` {#nbt.Writer.double}

```zig
pub fn double(self: *Writer, value: f64) std.mem.Allocator.Error!void
```

A double always carries its decimal point and its `d`. A value SNBT cannot express, NaN or an infinity, is written as 0.0.

- Parameters:
    - value : `f64`
- Return type: `std.mem.Allocator.Error!void`

### `nbt.Writer.raw` {#nbt.Writer.raw}

```zig
pub fn raw(self: *Writer, snbt: []const u8) std.mem.Allocator.Error!void
```

Inserts text that is already SNBT, one value or several separated by commas, in the place of one value.

- Parameters:
    - snbt : `[]const u8`
- Return type: `std.mem.Allocator.Error!void`

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

One SNBT value. Typed arrays hold their numbers as i64 whatever the element width.

### `nbt.Value.get` {#nbt.Value.get}

```zig
pub fn get(self: Value, path: []const u8) ?Value
```

Follows a dotted path through compounds; null when a step is missing.

- Parameters:
    - path : `[]const u8`
- Return type: `?Value`

### `nbt.Value.getString` {#nbt.Value.getString}

```zig
pub fn getString(self: Value, path: []const u8) ?[]const u8
```

The string at path, or null when it is absent or not a string.

- Parameters:
    - path : `[]const u8`
- Return type: `?[]const u8`

### `nbt.Value.getInt` {#nbt.Value.getInt}

```zig
pub fn getInt(self: Value, path: []const u8) ?i64
```

The integer at path of any width, or null when it is absent or not one.

- Parameters:
    - path : `[]const u8`
- Return type: `?i64`

### `nbt.Value.getFloat` {#nbt.Value.getFloat}

```zig
pub fn getFloat(self: Value, path: []const u8) ?f64
```

The number at path, integer or floating, or null when it is absent.

- Parameters:
    - path : `[]const u8`
- Return type: `?f64`

### `nbt.Value.getBool` {#nbt.Value.getBool}

```zig
pub fn getBool(self: Value, path: []const u8) ?bool
```

The byte at path read as a boolean, or null when it is absent or not 0 or 1.

- Parameters:
    - path : `[]const u8`
- Return type: `?bool`

## `nbt.Entry` {#nbt.Entry}

```zig
pub const Entry = struct {
    key: []const u8,
    value: Value,
    // ...
};
```

One key of a compound and its value.

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

The binary form of an NBT payload.
