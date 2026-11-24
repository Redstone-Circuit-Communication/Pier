# Zig: Server, ticks and system information

## Functions {#functions}

### `props.srvBdsVersion` {#props.srvBdsVersion}

```zig
pub fn srvBdsVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_BDS_VERSION`: `Common::getGameVersionString`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvProtocolVersion` {#props.srvProtocolVersion}

```zig
pub fn srvProtocolVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_PROTOCOL_VERSION`: `LevelData::mNetworkVersion`: the protocol the level was last written by. Says how old the save is, not what the server speaks.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvLevelProtocolVersion` {#props.srvLevelProtocolVersion}

```zig
pub fn srvLevelProtocolVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_LEVEL_PROTOCOL_VERSION`: "major.minor.patch" of the running build, from CurrentGameSemVersion. Lets a mod carry its own version→protocol table instead of waiting for a Pier release.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvGameSemVersion` {#props.srvGameSemVersion}

```zig
pub fn srvGameSemVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_GAME_SEM_VERSION`: `PIER_SRV_GAME_SEM_VERSION`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvLoaderVersion` {#props.srvLoaderVersion}

```zig
pub fn srvLoaderVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_LOADER_VERSION`: `ll::getLoaderVersion`, the running LeviLamina

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvLevelName` {#props.srvLevelName}

```zig
pub fn srvLevelName(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_LEVEL_NAME`: `LevelData::mLevelName`, the world name

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvIsHardcore` {#props.srvIsHardcore}

```zig
pub fn srvIsHardcore(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_IS_HARDCORE`: `LevelData::mIsHardcore`, "1" or "0"

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvWorldStartCount` {#props.srvWorldStartCount}

```zig
pub fn srvWorldStartCount(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_WORLD_START_COUNT`: `LevelData::mWorldStartCount`, how many times the world was opened

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvEducationFeatures` {#props.srvEducationFeatures}

```zig
pub fn srvEducationFeatures(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_EDUCATION_FEATURES`: `LevelData::mEducationFeaturesEnabled`, "1" or "0"

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `props.sysOsName` {#props.sysOsName}

```zig
pub fn sysOsName(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_OS_NAME`: `sys_utils::getSystemName`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysOsVersion` {#props.sysOsVersion}

```zig
pub fn sysOsVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_OS_VERSION`: `sys_utils::getSystemVersion` → string

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysLocale` {#props.sysLocale}

```zig
pub fn sysLocale(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_LOCALE`: `sys_utils::getSystemLocaleCode`

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysLocalTime` {#props.sysLocalTime}

```zig
pub fn sysLocalTime(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_LOCAL_TIME`: `sys_utils::getLocalTime` → SNBT {year,month,day,hour,minute,second,ms}

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysProcessId` {#props.sysProcessId}

```zig
pub fn sysProcessId(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_PROCESS_ID`: the id of the server process

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `core.Error![]u8`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `server.gamingStatus` {#server.gamingStatus}

```zig
pub fn gamingStatus() core.Error!GamingStatus
```

Which stage the server is in. Thread safe: any thread may ask.

- Return type: `core.Error!GamingStatus`
- Slots: [`gaming_status`](../cpp/core.md#gaming_status)

### `server.currentTick` {#server.currentTick}

```zig
pub fn currentTick() core.Error!u64
```

The current server tick. NoAnswer while the level is not ready.

- Return type: `core.Error!u64`
- Slots: [`get_current_tick`](../cpp/server.md#get_current_tick)

### `server.playerCount` {#server.playerCount}

```zig
pub fn playerCount() core.Error!i32
```

How many players are connected.

- Return type: `core.Error!i32`
- Slots: [`get_player_count`](../cpp/server.md#get_player_count)

### `server.isSimPaused` {#server.isSimPaused}

```zig
pub fn isSimPaused() core.Error!bool
```

Whether the simulation is paused.

- Return type: `core.Error!bool`
- Slots: [`get_sim_paused`](../cpp/server.md#get_sim_paused)

### `server.tickDeltaTime` {#server.tickDeltaTime}

```zig
pub fn tickDeltaTime() core.Error!f64
```

The wall-clock period of the last frame in seconds. At 20 TPS it is 0.05.

- Return type: `core.Error!f64`
- Slots: [`get_tick_delta_time`](../cpp/server.md#get_tick_delta_time)

### `server.tps` {#server.tps}

```zig
pub fn tps() core.Error!f64
```

Ticks per second over the last 5 seconds of wall clock.

- Return type: `core.Error!f64`
- Slots: [`get_tps`](../cpp/server.md#get_tps)

### `server.tpsOver` {#server.tpsOver}

```zig
pub fn tpsOver(window_seconds: i32) core.Error!f64
```

As `tps`, over a window of `window_seconds`, from 1 to 60 and clipped by the host.

- Parameters:
    - window_seconds : `i32`
- Return type: `core.Error!f64`
- Slots: [`get_tps`](../cpp/server.md#get_tps)

### `server.mspt` {#server.mspt}

```zig
pub fn mspt() core.Error!f64
```

Milliseconds spent computing each tick, averaged over the last 5 seconds.

- Return type: `core.Error!f64`
- Slots: [`get_mspt`](../cpp/server.md#get_mspt)

### `server.msptOver` {#server.msptOver}

```zig
pub fn msptOver(window_seconds: i32) core.Error!f64
```

As `mspt`, over a window of `window_seconds`, from 1 to 60 and clipped by the host.

- Parameters:
    - window_seconds : `i32`
- Return type: `core.Error!f64`
- Slots: [`get_mspt`](../cpp/server.md#get_mspt)

### `server.setTickFreeze` {#server.setTickFreeze}

```zig
pub fn setTickFreeze(on: bool) core.Error!void
```

Freezes or unfreezes the world.

- Parameters:
    - on : `bool`
- Return type: `core.Error!void`
- Slots: [`tick_freeze`](../cpp/server.md#tick_freeze)

### `server.stepTicks` {#server.stepTicks}

```zig
pub fn stepTicks(n: u32) core.Error!void
```

Valid only while frozen: lets `n` more frames through.

- Parameters:
    - n : `u32`
- Return type: `core.Error!void`
- Slots: [`tick_step`](../cpp/server.md#tick_step)

### `server.setTickWarp` {#server.setTickWarp}

```zig
pub fn setTickWarp(factor: f64) core.Error!void
```

The time warp. `0 < factor <= 100`, below 1 is slow motion and 1.0 is normal.

- Parameters:
    - factor : `f64`
- Return type: `core.Error!void`
- Slots: [`tick_warp`](../cpp/server.md#tick_warp)

### `server.beginProfile` {#server.beginProfile}

```zig
pub fn beginProfile(ticks: u32) core.Error!void
```

Opens a sampling window of `ticks` frames, from 1 to 12000. Only one window at a time.

- Parameters:
    - ticks : `u32`
- Return type: `core.Error!void`
- Slots: [`profile_begin`](../cpp/server.md#profile_begin)

### `server.takeProfile` {#server.takeProfile}

```zig
pub fn takeProfile(allocator: Allocator) core.Error!?[]u8
```

Takes the sampling report as SNBT, owned by the caller; null while the window is still open or none was armed. The report is handed out once per window.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!?[]u8`
- Slots: [`profile_take`](../cpp/server.md#profile_take)

### `server.env` {#server.env}

```zig
pub fn env(allocator: Allocator, name: []const u8) core.Error![]u8
```

Reads an environment variable of this process, owned by the caller.

- Parameters:
    - allocator : `Allocator`
    - name : `[]const u8`
- Return type: `core.Error![]u8`
- Slots: [`sys_get_env`](../cpp/server.md#sys_get_env)

### `server.setEnv` {#server.setEnv}

```zig
pub fn setEnv(name: []const u8, value: []const u8) core.Error!void
```

Sets an environment variable. It affects this process only.

- Parameters:
    - name : `[]const u8`
    - value : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`sys_set_env`](../cpp/server.md#sys_set_env)

### `server.isWine` {#server.isWine}

```zig
pub fn isWine() core.Error!bool
```

Whether this host runs under Wine.

- Return type: `core.Error!bool`
- Slots: [`sys_is_wine`](../cpp/server.md#sys_is_wine)

### `server.protocolVersion` {#server.protocolVersion}

```zig
pub fn protocolVersion(allocator: Allocator) core.Error!u32
```

The network protocol version of the server, derived from the running build's game version.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!u32`

### `server.levelProtocolVersion` {#server.levelProtocolVersion}

```zig
pub fn levelProtocolVersion(allocator: Allocator) core.Error!u32
```

The protocol the level was last written by. It says how old the save is, not what the server speaks.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!u32`

### `server.processId` {#server.processId}

```zig
pub fn processId(allocator: Allocator) core.Error!u32
```

The id of the server process.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!u32`

### `server.worldStartCount` {#server.worldStartCount}

```zig
pub fn worldStartCount(allocator: Allocator) core.Error!u32
```

How many times the world has been opened.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!u32`

### `server.isHardcore` {#server.isHardcore}

```zig
pub fn isHardcore(allocator: Allocator) core.Error!bool
```

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!bool`

### `server.educationFeaturesEnabled` {#server.educationFeaturesEnabled}

```zig
pub fn educationFeaturesEnabled(allocator: Allocator) core.Error!bool
```

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!bool`

### `server.localTime` {#server.localTime}

```zig
pub fn localTime(allocator: Allocator) core.Error!types.LocalTime
```

The local time of the server.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.LocalTime`

### `server.listEvents` {#server.listEvents}

```zig
pub fn listEvents(allocator: Allocator) core.Error![][]u8
```

Every event id the host can currently resolve, each owned by the caller with the slice holding them; free them with `core.freeList`.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error![][]u8`
- Slots: [`list_events`](../cpp/events.md#list_events)

### `server.listPlayers` {#server.listPlayers}

```zig
pub fn listPlayers(allocator: Allocator) core.Error!types.Owned(PlayerInfo)
```

Every online player.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(PlayerInfo)`
- Slots: [`list_players`](../cpp/player.md#list_players)

### `server.listActors` {#server.listActors}

```zig
pub fn listActors(allocator: Allocator, dim: i32) core.Error!types.Owned(ActorEntry)
```

The live actors of a dimension; -1 lists every dimension.

- Parameters:
    - allocator : `Allocator`
    - dim : `i32`
- Return type: `core.Error!types.Owned(ActorEntry)`
- Slots: [`list_actors`](../cpp/entity.md#list_actors)

### `server.broadcast` {#server.broadcast}

```zig
pub fn broadcast(message: []const u8) core.Error!void
```

Sends a message to every online player.

- Parameters:
    - message : `[]const u8`
- Return type: `core.Error!void`
- Slots: [`broadcast_message`](../cpp/player.md#broadcast_message)

## `server.GamingStatus` {#server.GamingStatus}

```zig
pub const GamingStatus = enum(i32) {
    default = 0,
    starting = 1,
    running = 2,
    stopping = 3,
    _,
};
```

The run stage of the server, mirroring `ll::GamingStatus`.

## `server.PlayerInfo` {#server.PlayerInfo}

```zig
pub const PlayerInfo = struct {
    name: []const u8,
    xuid: []const u8,
    uuid: []const u8,
    dim: i32,
    x: f64,
    y: f64,
    z: f64,
    // ...
};
```

One online player.

## `server.ActorEntry` {#server.ActorEntry}

```zig
pub const ActorEntry = struct {
    id: i64,
    type_name: []const u8,
    // ...
};
```

One live actor of a listing.
