# 动机

路径积分的三个基本运算是反向、拼接和换参数。前两者已经能在 Mathlib 的 `Path` 上精确表达；换参数目前先公开证明中真正使用的参数空间换元公式。

# 直觉

反向会改变方向，所以积分变号。首尾相接的两段路径覆盖整条拼接路径，所以积分相加。换参数时，新的积分核多出导数 `φ'`；有向区间自动记录端点顺序，因此底层换元公式不需要另加单调性假设。

# 陈述（自然语言）

沿反向路径的积分是原积分的负数；两条可积路径拼接后的积分是两段积分之和。若实函数 `φ` 在有向区间上具有连续导数，且复值函数 `g` 连续，则

`∫ₐᵇ φ'(x) • g(φ(x)) dx = ∫_{φ(a)}^{φ(b)} g(u) du`。

# 陈述（Lean 对照）

```lean
pathIntegral_symm
PathIntegrable.symm
PathIntegrable.trans
pathIntegral_trans
pathIntegral_changeOfVariables
```

其中 `pathIntegral_changeOfVariables` 的参数是 `φ φ' : ℝ → ℝ` 与 `g : ℝ → ℂ`；它是参数空间中的区间积分公式，并不是一个已经以 `Path.reparam` 为结论的任意路径重参数化定理。

# 思维脉络（thinking trace）

反向和拼接直接沿用 `Path.symm`、`Path.trans`，避免重新证明路径连续性。换参数则抽出唯一的分析核心：向量值有向区间积分的换元。将来若补充某类 `Path.reparam` 的导数与延拓引理，可以把其参数积分核代入本定理，而无需重做积分论。

# 自然语言 ↔ Lean 映射

“反向路径”对应 `γ.symm`；“拼接”对应 `γ.trans δ`；“两段均可积”对应两个 `PathIntegrable` 假设；“换元导数”对应 `HasDerivAt φ (φ' x) x`；“导数连续”对应 `ContinuousOn φ' (Set.uIcc a b)`。

# 依赖（人话版）

反向与拼接使用 `CurveIntegral.Basic` 中对一般一形式已经证明的结论。换参数使用 `IntervalIntegral.IntegrationByParts` 中的向量值换元定理；复数被视为实数上的赋范空间，`φ' x • ...` 是实标量作用。

# 应用与陷阱

`pathIntegral_trans` 需要两段都可积；不能仅凭路径连续就省略这些假设。当前换参数定理没有构造新的 `Path`，也没有证明任意 `Path.reparam` 保持积分；把它表述成完整路径重参数化不变性会过强。反向定理则不需要额外可积性假设，因为 Mathlib 的积分在不可积时也有约定值且该等式仍成立。
