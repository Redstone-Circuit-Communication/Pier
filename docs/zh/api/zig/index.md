# Zig 接口

包名 `.pier`，导出模块 `levilamina`。`levilamina.slot("名字")` 能取到 abi.h 的全部 221 个槽位，每个槽位的参数和返回值见 [C++ 接口](../cpp/index.md)；下面各页列的是建立在 `slot` 之上的函数和方法。

`props_gen.zig` 和 `nbt.zig` 分别以 `levilamina.props`、`levilamina.nbt` 公开；其中 `Player`、`Entity`、`BlockAt`、`Item` 和 `SelKind` 在根上也有同名的再导出。

| 页面 | 函数和方法 | 类型 | 常量 |
|---|---|---|---|
| [核心](core.md) | 20 | 4 | 2 |
| [事件](events.md) | 4 | 3 | 0 |
| [命令](commands.md) | 31 | 8 | 2 |
| [服务器、刻与系统信息](server.md) | 42 | 3 | 0 |
| [世界](world.md) | 50 | 11 | 3 |
| [玩家](player.md) | 116 | 2 | 0 |
| [实体](entity.md) | 120 | 1 | 0 |
| [方块](block.md) | 52 | 1 | 0 |
| [物品与容器](item.md) | 83 | 3 | 0 |
| [计分板](scoreboard.md) | 11 | 2 | 0 |
| [表单](form.md) | 33 | 7 | 1 |
| [NBT 与键值数据库](data.md) | 9 | 2 | 0 |
| [经济](money.md) | 10 | 2 | 0 |
| [数据包](packet.md) | 16 | 6 | 0 |
| [模拟玩家](sim.md) | 24 | 1 | 0 |
| [客户端](client.md) | 109 | 3 | 1 |
| [原生逃生口](native.md) | 11 | 2 | 6 |
| [自定义维度](dimensions.md) | 19 | 8 | 1 |
| [跨模组](crossmod.md) | 22 | 11 | 2 |
| [注册表](registry.md) | 8 | 4 | 1 |
| [SNBT](nbt.md) | 26 | 5 | 1 |
| [通用类型](types.md) | 15 | 23 | 4 |
