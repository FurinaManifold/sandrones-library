# F4 弱拓扑、弱星拓扑与弱紧性 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`5946cc2`（`git rebase main`）
- 权限：F4.1 已集成；F4.2 `integration_open`；F4.3 `development_open`
- 当前阶段：F4.1 弱拓扑已集成；F4.2 弱星拓扑与 F4.3 Banach–Alaoglu 已完成验证

## F4.1 拓扑向量空间基础窗

- 实拓扑向量空间直接组合 `IsTopologicalAddGroup E`、`Module ℝ E` 与 `ContinuousSMul ℝ E`，
  不建立本地包装 class。
- 公开接口展开加法、取负、联合数乘的连续性，并以 `Homeomorph.addLeft` 给出平移自同胚。
- 本窗只讲清基础定义，不把局部凸、弱或弱星拓扑并入定义。
- `lake build SandronesLibrary.FunctionalAnalysis.TopologicalVectorSpace`：1669 jobs 通过；Entry 精确
  映射为四个公开声明，公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`。

## F4.1 弱拓扑窗

- 弱拓扑直接采用 Mathlib `WeakSpace ℝ E`，它是底层向量与 `E` 相同、拓扑由连续对偶配对诱导的
  类型同义词；不建立本地弱拓扑结构。
- `toWeakSpace` 是底层线性恒等，`toWeakSpaceCLM` 是从范数拓扑到弱拓扑的连续版本，
  `WeakSpace.map` 承载连续线性映射的弱—弱连续性。
- 公开链覆盖连续对偶评价连续、弱收敛的逐泛函判据、范数收敛蕴含弱收敛，以及连续线性映射保持弱收敛。
- 弱星拓扑在独立 `WeakStarTopology.lean` 窗口开发；Banach–Alaoglu 及弱紧性仍只有 `research_open`。
- `lake build SandronesLibrary.FunctionalAnalysis.WeakTopology`：8721 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖 `WeakSpace`、两个恒等承载、`WeakSpace.map` 与四个公开声明；Entry 精确映射为四个声明。
- 四个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## F4.2 弱星拓扑窗

- 弱星拓扑直接采用 `WeakDual ℝ E`，`StrongDual.toWeakDual` 是范数对偶到弱星对偶的底层线性恒等；不建立平行承载。
- 公开链覆盖向量求值连续、弱星收敛的逐点判据、对偶范数收敛蕴含弱星收敛，以及对偶弱收敛蕴含弱星收敛。
- 文档与公开类型明确区分 `WeakDual ℝ E` 与 `WeakSpace ℝ (StrongDual ℝ E)`，不把弱拓扑与弱星拓扑混同。
- `lake build SandronesLibrary.FunctionalAnalysis.WeakStarTopology`：8722 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖弱星承载、底层恒等、求值连续与四个公开声明；Entry 精确映射为四个声明。
- 四个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## F4.3 Banach–Alaoglu 窗

- 直接采用 `WeakDual.isCompact_closedBall`；弱星球写成
  `WeakDual.toStrongDual ⁻¹' Metric.closedBall f r`，不把弱星紧致误写成范数紧致。
- 公开链覆盖弱星闭性、任意对偶闭球弱星紧致及闭单位球特例。
- 集成等待 F4.2 的 `WeakDual` 教材承载进入 Main；可分时可度量化／序列紧致仍是后续窗口。
- `lake build SandronesLibrary.FunctionalAnalysis.BanachAlaoglu`：8723 jobs 通过；Entry 精确映射为
  三个公开声明，三者公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`。

## F4.4 弱星可度量化与序列抽取窗

- 可分性直接使用 `TopologicalSpace.SeparableSpace E`；不选择或定义本地弱星度量。
- 紧子集可度量化挂靠 `WeakDual.metrizable_of_isCompact`，闭球序列紧挂靠
  `WeakDual.isSeqCompact_closedBall`。
- 上层使用者把闭单位球序列紧展开为严格递增指标的弱星收敛子列，极限仍满足范数不超过一。
- 不声称整个弱星对偶可度量化，也不把弱星收敛误写成范数收敛。
- `lake build SandronesLibrary.FunctionalAnalysis.WeakStarMetrizable`：8724 jobs 通过；Entry 精确映射
  为三个公开声明，公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`。

## 共有文件建议

- Main 集成时新增顶层 `WeakTopology` import，登记 Entry、RADAR 与 ROADMAP 状态。
- 引用建议挂靠 Bühler–Salamon 第 3.1 节；学科分支不直接修改 `reference.bib`。

## F4.5 Banach--Dieudonné 窗口

- Main 基线：`e81ce2e`（`git rebase main`）；权限为 `integration_open`。
- 概念链：对偶子空间仍用 `Submodule ℝ (StrongDual ℝ X)`，弱星承载用
  `WeakDual ℝ X`；闭单位球截面用 `dualUnitSlice`，没有建立平行对偶、弱星或 `c₀` 类型。
- 正式证明包含教材全链：范数闭性和正间隙；Banach--Alaoglu 下的有限检测块递归；
  单位球中趋零的检测序列；对 `C₀(ℕ,ℝ)` 像商应用 Hahn--Banach；在 Banach 原空间中
  对绝对可和级数求和；最终得到弱星分离向量和闭性充要判据。
- 公开上层 API：`exists_weakStar_separator_of_dualUnitSlice_closed`、
  `weakStarImage_submodule_isClosed_of_dualUnitSlice_closed`、
  `weakStarImage_submodule_isClosed_iff_dualUnitSlice_closed`。有限检测引理保留公开，
  `C₀` 坐标和自然数配对枚举均为私有证明后端。
- 完整性边界：`[CompleteSpace X]` 只在将绝对可和向量级数求和为 `x₀ : X` 时使用；
  未声称任意凸集版本，未使用 Eberlein--Šmulian、闭值域或 Fredholm 结论。
- Main 集成建议：新增顶层 `BanachDieudonne` import，登记
  `functional-analysis.weak-star.banach-dieudonne`，并将 F4.5 标记为已集成。
