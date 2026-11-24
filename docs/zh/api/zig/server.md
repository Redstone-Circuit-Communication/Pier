# Zig：服务器、刻与系统信息

## 函数 {#functions}

### `props.srvBdsVersion` {#props.srvBdsVersion}

```zig
pub fn srvBdsVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_BDS_VERSION`：取自 `Common::getGameVersionString`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvProtocolVersion` {#props.srvProtocolVersion}

```zig
pub fn srvProtocolVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_PROTOCOL_VERSION`：`LevelData::mNetworkVersion`：最后一次写这个存档时用的协议版本。它说明存档有多旧，和服务器现在使用的协议无关。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvLevelProtocolVersion` {#props.srvLevelProtocolVersion}

```zig
pub fn srvLevelProtocolVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_LEVEL_PROTOCOL_VERSION`：正在运行的构建的版本号 `"major.minor.patch"`，取自 `CurrentGameSemVersion`。模组可以据此自带一张版本到协议的对照表，不必等 Pier 发新版。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvGameSemVersion` {#props.srvGameSemVersion}

```zig
pub fn srvGameSemVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_GAME_SEM_VERSION`：`PIER_SRV_GAME_SEM_VERSION`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvLoaderVersion` {#props.srvLoaderVersion}

```zig
pub fn srvLoaderVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_LOADER_VERSION`：`ll::getLoaderVersion`，正在运行的 LeviLamina 版本

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvLevelName` {#props.srvLevelName}

```zig
pub fn srvLevelName(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_LEVEL_NAME`：`LevelData::mLevelName`，世界名

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvIsHardcore` {#props.srvIsHardcore}

```zig
pub fn srvIsHardcore(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_IS_HARDCORE`：`LevelData::mIsHardcore`，"1" 或 "0"

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvWorldStartCount` {#props.srvWorldStartCount}

```zig
pub fn srvWorldStartCount(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_WORLD_START_COUNT`：`LevelData::mWorldStartCount`，世界被打开过的次数

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.srvEducationFeatures` {#props.srvEducationFeatures}

```zig
pub fn srvEducationFeatures(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SRV_EDUCATION_FEATURES`：`LevelData::mEducationFeaturesEnabled`，"1" 或 "0"

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `props.sysOsName` {#props.sysOsName}

```zig
pub fn sysOsName(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_OS_NAME`：取自 `sys_utils::getSystemName`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysOsVersion` {#props.sysOsVersion}

```zig
pub fn sysOsVersion(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_OS_VERSION`：取自 `sys_utils::getSystemVersion`，返回字符串

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysLocale` {#props.sysLocale}

```zig
pub fn sysLocale(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_LOCALE`：取自 `sys_utils::getSystemLocaleCode`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysLocalTime` {#props.sysLocalTime}

```zig
pub fn sysLocalTime(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_LOCAL_TIME`：取自 `sys_utils::getLocalTime`，返回 SNBT `{year,month,day,hour,minute,second,ms}`

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `props.sysProcessId` {#props.sysProcessId}

```zig
pub fn sysProcessId(allocator: std.mem.Allocator) core.Error![]u8
```

`PIER_SYS_PROCESS_ID`：服务端进程的 id

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `server.gamingStatus` {#server.gamingStatus}

```zig
pub fn gamingStatus() core.Error!GamingStatus
```

服务器处于哪个阶段。线程安全：任何线程都可以问。

- 返回值类型：`core.Error!GamingStatus`
- 对应槽位：[`gaming_status`](../cpp/core.md#gaming_status)

### `server.currentTick` {#server.currentTick}

```zig
pub fn currentTick() core.Error!u64
```

当前的服务器 tick。level 尚未就绪时为 `NoAnswer`。

- 返回值类型：`core.Error!u64`
- 对应槽位：[`get_current_tick`](../cpp/server.md#get_current_tick)

### `server.playerCount` {#server.playerCount}

```zig
pub fn playerCount() core.Error!i32
```

当前连接了多少名玩家。

- 返回值类型：`core.Error!i32`
- 对应槽位：[`get_player_count`](../cpp/server.md#get_player_count)

### `server.isSimPaused` {#server.isSimPaused}

```zig
pub fn isSimPaused() core.Error!bool
```

模拟是否暂停。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`get_sim_paused`](../cpp/server.md#get_sim_paused)

### `server.tickDeltaTime` {#server.tickDeltaTime}

```zig
pub fn tickDeltaTime() core.Error!f64
```

上一帧的挂钟周期，单位为秒。20 TPS 时是 0.05。

- 返回值类型：`core.Error!f64`
- 对应槽位：[`get_tick_delta_time`](../cpp/server.md#get_tick_delta_time)

### `server.tps` {#server.tps}

```zig
pub fn tps() core.Error!f64
```

最近 5 秒挂钟时间内的每秒 tick 数。

- 返回值类型：`core.Error!f64`
- 对应槽位：[`get_tps`](../cpp/server.md#get_tps)

### `server.tpsOver` {#server.tpsOver}

```zig
pub fn tpsOver(window_seconds: i32) core.Error!f64
```

同 `tps`，窗口为 `window_seconds` 秒，取值 1 到 60，超出时由宿主截断。

- 参数：
    - window_seconds : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`get_tps`](../cpp/server.md#get_tps)

### `server.mspt` {#server.mspt}

```zig
pub fn mspt() core.Error!f64
```

最近 5 秒内，每个 tick 平均花在计算上的毫秒数。

- 返回值类型：`core.Error!f64`
- 对应槽位：[`get_mspt`](../cpp/server.md#get_mspt)

### `server.msptOver` {#server.msptOver}

```zig
pub fn msptOver(window_seconds: i32) core.Error!f64
```

同 `mspt`，窗口为 `window_seconds` 秒，取值 1 到 60，超出时由宿主截断。

- 参数：
    - window_seconds : `i32`
- 返回值类型：`core.Error!f64`
- 对应槽位：[`get_mspt`](../cpp/server.md#get_mspt)

### `server.setTickFreeze` {#server.setTickFreeze}

```zig
pub fn setTickFreeze(on: bool) core.Error!void
```

冻结或解冻世界。

- 参数：
    - on : `bool`
- 返回值类型：`core.Error!void`
- 对应槽位：[`tick_freeze`](../cpp/server.md#tick_freeze)

### `server.stepTicks` {#server.stepTicks}

```zig
pub fn stepTicks(n: u32) core.Error!void
```

只在冻结时有效：再放过 `n` 帧。

- 参数：
    - n : `u32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`tick_step`](../cpp/server.md#tick_step)

### `server.setTickWarp` {#server.setTickWarp}

```zig
pub fn setTickWarp(factor: f64) core.Error!void
```

时间加速。`0 < factor <= 100`，小于 1 是慢动作，1.0 是正常速度。

- 参数：
    - factor : `f64`
- 返回值类型：`core.Error!void`
- 对应槽位：[`tick_warp`](../cpp/server.md#tick_warp)

### `server.beginProfile` {#server.beginProfile}

```zig
pub fn beginProfile(ticks: u32) core.Error!void
```

开启一个 `ticks` 帧的采样窗口，1 到 12000。同一时间只有一个窗口。

- 参数：
    - ticks : `u32`
- 返回值类型：`core.Error!void`
- 对应槽位：[`profile_begin`](../cpp/server.md#profile_begin)

### `server.takeProfile` {#server.takeProfile}

```zig
pub fn takeProfile(allocator: Allocator) core.Error!?[]u8
```

取出采样报告，SNBT 形式，由调用方持有；窗口还没结束或者根本没有开启采样时为 null。报告在每个窗口里只交出一次。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!?[]u8`
- 对应槽位：[`profile_take`](../cpp/server.md#profile_take)

### `server.env` {#server.env}

```zig
pub fn env(allocator: Allocator, name: []const u8) core.Error![]u8
```

读取这个进程的一个环境变量，由调用方持有。

- 参数：
    - allocator : `Allocator`
    - name : `[]const u8`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`sys_get_env`](../cpp/server.md#sys_get_env)

### `server.setEnv` {#server.setEnv}

```zig
pub fn setEnv(name: []const u8, value: []const u8) core.Error!void
```

设置一个环境变量。只影响这个进程。

- 参数：
    - name : `[]const u8`
    - value : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`sys_set_env`](../cpp/server.md#sys_set_env)

### `server.isWine` {#server.isWine}

```zig
pub fn isWine() core.Error!bool
```

这个宿主是否运行在 Wine 下。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`sys_is_wine`](../cpp/server.md#sys_is_wine)

### `server.protocolVersion` {#server.protocolVersion}

```zig
pub fn protocolVersion(allocator: Allocator) core.Error!u32
```

服务器的网络协议版本，由正在运行的构建的游戏版本推出。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!u32`

### `server.levelProtocolVersion` {#server.levelProtocolVersion}

```zig
pub fn levelProtocolVersion(allocator: Allocator) core.Error!u32
```

这个 level 上一次是用哪个协议写入的。它说明存档有多旧，和服务器现在使用什么协议无关。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!u32`

### `server.processId` {#server.processId}

```zig
pub fn processId(allocator: Allocator) core.Error!u32
```

服务端进程的 id。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!u32`

### `server.worldStartCount` {#server.worldStartCount}

```zig
pub fn worldStartCount(allocator: Allocator) core.Error!u32
```

这个世界被打开过的次数。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!u32`

### `server.isHardcore` {#server.isHardcore}

```zig
pub fn isHardcore(allocator: Allocator) core.Error!bool
```

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!bool`

### `server.educationFeaturesEnabled` {#server.educationFeaturesEnabled}

```zig
pub fn educationFeaturesEnabled(allocator: Allocator) core.Error!bool
```

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!bool`

### `server.localTime` {#server.localTime}

```zig
pub fn localTime(allocator: Allocator) core.Error!types.LocalTime
```

服务器的本地时间。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.LocalTime`

### `server.listEvents` {#server.listEvents}

```zig
pub fn listEvents(allocator: Allocator) core.Error![][]u8
```

宿主当前能解析的每个事件 id，每个都由调用方持有，切片也一样；用 `core.freeList` 释放。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error![][]u8`
- 对应槽位：[`list_events`](../cpp/events.md#list_events)

### `server.listPlayers` {#server.listPlayers}

```zig
pub fn listPlayers(allocator: Allocator) core.Error!types.Owned(PlayerInfo)
```

每名在线玩家。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(PlayerInfo)`
- 对应槽位：[`list_players`](../cpp/player.md#list_players)

### `server.listActors` {#server.listActors}

```zig
pub fn listActors(allocator: Allocator, dim: i32) core.Error!types.Owned(ActorEntry)
```

一个维度里的存活实体；传 -1 列出所有维度。

- 参数：
    - allocator : `Allocator`
    - dim : `i32`
- 返回值类型：`core.Error!types.Owned(ActorEntry)`
- 对应槽位：[`list_actors`](../cpp/entity.md#list_actors)

### `server.broadcast` {#server.broadcast}

```zig
pub fn broadcast(message: []const u8) core.Error!void
```

向每名在线玩家发送一条消息。

- 参数：
    - message : `[]const u8`
- 返回值类型：`core.Error!void`
- 对应槽位：[`broadcast_message`](../cpp/player.md#broadcast_message)

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

服务器的运行阶段，对应 `ll::GamingStatus`。

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

一名在线玩家。

## `server.ActorEntry` {#server.ActorEntry}

```zig
pub const ActorEntry = struct {
    id: i64,
    type_name: []const u8,
    // ...
};
```

一次列举中的一个存活实体。
