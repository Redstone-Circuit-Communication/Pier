# Zig: Simulated players

## Functions {#functions}

### `sim.list` {#sim.list}

```zig
pub fn list(allocator: Allocator) core.Error![][]u8
```

The names of the simulated players alive now, owned by the caller; `core.freeList` releases them. A bot that outlived the session that spawned it is found again by name.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error![][]u8`
- Slots: [`sim_list`](../cpp/sim.md#sim_list)

## `sim.SimPlayer` {#sim.SimPlayer}

```zig
pub const SimPlayer = struct {
    name: []const u8,
    // ...
};
```

One simulated player, named. The name is borrowed and must outlive the value.

### `sim.SimPlayer.spawn` {#sim.SimPlayer.spawn}

```zig
pub fn spawn(name: []const u8, dim: i32, x: f64, y: f64, z: f64) core.Error!SimPlayer
```

Builds a simulated player. It fails when the name is taken by a real player.

- Parameters:
    - name : `[]const u8`
    - dim : `i32`
    - x : `f64`
    - y : `f64`
    - z : `f64`
- Return type: `core.Error!SimPlayer`
- Slots: [`sim_spawn`](../cpp/sim.md#sim_spawn)

### `sim.SimPlayer.byName` {#sim.SimPlayer.byName}

```zig
pub fn byName(name: []const u8) SimPlayer
```

Attaches by name to a simulated player that already exists. It does not check whether one does; `isSimulated` does.

- Parameters:
    - name : `[]const u8`
- Return type: `SimPlayer`

### `sim.SimPlayer.player` {#sim.SimPlayer.player}

```zig
pub fn player(self: SimPlayer) props.Player
```

Uses it as an ordinary player, giving the full player API.

- Return type: `props.Player`

### `sim.SimPlayer.isSimulated` {#sim.SimPlayer.isSimulated}

```zig
pub fn isSimulated(self: SimPlayer) core.Error!bool
```

Whether this name currently points at a live simulated player.

- Return type: `core.Error!bool`
- Slots: [`sim_is`](../cpp/sim.md#sim_is)

### `sim.SimPlayer.act` {#sim.SimPlayer.act}

```zig
pub fn act(self: SimPlayer, verb: []const u8, args_snbt: []const u8) core.Error!void
```

Runs one verb. The argument is SNBT, and "{}" is passed when there is none.

- Parameters:
    - verb : `[]const u8`
    - args_snbt : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.despawn` {#sim.SimPlayer.despawn}

```zig
pub fn despawn(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.stop` {#sim.SimPlayer.stop}

```zig
pub fn stop(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.jump` {#sim.SimPlayer.jump}

```zig
pub fn jump(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.attack` {#sim.SimPlayer.attack}

```zig
pub fn attack(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.interact` {#sim.SimPlayer.interact}

```zig
pub fn interact(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.useItem` {#sim.SimPlayer.useItem}

```zig
pub fn useItem(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.dropSelected` {#sim.SimPlayer.dropSelected}

```zig
pub fn dropSelected(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.respawn` {#sim.SimPlayer.respawn}

```zig
pub fn respawn(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.stopDestroying` {#sim.SimPlayer.stopDestroying}

```zig
pub fn stopDestroying(self: SimPlayer) core.Error!void
```

- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.moveTo` {#sim.SimPlayer.moveTo}

```zig
pub fn moveTo(self: SimPlayer, x: f64, y: f64, z: f64, speed: f64, face_target: bool) core.Error!void
```

Walks straight there. `face_target` decides whether it faces the target while walking.

- Parameters:
    - x : `f64`
    - y : `f64`
    - z : `f64`
    - speed : `f64`
    - face_target : `bool`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.navigateTo` {#sim.SimPlayer.navigateTo}

```zig
pub fn navigateTo(self: SimPlayer, x: f64, y: f64, z: f64, speed: f64) core.Error!void
```

Paths there. Unlike `moveTo` it goes around obstacles.

- Parameters:
    - x : `f64`
    - y : `f64`
    - z : `f64`
    - speed : `f64`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.lookAt` {#sim.SimPlayer.lookAt}

```zig
pub fn lookAt(self: SimPlayer, x: f64, y: f64, z: f64) core.Error!void
```

- Parameters:
    - x : `f64`
    - y : `f64`
    - z : `f64`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.destroyBlock` {#sim.SimPlayer.destroyBlock}

```zig
pub fn destroyBlock(self: SimPlayer, x: i32, y: i32, z: i32, face: i32) core.Error!void
```

Mines one block. `face` is the face, 1 meaning up.

- Parameters:
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - face : `i32`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.interactBlock` {#sim.SimPlayer.interactBlock}

```zig
pub fn interactBlock(self: SimPlayer, x: i32, y: i32, z: i32, face: i32) core.Error!void
```

- Parameters:
    - x : `i32`
    - y : `i32`
    - z : `i32`
    - face : `i32`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.destroyLookAt` {#sim.SimPlayer.destroyLookAt}

```zig
pub fn destroyLookAt(self: SimPlayer, hand: f64) core.Error!void
```

Mines the block in the line of sight. `hand` is the reach, in blocks.

- Parameters:
    - hand : `f64`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.setSneaking` {#sim.SimPlayer.setSneaking}

```zig
pub fn setSneaking(self: SimPlayer, on: bool) core.Error!void
```

- Parameters:
    - on : `bool`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.setFlying` {#sim.SimPlayer.setFlying}

```zig
pub fn setFlying(self: SimPlayer, on: bool) core.Error!void
```

- Parameters:
    - on : `bool`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)

### `sim.SimPlayer.chat` {#sim.SimPlayer.chat}

```zig
pub fn chat(self: SimPlayer, message: []const u8) core.Error!void
```

- Parameters:
    - message : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`sim_do`](../cpp/sim.md#sim_do)
