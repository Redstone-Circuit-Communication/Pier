## 04be2d328f

> core.zig: the handshake, the slot gate, strings, logging, tasks, events, commands and
> the cross-mod channels of the Zig binding.
>
> Zig calls the host's function pointers directly, so there is no generated layer between:
> `slot("name")` is the function pointer of that slot, gated by both checks of contract
> section 10, and every other function here is built on it.

core.zig：Zig 绑定的握手、槽位关卡、字符串、日志、任务、事件、命令和跨模组通道。

Zig 直接调用宿主的函数指针，中间没有生成的那一层：`slot("name")` 就是那个槽位的函数指针，经过契约第 10 节的两道检查，这里的其他函数都建立在它之上。

## b4c3ed02c6

> The function pointer of slot `name`, or null when the host's table is too short to hold
> it or the slot is NULL. Every slot of abi.h is reachable this way.

名为 `name` 的槽位的函数指针；宿主的表太短、放不下这个槽位，或者槽位为 NULL 时返回 null。abi.h 的每一个槽位都可以这样取到。

## 52977a15c0

> The caller's own mod handle, for a slot that takes one.

调用方自己的模组句柄，供需要它的槽位使用。

## c18aee85e8

> A Zig slice as a PierStr; the host reads it during the call only.

把 Zig 切片当作 `PierStr`；宿主只在调用期间读取它。

## 3676bdcd83

> A PierStr as a slice, valid only during the callback that received it.

把 `PierStr` 当作切片，只在收到它的那次回调期间有效。

## 7da910a24a

> Writes one line through this mod's LeviLamina logger. Safe from any thread.

通过这个模组的 LeviLamina 日志器写一行。可以在任何线程调用。

## 8cf6b88334

> log with std.fmt formatting, into a buffer of 2048 bytes.

用 `std.fmt` 格式化的 `log`，写进一个 2048 字节的缓冲区。

## 4ef05d7b32

> Exports pier_main for mod type M, named `name` in the log. Call it from the root file:
>
>     comptime { levilamina.exportMod(MyMod, "my-mod"); }
>
> M declares any of `pub fn load`, `enable`, `disable` and `unload`, each taking a
> `*levilamina.Context` and returning `!void`; an error is logged and refuses the step.

为模组类型 `M` 导出 `pier_main`，在日志里以 `name` 命名。在根文件里调用：

```zig
comptime { levilamina.exportMod(MyMod, "my-mod"); }
```

`M` 可以声明 `pub fn load`、`enable`、`disable` 和 `unload` 中的任意几个，每个都接收 `*levilamina.Context`，返回 `!void`；返回错误时会记录日志，并拒绝这一步。

## 97aea70c59

> Runs `task` on the server thread as soon as it can. Safe from any thread. The task
> belongs to this mod: if the mod unloads first, the host drops it and it never runs.

尽快在服务器线程上运行 `task`。可以在任何线程调用。任务属于这个模组：模组先卸载的话，宿主会丢掉这个任务，它永远不会运行。

## 85a8f3a5d1

> Runs `task` on the server thread after delay_ms, under the ownership of schedule.

在 `delay_ms` 毫秒后于服务器线程上运行 `task`，归属规则和 `schedule` 一样。

## c26e70aced

> Voids a task that has not run; false for one that ran, was cancelled or is not this mod's.

作废一个还没运行的任务；已经运行过、已经取消过，或者不属于这个模组的任务返回 false。

## 735facfae9

> This mod's tasks that have not run. A host that cannot count returns an error.

这个模组还没运行的任务数。宿主数不出来时返回错误。

## 4b83dc16d0

> The ABI as translate-c read it from abi.h: every type, slot and constant.

translate-c 从 abi.h 读出来的 ABI：所有的类型、槽位和常量。

## 78456832c8

> A task id, for cancel.

任务 id，供 `cancel` 使用。

## 8cbffdfc07

> Gathers what a PierStrSink receives during one call, each piece copied with allocator.

收集一次调用期间 `PierStrSink` 收到的内容，每一段都用 `allocator` 复制一份。

## f901d6f9d5

> The PierStrSink to hand the host, with a *Collector as its ctx.

交给宿主的 `PierStrSink`，`ctx` 是一个 `*Collector`。

## cfb239ae6b

> The last piece, owned by the caller; NoAnswer when the sink received nothing.

最后一段，归调用方所有；输出回调什么都没收到时返回 `NoAnswer`。

## ad9ebb6deb

> The last piece, or an empty owned slice when the sink received nothing.

最后一段；输出回调什么都没收到时，返回一个归调用方所有的空切片。

## d55b2a51f8

> Every piece, owned by the caller with the slice holding them.

所有的段，连同装着它们的切片，都归调用方所有。

## cf5cffd612

> What a lifecycle step receives.

生命周期的每一步收到的东西。

## 3c4b798980

> Why a call failed. A read the host cannot answer returns NoAnswer.

调用失败的原因。宿主答不上来的读取返回 `NoAnswer`。

## fb2424e285

> The levels of the log slot, which mirror ll::io::LogLevel.

`log` 槽位的日志级别，对应 `ll::io::LogLevel`。

## 19e087631e

> Calls `handler` for every event with this id, on the server thread. Server thread only.

对这个 id 的每一个事件，在服务器线程上调用 `handler`。只能在服务器线程调用。

## a393791e97

> One event as a listener receives it; id and snbt are valid during the callback only.

监听器收到的一个事件；`id` 和 `snbt` 只在回调期间有效。

## 03201b1d42

> Writes keys back into the event, as SNBT of only the keys that change; the host
> merges them, so two listeners writing different keys keep both.

把键写回事件里，SNBT 中只放要改的键；宿主会合并它们，所以两个监听器写不同的键时，两边的改动都会保留。

## 23581b7ff1

> Asks the host to cancel the event. An event that cannot be cancelled ignores it.

请求宿主取消这个事件。不能取消的事件会忽略这个请求。

## 86464487a8

> One subscription, kept to end it.

一个订阅，保存下来用来结束它。

## ebf42359ae

> Ends the subscription; calling it twice is harmless. Server thread only.

结束订阅；调用两次也没有问题。只能在服务器线程调用。

## dbefd67589

> Listener order, mirroring ll::event::EventPriority.

监听器的顺序，对应 `ll::event::EventPriority`。

## 455569bfa5

> Registers /name, whose text after the name reaches handler as args. Call it from enable.

注册 `/name`，命令名之后的文本作为 `args` 交给 `handler`。请在 `enable` 里调用。

## ab7afc74b5

> Runs cmd as the console. Server thread only. The output lines are logged at debug level;
> a false from the host, a level that is not ready, is Refused.

以控制台的身份运行 `cmd`。只能在服务器线程调用。输出的每一行按 debug 级别记进日志；宿主返回 false（世界还没就绪）时得到 `Refused`。

## 16de8a361b

> Registers a static enum, each value a name and a number, for a parameter to reference.

注册一个静态枚举，每个值是一个名字加一个数字，供参数引用。

## c28d561c16

> Registers a soft enum, one whose values can change at runtime, for a parameter to reference.

注册一个软枚举，它的值可以在运行时改变，供参数引用。

## 1b3da15929

> Changes the values of a soft enum. Refused for a name that was never registered.

修改软枚举的值。名字从未注册过时返回 `Refused`。

## 91d6db6875

> One run of a typed command. Valid during the handler only.

一个带类型的命令的一次运行。只在处理函数执行期间有效。

## b3c2bfbf8b

> The raw argument text, the SNBT the host handed over.

原始的参数文本，也就是宿主交过来的 SNBT。

## 3f02d446c3

> Sends one success output.

发送一条成功输出。

## 3d9d600106

> Sends one error output, a separate channel the client colors differently.

发送一条错误输出，这是一条独立的通道，客户端会用不同的颜色显示。

## 2c4db030cf

> Which overload matched, counting from 0.

匹配到的是第几个重载，从 0 数起。

## 0ffcb836f9

> Reads a named argument. An omitted optional argument gives null.

按名字读取一个参数。省略了的可选参数得到 null。

## 45de8479dd

> The origin of the run.

这次运行的来源。

## 96c40ec3e2

> A literal: a fixed word the player types, and a node in the command tree.

字面量：玩家要输入的一个固定单词，也是命令树里的一个节点。

## 520a317b15

> A command with typed overloads. `name` and `description` are borrowed and must outlive the
> registration.

带类型重载的命令。`name` 和 `description` 只是借用，必须比注册活得更久。

## e63dfd9dfb

> Adds one overload. At least one is required.

添加一个重载。至少需要一个。

## d6e847723f

> Registers it, from enable. A command with no overload is Refused, since the host refuses
> outright; the plain `registerCommand` is for a command with no argument. A name that is
> taken with a different shape, or a misspelled parameter type, is Refused as well.

注册它，在 enable 里调用。没有任何重载的命令会得到 `Refused`，因为宿主会直接拒绝；没有参数的命令用普通的 `registerCommand`。名字已被占用而形状不同，或者参数类型拼错了，同样得到 `Refused`。

## a12fa4a256

> One run of a command; valid during the callback only.

一次命令的执行；只在回调期间有效。

## 40d3b7adba

> Sends a line of output.

发送一行输出。

## cafaae6467

> Sends a line of error output.

发送一行错误输出。

## 360375182d

> The player name when the origin is a player.

来源是玩家时的玩家名。

## 70208c442f

> The type of one parameter inside one overload.

一个重载里某个参数的类型。

## 38e1091679

> The spelling on the ABI. The host dispatches on this string, and a typo drops the whole
> command.

它在 ABI 上的拼写。宿主按这个字符串分派，拼错一个字母整条命令都会被丢掉。

## 94a705d731

> Who may run a command, mirroring CommandPermissionLevel.

谁可以运行一条命令，对应 `CommandPermissionLevel`。

## 364b0095c5

> How `updateSoftEnum` changes the values of a soft enum.

`updateSoftEnum` 怎样修改软枚举的值。

## 214104951d

> Which stage the server is in. Thread safe: any thread may ask.

服务器处于哪个阶段。线程安全：任何线程都可以问。

## 7bd44192dc

> The current server tick. NoAnswer while the level is not ready.

当前的服务器 tick。level 尚未就绪时为 `NoAnswer`。

## a59dac4534

> How many players are connected.

当前连接了多少名玩家。

## bea5b1f492

> The wall-clock period of the last frame in seconds. At 20 TPS it is 0.05.

上一帧的挂钟周期，单位为秒。20 TPS 时是 0.05。

## 4c2a99541f

> Ticks per second over the last 5 seconds of wall clock.

最近 5 秒挂钟时间内的每秒 tick 数。

## 0a461f1c08

> As `tps`, over a window of `window_seconds`, from 1 to 60 and clipped by the host.

同 `tps`，窗口为 `window_seconds` 秒，取值 1 到 60，超出时由宿主截断。

## 474eae13db

> Milliseconds spent computing each tick, averaged over the last 5 seconds.

最近 5 秒内，每个 tick 平均花在计算上的毫秒数。

## 5a60a7fbf8

> As `mspt`, over a window of `window_seconds`, from 1 to 60 and clipped by the host.

同 `mspt`，窗口为 `window_seconds` 秒，取值 1 到 60，超出时由宿主截断。

## 1b3c12d20b

> Takes the sampling report as SNBT, owned by the caller; null while the window is still
> open or none was armed. The report is handed out once per window.

取出采样报告，SNBT 形式，由调用方持有；窗口还没结束或者根本没有开启采样时为 null。报告在每个窗口里只交出一次。

## 88fcb28c89

> Reads an environment variable of this process, owned by the caller.

读取这个进程的一个环境变量，由调用方持有。

## a10254c2b3

> Whether this host runs under Wine.

这个宿主是否运行在 Wine 下。

## 77eb0e30ec

> The network protocol version of the server, derived from the running build's game version.

服务器的网络协议版本，由正在运行的构建的游戏版本推出。

## 529d9ec8c8

> The protocol the level was last written by. It says how old the save is, not what the
> server speaks.

这个 level 上一次是用哪个协议写入的。它说明存档有多旧，和服务器现在使用什么协议无关。

## 92f7f39300

> The local time of the server.

服务器的本地时间。

## aae910a087

> Every event id the host can currently resolve, each owned by the caller with the slice
> holding them; free them with `core.freeList`.

宿主当前能解析的每个事件 id，每个都由调用方持有，切片也一样；用 `core.freeList` 释放。

## efeb766f0e

> Every online player.

每名在线玩家。

## 1a0a500c28

> The live actors of a dimension; -1 lists every dimension.

一个维度里的存活实体；传 -1 列出所有维度。

## bb4228b754

> Sends a message to every online player.

向每名在线玩家发送一条消息。

## 25f388b6ff

> One online player.

一名在线玩家。

## f9f2d52963

> One live actor of a listing.

一次列举中的一个存活实体。

## da759c5858

> The world time in ticks.

世界时间，单位为 tick。

## f8aee531a1

> Sets the world time natively.

以原生方式设置世界时间。

## e110a16210

> Sets the level and the remaining duration, in ticks, of rain and of lightning.

设置雨和雷各自的强度与剩余时长，时长单位为 tick。

## 6010b4f5d2

> Reads one game rule. An unrecognized rule name is NoAnswer and not some default value.

读取一条游戏规则。规则名不认识时是 `NoAnswer`，不会给出某个默认值。

## 8bcf70cf22

> Writes one game rule from its text form, such as "true" or "300".

用文本形式写入一条游戏规则，例如 "true" 或 "300"。

## 534268df73

> The biome name at one cell, owned by the caller.

一个格子处的生物群系名，由调用方持有。

## c6ae6a8428

> Sets the biome of a region, column by column, and returns how many columns were set.
>
> The corners are given in either order and no y is taken, since Bedrock stores biomes per
> column. A return of 0 means none were set.

逐列设置一个区域的生物群系，并返回设置了多少列。两个角可以按任意顺序给出，不需要 y，因为基岩版按列保存生物群系。返回 0 表示一列也没有设置。

## ba6ee7f458

> The villages in one dimension.

一个维度里的村庄。

## 317df49a41

> The hardcoded generation areas in the loaded chunks within a radius.

一个半径内、已加载区块里的硬编码生成区域。

## 285c10b652

> Whether every chunk covered by the region is in memory.

区域覆盖的每个区块是否都在内存里。

## c6fb389373

> Deletes every save key of a chunk, so the engine regenerates it from the generator on its
> next load. Only an unloaded chunk can be restored this way. Returns how many keys went.

删除一个区块的全部存档键，引擎会在下次加载它时从生成器重新生成。只有未加载的区块可以这样还原。返回删掉了多少个键。

## 3c5af1bed1

> Lists every save key of a chunk, each owned by the caller with the slice holding them.

列出一个区块的全部存档键，每个键由调用方持有，切片也一样。

## 1c036a8309

> Deletes one save key byte for byte. The content is not interpreted.

逐字节删除一个存档键。内容不会被解释。

## b488253608

> Computes a path for an actor to a target cell, as the host's SNBT `{nodes, reached}`. Every
> current host answers NotProvided: pathfinding is not implemented.

为一个实体计算前往目标格子的路径，结果是宿主的 SNBT `{nodes, reached}`。目前所有宿主都返回 `NotProvided`：寻路没有实现。

## 48128ce786

> Reads one block. The name and the SNBT belong to the arena inside the result.

读取一个方块。名字和 SNBT 属于结果里的 arena。

## 58d4b7c497

> Places a block natively with the default update flags. `spec` is a bare name such as
> "minecraft:stone", or full SNBT. An unknown name fails instead of placing a placeholder.

用默认的更新标志以原生方式放置一个方块。`spec` 是裸名字（例如 "minecraft:stone"）或完整的 SNBT。名字不认识时会失败，而不是放一个占位方块。

## 6707ff4422

> Reads the liquid layer of a cell as a block name; an empty layer gives air.

以方块名的形式读取一个格子的液体层；空的液体层得到空气。

## 5fe6db5e89

> Writes the liquid layer of a cell; write "minecraft:air" to clear it.

写入一个格子的液体层；写 "minecraft:air" 可清除它。

## abbf60994f

> Writes a block from serialized NBT, the shape `getBlock` produces.

用序列化的 NBT 写入一个方块，格式就是 `getBlock` 产生的那种。

## 88e18bdc3b

> Writes a block from a name and optional partial states. An empty `states_snbt` means every
> state at its default.

用一个名字加可选的部分状态写入一个方块。`states_snbt` 为空表示每个状态都取默认值。

## 72b3c72f28

> Writes a block entity's NBT back. The cell must already hold the matching block.

把一个方块实体的 NBT 写回去。该格子里必须已经是对应的方块。

## dc3740614f

> Scans a region and collects every block and actor into memory.

扫描一个区域，把每个方块和每个实体收集到内存里。

## ef37bb3da6

> Scans the blocks of a region into a palette plus cells. Each distinct block state is
> serialized once, so a region of a million stone cells costs one SNBT and not a million.

把一个区域的方块扫描成调色板加格子。每种不同的方块状态只序列化一次，所以一百万个石头格子只花一次 SNBT 的代价，而不是一百万次。

## 57769c77a3

> Fills a box with one block and returns how many cells were written. `spec` is a bare name
> or full SNBT, resolved once for the whole box.

用同一种方块填满一个盒子，并返回写入了多少格。`spec` 是裸名字或完整的 SNBT，整个盒子只解析一次。

## a04f7ae030

> Writes many cells in one call and returns how many were written. Each entry of `palette` is
> a block spec resolved once; a cell whose index is out of range, or whose block did not
> resolve, is skipped.

一次调用写入许多格子，并返回写入了多少个。`palette` 的每一项是一个方块规格，只解析一次；索引超出范围、或方块没有解析出来的格子会被跳过。

## 09fdc4df53

> Spawns a mob and returns it.

生成一只生物并返回它。

## 051486ffd1

> Spawns an actor from full NBT, the inverse of `Entity.snapshot`. A `pos` overrides the Pos
> tag. Every current host answers NotProvided: the engine helper that gives a loaded actor
> a fresh unique id is not reachable.

用完整的 NBT 生成一个实体，是 `Entity.snapshot` 的逆操作。`pos` 会覆盖 Pos 标签。目前所有宿主都返回 `NotProvided`：让已加载实体获得新唯一 id 的引擎辅助函数无法访问。

## 2df0dd03f3

> Detonates at a point.

在一个点引爆。

## 6eb6f09c38

> A particle visible across the whole dimension. Showing it to one person only uses
> `spawnParticleFor`.

整个维度都能看到的粒子。只给一个人看用 `spawnParticleFor`。

## 9e97db6191

> A particle shown to one player.

只给一名玩家看到的粒子。

## c7f93b77d3

> Looks up the feet position and dimension of a connected player by name.

按名字查找一名已连接玩家的脚下位置和所在维度。

## 938ba6fe07

> One weather value of a dimension by its PIER_WPROP_* key.

按 PIER_WPROP_* 键读取一个维度的一项天气值。

## bbcde6d023

> The result of one scan: every block of the region and every actor inside it.

一次扫描的结果：区域里的每个方块，以及其中的每个实体。

## 7cf7647be8

> Cells that are not air, by block name.

不是空气的格子数，按方块名判断。

## 2b752b7771

> The result of one `scanIndexed`: every distinct block state once, and one cell for each
> position holding an index into the palette.

一次 `scanIndexed` 的结果：每种不同的方块状态一份，以及每个位置一个指向调色板的索引。

## 1d44cda8e4

> The palette entry of a cell, or null for an index the palette does not have.

一个格子对应的调色板条目；索引不在调色板里时为 null。

## e2985e63db

> The sleep status of the players.

玩家们的睡眠状态。

## d2b3aec59c

> One hardcoded generation area: a stronghold, a witch hut, an ocean monument or a similar structure.

一个硬编码的生成区域：要塞、女巫小屋、海底神殿或类似的结构。

## 441831a2b0

> One block as the host reports it.

宿主报告的一个方块。

## 05adbf2cba

> One distinct block state met by `scanIndexed`.

`scanIndexed` 遇到的一种不同的方块状态。

## 4fc9ae996b

> One cell of `scanIndexed` or `setBlocks`: a position and an index into a palette.

`scanIndexed` 或 `setBlocks` 的一个格子：一个位置加上调色板里的一个索引。

## 14747479ca

> What an explosion does and who caused it.

一次爆炸做什么、由谁引起。

## bc7dad4c9d

> One player, named by a selector.

一名玩家，由选择器指定。

## dc23afd3a4

> Runs cmd as this player, with the player's own permission level. Server thread only.
> The output lines are logged at debug level; a false from the host, a player who is
> offline or a level that is not ready, is Refused.

以这个玩家的身份运行 `cmd`，用他自己的权限等级。只能在服务器线程调用。输出的每一行按 debug 级别记进日志；宿主返回 false（玩家不在线或世界还没就绪）时得到 `Refused`。

## 6a9cae342d

> Resolves the selector to the player's actor, which gives the calls of `Entity`. NoAnswer when the player is offline.

把选择器解析成这名玩家对应的实体，这样就可以使用 `Entity` 的各个调用。玩家不在线时为 `NoAnswer`。

## a74c466c02

> Whether the selector resolves to anyone online now.

这个选择器现在是否能解析到某名在线玩家。

## 4ac5221203

> The connection id of this player, the same number a packet handler sees. NoAnswer when the player is offline or has no network identity.

这名玩家的连接 id，和数据包处理函数看到的是同一个数。玩家不在线、或者没有网络身份时为 `NoAnswer`。

## bc2eccc59a

> Teleports. A custom dimension, with an id of 3 or above, goes through here too, and the host refuses a dimension whose engine instance does not match.

传送。自定义维度（id 为 3 或更大）也走这里，宿主会拒绝引擎实例对不上的维度。

## 81473bad3e

> Sends one message with a given `TextPacketType`.

以给定的 `TextPacketType` 发送一条消息。

## b766a61d6d

> Sends one title. Only a title, a subtitle or an action bar carries text. `times` of null leaves the durations to the host.

发送一个标题。只有标题、副标题和动作栏带文字。`times` 为 null 时持续时间交给宿主决定。

## 4494780610

> Disconnects the player with a reason the client shows.

把玩家踢下线，原因会显示在客户端上。

## bbeb921dc5

> One inventory slot as item SNBT, owned by the caller.

一个背包格子，物品 SNBT 形式，由调用方持有。

## eec4b08cca

> Writes one inventory slot. Refresh the container afterwards, or the client keeps showing the old item.

写入一个背包格子。之后要刷新容器，否则客户端还会继续显示旧物品。

## 391e615bcb

> The item in hand as item SNBT, owned by the caller.

手里的物品，物品 SNBT 形式，由调用方持有。

## da203ac627

> The full equipment set. For the `slot` numbering see `types.EquipSlot`.

完整的装备。`slot` 的编号见 `types.EquipSlot`。

## 65b507428a

> How many ticks of cooldown one item has left; null when it is not on cooldown.

一个物品还剩多少 tick 的冷却；不在冷却中时为 null。

## ea4cf92b31

> The feet position and the dimension. It goes through a dedicated slot and not a property number, because a position needs three numbers and an id at once.

脚下位置和所在维度。它走专用槽位而不是属性编号，因为位置要同时给出三个数和一个 id。

## 2ba58e8287

> How a Player selector names its player. A decision about permissions, money or ownership
> keys on the xuid: a name can change hands.

`Player` 选择器用什么来指定玩家。关于权限、金钱或归属的判断，要以 xuid 为键：名字会换主人。

## 833ed6a65f

> One actor, named by its unique id, the uid of event payloads.

一个实体，由它的唯一 id 指定，也就是事件载荷里的 uid。

## 8923ca6bc6

> The whole actor as SNBT, owned by the caller.

整个实体的 SNBT，由调用方持有。

## e764635733

> Clones this actor to a given position.

把这个实体克隆到一个给定的位置。

## ff904b68a0

> The distance between two actors. The host refuses across dimensions.

两个实体之间的距离。跨维度时宿主会拒绝。

## c79f08be26

> Every status effect on this actor.

这个实体身上的每一个状态效果。

## cbd5e8d894

> What is equipped in one slot, as item SNBT owned by the caller.

一个槽位里装备的东西，物品 SNBT 形式，由调用方持有。

## c7a410d8eb

> The vehicle being ridden. Riding nothing gives null and only a missing slot is an error.

正在骑乘的载具。没有骑乘任何东西时为 null，只有槽位缺失才是错误。

## ea35656b28

> Reads one bit of `ActorFlags`.

读取 `ActorFlags` 的一位。

## c8667018ef

> Casts a ray along the line of sight of this actor and reports what it hits. A block hit
> carries a name owned by `allocator`; `RayHit.deinit` frees it.

沿着这个实体的视线射出一条射线，报告它撞到了什么。撞到方块时，名字由 `allocator` 持有，用 `RayHit.deinit` 释放。

## 1a4970ceaf

> As `traceRay`, reporting the hit as a block cell and carrying the face that was hit.

同 `traceRay`，但把命中结果报告为一个方块格子，并带上被击中的那一面。

## 34678c9b78

> One block cell of a dimension.

一个维度里的一个方块格。

## 06ec6507f0

> One block state value by its name, owned by the caller.

按名字读取一个方块状态的值，由调用方持有。

## d16e61148c

> Writes one block state value, given as text.

写入一个方块状态的值，以文本形式给出。

## 0839a54189

> The block entity as SNBT, owned by the caller. NoAnswer when the cell holds none.

方块实体的 SNBT，由调用方持有。该格子里没有方块实体时为 `NoAnswer`。

## efc710f6c4

> The collision shape as the host writes it, owned by the caller.

碰撞形状，按宿主写出的形式，由调用方持有。

## 72886351ef

> An item stack as SNBT, a value: reading it asks the host about that SNBT.

以 SNBT 表示的物品堆，是一个值：读取它，就是拿这段 SNBT 去问宿主。

## d731fd88e2

> Builds an item from a type name and a count, as SNBT owned by the caller.

用类型名和数量构造一个物品，SNBT 形式，由调用方持有。

## 3b6db2cf9d

> Whether two items are the same kind of thing.

两个物品是否是同一种东西。

## c984d271b0

> Runs one transform and returns the new item as SNBT, owned by the caller. This item is unchanged.

执行一次变换，并返回新物品的 SNBT，由调用方持有。原物品不变。

## 68a2a9faef

> Wears the item down by `wear`, breaking it when it runs out.

让物品磨损 `wear` 点，磨完时物品会损坏。

## c48b338472

> Sets the lore, one string per line.

设置物品说明文字，每行一个字符串。

## 2caf979d03

> The blocks the item may break in adventure mode.

物品在冒险模式下可以破坏的方块。

## ace2245377

> The blocks the item may be placed on in adventure mode.

物品在冒险模式下可以放置到的方块上。

## 42436a16f3

> The enchantments on the item.

物品上的附魔。

## fa2d9eed0a

> Replaces the whole enchantment set and returns the new item as SNBT, owned by the caller.
> Every current host answers NotProvided: writing enchantments is not implemented, and
> `withEnchant` is the way to add one.

替换整套附魔，并返回新物品的 SNBT，由调用方持有。目前所有宿主都返回 `NotProvided`：写入附魔没有实现，要添加一个附魔请用 `withEnchant`。

## 99abcdf931

> The custom NBT of the item, the `tag` section, as SNBT owned by the caller. It goes through a dedicated slot and not a string property.

物品的自定义 NBT，也就是 `tag` 部分，SNBT 形式，由调用方持有。它走专用槽位，而不是字符串属性。

## 22edfea72f

> One container on a player.

玩家身上的一个容器。

## 2c9d5bd8ea

> The slot count.

槽位数。

## a28e63ca3b

> What is in one slot, as item SNBT owned by the caller. An empty slot gives the SNBT of
> the air item and is not an error.

一个槽位里的内容，物品 SNBT 形式，由调用方持有。空槽位给出空气物品的 SNBT，不是错误。

## 819952aabb

> Every slot as item SNBT in slot order, owned by the caller; `core.freeList` releases them.

按槽位顺序给出每个槽位，物品 SNBT 形式，由调用方持有；用 `core.freeList` 释放。

## 3941d2e9af

> Writes one slot. Call `refresh` afterwards for a player's container.

写入一个槽位。玩家的容器写完后要调用 `refresh`。

## 78559f94fe

> Puts one in and lets the engine pick the slot.

放进去一个，槽位由引擎挑选。

## 740837c4c8

> Resends the whole container to its owner. A block container has no owner to resend to
> and is Refused.

把整个容器重新发给它的主人。方块容器没有主人可发，会得到 `Refused`。

## d0dde280b5

> A block container has no single owner and therefore cannot be resynchronized.

方块容器没有唯一的主人，所以无法重新同步。

## 62b141cf55

> Creates a dummy objective. It is Refused when one of that name already exists.

创建一个 dummy 计分项。同名的已经存在时得到 `Refused`。

## 883729c529

> Every objective of the scoreboard.

计分板上的每个计分项。

## d643f89b21

> Reads one score; null for a name that has none on this objective.

读取一个分数；这个名字在该计分项上没有分数时为 null。

## 6bc1423430

> Sets a score and returns the value after the write.

设置一个分数，并返回写入后的值。

## d24fa6b573

> Erases the score of this name on this objective, which is not setting it to 0.

抹掉这个名字在该计分项上的分数，这和把它设为 0 不是一回事。

## 4860a126bf

> The name the host dispatches on.

宿主据以分派的名字。

## 7bbc810d06

> What a handler receives: the `user` pointer given at send and the answer.

处理函数收到的东西：发送时给出的 `user` 指针，以及玩家的回答。

## 487131e64d

> A custom form: input fields, toggles, dropdowns and sliders, each named so the answer can
> be read by name. `title` is borrowed and must outlive the send.

自定义表单：输入框、开关、下拉框和滑块，每个控件都有名字，回答可以按名字读取。`title` 只是借用，必须比发送活得更久。

## 62983dd055

> The text of the submit button.

提交按钮上的文字。

## 184a3095dd

> A simple form: a column of buttons. `title` and `content` are borrowed and must outlive
> the send.

简单表单：一列按钮。`title` 和 `content` 只是借用，必须比发送活得更久。

## c66e863c83

> A button with an icon. `image_type` is "path" or "url".

带图标的按钮。`image_type` 是 "path" 或 "url"。

## fe4113d6e8

> Sends it. A form with no button at all is Refused, since a player cannot press it.

发送它。一个按钮也没有的表单会得到 `Refused`，因为玩家无法按下它。

## c170766af2

> The chosen position of a dropdown or a step slider.

下拉框或步进滑块选中的位置。

## 62d82ca247

> The value of one control of a custom form.

自定义表单里一个控件的值。

## ea99a81594

> The text of the selected item of one control of a custom form.

自定义表单里一个控件所选项的文字。

## f76d24d0ce

> The answers of a custom form, one entry per named control.

自定义表单的回答，每个有名字的控件一项。

## 751c35f223

> The value of one control.

一个控件的值。

## 119cb842f6

> The text of the selected item of one control.

一个控件所选项的文字。

## b491a6af2e

> A modal form: some text and two buttons. Every string is borrowed and must outlive the
> send.

模态表单：一段文字加两个按钮。每个字符串都只是借用，必须比发送活得更久。

## 4fcc46c8bb

> One open key-value store. `close` releases it.

一个已打开的键值库。`close` 释放它。

## 2a78815185

> Opens an existing one only. A store that does not exist is Refused and no empty one is
> created in its place.

只打开已经存在的。库不存在时得到 `Refused`，不会替它创建一个空库。

## 66f91dc037

> Closes the store; calling it twice is harmless.

关闭这个库；调用两次也没有害处。

## 6154d1ec8e

> Reads one key, owned by the caller: null for a key that does not exist.

读取一个键，由调用方持有：键不存在时为 null。

## 06e25a74fa

> Every key and value. The whole store is read into memory, so a large one needs care.

每个键和值。整个库会被读进内存，所以大的库要小心。

## cf12a2bf8f

> One key and its value.

一个键和它的值。

## a3a3f20132

> The balance of an account. NoAnswer when the host cannot say: an empty xuid, a database
> error or no backend. Reading an account no one has opened opens it at the default.

一个账户的余额。宿主说不出时为 `NoAnswer`：xuid 为空、数据库出错或没有后端。读取一个没人开过的账户，会按默认值把它开出来。

## ee13e10594

> Sets the balance to a target.

把余额设为目标值。

## 44143e930a

> Transfers between two accounts. An empty `from` or `to` means created from or destroyed
> into nothing. A `from` equal to `to` is refused by the backend, and the amount the payee
> receives is reduced by the configured tax.

在两个账户之间转账。`from` 或 `to` 为空表示从无到有地创造、或销毁为无。`from` 等于 `to` 会被后端拒绝，收款方实际收到的金额要扣除配置的税。

## 4f596a5d00

> The transactions of the last `seconds` seconds, one per line, owned by the caller;
> `core.freeList` releases them.

最近 `seconds` 秒的交易，每行一条，由调用方持有；用 `core.freeList` 释放。

## 72ac6ea1f6

> Clears transactions older than `seconds` seconds.

清除早于 `seconds` 秒的交易。

## c854f27250

> The top `top_n` of the rich list, one per line, owned by the caller; `core.freeList`
> releases them.

富豪榜的前 `top_n` 名，每行一条，由调用方持有；用 `core.freeList` 释放。

## c391244644

> Registers a callback that runs before the event, where returning false vetoes it. Several
> mods may each register one, and the loader removes it when this mod unloads.

注册一个在事件之前运行的回调，返回 false 就否决它。多个 mod 可以各注册一个，这个 mod 卸载时加载器会移除它。

## a42df57c26

> What an economy event does.

一个经济事件做什么。

## 84f25ef861

> One economy event. The two strings are valid during the callback only.

一个经济事件。两个字符串只在回调期间有效。

## 65d9da76a7

> Registers an interceptor for every packet in the chosen directions, chunk data included,
> which costs one call per packet. `interceptIds` costs less when only some ids matter.

为所选方向上的每一个数据包注册一个拦截器，区块数据也在内，每个包都会调用一次。只关心某些 id 时 `interceptIds` 更省。

## ca69493da9

> As `intercept`, but the handler runs only for the listed packet ids, 0 to 1023.

同 `intercept`，但处理函数只对列出的数据包 id 运行，范围 0 到 1023。

## 99b3621b7b

> Sends one packet to a player: the id and the body, without the header.

向一名玩家发送一个数据包：id 和包体，不含包头。

## 5b5e38ef77

> The packet a handler receives. Valid only during the call.

处理函数收到的数据包。只在调用期间有效。

## a080c48e8f

> The peer address as `ip:port`. For diagnostics; use `connId` as a key.

对端地址，形如 `ip:port`。用于诊断；要当键用请用 `connId`。

## 12bf5e4c48

> The body, without the header, since the packet id and sub ids are already decoded.

包体，不含包头，因为数据包 id 和子 id 已经解码出来了。

## 0eb1a2d9f5

> Replaces the body. It may be called several times in one call and the last one wins.

替换包体。一次调用里可以调用多次，以最后一次为准。

## 174f6511de

> A registered packet interceptor or connection observer.

一个已注册的数据包拦截器或连接观察器。

## eb0e13056f

> Deregisters it; calling it twice is harmless. Safe to call from inside the handler.

注销它；调用两次也没有害处。在处理函数里面调用也是安全的。

## 2d4818dc29

> What the handler does with this packet.

处理函数对这个数据包做什么。

## 5545d7c672

> The two states of a connection. A close is the only reliable signal to clear what a mod
> keeps per connection: one that never completed the login handshake never becomes a
> player, and no player event covers it.

一个连接的两种状态。关闭是清理 mod 按连接保存的状态时唯一可靠的信号：没有完成登录握手的连接不会变成玩家，任何玩家事件都覆盖不到它。

## fb314a28d7

> The names of the simulated players alive now, owned by the caller; `core.freeList` releases
> them. A bot that outlived the session that spawned it is found again by name.

现在存活的模拟玩家的名字，由调用方持有；用 `core.freeList` 释放。比生成它的那次会话活得更久的 bot，可以凭名字重新找到。

## aa0366fa03

> One simulated player, named. The name is borrowed and must outlive the value.

一个模拟玩家，用名字表示。名字只是借用，必须比这个值活得更久。

## 0fb5cfc640

> Attaches by name to a simulated player that already exists. It does not check whether one
> does; `isSimulated` does.

按名字附着到一个已经存在的模拟玩家上。它不检查是否真的存在，`isSimulated` 才会检查。

## 3813ba0832

> Whether this name currently points at a live simulated player.

这个名字现在是否指向一个存活的模拟玩家。

## f7384b6631

> Runs one verb. The argument is SNBT, and "{}" is passed when there is none.

执行一个动词。参数是 SNBT，没有参数时传 "{}"。

## b56f85d548

> Paths there. Unlike `moveTo` it goes around obstacles.

寻路前往。与 `moveTo` 不同，它会绕开障碍物。

## 56553ee1d3

> Mines one block. `face` is the face, 1 meaning up.

挖掉一个方块。`face` 是面，1 表示朝上。

## 1d6ccfaff5

> Mines the block in the line of sight. `hand` is the reach, in blocks.

挖掉视线上的方块。`hand` 是触及距离，单位为格。

## a80e47ed04

> Called on the client thread for each press and release of a registered key: the `user`
> pointer given at registration, the action, and the focus impact the engine reports.

已注册按键每次按下和松开时在客户端线程上调用：注册时给出的 `user` 指针、动作，以及引擎报告的焦点影响。

## 27c2423364

> One numeric client property by its PIER_CPROP_* key. NoAnswer for a key this host does
> not know, or a key about the local player while the client is not in a world.

按 PIER_CPROP_* 键读取一个数值型的客户端属性。宿主不认识这个键、或者客户端不在世界里时读取关于本地玩家的键，得到 `NoAnswer`。

## 87c2c2704c

> The local player's feet position: x, y and z.

本地玩家脚下的位置：x、y、z。

## 995c46eb27

> The local player's pitch and yaw in degrees; a negative pitch looks up.

本地玩家的 pitch 和 yaw，单位为度；pitch 为负表示向上看。

## 14d57f4d22

> The topmost screen of the client's screen stack, owned by the caller.

客户端界面栈最顶层的界面，由调用方持有。

## a45a6e8a11

> Every key binding name the key registry holds, whichever mod registered it. The caller
> frees each name and the slice.

按键注册表里所有按键绑定的名字，不论是哪个 mod 注册的。每个名字和切片都由调用方释放。

## 2047dbcd3f

> Shows text in this client's chat. Nothing is sent to a server.

在这个客户端的聊天栏里显示文字。不会向服务器发送任何东西。

## c5c79dc4c2

> Shows text as the title on this client.

在这个客户端上把文字显示为标题。

## 20ffcb4577

> Shows text as the subtitle on this client.

在这个客户端上把文字显示为副标题。

## 51958ddbf5

> Shows text above the hotbar on this client.

在这个客户端的快捷栏上方显示文字。

## 0a1f5d7a6f

> Shows text as a tip on this client.

在这个客户端上把文字显示为提示。

## e5fd28ef28

> Plays a UI sound by name on this client, such as "random.click".

在这个客户端上按名字播放一个界面音效，例如 "random.click"。

## 5976037d46

> Shows a popup; a newline in text separates the message from a subtitle.

显示一个弹出提示；文字里的换行把消息和副标题分开。

## f15293df0b

> Writes text to the developer console.

把文字写入开发者控制台。

## 9a95ad3c00

> Gives the mouse back to the game.

把鼠标交还给游戏。

## de193b1680

> Mutes the client audio.

把客户端静音。

## f08614567a

> Unmutes the client audio.

取消客户端静音。

## 5bf38dc7a8

> Resets the movement input of the local player.

重置本地玩家的移动输入。

## 78be04a7e5

> Writes value to the system clipboard.

把 value 写入系统剪贴板。

## 31056bb673

> Opens How to Play at topic, or at its start for an empty topic.

打开“游戏指南”并定位到 topic，主题为空时打开首页。

## 258156c166

> Every client option. The caller frees each key, each value and the slice.

全部客户端选项。每个键、每个值和切片都由调用方释放。

## 1965221172

> One client option by its options.txt key, owned by the caller.

按 options.txt 里的键读取一个客户端选项，由调用方持有。

## 6043f5f39d

> Writes one client option from its options.txt text form; read it back to see what the
> engine kept.

用 options.txt 的文本形式写入一个客户端选项；读回来才能看到引擎保留了什么。

## 0879baceed

> Registers a key binding under `name` with its default `key_codes`. `allow_remap` lets the
> player rebind it. A name that is taken, or an empty code list, is Refused.

以 `name` 注册一个按键绑定，默认按键码为 `key_codes`。`allow_remap` 允许玩家重新绑定。名字已被占用、或按键码列表为空时得到 `Refused`。

## 7fe737fbcf

> Whether the client is inside a level, which means a world is loaded.

客户端是否在一个 level 里，也就是是否已经加载了世界。

## e5641da2fd

> The name of the local player, owned by the caller. NoAnswer outside a level.

本地玩家的名字，由调用方持有。不在 level 里时为 `NoAnswer`。

## 0b48bbba41

> One registered key binding, kept to drop it.

一个已注册的按键绑定，留着它是为了之后注销。

## 792b7cf4fa

> The key codes currently assigned, which differ from the defaults when the player
> remapped the key. Owned by the caller.

当前分配的按键码；玩家重新映射过按键时，它和默认值不同。由调用方持有。

## 71e3289b05

> Drops the binding: this mod's handler stops firing. The engine keeps one key per name and
> offers no removal, so registering the same name again reuses it. Calling it twice is
> harmless.

注销这个绑定：这个 mod 的处理函数不再触发。引擎对每个名字只保留一个按键，也没有移除的接口，所以再次注册同一个名字会复用它。调用两次也没有害处。

## 2383bec5ba

> What a key binding reports.

一个按键绑定上报的动作。

## 37d3f3122e

> One client option: its options.txt key and its value in that text form.

一个客户端选项：它在 options.txt 里的键，以及那种文本形式的值。

## 778a410f6a

> Whether the host answers the native calls, which its config.json decides.

宿主是否响应原生调用，由它的 config.json 决定。

## 9287c2d5b3

> The first match of a byte pattern such as "48 8B ?? 08" in the engine executable.

字节特征码（例如 "48 8B ?? 08"）在引擎可执行文件中的第一个匹配。

## e4a3353331

> An export of a module already loaded into the process; an empty module names the engine
> executable. LeviLamina's API is an export of LeviLamina.dll.

进程中已加载模块的一个导出；`module` 为空表示引擎可执行文件。LeviLamina 的 API 是 LeviLamina.dll 的导出。

## 3d389e6f4f

> The engine's Player object of an online player, valid while the player stays online.

在线玩家对应的引擎 Player 对象，玩家在线期间有效。

## 11a407cefe

> The engine's Actor object of a loaded actor.

已加载实体对应的引擎 Actor 对象。

## ea5742cec8

> The engine's Dimension object of a dimension id.

维度 id 对应的引擎 Dimension 对象。

## c4c496dd57

> Installs detour on target at a priority_* value. detour must be a callconv(.c) function
> with the exact signature of target, and it reaches the engine through original only. The
> host removes a detour this mod still holds when the mod unloads, and does not wait for a
> call already inside it on another thread.

在 `target` 上以某个 priority_* 值安装 detour。detour 必须是与 target 签名完全一致的 callconv(.c) 函数，并且只能通过 original 调用引擎。mod 卸载时宿主会移除它仍持有的 detour，已经在其他线程上进入 detour 的调用不会被等待。

## 02216eee0c

> core.Error plus the four answers of a native slot other than PIER_NATIVE_OK.

core.Error 再加上原生槽位除 PIER_NATIVE_OK 之外的四种回答。

## 809e6ab85b

> The priorities of ll::memory::HookPriority, for hookInstall.

ll::memory::HookPriority 的各个优先级，供 hookInstall 使用。

## 5378f879db

> The engine service objects `object` hands out. The two client kinds are not found on a
> server host.

`object` 能取得的引擎服务对象。两个仅客户端的种类在服务端宿主上找不到。

## 88a2b77142

> One installed detour: the id hookRemove takes, and the address through which the detour
> calls the next detour or the engine.

一个已安装的 detour：hookRemove 使用的 id，以及 detour 用来调用下一个 detour 或引擎的地址。

## 6d084de358

> A generator for `addDimensionGenerated`. Returning false means the chunk could not be
> filled; the host writes air and logs it. It runs on chunk threads, so it must not touch
> state another thread writes.

`addDimensionGenerated` 用的生成器。返回 false 表示这个区块没能填充；宿主会写入空气并记一条日志。它运行在区块线程上，所以不能碰别的线程会写的状态。

## 07a9bf646b

> Whether this host was built with the custom dimension capability. A host that answers
> true here can still refuse a registration when the engine's layout does not match.

这个宿主是否带有自定义维度的能力。这里回答 true 的宿主，在引擎布局对不上时仍然可能拒绝一次注册。

## 76e2c91885

> Looks up a dimension id by name; null for a name nothing registered.

按名字查找维度 id；没有任何东西注册过这个名字时为 null。

## 9b52d125b1

> Every registered custom dimension.

每个已注册的自定义维度。

## 2631e10075

> Reads one rule. A dimension with no explicit entry for that rule gives null, which is
> not the same as false.

读取一条规则。某个维度没有该规则的显式条目时给出 null，这和 false 不是一回事。

## 65a35a1a10

> Replaces the merge marks of a dimension as a whole. Only plots that carry a marker need to
> be listed.

整体替换一个维度的合并标记。只需要列出带标记的地块。

## c41d764e27

> Adds a custom dimension with a native terrain from one declarative spec, and returns its id.
> The reason for a refusal is in the host log.

用一份声明式规格添加一个原生地形的自定义维度，并返回它的 id。被拒绝的原因在宿主日志里。

## e00fec58a3

> Adds a custom dimension whose terrain is a terrain pack: a directory with a config file and
> a binary built by tools/pier-pack. `config_path` is relative to the server root, with
> forward slashes, no `..` and not absolute.

添加一个地形来自地形包的自定义维度：地形包是一个目录，里面有一个配置文件和一个由 tools/pier-pack 生成的二进制文件。`config_path` 相对于服务器根目录，使用正斜杠，不含 `..`，也不是绝对路径。

## dd520c7c8f

> Retires a custom dimension: it is dropped from the host's tables and from
> dimension_config.json, so nothing registers it on the next boot. The chunks it wrote stay.
> Returns whether one by that name was registered.

注销一个自定义维度：把它从宿主的表和 dimension_config.json 里去掉，下次启动时就不会再有东西注册它。它写出的区块保留。返回是否存在这个名字的已注册维度。

## a369591499

> Registers a dimension whose terrain the mod fills itself, and returns its id. `spec_snbt`
> carries only seed, height and sky. Entry 0 of `materials` must be "minecraft:air", which
> the host reads as nothing written. `user` must stay valid for as long as the dimension
> lives, which is the host's lifetime and not the mod's.

注册一个地形由 mod 自己填充的维度，并返回它的 id。`spec_snbt` 只带种子、高度和天空。`materials` 的第 0 项必须是 "minecraft:air"，宿主把它读作“没有写入”。`user` 必须在维度存活期间一直有效，这是宿主的生命周期，不是 mod 的。

## c6ba28aa6f

> Gives a generated dimension the cell geometry its confinement rules use. `cell` is the edge
> of a cell and `gap` the space between cells, both in blocks. A `cell` of 0 removes the
> geometry. Refused for a dimension this host did not register.

给一个生成出来的维度设置它的限制规则所用的单元几何。`cell` 是单元的边长，`gap` 是单元之间的间隔，单位都是方块。`cell` 为 0 表示去掉这个几何。对这个宿主没有注册过的维度得到 `Refused`。

## 405e6347d8

> The vanilla generator of a `terrain:{kind:"native"}` spec.

`terrain:{kind:"native"}` 规格所用的原版生成器。

## 9ccf5e13ac

> What the engine itself calls this generator. Not the same string as `specName`.

引擎自己对这个生成器的叫法。和 `specName` 不是同一个字符串。

## d939b8e0fa

> Assembles a mask from the four directions in the order north, east, south, west.

按北、东、南、西的顺序，用四个方向拼出一个掩码。

## 040d1bbc61

> Why the host refused a terrain pack; the values are `PIER_PACK_*`.

宿主为什么拒绝一个地形包；取值是 `PIER_PACK_*`。

## 48e5aa7084

> Per-dimension rules. The values correspond to `PIER_DIMRULE_*`.

按维度生效的规则。取值对应 `PIER_DIMRULE_*`。

## e3026c1155

> The outcome of registering a terrain pack: its dimension id, or why it was refused.

注册一个地形包的结果：它的维度 id，或者被拒绝的原因。

## cfe9d75182

> What a pack asks for, as the JSON document `md_pack_inspect` describes, without registering
> anything. The text is owned by the caller. A refusal gives its status and, when the host
> wrote one, its reasons in `problems`, owned by the caller as well.

一个地形包提出的要求，格式是 `md_pack_inspect` 描述的那份 JSON 文档，不会注册任何东西。文本由调用方持有。被拒绝时给出状态，宿主写了原因的话还给出 `problems`，同样由调用方持有。

## 856ac4cd93

> What the host asks a generator to fill: one chunk. `materials` has `256 * height` entries,
> indexed `(x * 16 + z) * height + y` with y counted from `min_y`, and `biomes` has 256, one
> per column. Both hold indices into the two palettes given at registration, and material 0
> is air.

宿主要求生成器填充的内容：一个区块。`materials` 有 `256 * height` 项，按 `(x * 16 + z) * height + y` 索引，y 从 `min_y` 起算；`biomes` 有 256 项，每列一项。两者存的都是注册时给出的两张调色板里的索引，材质 0 是空气。

## e88831dcbc

> The lane protocol version this binding speaks.

这个绑定使用的快速通道协议版本。

## be2abf5dd3

> Calls `handler(topic, payload)` for every message on topic, from mods of any language, on
> the publisher's thread. It returns a veto: true refuses a vetoable publish and false has
> no opinion, and a plain publish ignores it. Namespace topics, as "plot:enter".

对 `topic` 上的每一条消息调用 `handler(topic, payload)`，消息可以来自任何语言写的模组，在发布方的线程上调用。返回值是否决：true 拒绝一次可否决的发布，false 表示没有意见，普通的发布忽略它。主题请加命名空间，比如 `"plot:enter"`。

## 517aa44a45

> Sends payload to every subscriber of topic and returns how many ran; 0 means nobody is
> listening, which is not an error.

把 `payload` 发给 `topic` 的每一个订阅者，返回运行了多少个；0 表示没有人在听，这不是错误。

## 58b92587f7

> Sends payload and collects the subscribers' vetoes.

发送 `payload`，并收集订阅者的否决。

## 0f01dbd65a

> How many subscribers topic has now.

`topic` 当前有多少订阅者。

## e1784272fc

> Answers calls to name from mods of any language, and from native plugins through the
> bridge. `provider(request, reply)` runs on the caller's thread, also while this mod is
> disabled but loaded, since consumers resolve services in their own on_load.

回答任何语言写的模组对 `name` 的调用，也回答原生插件经 bridge 发来的调用。`provider(request, reply)` 在调用方的线程上运行；这个模组被禁用、但仍然加载着的时候也会运行，因为使用方会在自己的 `on_load` 里解析服务。

## 6228ac8153

> Calls another mod's service, whatever language it is written in.

调用另一个模组的服务，不管它是用什么语言写的。

## 7a5c520991

> Every registered service as the host's JSON array of {"name","mod"}, owned by the caller.

所有已注册的服务，以宿主给出的 JSON 数组 `{"name","mod"}` 返回，归调用方所有。

## abf528149c

> Inside a provider, the mod whose call is running; null outside one and for a caller with
> no mod, such as a native plugin through the bridge.

在提供方内部，返回正在调用它的模组；在提供方之外，或者调用方没有模组（比如经 bridge 调用的原生插件）时返回 null。

## 1d37399fa3

> Publishes a lane, exclusively under `name`. `fingerprint` is the value of the contract and
> must not be 0, which means anyone may connect and which the host refuses. `table` is the
> provider's table of function pointers, `data` the pointer each of them receives; `retain`
> and `release` count leases on `data`. The lane is withdrawn automatically at unload. A
> name that is taken is Refused, and the host log names the holder.

以 `name` 独占地发布一条快速通道。`fingerprint` 是契约的值，不能是 0：0 表示任何人都可以连接，宿主会拒绝。`table` 是提供方的函数指针表，`data` 是每个函数收到的指针；`retain` 和 `release` 统计对 `data` 的租约。卸载时这条通道会被自动撤回。名字被占用时得到 `Refused`，宿主日志里会写出占用者。

## 37b01ebaf0

> Acquires a lane. `fingerprint` must be the value the consumer computed itself from the
> contract; 0 is not valid and always yields `fingerprint`.

获取一条快速通道。`fingerprint` 必须是消费方自己根据契约算出来的值；0 无效，总是得到 `fingerprint`。

## 0d98485bfd

> The raw JSON of the lane listing, unparsed, owned by the caller.

快速通道列表的原始 JSON，未经解析，由调用方持有。

## d426f4a4d7

> A lease on a published lane, kept to return it.

对一条已发布通道的租约，留着它是为了归还。

## b415d64c21

> Whether the provider is still there.

提供方是否还在。

## c85d02a1fe

> Enters the provider for one call. Null when the provider is gone. The caller makes its
> calls through the guard and then `leave`s, so the provider cannot unload underneath a
> call that is running:
>
>     if (lease.enter()) |inside| {
>         defer inside.leave();
>         inside.table(MyTable).hello(inside.data);
>     }

为一次调用进入提供方。提供方已经不在时为 null。调用方通过这个守卫发起调用，之后 `leave`，这样提供方就不会在调用进行时被卸载：if (lease.enter()) |inside| { defer inside.leave(); inside.table(MyTable).hello(inside.data); }

## 3e054df400

> Returns the lease. Only a lease this mod holds. False when the provider is already gone,
> since the loader has released it by then and releasing again would be a double free.

归还租约。只能是这个 mod 持有的租约。提供方已经不在时为 false，因为加载器那时已经释放过它，再释放一次就是重复释放。

## 95a56cb38a

> One call inside a provider. `leave` ends it.

提供方内部的一次调用。`leave` 结束它。

## aef85f4b04

> The provider's table, which the contract names the type of.

提供方的函数表，它的类型由契约指定。

## 214d80f22c

> The pointer each function of the table receives.

函数表里每个函数收到的指针。

## 6e306daad0

> One bus subscription, kept to end it.

一个总线订阅，保存下来用来结束它。

## 5efa88486b

> Ends the subscription; calling it twice is harmless.

结束订阅；调用两次也没有问题。

## f43d143c3a

> The way a service provider answers: send the reply and return true, or send the reason
> and return false, which the caller receives unchanged as the provider's message.

服务提供方回答的方式：发送回答并返回 true；或者发送原因并返回 false，调用方会原样收到这段文字，作为提供方的错误信息。

## 3c09df2169

> One service this mod provides, kept to withdraw it.

这个模组提供的一项服务，保存下来用来撤回它。

## 9d6528c371

> Withdraws the service; calling it twice is harmless.

撤回这项服务；调用两次也没有问题。

## 9d8b0c9ea9

> One publication. `withdraw` takes the lane back.

一次发布。`withdraw` 把通道收回来。

## 667ac5b533

> Withdraws the lane; calling it twice is harmless. Every outstanding lease is released and
> a consumer's next liveness check sees the lane gone.

撤回这条通道；调用两次也没有害处。所有未归还的租约都会被释放，消费方下一次存活检查就会看到通道已经没了。

## 4e0e43b15c

> The result of one vetoable publish. There is no short circuit: after a veto the later
> subscribers still receive the message.

一次可否决发布的结果。不会提前结束：有订阅者否决以后，后面的订阅者仍然会收到消息。

## 6c183efdd0

> How a service call ended, matching the PIER_SERVICE_* results.

一次服务调用的结束方式，和 `PIER_SERVICE_*` 的结果一一对应。

## 7ff192dcde

> One service call's outcome. body is the reply for ok and the provider's message for
> provider_error, owned by the caller.

一次服务调用的结果。`code` 为 ok 时 `body` 是回答，为 provider_error 时 `body` 是提供方的错误信息，归调用方所有。

## bfbc8db973

> How acquiring a lane ended.

获取一条快速通道的结果。

## d650cc3956

> Every command the engine's registry holds, whichever mod registered it.

引擎注册表里的每一条命令，不论是哪个 mod 注册的。

## 3b89db6dff

> nbt.zig: SNBT parsing and writing for Zig mods, with the rules of the Rust and Go
> bindings: a bare number is an int, then a long, then a double; a suffix b, s, l, f or d
> fixes the type; true and false are bytes; any other bare word is a string.

nbt.zig：Zig 模组的 SNBT 解析和写出，规则和 Rust、Go 绑定一样：不带后缀的数字依次尝试 int、long、double；后缀 b、s、l、f 或 d 指定类型；true 和 false 是字节；其他不带引号的单词是字符串。

## 10e3f80f5f

> Parses SNBT. Every node is allocated with `arena`, which the caller frees as a whole; a
> bare string or key may also point into `text`, which must outlive the result.

解析 SNBT。每个节点都用 `arena` 分配，由调用方整体释放；不带引号的字符串或键也可能直接指向 `text`，所以 `text` 必须比结果存活得更久。

## 0e8d62deb5

> Encodes SNBT as binary NBT, owned by the caller. Refused for text the host cannot parse.

把 SNBT 编码成二进制 NBT，由调用方持有。宿主解析不了的文本得到 `Refused`。

## 5bf4869cfc

> Decodes binary NBT as SNBT, owned by the caller. Refused for bytes that are not NBT.

把二进制 NBT 解码成 SNBT，由调用方持有。不是 NBT 的字节得到 `Refused`。

## f6510f6a08

> The deepest nesting accepted, the cap Minecraft puts on NBT. A deeper payload is refused
> instead of exhausting the stack of a host thread.

接受的最大嵌套深度，和 Minecraft 对 NBT 的上限一样。更深的数据会被拒绝，以免耗尽宿主线程的栈。

## 046405909b

> Builds SNBT text the way the Rust and Go bindings write it, so the host's stricter parser
> accepts it: every key is quoted, every number carries its type suffix, and a control
> character is written as `\uXXXX`.
>
> Open a container, write into it, close it; a key goes before each value of a compound.
> The writer does not check that the calls balance.

按 Rust 和 Go 绑定的写法生成 SNBT 文本，这样宿主更严格的解析器才会接受：每个键都加引号，每个数字都带类型后缀，控制字符写成 `\uXXXX`。打开一个容器，往里写，再关闭它；复合标签里每个值前面要先写键。写入器不检查调用是否配对。

## b0ca94a4a3

> The text written so far.

到目前为止写入的文本。

## 5e6767168f

> The finished text, owned by the caller. The writer is empty afterwards.

写完的文本，由调用方持有。之后写入器是空的。

## 7f2377bcde

> Writes the key of the next entry of the open compound.

写下打开着的复合标签里下一项的键。

## 74a0a70db2

> A boolean is a byte, 1b or 0b.

布尔值是一个字节，1b 或 0b。

## 8b58a059b3

> A double always carries its decimal point and its `d`. A value SNBT cannot express, NaN
> or an infinity, is written as 0.0.

double 总是带着小数点和 `d`。SNBT 表达不了的值，NaN 或无穷大，写成 0.0。

## 39c2107cb9

> Inserts text that is already SNBT, one value or several separated by commas, in the place
> of one value.

插入已经是 SNBT 的文本，可以是一个值，也可以是用逗号分隔的多个值，占据一个值的位置。

## 528b02bb81

> One SNBT value. Typed arrays hold their numbers as i64 whatever the element width.

一个 SNBT 值。带类型的数组不论元素多宽，都用 i64 保存数字。

## d97f247bb3

> Follows a dotted path through compounds; null when a step is missing.

沿着用点分隔的路径穿过复合标签；某一步不存在时返回 null。

## 6ab7a0f1e8

> The string at path, or null when it is absent or not a string.

`path` 处的字符串；不存在或者不是字符串时返回 null。

## 6e187c4b47

> The integer at path of any width, or null when it is absent or not one.

`path` 处任意宽度的整数；不存在或者不是整数时返回 null。

## c81472d687

> The number at path, integer or floating, or null when it is absent.

`path` 处的数字，整数或浮点数都可以；不存在时返回 null。

## da0eb67675

> The byte at path read as a boolean, or null when it is absent or not 0 or 1.

把 `path` 处的字节当作布尔值读取；不存在，或者不是 0 或 1 时返回 null。

## 3b3299023d

> One key of a compound and its value.

复合标签的一个键和它的值。

## 19c5e4ab27

> The binary form of an NBT payload.

一份 NBT 数据的二进制形式。

## 4566677b67

> Notify the neighbors, meaning redstone, liquid flow and block updates.

通知相邻方块，包括红石、液体流动和方块更新。

## 37b886af6d

> Synchronize to the client.

同步给客户端。

## 9d2b5170ab

> Both, equivalent to `/setblock`.

两者都做，等同于 `/setblock`。

## cebbae1313

> Neither. For a bulk fill, resynchronizing afterwards.

都不做。用于批量填充，之后再重新同步。

## 7250cb500d

> A list or a record the host produced, whose memory belongs to one arena: `deinit` frees all
> of it, every string included.

宿主产生的一个列表或一条记录，它的内存属于同一个 arena：`deinit` 会把它全部释放，每个字符串都包括在内。

## 578ff426f2

> The box spanned by two corners given in either order.

由两个角张成的盒子，两个角按任意顺序给出都可以。

## 6e4c1b4b50

> The number of cells along each axis.

每个轴上的格子数。

## 1eb6160f09

> The number of cells in the box.

盒子里的格子数。

## 3ff314f59d

> Whether the cell is inside the box.

这个格子是否在盒子里。

## ab28f0ef45

> The cell of a block hit.

方块命中的格子。

## 4522592325

> The id of an actor hit.

命中的实体的 id。

## 60375a389b

> Frees the block name, which belongs to the allocator the trace was given.

释放方块名，它属于追踪时给出的分配器。

## 8948e541e2

> The game mode. The values are part of the ABI, through `player_set_gamemode`.
>
> Note that `spectator` is 6 and not 3: the values in between mean other things in the
> engine, and guessing one from the order sets the player to a different mode.

游戏模式。取值是 ABI 的一部分，通过 `player_set_gamemode` 传递。注意 `spectator` 是 6 而不是 3：中间的值在引擎里另有含义，按顺序猜一个值会把玩家设成另一个模式。

## 01f6b94a19

> The `SetTitlePacketPayload::TitleType` of `player_send_title`.

`player_send_title` 的 `SetTitlePacketPayload::TitleType`。

## 35b5673dfa

> Whether this kind carries text.

这种类型是否带文字。

## 29158a8b16

> A player ability bit. The index of `PIER_PACT_SET_ABILITY` and `PIER_PACT_CAN_USE_ABILITY`.
>
> The three carrying `speed` are floating-point abilities and the rest are boolean.

玩家的一个能力位。是 `PIER_PACT_SET_ABILITY` 和 `PIER_PACT_CAN_USE_ABILITY` 的索引。带 `speed` 的三个是浮点能力，其余是布尔能力。

## 9ccba54945

> Whether the ability holds a number and not a flag.

这个能力保存的是数字还是标志。

## dff1682bf9

> The `TextPacketType` of `player_send_message_typed`.
>
> The host falls back to `raw` on an out-of-range value, so no fallback branch is needed here.

`player_send_message_typed` 的 `TextPacketType`。取值超出范围时宿主回退到 `raw`，所以这里不需要回退分支。

## dbdba3a871

> The three title durations, in ticks.
>
> All three are given together or not at all: the host refuses a half-specified combination
> rather than guessing the rest for the caller.

三个标题持续时间，单位为 tick。三个要么一起给出、要么都不给：宿主会拒绝只给一半的组合，而不是替调用方猜剩下的。

## b27e1616ac

> Tells the engine which follow-up work a block write needs.

告诉引擎一次方块写入需要做哪些后续工作。

## 1bc82c8ed0

> One attribute of an entity as `Entity.attributeInfo` reads it.

一个实体的一项属性，即 `Entity.attributeInfo` 读到的内容。

## 1ebc2d95d2

> The network status of a player, from `PIER_PSTR_NETWORK_STATUS`. A value the host could not
> measure is -1.

一名玩家的网络状态，来自 `PIER_PSTR_NETWORK_STATUS`。宿主测不出来的值是 -1。

## 051084ba4f

> One slot of a player's equipment.

玩家装备的一个槽位。

## ff18ac004e

> A player's feet position and the dimension it is in.

一名玩家脚下的位置，以及它所在的维度。

## 38c3fb88bc

> The operations of `Item.transform`, the numbering of `item_transform`.

`Item.transform` 的各个操作，使用 `item_transform` 的编号。
