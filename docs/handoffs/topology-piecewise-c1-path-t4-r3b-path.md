# Topology handoff：T4-R3b-path 归纳式 PiecewiseC1 道路

## Scope and gate

- branch target: `codex/topology-foundations`；
- permission: `main-t4r3b-path-inductive-interface-approved.md`，`development_open`；
- authoritative research candidate: `/tmp/PiecewiseC1PathInductiveCandidate.lean`；
- superseded design: `FiniteC1Decomposition` 严格等于统一 `Path.concat` 的旧结构候选；
- formal slice: one source, one Entry, this handoff。

本批只建立一维道路的归纳式分段 C1 性和 R3a replacement 消费者。它不包含候选文件末尾的复分析
`pathIntegrable_of_piecewiseC1`，也不进入仍为 `research_open` 的 T4-R3b-square。

## Files

- `SandronesLibrary/Topology/PiecewiseC1Path.lean`；
- `docs/entries/topology/homotopy/piecewise-c1-path.md`；
- `docs/handoffs/topology-piecewise-c1-path-t4-r3b-path.md`。

源码 imports：

- `SandronesLibrary.Topology.PathPolygonalApproximation`；
- `Mathlib.Analysis.Calculus.ContDiff.Operations`；
- `Mathlib.Analysis.Calculus.AddTorsor.AffineMap`。

没有 import 复分析模块，拓扑依赖方向保持单向。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 分类 | 本批消费者 | 边界 |
|---|---|---|---|---|---|
| 道路 | 带固定端点的连续映射 | Mathlib `Path` | 语义一致的正式承载 | `Path.PiecewiseC1` | 不另造 carrier |
| 整体 C1 | 参数区间上连续可微 | `ContDiffOn ℝ 1 gamma.extend (Icc 0 1)` | 语义一致的正式承载 | `of_contDiffOn` | 只要求阶数 1 |
| 分段 C1 | 有限 C1 道路拼接 | 本库归纳 Prop `Path.PiecewiseC1` | 必要桥 | `meshPolygonal_piecewiseC1`、replacement | 当前是 Mathlib concat-tree 版本 |
| 拼接／cast／反向 | 道路标准操作 | Mathlib `Path.trans/cast/symm` | 语义一致的正式承载 | 三构造子与 `PiecewiseC1.symm` | 无新 notation 或 instance |
| 开集内替换 | 相对端点且同伦不离开开集 | Mathlib `Path.Homotopy` 加逐点证书 | 语义一致的正式承载 | 最终 replacement theorem | 不正则化同伦方形 |

## Public surface

用户层公开接口为：

1. `Path.PiecewiseC1`，连同归纳构造子 `of_contDiffOn`、`trans`、`cast`；
2. `Path.piecewiseC1_of_contDiffOn`；
3. `Path.piecewiseC1_refl`；
4. `Path.piecewiseC1_segment`；
5. `Path.piecewiseC1_concat`；
6. `Path.PiecewiseC1.symm`；
7. `Path.meshPolygonal_piecewiseC1`；
8. `Path.exists_piecewiseC1_range_subset_open_and_homotopyWithin`。

本批没有私有 helper；所有证明均直接围绕上述教材操作。归纳命题自动生成 recursor/匹配设施属于
Lean 生成接口，handoff 明确披露，Main 的声明映射器需要确认能识别 `inductive` 核心声明及构造子。

## Semantic correction

旧结构候选要求原道路严格等于统一 `Path.concat`。其零段基例是常道路，导致任意整体 C1 道路一般
无法严格满足这种参数化等式。正式版本改为归纳 Prop，整体 C1 是直接构造子，拼接保持 Mathlib
实际参数化。

当前接口没有宣称与任意有限实数断点定义等价；Entry 已明确说明它是有限 binary concat tree。
这防止把尚未建立的重参数化理论隐藏在“piecewise”一词后面。

## Definition-chain audit

临时 aggregate 应同时 `#check`：

- `Path.PiecewiseC1` 及三个构造子；
- 整体 C1 引入、常道路、线段、有限 concat、反向；
- `Path.meshPolygonal_piecewiseC1`；
- `Path.exists_piecewiseC1_range_subset_open_and_homotopyWithin`。

最后两项是真实上层消费者，证明核心 Prop 不是装饰别名。复分析研究消费者已在 `/tmp` 编译，但按
Main 所有权裁决不进入本提交。

## Verification

```text
lake build SandronesLibrary.Topology.PiecewiseC1Path
✔ [2083/2083] Built SandronesLibrary.Topology.PiecewiseC1Path
Build completed successfully (2083 jobs).
```

独立 aggregate 导入正式模块并 `#check` 核心 Prop、三个构造子和其余七个公开出口，exit code 0。
`scripts.check_axioms.map_entry_to_decl` 将 Entry 唯一映射到八个手写公开声明；构造子由 `inductive`
生成，已在 aggregate 中分别检查。Registry 仍由 Main 维护，故注册前运行完整 entry-id checker 会按
预期报告该 id 尚未登记。

代表性公理结果：

```text
Path.PiecewiseC1:
  [propext, Classical.choice, Quot.sound]
Path.piecewiseC1_concat:
  [propext, Classical.choice, Quot.sound]
Path.PiecewiseC1.symm:
  [propext, Classical.choice, Quot.sound]
Path.exists_piecewiseC1_range_subset_open_and_homotopyWithin:
  [propext, Classical.choice, Quot.sound]
```

另以只读临时消费者逐构造子证明复分析 `PathIntegrable`，编译零输出，确认接口有真实下游用途；该
消费者没有进入提交。三文件禁用占位扫描为空，未发现 ComplexAnalysis import、instance 或 notation；
`git diff --check` 通过。

## Honest boundary

本批不修改共有 `SandronesLibrary.lean`、Registry、ROADMAP 或 RADAR；这些由 Main 集成。它不证明
曲线可积性、曲线积分的拼接／反向公式、任意连续同伦的积分不变性、同伦方形分片 C2 正则化或
van Kampen 结果。
