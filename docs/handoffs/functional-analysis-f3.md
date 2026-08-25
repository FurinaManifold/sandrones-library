# F3 Hilbert 空间 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`bdc17a6`（`git rebase main`）
- 设计 RFC：`docs/maintenance/functional-analysis-f3-design.md`
- 当前阶段：正交投影与 Riesz 表示已由 Main 集成；伴随与正交规范基／Parseval 完成验证

## Main 基线同步

- 按 `main-a1d019e-sync-notice.md` 在清洁工作树执行 `git rebase main`，七个学科提交无冲突重放。
- `git merge-base --is-ancestor a1d019e HEAD` 通过；没有恢复或修改 Registry、ROADMAP、RADAR
  等 Main 共有文件。
- 同步后重新执行两个模块构建、联合定义链 `#check`、Entry 映射、公理与禁用占位扫描。

## Riesz 表示窗

- 正式承载为 `StrongDual ℝ E`／`E →L[ℝ] ℝ` 与 `InnerProductSpace.toDual`；没有本地对偶或
  Riesz 映射。
- `lake build SandronesLibrary.FunctionalAnalysis.RieszRepresentation`：8712 jobs 通过；只重放
  既有 Topology 与 LinearAlgebra 警告。
- 聚合 `#check` 覆盖连续对偶、`toDual` 等距等价和三个公开声明；Entry 精确映射为三个声明。
- 三个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 正交投影窗

- 正式承载为 `Submodule.HasOrthogonalProjection`、`orthogonalProjectionOnto` 和
  `starProjection`；公开性质覆盖归属、正交余项和最近点。
- `lake build SandronesLibrary.FunctionalAnalysis.HilbertProjection`：8711 jobs 通过；只重放既有
  Topology 与 LinearAlgebra 格式／结构警告。
- 聚合 `#check` 覆盖 Hilbert 正式承载、投影存在性和三个公开性质；Entry 精确映射为四个声明。
- 四个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 伴随窗口

- 正式承载为 `ContinuousLinearMap.adjoint` 与记号 `A†`；没有本地伴随定义或包装结构。
- 教材定义由全称量化的内积转移公式展开，首个上层使用者同时覆盖对合、等距和复合反序。
- 本条固定实 Hilbert 空间；复数域共轭线性、Banach 对偶算子和无界算子伴随均明确留在范围外。
- `lake build SandronesLibrary.FunctionalAnalysis.AdjointOperator`：8713 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖正式承载、定义性刻画及五个公开声明；Entry 精确映射为五个声明。
- 五个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 正交规范基／Parseval 窗口

- 无限维正式承载选用 `HilbertBasis ι ℝ E`，即 `E` 与 `ℓ²(ι,ℝ)` 的等距线性等价；不复制基结构，
  也不把只适合有限指标的 `OrthonormalBasis` 冒充一般承载。
- 教材展开覆盖正交规范、稠密张成、Fourier 级数重构与 Parseval 自内积恒等式。
- 不假设可分或可数指标；复数共轭版本、Schauder 基和紧自伴谱分解均保持在本窗之外。
- `lake build SandronesLibrary.FunctionalAnalysis.OrthonormalBasis`：8714 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖 `HilbertBasis`、`repr`、系数刻画、级数重构、Parseval 与四个公开声明；
  Entry 精确映射为四个声明。
- 四个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 范围与边界

- 依次覆盖正交投影、Riesz 表示、伴随、正交规范基／Parseval 与酉算子。
- 直接复用语义一致的 Mathlib Hilbert 接口，不重定义内积、投影、对偶或基。
- 本分支保持 F3 连续依赖链；F4 继续锁定，共有文件仍由 Main 集成。
