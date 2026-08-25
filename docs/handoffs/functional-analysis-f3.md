# F3 Hilbert 空间 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`a1d019e`（`git rebase main`）
- 设计 RFC：`docs/maintenance/functional-analysis-f3-design.md`
- 当前阶段：正交投影与 Riesz 表示均已提交并在新基线上复验；伴随待开发

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

## 范围与边界

- 依次覆盖正交投影、Riesz 表示、伴随、正交规范基／Parseval、紧自伴谱定理。
- 直接复用语义一致的 Mathlib Hilbert 接口，不重定义内积、投影、对偶或基。
- 本分支保持 F3 连续依赖链；F4 继续锁定，共有文件仍由 Main 集成。
