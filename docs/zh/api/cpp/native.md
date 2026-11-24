# 原生逃生口

??? note "abi.h 里的分节说明"

    **原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）**

    每个宿主都会填充这一组。config.json 没有打开 native_detour 时，除 native_enabled 外的每个槽位都返回 PIER_NATIVE_DISABLED。请在宿主调用模组的那个线程上调用它们：服务端线程，或者客户端宿主上的客户端线程。每个 `out` 都会先被置为 NULL 或 0，只有返回 PIER_NATIVE_OK 时才写入结果。

## 槽位 {#slots}

### `native_enabled` {#native_enabled}

```c
bool (*native_enabled)(void);
```

native_detour 是否打开，即其他 native_* 槽位能否响应。不写日志。

- 调用形式：`api->native_enabled()`
- 返回值类型：`bool`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 206 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::enabled`](../rust/native.md#fn.enabled)、[`native::enabled`](../rust/native.md#fn.enabled)
    - Go：[`Raw.NativeEnabled`](../go/raw.md#Raw.NativeEnabled)
    - Zig：[`native.enabled`](../zig/native.md#native.enabled)

### `native_resolve_symbol` {#native_resolve_symbol}

```c
int32_t (*native_resolve_symbol)(PierModHandle mod, PierStr symbol, void** out);
```

按修饰后的符号名得到一个引擎函数的地址，使用宿主自己的解析，即 ll::memory::SymbolView::resolve。

- 调用形式：`api->native_resolve_symbol(mod, symbol, out)`
- 参数：
    - mod : `PierModHandle`
    - symbol : `PierStr`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 207 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::resolve_symbol`](../rust/native.md#fn.resolve_symbol)
    - Go：[`Raw.NativeResolveSymbol`](../go/raw.md#Raw.NativeResolveSymbol)
    - Zig：[`native.resolveSymbol`](../zig/native.md#native.resolveSymbol)

### `native_resolve_signature` {#native_resolve_signature}

```c
int32_t (*native_resolve_signature)(PierModHandle mod, PierStr pattern, void** out);
```

字节特征码在引擎可执行文件中的第一个匹配。`pattern` 是用空格分隔的记号，每个记号是两位十六进制数，或者写作 "?" 或 "??" 的通配符，例如 "48 8B ?? 08"。出现其他形状的记号时拒绝调用，绝不会把它当作一个字节来读。

- 调用形式：`api->native_resolve_signature(mod, pattern, out)`
- 参数：
    - mod : `PierModHandle`
    - pattern : `PierStr`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 208 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::resolve_signature`](../rust/native.md#fn.resolve_signature)
    - Go：[`Raw.NativeResolveSignature`](../go/raw.md#Raw.NativeResolveSignature)
    - Zig：[`native.resolveSignature`](../zig/native.md#native.resolveSignature)

### `native_module_export` {#native_module_export}

```c
int32_t (*native_module_export)(PierModHandle mod, PierStr module, PierStr name,
                                void** out);
```

进程中已加载模块的一个导出，通过 GetModuleHandle 和 GetProcAddress 取得。`module` 为空表示引擎可执行文件。LeviLamina 自身的 API 就通过这种方式取得，它是 LeviLamina.dll 以修饰名导出的符号。这个调用绝不会让宿主加载模块。

- 调用形式：`api->native_module_export(mod, module, name, out)`
- 参数：
    - mod : `PierModHandle`
    - module : `PierStr`
    - name : `PierStr`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 209 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::module_export`](../rust/native.md#fn.module_export)
    - Go：[`Raw.NativeModuleExport`](../go/raw.md#Raw.NativeModuleExport)
    - Zig：[`native.moduleExport`](../zig/native.md#native.moduleExport)

### `native_object` {#native_object}

```c
int32_t (*native_object)(PierModHandle mod, int32_t kind, void** out);
```

一个引擎服务对象的地址，`kind` 取 PIER_NATIVE_OBJ_* 之一。对象不存在时（例如世界加载前的 level），以及在服务端宿主上请求仅客户端的种类时，返回 PIER_NATIVE_NOT_FOUND。

- 调用形式：`api->native_object(mod, kind, out)`
- 参数：
    - mod : `PierModHandle`
    - kind : `int32_t`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 210 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::object`](../rust/native.md#fn.object)
    - Go：[`Raw.NativeObject`](../go/raw.md#Raw.NativeObject)
    - Zig：[`native.object`](../zig/native.md#native.object)

### `native_player` {#native_player}

```c
int32_t (*native_player)(PierModHandle mod, PierPlayerSel sel, void** out);
```

在线玩家的 Player 对象，解析方式和其他选择器相同。

- 调用形式：`api->native_player(mod, sel, out)`
- 参数：
    - mod : `PierModHandle`
    - sel : `PierPlayerSel`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 211 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::player`](../rust/native.md#fn.player)
    - Go：[`Raw.NativePlayer`](../go/raw.md#Raw.NativePlayer)
    - Zig：[`native.player`](../zig/native.md#native.player)

### `native_actor` {#native_actor}

```c
int32_t (*native_actor)(PierModHandle mod, PierActorId id, void** out);
```

已加载实体的 Actor 对象。

- 调用形式：`api->native_actor(mod, id, out)`
- 参数：
    - mod : `PierModHandle`
    - id : `PierActorId`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 212 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::actor`](../rust/native.md#fn.actor)
    - Go：[`Raw.NativeActor`](../go/raw.md#Raw.NativeActor)
    - Zig：[`native.actor`](../zig/native.md#native.actor)

### `native_dimension` {#native_dimension}

```c
int32_t (*native_dimension)(PierModHandle mod, int32_t dim, void** out);
```

维度 id 对应的 Dimension 对象，包括自定义维度。引擎尚未构建的自定义维度会由这个调用构建，就像向它写入一个方块时会构建它一样。

- 调用形式：`api->native_dimension(mod, dim, out)`
- 参数：
    - mod : `PierModHandle`
    - dim : `int32_t`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 213 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::dimension`](../rust/native.md#fn.dimension)
    - Go：[`Raw.NativeDimension`](../go/raw.md#Raw.NativeDimension)
    - Zig：[`native.dimension`](../zig/native.md#native.dimension)

### `native_block_source` {#native_block_source}

```c
int32_t (*native_block_source)(PierModHandle mod, int32_t dim, void** out);
```

维度 id 对应的 BlockSource，规则与 native_dimension 相同。

- 调用形式：`api->native_block_source(mod, dim, out)`
- 参数：
    - mod : `PierModHandle`
    - dim : `int32_t`
    - out : `void**`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 214 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::block_source`](../rust/native.md#fn.block_source)
    - Go：[`Raw.NativeBlockSource`](../go/raw.md#Raw.NativeBlockSource)
    - Zig：[`native.blockSource`](../zig/native.md#native.blockSource)

### `native_hook_install` {#native_hook_install}

```c
int32_t (*native_hook_install)(PierModHandle mod, void* target, void* detour,
                               int32_t priority, void** out_original, uint64_t* out_id);
```

通过 ll::memory::hook 在 `target` 上安装一个原生 detour。

`detour` 必须与 `target` 的签名和调用约定完全一致，宿主无法检查这一点。`priority` 从最高的 0 到最低的 400，200 为普通，取值与 ll::memory::HookPriority 相同；超出 0..400 的值会被拒绝。返回 PIER_NATIVE_OK 时，*out_original 得到 detour 用来调用下一个 detour 或引擎的地址，*out_id 得到 native_hook_remove 使用的 id。

宿主会记录哪个模组安装了什么。模组卸载时，它仍持有的每个 detour 都会在它的 dll 被卸载前移除。已经在其他线程上进入 detour 的调用不会被等待，因此运行时会被卸载的模组要么先自行移除 detour，要么不让 detour 在其他线程上运行。同一对 (target, detour) 只能安装一次，第二次安装会被拒绝。

- 调用形式：`api->native_hook_install(mod, target, detour, priority, out_original, out_id)`
- 参数：
    - mod : `PierModHandle`
    - target : `void*`
    - detour : `void*`
    - priority : `int32_t`
    - out_original : `void**`
    - out_id : `uint64_t*`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 215 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::hook_install`](../rust/native.md#fn.hook_install)
    - Go：[`Raw.NativeHookInstall`](../go/raw.md#Raw.NativeHookInstall)
    - Zig：[`native.hookInstall`](../zig/native.md#native.hookInstall)

### `native_hook_remove` {#native_hook_remove}

```c
int32_t (*native_hook_remove)(PierModHandle mod, uint64_t id);
```

移除这个模组安装的一个 detour。id 不属于这个模组（包括已经移除过的）时返回 PIER_NATIVE_NOT_FOUND。引擎侧移除失败时返回 PIER_NATIVE_FAILED，这个 detour 仍保留在记录中，卸载时会再试一次。

- 调用形式：`api->native_hook_remove(mod, id)`
- 参数：
    - mod : `PierModHandle`
    - id : `uint64_t`
- 返回值类型：`int32_t`
- 所在分节：原生逃生口（native_*）；契约是本文件靠前位置它的那一节。（`Native escape hatch (native_*); its section near the top of this file is the`）
- 表内序号：第 216 个槽位（从 0 数起）
- 各绑定里的调用方：
    - Rust：[`native::hook_remove`](../rust/native.md#fn.hook_remove)
    - Go：[`Raw.NativeHookRemove`](../go/raw.md#Raw.NativeHookRemove)
    - Zig：[`native.hookRemove`](../zig/native.md#native.hookRemove)

## `PierNativeObject` {#PierNativeObject}

native_object 的种类。

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="PIER_NATIVE_OBJ_MINECRAFT"></span>`PIER_NATIVE_OBJ_MINECRAFT` | `0` | ll::service::getMinecraft |
| <span id="PIER_NATIVE_OBJ_LEVEL"></span>`PIER_NATIVE_OBJ_LEVEL` | `1` | ll::service::getLevel |
| <span id="PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER"></span>`PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER` | `2` | ll::service::getServerNetworkHandler |
| <span id="PIER_NATIVE_OBJ_SERVER_INSTANCE"></span>`PIER_NATIVE_OBJ_SERVER_INSTANCE` | `3` | ll::service::getServerInstance |
| <span id="PIER_NATIVE_OBJ_COMMAND_REGISTRY"></span>`PIER_NATIVE_OBJ_COMMAND_REGISTRY` | `4` | ll::service::getCommandRegistry |
| <span id="PIER_NATIVE_OBJ_NETWORK_SYSTEM"></span>`PIER_NATIVE_OBJ_NETWORK_SYSTEM` | `5` | ll::service::getNetworkSystem |
| <span id="PIER_NATIVE_OBJ_DB_STORAGE"></span>`PIER_NATIVE_OBJ_DB_STORAGE` | `6` | ll::service::getDBStorage |
| <span id="PIER_NATIVE_OBJ_CLIENT_INSTANCE"></span>`PIER_NATIVE_OBJ_CLIENT_INSTANCE` | `7` | ll::service::getClientInstance，仅客户端宿主 |
| <span id="PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL"></span>`PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL` | `8` | ll::service::getMultiPlayerLevel，仅客户端宿主：客户端渲染的那个 level |

## `PIER_NATIVE_*` {#PIER_NATIVE_OK-group}

native_* 的返回码。

| 名称 | 值 | 说明 |
|---|---|---|
| <span id="PIER_NATIVE_OK"></span>`PIER_NATIVE_OK` | `0` | 完成；输出已写入 |
| <span id="PIER_NATIVE_DISABLED"></span>`PIER_NATIVE_DISABLED` | `1` | 宿主的 config.json 没有把 native_detour 设为 true |
| <span id="PIER_NATIVE_NOT_FOUND"></span>`PIER_NATIVE_NOT_FOUND` | `2` | 目前没有这样的符号、特征码匹配、导出、对象或实体 |
| <span id="PIER_NATIVE_REFUSED"></span>`PIER_NATIVE_REFUSED` | `3` | 参数为空或格式错误、种类未知、或者 id 不属于这个模组 |
| <span id="PIER_NATIVE_FAILED"></span>`PIER_NATIVE_FAILED` | `4` | 引擎侧的调用失败：例如 detour 没能安装 |
