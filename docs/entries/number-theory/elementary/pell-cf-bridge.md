---
id: number-theory.elementary.pell-cf-bridge
family: number-theory.elementary
variant: bridge
kind: theorem
state: verified
title: 连分数与 Pell 解的桥
summary: 正 Pell 解的比值必是 √d 的收敛子；反方向只给出收敛子的 Pell 形式上界
premises: [number-theory.elementary.continued-fraction-convergent, number-theory.elementary.legendre-criterion, number-theory.elementary.pell-equation]
mathlib: [GenContFract.abs_sub_convs_le, GenContFract.conv_eq_num_div_den, GenContFract.of_correctness_of_terminatedAt, GenContFract.of_den_mono, GenContFract.succ_nth_fib_le_of_nth_den, GenContFract.terminated_stable, GenContFract.contsAux_recurrence, GenContFract.of_h_eq_floor, GenContFract.of_partNum_eq_one, GenContFract.partNum_eq_s_a, GenContFract.num_eq_conts_a, GenContFract.den_eq_conts_b, GenContFract.nth_cont_eq_succ_nth_contAux, GenContFract.IntFractPair.exists_succ_get?_stream_of_gcf_of_get?_eq_some, Real.convergent, Real.convs_eq_convergent, Real.sq_sqrt, Real.sqrt_lt_sqrt, Rat.den_div_eq_of_coprime, Rat.den_dvd, Rat.num_div_den, Rat.cast_injective, Rat.intCast_div_eq_divInt, Int.isCoprime_iff_gcd_eq_one, Int.gcd_def, Int.le_of_dvd, sq_lt_sq, abs_add_le, abs_sub_comm, one_div_le_one_div_of_le, div_lt_div_of_pos_left]
provenance:
  source_type: book
  ref: "hardy-wright-number-theory-2008"
---

# 动机

正 Pell 方程 `x² - d y² = 1` 与 `√d` 的连分数展开，在教材里本来就是同一件事的两面：一方面，
解 `(x, y)` 给出的比值 `x / y` 是 `√d` 极好的有理逼近；另一方面，好到一定程度的有理逼近
一定来自连分数算法。本库此前已经有了 Pell 侧的坐标接口（`PellSolution`）与连分数侧的有理接口
（`continuedFractionConvergent`、`IsLegendreApproximation`、`legendreApproximation_is_convergent`），
但两者之间没有任何 Lean 层面的连接：Pell 侧的定理不知道连分数，连分数侧的定理也不知道 Pell。

本条目把这个缺口补成一条**显式的桥**，并且**把两个方向分开陈述、分开证明**：方向 I 说
“Pell 正解 ⟹ 比值是收敛子”，方向 II 只说“收敛子 ⟹ Pell 形式有界”。后者比前者的反方向弱得多，
本条目不允许它冒充前者。

# 直觉

**方向 I。** 设 `x² - d y² = 1`、`y > 0`。把方程改写一下：

`(√d - x/y)(√d + x/y) = d - x²/y² = -(x² - d y²)/y² = -1/y²`。

因此 `|√d - x/y| = (1/y²) / (√d + x/y)`。又由 `x² = 1 + d y² > d y²` 与 `y > 0` 得 `x/y > √d`，
而 `d > 1` 保证 `√d > 1`，于是分母 `√d + x/y > 2`，误差就严格小于 `1/(2y²)`。这正是 Legendre
判据的阈值，所以 `x/y` 必是 `√d` 的某个收敛子。

还有一处不能省：Legendre 判据的阈值里出现的是**既约**分母 `q.den`，不是任意的 `y`。好在
方程本身就是一条 Bézout 关系：`x·x + (-(d y))·y = 1`，所以 `x` 与 `y` 互素，`x/y` 已经是既约分数，
`q.den` 恰好就是 `y`。这两步合起来才是完整的桥。

**方向 II。** 反过来只有一条上界。收敛子的误差满足 `|√d - q| ≤ 1/(Bₙ·Bₙ₊₁)`，其中 `Bₙ` 是连分数
自身的分母（continuant）；而 `q` 的既约分母不超过 `Bₙ`（`q` 是拿 `Bₙ` 作分母约分出来的）。
于是

`|q.num² - d q.den²| = q.den²·|√d - q|·|√d + q| ≤ |√d + q| ≤ 2√d + |q - √d| ≤ 2√d + 1/q.den² ≤ 2√d + 1`。

整条链全是非严格不等号，所以最终结论也只能写成 `≤`，不能写成 `<`。

# 陈述（自然语言）

**方向 I（本条目主交付，真正证明）。** 设整数 `d > 0` 不是平方数，`a = (x, y)` 是正 Pell 方程
`x² - d y² = 1` 的解，且 `x > 1`、`y > 0`。则存在自然数 `n`，使比值 `x / y` 等于 `√d` 的
第 `n` 个连分数渐近分数。

**方向 II（次交付，只是上界）。** 设整数 `d > 0`，有理数 `q` 是 `√d` 的某个连分数渐近分数。
则 `|q.num² - d·q.den²| ≤ 2√d + 1`，其中 `q.num`、`q.den` 是 `q` 的既约分子与分母。

方向 II 是**单向**的：它只说渐近分数的 Pell 形式不会太大，没有断言渐近分数是 Pell 解。

# 陈述（Lean 对照）

```lean
theorem pellSolution_ratio_isConvergent {d : ℤ} (hd : 0 < d) (hns : ¬IsSquare d)
    {a : PellSolution d} (hx : 1 < a.x) (hy : 0 < a.y) :
    ∃ n, ((a.x : ℚ) / (a.y : ℚ)) = continuedFractionConvergent (√(d : ℝ)) n

theorem convergent_pellForm_bounded {d : ℤ} (hd : 0 < d) {q : ℚ}
    (hq : ∃ n, q = continuedFractionConvergent (√(d : ℝ)) n) :
    |(q.num : ℝ) ^ 2 - (d : ℝ) * (q.den : ℝ) ^ 2| ≤ 2 * √(d : ℝ) + 1
```

两点如实说明：

- 方向 I 的 `hns : ¬IsSquare d` 在证明里只用于把 `0 < d` 加强成 `1 < d`（`d = 1` 时
  `IsSquare 1` 成立，与非平方矛盾）。除此之外证明不需要非平方假设：当 `d` 本身是整数平方时，
  `x² - d y² = 1` 强制 `y = 0`，与 `0 < a.y` 矛盾，结论空真。保留 `hns` 是为了与前置 Entry
  `number-theory.elementary.pell-positive-existence` 的 `(0 < d, ¬IsSquare d)` 口径一致。
- 方向 II 的右端是 `≤ 2√d + 1`，不是 `<`。证明给出的放缩链是
  `|q.num² - d q.den²| ≤ 2√d + 1/q.den² ≤ 2√d + 1`，两步都是非严格不等式，陈述与证明一致。

# 思维脉络（thinking trace）

完整过程见 `traces/lean/number-theory/number-theory.elementary.pell-cf-bridge-pell-bridge.jsonl`
（每次 `#check` 侦察轮与每次失败尝试都留痕）。

方向 I：

1. 先侦察承载。派工包里两个未验证的提示被编译器否掉：`GenContFract.of_sqrt` 与 `Pell.Solution.xp`
   都不存在，所以 Pell 侧只能用本库 `PellSolution`，连分数侧只能用 `Real.convergent`。
2. `IsCoprime a.x a.y` 用 `⟨a.x, -(d * a.y), by rw [← a.equation]; ring⟩` 直接给出（不用
   `linear_combination`，那条 import 链没有带这个 tactic）。
3. `Int.isCoprime_iff_natAbs_coprime` 不存在；改走 `Int.isCoprime_iff_gcd_eq_one` 加
   `Int.gcd_def`（`Int.gcd` 的定义就是 `Nat.gcd` 作用在两个 `natAbs` 上），得到
   `Nat.Coprime a.x.natAbs a.y.natAbs`。
4. `Rat.den_div_eq_of_coprime` 给出 `(q.den : ℤ) = a.y`，再用 `exact_mod_cast` 抬到 `ℝ`。
5. 代数估计写成四段：`(√d - r)(√d + r) = -1/y²`（`field_simp` + `linarith` 用方程）、
   `|√d - r|·(√d + r) = 1/y²`（`abs_mul` + `abs_of_pos`）、`√d < r`（`sq_lt_sq` 从
   `r² = d + 1/y²` 推）、最后 `div_lt_div_of_pos_left` 放缩。
6. 一处 elaboration 陷阱：直接写 `((a.x : ℚ) / (a.y : ℚ) : ℝ)` 时，Lean 的 expected-type
   elaboration 会把强转插到除法两边（变成 `↑↑a.x / ↑↑a.y`），于是 `rw [Rat.cast_div]` 找不到
   `↑(p/q)` 形状，`show` 的 pattern 也与目标 definitional 不等。改用 `set q : ℚ := ...`
   把有理数提成局部变量后一次通过。

方向 II：

7. 主要障碍是 `q.den` 与 `GenContFract.dens n` 的比较。Mathlib 的 `GenContFract.nums`/`dens`
   取值在系数域 `K`（此处 `ℝ`），没有 ℤ/ℕ 版本，所以先证了一条私有引理
   `exists_int_contsAux`：对 `of v` 的 `contsAux` 做强归纳，用「偏分子恒为 1」（`of_partNum_eq_one`）
   与「偏分母是 `IntFractPair.b`，本就是整数」（`get?_of_eq_some_of_succ_get?_intFractPair_stream`）
   把每一层 continuant 写成 `⟨(A : ℝ), (B : ℝ)⟩`。
8. 有了整性，`Rat.den_dvd` + `Int.le_of_dvd` 给出 `q.den ≤ dens n`。
9. `TerminatedAt n` 与否则要分开：终止时 `q = √d`，Pell 形式恰为 0；未终止时才可以用
   `abs_sub_convs_le`，并用 `succ_nth_fib_le_of_nth_den` 说明 `dens n > 0`。
10. 最后把 `q.num² - d q.den²` 改写成 `q.den²·((q - √d)(q + √d))`，用
    `mul_le_mul` 把 `q.den²·|q - √d| ≤ 1` 与 `|q + √d| ≤ 2√d + 1/q.den²` 相乘。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 正 Pell 方程的解 | `PellSolution d` |
| 解的第一、第二坐标 | `a.x`、`a.y` |
| 解的方程 | `a.equation : a.x ^ 2 - d * a.y ^ 2 = 1` |
| `x` 与 `y` 互素 | `IsCoprime a.x a.y` |
| 比值的既约分母 | `((a.x : ℚ) / (a.y : ℚ)).den` |
| 既约分母就是 `y` | `Rat.den_div_eq_of_coprime` |
| 第 `n` 个渐近分数 | `continuedFractionConvergent (√(d : ℝ)) n` |
| Legendre 阈值 | `IsLegendreApproximation (√(d : ℝ)) q` |
| 方向 I 的最后一击 | `legendreApproximation_is_convergent` |
| 收敛子的误差界 | `GenContFract.abs_sub_convs_le` |
| 连分数的分子 / 分母 | `(GenContFract.of v).nums n`、`(GenContFract.of v).dens n` |
| continuant 对是整数 | 私有引理 `exists_int_contsAux` |
| `q.den ≤ dens n` | 私有引理 `rat_den_le_dens` |
| `q.num = q · q.den` | 私有引理 `rat_num_eq_mul_den` |
| 终止情形 `q = √d` | `GenContFract.of_correctness_of_terminatedAt` |

# 依赖（人话版）

- `number-theory.elementary.continued-fraction-convergent`：`continuedFractionConvergent` 是两条
  定理结论里的渐近分数载体。
- `number-theory.elementary.legendre-criterion`：`legendreApproximation_is_convergent` 是方向 I 的
  最后一步——把“误差够小”换成“是某个渐近分数”。
- `number-theory.elementary.pell-equation`：`PellSolution` 结构与其方程字段是方向 I 的输入。
- `number-theory.elementary.pell-positive-existence`：提供 `(0 < d, ¬IsSquare d)` 这组假设口径；
  Lean 证明只用 `hns` 把 `0 < d` 加强成 `1 < d`，数学上并不需要非平方假设（见上）。
- Mathlib 侧的关键承载：`GenContFract.abs_sub_convs_le`（收敛子误差界）、
  `Real.convs_eq_convergent`（把 `Real.convergent` 与 `GenContFract.convs` 对齐）、
  `GenContFract.conv_eq_num_div_den`（`convs = nums / dens`）、
  `Rat.den_div_eq_of_coprime`（互素比值的既约分母）、
  `GenContFract.contsAux_recurrence` 与 `GenContFract.IntFractPair.exists_succ_get?_stream_of_gcf_of_get?_eq_some`
  （continuant 整性）。

# 应用与陷阱

- 应用：任何“Pell 解 ⟹ 极好有理逼近 ⟹ 收敛子”的推理现在可以在本库接口上直接进行，不需要
  再绕到 Mathlib 的广义连分数内部表示。
- 应用：方向 II 给出 `|q.num² - d q.den²|` 的统一上界，可用于证明渐近分数的 Pell 形式只能取
  有限多个值。
- 陷阱：方向 II 的右端是 `≤`，不是 `<`；证明链上两步都是非严格放缩，改写成 `<` 会说谎。
- 陷阱：方向 II **不是**“收敛子都是 Pell 解”，也**不是**“`√d` 的收敛子产生 Pell 解”。它只给上界。
- 陷阱：方向 I 的 `hns` 只用于把 `0 < d` 加强成 `1 < d`；它不是证明的数学必需条件，别误以为
  “非平方”是这条桥成立的原因。
- 边界：本条目**没有**做“`√d` 连分数展开的周期末端渐近分数给出基本解”。那需要 `√d` 部分商
  序列的周期性，而当前 Mathlib 没有 `GenContFract.of_sqrt`（已实测不存在），本库也还没有周期层
  （由另一窗口负责）。因此本条目不是“`√d` 收敛子产生 Pell 解”的完整实现。
- 边界：本条目不涉及负 Pell 方程 `x² - d y² = -1` 的任何结论，也不声称 `PellSolution` 全体解的
  分类或幂生成。
