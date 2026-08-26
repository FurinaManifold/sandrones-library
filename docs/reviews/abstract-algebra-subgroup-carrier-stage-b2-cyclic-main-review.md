# Main review：抽象代数子群载体 Stage B2 Cyclic

- reviewed commit: `9c73a89`
- verdict: `needs_changes`（提交已被 Main 现状语义性取代，不应 cherry-pick）
- reviewed at: 2026-08-26

## 结论

该提交在自身旧基线上可以构建，且“正式 `Subgroup` 作为真实消费者、旧集合接口退到 compatibility”
的方向本身正确。但它基于已经过期的 `GroupCyclic.lean`：提交仍保留并扩写
`cyclicSubgroupSet`、`IsGroupGenerator`、`CyclicGroup` 以及 `Set + SubgroupSet` 旧签名；当前 Main
已经把循环子群直接承载为 `Subgroup.zpowers`，循环性直接承载为 `IsCyclic`，现有
`subgroup_of_cyclic_is_cyclic` 与 `subgroup_of_cyclic_eq_cyclicSubgroup` 也已经直接接受正式
`Subgroup`。

现场 cherry-pick 在源码和 Entry 出现多处实质冲突。选择学科分支版本会重新引入 Main 已移除的
平行定义层，并把目前更简洁的正式接口改回集合兼容签名；这不是维护进步。因此 Main 中止集成，
不以“能在旧分支构建”覆盖当前事实。

## 处理要求

负责人应先同步当前 Main，并把 `9c73a89` 视为 superseded，不重放该补丁。同步后只需核对 Main 的
两个现有正式子群定理及 Entry 已完整解释 `Subgroup.zpowers`／`IsCyclic`；若没有新的真实消费者
缺口，本批以 no-op closure 结束，不应为了保留提交而重新制造旧 API。该问题是基线与正式承载冲突，
不是纯文档问题。
