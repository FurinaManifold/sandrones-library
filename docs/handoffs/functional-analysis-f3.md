# F3 Hilbert 空间 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`000abbb`（`git rebase main`）
- 设计 RFC：`docs/maintenance/functional-analysis-f3-design.md`
- 当前阶段：正交投影窗完成验证；Riesz 表示待开发

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
