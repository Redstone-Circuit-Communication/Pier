# Go：原生逃生口

## 函数 {#functions}

### `NativeEnabledNow` {#NativeEnabledNow}

```go
func NativeEnabledNow() bool
```

NativeEnabledNow 报告宿主是否响应原生调用，由它的 config.json 决定。

- 返回值类型：`bool`

### `NativeSymbol` {#NativeSymbol}

```go
func NativeSymbol(symbol string) (unsafe.Pointer, error)
```

NativeSymbol 是按修饰后的符号名找到的引擎函数地址。

- 参数：
    - symbol : `string`
- 返回值类型：`(unsafe.Pointer, error)`

### `NativeSignature` {#NativeSignature}

```go
func NativeSignature(pattern string) (unsafe.Pointer, error)
```

NativeSignature 是字节特征码（例如 "48 8B ?? 08"）在引擎可执行文件中的第一个匹配。

- 参数：
    - pattern : `string`
- 返回值类型：`(unsafe.Pointer, error)`

### `NativeExport` {#NativeExport}

```go
func NativeExport(module, name string) (unsafe.Pointer, error)
```

NativeExport 是进程中已加载模块的一个导出；module 为空表示引擎可执行文件。LeviLamina 的 API 是 LeviLamina.dll 的导出。

- 参数：
    - module : `string`
    - name : `string`
- 返回值类型：`(unsafe.Pointer, error)`

### `NativeObjectOf` {#NativeObjectOf}

```go
func NativeObjectOf(kind NativeObjectKind) (unsafe.Pointer, error)
```

NativeObjectOf 是一个引擎服务对象的地址。

- 参数：
    - kind : `NativeObjectKind`
- 返回值类型：`(unsafe.Pointer, error)`

### `NativePlayerOf` {#NativePlayerOf}

```go
func NativePlayerOf(p Player) (unsafe.Pointer, error)
```

NativePlayerOf 是在线玩家对应的引擎 Player 对象，玩家在线期间有效。

- 参数：
    - p : `Player`
- 返回值类型：`(unsafe.Pointer, error)`

### `NativeActorOf` {#NativeActorOf}

```go
func NativeActorOf(id ActorID) (unsafe.Pointer, error)
```

NativeActorOf 是已加载实体对应的引擎 Actor 对象。

- 参数：
    - id : `ActorID`
- 返回值类型：`(unsafe.Pointer, error)`

### `NativeDimensionOf` {#NativeDimensionOf}

```go
func NativeDimensionOf(dim int32) (unsafe.Pointer, error)
```

NativeDimensionOf 是维度 id 对应的引擎 Dimension 对象。

- 参数：
    - dim : `int32`
- 返回值类型：`(unsafe.Pointer, error)`

### `NativeBlockSourceOf` {#NativeBlockSourceOf}

```go
func NativeBlockSourceOf(dim int32) (unsafe.Pointer, error)
```

NativeBlockSourceOf 是维度 id 对应的引擎 BlockSource。

- 参数：
    - dim : `int32`
- 返回值类型：`(unsafe.Pointer, error)`

### `InstallNativeHook` {#InstallNativeHook}

```go
func InstallNativeHook(target, detour unsafe.Pointer, priority int32) (NativeHook, error)
```

InstallNativeHook 以一个 HookPriority 值在 target 上安装 detour。detour 必须是与 target 签名和调用约定完全一致的 C 函数，并且只能通过 Original 调用引擎。模组卸载时，宿主会移除它仍持有的 detour，已经在其他线程上进入 detour 的调用不会被等待。

- 参数：
    - target : `unsafe.Pointer`
    - detour : `unsafe.Pointer`
    - priority : `int32`
- 返回值类型：`(NativeHook, error)`

### `RemoveNativeHook` {#RemoveNativeHook}

```go
func RemoveNativeHook(h NativeHook) error
```

RemoveNativeHook 移除这个模组安装的一个 detour。

- 参数：
    - h : `NativeHook`
- 返回值类型：`error`

## `NativeError` {#NativeError}

```go
type NativeError struct {
    Op   string
    Code int32
}
```

NativeError 是原生槽位返回 PIER_NATIVE_OK 以外的结果时的错误。

### `NativeError.Disabled` {#NativeError.Disabled}

```go
func (e *NativeError) Disabled() bool
```

Disabled 报告宿主的 config.json 是否没有打开 native_detour。

- 返回值类型：`bool`

### `NativeError.Error` {#NativeError.Error}

```go
func (e *NativeError) Error() string
```

- 返回值类型：`string`

## `NativeObjectKind` {#NativeObjectKind}

```go
type NativeObjectKind int32
```

NativeObjectKind 为 NativeObjectOf 指定一个引擎服务对象。

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="NativeMinecraft"></span>`NativeMinecraft` | `C.PIER_NATIVE_OBJ_MINECRAFT` |  |
| <span id="NativeLevel"></span>`NativeLevel` | `C.PIER_NATIVE_OBJ_LEVEL` |  |
| <span id="NativeServerNetworkHandler"></span>`NativeServerNetworkHandler` | `C.PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER` |  |
| <span id="NativeServerInstance"></span>`NativeServerInstance` | `C.PIER_NATIVE_OBJ_SERVER_INSTANCE` |  |
| <span id="NativeCommandRegistry"></span>`NativeCommandRegistry` | `C.PIER_NATIVE_OBJ_COMMAND_REGISTRY` |  |
| <span id="NativeNetworkSystem"></span>`NativeNetworkSystem` | `C.PIER_NATIVE_OBJ_NETWORK_SYSTEM` |  |
| <span id="NativeDBStorage"></span>`NativeDBStorage` | `C.PIER_NATIVE_OBJ_DB_STORAGE` |  |
| <span id="NativeClientInstance"></span>`NativeClientInstance` | `C.PIER_NATIVE_OBJ_CLIENT_INSTANCE` |  |
| <span id="NativeMultiPlayerLevel"></span>`NativeMultiPlayerLevel` | `C.PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL` |  |

## `NativeHook` {#NativeHook}

```go
type NativeHook struct {
    ID       uint64
    Original unsafe.Pointer
}
```

NativeHook 是一个已安装的 detour：RemoveNativeHook 使用的 id，以及 detour 用来调用下一个 detour 或引擎的地址。

## `HookPriority*` {#HookPriority-values}

ll::memory::HookPriority 的各个优先级，供 InstallNativeHook 使用。

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="HookPriorityHighest"></span>`HookPriorityHighest` | `0` |  |
| <span id="HookPriorityHigh"></span>`HookPriorityHigh` | `100` |  |
| <span id="HookPriorityNormal"></span>`HookPriorityNormal` | `200` |  |
| <span id="HookPriorityLow"></span>`HookPriorityLow` | `300` |  |
| <span id="HookPriorityLowest"></span>`HookPriorityLowest` | `400` |  |
