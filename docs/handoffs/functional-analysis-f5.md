# F5 对偶算子、紧算子与 Fredholm 理论 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`5946cc2`（`git rebase main`）
- 权限：对偶算子基础 `development_open`；紧算子 `research_open`；Fredholm 冻结
- 当前阶段：对偶算子定义窗口开发中

## 对偶算子基础

- 当前 Mathlib 没有 ROADMAP 所写的 `ContinuousLinearMap.dualMap`专名；成熟后端是 `ContinuousLinearMap.precomp`。
- `dualOperator T` 只将 `T.precomp ℝ` 命名为教材对偶算子，元素化公式为 `(T' f)(x)=f(Tx)`。
- 公开链覆盖求值展开、范数控制、复合反序和恒等算子；文档明确区分对偶算子与 Hilbert 伴随。
- 本窗只依赖已集成 F1–F3，可形成独立提交；不引入紧性或 Fredholm 语言。
- `lake build SandronesLibrary.FunctionalAnalysis.DualOperator`：8723 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖 `ContinuousLinearMap.precomp`、复合范数不等式、对偶算子定义和五个公开性质；
  Entry 精确映射为一个定义与五个定理。
- 六个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 共有文件建议

- Main 集成时新增 `DualOperator` 顶层 import，登记 Entry、RADAR 和 ROADMAP 状态。
- 引用建议挂靠 Bühler–Salamon 第 4.1 节；学科分支不修改 `reference.bib`。
