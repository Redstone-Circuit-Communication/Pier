# Go：跨模组：总线、服务与快速通道

## 函数 {#functions}

### `BusSubscribe` {#BusSubscribe}

```go
func BusSubscribe(topic string, fn func(topic, payload string) (veto bool)) (*Subscription, error)
```

对 `topic` 上发布的每一条消息调用 `fn`，在发布方的线程上调用，不管发布方是用什么语言写的。`fn` 返回否决：true 拒绝一次可否决的发布，false 表示没有意见，普通的发布忽略它。订阅者只能拒绝，不能推翻别人的拒绝。主题请加命名空间，比如 `"plot:enter"`。

- 参数：
    - topic : `string`
    - fn : `func(topic, payload string) (veto bool)`
- 返回值类型：`(*Subscription, error)`
- 对应槽位：[`bus_subscribe`](../cpp/crossmod.md#bus_subscribe)

### `BusPublish` {#BusPublish}

```go
func BusPublish(topic, payload string) (uint32, error)
```

把 `payload` 发给 `topic` 的每一个订阅者，返回运行了多少个；0 是正常的回答，表示没有人在听。载荷对宿主是不透明的，所以两个模组要在别处约定它的格式，JSON 或者 SNBT。

- 参数：
    - topic : `string`
    - payload : `string`
- 返回值类型：`(uint32, error)`
- 对应槽位：[`bus_publish`](../cpp/crossmod.md#bus_publish)

### `BusPublishVetoable` {#BusPublishVetoable}

```go
func BusPublishVetoable(topic, payload string) (Vetoable, error)
```

发送 `payload`，并收集订阅者的否决。

- 参数：
    - topic : `string`
    - payload : `string`
- 返回值类型：`(Vetoable, error)`
- 对应槽位：[`bus_publish_vetoable`](../cpp/crossmod.md#bus_publish_vetoable)

### `BusSubscriberCount` {#BusSubscriberCount}

```go
func BusSubscriberCount(topic string) (uint32, error)
```

`topic` 当前有多少订阅者。

- 参数：
    - topic : `string`
- 返回值类型：`(uint32, error)`
- 对应槽位：[`bus_subscriber_count`](../cpp/crossmod.md#bus_subscriber_count)

### `RegisterService` {#RegisterService}

```go
func RegisterService(name string, fn func(request string) (string, error)) (*ServiceRegistration, error)
```

回答任何语言写的模组对 `name` 的调用，也回答原生插件经 bridge 发来的调用。`fn` 收到请求，返回回答，或者返回一个错误，错误信息会原样到达调用方。它在调用方的线程上运行；这个模组被禁用、但仍然加载着的时候也会运行，因为使用方会在自己的 `on_load` 里解析服务。

- 参数：
    - name : `string`
    - fn : `func(request string) (string, error)`
- 返回值类型：`(*ServiceRegistration, error)`
- 对应槽位：[`service_register`](../cpp/crossmod.md#service_register)

### `CallService` {#CallService}

```go
func CallService(name, request string) (string, error)
```

调用另一个模组的服务，不管它是用什么语言写的；返回它的回答，或者一个 `*CallError`。

- 参数：
    - name : `string`
    - request : `string`
- 返回值类型：`(string, error)`
- 对应槽位：[`service_call`](../cpp/crossmod.md#service_call)

### `CallServiceOptional` {#CallServiceOptional}

```go
func CallServiceOptional(name, request string) (reply string, found bool, err error)
```

没有模组提供这个名字时，以 `found` 为 false 返回的 `CallService`，用于没有另一个模组也能工作的可选集成。

- 参数：
    - name : `string`
    - request : `string`
- 返回值类型：`(reply string, found bool, err error)`
- 对应槽位：[`service_call`](../cpp/crossmod.md#service_call)

### `ListServices` {#ListServices}

```go
func ListServices() ([]ServiceInfo, error)
```

列出所有已注册的服务。

- 返回值类型：`([]ServiceInfo, error)`
- 对应槽位：[`service_list`](../cpp/crossmod.md#service_list)

### `ServiceExists` {#ServiceExists}

```go
func ServiceExists(name string) bool
```

判断现在有没有模组提供 `name`。

- 参数：
    - name : `string`
- 返回值类型：`bool`
- 对应槽位：[`service_list`](../cpp/crossmod.md#service_list)

### `ServiceCaller` {#ServiceCaller}

```go
func ServiceCaller() (string, bool)
```

在提供方内部调用时，返回正在调用它的模组。在提供方之外，或者调用方没有模组（比如经 bridge 调用的原生插件）时为 false：提供方由此知道它无法确定请求来自谁。

- 返回值类型：`(string, bool)`
- 对应槽位：[`service_caller`](../cpp/crossmod.md#service_caller)

### `Lanes` {#Lanes}

```go
func Lanes() ([]LaneInfo, error)
```

Lanes 列出每条已发布的快速通道。它不传任何指针，所以适合先看看有什么。

- 返回值类型：`([]LaneInfo, error)`
- 对应槽位：[`lane_list`](../cpp/crossmod.md#lane_list)

### `PublishLane` {#PublishLane}

```go
func PublishLane(name string, fingerprint uint64, data, table, retain, release unsafe.Pointer) (*LanePublication, error)
```

PublishLane 以 name 独占地发布一条快速通道。fingerprint 是契约的值，不能是 0：0 表示任何人都可以连接，宿主会拒绝。table 是提供方的函数指针表，data 是每个函数收到的指针；两者都必须指向 C 内存，因为消费方是从 Go 之外访问它们的。retain 和 release 不为 nil 时是统计 data 上租约的 C 函数。卸载时这条通道会被自动撤回。

- 参数：
    - name : `string`
    - fingerprint : `uint64`
    - data : `unsafe.Pointer`
    - table : `unsafe.Pointer`
    - retain : `unsafe.Pointer`
    - release : `unsafe.Pointer`
- 返回值类型：`(*LanePublication, error)`
- 对应槽位：[`lane_publish`](../cpp/crossmod.md#lane_publish)

### `AcquireLane` {#AcquireLane}

```go
func AcquireLane(name string, fingerprint uint64) (*LaneLease, error)
```

AcquireLane 获取一条快速通道。fingerprint 必须是消费方自己根据契约算出来的值；0 无效，总是失败。通道不存在时错误是 *LaneNotFoundError，契约不一致时是 *LaneFingerprintError。

- 参数：
    - name : `string`
    - fingerprint : `uint64`
- 返回值类型：`(*LaneLease, error)`
- 对应槽位：[`lane_acquire`](../cpp/crossmod.md#lane_acquire)

## `Subscription` {#Subscription}

```go
type Subscription struct {
    // unexported fields
}
```

一个总线订阅，保存下来用来结束它。

### `Subscription.ID` {#Subscription.ID}

```go
func (s *Subscription) ID() uint64
```

宿主给这个订阅的 id。

- 返回值类型：`uint64`

### `Subscription.Topic` {#Subscription.Topic}

```go
func (s *Subscription) Topic() string
```

订阅的主题。

- 返回值类型：`string`

### `Subscription.Unsubscribe` {#Subscription.Unsubscribe}

```go
func (s *Subscription) Unsubscribe() error
```

结束订阅。调用两次也没有问题。

- 返回值类型：`error`
- 对应槽位：[`bus_unsubscribe`](../cpp/crossmod.md#bus_unsubscribe)

## `ServiceRegistration` {#ServiceRegistration}

```go
type ServiceRegistration struct {
    // unexported fields
}
```

这个模组提供的一项服务，保存下来用来撤回它。

### `ServiceRegistration.ID` {#ServiceRegistration.ID}

```go
func (r *ServiceRegistration) ID() uint64
```

宿主给这项注册的 id。

- 返回值类型：`uint64`

### `ServiceRegistration.Name` {#ServiceRegistration.Name}

```go
func (r *ServiceRegistration) Name() string
```

服务的名字。

- 返回值类型：`string`

### `ServiceRegistration.Unregister` {#ServiceRegistration.Unregister}

```go
func (r *ServiceRegistration) Unregister() error
```

撤回这项服务。调用两次也没有问题。

- 返回值类型：`error`
- 对应槽位：[`service_unregister`](../cpp/crossmod.md#service_unregister)

## `LaneLease` {#LaneLease}

```go
type LaneLease struct {
    // unexported fields
}
```

LaneLease 是对一条已发布通道的租约，留着它是为了归还。

### `LaneLease.IsAlive` {#LaneLease.IsAlive}

```go
func (l *LaneLease) IsAlive() bool
```

IsAlive 报告提供方是否还在。

- 返回值类型：`bool`

### `LaneLease.Enter` {#LaneLease.Enter}

```go
func (l *LaneLease) Enter() (table, data unsafe.Pointer, leave func(), ok bool)
```

Enter 为一次调用进入提供方，并返回提供方的函数表和 data 指针。提供方已经不在时 ok 为 false。调用结束后要调用 leave，这样提供方就不会在调用进行时被卸载。

- 返回值类型：`(table, data unsafe.Pointer, leave func(), ok bool)`

### `LaneLease.Release` {#LaneLease.Release}

```go
func (l *LaneLease) Release() (bool, error)
```

Release 归还租约。提供方已经不在时报告 false，因为加载器那时已经释放过它，再释放一次就是重复释放。

- 返回值类型：`(bool, error)`
- 对应槽位：[`lane_release`](../cpp/crossmod.md#lane_release)

## `CallError` {#CallError}

```go
type CallError struct {
    Kind    CallErrorKind
    Name    string
    Message string
}
```

服务调用失败的原因：没有模组提供这个名字；提供方拒绝了，`Message` 是它给的理由；宿主拒绝了这次调用（名字不合法、调用自己，或者形成了循环）；或者宿主没有服务这项能力。

### `CallError.Error` {#CallError.Error}

```go
func (e *CallError) Error() string
```

- 返回值类型：`string`

## `LanePublication` {#LanePublication}

```go
type LanePublication struct{ id uint64 }
type LanePublication struct{ id uint64 }
```

LanePublication 是一条已发布的快速通道。

### `LanePublication.Withdraw` {#LanePublication.Withdraw}

```go
func (p *LanePublication) Withdraw() error
```

Withdraw 把通道收回来；调用两次也没有害处。所有未归还的租约都会被释放。

- 返回值类型：`error`
- 对应槽位：[`lane_unpublish`](../cpp/crossmod.md#lane_unpublish)

## `LaneNotFoundError` {#LaneNotFoundError}

```go
type LaneNotFoundError struct{ Name string }
type LaneNotFoundError struct{ Name string }
```

LaneNotFoundError 表示没有发布过这个名字的快速通道。

### `LaneNotFoundError.Error` {#LaneNotFoundError.Error}

```go
func (e *LaneNotFoundError) Error() string
```

- 返回值类型：`string`

## `LaneFingerprintError` {#LaneFingerprintError}

```go
type LaneFingerprintError struct {
    Name         string
    Ours, Theirs uint64
}
```

LaneFingerprintError 表示提供方的契约不是消费方要的那一个。

### `LaneFingerprintError.Error` {#LaneFingerprintError.Error}

```go
func (e *LaneFingerprintError) Error() string
```

- 返回值类型：`string`

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

一次可否决发布的结果。

## `CallErrorKind` {#CallErrorKind}

```go
type CallErrorKind int
```

说明一次服务调用为什么失败。

| 名称 | 值 | 说明 |
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

一项已注册的服务，以及提供它的模组。

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

LaneInfo 是一条已发布快速通道的登记记录。
