---
id: functional-analysis.fredholm.alternative
family: functional-analysis.operator
variant: identity-minus-compact-index
kind: theorem
state: verified
title: 恒等算子的紧扰动
summary: 紧算子 K 的恒等扰动 I-K 具有有限维核、有限维余核、闭值域且指数为零
premises: [functional-analysis.compact-operator.dual, functional-analysis.fredholm.definition]
mathlib: [IsCompactOperator, ContinuousLinearMap.ker, Submodule.ClosedComplemented]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

Fredholm 备择先控制恒等算子的紧扰动。紧性阻止 `I-K` 的核无限维，并迫使其值域闭；闭值域的
对偶零化子刻画继而给出有限维余核。进一步考察幂核与幂值域，可证明 `I-K` 的指数为零。最终的
单射／满射等价仍作为下一窗口，而不是在本条静默调用 Mathlib 的最终备择。

# 教材命题

Salamon Lemma 4.3.9（Main Fredholm Lemma）证明：若有紧算子辅助控制
`‖x‖ ≤ c(‖Dx‖ + ‖Kx‖)`，则 `D` 的核有限维且值域闭。取 `D = I-K` 时，该估计由三角不等式给出。

# 正式承载

紧性直接使用 Mathlib `IsCompactOperator`。`I-K` 由
`identitySubCompact K := ContinuousLinearMap.id ℝ E - K` 承载；核和值域仍是 Mathlib 的
`ContinuousLinearMap.ker` 与 `Set.range`，没有建立平行 Fredholm 数据类型。

# 恒等紧扰动证明

在 `ker(I-K)` 上有 `Kx=x`，所以把 `K` 限制到该核就得到紧的恒等算子；Riesz 有限维判据推出核
有限维。有限维核由 Hahn--Banach 得到闭补空间 `C`。若 `(I-K)|C` 没有正下界，可取范数统一远离
零、而 `(I-K)xₙ→0` 的序列；紧性给出 `Kxₙ` 的收敛子列，于是 `xₙ=(I-K)xₙ+Kxₙ` 也收敛。极限
同时属于核与 `C`，只能为零，与范数下界矛盾。故限制算子反 Lipschitz，值域闭；直和分解说明该
限制值域就是 `I-K` 的完整值域。

# 余核与指数

把 `y ∈ E` 送到对偶算子核上的取值泛函 `f ↦ f(y)`。闭值域零化子定理说明该线性映射的核正是
`range(I-K)`；Schauder 定理保证对偶紧算子仍紧，因此目标——对偶算子核的代数对偶——有限维。
商核同构遂给出 `E/range(I-K)` 有限维。

指数零的证明没有提前使用一般 Fredholm 扰动稳定性。对任意 `n`，`(I-K)^n` 仍可写成恒等减紧
算子，故幂核有限维、幂值域闭。若幂核链始终严格增长，Riesz 引理可选出一列向量，使其 `K` 像
两两一致分离，与紧性矛盾，所以幂核最终稳定。对偶算子上应用同一论证，再以闭值域的连续零化子
刻画推出幂值域最终稳定。选取共同稳定次数 `N>0` 后得到 Fitting 分解
`E = ker((I-K)^N) ⊕ range((I-K)^N)`，所以该幂指数为零；指数对复合可加，故
`N · index(I-K)=0`，从而 `index(I-K)=0`。

# Lean 对照

- `identitySubCompact`、`identitySubCompact_apply`：`I-K` 的具名承载与元素展开；
- `finiteDimensional_kernel_identitySubCompact`：有限维核；
- `isClosed_range_identitySubCompact`：闭值域；
- `evaluationOnDualKernel_ker_eq_range`：余核与对偶核配对的核识别；
- `finiteDimensional_cokernel_identitySubCompact`：有限维余核；
- `compactPowerRemainder_isCompactOperator`：幂仍是恒等减紧算子；
- `index_identitySubCompact_eq_zero`：指数为零。

# 边界

本条不证明单射与满射等价、预解集二择一或积分核实例。尤其没有导入或调用
`Mathlib.Analysis.Normed.Operator.Compact.FredholmAlternative` 的最终 package；最终单射／满射
备择按 Main 协议在本窗 handoff 冻结接口后自动转入下一开发窗。
