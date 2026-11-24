# Go：服务器、刻与系统信息

## 函数 {#functions}

### `CurrentTick` {#CurrentTick}

```go
func CurrentTick() (uint64, error)
```

服务器的刻计数器。

- 返回值类型：`(uint64, error)`
- 对应槽位：[`get_current_tick`](../cpp/server.md#get_current_tick)

### `TickDeltaTime` {#TickDeltaTime}

```go
func TickDeltaTime() (float64, error)
```

上一刻的长度，单位是秒。

- 返回值类型：`(float64, error)`
- 对应槽位：[`get_tick_delta_time`](../cpp/server.md#get_tick_delta_time)

### `PlayerCount` {#PlayerCount}

```go
func PlayerCount() (int32, error)
```

在线的玩家数。

- 返回值类型：`(int32, error)`
- 对应槽位：[`get_player_count`](../cpp/server.md#get_player_count)

### `SimPaused` {#SimPaused}

```go
func SimPaused() (bool, error)
```

判断模拟是否暂停。

- 返回值类型：`(bool, error)`
- 对应槽位：[`get_sim_paused`](../cpp/server.md#get_sim_paused)

### `Tps` {#Tps}

```go
func Tps(windowSeconds int32) (float64, error)
```

最近 `windowSeconds` 秒里每秒的刻数。宿主还没有测量到任何东西时会给出负数，这时返回错误，不把它当作速率。

- 参数：
    - windowSeconds : `int32`
- 返回值类型：`(float64, error)`
- 对应槽位：[`get_tps`](../cpp/server.md#get_tps)

### `Mspt` {#Mspt}

```go
func Mspt(windowSeconds int32) (float64, error)
```

最近 `windowSeconds` 秒里每刻的毫秒数，规则和 `Tps` 一样。

- 参数：
    - windowSeconds : `int32`
- 返回值类型：`(float64, error)`
- 对应槽位：[`get_mspt`](../cpp/server.md#get_mspt)

### `Env` {#Env}

```go
func Env(name string) (string, error)
```

读取服务器进程的一个环境变量。

- 参数：
    - name : `string`
- 返回值类型：`(string, error)`
- 对应槽位：[`sys_get_env`](../cpp/server.md#sys_get_env)

### `SetEnv` {#SetEnv}

```go
func SetEnv(name, value string) error
```

设置服务器进程的一个环境变量。

- 参数：
    - name : `string`
    - value : `string`
- 返回值类型：`error`
- 对应槽位：[`sys_set_env`](../cpp/server.md#sys_set_env)

### `SetTickFreeze` {#SetTickFreeze}

```go
func SetTickFreeze(on bool) error
```

SetTickFreeze 冻结或解冻世界。

- 参数：
    - on : `bool`
- 返回值类型：`error`
- 对应槽位：[`tick_freeze`](../cpp/server.md#tick_freeze)

### `StepTicks` {#StepTicks}

```go
func StepTicks(n uint32) error
```

StepTicks 在世界被冻结时多放行 n 帧。

- 参数：
    - n : `uint32`
- 返回值类型：`error`
- 对应槽位：[`tick_step`](../cpp/server.md#tick_step)

### `SetTickWarp` {#SetTickWarp}

```go
func SetTickWarp(factor float64) error
```

SetTickWarp 设置时间扭曲：0 < factor <= 100，小于 1 是慢动作，1 是正常速度。

- 参数：
    - factor : `float64`
- 返回值类型：`error`
- 对应槽位：[`tick_warp`](../cpp/server.md#tick_warp)

### `BeginProfile` {#BeginProfile}

```go
func BeginProfile(ticks uint32) error
```

BeginProfile 打开一个 ticks 帧的采样窗口，取值 1 到 12000。同一时间只能开一个窗口。

- 参数：
    - ticks : `uint32`
- 返回值类型：`error`
- 对应槽位：[`profile_begin`](../cpp/server.md#profile_begin)

### `TakeProfile` {#TakeProfile}

```go
func TakeProfile() (report string, ready bool, err error)
```

TakeProfile 取出采样报告，SNBT 形式。窗口还没结束、或根本没有开启采样时 ready 为 false。报告在每个窗口里只交出一次。

- 返回值类型：`(report string, ready bool, err error)`
- 对应槽位：[`profile_take`](../cpp/server.md#profile_take)

### `IsWine` {#IsWine}

```go
func IsWine() (bool, error)
```

IsWine 报告这个宿主是否运行在 Wine 下。

- 返回值类型：`(bool, error)`
- 对应槽位：[`sys_is_wine`](../cpp/server.md#sys_is_wine)

### `ServerBdsVersion` {#ServerBdsVersion}

```go
func ServerBdsVersion() (string, error)
```

读取 `PIER_SRV_BDS_VERSION`：取自 `Common::getGameVersionString`

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerProtocolVersion` {#ServerProtocolVersion}

```go
func ServerProtocolVersion() (string, error)
```

读取 `PIER_SRV_PROTOCOL_VERSION`：`LevelData::mNetworkVersion`：最后一次写这个存档时用的协议版本。它说明存档有多旧，和服务器现在使用的协议无关。

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerLevelProtocolVersion` {#ServerLevelProtocolVersion}

```go
func ServerLevelProtocolVersion() (string, error)
```

读取 `PIER_SRV_LEVEL_PROTOCOL_VERSION`：正在运行的构建的版本号 `"major.minor.patch"`，取自 `CurrentGameSemVersion`。模组可以据此自带一张版本到协议的对照表，不必等 Pier 发新版。

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerGameSemVersion` {#ServerGameSemVersion}

```go
func ServerGameSemVersion() (string, error)
```

读取 `PIER_SRV_GAME_SEM_VERSION`：`PIER_SRV_GAME_SEM_VERSION`

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerLoaderVersion` {#ServerLoaderVersion}

```go
func ServerLoaderVersion() (string, error)
```

读取 `PIER_SRV_LOADER_VERSION`：`ll::getLoaderVersion`，正在运行的 LeviLamina 版本

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerLevelName` {#ServerLevelName}

```go
func ServerLevelName() (string, error)
```

读取 `PIER_SRV_LEVEL_NAME`：`LevelData::mLevelName`，世界名

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerIsHardcore` {#ServerIsHardcore}

```go
func ServerIsHardcore() (string, error)
```

读取 `PIER_SRV_IS_HARDCORE`：`LevelData::mIsHardcore`，"1" 或 "0"

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerWorldStartCount` {#ServerWorldStartCount}

```go
func ServerWorldStartCount() (string, error)
```

读取 `PIER_SRV_WORLD_START_COUNT`：`LevelData::mWorldStartCount`，世界被打开过的次数

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `ServerEducationFeatures` {#ServerEducationFeatures}

```go
func ServerEducationFeatures() (string, error)
```

读取 `PIER_SRV_EDUCATION_FEATURES`：`LevelData::mEducationFeaturesEnabled`，"1" 或 "0"

- 返回值类型：`(string, error)`
- 对应槽位：[`server_info_str`](../cpp/server.md#server_info_str)

### `SystemOsName` {#SystemOsName}

```go
func SystemOsName() (string, error)
```

读取 `PIER_SYS_OS_NAME`：取自 `sys_utils::getSystemName`

- 返回值类型：`(string, error)`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemOsVersion` {#SystemOsVersion}

```go
func SystemOsVersion() (string, error)
```

读取 `PIER_SYS_OS_VERSION`：取自 `sys_utils::getSystemVersion`，返回字符串

- 返回值类型：`(string, error)`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemLocale` {#SystemLocale}

```go
func SystemLocale() (string, error)
```

读取 `PIER_SYS_LOCALE`：取自 `sys_utils::getSystemLocaleCode`

- 返回值类型：`(string, error)`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemLocalTime` {#SystemLocalTime}

```go
func SystemLocalTime() (string, error)
```

读取 `PIER_SYS_LOCAL_TIME`：取自 `sys_utils::getLocalTime`，返回 SNBT `{year,month,day,hour,minute,second,ms}`

- 返回值类型：`(string, error)`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemProcessId` {#SystemProcessId}

```go
func SystemProcessId() (string, error)
```

读取 `PIER_SYS_PROCESS_ID`：服务端进程的 id

- 返回值类型：`(string, error)`
- 对应槽位：[`sys_info_str`](../cpp/server.md#sys_info_str)

## `Srv*` {#Srv}

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="SrvBdsVersion"></span>`SrvBdsVersion` | `0` | 即 `PIER_SRV_BDS_VERSION`：取自 `Common::getGameVersionString` |
| <span id="SrvProtocolVersion"></span>`SrvProtocolVersion` | `1` | 即 `PIER_SRV_PROTOCOL_VERSION`：`LevelData::mNetworkVersion`：最后一次写这个存档时用的协议版本。它说明存档有多旧，和服务器现在使用的协议无关。 |
| <span id="SrvLevelProtocolVersion"></span>`SrvLevelProtocolVersion` | `2` | 即 `PIER_SRV_LEVEL_PROTOCOL_VERSION`：正在运行的构建的版本号 `"major.minor.patch"`，取自 `CurrentGameSemVersion`。模组可以据此自带一张版本到协议的对照表，不必等 Pier 发新版。 |
| <span id="SrvGameSemVersion"></span>`SrvGameSemVersion` | `3` | 即 `PIER_SRV_GAME_SEM_VERSION`：`PIER_SRV_GAME_SEM_VERSION` |
| <span id="SrvLoaderVersion"></span>`SrvLoaderVersion` | `4` | 即 `PIER_SRV_LOADER_VERSION`：`ll::getLoaderVersion`，正在运行的 LeviLamina 版本 |
| <span id="SrvLevelName"></span>`SrvLevelName` | `5` | 即 `PIER_SRV_LEVEL_NAME`：`LevelData::mLevelName`，世界名 |
| <span id="SrvIsHardcore"></span>`SrvIsHardcore` | `6` | 即 `PIER_SRV_IS_HARDCORE`：`LevelData::mIsHardcore`，"1" 或 "0" |
| <span id="SrvWorldStartCount"></span>`SrvWorldStartCount` | `7` | 即 `PIER_SRV_WORLD_START_COUNT`：`LevelData::mWorldStartCount`，世界被打开过的次数 |
| <span id="SrvEducationFeatures"></span>`SrvEducationFeatures` | `8` | 即 `PIER_SRV_EDUCATION_FEATURES`：`LevelData::mEducationFeaturesEnabled`，"1" 或 "0" |

## `Sys*` {#Sys}

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="SysOsName"></span>`SysOsName` | `0` | 即 `PIER_SYS_OS_NAME`：取自 `sys_utils::getSystemName` |
| <span id="SysOsVersion"></span>`SysOsVersion` | `1` | 即 `PIER_SYS_OS_VERSION`：取自 `sys_utils::getSystemVersion`，返回字符串 |
| <span id="SysLocale"></span>`SysLocale` | `2` | 即 `PIER_SYS_LOCALE`：取自 `sys_utils::getSystemLocaleCode` |
| <span id="SysLocalTime"></span>`SysLocalTime` | `3` | 即 `PIER_SYS_LOCAL_TIME`：取自 `sys_utils::getLocalTime`，返回 SNBT `{year,month,day,hour,minute,second,ms}` |
| <span id="SysProcessId"></span>`SysProcessId` | `4` | 即 `PIER_SYS_PROCESS_ID`：服务端进程的 id |
