---
id: functional-analysis.fredholm.alternative
family: functional-analysis.operator
variant: identity-minus-compact-first-window
kind: theorem
state: verified
title: 恒等算子的紧扰动
summary: 紧算子 K 的恒等扰动 I-K 具有有限维核和闭值域
premises: [functional-analysis.compact-operator.dual, functional-analysis.fredholm.definition]
mathlib: [IsCompactOperator, ContinuousLinearMap.ker, Submodule.ClosedComplemented]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

Fredholm 备择的第一步不是立刻证明单射等价于满射，而是先控制恒等算子的紧扰动。紧性阻止
`I-K` 的核无限维，并迫使其值域闭。这两条桥为以后研究余核、指数零和最终备择提供基础，但本条
不提前声称后续结论已经成立。

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

# Lean 对照

- `identitySubCompact`、`identitySubCompact_apply`：`I-K` 的具名承载与元素展开；
- `finiteDimensional_kernel_identitySubCompact`：有限维核；
- `isClosed_range_identitySubCompact`：闭值域。

# 边界

本条不证明余核有限维、`index(I-K)=0`、单射与满射等价、预解集二择一或积分核实例。尤其没有
导入或调用 `Mathlib.Analysis.Normed.Operator.Compact.FredholmAlternative` 的最终 package；这些
后续内容仍服从 Main 的 `research_open` 冻结门。
