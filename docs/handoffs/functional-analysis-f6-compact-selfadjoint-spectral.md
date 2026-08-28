# F6.5 compact self-adjoint spectral handoff

- 分支：`codex/functional-analysis-restart`
- 权限：`main-f65-signature-approved-development-open.md` / `development_open`
- Entry：`functional-analysis.hilbert.compact-selfadjoint-spectral`
- 前置 Main：`50fce39`

## 文件与公开接口

- `SandronesLibrary/FunctionalAnalysis/CompactSelfAdjointSpectrum.lean`
- `docs/entries/functional-analysis/hilbert/compact-selfadjoint-spectral.md`
- `compact_isSymmetric_spectral_decomposition`

## 实现内容

公开定理保持 Main 冻结的 Mathlib-native carrier：`IsCompactOperator T` 与
`(T : E →ₗ[𝕜] E).IsSymmetric`。它组装：

- 特征值满足 `star μ = μ`；
- 特征空间形成 `OrthogonalFamily`；
- 全部特征空间的上确界作为集合在全空间中稠密；
- 非零特征空间有限维。

前三个核心输入分别消费 Mathlib 的 `conj_eigenvalue_eq_self`、
`orthogonalFamily_eigenspaces` 与 `orthogonalComplement_iSup_eigenspaces_eq_bot`；有限维性消费
`ContinuousLinearMap.finite_dimensional_eigenspace`。稠密性转换真实使用子空间拓扑闭包与正交补，
没有把“正交补为底”误写成未闭代数和等于全空间。

## 教材与边界

按渲染 PDF 244--245 页核对 Salamon Theorem 5.3.15(v)。本批是紧自伴特例的定义解释和最小组装。
没有构造显式无限维 `HilbertBasis`，没有进入一般正规算子、广义特征空间退化、函数演算、Fitting
分解、谱投影或谱测度。
