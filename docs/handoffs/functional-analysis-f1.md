# F1 泛函分析基础 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`fe232a4`
- 设计 RFC：`docs/maintenance/functional-analysis-f1-design.md`
- 当前阶段：定义层设计冻结，Lean 实现尚未开始

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

## 尚未完成

- 尚无正式 F1 Lean 源码或课程 Entry 文档。
- 尚未验证算子范数下确界定义和商范数所需的 Mathlib API。
- F2/F3/F4 仍保持锁定，本分支不提前使用其结论。
