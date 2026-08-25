# F3 Hilbert 空间接口冻结

- 分支：`codex/functional-analysis`
- Main 基线：`000abbb`
- 依赖门：F1 与 L5 已完成，Main 已明确解锁 F3
- 范围：正交投影、Riesz 表示、伴随、正交规范基／Parseval、紧自伴谱定理

## 概念清单

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | 复用说明 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| Hilbert 空间 | 完备内积空间 | `InnerProductSpace` + `CompleteSpace` | 范数由内积诱导 | 语义一致，直接复用 | 正交投影 | `functional-analysis.hilbert.projection` |
| 闭子空间正交投影 | 最近点且余项正交 | `Submodule.starProjection` | 最小距离、余项属于 `Sᗮ` | 不定义平行投影 | 正交分解 | `functional-analysis.hilbert.projection` |
| 连续对偶 | 连续线性泛函 | `E →L[𝕜] 𝕜` | 算子范数 | F1 承载的标量值特例 | Riesz 表示 | `functional-analysis.hilbert.riesz` |
| 伴随 | 内积转移算子 | `ContinuousLinearMap.adjoint` | 伴随内积恒等式 | 直接复用 | 自伴与谱 | `functional-analysis.hilbert.adjoint` |
| 正交规范基 | 完备正交规范族 | `HilbertBasis`／`OrthonormalBasis` | 展开与 Parseval | 按无限维语义选承载 | Fourier 展开 | `functional-analysis.hilbert.orthonormal-basis` |
| 紧自伴算子 | 紧且等于伴随 | Mathlib compact/self-adjoint API | 特征向量谱分解 | 不建立平行算子类 | 紧谱定理 | `functional-analysis.hilbert.compact-spectral` |

## 边界

- F3 主线采用实 Hilbert 空间起步；Riesz、伴随与谱窗再根据 Mathlib 稳定 API 决定是否推广到
  `RCLike`，不得让半线性细节遮蔽教材陈述。
- 线性代数已有有限维 `adjointOperator` 只作为前置教材概念，不替代无限维连续线性伴随。
- 不重定义内积、正交补、投影、连续对偶或正交规范基。
- F4 仍保持锁定。
