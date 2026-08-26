# Topology handoff：AT2-C4b covering lifting criterion

## Scope and automatic gate

- branch: `codex/topology-foundations`；
- synchronized Main baseline: `921a888`，merge `4e4986c`；
- C4a commit: `052578d`，handoff 已冻结并通知 Main；
- permission: `main-at2-c4-interface-audit-approved.md` 规定 C4a handoff 后 C4b 自动
  `development_open`；
- source: `SandronesLibrary/Topology/CoveringLiftingCriterionStandard.lean`；
- Entry: `topology.covering.lifting-criterion-standard`。

本批新增一个模块、一篇 Entry 与本 handoff；不修改 C1--C4a、C5、Registry、ROADMAP 或顶层 import。

## Genuine theorem and Mathlib reuse

`coveringMap_lift_range_le_of_exists` 是教材判据缺失的必要方向：从实际全局提升构造
`FundamentalGroup.map F a0 q` 作为 range witness，并以道路同伦商 `map_comp` 证明投影后等于
`map f a0 q`。此方向没有道路连通或局部道路连通假设。

两个 iff 的充分方向直接复用 Mathlib `existsUnique_continuousMap_lifts_of_range_le`，严格保留
`PathConnectedSpace A` 与 `LocallyPathConnectedSpace A`。没有复制沿道路构造提升的证明。

## Public signature inventory

| 公开结果 | 类型 | 假设 | 消费者 |
|---|---|---|---|
| `coveringMap_lift_range_le_of_exists` | existing lift → subgroup range inclusion | topology + covering | both iff theorems |
| `exists_coveringMap_lift_iff_range_le` | `∃ lift ↔ range ≤ range` | path/local path connected | lifting users |
| `existsUnique_coveringMap_lift_iff_range_le` | `∃! lift ↔ range ≤ range` | path/local path connected | classification research |

`FundamentalGroup`、`map`、`mapOfEq`、`Subgroup.range` 和 `ContinuousMap` 均为已解释的正式 carrier。
没有 private helper、新 carrier、instance、coercion、notation 或 C5 假设泄漏。

## Verification contract

- `lake build SandronesLibrary.Topology.CoveringLiftingCriterionStandard`：1819 jobs，通过；
- `/tmp/CoveringLiftingCriterionStandardAggregate.lean` 同时检查基本群 carrier、`map/mapOfEq`、道路商
  `map_comp`、Mathlib 充分方向、C4a closed/fixed 桥及本批三项 API；实际从指定 lift 消费必要方向，
  并从像包含分别消费存在和存在唯一结论；
- mapper 精确得到 1 Entry / 3 public theorems；没有吸入 C4a 或 Mathlib 声明；
- 三项公开结果公理均为 `[propext, Classical.choice, Quot.sound]`；
- Entry 为精确八段，源码、Markdown 与拟登记 Registry id 一致；
- placeholder、新 axiom、instance、notation、冲突标记、全名碰撞与 `git diff --check` 扫描通过。

## Honest boundary

本批不以 simply connected 特例代替一般判据，不构造 universal cover，也不声称覆盖空间分类。C4c 和
C5 仍只允许 research；C5 的 semilocally simply connected 假设不得由当前 iff 自动推出或省略。
