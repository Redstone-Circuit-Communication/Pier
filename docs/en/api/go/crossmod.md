# Go: Cross-mod: bus, services and lanes

## Functions {#functions}

### `BusSubscribe` {#BusSubscribe}

```go
func BusSubscribe(topic string, fn func(topic, payload string) (veto bool)) (*Subscription, error)
```

BusSubscribe calls fn for every message published on topic, on the publisher's thread, whichever language the publisher is written in. fn returns a veto: true refuses a vetoable publish and false has no opinion, and a plain publish ignores it. A subscriber can only refuse, never overturn another's refusal. Namespace topics, as "plot:enter".

- Parameters:
    - topic : `string`
    - fn : `func(topic, payload string) (veto bool)`
- Return type: `(*Subscription, error)`
- Slots: [`bus_subscribe`](../cpp/crossmod.md#bus_subscribe)

### `BusPublish` {#BusPublish}

```go
func BusPublish(topic, payload string) (uint32, error)
```

BusPublish sends payload to every subscriber of topic and returns how many ran; 0 is a normal answer, meaning nobody is listening. The payload is opaque to the host, so the two mods agree on its format, JSON or SNBT, out of band.

- Parameters:
    - topic : `string`
    - payload : `string`
- Return type: `(uint32, error)`
- Slots: [`bus_publish`](../cpp/crossmod.md#bus_publish)

### `BusPublishVetoable` {#BusPublishVetoable}

```go
func BusPublishVetoable(topic, payload string) (Vetoable, error)
```

BusPublishVetoable sends payload and collects the subscribers' vetoes.

- Parameters:
    - topic : `string`
    - payload : `string`
- Return type: `(Vetoable, error)`
- Slots: [`bus_publish_vetoable`](../cpp/crossmod.md#bus_publish_vetoable)

### `BusSubscriberCount` {#BusSubscriberCount}

```go
func BusSubscriberCount(topic string) (uint32, error)
```

BusSubscriberCount is how many subscribers topic has now.

- Parameters:
    - topic : `string`
- Return type: `(uint32, error)`
- Slots: [`bus_subscriber_count`](../cpp/crossmod.md#bus_subscriber_count)

### `RegisterService` {#RegisterService}

```go
func RegisterService(name string, fn func(request string) (string, error)) (*ServiceRegistration, error)
```

RegisterService answers calls to name from mods of any language, and from native plugins through the bridge. fn receives the request and returns the reply, or an error whose message reaches the caller unchanged. It runs on the caller's thread, and also while this mod is disabled but loaded, since consumers resolve services in their own `on_load`.

- Parameters:
    - name : `string`
    - fn : `func(request string) (string, error)`
- Return type: `(*ServiceRegistration, error)`
- Slots: [`service_register`](../cpp/crossmod.md#service_register)

### `CallService` {#CallService}

```go
func CallService(name, request string) (string, error)
```

CallService calls another mod's service, whatever language it is written in, and returns its reply or a \*CallError.

- Parameters:
    - name : `string`
    - request : `string`
- Return type: `(string, error)`
- Slots: [`service_call`](../cpp/crossmod.md#service_call)

### `CallServiceOptional` {#CallServiceOptional}

```go
func CallServiceOptional(name, request string) (reply string, found bool, err error)
```

CallServiceOptional is CallService with nobody providing the name as found false, for an optional integration that works without the other mod.

- Parameters:
    - name : `string`
    - request : `string`
- Return type: `(reply string, found bool, err error)`
- Slots: [`service_call`](../cpp/crossmod.md#service_call)

### `ListServices` {#ListServices}

```go
func ListServices() ([]ServiceInfo, error)
```

ListServices lists every registered service.

- Return type: `([]ServiceInfo, error)`
- Slots: [`service_list`](../cpp/crossmod.md#service_list)

### `ServiceExists` {#ServiceExists}

```go
func ServiceExists(name string) bool
```

ServiceExists reports whether some mod provides name now.

- Parameters:
    - name : `string`
- Return type: `bool`
- Slots: [`service_list`](../cpp/crossmod.md#service_list)

### `ServiceCaller` {#ServiceCaller}

```go
func ServiceCaller() (string, bool)
```

ServiceCaller is the mod whose call is running, asked inside a provider. It is false outside a provider and for a caller with no mod, such as a native plugin through the bridge: a provider then knows it cannot attribute the request.

- Return type: `(string, bool)`
- Slots: [`service_caller`](../cpp/crossmod.md#service_caller)

### `Lanes` {#Lanes}

```go
func Lanes() ([]LaneInfo, error)
```

Lanes lists every published lane. It passes no pointer at all, so it suits looking at what exists first.

- Return type: `([]LaneInfo, error)`
- Slots: [`lane_list`](../cpp/crossmod.md#lane_list)

### `PublishLane` {#PublishLane}

```go
func PublishLane(name string, fingerprint uint64, data, table, retain, release unsafe.Pointer) (*LanePublication, error)
```

PublishLane publishes a lane, exclusively under name. fingerprint is the value of the contract and must not be 0, which means anyone may connect and which the host refuses. table is the provider's table of function pointers and data the pointer each of them receives; both must point into C memory, since the consumer reaches them from outside Go. retain and release, when not nil, are C functions that count leases on data. The lane is withdrawn automatically at unload.

- Parameters:
    - name : `string`
    - fingerprint : `uint64`
    - data : `unsafe.Pointer`
    - table : `unsafe.Pointer`
    - retain : `unsafe.Pointer`
    - release : `unsafe.Pointer`
- Return type: `(*LanePublication, error)`
- Slots: [`lane_publish`](../cpp/crossmod.md#lane_publish)

### `AcquireLane` {#AcquireLane}

```go
func AcquireLane(name string, fingerprint uint64) (*LaneLease, error)
```

AcquireLane acquires a lane. fingerprint must be the value the consumer computed itself from the contract; 0 is not valid and always fails. A missing lane is a \*LaneNotFoundError and a contract that differs is a \*LaneFingerprintError.

- Parameters:
    - name : `string`
    - fingerprint : `uint64`
- Return type: `(*LaneLease, error)`
- Slots: [`lane_acquire`](../cpp/crossmod.md#lane_acquire)

## `Subscription` {#Subscription}

```go
type Subscription struct {
    // unexported fields
}
```

Subscription is one bus subscription, kept to end it.

### `Subscription.ID` {#Subscription.ID}

```go
func (s *Subscription) ID() uint64
```

ID is the host's id of the subscription.

- Return type: `uint64`

### `Subscription.Topic` {#Subscription.Topic}

```go
func (s *Subscription) Topic() string
```

Topic is the topic subscribed to.

- Return type: `string`

### `Subscription.Unsubscribe` {#Subscription.Unsubscribe}

```go
func (s *Subscription) Unsubscribe() error
```

Unsubscribe ends the subscription. Calling it twice is harmless.

- Return type: `error`
- Slots: [`bus_unsubscribe`](../cpp/crossmod.md#bus_unsubscribe)

## `ServiceRegistration` {#ServiceRegistration}

```go
type ServiceRegistration struct {
    // unexported fields
}
```

ServiceRegistration is one service this mod provides, kept to withdraw it.

### `ServiceRegistration.ID` {#ServiceRegistration.ID}

```go
func (r *ServiceRegistration) ID() uint64
```

ID is the host's id of the registration.

- Return type: `uint64`

### `ServiceRegistration.Name` {#ServiceRegistration.Name}

```go
func (r *ServiceRegistration) Name() string
```

Name is the service name.

- Return type: `string`

### `ServiceRegistration.Unregister` {#ServiceRegistration.Unregister}

```go
func (r *ServiceRegistration) Unregister() error
```

Unregister withdraws the service. Calling it twice is harmless.

- Return type: `error`
- Slots: [`service_unregister`](../cpp/crossmod.md#service_unregister)

## `LaneLease` {#LaneLease}

```go
type LaneLease struct {
    // unexported fields
}
```

LaneLease is a lease on a published lane, kept to return it.

### `LaneLease.IsAlive` {#LaneLease.IsAlive}

```go
func (l *LaneLease) IsAlive() bool
```

IsAlive reports whether the provider is still there.

- Return type: `bool`

### `LaneLease.Enter` {#LaneLease.Enter}

```go
func (l *LaneLease) Enter() (table, data unsafe.Pointer, leave func(), ok bool)
```

Enter enters the provider for one call and returns the provider's table and data pointers. ok is false when the provider is gone. Call leave when the call is over, so the provider cannot unload underneath a call that is running.

- Return type: `(table, data unsafe.Pointer, leave func(), ok bool)`

### `LaneLease.Release` {#LaneLease.Release}

```go
func (l *LaneLease) Release() (bool, error)
```

Release returns the lease. It reports false when the provider is already gone, since the loader has released it by then and releasing again would be a double free.

- Return type: `(bool, error)`
- Slots: [`lane_release`](../cpp/crossmod.md#lane_release)

## `CallError` {#CallError}

```go
type CallError struct {
    Kind    CallErrorKind
    Name    string
    Message string
}
```

CallError is why a service call failed: nobody provides the name, the provider said no and Message is what it said, the host refused the call (a bad name, a call to itself or a cycle), or the host has no service capability.

### `CallError.Error` {#CallError.Error}

```go
func (e *CallError) Error() string
```

- Return type: `string`

## `LanePublication` {#LanePublication}

```go
type LanePublication struct{ id uint64 }
type LanePublication struct{ id uint64 }
```

LanePublication is one published lane.

### `LanePublication.Withdraw` {#LanePublication.Withdraw}

```go
func (p *LanePublication) Withdraw() error
```

Withdraw takes the lane back; calling it twice is harmless. Every outstanding lease is released.

- Return type: `error`
- Slots: [`lane_unpublish`](../cpp/crossmod.md#lane_unpublish)

## `LaneNotFoundError` {#LaneNotFoundError}

```go
type LaneNotFoundError struct{ Name string }
type LaneNotFoundError struct{ Name string }
```

LaneNotFoundError means no lane by that name is published.

### `LaneNotFoundError.Error` {#LaneNotFoundError.Error}

```go
func (e *LaneNotFoundError) Error() string
```

- Return type: `string`

## `LaneFingerprintError` {#LaneFingerprintError}

```go
type LaneFingerprintError struct {
    Name         string
    Ours, Theirs uint64
}
```

LaneFingerprintError means the provider's contract is not the one the consumer asked for.

### `LaneFingerprintError.Error` {#LaneFingerprintError.Error}

```go
func (e *LaneFingerprintError) Error() string
```

- Return type: `string`

## `Vetoable` {#Vetoable}

```go
type Vetoable struct {
    // Vetoed is true when any subscriber refused.
    Vetoed bool
    // Delivered is how many subscribers ran. There is no short circuit: after a veto the
    // later subscribers still receive the message, so observers see a consistent stream.
    Delivered uint32
}
```

Vetoable is the result of one vetoable publish.

## `CallErrorKind` {#CallErrorKind}

```go
type CallErrorKind int
```

CallErrorKind says why a service call failed.

| Name | Value | Description |
|---|---|---|
| <span id="CallNotFound"></span>`CallNotFound` | `1` |  |
| <span id="CallProvider"></span>`CallProvider` | `2` |  |
| <span id="CallRefused"></span>`CallRefused` | `3` |  |
| <span id="CallUnavailable"></span>`CallUnavailable` | `4` |  |

## `ServiceInfo` {#ServiceInfo}

```go
type ServiceInfo struct {
    Name string `json:"name"`
    Mod  string `json:"mod"`
}
```

ServiceInfo is one registered service and the mod providing it.

## `LaneInfo` {#LaneInfo}

```go
type LaneInfo struct {
    Name        string `json:"name"`
    Mod         string `json:"mod"`
    Fingerprint string `json:"fingerprint"`
    Protocol    uint32 `json:"protocol"`
    Leases      uint32 `json:"leases"`
    Alive       bool   `json:"alive"`
}
```

LaneInfo is the registration record of a published lane.
