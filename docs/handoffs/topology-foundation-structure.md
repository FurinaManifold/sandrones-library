# 拓扑定义层首批 handoff

## 分支与范围

- 分支：`codex/topology-foundations`；专用 worktree：`sandrones-library-topology`。
- 新源码：`SandronesLibrary/Topology/Foundation.lean`。
- 新条目：`docs/entries/topology/foundation/structure.md`。
- Entry id：`topology.foundation.structure`。

## 公开定义与后端边界

- 本库公开对象为 `TextbookTopology`、`TextbookTopology.IsClosed`、`IsNeighborhood`、
  `Continuous` 和 `Homeomorphism`。
- `TextbookTopology.toMathlib` 是显式、非全局的实现桥；Mathlib 的 `TopologicalSpace` 和
  `continuous_def` 仅用于互操作与校验。
- 旧 T1–T3 模块暂不删除，也尚未迁移到新定义层；它们应视作待维护的历史接口。

## 负责人审核

- 检查定义依赖顺序为开集公理、闭集/邻域、连续、同胚，没有循环借用 Mathlib 概念。
- 检查空集开与二元并开确实由三条公理推出，不作为隐藏字段重复假设。
- 桥不注册为全局实例，避免同一载体的多个拓扑造成实例冲突。

## Main 共有文件建议

- 顶层 import 建议加入 `SandronesLibrary.Topology.Foundation`。
- Registry 建议登记 `topology.foundation.structure`，并把旧 T1–T3 标为等待定义层迁移。
- ROADMAP 建议把拓扑状态改为重建中；复分析 C1–C3 同时标为施工中，待道路、同伦、单连通定义链完成。

## 下一批

下一批先构造子空间、积拓扑以及连续映射的本库运算，再建立道路、环路与相对端点同伦。当前批次
不能作为“同伦基础已经完成”的依据。
