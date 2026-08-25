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

## 共有文件建议

- Main 集成时新增顶层 `WeakTopology` import，登记 Entry、RADAR 与 ROADMAP 状态。
- 引用建议挂靠 Bühler–Salamon 第 3.1 节；学科分支不直接修改 `reference.bib`。
