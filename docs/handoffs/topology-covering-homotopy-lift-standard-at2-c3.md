# Topology handoff：AT2-C3 covering homotopy lifting

## Scope and automatic gate

- branch: `codex/topology-foundations`；
- Main baseline: `77f6272`，sync merge `794eaf2`；
- direct C2 commit: `85e360f`，其 handoff 已冻结道路提升公开接口；
- permission: `main-961f4a6-permissions-expanded.md` 规定 C2 签名冻结后 C3 自动
  `development_open`；
- source: `SandronesLibrary/Topology/CoveringHomotopyLiftStandard.lean`；
- Entry: `topology.covering.homotopy-lifting-standard`。

本批只新增一个模块、一篇 Entry 与本 handoff；不修改 C1/C2、van Kampen、R3b 或共有文件。

## Quantifier and carrier decision

核心 theorem 量化 `Hlift : C(unitInterval × A,E)`，并要求输入初始切片是整个连续映射
`f0Lift : C(A,E)`。逐点选择 fiber 元素或逐参数调用道路提升都不足以证明对 `(t,a)` 的联合连续性，
所以本批直接复用 Mathlib 参数化 `liftHomotopy`，没有从 C2 拼装二维函数。

`coveringMapHomotopyLiftEndpoint` 是 lift 的时间一连续切片；`coveringMapHomotopyLift` 只是同一柱面
映射的标准 `ContinuousMap.Homotopy` view。没有新 carrier、instance、coercion 或 notation。

## Concept inventory and public signature audit

| 概念 | 教材语义 | Lean 正式承载 | Mathlib 角色 | 本批公开结果 |
|---|---|---|---|---|
| 覆盖映射 | 均匀覆盖局部模型 | C1 `IsCoveringMap p` | 正式 carrier | 全部结果的假设 |
| 参数化同伦 | 连续 `I × A → X` | `C(unitInterval × A,X)` | `ContinuousMap` | `∃!` 输入 |
| 初始连续提升 | `A → E` 且投影为零切片 | `f0Lift : C(A,E)` | 正式 carrier | `∃!` 初值 |
| 柱面提升 | 联合连续且投影为 H | Mathlib `liftHomotopy` | 存在性后端 | 唯一提升 theorem |
| 唯一性 | 同投影、同零切片则相等 | `eq_liftHomotopy_iff'` | 唯一性后端 | `∃!` uniqueness |
| 时间一提升 | 连续的终端切片 | `C(A,E)` | lift 的 restriction | endpoint def/theorem |
| 标准同伦视图 | 端点索引的同一柱面映射 | `ContinuousMap.Homotopy` | 正式 carrier | homotopy def/theorem |

公开面共 5 项：唯一柱面提升、时间一连续映射、标准同伦视图、逐点投影、时间一投影。公开签名没有
道路连通、局部道路连通、Hausdorff、满射、relative、monodromy、quotient 或 classification 假设。

## Verification contract

- `lake build SandronesLibrary.Topology.CoveringHomotopyLiftStandard`：1817 jobs，通过；
- `/tmp/CoveringHomotopyLiftStandardAggregate.lean` 同时检查 C1/C2 carrier、Mathlib
  `liftHomotopy`/唯一性刻画及本批五项 API；实际证明任意两个同投影同零切片的柱面候选相等，并消费
  标准同伦零端、全柱投影与时间一投影；
- mapper 精确得到 1 Entry / 5 public declarations，包括两个 `noncomputable def`；没有吸入 C2
  声明；
- 五项公开结果的公理均为 `[propext, Classical.choice, Quot.sound]`；
- Entry 教材正文为八段；源码、Markdown 与拟登记 Registry id 一致；
- placeholder、新 axiom、instance、notation、冲突标记、全名碰撞与 `git diff --check` 扫描通过。

## Honest boundary

本批没有证明 relative homotopy lifting、道路同伦类上的作用、monodromy、提升判据或覆盖分类。时间一
提升由初始连续提升和基同伦决定，不允许再指定任意终端 lift。标准 Homotopy view 是薄封装，不是第二
套同伦实现。
