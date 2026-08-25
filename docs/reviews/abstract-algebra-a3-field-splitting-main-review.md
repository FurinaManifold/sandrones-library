# Main review: Abstract algebra A3.7 splitting fields

- reviewed_commit: `d88dfe5`
- verdict: `accepted`
- reviewed_at: 2026-08-25

公开链以显式 `FieldEmbedding` 定义根集、分裂、根生成分裂域和基域上同构；零多项式边界被明确
区分为“可分裂但不是本条意义的分裂域”。有限性、代数性、向任意分裂扩域的嵌入、存在性及基域
上同构唯一性均有真实 Lean 声明。高级 `Algebra`、`IntermediateField`、`AlgEquiv` 与 Mathlib
分裂域类只在私有桥中出现。Main 现场独立编译零输出通过，无占位或自设公理。提交以 `987bf91`
接收，共享登记完成；全库构建 8926 jobs 通过。
