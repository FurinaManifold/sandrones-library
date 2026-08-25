# F1 泛函分析基础 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`fe232a4`
- 设计 RFC：`docs/maintenance/functional-analysis-f1-design.md`
- 当前阶段：算子定义层首窗已实现；算子空间、级数、商空间待办

## 路线结论

- F1 依赖 L5、T3、R4，当前均已满足；完成后建议打开 F2。
- 赋范空间与 Banach 空间已经由 `topology.normed-space.def`／`.banach` 验收，F1 复用而不重复
  建立 Registry id。
- 新公共定义从 `IsBoundedLinearOperator` 开始；`ContinuousLinearMap` 只作桥和实现承载。
- 算子范数必须有最小全局界的教材语义；向量值绝对可和与闭线性子空间也必须先有本库入口。

## Main-side 建议

- ROADMAP F1 第 1 项标记为复用 `topology.normed-space.def`，不要创建重复 Entry。
- 后续集成新增 `SandronesLibrary.FunctionalAnalysis.*` 顶层 imports、五个实际新 Entry 的 Registry、
  RADAR API 和 F1 状态；这些共有文件不由本分支修改。

## 当前验证

- `lake build SandronesLibrary.FunctionalAnalysis.Operator`：8708 jobs 通过；仅重放既有 Topology
  文件的格式 linter 警告。
- 临时聚合同时 `#check` 定义、一手性质、打包桥和有界／连续等价，并检查两项 axioms；通过后
  已删除。
- Entry 映射：continuous-linear-map 5 个声明，bounded-iff 3 个声明；没有跨文件或漏审。
- 正式源码禁用占位扫描与 `git diff --check` 通过。

## 尚未完成

- `Operator.lean` 已给出 `IsBoundedLinearOperator`、零算子一手性质、到
  `ContinuousLinearMap` 的桥，以及有界与连续的双向等价。
- 两篇课程文档已完成 staging 初稿；Registry 与顶层 import 留给 Main。
- 尚未验证算子范数下确界定义和商范数所需的 Mathlib API。
- F2/F3/F4 仍保持锁定，本分支不提前使用其结论。
