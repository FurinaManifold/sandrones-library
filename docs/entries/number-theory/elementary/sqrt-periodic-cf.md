---
id: number-theory.elementary.sqrt-periodic-cf
family: number-theory.elementary
variant: classical
kind: theorem
state: verified
title: √d 连分数展开的最终周期性
summary: √d 的数位序列最终周期，且存在周期 L ≤ 2d（显式上界）
premises: [number-theory.elementary.continued-fraction-convergent, number-theory.elementary.continued-fraction-recursion]
mathlib: [Int.fract, Int.floor, Int.self_sub_floor, Int.floor_eq_iff, Int.le_floor, Int.mul_ediv_cancel', Int.card_Icc, irrational_sqrt_intCast_iff, Irrational.ne_rat, Real.lt_sqrt, Real.sqrt_lt', Real.sq_sqrt, Finset.exists_ne_map_eq_of_card_lt_of_maps_to, Function.iterate_add_apply, one_lt_inv₀]
provenance:
  source_type: book
  ref: "hardy-wright-number-theory-2008"
---

# 动机

`√d` 的小数展开携带无限信息，而简单连分数把它压成一串整数 `a₀, a₁, a₂, …`。这串数位是
Pell 方程、二次域基本单位与最佳有理逼近的共同入口：经典理论说 `√d` 的数位序列最终周期，
周期长度与判别式、基本单位有定量联系。

但 Mathlib 目前**没有**任何二次无理数连分数周期性的承载：`GenContFract.of_sqrt` 不存在
（`#check` 报 `Unknown constant`），也没有“周期”这一层概念。所以周期性的陈述、状态递推与
鸽笼论证都必须在本库自建；Mathlib 只提供 `Int.fract`、`Int.floor` 这类底层工具。

# 直觉

连分数算法的每一步只有一个动作：去掉整数部分，再取倒数。把这个动作（Gauss 映射
`x ↦ (fract x)⁻¹`）迭代下去就得到完全商 `ξₙ`，而数位就是 `aₙ = ⌊ξₙ⌋`。

对 `ξ = √d`，每个完全商都能写成

`ξₙ = (Pₙ + √d) / Qₙ`

的“整数 + 同一个无理数”的形式，其中 `(Pₙ, Qₙ)` 是整数对，按

`Pₙ₊₁ = aₙQₙ - Pₙ`，`Qₙ₊₁ = (d - Pₙ₊₁²)/Qₙ`

递推。关键的定性事实是**有界性**：对 `n ≥ 1` 有 `0 < Pₙ < √d` 与 `0 < Qₙ < 2√d`。于是状态
`(Pₙ, Qₙ)` 只能落在有限多个整数点上，鸽笼原理保证某个状态重复；而下一步完全由状态决定
（`aₙ = ⌊(Pₙ + √d)/Qₙ⌋` 只依赖 `(Pₙ, Qₙ)`），所以状态序列一旦重复就永远周期地重复，数位
序列也随之最终周期。

# 陈述（自然语言）

1. **定义层。** 完全商 `ξ₀ = ξ`、`ξₙ₊₁ = (fract ξₙ)⁻¹`；数位（部分商）`aₙ = ⌊ξₙ⌋`；
   整数序列 `a` 最终周期指：存在起点 `N` 与正周期 `L`，使 `n ≥ N` 时 `a(n + L) = a(n)`。
2. **一般判据。** 对任意实数 `ξ`，若第 `N + L` 个完全商回到第 `N` 个完全商（`L > 0`），
   则数位序列从 `N` 起以 `L` 为周期。这是“完全商重复 ⇒ 数位周期”，与 `√d` 无关。
3. **主定理。** 若 `d` 是正整数且不是完全平方数，则 `√d` 的数位序列 `aₙ = ⌊ξₙ⌋` 最终周期。
4. **定量上界。** 上述周期可以取到满足 `L ≤ 2d`；这是本条能做到的定量强度（见“应用与陷阱”：
   `2d` **不是**判别式界）。
5. **显式特例。** 若 `d = a² + 1`（`a ≥ 1`），则从 `n = 1` 起数位恒为 `2a`，周期长度 `1`：
   `√d + a` 是 Gauss 映射的不动点。

# 陈述（Lean 对照）

```lean
noncomputable def cfCompleteQuotient (ξ : ℝ) : ℕ → ℝ
  | 0 => ξ
  | n + 1 => (Int.fract (cfCompleteQuotient ξ n))⁻¹

noncomputable def cfDigit (ξ : ℝ) (n : ℕ) : ℤ := ⌊cfCompleteQuotient ξ n⌋

def IsEventuallyPeriodic (a : ℕ → ℤ) : Prop :=
  ∃ N L : ℕ, 0 < L ∧ ∀ n, N ≤ n → a (n + L) = a n

-- 一般判据：完全商重复 ⇒ 数位周期
theorem cfDigit_eventuallyPeriodic_of_completeQuotient_eq {ξ : ℝ} {N L : ℕ} (hL : 0 < L)
    (h : cfCompleteQuotient ξ (N + L) = cfCompleteQuotient ξ N) :
    IsEventuallyPeriodic (cfDigit ξ)

-- 主定理
theorem cfDigit_sqrt_eventuallyPeriodic (d : ℕ) (hd : 0 < d) (hns : ¬ IsSquare (d : ℤ)) :
    IsEventuallyPeriodic (cfDigit (√(d : ℝ)))

-- 周期长度的显式上界
theorem exists_cfDigit_sqrt_period_le (d : ℕ) (hd : 0 < d) (hns : ¬ IsSquare (d : ℤ)) :
    ∃ N L : ℕ, 0 < L ∧ L ≤ 2 * d ∧
      ∀ n, N ≤ n → cfDigit (√(d : ℝ)) (n + L) = cfDigit (√(d : ℝ)) n

-- 显式特例：d = a² + 1 ⟹ 数位从 n = 1 起恒为 2a
theorem cfDigit_sqrt_sq_add_one (a : ℕ) (ha : 1 ≤ a) {n : ℕ} (hn : 1 ≤ n) :
    cfDigit (√(((a ^ 2 + 1 : ℕ) : ℝ))) n = 2 * (a : ℤ)
```

支撑主定理的内部接口（`private`，不对外）：

```lean
noncomputable def sqrtCFState (d : ℕ) (n : ℕ) : ℤ × ℤ := (sqrtCFStep d)^[n] (0, 1)
-- 表示不变量：ξₙ = ((sqrtCFState d n).1 + √d) / (sqrtCFState d n).2
-- 界：n ≥ 1 ⟹ 0 < Pₙ < √d 且 0 < Qₙ < 2√d
```

# 思维脉络（thinking trace）

**路线选择。** 派工上下文包明确指出 Mathlib 没有 `GenContFract.of_sqrt`，所以第一步是把
“周期”这件事拆成两个可独立证明的部件： (i) 完全商重复 ⇒ 数位周期（纯 Gauss 映射迭代，
对任意实数成立）； (ii) `√d` 的完全商序列确实重复（整数状态 + 鸽笼）。把 (i) 抽成公开的
一般判据后，`√d` 部分只剩“证明状态重复”，周期性的逻辑不再与有界性纠缠。

**状态递推的归纳不变量。** 表示 `ξₙ = (Pₙ + √d)/Qₙ` 与整除性 `Qₙ ∣ d - Pₙ²` 必须一起归纳：
由 `Qₙ ∣ d - Pₙ²` 推出 `Qₙ ∣ d - Pₙ₊₁²` 用的是恒等式

`d - (aQ - P)² = (d - P²) - a²Q² + 2aQP`，

于是 `Qₙ₊₁ = (d - Pₙ₊₁²)/Qₙ` 是真正的整数商（用 `Int.mul_ediv_cancel'` 把 `QₙQₙ₊₁ = d - Pₙ₊₁²`
取回来）。实分析部分只需一次有理化：`ξₙ₊₁ = Qₙ/(√d - Pₙ₊₁) = (Pₙ₊₁ + √d)/Qₙ₊₁`。

**界的归纳。** `n ≥ 1` 时先有 `ξₙ > 1`（因为 `ξₙ = (fract ξₙ₋₁)⁻¹` 而小数部分严格落在 `(0,1)`），
于是 `aₙ ≥ 1`。再由 `ξₙ₊₁ = Qₙ/(√d - Pₙ₊₁)` 与 `ξₙ₊₁ > 1` 得 `0 < √d - Pₙ₊₁ < Qₙ`，即
`Pₙ₊₁ < √d`；反向的 `Pₙ₊₁ > 0` 用反证：若 `Pₙ₊₁ ≤ 0`，由 `aₙ > ξₙ - 1` 与 `aₙQₙ ≤ Pₙ` 得
`Qₙ > √d`，此时 `1 < ξₙ < 2` 迫使 `aₙ = 1`，于是 `Pₙ₊₁ = Qₙ - Pₙ > 0`，矛盾。
`Qₙ₊₁` 的两侧由 `QₙQₙ₊₁ = d - Pₙ₊₁²` 与 `Qₙ₊₁ = (√d + Pₙ₊₁)/ξₙ₊₁` 给出。

**鸽笼与确定性。** 状态落在盒子 `(1..⌊√d⌋) × (1..⌊2√d⌋)` 里，用
`Finset.exists_ne_map_eq_of_card_lt_of_maps_to` 对 `Fin (card + 1) → ℤ × ℤ` 取值，得到
`i < j` 使状态相同。把状态写成 `(sqrtCFStep d)^[n] (0,1)`，重复立即升级为周期：
`(f^[k]) x` 只依赖 `x`。

**走过的弯路（已留痕）。** 见 `traces/lean/number-theory/number-theory.elementary.sqrt-periodic-cf-sqrt-cf.jsonl`：
`omega` 不能消化 `¬ IsSquare` 假设（要先把非平方条件手工变成 `d ≠ 1`）；`set` 会把假设里的
表达式一起折叠，导致多余的 `rw [← hs]` 报 `No goals to be solved`（Playbook §1.2）；
`rw [← Int.floor_add_fract x]` 会连右侧 `⌊x⌋` 内部的 `x` 一起改写；`induction` 会把依赖归纳
变量的假设一并泛化，使归纳假设多出前提（把迭代引理提成独立的 `∀ k` 命题即可）。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 完全商 `ξₙ` | `cfCompleteQuotient ξ n` |
| 数位（部分商）`aₙ` | `cfDigit ξ n` |
| Gauss 映射 | `cfGaussMap x = (Int.fract x)⁻¹` |
| 完全商加法公式 | `cfCompleteQuotient_add ξ m k` |
| 最终周期 | `IsEventuallyPeriodic a` |
| 周期可乘 | `IsEventuallyPeriodic.mul_period` |
| 整数状态 | `sqrtCFState d n : ℤ × ℤ` |
| 一步递推 | `sqrtCFStep d` |
| 状态对应的部分商 | `sqrtCFPartialQuotient d s` |
| 周期上界 `L ≤ 2d` | `exists_cfDigit_sqrt_period_le` |
| 非平方条件 | `¬ IsSquare (d : ℤ)`（`d : ℕ`） |

# 依赖（人话版）

- `number-theory.elementary.continued-fraction-convergent`：教材层收敛子 `continuedFractionConvergent`；
  本条的桥接引理 `continuedFractionConvergent_succ_eq` 把它与完全商对齐
  （`cfCompleteQuotient ξ 1 = (fract ξ)⁻¹` 是 definitional 的）。
- `number-theory.elementary.continued-fraction-recursion`：收敛子的递推
  `continuedFractionConvergent_succ`，桥接引理直接引用。
- Mathlib：`Int.fract` / `Int.floor` 及其展开引理（`Int.self_sub_floor`、`Int.floor_eq_iff`、
  `Int.le_floor`、`Int.floor_le`）、`irrational_sqrt_intCast_iff` 与 `Irrational.ne_rat`
  （把 `¬ IsSquare` 变成 `√d` 的无理性）、`Real.lt_sqrt` / `Real.sqrt_lt'` / `Real.sq_sqrt`
  （`√` 的基本算术）、`Int.mul_ediv_cancel'`（整除性 → 真正的商）、`Int.card_Icc`
  （周期上界的基数计算）、`Finset.exists_ne_map_eq_of_card_lt_of_maps_to`（鸽笼）、
  `Function.iterate_add_apply`（迭代的确定性）、`one_lt_inv₀`（`0 < x < 1 ⟹ 1 < x⁻¹`）。
- 本条的周期性、状态递推与鸽笼都是自建；Mathlib 没有二次无理数连分数周期性的任何承载。

# 应用与陷阱

- **Mathlib 没有 `√d` 周期展开的承载。** `GenContFract.of_sqrt` 不存在（实测 `#check` 报
  `Unknown constant`），也没有“周期”概念或二次无理数连分数周期性的定理。本条的完全商、
  数位、最终周期谓词、状态递推与鸽笼论证全部自建；`state: verified` 指的是这些 Lean 陈述
  真的被证明了，而不是说 Mathlib 里有现成结论。
- **周期长度与判别式的定量关系只做到显式上界。** 本条的定量结论是 `L ≤ 2d`。`2d` **不是**
  判别式界：判别式只由 `d` 的无平方因子部分决定（若 `d = k²m`、`m` 无平方因子，则
  `ℚ(√d)` 的判别式为 `m`（当 `m ≡ 1 mod 4`）或 `4m`），例如 `d = 18 = 3²·2` 的判别式为
  `8 < d`，`d = 50 = 2·5²` 的判别式为 `8`。因此只有在 `d` 无平方因子时才有
  `L ≤ 2d ≤ 2·disc`；对一般的非平方 `d`，本条只主张 `L ≤ 2d`。**精确**关系（周期长度与
  基本单位、类数、负 Pell 方程可解性的联系）在本库中尚未形式化。
- **陷阱：先把无平方因子情形固定下来。** `√d` 的连分数只依赖 `d` 的无平方因子部分
  （`√(k²m) = k√m`），所以谈论“周期长度与判别式”时必须先说明 `d` 是否无平方因子，
  别把 `2d` 当成判别式界。
- **陷阱：`d` 必须非完全平方。** 若 `d` 是完全平方，`√d` 是有理数，连分数有限且不周期；
  两条主定理都以 `¬ IsSquare (d : ℤ)` 为前提。
- **陷阱：周期一般从 `n = 1` 起，不是从 `n = 0` 起。** `a₀ = ⌊√d⌋` 通常不属于后面的周期
  （例如 `√2` 的数位是 `1, 2, 2, 2, …`）。
- **陷阱：`IsEventuallyPeriodic` 只说“存在周期”。** 它不声称 `L` 是最小周期；
  `IsEventuallyPeriodic.mul_period` 只说明周期 `L` 可换成 `k * L`。
- **应用：** 把 `√d` 的数位周期性作为 Pell 方程、二次域基本单位与最佳有理逼近的输入；
  一般判据 `cfDigit_eventuallyPeriodic_of_completeQuotient_eq` 也可用于其它二次无理数，
  只要能把完全商的重复性独立证出来。
