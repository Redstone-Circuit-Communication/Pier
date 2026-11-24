# Zig: Cross-mod: bus, services and lanes

## Declarations {#declarations}

### `lane.protocol` {#lane.protocol}

```zig
pub const protocol: u32 = c.PIER_LANE_PROTOCOL;
```

The lane protocol version this binding speaks.

### `lane.LaneInfo.json_keys` {#lane.LaneInfo.json_keys}

```zig
pub const json_keys = .{ .owner = "mod" };
```

## Functions {#functions}

### `busSubscribe` {#busSubscribe}

```zig
pub fn busSubscribe(topic: []const u8, comptime handler: fn ([]const u8, []const u8) bool) Error!Subscription
```

Calls `handler(topic, payload)` for every message on topic, from mods of any language, on the publisher's thread. It returns a veto: true refuses a vetoable publish and false has no opinion, and a plain publish ignores it. Namespace topics, as "plot:enter".

- Parameters:
    - topic : `[]const u8`
    - handler : `comptime fn ([]const u8, []const u8) bool`
- Return type: `Error!Subscription`
- Slots: [`bus_subscribe`](../cpp/crossmod.md#bus_subscribe)

### `busPublish` {#busPublish}

```zig
pub fn busPublish(topic: []const u8, payload: []const u8) Error!u32
```

Sends payload to every subscriber of topic and returns how many ran; 0 means nobody is listening, which is not an error.

- Parameters:
    - topic : `[]const u8`
    - payload : `[]const u8`
- Return type: `Error!u32`
- Slots: [`bus_publish`](../cpp/crossmod.md#bus_publish)

### `busPublishVetoable` {#busPublishVetoable}

```zig
pub fn busPublishVetoable(topic: []const u8, payload: []const u8) Error!Vetoable
```

Sends payload and collects the subscribers' vetoes.

- Parameters:
    - topic : `[]const u8`
    - payload : `[]const u8`
- Return type: `Error!Vetoable`
- Slots: [`bus_publish_vetoable`](../cpp/crossmod.md#bus_publish_vetoable)

### `busSubscriberCount` {#busSubscriberCount}

```zig
pub fn busSubscriberCount(topic: []const u8) Error!u32
```

How many subscribers topic has now.

- Parameters:
    - topic : `[]const u8`
- Return type: `Error!u32`
- Slots: [`bus_subscriber_count`](../cpp/crossmod.md#bus_subscriber_count)

### `registerService` {#registerService}

```zig
pub fn registerService(name: []const u8, comptime provider: fn ([]const u8, *const Reply) bool) Error!ServiceRegistration
```

Answers calls to name from mods of any language, and from native plugins through the bridge. `provider(request, reply)` runs on the caller's thread, also while this mod is disabled but loaded, since consumers resolve services in their own `on_load`.

- Parameters:
    - name : `[]const u8`
    - provider : `comptime fn ([]const u8, *const Reply) bool`
- Return type: `Error!ServiceRegistration`
- Slots: [`service_register`](../cpp/crossmod.md#service_register)

### `callService` {#callService}

```zig
pub fn callService(allocator: std.mem.Allocator, name: []const u8, request: []const u8) Error!CallOutcome
```

Calls another mod's service, whatever language it is written in.

- Parameters:
    - allocator : `std.mem.Allocator`
    - name : `[]const u8`
    - request : `[]const u8`
- Return type: `Error!CallOutcome`
- Slots: [`service_call`](../cpp/crossmod.md#service_call)

### `listServicesJson` {#listServicesJson}

```zig
pub fn listServicesJson(allocator: std.mem.Allocator) Error![]u8
```

Every registered service as the host's JSON array of {"name","mod"}, owned by the caller.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `Error![]u8`
- Slots: [`service_list`](../cpp/crossmod.md#service_list)

### `serviceCaller` {#serviceCaller}

```zig
pub fn serviceCaller(allocator: std.mem.Allocator) Error!?[]u8
```

Inside a provider, the mod whose call is running; null outside one and for a caller with no mod, such as a native plugin through the bridge.

- Parameters:
    - allocator : `std.mem.Allocator`
- Return type: `Error!?[]u8`
- Slots: [`service_caller`](../cpp/crossmod.md#service_caller)

### `lane.publish` {#lane.publish}

```zig
pub fn publish(name: []const u8, fingerprint: u64, data: ?*anyopaque, table: *const anyopaque, retain: c.PierLaneRefFn, release: c.PierLaneRefFn) core.Error!Publication
```

Publishes a lane, exclusively under `name`. `fingerprint` is the value of the contract and must not be 0, which means anyone may connect and which the host refuses. `table` is the provider's table of function pointers, `data` the pointer each of them receives; `retain` and `release` count leases on `data`. The lane is withdrawn automatically at unload. A name that is taken is Refused, and the host log names the holder.

- Parameters:
    - name : `[]const u8`
    - fingerprint : `u64`
    - data : `?*anyopaque`
    - table : `*const anyopaque`
    - retain : `c.PierLaneRefFn`
    - release : `c.PierLaneRefFn`
- Return type: `core.Error!Publication`
- Slots: [`lane_publish`](../cpp/crossmod.md#lane_publish)

### `lane.acquire` {#lane.acquire}

```zig
pub fn acquire(name: []const u8, fingerprint: u64) core.Error!Outcome
```

Acquires a lane. `fingerprint` must be the value the consumer computed itself from the contract; 0 is not valid and always yields `fingerprint`.

- Parameters:
    - name : `[]const u8`
    - fingerprint : `u64`
- Return type: `core.Error!Outcome`
- Slots: [`lane_acquire`](../cpp/crossmod.md#lane_acquire)

### `lane.list` {#lane.list}

```zig
pub fn list(allocator: Allocator) core.Error!types.Owned(LaneInfo)
```

Every lane. It passes no pointer at all, so it suits looking at what exists first.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error!types.Owned(LaneInfo)`
- Slots: [`lane_list`](../cpp/crossmod.md#lane_list)

### `lane.listJson` {#lane.listJson}

```zig
pub fn listJson(allocator: Allocator) core.Error![]u8
```

The raw JSON of the lane listing, unparsed, owned by the caller.

- Parameters:
    - allocator : `Allocator`
- Return type: `core.Error![]u8`
- Slots: [`lane_list`](../cpp/crossmod.md#lane_list)

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

A lease on a published lane, kept to return it.

### `lane.Lease.isAlive` {#lane.Lease.isAlive}

```zig
pub fn isAlive(self: Lease) bool
```

Whether the provider is still there.

- Return type: `bool`

### `lane.Lease.enter` {#lane.Lease.enter}

```zig
pub fn enter(self: Lease) ?Guard
```

Enters the provider for one call. Null when the provider is gone. The caller makes its calls through the guard and then `leave`s, so the provider cannot unload underneath a call that is running:

```text
if (lease.enter()) |inside| {
    defer inside.leave();
    inside.table(MyTable).hello(inside.data);
}
```

- Return type: `?Guard`

### `lane.Lease.release` {#lane.Lease.release}

```zig
pub fn release(self: *Lease) core.Error!bool
```

Returns the lease. Only a lease this mod holds. False when the provider is already gone, since the loader has released it by then and releasing again would be a double free.

- Return type: `core.Error!bool`
- Slots: [`lane_release`](../cpp/crossmod.md#lane_release)

## `lane.Guard` {#lane.Guard}

```zig
pub const Guard = struct {
    lease: Lease,
    // ...
};
```

One call inside a provider. `leave` ends it.

### `lane.Guard.table` {#lane.Guard.table}

```zig
pub fn table(self: Guard, comptime Table: type) *const Table
```

The provider's table, which the contract names the type of.

- Parameters:
    - Table : `comptime type`
- Return type: `*const Table`

### `lane.Guard.data` {#lane.Guard.data}

```zig
pub fn data(self: Guard) ?*anyopaque
```

The pointer each function of the table receives.

- Return type: `?*anyopaque`

### `lane.Guard.leave` {#lane.Guard.leave}

```zig
pub fn leave(self: Guard) void
```

- Return type: `void`

## `Subscription` {#Subscription}

```zig
pub const Subscription = struct {
    id: u64,
    // ...
};
```

One bus subscription, kept to end it.

### `Subscription.unsubscribe` {#Subscription.unsubscribe}

```zig
pub fn unsubscribe(self: *Subscription) Error!void
```

Ends the subscription; calling it twice is harmless.

- Return type: `Error!void`
- Slots: [`bus_unsubscribe`](../cpp/crossmod.md#bus_unsubscribe)

## `Reply` {#Reply}

```zig
pub const Reply = struct {
    ctx: ?*anyopaque,
    sink: c.PierStrSink,
    // ...
};
```

The way a service provider answers: send the reply and return true, or send the reason and return false, which the caller receives unchanged as the provider's message.

### `Reply.send` {#Reply.send}

```zig
pub fn send(self: *const Reply, text: []const u8) void
```

- Parameters:
    - text : `[]const u8`
- Return type: `void`

## `ServiceRegistration` {#ServiceRegistration}

```zig
pub const ServiceRegistration = struct {
    id: u64,
    // ...
};
```

One service this mod provides, kept to withdraw it.

### `ServiceRegistration.unregister` {#ServiceRegistration.unregister}

```zig
pub fn unregister(self: *ServiceRegistration) Error!void
```

Withdraws the service; calling it twice is harmless.

- Return type: `Error!void`
- Slots: [`service_unregister`](../cpp/crossmod.md#service_unregister)

## `lane.Publication` {#lane.Publication}

```zig
pub const Publication = struct {
    id: u64,
    // ...
};
```

One publication. `withdraw` takes the lane back.

### `lane.Publication.withdraw` {#lane.Publication.withdraw}

```zig
pub fn withdraw(self: *Publication) core.Error!void
```

Withdraws the lane; calling it twice is harmless. Every outstanding lease is released and a consumer's next liveness check sees the lane gone.

- Return type: `core.Error!void`
- Slots: [`lane_unpublish`](../cpp/crossmod.md#lane_unpublish)

## `Vetoable` {#Vetoable}

```zig
pub const Vetoable = struct {
    vetoed: bool, delivered: u32
    // ...
};
```

The result of one vetoable publish. There is no short circuit: after a veto the later subscribers still receive the message.

## `CallCode` {#CallCode}

```zig
pub const CallCode = enum {
    ok, not_found, provider_error, refused
};
```

How a service call ended, matching the PIER\_SERVICE\_\* results.

## `CallOutcome` {#CallOutcome}

```zig
pub const CallOutcome = struct {
    code: CallCode, body: []u8
    // ...
};
```

One service call's outcome. body is the reply for ok and the provider's message for `provider_error`, owned by the caller.

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

How acquiring a lane ended.

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

The registration record of a published lane.
