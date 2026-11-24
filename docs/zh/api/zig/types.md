# Zig：通用类型

## 声明 {#declarations}

### `types.BlockUpdate.neighbors` {#types.BlockUpdate.neighbors}

```zig
pub const neighbors: BlockUpdate = .{ .bits = 1 };
```

通知相邻方块，包括红石、液体流动和方块更新。

### `types.BlockUpdate.network` {#types.BlockUpdate.network}

```zig
pub const network: BlockUpdate = .{ .bits = 2 };
```

同步给客户端。

### `types.BlockUpdate.default` {#types.BlockUpdate.default}

```zig
pub const default: BlockUpdate = .{ .bits = 3 };
```

两者都做，等同于 `/setblock`。

### `types.BlockUpdate.none` {#types.BlockUpdate.none}

```zig
pub const none: BlockUpdate = .{ .bits = 0 };
```

都不做。用于批量填充，之后再重新同步。

## 函数 {#functions}

### `types.Owned` {#types.Owned}

```zig
pub fn Owned(comptime T: type) type
```

宿主产生的一个列表或一条记录，它的内存属于同一个 arena：`deinit` 会把它全部释放，每个字符串都包括在内。

- 参数：
    - T : `comptime type`
- 返回值类型：`type`

## `types.Bounds` {#types.Bounds}

```zig
pub const Bounds = struct {
    min: Pos3,
    max: Pos3,
    // ...
};
```

一个闭区间的长方体，两个角都包含在内。

### `types.Bounds.init` {#types.Bounds.init}

```zig
pub fn init(a: Pos3, b: Pos3) Bounds
```

由两个角张成的盒子，两个角按任意顺序给出都可以。

- 参数：
    - a : `Pos3`
    - b : `Pos3`
- 返回值类型：`Bounds`

### `types.Bounds.size` {#types.Bounds.size}

```zig
pub fn size(self: Bounds) [3]u64
```

每个轴上的格子数。

- 返回值类型：`[3]u64`

### `types.Bounds.volume` {#types.Bounds.volume}

```zig
pub fn volume(self: Bounds) u64
```

盒子里的格子数。

- 返回值类型：`u64`

### `types.Bounds.contains` {#types.Bounds.contains}

```zig
pub fn contains(self: Bounds, p: Pos3) bool
```

这个格子是否在盒子里。

- 参数：
    - p : `Pos3`
- 返回值类型：`bool`

## `types.RayHit` {#types.RayHit}

```zig
pub const RayHit = union(enum) {
    entity: struct { id: i64, pos: Vec3 },
    block: struct { block: Pos3, facing: i32, name: []u8, pos: Vec3 },
    none,
    // ...
};
```

一次射线检测的结果，来自 `actor_trace_ray` 或 `edit_trace_ray`。

### `types.RayHit.blockPos` {#types.RayHit.blockPos}

```zig
pub fn blockPos(self: RayHit) ?Pos3
```

方块命中的格子。

- 返回值类型：`?Pos3`

### `types.RayHit.entityId` {#types.RayHit.entityId}

```zig
pub fn entityId(self: RayHit) ?i64
```

命中的实体的 id。

- 返回值类型：`?i64`

### `types.RayHit.deinit` {#types.RayHit.deinit}

```zig
pub fn deinit(self: RayHit, allocator: std.mem.Allocator) void
```

释放方块名，它属于追踪时给出的分配器。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`void`

## `types.GameMode` {#types.GameMode}

```zig
pub const GameMode = enum(i32) {
    survival = 0,
    creative = 1,
    adventure = 2,
    spectator = 6,
};
```

游戏模式。取值是 ABI 的一部分，通过 `player_set_gamemode` 传递。注意 `spectator` 是 6 而不是 3：中间的值在引擎里另有含义，按顺序猜一个值会把玩家设成另一个模式。

### `types.GameMode.fromInt` {#types.GameMode.fromInt}

```zig
pub fn fromInt(v: i32) ?GameMode
```

- 参数：
    - v : `i32`
- 返回值类型：`?GameMode`

## `types.PlayerPermission` {#types.PlayerPermission}

```zig
pub const PlayerPermission = enum(i32) {
    visitor = 0,
    member = 1,
    operator = 2,
    custom = 3,
};
```

玩家的权限等级，经 `PIER_PACT_SET_PERMISSION_LEVEL` 和 `PIER_PPROP_PERMISSION_LEVEL` 传递。

### `types.PlayerPermission.fromInt` {#types.PlayerPermission.fromInt}

```zig
pub fn fromInt(v: i32) ?PlayerPermission
```

- 参数：
    - v : `i32`
- 返回值类型：`?PlayerPermission`

## `types.Weather` {#types.Weather}

```zig
pub const Weather = enum(i32) {
    clear = 0,
    rain = 1,
    thunder = 2,
};
```

天气。`set_weather` 的三种状态。

### `types.Weather.fromInt` {#types.Weather.fromInt}

```zig
pub fn fromInt(v: i32) ?Weather
```

- 参数：
    - v : `i32`
- 返回值类型：`?Weather`

## `types.Difficulty` {#types.Difficulty}

```zig
pub const Difficulty = enum(i32) {
    peaceful = 0,
    easy = 1,
    normal = 2,
    hard = 3,
};
```

难度。

### `types.Difficulty.fromInt` {#types.Difficulty.fromInt}

```zig
pub fn fromInt(v: i32) ?Difficulty
```

- 参数：
    - v : `i32`
- 返回值类型：`?Difficulty`

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

`player_send_title` 的 `SetTitlePacketPayload::TitleType`。

### `types.TitleKind.usesText` {#types.TitleKind.usesText}

```zig
pub fn usesText(self: TitleKind) bool
```

这种类型是否带文字。

- 返回值类型：`bool`

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

装备槽位。`actor_get_equipped_item` 和 `player_get_equipment` 用的编号。

### `types.EquipSlot.fromInt` {#types.EquipSlot.fromInt}

```zig
pub fn fromInt(v: i32) ?EquipSlot
```

- 参数：
    - v : `i32`
- 返回值类型：`?EquipSlot`

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

玩家的一个能力位。是 `PIER_PACT_SET_ABILITY` 和 `PIER_PACT_CAN_USE_ABILITY` 的索引。带 `speed` 的三个是浮点能力，其余是布尔能力。

### `types.Ability.isFloat` {#types.Ability.isFloat}

```zig
pub fn isFloat(self: Ability) bool
```

这个能力保存的是数字还是标志。

- 返回值类型：`bool`

## `types.Pos3` {#types.Pos3}

```zig
pub const Pos3 = struct {
    x: i32, y: i32, z: i32
    // ...
};
```

一个方块坐标。

## `types.Vec3` {#types.Vec3}

```zig
pub const Vec3 = struct {
    x: f64, y: f64, z: f64
    // ...
};
```

一个实体坐标或精确坐标。

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

`player_send_message_typed` 的 `TextPacketType`。取值超出范围时宿主回退到 `raw`，所以这里不需要回退分支。

## `types.TitleTimes` {#types.TitleTimes}

```zig
pub const TitleTimes = struct {
    fade_in: i32 = 10,
    stay: i32 = 60,
    fade_out: i32 = 10,
    // ...
};
```

三个标题持续时间，单位为 tick。三个要么一起给出、要么都不给：宿主会拒绝只给一半的组合，而不是替调用方猜剩下的。

## `types.BlockUpdate` {#types.BlockUpdate}

```zig
pub const BlockUpdate = struct {
    bits: i32,
    // ...
};
```

告诉引擎一次方块写入需要做哪些后续工作。

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

本地时间，取自 `PIER_SYS_LOCAL_TIME`。

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

一个实体的一项属性，即 `Entity.attributeInfo` 读到的内容。

## `types.Aabb` {#types.Aabb}

```zig
pub const Aabb = struct {
    min: Vec3,
    max: Vec3,
    // ...
};
```

实体的轴对齐碰撞箱。

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

一个状态效果。

## `types.Enchant` {#types.Enchant}

```zig
pub const Enchant = struct {
    id: []const u8,
    level: i32,
    // ...
};
```

一个附魔。

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

一名玩家的网络状态，来自 `PIER_PSTR_NETWORK_STATUS`。宿主测不出来的值是 -1。

## `types.EquipmentEntry` {#types.EquipmentEntry}

```zig
pub const EquipmentEntry = struct {
    slot: i32,
    item_snbt: []const u8,
    // ...
};
```

玩家装备的一个槽位。

## `types.PlayerPosition` {#types.PlayerPosition}

```zig
pub const PlayerPosition = struct {
    pos: Vec3,
    dim: i32,
    // ...
};
```

一名玩家脚下的位置，以及它所在的维度。

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

`Item.transform` 的各个操作，使用 `item_transform` 的编号。
