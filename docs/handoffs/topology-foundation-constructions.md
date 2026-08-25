# 拓扑基础构造 handoff

## 分支与范围

- 分支：`codex/topology-foundations`。
- 新源码：`SandronesLibrary/Topology/Constructions.lean`。
- 新条目：`docs/entries/topology/foundation/constructions.md`。
- Entry id：`topology.foundation.constructions`。

## 公开定义与证明

- `induced` 从开集原像定义诱导拓扑；`subspace` 是包含映射诱导的特例。
- `product` 用每点具有内含开矩形的局部条件定义积拓扑。
- `continuous_subtype_val`、`continuous_fst`、`continuous_snd` 全部使用本库 `Continuous`。
- 本模块没有安装或调用 Mathlib 拓扑实例。

## 负责人审核

- 检查诱导拓扑的任意并证明没有偷偷使用 Mathlib `induced`。
- 检查积拓扑交集证明同时缩小两个坐标，任意并证明保持矩形的内含关系。
- 检查“积拓扑”定义的是开矩形的任意并，而不是错误地只允许单个开矩形。

## Main 共有文件建议

- 顶层 import 建议置于 `Topology.Foundation` 之后。
- Registry 登记 `topology.foundation.constructions`；ROADMAP 将其作为道路与同伦定义的前置门。

## 下一批

下一批需要建立实单位区间的本库拓扑对象，再定义道路、常值道路、逆道路、拼接与环路；此后才能
定义相对端点同伦。
