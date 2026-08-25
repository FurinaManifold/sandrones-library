# F2 Banach 三大定理定义与接口冻结

- 分支：`codex/functional-analysis`
- Main 基线：`c9faa0f`
- 依赖门：F1 已由 Main 接收
- 范围：Baire、Banach–Steinhaus、开映射、闭图、有界逆

## 概念清单

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | 复用说明 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| Baire 性质 | 可数个稠密开集之交稠密 | `BaireSpace` | `dense_iInter_of_isOpen_nat` | 语义一致，直接复用 | 闭集覆盖推论 | `functional-analysis.baire.theorem` |
| 点态有界算子族 | 每个向量的像一致有界 | `∀ x, ∃ C, ∀ i, ‖g i x‖ ≤ C` | 原量词即教材定义 | 不建包装谓词 | 一致有界原理 | `functional-analysis.banach-steinhaus` |
| 开映射 | 开集的像为开集 | `IsOpenMap f` | `ContinuousLinearMap.isOpenMap` | 语义一致，直接复用 | 有界逆 | `functional-analysis.open-mapping` |
| 闭图 | 图集在乘积空间中闭 | `IsClosed (g.graph : Set (E × F))` | `LinearMap.graph` | 语义一致，直接复用 | 闭图定理 | `functional-analysis.closed-graph` |
| 有界逆 | 双射连续线性映射的逆连续 | `LinearEquiv.continuous_symm`／`E ≃L[ℝ] F` | 逆连续与连续线性等价打包 | 不建逆算子结构 | 连续线性等价 | `functional-analysis.inverse-operator` |

## 边界

- F2 只处理实 Banach 空间的教材主线；Mathlib 的半线性、多标量域版本只作为证明后端。
- 不重证 Mathlib 已有三大定理，不创建平行的点态有界、开映射或闭图谓词。
- 每条 Entry 至少给出一个教材主陈述和一个可直接用于后续课程的推论或打包结果。
- F3/F4 继续保持锁定。
