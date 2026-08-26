# Topology handoff：AT2-C2 covering path lifting

## Scope and automatic gate

- branch: `codex/topology-foundations`；
- Main baseline: `77f6272`，sync merge `794eaf2`；
- direct C1 commit: `20ff2ef`，handoff 已冻结 carrier；
- permission: `main-961f4a6-permissions-expanded.md` 规定 C1 handoff 后 C2 自动
  `development_open`；
- source: `SandronesLibrary/Topology/CoveringPathLiftStandard.lean`；
- Entry: `topology.covering.path-lifting-standard`。

本批新增一个模块、一篇 Entry 与本 handoff；不修改 C1、R3b 或共有文件。

## Quantifier and carrier decision

核心 theorem 量化 `Gamma : C(unitInterval,E)`，规定 `Gamma 0=e` 与 `p ∘ Gamma=gamma` 并给出 `∃!`。
原因不是偏离教材，而是提升终点在构造前未知，无法先写入 dependent `Path e ?endpoint` 类型。

在 Mathlib `cov.liftPath` 已确定终点后，`coveringMapPathLift` 将同一个连续映射薄封装成标准
`Path e (cov.liftPath ... 1)`；pointwise projection 与 endpoint fiber 定理是真实消费者。没有新道路
carrier或提升算法。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 覆盖映射 | 每点有均匀覆盖邻域 | C1 `IsCoveringMap p` | C1 definition expansion | 正式承载 | lift existence | 本 Entry premise |
| 基道路 | 从 x 到 y 的连续道路 | Mathlib `Path x y` | endpoints `source/target` | 正式承载 | lift theorem | 本 Entry |
| 指定初值 | e 位于 x 的 fiber | `e : E`、`p e = x` | orientation conversion | equality | unique lift | 本 Entry |
| 连续提升 | I→E 且投影为 gamma | `ContinuousMap unitInterval E` | `p ∘ Gamma = gamma` | 正式承载 | ∃! theorem | 本 Entry |
| 标准提升道路 | 起点 e、终点由 lift(1) 决定 | `coveringMapPathLift : Path ...` | thin view of `cov.liftPath` | `Path` 正式承载 | projection theorem | 本 Entry |
| 唯一性 | 同基道路同初值提升相等 | `∃!` / `eq_liftPath_iff'` | strict function equality | Mathlib 后端 | C3 | 本 Entry |

公开签名没有道路连通、局部道路连通、Hausdorff、满射、homotopy、monodromy 或 quotient 假设。所有
公开 carrier 均为 C1/Mathlib 已解释对象；新 def 只改变 endpoint-indexed view，无 instance、coercion
或 notation。

## Public surface and C3 gate

公开面 4 项：唯一连续提升、标准 Path view、逐点投影、终点 fiber。C2 handoff 冻结后，按 Main 自动门
C3 转为 `development_open`。C3 应直接复用 Mathlib `IsCoveringMap.liftHomotopy` 与唯一性刻画，且必须
保持初始 lift 是整个参数空间上的连续映射这一量词；不得从逐点道路提升拼装一个未经连续性证明的
二维函数。

## Verification contract

已验证：

- `lake build SandronesLibrary.Topology.CoveringPathLiftStandard`：1713 jobs，通过；
- `/tmp/CoveringPathLiftStandardAggregate.lean` 同时检查 C1 carrier、Mathlib `liftPath`/唯一性刻画、
  `∃!` theorem、Path view、projection 和 endpoint fiber；实际证明任意两个同初值提升相等、常道路
  提升为常映射，并消费 endpoint fiber 定理；
- mapper 精确得到 1 Entry / 4 public declarations，包括 `noncomputable def`；
- 四项公开结果公理均为 `[propext, Classical.choice, Quot.sound]`；
- 全名碰撞、placeholder、新 axiom、instance、notation、conflict 与 `git diff --check` 扫描通过。

## Honest boundary

本批不证明同伦提升、monodromy、拼接相容性、提升判据或覆盖分类。标准 Path view 的终点是结果而非
输入；不能由 endpoint fiber 定理反推任意指定 fiber 点都能作为该基道路从 e 出发的提升终点。
