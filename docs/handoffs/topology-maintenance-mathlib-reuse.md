# 拓扑 Mathlib 复用迁移 handoff

## 范围与决定

- 分支：`codex/topology-foundations`。
- Main 同步提交：`2ceb668`，包含 Main `8d5d823`。
- RFC：`docs/maintenance/topology-mathlib-reuse-migration.md`。
- 声明级 API 对照：`docs/maintenance/topology-mathlib-api-matrix.md`。
- 等级／阶段：M2，调查与迁移设计阶段；尚未修改公开接口。
- Main 指示已执行：冻结 `TextbookTopology` 平行链，不再落入 `/tmp` 的基本群单位律。

## 正式承载与旧 API

新课程开发应直接使用 Mathlib 的 `TopologicalSpace`、`Continuous`、`Homeomorph`、`Path`、
`ContinuousMap.Homotopy`、`Path.Homotopy`、`Path.Homotopic.Quotient`、
`ContinuousMap.HomotopyEquiv`、`ContractibleSpace`、`Joined`、`IsPathConnected`、
`FundamentalGroupoid` 与 `FundamentalGroup`。

旧 `TextbookTopology`、本库道路／同伦／商链完整保留但冻结。当前只存在
`TextbookTopology.toMathlib` 和连续性桥；高层转换尚未建立，不能宣称迁移完成。

## 影响与剩余计数

- 直接受影响的拓扑 Lean 模块：18 个；完整表和依赖图见 RFC。
- 跨学科 Lean 直接使用者：扫描结果为 0。
- 旧 API 在拓扑模块中的出现仍很多，本轮没有以文本计数冒充语义迁移完成。
- `/tmp/sandrones-library/PathUnitLaws.lean` 未进入 Git，也不得纳入后续批次。

## Main 共有文件建议

- ROADMAP：将自建基本群链标为“迁移施工中”，不要把旧商单位律／结合律列为下一开发门。
- Registry：尚未集成的旧链条目不要标为 verified 课程出口；迁移后给 Mathlib 正式承载条目明确
  标注 explained reuse。
- RADAR：登记上述 Mathlib 正式承载及教材含义，不把直接复用描述为缺失本库定义。
- 顶层 import：阶段 A0/A1 完成前不新增旧 `PathReparameterization` 等模块。

## 验证与下一门

- `lake build SandronesLibrary.Topology.Constructions SandronesLibrary.Topology.Homotopy`：通过，858 jobs。
- 临时 Mathlib 名称聚合核对已完成；其中正确名称是根命名空间 `unitInterval` 和
  `ContinuousMap.HomotopyEquiv`，不是 `Set.unitInterval` 或根 `HomotopyEquiv`。
- 下一门：Main 审核本 RFC 的分类与 A0 公开入口；获准后单独实现 A0，不改旧 API。
- 全库构建、公理全量审计、Registry 与 RADAR 更新未运行，归 Main 集成阶段。
