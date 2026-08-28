# F6.5 紧自伴谱定理签名 handoff

- 分支：`codex/functional-analysis-restart`
- 权限：`research_open`
- 目标 Entry：`functional-analysis.hilbert.compact-selfadjoint-spectral`
- 调查：`docs/maintenance/functional-analysis-f6-compact-selfadjoint-audit.md`

## 建议 carrier

```lean
variable {𝕜 E : Type*} [RCLike 𝕜]
variable [NormedAddCommGroup E] [InnerProductSpace 𝕜 E] [CompleteSpace E]
variable {T : E →L[𝕜] E}

(hK : IsCompactOperator T)
(hT : (T : E →ₗ[𝕜] E).IsSymmetric)
```

不新建 self-adjoint 或 compact wrapper。正式文件应直接使用 Mathlib carrier。

## 建议第一批公开结论

第一批建议只冻结一个教材化组装定理，内容为：

- 每个特征值满足 `star μ = μ`；
- `eigenspace T μ` 构成 `OrthogonalFamily`；
- `(⨆ μ, eigenspace T μ)ᗮ = ⊥`；
- `μ ≠ 0` 时 `eigenspace T μ` 有限维。

这四项分别直接由
`conj_eigenvalue_eq_self`、`orthogonalFamily_eigenspaces`、
`ContinuousLinearMap.orthogonalComplement_iSup_eigenspaces_eq_bot` 和
`ContinuousLinearMap.finite_dimensional_eigenspace` 提供。组装的价值是对齐教材定义链与本库 Entry，
不是宣称 Mathlib 缺失核心谱定理。

可选第二公开引理：对 `0 < n`，自伴算子的 `genEigenspace T μ n` 等于 `eigenspace T μ`，对应
Salamon Theorem 5.3.15(v) 证明的 Step 2。请 Main 决定它是否与第一批一起冻结。

## 暂不建议冻结的签名

不在第一批构造“存在特征向量 `HilbertBasis`”的选择性 package。Mathlib 当前的无限维紧自伴接口
已经给出特征空间正交和稠密完备性，但现成 `eigenvectorBasis` 只适用于有限维。若未来 F6.8/F6.9
消费者需要坐标展开，应另开窗口设计 `HilbertBasis` 与特征值标号。

本 handoff 也不申请一般正规谱定理、连续函数演算、谱测度、一般幂核稳定、Fitting 分解或谱投影。

## 请求 Main 决策

请 Main 审核并冻结：

1. F6.5 第一批是否提升为 `development_open`；
2. 是否接受上述 Mathlib-native carrier；
3. 自伴广义特征空间退化引理是否纳入同一批；
4. 显式 `HilbertBasis` 是否保持为后续消费者驱动的独立窗口。
