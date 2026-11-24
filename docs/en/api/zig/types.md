# Zig: Shared types

## Declarations {#declarations}

### `types.BlockUpdate.neighbors` {#types.BlockUpdate.neighbors}

```zig
pub const neighbors: BlockUpdate = .{ .bits = 1 };
```

Notify the neighbors, meaning redstone, liquid flow and block updates.

### `types.BlockUpdate.network` {#types.BlockUpdate.network}

```zig
pub const network: BlockUpdate = .{ .bits = 2 };
```

Synchronize to the client.

### `types.BlockUpdate.default` {#types.BlockUpdate.default}

```zig
pub const default: BlockUpdate = .{ .bits = 3 };
```

Both, equivalent to `/setblock`.

### `types.BlockUpdate.none` {#types.BlockUpdate.none}

```zig
pub const none: BlockUpdate = .{ .bits = 0 };
```

Neither. For a bulk fill, resynchronizing afterwards.

## Functions {#functions}

### `types.Owned` {#types.Owned}

```zig
pub fn Owned(comptime T: type) type
```

A list or a record the host produced, whose memory belongs to one arena: `deinit` frees all of it, every string included.

- Parameters:
    - T : `comptime type`
- Return type: `type`

## `types.Bounds` {#types.Bounds}

```zig
pub const Bounds = struct {
    min: Pos3,
    max: Pos3,
    // ...
};
```

A closed box, with both corners included.

### `types.Bounds.init` {#types.Bounds.init}

```zig
pub fn init(a: Pos3, b: Pos3) Bounds
```

The box spanned by two corners given in either order.

- Parameters:
    - a : `Pos3`
    - b : `Pos3`
- Return type: `Bounds`

### `types.Bounds.size` {#types.Bounds.size}

```zig
pub fn size(self: Bounds) [3]u64
```

The number of cells along each axis.

- Return type: `[3]u64`

### `types.Bounds.volume` {#types.Bounds.volume}

```zig
pub fn volume(self: Bounds) u64
```

The number of cells in the box.

- Return type: `u64`

### `types.Bounds.contains` {#types.Bounds.contains}

```zig
pub fn contains(self: Bounds, p: Pos3) bool
```

Whether the cell is inside the box.

- Parameters:
    - p : `Pos3`
- Return type: `bool`

## `types.RayHit` {#types.RayHit}

```zig
pub const RayHit = union(enum) {
    entity: struct { id: i64, pos: Vec3 },
    block: struct { block: Pos3, facing: i32, name: []u8, pos: Vec3 },
    none,
    // ...
};
```

The result of one ray trace, from `actor_trace_ray` or `edit_trace_ray`.

### `types.RayHit.blockPos` {#types.RayHit.blockPos}

```zig
pub fn blockPos(self: RayHit) ?Pos3
```

The cell of a block hit.

- Return type: `?Pos3`

### `types.RayHit.entityId` {#types.RayHit.entityId}

```zig
pub fn entityId(self: RayHit) ?i64
```

The id of an actor hit.

- Return type: `?i64`

### `types.RayHit.deinit` {#types.RayHit.deinit}

```zig
pub fn deinit(self: RayHit, allocator: std.mem.Allocator) void
```

Frees the block name, which belongs to the allocator the trace was given.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `void`

## `types.GameMode` {#types.GameMode}

```zig
pub const GameMode = enum(i32) {
    survival = 0,
    creative = 1,
    adventure = 2,
    spectator = 6,
};
```

The game mode. The values are part of the ABI, through `player_set_gamemode`.

Note that `spectator` is 6 and not 3: the values in between mean other things in the engine, and guessing one from the order sets the player to a different mode.

### `types.GameMode.fromInt` {#types.GameMode.fromInt}

```zig
pub fn fromInt(v: i32) ?GameMode
```

- Parameters:
    - v : `i32`
- Return type: `?GameMode`

## `types.PlayerPermission` {#types.PlayerPermission}

```zig
pub const PlayerPermission = enum(i32) {
    visitor = 0,
    member = 1,
    operator = 2,
    custom = 3,
};
```

The player permission level, through `PIER_PACT_SET_PERMISSION_LEVEL` and `PIER_PPROP_PERMISSION_LEVEL`.

### `types.PlayerPermission.fromInt` {#types.PlayerPermission.fromInt}

```zig
pub fn fromInt(v: i32) ?PlayerPermission
```

- Parameters:
    - v : `i32`
- Return type: `?PlayerPermission`

## `types.Weather` {#types.Weather}

```zig
pub const Weather = enum(i32) {
    clear = 0,
    rain = 1,
    thunder = 2,
};
```

The weather. The three states of `set_weather`.

### `types.Weather.fromInt` {#types.Weather.fromInt}

```zig
pub fn fromInt(v: i32) ?Weather
```

- Parameters:
    - v : `i32`
- Return type: `?Weather`

## `types.Difficulty` {#types.Difficulty}

```zig
pub const Difficulty = enum(i32) {
    peaceful = 0,
    easy = 1,
    normal = 2,
    hard = 3,
};
```

The difficulty.

### `types.Difficulty.fromInt` {#types.Difficulty.fromInt}

```zig
pub fn fromInt(v: i32) ?Difficulty
```

- Parameters:
    - v : `i32`
- Return type: `?Difficulty`

## `types.TitleKind` {#types.TitleKind}

```zig
pub const TitleKind = enum(i32) {
    clear = 0,
    reset = 1,
    title = 2,
    subtitle = 3,
    actionbar = 4,
    times = 5,
};
```

The `SetTitlePacketPayload::TitleType` of `player_send_title`.

### `types.TitleKind.usesText` {#types.TitleKind.usesText}

```zig
pub fn usesText(self: TitleKind) bool
```

Whether this kind carries text.

- Return type: `bool`

## `types.EquipSlot` {#types.EquipSlot}

```zig
pub const EquipSlot = enum(i32) {
    main_hand = 0,
    off_hand = 1,
    helmet = 2,
    chestplate = 3,
    leggings = 4,
    boots = 5,
};
```

An equipment slot. The numbering `actor_get_equipped_item` and `player_get_equipment` use.

### `types.EquipSlot.fromInt` {#types.EquipSlot.fromInt}

```zig
pub fn fromInt(v: i32) ?EquipSlot
```

- Parameters:
    - v : `i32`
- Return type: `?EquipSlot`

## `types.Ability` {#types.Ability}

```zig
pub const Ability = enum(i32) {
    build = 0,
    mine = 1,
    doors_and_switches = 2,
    open_containers = 3,
    attack_players = 4,
    attack_mobs = 5,
    operator = 6,
    teleport = 7,
    invulnerable = 8,
    flying = 9,
    may_fly = 10,
    instabuild = 11,
    lightning = 12,
    fly_speed = 13,
    walk_speed = 14,
    muted = 15,
    world_builder = 16,
    no_clip = 17,
    privileged_builder = 18,
    vertical_fly_speed = 19,
};
```

A player ability bit. The index of `PIER_PACT_SET_ABILITY` and `PIER_PACT_CAN_USE_ABILITY`.

The three carrying `speed` are floating-point abilities and the rest are boolean.

### `types.Ability.isFloat` {#types.Ability.isFloat}

```zig
pub fn isFloat(self: Ability) bool
```

Whether the ability holds a number and not a flag.

- Return type: `bool`

## `types.Pos3` {#types.Pos3}

```zig
pub const Pos3 = struct {
    x: i32, y: i32, z: i32
    // ...
};
```

A block coordinate.

## `types.Vec3` {#types.Vec3}

```zig
pub const Vec3 = struct {
    x: f64, y: f64, z: f64
    // ...
};
```

An actor or exact coordinate.

## `types.MessageType` {#types.MessageType}

```zig
pub const MessageType = enum(i32) {
    raw = 0,
    chat = 1,
    translate = 2,
    popup = 3,
    jukebox_popup = 4,
    tip = 5,
    system_message = 6,
    whisper = 7,
    announcement = 8,
    text_object_whisper = 9,
    text_object = 10,
    text_object_announcement = 11,
};
```

The `TextPacketType` of `player_send_message_typed`.

The host falls back to `raw` on an out-of-range value, so no fallback branch is needed here.

## `types.TitleTimes` {#types.TitleTimes}

```zig
pub const TitleTimes = struct {
    fade_in: i32 = 10,
    stay: i32 = 60,
    fade_out: i32 = 10,
    // ...
};
```

The three title durations, in ticks.

All three are given together or not at all: the host refuses a half-specified combination rather than guessing the rest for the caller.

## `types.BlockUpdate` {#types.BlockUpdate}

```zig
pub const BlockUpdate = struct {
    bits: i32,
    // ...
};
```

Tells the engine which follow-up work a block write needs.

## `types.LocalTime` {#types.LocalTime}

```zig
pub const LocalTime = struct {
    year: i32,
    month: i32,
    day: i32,
    hour: i32,
    minute: i32,
    second: i32,
    ms: i32,
    // ...
};
```

The local time, from `PIER_SYS_LOCAL_TIME`.

## `types.AttributeValue` {#types.AttributeValue}

```zig
pub const AttributeValue = struct {
    current: f64,
    min: f64,
    max: f64,
    default: f64,
    // ...
};
```

One attribute of an entity as `Entity.attributeInfo` reads it.

## `types.Aabb` {#types.Aabb}

```zig
pub const Aabb = struct {
    min: Vec3,
    max: Vec3,
    // ...
};
```

The axis-aligned bounding box of an actor.

## `types.Effect` {#types.Effect}

```zig
pub const Effect = struct {
    /// The effect's name, or its number written out when the host gives one.
    id: []const u8,
    ticks: i32,
    amplifier: i32,
    visible: bool,
    // ...
};
```

One status effect.

## `types.Enchant` {#types.Enchant}

```zig
pub const Enchant = struct {
    id: []const u8,
    level: i32,
    // ...
};
```

One enchantment.

## `types.NetworkStatus` {#types.NetworkStatus}

```zig
pub const NetworkStatus = struct {
    ping: i32,
    avg_ping: i32,
    max_ping: i32,
    packet_loss: i32,
    // ...
};
```

The network status of a player, from `PIER_PSTR_NETWORK_STATUS`. A value the host could not measure is -1.

## `types.EquipmentEntry` {#types.EquipmentEntry}

```zig
pub const EquipmentEntry = struct {
    slot: i32,
    item_snbt: []const u8,
    // ...
};
```

One slot of a player's equipment.

## `types.PlayerPosition` {#types.PlayerPosition}

```zig
pub const PlayerPosition = struct {
    pos: Vec3,
    dim: i32,
    // ...
};
```

A player's feet position and the dimension it is in.

## `types.ItemOp` {#types.ItemOp}

```zig
pub const ItemOp = enum(i32) {
    set_custom_name = 0,
    set_damage = 1,
    set_count = 2,
    set_lore = 3,
    set_unbreakable = 4,
    hurt_and_break = 5,
    set_repair_cost = 6,
    add_enchant = 7,
    remove_enchants = 8,
    clear_lore = 9,
    reset_name = 10,
    set_can_destroy = 11,
    set_can_place_on = 12,
};
```

The operations of `Item.transform`, the numbering of `item_transform`.
