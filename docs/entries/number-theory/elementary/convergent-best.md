---
id: number-theory.elementary.convergent-best
family: number-theory.elementary
variant: classical
kind: theorem
state: verified
title: 连分数收敛子的最佳逼近性
summary: 无理数的每个 n ≥ 1 阶收敛子在其分母预算内误差最小
premises: [number-theory.elementary.continued-fraction-convergent, number-theory.elementary.best-rational-approximation]
mathlib: [GenContFract.of, GenContFract.contsAux, GenContFract.nums, GenContFract.dens, GenContFract.convs, GenContFract.contsAux_recurrence, GenContFract.of_partNum_eq_one_and_exists_int_partDen_eq, GenContFract.succ_nth_fib_le_of_nth_den, GenContFract.sub_convs_eq, GenContFract.conv_eq_num_div_den, GenContFract.of_correctness_of_terminates, SimpContFract.determinant, Real.convs_eq_convergent, Rat.den_dvd]
provenance:
  source_type: book
  ref: "hardy-wright-number-theory-2008"
---

# 动机

连分数算法给出了一串越来越好的有理逼近。教材里紧接着要回答的问题是：这些逼近到底“好”到什么
程度？答案是它们已经是分母预算内的最优解——任何分母不超过第 `n` 个收敛子分母的有理数，都不可能
比它更接近 `ξ`。这是连分数作为“最佳逼近生成器”的全部价值所在，也是 Legendre 判据（反方向）
之外的另一个半边。

前置文件 `ContinuedFractions.lean` 明确登记过：Mathlib 只有 Legendre 判别准则
（误差足够小 ⇒ 是收敛子），没有“每个收敛子都是最佳逼近”。本 Entry 补上这缺失的一半。

# 直觉

设 `ξ` 无理，收敛子记作 `pₙ/qₙ`。三件事凑在一起就得到结论：

1. **收敛子交替地从两侧逼近**：`ξ` 在第 `n` 个与第 `n+1` 个收敛子之间来回换边，所以
   `δₙ = qₙ ξ - pₙ` 与 `δₙ₊₁` 反号；
2. **相邻收敛子构成格基**：`pₙ qₙ₊₁ - qₙ pₙ₊₁ = ±1`，于是任意整数对 `(p, q)` 都能唯一写成
   `a (pₙ, qₙ) + b (pₙ₊₁, qₙ₊₁)`；
3. **分母预算锁死系数符号**：`0 < q < qₙ₊₁` 逼出 `a b ≤ 0` 且 `a ≠ 0`。

把 1 与 3 合起来：`q ξ - p = a δₙ + b δₙ₊₁`，而 `a δₙ` 与 `b δₙ₊₁` 同号，于是
`|q ξ - p| = |a| |δₙ| + |b| |δₙ₊₁| ≥ |δₙ|`。最后除以 `q ≤ qₙ` 就得到按误差比较的结论。

直观图像：`pₙ/qₙ` 与 `pₙ₊₁/qₙ₊₁` 是相邻的 Farey 邻居，它们之间没有分母更小的分数；
`ξ` 夹在中间，任何分母不够大的分数都被挤到区间之外，只能离 `ξ` 更远。

# 陈述（自然语言）

设 `ξ` 是无理实数，`n ≥ 1`。若 `q` 是 `ξ` 的第 `n` 个连分数收敛子，则对任意有理数 `r`，
只要 `r` 的（约分后）分母不超过 `q` 的分母，就有

`|ξ - q| ≤ |ξ - r|`。

即：第 `n` 个收敛子是分母预算 `≤ q.den` 内的最佳有理逼近（并列最佳允许出现，因为结论用 `≤`）。

**边界**：`n = 0` 时命题为假，`n ≥ 1` 不可去。反例：`ξ = 1.7` 的第 0 个收敛子是 `1`，误差 `0.7`；
而 `2/1` 的分母也是 `1`，误差 `0.3 < 0.7`。根源是 `Q₀ = 1 ≤ Q₁` 可能取等号
（`fract ξ ∈ (1/2, 1)` 时 `Q₁ = ⌊1/fract ξ⌋ = 1`），而证明中分母严格递增 `Qₙ < Qₙ₊₁`
只在 `n ≥ 1` 成立。

**强度说明**：本文件实际证明的是更强的“第二类”陈述（见核心引理
`abs_sub_convergent_le_of_decomposition`）：对整数 `p, q`，`0 < q < Qₙ₊₁` 时
`|q ξ - p| ≥ |Qₙ ξ - Pₙ|`。主定理是把它除以分母预算后的“第一类”形式，强度不超出核心引理。

# 陈述（Lean 对照）

```lean
theorem convergent_isBestRationalApproximation {ξ : ℝ} (hξ : Irrational ξ) {n : ℕ}
    (hn : 1 ≤ n) :
    IsBestRationalApproximation ξ (continuedFractionConvergent ξ n)
```

其中 `IsBestRationalApproximation` 来自前置 Entry：

```lean
def IsBestRationalApproximation (ξ : ℝ) (q : ℚ) : Prop :=
  ∀ r : ℚ, r.den ≤ q.den → rationalApproximationError ξ q ≤ rationalApproximationError ξ r
```

核心引理（比主定理强，是主定理的代数支点）：

```lean
theorem abs_sub_convergent_le_of_decomposition (ξ : ℝ) (hξ : Irrational ξ) (n : ℕ)
    {p q a b : ℤ}
    (hp : (p : ℝ) = (a : ℝ) * (continuantNumerator ξ n : ℝ)
      + (b : ℝ) * (continuantNumerator ξ (n + 1) : ℝ))
    (hq : (q : ℝ) = (a : ℝ) * (continuantDenominator ξ n : ℝ)
      + (b : ℝ) * (continuantDenominator ξ (n + 1) : ℝ))
    (hq0 : 0 < (q : ℝ))
    (hqlt : (q : ℝ) < (continuantDenominator ξ (n + 1) : ℝ)) :
    |(continuantDenominator ξ n : ℝ) * ξ - (continuantNumerator ξ n : ℝ)| ≤
      |(q : ℝ) * ξ - (p : ℝ)|
```

# 思维脉络（thinking trace）

证明按“结构引理 → 代数支点 → 组装”三层推进，每一步都在 `/tmp` 单独立项验证后才进入正式文件：

1. **整数性**（`exists_int_contsAux` / `continuantNumerator` / `continuantDenominator`）。
   Mathlib 只给 `of v` 的 continuants 是“有理数”，但教材推导需要它们在 `ℤ` 里做整除与格分解。
   对 `contsAux` 用 `Nat.twoStepInduction`，步进靠 `contsAux_recurrence` 加上
   “部分分子恒为 `1`、部分分母恒为整数”。第一次把递推假设同时放进 `rw` 列表时编译器报
   “找不到 `contsAux n` 的模式”，教训是 `contsAux_recurrence` 的实例化已经把两个假设代入目标，
   多余的 `rw` 反而失败（Playbook §1.2 的同类现象）。
2. **非终止性**（`of_irrational_not_terminatedAt`）。`terminates_iff_rat` 所在的模块不在本文件的
   import 闭包内，因此改走 `of_correctness_of_terminates` + `Real.convs_eq_convergent`：
   终止意味着 `ξ` 恰等于某个收敛子，而收敛子是有理数，与 `Irrational` 矛盾。
3. **分母结构**（`dens_pos`、`dens_add_two`、`dens_lt_dens_succ`）。`fib` 下界给正性；
   两步递推给严格单调，且这里必须 `n ≥ 1`——这正是主定理边界假设的来源。
4. **幺模性**（`continuant_determinant`）。`SimpContFract.determinant` 的陈述里出现
   `↑(SimpContFract.of ξ)`，与 `GenContFract.of ξ` 只是 defeq 而非语法相同，`rw` 拒绝匹配；
   解法是先 `have h : <of 版本的类型> := <SimpContFract 版本的项>` 让内核做 defeq 转换。
5. **符号交替**（`exists_stream_fr_ne_zero`、`sub_convs_eq_neg_one_pow_div`、`delta_mul_delta_succ_neg`）。
   `sub_convs_eq` 是唯一的符号来源，但它要求 `IntFractPair.stream ξ n = some ifp` 且 `ifp.fr ≠ 0`；
   由非终止性先取 `stream ξ (n+1) ≠ none`，再用 `succ_nth_stream_eq_some_iff` 反推第 `n` 项。
6. **分母桥**（`convergent_den_le_continuantDenominator`）。证明里用的是 continuant 分母 `qₙ`，
   而公开定义比较的是 `Rat.den`。由 `Rat.cast_injective` + `Rat.cast_divInt` 把
   `continuedFractionConvergent ξ n` 认成 `Rat.divInt pₙ qₙ`，再用 `Rat.den_dvd` 得到整除、
   `Int.le_of_dvd` 转不等式。这一步很关键：`pₙ/qₙ` 未必约分，只能得到 `≤` 而非 `=`。
7. **组装**（`abs_sub_convergent_le_of_decomposition`、`convergent_isBestRationalApproximation`）。
   系数取 `a = D (r.num qₙ₊₁ - r.den pₙ₊₁)`、`b = D (r.den pₙ - r.num qₙ)`（`D = pₙ qₙ₊₁ - qₙ pₙ₊₁`），
   用 `D² = 1` 验证 `a (pₙ,qₙ) + b (pₙ₊₁,qₙ₊₁) = (r.num, r.den)`。把 `hpZ`/`hqZ` 抬到 `ℝ` 时
   最初写 `rw [hpZ]`，结果 `hpZ` 里的 `r.num` 在目标右侧（`a, b` 的定义式也含 `r.num`）被一并重写，
   目标变成一个假的四次恒等式；改用 `congrArg (fun z : ℤ => (z : ℝ))` 再 `simpa` 才正确。
   这是本批最隐蔽的一次错误。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 第 `n` 个收敛子 | `continuedFractionConvergent ξ n` |
| 收敛子的实数化 | `convergent_cast_eq : ↑(continuedFractionConvergent ξ n) = Pₙ / Qₙ` |
| continuant 分子 / 分母（未必约分） | `continuantNumerator ξ n` / `continuantDenominator ξ n` |
| 约分分母不超过 continuant 分母 | `convergent_den_le_continuantDenominator` |
| 逼近误差 | `rationalApproximationError ξ q = |ξ - ↑q|` |
| 分母预算内误差最小 | `IsBestRationalApproximation ξ q` |
| 相邻收敛子行列式 `±1` | `continuant_determinant` |
| `δₙ = qₙ ξ - pₙ` 反号 | `delta_mul_delta_succ_neg` |
| `n ≥ 1` 时分母严格递增 | `dens_lt_dens_succ` |
| 第二类最佳逼近（更强） | `abs_sub_convergent_le_of_decomposition` |

# 依赖（人话版）

- `number-theory.elementary.continued-fraction-convergent`：结论里用的教材层收敛子
  `continuedFractionConvergent`，以及它与 Mathlib `GenContFract.of` 的桥。
- `number-theory.elementary.best-rational-approximation`：结论谓词 `IsBestRationalApproximation`
  与误差函数 `rationalApproximationError`；本 Entry 只证明该谓词对收敛子成立，不改动它的定义。
- `GenContFract.of_correctness_of_terminates` + `Real.convs_eq_convergent`：把“终止”翻译成
  “`ξ` 是有理数”，从而对无理数得到永不终止。
- `SimpContFract.determinant`：相邻收敛子的行列式为 `±1`，`ℤ²` 基分解的来源。
- `GenContFract.sub_convs_eq`：误差 `ξ - convs n = (-1)ⁿ / (正数)`，符号交替的唯一来源。
- `GenContFract.succ_nth_fib_le_of_nth_den`：分母的 `fib` 下界，给正性与严格单调。
- `Rat.den_dvd`：约分分母整除任何分母表示，把 `Rat.den` 与 continuant 分母接上。

本 Entry 不依赖 `number-theory.elementary.legendre-criterion`：两条定理方向不同，证明互不引用。
registry 中 `premises` 因此只登记上面前两个 Entry。

# 与 Legendre 判据的方向关系

| | 假设 | 结论 | 方向 |
|---|---|---|---|
| `number-theory.elementary.legendre-criterion` | `IsLegendreApproximation ξ q`（`|ξ - q| < 1/(2 q.den²)`） | `∃ n, q = continuedFractionConvergent ξ n` | 误差足够小 ⇒ 是收敛子（充分判据） |
| 本 Entry | `q = continuedFractionConvergent ξ n` 且 `n ≥ 1` | `IsBestRationalApproximation ξ q` | 是收敛子 ⇒ 分母预算内误差最小 |

两者**互不蕴含**，是同一枚硬币的两面，而不是同一条定理的强弱形式：

- **本条推不出 Legendre**（“是收敛子”不蕴含“误差足够小”）。取 `ξ = [0; 100, 1, 1, 1, …]`
  （即 `ξ = 1/(100 + 1/φ)`，`φ` 为黄金比），它的第 1 个收敛子是 `1/100`，误差 `6.14×10⁻⁵`，
  而 Legendre 阈值是 `1/(2 · 100²) = 5×10⁻⁵`，误差**大于**阈值。所以 `1/100` 是收敛子却不满足
  `IsLegendreApproximation`，本条的假设严格弱于 Legendre 的假设（两者假设不可比）。
- **Legendre 推不出本条**。它的结论只是“`q` 是某个收敛子”这一身份，不含任何最优性；
  而且它允许 `n = 0`，本条在 `n = 0` 时是**假**的。要得到最优性必须另外引用本条。
- 第一类最佳逼近的**逆命题为假**：`√2` 的 `4/3` 在分母预算 `≤ 3` 内误差最小
  （`0.08088…`，优于 `3/2` 的 `0.08579…`），但它不是收敛子——`√2` 的收敛子是
  `1/1, 3/2, 7/5, 17/12, …`，`4/3` 只是 `1/1` 与 `3/2` 的中介分数。
  所以“最佳逼近 ⇒ 收敛子”**不成立**，本 Entry 不能反向使用。
  注意方向别写反：`IsBestRationalApproximation (√2) (4/3)` 是**真**命题，
  `¬ IsBestRationalApproximation (√2) (4/3)` 是**假**命题。
- 上述两个反例在本批中经数值核算确认（穷举分母受限的候选、逐项计算收敛子），但**未形式化**；
  文档只把它们作为未经形式化的说明，不冒充已证结论（见“应用与陷阱”）。

# 应用与陷阱

- 应用：给定 `ξ` 的连分数展开，第 `n` 个收敛子在分母预算 `≤ (conv n).den` 内自动最优，
  无需再搜索。这把“找最佳逼近”归约成“跑连分数算法”。
- 应用：结合 Legendre 判据可以双向定位——先用 Legendre 从误差反推身份，再用本条从身份得到最优性。
- 陷阱：`1 ≤ n` 是本质假设，不能删（反例 `ξ = 1.7`，`n = 0`）。
- 陷阱：结论比较的是**约分分母** `q.den`。对未约分的表示 `a/b` 用 `b` 比较会得到不同的（更弱的）
  命题；本文件用 `convergent_den_le_continuantDenominator` 专门处理这一层。
- 陷阱：`≤` 允许并列最佳（例如 `ξ` 恰为两个候选的中点时），不要把它读成严格最小。
- 陷阱：本条**不能**反用。“最佳逼近 ⇒ 收敛子”为假，`√2` 的 `4/3` 是反例。
  该反例本批只做了数值核算（穷举分母 `≤ 3` 的有理数），**没有**写成 Lean 定理；
  因此这里只作未经形式化的说明，不冒充已证结论。
- 陷阱：`continuantNumerator` / `continuantDenominator` 是 continuant 的（未必约分的）分子分母，
  不等于 `(continuedFractionConvergent ξ n).num` / `.den`；两者只由
  `convergent_den_le_continuantDenominator` 单向联系。
