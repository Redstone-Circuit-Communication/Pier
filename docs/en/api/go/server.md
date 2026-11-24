# Go: Server, ticks and system information

## Functions {#functions}

### `CurrentTick` {#CurrentTick}

```go
func CurrentTick() (uint64, error)
```

CurrentTick is the server's tick counter.

- Return type: `(uint64, error)`
- Slots: [`get_current_tick`](../cpp/server.md#get_current_tick)

### `TickDeltaTime` {#TickDeltaTime}

```go
func TickDeltaTime() (float64, error)
```

TickDeltaTime is the length of the last tick, in seconds.

- Return type: `(float64, error)`
- Slots: [`get_tick_delta_time`](../cpp/server.md#get_tick_delta_time)

### `PlayerCount` {#PlayerCount}

```go
func PlayerCount() (int32, error)
```

PlayerCount is how many players are online.

- Return type: `(int32, error)`
- Slots: [`get_player_count`](../cpp/server.md#get_player_count)

### `SimPaused` {#SimPaused}

```go
func SimPaused() (bool, error)
```

SimPaused reports whether the simulation is paused.

- Return type: `(bool, error)`
- Slots: [`get_sim_paused`](../cpp/server.md#get_sim_paused)

### `Tps` {#Tps}

```go
func Tps(windowSeconds int32) (float64, error)
```

Tps is the ticks per second over the last windowSeconds. A negative answer, which the host gives before it has measured anything, is an error and not a rate.

- Parameters:
    - windowSeconds : `int32`
- Return type: `(float64, error)`
- Slots: [`get_tps`](../cpp/server.md#get_tps)

### `Mspt` {#Mspt}

```go
func Mspt(windowSeconds int32) (float64, error)
```

Mspt is the milliseconds per tick over the last windowSeconds, with Tps's rule.

- Parameters:
    - windowSeconds : `int32`
- Return type: `(float64, error)`
- Slots: [`get_mspt`](../cpp/server.md#get_mspt)

### `Env` {#Env}

```go
func Env(name string) (string, error)
```

Env reads an environment variable of the server process.

- Parameters:
    - name : `string`
- Return type: `(string, error)`
- Slots: [`sys_get_env`](../cpp/server.md#sys_get_env)

### `SetEnv` {#SetEnv}

```go
func SetEnv(name, value string) error
```

SetEnv sets an environment variable of the server process.

- Parameters:
    - name : `string`
    - value : `string`
- Return type: `error`
- Slots: [`sys_set_env`](../cpp/server.md#sys_set_env)

### `SetTickFreeze` {#SetTickFreeze}

```go
func SetTickFreeze(on bool) error
```

SetTickFreeze freezes or unfreezes the world.

- Parameters:
    - on : `bool`
- Return type: `error`
- Slots: [`tick_freeze`](../cpp/server.md#tick_freeze)

### `StepTicks` {#StepTicks}

```go
func StepTicks(n uint32) error
```

StepTicks lets n more frames through while the world is frozen.

- Parameters:
    - n : `uint32`
- Return type: `error`
- Slots: [`tick_step`](../cpp/server.md#tick_step)

### `SetTickWarp` {#SetTickWarp}

```go
func SetTickWarp(factor float64) error
```

SetTickWarp sets the time warp: 0 &lt; factor &lt;= 100, below 1 is slow motion and 1 is normal.

- Parameters:
    - factor : `float64`
- Return type: `error`
- Slots: [`tick_warp`](../cpp/server.md#tick_warp)

### `BeginProfile` {#BeginProfile}

```go
func BeginProfile(ticks uint32) error
```

BeginProfile opens a sampling window of ticks frames, from 1 to 12000. Only one window is open at a time.

- Parameters:
    - ticks : `uint32`
- Return type: `error`
- Slots: [`profile_begin`](../cpp/server.md#profile_begin)

### `TakeProfile` {#TakeProfile}

```go
func TakeProfile() (report string, ready bool, err error)
```

TakeProfile takes the sampling report as SNBT. ready is false while the window is still open or none was armed. The report is handed out once per window.

- Return type: `(report string, ready bool, err error)`
- Slots: [`profile_take`](../cpp/server.md#profile_take)

### `IsWine` {#IsWine}

```go
func IsWine() (bool, error)
```

IsWine reports whether this host runs under Wine.

- Return type: `(bool, error)`
- Slots: [`sys_is_wine`](../cpp/server.md#sys_is_wine)

### `ServerBdsVersion` {#ServerBdsVersion}

```go
func ServerBdsVersion() (string, error)
```

ServerBdsVersion reads `PIER_SRV_BDS_VERSION`: `Common::getGameVersionString`

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerProtocolVersion` {#ServerProtocolVersion}

```go
func ServerProtocolVersion() (string, error)
```

ServerProtocolVersion reads `PIER_SRV_PROTOCOL_VERSION`: `LevelData::mNetworkVersion`: the protocol the level was last written by. Says how old the save is, not what the server speaks.

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerLevelProtocolVersion` {#ServerLevelProtocolVersion}

```go
func ServerLevelProtocolVersion() (string, error)
```

ServerLevelProtocolVersion reads `PIER_SRV_LEVEL_PROTOCOL_VERSION`: "major.minor.patch" of the running build, from CurrentGameSemVersion. Lets a mod carry its own version→protocol table instead of waiting for a Pier release.

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerGameSemVersion` {#ServerGameSemVersion}

```go
func ServerGameSemVersion() (string, error)
```

ServerGameSemVersion reads `PIER_SRV_GAME_SEM_VERSION`: `PIER_SRV_GAME_SEM_VERSION`

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerLoaderVersion` {#ServerLoaderVersion}

```go
func ServerLoaderVersion() (string, error)
```

ServerLoaderVersion reads `PIER_SRV_LOADER_VERSION`: `ll::getLoaderVersion`, the running LeviLamina

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerLevelName` {#ServerLevelName}

```go
func ServerLevelName() (string, error)
```

ServerLevelName reads `PIER_SRV_LEVEL_NAME`: `LevelData::mLevelName`, the world name

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerIsHardcore` {#ServerIsHardcore}

```go
func ServerIsHardcore() (string, error)
```

ServerIsHardcore reads `PIER_SRV_IS_HARDCORE`: `LevelData::mIsHardcore`, "1" or "0"

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerWorldStartCount` {#ServerWorldStartCount}

```go
func ServerWorldStartCount() (string, error)
```

ServerWorldStartCount reads `PIER_SRV_WORLD_START_COUNT`: `LevelData::mWorldStartCount`, how many times the world was opened

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `ServerEducationFeatures` {#ServerEducationFeatures}

```go
func ServerEducationFeatures() (string, error)
```

ServerEducationFeatures reads `PIER_SRV_EDUCATION_FEATURES`: `LevelData::mEducationFeaturesEnabled`, "1" or "0"

- Return type: `(string, error)`
- Slots: [`server_info_str`](../cpp/server.md#server_info_str)

### `SystemOsName` {#SystemOsName}

```go
func SystemOsName() (string, error)
```

SystemOsName reads `PIER_SYS_OS_NAME`: `sys_utils::getSystemName`

- Return type: `(string, error)`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemOsVersion` {#SystemOsVersion}

```go
func SystemOsVersion() (string, error)
```

SystemOsVersion reads `PIER_SYS_OS_VERSION`: `sys_utils::getSystemVersion` → string

- Return type: `(string, error)`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemLocale` {#SystemLocale}

```go
func SystemLocale() (string, error)
```

SystemLocale reads `PIER_SYS_LOCALE`: `sys_utils::getSystemLocaleCode`

- Return type: `(string, error)`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemLocalTime` {#SystemLocalTime}

```go
func SystemLocalTime() (string, error)
```

SystemLocalTime reads `PIER_SYS_LOCAL_TIME`: `sys_utils::getLocalTime` → SNBT {year,month,day,hour,minute,second,ms}

- Return type: `(string, error)`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

### `SystemProcessId` {#SystemProcessId}

```go
func SystemProcessId() (string, error)
```

SystemProcessId reads `PIER_SYS_PROCESS_ID`: the id of the server process

- Return type: `(string, error)`
- Slots: [`sys_info_str`](../cpp/server.md#sys_info_str)

## `Srv*` {#Srv}

| Name | Value | Description |
|---|---|---|
| <span id="SrvBdsVersion"></span>`SrvBdsVersion` | `0` | SrvBdsVersion is `PIER_SRV_BDS_VERSION`: `Common::getGameVersionString` |
| <span id="SrvProtocolVersion"></span>`SrvProtocolVersion` | `1` | SrvProtocolVersion is `PIER_SRV_PROTOCOL_VERSION`: `LevelData::mNetworkVersion`: the protocol the level was last written by. Says how old the save is, not what the server speaks. |
| <span id="SrvLevelProtocolVersion"></span>`SrvLevelProtocolVersion` | `2` | SrvLevelProtocolVersion is `PIER_SRV_LEVEL_PROTOCOL_VERSION`: "major.minor.patch" of the running build, from CurrentGameSemVersion. Lets a mod carry its own version→protocol table instead of waiting for a Pier release. |
| <span id="SrvGameSemVersion"></span>`SrvGameSemVersion` | `3` | SrvGameSemVersion is `PIER_SRV_GAME_SEM_VERSION`: `PIER_SRV_GAME_SEM_VERSION` |
| <span id="SrvLoaderVersion"></span>`SrvLoaderVersion` | `4` | SrvLoaderVersion is `PIER_SRV_LOADER_VERSION`: `ll::getLoaderVersion`, the running LeviLamina |
| <span id="SrvLevelName"></span>`SrvLevelName` | `5` | SrvLevelName is `PIER_SRV_LEVEL_NAME`: `LevelData::mLevelName`, the world name |
| <span id="SrvIsHardcore"></span>`SrvIsHardcore` | `6` | SrvIsHardcore is `PIER_SRV_IS_HARDCORE`: `LevelData::mIsHardcore`, "1" or "0" |
| <span id="SrvWorldStartCount"></span>`SrvWorldStartCount` | `7` | SrvWorldStartCount is `PIER_SRV_WORLD_START_COUNT`: `LevelData::mWorldStartCount`, how many times the world was opened |
| <span id="SrvEducationFeatures"></span>`SrvEducationFeatures` | `8` | SrvEducationFeatures is `PIER_SRV_EDUCATION_FEATURES`: `LevelData::mEducationFeaturesEnabled`, "1" or "0" |

## `Sys*` {#Sys}

| Name | Value | Description |
|---|---|---|
| <span id="SysOsName"></span>`SysOsName` | `0` | SysOsName is `PIER_SYS_OS_NAME`: `sys_utils::getSystemName` |
| <span id="SysOsVersion"></span>`SysOsVersion` | `1` | SysOsVersion is `PIER_SYS_OS_VERSION`: `sys_utils::getSystemVersion` → string |
| <span id="SysLocale"></span>`SysLocale` | `2` | SysLocale is `PIER_SYS_LOCALE`: `sys_utils::getSystemLocaleCode` |
| <span id="SysLocalTime"></span>`SysLocalTime` | `3` | SysLocalTime is `PIER_SYS_LOCAL_TIME`: `sys_utils::getLocalTime` → SNBT {year,month,day,hour,minute,second,ms} |
| <span id="SysProcessId"></span>`SysProcessId` | `4` | SysProcessId is `PIER_SYS_PROCESS_ID`: the id of the server process |
