# Zig：模拟玩家

## 函数 {#functions}

### `sim.list` {#sim.list}

```zig
pub fn list(allocator: Allocator) core.Error![][]u8
```

现在存活的模拟玩家的名字，由调用方持有；用 `core.freeList` 释放。比生成它的那次会话活得更久的 bot，可以凭名字重新找到。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error![][]u8`
- 对应槽位：[`sim_list`](../cpp/sim.md#sim_list)

## `sim.SimPlayer` {#sim.SimPlayer}

```zig
pub const SimPlayer = struct {
    name: []const u8,
    // ...
};
```

一个模拟玩家，用名字表示。名字只是借用，必须比这个值活得更久。

### `sim.SimPlayer.spawn` {#sim.SimPlayer.spawn}

```zig
pub fn spawn(name: []const u8, dim: i32, x: f64, y: f64, z: f64) core.Error!SimPlayer
```

构造一个模拟玩家。名字被一个真实玩家占用时失败。

- 参数：
    - name : `[]const u8`
    - dim : `i32`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- 返回值类型：`core.Error!SimPlayer`
- 对应槽位：[`sim_spawn`](../cpp/sim.md#sim_spawn)

### `sim.SimPlayer.byName` {#sim.SimPlayer.byName}

```zig
pub fn byName(name: []const u8) SimPlayer
```

按名字附着到一个已经存在的模拟玩家上。它不检查是否真的存在，`isSimulated` 才会检查。

- 参数：
    - name : `[]const u8`
- 返回值类型：`SimPlayer`

### `sim.SimPlayer.player` {#sim.SimPlayer.player}

```zig
pub fn player(self: SimPlayer) props.Player
```

把它当作普通玩家使用，获得完整的玩家接口。

- 返回值类型：`props.Player`

### `sim.SimPlayer.isSimulated` {#sim.SimPlayer.isSimulated}

```zig
pub fn isSimulated(self: SimPlayer) core.Error!bool
```

这个名字现在是否指向一个存活的模拟玩家。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`sim_is`](../cpp/sim.md#sim_is)

### `sim.SimPlayer.act` {#sim.SimPlayer.act}

```zig
pub fn act(self: SimPlayer, verb: []const u8, args_snbt: []const u8) core.Error!void
```

执行一个动词。参数是 SNBT，没有参数时传 "{}"。

- 参数：
    - verb : `[]const u8`
    - args_snbt : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.despawn` {#sim.SimPlayer.despawn}

```zig
pub fn despawn(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.stop` {#sim.SimPlayer.stop}

```zig
pub fn stop(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.jump` {#sim.SimPlayer.jump}

```zig
pub fn jump(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.attack` {#sim.SimPlayer.attack}

```zig
pub fn attack(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.interact` {#sim.SimPlayer.interact}

```zig
pub fn interact(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.useItem` {#sim.SimPlayer.useItem}

```zig
pub fn useItem(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.dropSelected` {#sim.SimPlayer.dropSelected}

```zig
pub fn dropSelected(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.respawn` {#sim.SimPlayer.respawn}

```zig
pub fn respawn(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.stopDestroying` {#sim.SimPlayer.stopDestroying}

```zig
pub fn stopDestroying(self: SimPlayer) core.Error!void
```

- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.moveTo` {#sim.SimPlayer.moveTo}

```zig
pub fn moveTo(self: SimPlayer, x: f64, y: f64, z: f64, speed: f64, face_target: bool) core.Error!void
```

径直走过去。`face_target` 决定走的时候是否面向目标。

- 参数：
    - x : `f64`
    - y : `f64`
    - z : `f64`
    - speed : `f64`
    - face_target : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.navigateTo` {#sim.SimPlayer.navigateTo}

```zig
pub fn navigateTo(self: SimPlayer, x: f64, y: f64, z: f64, speed: f64) core.Error!void
```

寻路前往。与 `moveTo` 不同，它会绕开障碍物。

- 参数：
    - x : `f64`
    - y : `f64`
    - z : `f64`
    - speed : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.lookAt` {#sim.SimPlayer.lookAt}

```zig
pub fn lookAt(self: SimPlayer, x: f64, y: f64, z: f64) core.Error!void
```

- 参数：
    - x : `f64`
    - y : `f64`
    - z : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.destroyBlock` {#sim.SimPlayer.destroyBlock}

```zig
pub fn destroyBlock(self: SimPlayer, x: i32, y: i32, z: i32, face: i32) core.Error!void
```

挖掉一个方块。`face` 是面，1 表示朝上。

- 参数：
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - face : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.interactBlock` {#sim.SimPlayer.interactBlock}

```zig
pub fn interactBlock(self: SimPlayer, x: i32, y: i32, z: i32, face: i32) core.Error!void
```

- 参数：
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - face : `i32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.destroyLookAt` {#sim.SimPlayer.destroyLookAt}

```zig
pub fn destroyLookAt(self: SimPlayer, hand: f64) core.Error!void
```

挖掉视线上的方块。`hand` 是触及距离，单位为格。

- 参数：
    - hand : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.setSneaking` {#sim.SimPlayer.setSneaking}

```zig
pub fn setSneaking(self: SimPlayer, on: bool) core.Error!void
```

- 参数：
    - on : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.setFlying` {#sim.SimPlayer.setFlying}

```zig
pub fn setFlying(self: SimPlayer, on: bool) core.Error!void
```

- 参数：
    - on : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.chat` {#sim.SimPlayer.chat}

```zig
pub fn chat(self: SimPlayer, message: []const u8) core.Error!void
```

- 参数：
    - message : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sim_do`](../cpp/sim.md#sim_do)
