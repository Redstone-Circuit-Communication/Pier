# Zig：跨模组：总线、服务与快速通道

## 声明 {#declarations}

### `lane.protocol` {#lane.protocol}

```zig
pub const protocol: u32 = c.PIER_LANE_PROTOCOL;
```

这个绑定使用的快速通道协议版本。

### `lane.LaneInfo.json_keys` {#lane.LaneInfo.json_keys}

```zig
pub const json_keys = .{ .owner = "mod" };
```

## 函数 {#functions}

### `busSubscribe` {#busSubscribe}

```zig
pub fn busSubscribe(topic: []const u8, comptime handler: fn ([]const u8, []const u8) bool) Error!Subscription
```

对 `topic` 上的每一条消息调用 `handler(topic, payload)`，消息可以来自任何语言写的模组，在发布方的线程上调用。返回值是否决：true 拒绝一次可否决的发布，false 表示没有意见，普通的发布忽略它。主题请加命名空间，比如 `"plot:enter"`。

- 参数：
    - topic : `[]const u8`
    - handler : `comptime fn ([]const u8, []const u8) bool`
- 返回值类型：`Error!Subscription`
- 对应槽位：[`bus_subscribe`](../cpp/crossmod.md#bus_subscribe)

### `busPublish` {#busPublish}

```zig
pub fn busPublish(topic: []const u8, payload: []const u8) Error!u32
```

把 `payload` 发给 `topic` 的每一个订阅者，返回运行了多少个；0 表示没有人在听，这不是错误。

- 参数：
    - topic : `[]const u8`
    - payload : `[]const u8`
- 返回值类型：`Error!u32`
- 对应槽位：[`bus_publish`](../cpp/crossmod.md#bus_publish)

### `busPublishVetoable` {#busPublishVetoable}

```zig
pub fn busPublishVetoable(topic: []const u8, payload: []const u8) Error!Vetoable
```

发送 `payload`，并收集订阅者的否决。

- 参数：
    - topic : `[]const u8`
    - payload : `[]const u8`
- 返回值类型：`Error!Vetoable`
- 对应槽位：[`bus_publish_vetoable`](../cpp/crossmod.md#bus_publish_vetoable)

### `busSubscriberCount` {#busSubscriberCount}

```zig
pub fn busSubscriberCount(topic: []const u8) Error!u32
```

`topic` 当前有多少订阅者。

- 参数：
    - topic : `[]const u8`
- 返回值类型：`Error!u32`
- 对应槽位：[`bus_subscriber_count`](../cpp/crossmod.md#bus_subscriber_count)

### `registerService` {#registerService}

```zig
pub fn registerService(name: []const u8, comptime provider: fn ([]const u8, *const Reply) bool) Error!ServiceRegistration
```

回答任何语言写的模组对 `name` 的调用，也回答原生插件经 bridge 发来的调用。`provider(request, reply)` 在调用方的线程上运行；这个模组被禁用、但仍然加载着的时候也会运行，因为使用方会在自己的 `on_load` 里解析服务。

- 参数：
    - name : `[]const u8`
    - provider : `comptime fn ([]const u8, *const Reply) bool`
- 返回值类型：`Error!ServiceRegistration`
- 对应槽位：[`service_register`](../cpp/crossmod.md#service_register)

### `callService` {#callService}

```zig
pub fn callService(allocator: std.mem.Allocator, name: []const u8, request: []const u8) Error!CallOutcome
```

调用另一个模组的服务，不管它是用什么语言写的。

- 参数：
    - allocator : `std.mem.Allocator`
    - name : `[]const u8`
    - request : `[]const u8`
- 返回值类型：`Error!CallOutcome`
- 对应槽位：[`service_call`](../cpp/crossmod.md#service_call)

### `listServicesJson` {#listServicesJson}

```zig
pub fn listServicesJson(allocator: std.mem.Allocator) Error![]u8
```

所有已注册的服务，以宿主给出的 JSON 数组 `{"name","mod"}` 返回，归调用方所有。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`Error![]u8`
- 对应槽位：[`service_list`](../cpp/crossmod.md#service_list)

### `serviceCaller` {#serviceCaller}

```zig
pub fn serviceCaller(allocator: std.mem.Allocator) Error!?[]u8
```

在提供方内部，返回正在调用它的模组；在提供方之外，或者调用方没有模组（比如经 bridge 调用的原生插件）时返回 null。

- 参数：
    - allocator : `std.mem.Allocator`
- 返回值类型：`Error!?[]u8`
- 对应槽位：[`service_caller`](../cpp/crossmod.md#service_caller)

### `lane.publish` {#lane.publish}

```zig
pub fn publish(name: []const u8, fingerprint: u64, data: ?*anyopaque, table: *const anyopaque, retain: c.PierLaneRefFn, release: c.PierLaneRefFn) core.Error!Publication
```

以 `name` 独占地发布一条快速通道。`fingerprint` 是契约的值，不能是 0：0 表示任何人都可以连接，宿主会拒绝。`table` 是提供方的函数指针表，`data` 是每个函数收到的指针；`retain` 和 `release` 统计对 `data` 的租约。卸载时这条通道会被自动撤回。名字被占用时得到 `Refused`，宿主日志里会写出占用者。

- 参数：
    - name : `[]const u8`
    - fingerprint : `u64`
    - data : `?*anyopaque`
    - table : `*const anyopaque`
    - retain : `c.PierLaneRefFn`
    - release : `c.PierLaneRefFn`
- 返回值类型：`core.Error!Publication`
- 对应槽位：[`lane_publish`](../cpp/crossmod.md#lane_publish)

### `lane.acquire` {#lane.acquire}

```zig
pub fn acquire(name: []const u8, fingerprint: u64) core.Error!Outcome
```

获取一条快速通道。`fingerprint` 必须是消费方自己根据契约算出来的值；0 无效，总是得到 `fingerprint`。

- 参数：
    - name : `[]const u8`
    - fingerprint : `u64`
- 返回值类型：`core.Error!Outcome`
- 对应槽位：[`lane_acquire`](../cpp/crossmod.md#lane_acquire)

### `lane.list` {#lane.list}

```zig
pub fn list(allocator: Allocator) core.Error!types.Owned(LaneInfo)
```

所有快速通道。它不交出任何指针，所以适合先看看有什么。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error!types.Owned(LaneInfo)`
- 对应槽位：[`lane_list`](../cpp/crossmod.md#lane_list)

### `lane.listJson` {#lane.listJson}

```zig
pub fn listJson(allocator: Allocator) core.Error![]u8
```

快速通道列表的原始 JSON，未经解析，由调用方持有。

- 参数：
    - allocator : `Allocator`
- 返回值类型：`core.Error![]u8`
- 对应槽位：[`lane_list`](../cpp/crossmod.md#lane_list)

## `lane.Lease` {#lane.Lease}

```zig
pub const Lease = struct {
    lease: u64,
    fingerprint: u64,
    data: ?*anyopaque,
    table: ?*const anyopaque,
    alive: ?*const u32,
    busy: ?*u32,
    // ...
};
```

对一条已发布通道的租约，留着它是为了归还。

### `lane.Lease.isAlive` {#lane.Lease.isAlive}

```zig
pub fn isAlive(self: Lease) bool
```

提供方是否还在。

- 返回值类型：`bool`

### `lane.Lease.enter` {#lane.Lease.enter}

```zig
pub fn enter(self: Lease) ?Guard
```

为一次调用进入提供方。提供方已经不在时为 null。调用方通过这个守卫发起调用，之后 `leave`，这样提供方就不会在调用进行时被卸载：if (lease.enter()) |inside| { defer inside.leave(); inside.table(MyTable).hello(inside.data); }

- 返回值类型：`?Guard`

### `lane.Lease.release` {#lane.Lease.release}

```zig
pub fn release(self: *Lease) core.Error!bool
```

归还租约。只能是这个 mod 持有的租约。提供方已经不在时为 false，因为加载器那时已经释放过它，再释放一次就是重复释放。

- 返回值类型：`core.Error!bool`
- 对应槽位：[`lane_release`](../cpp/crossmod.md#lane_release)

## `lane.Guard` {#lane.Guard}

```zig
pub const Guard = struct {
    lease: Lease,
    // ...
};
```

提供方内部的一次调用。`leave` 结束它。

### `lane.Guard.table` {#lane.Guard.table}

```zig
pub fn table(self: Guard, comptime Table: type) *const Table
```

提供方的函数表，它的类型由契约指定。

- 参数：
    - Table : `comptime type`
- 返回值类型：`*const Table`

### `lane.Guard.data` {#lane.Guard.data}

```zig
pub fn data(self: Guard) ?*anyopaque
```

函数表里每个函数收到的指针。

- 返回值类型：`?*anyopaque`

### `lane.Guard.leave` {#lane.Guard.leave}

```zig
pub fn leave(self: Guard) void
```

- 返回值类型：`void`

## `Subscription` {#Subscription}

```zig
pub const Subscription = struct {
    id: u64,
    // ...
};
```

一个总线订阅，保存下来用来结束它。

### `Subscription.unsubscribe` {#Subscription.unsubscribe}

```zig
pub fn unsubscribe(self: *Subscription) Error!void
```

结束订阅；调用两次也没有问题。

- 返回值类型：`Error!void`
- 对应槽位：[`bus_unsubscribe`](../cpp/crossmod.md#bus_unsubscribe)

## `Reply` {#Reply}

```zig
pub const Reply = struct {
    ctx: ?*anyopaque,
    sink: c.PierStrSink,
    // ...
};
```

服务提供方回答的方式：发送回答并返回 true；或者发送原因并返回 false，调用方会原样收到这段文字，作为提供方的错误信息。

### `Reply.send` {#Reply.send}

```zig
pub fn send(self: *const Reply, text: []const u8) void
```

- 参数：
    - text : `[]const u8`
- 返回值类型：`void`

## `ServiceRegistration` {#ServiceRegistration}

```zig
pub const ServiceRegistration = struct {
    id: u64,
    // ...
};
```

这个模组提供的一项服务，保存下来用来撤回它。

### `ServiceRegistration.unregister` {#ServiceRegistration.unregister}

```zig
pub fn unregister(self: *ServiceRegistration) Error!void
```

撤回这项服务；调用两次也没有问题。

- 返回值类型：`Error!void`
- 对应槽位：[`service_unregister`](../cpp/crossmod.md#service_unregister)

## `lane.Publication` {#lane.Publication}

```zig
pub const Publication = struct {
    id: u64,
    // ...
};
```

一次发布。`withdraw` 把通道收回来。

### `lane.Publication.withdraw` {#lane.Publication.withdraw}

```zig
pub fn withdraw(self: *Publication) core.Error!void
```

撤回这条通道；调用两次也没有害处。所有未归还的租约都会被释放，消费方下一次存活检查就会看到通道已经没了。

- 返回值类型：`core.Error!void`
- 对应槽位：[`lane_unpublish`](../cpp/crossmod.md#lane_unpublish)

## `Vetoable` {#Vetoable}

```zig
pub const Vetoable = struct {
    vetoed: bool, delivered: u32
    // ...
};
```

一次可否决发布的结果。不会提前结束：有订阅者否决以后，后面的订阅者仍然会收到消息。

## `CallCode` {#CallCode}

```zig
pub const CallCode = enum {
    ok, not_found, provider_error, refused
};
```

一次服务调用的结束方式，和 `PIER_SERVICE_*` 的结果一一对应。

## `CallOutcome` {#CallOutcome}

```zig
pub const CallOutcome = struct {
    code: CallCode, body: []u8
    // ...
};
```

一次服务调用的结果。`code` 为 ok 时 `body` 是回答，为 provider_error 时 `body` 是提供方的错误信息，归调用方所有。

## `lane.Outcome` {#lane.Outcome}

```zig
pub const Outcome = union(enum) {
    lease: Lease,
    /// No lane by that name is published.
    not_found,
    /// The provider's fingerprint, which differs from the one asked for.
    fingerprint: u64,
    refused,
    // ...
};
```

获取一条快速通道的结果。

## `lane.LaneInfo` {#lane.LaneInfo}

```zig
pub const LaneInfo = struct {
    name: []const u8 = "",
    owner: []const u8 = "",
    fingerprint: []const u8 = "",
    protocol: u32 = 0,
    leases: u32 = 0,
    alive: bool = false,
    // ...
};
```

已发布通道的注册记录。
