# Mathlib-RADAR —— 用到的 Mathlib 引理速查（新生版）

> **为什么有这个文档**：库里的证明大量直接调用 mathlib 的自带定理/实例。
> 它们名字奇形怪状（`tendsto_atTop_ciSup`、`isBoundedUnder_of_eventually_le`…），
> 一个大一新生看到只会"一眼抹黑"。本表把这些名字**逐条用人话翻译**：
> 它说什么、长什么样、从哪来、我正在用它在哪。

**给读者**：每条格式固定。先看"人话"；签名只是让你认得出它；
"谁在用"告诉你它在库里的位置（去翻对应叙述层看到完整讲解）。

**给维护者**：新增条目时，凡在证明里引用了一个 mathlib 名（含实例），
**必须**在此登记一条（协议见 INGESTION_PROTOCOL Step 3"登记 RADAR"）。
找不到出处时用 `grep -rn "<名字>" .lake/packages/mathlib/Mathlib/` 定位模块族。

## 环同构与整除的实现桥

### `Quotient` / `Quot.sound`
- **人话**：把本库显式理想同余真正实现成商集，并证明同余代表元给出同一商类。
- **出处**：Lean/Mathlib 的商类型基础设施。
- **谁在用**：`abstract-algebra.ring.iso-theorems`；只作实现后端，不代替教材商环定义。

### `Associated` / `Irreducible` / `Prime`
- **人话**：Mathlib 对相伴、不可约元和素元的标准谓词。
- **出处**：Mathlib 交换幺半群与分解理论。
- **谁在用**：`abstract-algebra.ring.divisibility` 的具名兼容桥；教材主定理使用本库谓词。

## 数项级数与幂级数

### `Finset.Nat.sum_antidiagonal_eq_sum_range_succ`
- **人话**：把 `i+j=n` 上的有限反对角线和改写成 `k=0,…,n` 的卷积和。
- **出处**：`Mathlib/Algebra/BigOperators/NatAntidiagonal.lean`。
- **谁在用**：`analysis.series.cauchy-product-definition`。

### `Finset.sum_range_diag_flip`
- **人话**：把逐条反对角线求和改写成对有限三角区域 `i+j<N` 的迭代求和。
- **出处**：Mathlib 的有限大算子恒等式。
- **谁在用**：`analysis.series.cauchy-product-definition`。

### `summable_norm_sum_mul_range_of_summable_norm`
- **人话**：若两个级数的范数都可和，则它们每条 Cauchy 反对角线之和的范数也可和。
- **出处**：`Mathlib/Analysis/Normed/Ring/InfiniteSum.lean`。
- **谁在用**：`analysis.series.cauchy-product-absolute`。

### `hasSum_sum_range_mul_of_summable_norm`
- **人话**：两个绝对可和级数的 Cauchy 乘积收敛到两级数和的乘积。
- **出处**：`Mathlib/Analysis/Normed/Ring/InfiniteSum.lean`。
- **谁在用**：`analysis.series.cauchy-product-absolute`。

### `cauchy_product`
- **人话**：一方绝对 Cauchy、另一方 Cauchy 时，两个部分和之积与 Cauchy 乘积部分和之差趋零。
- **出处**：`Mathlib/Algebra/Order/CauSeq/BigOperators.lean`。
- **谁在用**：`analysis.series.mertens`。

### `Finset.Nat.sum_antidiagonal_swap`
- **人话**：交换自然数反对角线上的两个坐标不改变有限和，用来交换 Cauchy 乘积的两个因子。
- **出处**：`Mathlib/Algebra/BigOperators/NatAntidiagonal.lean`。
- **谁在用**：`analysis.series.mertens`。

### `Real.tendsto_tsum_powerSeries_nhdsWithin_lt`
- **人话**：若实级数在 `x=1` 按自然顺序收敛，则其幂级数和在 `x→1⁻` 时趋于该级数和。
- **出处**：`Mathlib/Analysis/Complex/AbelLimit.lean`。
- **谁在用**：`analysis.series.abel-cauchy-product`。

### `summable_powerSeries_of_norm_lt_one`
- **人话**：级数在 `x=1` 收敛时，乘上几何权 `x^n` 后在 `|x|<1` 内绝对可和。
- **出处**：`Mathlib/Analysis/SpecificLimits/Normed.lean`。
- **谁在用**：`analysis.series.abel-cauchy-product`。

### `summable_powerSeries_of_norm_lt`
- **人话**：幂级数在某点收敛时，在到中心距离严格更小的点绝对收敛。
- **出处**：`Mathlib/Analysis/SpecificLimits/Normed.lean`。
- **谁在用**：`analysis.power-series.radius`。

### `Real.rpow_le_rpow` / `Real.rpow_inv_natCast_pow`
- **人话**：非负实数实幂保持大小关系，并把先取 `n` 次方根再取 `n` 次幂还原为原数。
- **出处**：Mathlib 的实数幂接口。
- **谁在用**：`analysis.series.root-test`。

### `Summable.of_norm_bounded_eventually_nat` / `tendsto_order`
- **人话**：最终被可和非负数列控制即可和；序拓扑中的极限可转成最终严格上下界。
- **出处**：Mathlib 的无限和与序极限接口。
- **谁在用**：`analysis.series.root-test`。

### `Summable.tsum_add`
- **人话**：两个可和级数可以逐项相加，且总和等于两个总和之和。
- **出处**：Mathlib 的无限和加法接口。
- **谁在用**：`analysis.power-series.operations`。

### `hasDerivAt_tsum_of_isPreconnected`
- **人话**：开连通区间上的可导函数列若导数具有可和的一致控制，且原函数列在一点可和，
  则级数和可导并可逐项求导。
- **出处**：`Mathlib/Analysis/Calculus/SmoothSeries.lean`。
- **谁在用**：`analysis.power-series.operations`。

### `Summable.of_norm_bounded` / `Summable.sum_add_tsum_nat_add`
- **人话**：前者由可和数列的逐项范数上界推出可和性；后者把无限和拆成有限前缀与平移后的尾和。
- **出处**：Mathlib 的赋范群无限和与自然数下标接口。
- **谁在用**：`analysis.power-series.operations`，分别用于导数级数可和性与下标重排。

### `ENNReal.ofReal_toReal`、`ENNReal.ofReal_le_ofReal_iff`、`ENNReal.ofReal_lt_ofReal_iff`
- **人话**：半径有限时，在扩展非负实数半径与其实数值之间来回转换，并把大小关系转回实数。
- **出处**：Mathlib 的扩展非负实数基础接口。
- **谁在用**：`analysis.power-series.endpoints`。

### `abs_eq`
- **人话**：把 `|u|=r`（`r≥0`）分成 `u=r` 或 `u=-r`，从而识别幂级数的两个端点。
- **出处**：Mathlib 的线性有序环绝对值接口。
- **谁在用**：`analysis.power-series.endpoints`。

### `summable_of_ne_finset_zero`
- **人话**：若函数在某个有限集之外恒为零，则对应的无限和可和。
- **出处**：Mathlib 的无限和基础接口。
- **谁在用**：`analysis.power-series.definition`，用于证明中心处除常数项外全为零。

### `Nat.find`
- **人话**：从自然数上的存在性证明中选出满足谓词的最小下标。
- **签名**：若 `h : ∃ n, p n`，则 `Nat.find h : ℕ`，并有 `Nat.find_spec`、`Nat.find_min`。
- **出处**：`Mathlib/Data/Nat/Find.lean`。
- **谁在用**：`analysis.series.riemann-rearrangement`。

### `Finset.sum_Ico_eq_sub`
- **人话**：有限区间 `[m,n)` 上的和等于两个前缀和之差。
- **签名**：`∑ k ∈ Ico m n, f k = (∑ k ∈ range n, f k) - ∑ k ∈ range m, f k`（`m ≤ n`）。
- **出处**：`Mathlib/Algebra/BigOperators/Intervals.lean`。
- **谁在用**：`analysis.series.riemann-rearrangement`。

### `Equiv.ofBijective`
- **人话**：把一个已证明为双射的函数包装成等价 `Equiv`。
- **签名**：`Equiv.ofBijective f hf : α ≃ β`。
- **出处**：`Mathlib/Logic/Equiv/Defs.lean`。
- **谁在用**：`analysis.series.riemann-rearrangement`。

### `Filter.liminf_le_iff`
- **人话**：在适当有界条件下，用“最终低于任意严格上界”刻画 `liminf ≤ a`。
- **出处**：`Mathlib/Order/LiminfLimsup.lean`。
- **谁在用**：`analysis.series.riemann-rearrangement`。

### `Filter.le_limsup_iff`
- **人话**：在适当有界条件下，用“任意严格下界被频繁超过”刻画 `a ≤ limsup`。
- **出处**：`Mathlib/Order/LiminfLimsup.lean`。
- **谁在用**：`analysis.series.riemann-rearrangement`。

### `tendsto_of_tendsto_of_tendsto_of_le_of_le'`
- **人话**：夹逼定理；若上下两个函数趋于同一极限，且最终夹住中间函数，则中间函数同趋于该极限。
- **出处**：Mathlib 的序滤子极限基础模块。
- **谁在用**：`analysis.series.riemann-rearrangement`。

---

## G1. 收敛与滤子语言（Tendsto / atTop / 𝓝）

这一组是"极限"的机器语言。`𝓝`、`atTop`、`Tendsto` 分别回答：
"哪儿是目标？""从哪个方向来？""最终会不会到？"

### `Filter.Tendsto`
- **人话**："f 顺着滤子 l₁ 逼近 l₂"：目标 l₂ 的每个邻域，都被 f 在源 l₁ 上"最终覆盖"。
  对数列：`Tendsto u atTop (𝓝 l)` = "从充分大的 n 起，u n 落进 l 的任意邻域" = aₙ → l。
- **签名**：`Tendsto f l₁ l₂ : Prop`
- **出处**：`Mathlib/Order/Filter/Tendsto.lean`
- **谁在用**：几乎所有极限条目（`analysis.sequence.*`、`analysis.real.archimedean` 等）。

### `Filter.atTop`
- **人话**：自然数上的"趋于正无穷"滤子：一事件"大到最终成立"当且仅当它包含某区间 `{n ≥ N}`。
- **签名**：`(atTop : Filter α)`（对带 `Preorder`、非空、有向的类型）
- **出处**：`Mathlib/Order/Filter/AtTopBot/Basic.lean`
- **谁在用**：所有数列极限条目。

### `nhds`（记号 `𝓝`）
- **人话**：点 l 的"邻域滤子"：所有包含 l 的某个开邻域的集合。
  `𝓝 l` 就是"l 附近"这个概念的严格化。
- **签名**：`(𝓝 : X → Filter X)`（`TopologicalSpace X`）
- **出处**：`Mathlib/Topology/Basic.lean`
- **谁在用**：所有极限条目。

### `Filter.eventually_atTop`（记号 `∀ᶠ n in atTop, ...`）
- **人话**："从某一项起都满足"：`(∀ᶠ n in atTop, p n) ↔ ∃ N, ∀ n ≥ N, p n`。
  这是 ε-N 里"最终"两字的机器写法。
- **签名**：`(∀ᶠ x in atTop, p x) ↔ ∃ a, ∀ b ≥ a, p b`
- **出处**：`Mathlib/Order/Filter/AtTopBot/Basic.lean`
- **谁在用**：`analysis.sequence.bounded`。

### `Metric.tendsto_atTop`
- **人话**：度量空间里"u 趋于 a ⟺ 距离最终小于任意 ε"。实轴上的 dist 就是 |x−y|，
  于是这正是教材的 ε-N 判据。
- **签名**：`Tendsto u atTop (𝓝 a) ↔ ∀ ε > 0, ∃ N, ∀ n ≥ N, dist (u n) a < ε`
- **出处**：`Mathlib/Topology/MetricSpace/Pseudo/`

### `Real.dist_eq`
- **人话**：实轴上"距离 = 绝对值"：`dist x y = |x - y|`。
  常被 `simpa [Real.dist_eq]` 用来把 ε-N 换成教材记号。
- **签名**：`(x y : ℝ) : dist x y = |x - y|`
- **出处**：`Mathlib/Topology/MetricSpace/Pseudo/Defs.lean`

### `tendsto_of_tendsto_of_tendsto_of_le_of_le`
- **人话**：**夹逼定理**的通用版：g → a、h → a，且恒有 g ≤ f ≤ h，则 f → a。
  三个参名 `of_tendsto_of_tendsto_of_le` 读作"既然 g 和 h 都收敛，又是 ≤ 夹住的"。
- **签名**：... `(hg : Tendsto g b (𝓝 a)) (hh : Tendsto h b (𝓝 a)) (hgf : g ≤ f) (hfh : f ≤ h) :
  Tendsto f b (𝓝 a)`
- **出处**：`Mathlib/Topology/Order/Basic.lean`
- **谁在用**：`analysis.sequence.squeeze`。

### `tendsto_nhds_unique`
- **人话**：**极限唯一**：一个函数/序列在同一个滤子上如果同时趋于 a 和 b，则 a = b。
  要求空间是 Hausdorff（T2），ℝ 满足。
- **签名**：`(ha : Tendsto f l (𝓝 a)) (hb : Tendsto f l (𝓝 b)) : a = b`
- **出处**：`Mathlib/Topology/Separation/`
- **谁在用**：`analysis.sequence.unique`。

### `tendsto_atTop_ciSup`
- **人话**：**单调有界收敛**的机器版：单调且值域有上界 ⇒ 收敛到"索引上确界 ⨆ u"。
  `ci` 前缀 = "conditionally"（条件完备格上）。
- **签名**：`Monotone f → BddAbove (range f) → Tendsto f atTop (𝓝 (⨆ i, f i))`
- **出处**：`Mathlib/Topology/Order/MonotoneConvergence.lean`
- **谁在用**：`analysis.sequence.monotone-convergence`。
- **坑**：它给的是 `⨆ i, f i`，想写成 `sSup (range f)` 要 `IsLUB.ciSup_eq` 桥接（见 G3）。

### `StrictMono.tendsto_atTop`
- **人话**：**严格递增的下标序列也冲向无穷**：φ : ℕ → ℕ 严格递增 ⟹ `Tendsto φ atTop atTop`。
  子序列语言的关键一桥："跳着取"的下标函数不会"停在原地"。
- **签名**：`{φ : ℕ → ℕ} (h : StrictMono φ) : Tendsto φ atTop atTop`
- **出处**：`Mathlib/Order/Filter/AtTopBot/Tendsto.lean`
- **谁在用**：`analysis.sequence.subsequence`。

### `Filter.Tendsto.comp`
- **人话**：**收敛的复合**：g 沿 y 趋于 z，f 沿 x 趋于 y ⟹ g∘f 沿 x 趋于 z。
  子序列定理 `u∘φ → l` 就是 `u → l` 与 `φ → atTop` 的复合。
- **签名**：`(hg : Tendsto g y z) (hf : Tendsto f x y) : Tendsto (g ∘ f) x z`
- **出处**：`Mathlib/Order/Filter/Tendsto.lean`
- **谁在用**：`analysis.sequence.subsequence`、`analysis.func-limit.comp`（复合函数极限）。

### `ContinuousAt.tendsto`
- **人话**：点连续 ⟹ 极限可穿过：`ContinuousAt g L` 给出 `Tendsto g (𝓝 L) (𝓝 (g L))`。
- **签名**：`(h : ContinuousAt f x) : Tendsto f (𝓝 x) (𝓝 (f x))`
- **出处**：`Mathlib/Topology/Basic.lean`
- **谁在用**：`analysis.func-limit.comp`。

### `div_eq_zero_iff`
- **人话**：`a/b = 0 ⟺ a = 0 ∨ b = 0`。证"差商为 0 ⟹ 分子为 0"的辅助。
- **签名**：`a / b = 0 ↔ a = 0 ∨ b = 0`
- **出处**：`Mathlib/Algebra/Order/GroupWithZero/`
- **谁在用**：`analysis.mvt.constant`（f'=0 ⟹ 常数）。

### `Filter.Tendsto.neg`
- **人话**：极限的负号随便进出：`u → l` ⟹ `-u → -l`。把反单调序列 `bₙ` 换成单调的 `-bₙ` 套单调收敛定理的关键一拧。
- **签名**：`(h : Tendsto u atTop (𝓝 l)) : Tendsto (fun n => -u n) atTop (𝓝 (-l))`
- **出处**：`Mathlib/Order/Filter/Tendsto.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.mct-to-nested-intervals`（`antitone_limit_le` 里 `hL.neg`）。

### `Filter.Tendsto.const_mul`
- **人话**：常数乘法可进出极限：`f → a` ⟹ `c·f → c·a`。做"`(b-a)·(1/2)ⁿ → 0`"这类缩放的标准手法。
- **签名**：`(b : M) (hf : Tendsto f x (𝓝 a)) : Tendsto (fun x => b * f x) x (𝓝 (b * a))`
- **出处**：`Mathlib/Order/Filter/Tendsto.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`、`analysis.completeness.equivalence-cycle.cauchy-to-sup`（`hpow.const_mul (b - a)`）。

### `tendsto_pow_atTop_nhds_zero_of_norm_lt_one`
- **人话**：`‖r‖ < 1` 时 `rⁿ → 0`。几何级数收敛的底子；对 `r = 1/2` 就是"二分区间直径 → 0"。
  这是**阿基米德原理的形式化身**（等价环里只有 `cauchy-to-sup` 一道显式用它）。
- **签名**：`(h : ‖x‖ < 1) : Tendsto (fun n => x ^ n) atTop (𝓝 0)`
- **出处**：`Mathlib/Analysis/SpecificLimits/Normed.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`、`analysis.completeness.equivalence-cycle.cauchy-to-sup`（区间长度趋于 0 的发动机）。

### `one_div_pow`
- **人话**：倒数的幂等于幂的倒数：`(1/a)ⁿ = 1/aⁿ`。把 `(1/2)ⁿ` 换回 `1/2ⁿ` 的桥。
- **签名**：`(a : α) (n : ℕ) : (1 / a) ^ n = 1 / a ^ n`
- **出处**：`Mathlib/Algebra/Group/Pow/`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`、`analysis.completeness.equivalence-cycle.cauchy-to-sup`（`heq : c/2ⁿ = c·(1/2)ⁿ` 的 rewrite）。

### `Filter.Eventually.of_forall`
- **人话**：逐点成立 ⟹ 滤子最终成立：`(∀ x, p x) → ∀ᶠ x in f, p x`。把"每一项都 ≥ b"搬进滤子语言，喂给取极限引理。
- **签名**：`(hp : ∀ x, p x) : ∀ᶠ x in f, p x`
- **出处**：`Mathlib/Order/Filter/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`、`analysis.completeness.equivalence-cycle.cauchy-to-sup`（配 `ge_of_tendsto` / `le_of_tendsto`）。

### `Filter.Tendsto.sub`
- **人话**：差的极限 = 极限的差：`f → a`、`g → b` ⟹ `(f - g) → (a - b)`。
- **签名**：`(hf : Tendsto f l (𝓝 a)) (hg : Tendsto g l (𝓝 b)) : Tendsto (fun x => f x - g x) l (𝓝 (a - b))`
- **出处**：`Mathlib/Topology/Algebra/Group/`（连续减法沿滤子保极限）
- **谁在用**：`analysis.completeness.equivalence-cycle.cauchy-to-sup`（`rₙ - lₙ → y - x`，再配合 `tendsto_nhds_unique` 证 `x = y`）。

### `ge_of_tendsto` / `le_of_tendsto`
- **人话**：**不等式取极限**：每一项 `f n ≥ b` 且 `f → a`，则 `a ≥ b`（`ge_of_tendsto`，上界方向）；
  每一项 `f n ≤ b` 则 `a ≤ b`（`le_of_tendsto`，下界方向）。把"逐项夹住"升级为"极限也被夹住"。
- **签名**：`(colim : Tendsto f x (𝓝 a)) (h : ∀ᶠ c in x, b ≤ f c) : b ≤ a`
- **出处**：`Mathlib/Topology/Order/Basic.lean`
- **谁在用**：`analysis.func-limit.le`（极限保序）、`analysis.sequence.le`（序列保序）。

### 函数极限四条（`Filter.Tendsto.add/sub/mul/div`）
- **人话**：**函数极限的四则运算**：`f → L`、`g → M` 时，和/差/积/商（商要求 `M ≠ 0`）
  分别趋于 `L+M`、`L−M`、`L·M`、`L/M`。是序列极限四则的函数版，一行调完。
- **签名**：`Tendsto.add : f→L → g→M → (f+g)→(L+M)`（sub/mul/div 同构）
- **出处**：`Mathlib/Topology/Algebra/Group/`（域上加法/乘法连续）
- **谁在用**：`analysis.func-limit.add/sub/mul/div`、`analysis.sequence.add/sub/mul/div/const-mul`（序列版）。
- **谁在用**：`analysis.func-limit.add/sub/mul/div`、`analysis.func-limit.const-mul`。

### `tendsto_const_nhds` / `Filter.tendsto_id`
- **人话**：常数函数在任意滤子下趋于该常数；恒等映射 `id` 任一滤子上趋于同滤子
  （在点 a 处就是 `id → a`）。
- **签名**：`Tendsto (fun _ => x) f (𝓝 x)`；`Tendsto id x x`
- **出处**：`Mathlib/Order/Filter/Tendsto.lean`
- **谁在用**：`analysis.func-limit.const`、`analysis.func-limit.identity`。

### `Filter.Tendsto.congr'` / `Filter.Tendsto.congr`
- **人话**：**逐点/最终相等可替换**：若 `f` 与 `g` 最终（或逐点）相等，则二者的极限可互换。
  证明"换一个等价的函数再取极限"的胶水。
- **签名**：`(hl : f₁ =ᶠ[l] f₂) → Tendsto f₁ l₁ l₂ → Tendsto f₂ l₁ l₂`
- **出处**：`Mathlib/Order/Filter/Tendsto.lean`
- **谁在用**：`analysis.func-limit.congr`。

### `tendsto_atTop`
- **人话**：**关于"趋于正无穷"的 Tendsto 判据**：`Tendsto f l atTop ⟺ ∀ b, ∀ᶠ x in l, b ≤ f x`。
  把"发散到正无穷"从拓扑说法换回序不等式说法。
- **签名**：`Tendsto m f atTop ↔ ∀ b, ∀ᶠ a in f, b ≤ m a`
- **出处**：`Mathlib/Order/Filter/AtTopBot/Basic.lean`
- **谁在用**：`analysis.func-limit.at-top`（`tendsto_nhds_atTop_iff`）。

### `tendsto_one_div_atTop_nhds_zero_nat` / `tendsto_pow_atTop_atTop_of_one_lt`
- **人话**：`1/n → 0`（Heine 反证构造反例序列用）；`r > 1 ⟹ rⁿ → ∞`（幂函数发散到无穷）。
- **签名**：`tendsto_one_div_atTop_nhds_zero_nat`；`(hr : 1 < r) : Tendsto (fun n => r ^ n) atTop atTop`
- **出处**：`Mathlib/Analysis/SpecificLimits/Normed.lean`、`Mathlib/Algebra/Order/Archimedean/`
- **谁在用**：`analysis.func-limit.heine`、`analysis.func-limit.at-top`。

---

## G2. 有界（BddAbove / BddBelow / IsBoundedUnder）

### `BddAbove` / `BddBelow`
- **人话**："有上界"/"有下界"：存在一个数 ≥（或 ≤）集合的所有元素。
  `BddAbove s ⟺ ∃ M, ∀ x ∈ s, x ≤ M`。
- **签名**：`BddAbove s : Prop`（`BddBelow s : Prop`）
- **出处**：`Mathlib/Order/Bounds/Basic.lean`
- **谁在用**：`analysis.real.bounded-sets.*`、`analysis.sequence.bounded/monotone-convergence`。

### `BddAbove.mono`
- **人话**：**子集继承有界**：s ⊆ t 且 t 有上界，则 s 有上界。
- **签名**：`(h : s ⊆ t) → BddAbove t → BddAbove s`
- **出处**：`Mathlib/Order/Bounds/Basic.lean`
- **谁在用**：`analysis.real.bounded-sets.subset`。

### `Filter.isBoundedUnder_of_eventually_le` / `_ge`
- **人话**："最终在某界之下/之上" ⇒ 滤子意义下有界。把"∀ᶠ n, u n ≤ a"转成
  `atTop.IsBoundedUnder (· ≤ ·) u`。
- **签名**：`(h : ∀ᶠ x in f, u x ≤ a) : f.IsBoundedUnder (· ≤ ·) u`
- **出处**：`Mathlib/Order/Filter/IsBounded.lean`
- **谁在用**：`analysis.sequence.bounded`。

### `Filter.IsBoundedUnder.bddAbove_range` / `.bddBelow_range`
- **人话**：滤子语言的"最终有界"翻译回值域语言的"有界"：
  `atTop.IsBoundedUnder (· ≤ ·) u → BddAbove (range u)`。
- **签名**：`IsBoundedUnder (· ≤ ·) atTop u : BddAbove (Set.range u)`
- **出处**：`Mathlib/Order/Filter/IsBounded.lean`
- **谁在用**：`analysis.sequence.bounded`。

### `cauchySeq_bdd`
- **人话**：**Cauchy 列必有界**：`∃ R > 0`，任意两项距离 `< R`。Cauchy 定义一推即得——
  从某一项起任两项相互靠拢，再用这个 R 把前头有限项一起框住。
- **签名**：`(hu : CauchySeq u) : ∃ R > 0, ∀ m n, dist (u m) (u n) < R`
- **出处**：`Mathlib/Topology/MetricSpace/Cauchy.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（`cauchy_seq_bounded`：从 R 框住值域得 BddAbove ∧ BddBelow）。

---

## G3. 上确界 / 下确界（sSup / sInf / IsLUB / IsGLB）

### `IsLUB` / `IsGLB`
- **人话**：`IsLUB s a` = "a 是 s 的最小上界"（下界那边叫 `IsGLB`，最大下界）。
  两个条件：a 是上界；且没有任何更小的上界。
- **签名**：`IsLUB (s : Set α) (a : α) : Prop`
- **出处**：`Mathlib/Order/Bounds/Basic.lean`
- **谁在用**：`analysis.real.sup / inf`、`analysis.sequence.monotone-convergence`。

### `sSup` / `sInf`
- **人话**：集合的上确界/下确界算子（"最小的上界"的**值**）。
- **签名**：`sSup (s : Set α) : α`（`sInf` 对称）
- **出处**：`Mathlib/Order/ConditionallyCompleteLattice/Basic.lean`

### `Real.isLUB_sSup`
- **人话**：**确界原理（ℝ 版）**：非空有上界集的上确界存在且恰是最小上界。
- **签名**：`(h₁ : s.Nonempty) (h₂ : BddAbove s) : IsLUB s (sSup s)`
- **出处**：`Mathlib/Data/Real/`（合理路由）；`Real.isLUB_sSup` 即教科书的定理。
- **谁在用**：`analysis.real.sup`、`analysis.sequence.monotone-convergence`。

### `isGLB_csInf`
- **人话**：**下确界原理**：非空有下界集的下确界存在且是最大下界（`IsGLB`）。
- **签名**：`(hn : s.Nonempty) (hb : BddBelow s) : IsGLB s (sInf s)`
- **出处**：`Mathlib/Order/ConditionallyCompleteLattice/Basic.lean`
- **谁在用**：`analysis.real.inf`。

### `IsLUB.ciSup_eq`
- **人话**：把"索引上确界"改写成"值域上确界"的桥：
  若 `IsLUB (range f) a`，则 `⨆ i, f i = a`。
- **签名**：`(H : IsLUB (range f) a) : ⨆ i, f i = a`
- **出处**：`Mathlib/Order/ConditionallyCompleteLattice/Indexed.lean`
- **谁在用**：`analysis.sequence.monotone-convergence`。
- **坑**：条件完备格没有 `iSup_eq_sSup` 这种名字，桥就走这里。

### `CompactIccSpace.isCompact_Icc`
- **人话**：**闭区间紧**：[a,b]（a ≤ b 时）是紧集。实数完备性的拓扑身位。
- **签名**：`[CompactIccSpace α] {a b : α} : IsCompact (Set.Icc a b)`
- **出处**：`Mathlib/Topology/Order/`（compact intervals）
- **谁在用**：`analysis.sequence.bolzano-weierstrass`。

### `IsCompact.isSeqCompact`
- **人话**：**紧集上的序列必有收敛子列**（序列紧），且子列极限仍落在集内。
  这正是 B-W 的"从区间里挖出收敛子列"一步。
- **签名**：`(hs : IsCompact s) : IsSeqCompact s`
- **出处**：`Mathlib/Topology/Sequences.lean`
- **谁在用**：`analysis.sequence.bolzano-weierstrass`。

### `Set.range_nonempty`
- **人话**：非空指标下的值域非空：`Nonempty ι → (Set.range f).Nonempty`。
  喂给确界原理的 h₁。
- **签名**：`[Nonempty ι] (f : ι → α) : (Set.range f).Nonempty`
- **出处**：`Mathlib/Data/Set/Basic.lean`

### `mem_upperBounds`
- **人话**："x 是 s 的上界"的判准：`x ∈ upperBounds s ⟺ ∀ y ∈ s, y ≤ x`。upperBounds s 是"s 的所有上界"这个集合。
- **签名**：`a ∈ upperBounds s ↔ ∀ x ∈ s, x ≤ a`
- **出处**：`Mathlib/Order/Bounds/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.cauchy-to-sup`（二分上确界里"右端是上界 / 左端不是上界"的不变量全靠它进出）。

### `IsCompact.elim_finite_subcover`
- **人话**：**紧集开覆盖的有限子覆盖抽取器**：`IsCompact s` + 开覆盖 `{Uᵢ}` ⟹ 存在有限指标集 t 使 `s ⊆ ⋃ i∈t, Uᵢ`。有限覆盖原理就是它的一行调用。
- **签名**：`(hs : IsCompact s) (hUo : ∀ i, IsOpen (U i)) (hc : s ⊆ ⋃ i, U i) : ∃ t : Finset ι, s ⊆ ⋃ i ∈ t, U i`
- **出处**：`Mathlib/Topology/Compactness/Compact.lean`
- **谁在用**：真定理 `analysis.completeness.finite-cover`。

### `Set.Infinite.exists_accPt_of_subset_isCompact`
- **人话**：**紧集里的无限子集必有聚点**：s 无限、s ⊆ K 且 K 紧 ⟹ 存在 x ∈ K 是 s 的聚点。聚点定理的直接来源。
- **签名**：`(hs : s.Infinite) (hK : IsCompact K) (hsub : s ⊆ K) : ∃ x ∈ K, AccPt x (𝓟 s)`
- **出处**：`Mathlib/Topology/Compactness/Compact.lean`
- **谁在用**：真定理 `analysis.completeness.accumulation-point`。

---

## G4. 阿基米德与有理稠密

### `exists_nat_gt`
- **人话**：**阿基米德性质**：任给 x，有自然数 n > x（有理数/实数都行）。
- **签名**：`(x : R) : ∃ n, x < (↑n : R)`
- **出处**：`Mathlib/Algebra/Order/Archimedean/Defs.lean`
- **谁在用**：`analysis.real.archimedean`。

### `exists_rat_btwn`
- **人话**：**有理数稠密**：x < y 时，中间夹一个有理数（↑q 的实数嵌入）。
- **签名**：`(h : x < y) : ∃ q, x < ↑q ∧ ↑q < y`
- **出处**：`Mathlib/Algebra/Order/Archimedean/Basic.lean`
- **谁在用**：`analysis.real.density`。

### `div_lt_iff₀`
- **人话**：除法的正方向双向转换：`(b / c < a) ↔ (b < a * c)`（c > 0 时）。
- **签名**：`(hc : 0 < c) : b / c < a ↔ b < a * c`
- **出处**：`Mathlib/Algebra/Order/GroupWithZero/`
- **谁在用**：`analysis.real.archimedean` 的构造（`exists_nat_mul_gt`）里除过去数倍。

---

## G5. 集合代数（Set）

### `Set.ext`
- **人话**：**外延相等**：两个集合相等 ⟺ 元素完全一致。
- **签名**：`(h : ∀ x, x ∈ a ↔ x ∈ b) : a = b`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`settheory.set.operations.complement-union`、`settheory.set.operations.complement-inter` 等一切集合等式证明。

### `Set.Subset.trans`
- **人话**：**包含关系传递**：a ⊆ b 且 b ⊆ c ⇒ a ⊆ c。
- **签名**：`(h₁ : a ⊆ b) (h₂ : b ⊆ c) : a ⊆ c`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`settheory.set.subset.trans`。

### `Set.Subset.antisymm`
- **人话**：**双向包含即相等**：a ⊆ b 且 b ⊆ a ⇒ a = b。集合等式证明的万能开局。
- **签名**：`(h₁ : a ⊆ b) (h₂ : b ⊆ a) : a = b`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`settheory.set.subset.antisymm`。

### `Set.empty_subset`
- **人话**：**空集是全场的最小集**：∅ 包含于一切集合。
- **签名**：`∅ ⊆ s`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`settheory.set.empty-subset`。

### `Set.inter_union_distrib_left`
- **人话**：**交对并分配律**：s ∩ (t ∪ u) = (s ∩ t) ∪ (s ∩ u)。
- **签名**：`(s t u : Set α) : s ∩ (t ∪ u) = s ∩ t ∪ s ∩ u`
- **出处**：`Mathlib/Data/Set/Operations.lean`
- **谁在用**：`settheory.set.operations.inter-distrib`。

### `Set.compl_union` / `Set.compl_inter`
- **人话**：**德摩根律**：(s ∪ t)ᶜ = sᶜ ∩ tᶜ；(s ∩ t)ᶜ = sᶜ ∪ tᶜ。
- **签名**：`(s t : Set α) : (s ∪ t)ᶜ = sᶜ ∩ tᶜ`
- **出处**：`Mathlib/Data/Set/Basic.lean`（de Morgan 系列）
- **谁在用**：`settheory.set.operations.complement-union`、`settheory.set.operations.complement-inter`。
- **坑**：`compl_inter` 用到的 `¬(P∧Q) → ¬P∨¬Q` 就是排中律，改写不动（见条目叙述层）。

### `Set.sdiff_eq`
- **人话**：**差集 = 交补**：s \ t = s ∩ tᶜ。`sdiff` 是 mathlib 新版的名字（旧 `diff` 已弃用）。
- **签名**：`(s t : Set α) : s \ t = s ∩ tᶜ`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`settheory.set.operations.diff-inter-complement`。

### `Set.preimage_union` / `Set.preimage_inter`
- **人话**：**原像保并/保交**：f⁻¹(B₁ ∪ B₂) = f⁻¹B₁ ∪ f⁻¹B₂（交同理）。
- **签名**：`f ⁻¹' (s ∪ t) = f ⁻¹' s ∪ f ⁻¹' t`
- **出处**：`Mathlib/Data/Set/Lattice.lean`
- **谁在用**：`settheory.function.image-preimage.*`。

### `Set.countable_iUnion`
- **人话**：**可数个可数之并可数**：每片 t i 可数，且指标可数，则并集可数。
- **签名**：`[Countable ι] (ht : ∀ i, (t i).Countable) : (⋃ i, t i).Countable`
- **出处**：`Mathlib/Data/Set/Countable.lean`
- **谁在用**：`settheory.cardinal.countable-union`。

### `Finset.finite_toSet`
- **人话**：**Finset 转成集合必有限**：`(↑t : Set α).Finite`。有限子覆盖/有限值域的收尾常靠它把 Finset 变回"有限集"。
- **签名**：`(s : Finset α) : (↑s : Set α).Finite`
- **出处**：`Mathlib/Data/Finset/`
- **谁在用**：`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`（`(Finset.finite_toSet t).subset hsub_fin : s.Finite`）。

### `Set.mem_iUnion`
- **人话**：并集元素判准：`x ∈ ⋃ i, s i ⟺ ∃ i, x ∈ s i`。
  **必用 `Set.mem_iUnion.mp`** 拿到正确类型的 i——直接 rcases 会被 bigUnion 记法绑架成 Set（Playbook §2.11）。
- **签名**：`x ∈ ⋃ i, s i ↔ ∃ i, x ∈ s i`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`、`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`（`Set.mem_iUnion.mp (hcover hxab)` 解出 i₀ : ι）。

### `Set.mem_biUnion`
- **人话**：**构造**"受限并"的元素：`x ∈ s` 且 `y ∈ t x` ⟹ `y ∈ ⋃ x ∈ s, t x`。这是构造方向（往并集里塞元素）的规则；反向解构请用 `Set.mem_iUnion.mp`。别用嵌套 rcases（Playbook §2.12）。
- **签名**：`(xs : x ∈ s) (ytx : y ∈ t x) : y ∈ ⋃ x ∈ s, t x`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（鸽笼 `Set.mem_biUnion ⟨n, rfl⟩ rfl`）。

### `Set.mem_singleton_iff`
- **人话**：单点集判准：`x ∈ {y} ⟺ x = y`。把"落在单点集里"翻回"等于那个点"。
- **签名**：`x ∈ ({y} : Set α) ↔ x = y`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`（`Uᵢ ∩ s ⊆ {i₀}` ⟹ y = i₀）、`analysis.completeness.equivalence-cycle.cauchy-to-sup`。

### `Set.Finite.subset` / `Set.Finite.image`
- **人话**：有限性两条传递：有限集的任意子集有限（subset）；有限集经任意函数像仍有限（image）。鸽笼/有限覆盖里的"有限蔓延"全靠它们。
- **签名**：`hs.subset ht : t.Finite`；`Set.Finite.image f hs : (f '' s).Finite`
- **出处**：`Mathlib/Data/Set/Finite/Defs.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`、`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`。

### `Set.Finite.biUnion`
- **人话**：**有限并仍有限**：指标集有限且每片有限 ⟹ `(⋃ i ∈ s, t i).Finite`。鸽笼的核心一步。
- **签名**：`(hs : s.Finite) (ht : ∀ i ∈ s, (t i).Finite) : (⋃ i ∈ s, t i).Finite`
- **出处**：`Mathlib/Data/Set/Finite/Lattice.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`、`analysis.completeness.equivalence-cycle.cauchy-to-sup`（值域有限 ⟹ 各纤维有限 ⟹ 并起来覆盖 ℕ 仍有限，矛盾）。

### `Set.infinite_univ` 与 `Set.Infinite.not_finite` / `Set.Infinite.nonempty`
- **人话**：**全集无限**（[Infinite α] 时）；`Infinite` 与 `¬ Finite` 同义（definitional，Playbook §2.12）；`Infinite.nonempty` 给非空。ℕ 无限（Set.infinite_univ）是鸽笼矛盾的弹药。
- **签名**：`[h : Infinite α] : Set.univ.Infinite`；`(hs : s.Infinite) : ¬ s.Finite`
- **出处**：`Mathlib/Data/Set/Finite/` 与 `Mathlib/Data/Set/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（univ = 有限个纤维之并 → 有限，与无限矛盾）。

### `Set.Infinite.exists_gt`
- **人话**：无限子集在任意 a 之后还有元素：`∃ b ∈ s, a < b`。配 Nat.exists_strictMono_subsequence 就能把无限集枚举成严格增子列。
- **签名**：`(hs : s.Infinite) (a : α) : ∃ b ∈ s, a < b`（需 [LocallyFiniteOrderBot α]，ℕ/ℝ 满足）
- **出处**：`Mathlib/Data/Set/Finite/`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（从 {n | u n = c} 无限拉出 n > N 的项）。

### `Set.Finite.isClosed` / `IsClosed.isOpen_compl` / `IsOpen.mem_nhds`
- **人话**：*分离有限个点*三连：有限集是闭集（T1 空间，ℝ 是）；闭集的补集是开集；开集含 x ⟹ 它是 x 的邻域。合起来：x 不在有限集 F 里 ⟹ 有一个开邻域避开 F。
- **签名**：`(hs : s.Finite) : IsClosed s`；`IsClosed.isOpen_compl : IsOpen sᶜ`；`IsOpen.mem_nhds hs hx : s ∈ 𝓝 x`
- **出处**：`Mathlib/Topology/`（Set.Finite.isClosed 连带 T 分离公理）
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（核心桥：x 与 s ∩ (range u \ {x}) 有限集分离，推出邻域矛盾）。

---

## G6. 函数性质

### `Function.Injective.comp` / `Function.Surjective.comp`
- **人话**：单射复合仍单射；满射复合仍满射。
- **签名**：`Injective g → Injective f → Injective (g ∘ f)`
- **出处**：`Mathlib/Logic/Function/`
- **谁在用**：`settheory.function.inj-comp`、`settheory.function.surj-comp`。

### `Function.bijective_iff_has_inverse`
- **人话**：**双射 ⟺ 存在左右逆**（可逆）。一年级"双射有反函数"的严格说法。
- **签名**：`Bijective f ↔ ∃ g, LeftInverse g f ∧ RightInverse g f`
- **出处**：`Mathlib/Logic/Function/`
- **谁在用**：`settheory.function.inject-surject.bijective-iff-inverse`。

---

## G7. 可数性 / 基数

### `Countable`
- **人话**：类型"至多可数"：能单射进 ℕ（或 ℕ 有限段）。ℚ 可数、ℕ 可数。
- **签名**：`Countable (α : Type) : Prop`

### `countable_iff_exists_injective`
- **人话**：**可数 ⟺ 存在到 ℕ 的单射**——教科书的判别法一字不差。
- **签名**：`Countable α ↔ ∃ f : α → ℕ, Function.Injective f`
- **出处**：`Mathlib/Data/Countable/Basic.lean`
- **谁在用**：`settheory.cardinal.countable-rat`。

### 可数性核心结论（mathlib 实例）
- **人话**：`ℚ` 有 `Countable` 实例（**有理数可数**）；
  `ℝ` 有 `Uncountable` 实例 = `not_countable`（**实数不可数**，Cantor 对角线已内置；
  `ℝ` 是 `ℝ` 类型自身的性质，第一章叙述层以 `unresolved` 记录其来源）。
- **谁在用**：`settheory.cardinal.countable-rat / uncountable-real`。
- **坑**：这些实例自带不可削减的经典选择（对角论证/可数选择）。

---

## G8. 等价关系、商集（Setoid / Quotient / Quot）

> 支撑 `analysis.real.construction-cauchy` 与 `settheory.set.relations` 的语言。

### `Setoid`
- **人话**："带证明的等价关系"：一个关系 + 自反/对称/传递的证明。`≈` 即其关系。
- **签名**：`structure Setoid α`（字段 `Rel`、`iseqv`）

### `Quotient` / `Quotient.mk''`
- **人话**：**商集**：把 α 按等价关系归并后得到的新类型。
  `Quotient mk a` 是 a 所在的等价类。
- **签名**：`Quotient.mk'' (a : α) : Quotient s₁`

### `Quotient.eq`
- **人话**：**商集判等准则**：两个元素在商集里相等 ⟺ 它们等价。
  `⟦x⟧ = ⟦y⟧ ↔ r x y`。Cantor 构造的核心判等同款。
- **签名**：`⟦x⟧ = ⟦y⟧ ↔ r x y`
- **出处**：`Mathlib/Data/Quot.lean`
- **谁在用**：`settheory.set.relations.equivalence-class-eq`。

### `Quotient.mk_surjective`
- **人话**：商映射是满射——每个等价类都有代表元（哪个元素当代表不重要）。
- **签名**：`Function.Surjective (Quotient.mk s)`
- **谁在用**：`settheory.set.relations.quotient-surj`。

### `Quot.sound`
- **人话**：商构造的公理本身：`r a b → Quot.mk a = Quot.mk b`（等价的代表元落入同"桶"）。
  几乎任何商集等式都依赖它，故 many 条目的 axioms 里有 `Quot.sound`。
- **签名**：`(h : r a b) : Quot.mk r a = Quot.mk r b`
- **出处**：Lean 核心（`Init/`）

---

## G9. Cauchy 序列与实数构造（CauSeq / Real）

> 支撑 `analysis.real.construction-cauchy`（第二章收官条目）。

### `CauSeq`
- **人话**：**柯西序列**类型：序列 + "要多近有多近"的证明
  （`IsCauSeq`：对任意 ε>0，从某处起两两距离 < ε）。
- **签名**：`structure CauSeq β abv where ...`
- **出处**：`Mathlib/Algebra/Order/CauSeq/Basic.lean`

### `CauSeq.equiv`
- **人话**：**"差趋于 0"是等价关系**的实例：`f ≈ g ⟺ LimZero (f - g)`，
  mathlib 已把它做成 `Setoid`，可直接商。
- **签名**：`(instance) : Setoid (CauSeq β abv)`
- **出处**：`Mathlib/Algebra/Order/CauSeq/Basic.lean`
- **谁在用**：`analysis.real.construction-cauchy`。
- **坑**：`#print axioms` 会因 `≈` 的类型展开带出 choice（Playbook §3.5）。

### `CauSeq.LimZero`
- **人话**："柯西差趋于 0"的命题：`∀ ε > 0, ∃ i, ∀ j ≥ i, abv (f j) < ε`。
- **签名**：`(f : CauSeq β abv) : Prop`
- **出处**：`Mathlib/Algebra/Order/CauSeq/Basic.lean`

### `CauSeq.const`
- **人话**：**常量序列**：每个元素 β 给出一条常量柯西序列；
  Cantor 视角下，有理数 q 到这个类 = 嵌入实数。
- **签名**：`(abv : β → α) [IsAbsoluteValue abv] (x : β) : CauSeq β abv`
- **出处**：`Mathlib/Algebra/Order/CauSeq/Basic.lean`
- **谁在用**：`analysis.real.construction-cauchy`（`rat_const_cauchy`）。

### `CauSeq.Completion`
- **人话**：柯西序列的"完成"：`CauSeq.Completion.Cauchy abv` = `Quotient CauSeq.equiv`
  —— 商出来的就是实数候选。
- **签名**：`Cauchy abv : Type`（= 商集）
- **出处**：`Mathlib/Algebra/Order/CauSeq/Completion.lean`

### `CauSeq.Completion.mk` / `mk_eq`
- **人话**：到商的投影 `mk f`（f 的等价类），及判等准则：
  `mk f = mk g ↔ LimZero (f - g)`。
- **签名**：`mk f = mk g ↔ LimZero (f - g)`
- **出处**：`Mathlib/Algebra/Order/CauSeq/Completion.lean`
- **谁在用**：`analysis.real.construction-cauchy`（`real_eq_iff_cau_equiv`）。

### `CauSeq.Completion.ofRat`
- **人话**：有理数（原环 β）的嵌入：`ofRat x = mk (const x)`。
- **出处**：`Mathlib/Algebra/Order/CauSeq/Completion.lean`

### `Real.ofCauchy` / `Real.cauchy`
- **人话**：ℝ 的**构造子/析出子**：`Real.ofCauchy : CauSeq.Completion.Cauchy → ℝ`；
  `Real.cauchy : ℝ → CauSeq.Completion.Cauchy`。两个方向完美对折——Cantor 构造就是 ℝ。
- **签名**：`ofCauchy : CauSeq.Completion.Cauchy abs → ℝ`
- **出处**：`Mathlib/Data/Real/Basic.lean`
- **谁在用**：`analysis.real.construction-cauchy`。

### `abs_add_le` / `abs_sub_comm`
- **人话**：绝对值三角不等式 `|a+b| ≤ |a| + |b|`；绝对值交换 `|a−b| = |b−a|`。
  传递性证明（三角接力）的生命线。
- **签名**：`(a b : α) : |a + b| ≤ |a| + |b|`
- **出处**：`Mathlib/Algebra/Order/AbsoluteValue/`（Lattice+add 的通用版本）
- **谁在用**：`analysis.real.construction-cauchy`（`cau_equiv_trans`）。
- **坑**：名字是 `abs_add_le`，**不是** `abs_add`（mathlib 里不存在后者）。

### `abs_lt`
- **人话**：绝对值围绕零的刻画：`|a| < b ⟺ -b < a ∧ a < b`。
  在 ε-N 证明里用来把 `|u n − l| < 1` 拆成 ab 两条普通不等式。
- **签名**：`|a| < b ↔ -b < a ∧ a < b`
- **出处**：`Mathlib/Algebra/Order/Abs/`
- **谁在用**：`analysis.sequence.bounded`。

### `CauchySeq`
- **人话**：**柯西列**（一般度量/一致空间版本）：序列自家人最终互相靠近。
- **签名**：`[UniformSpace α] [Preorder β] (u : β → α) : Prop`
- **出处**：`Mathlib/Topology/MetricSpace/`（度量空间的合法实例层）
- **谁在用**：`analysis.sequence.cauchy`。

### `Metric.cauchySeq_iff`
- **人话**：**Cauchy 的 ε-N 距离判据**：
  `CauchySeq u ⟺ ∀ ε > 0, ∃ N, ∀ m n ≥ N, dist (u m) (u n) < ε`。
  把滤子定义展开成教科书原始样貌。
- **签名**：`CauchySeq u ↔ ∀ ε > 0, ∃ N, ∀ m ≥ N, ∀ n ≥ N, dist (u m) (u n) < ε`
- **出处**：`Mathlib/Topology/MetricSpace/Cauchy.lean`
- **谁在用**：`analysis.sequence.cauchy`。

### `cauchySeq_tendsto_of_complete`
- **人话**：**完备空间里 Cauchy 必有极限**：`CompleteSpace α` 正是"柯西列均收敛"。
  ℝ 完备（`CompleteSpace ℝ` 实例），所以实数列 Cauchy ⟹ 存在极限 l。
- **签名**：`[CompleteSpace α] {u : β → α} (H : CauchySeq u) : ∃ x, Tendsto u atTop (𝓝 x)`
- **出处**：`Mathlib/Topology/MetricSpace/Cauchy.lean`
- **谁在用**：`analysis.sequence.cauchy`。

### 绝对值/上下界小件（`le_abs_self` `neg_abs_le` `le_max_left/right`）
- **人话**：`a ≤ |a|`；`-|a| ≤ a`；`x ≤ max x y`；`y ≤ max x y`。
  把"有界"翻译进对称区间 [−M, M] 的螺丝钉（`sequence_bounded_in_interval` 用它们）。
- **签名**：`le_abs_self a : a ≤ |a|`；`neg_abs_le a : -|a| ≤ a`
- **出处**：`Mathlib/Algebra/Order/Abs/`、`Mathlib/Algebra/Order/Monoid/`（max 部分）
- **谁在用**：`analysis.sequence.bolzano-weierstrass`。

### `Filter.limsup` / `Filter.liminf` / `Filter.liminf_le_limsup` / `tendsto_of_liminf_eq_limsup`
- **人话**：滤子版**上极限/下极限**：`limsup u f = sInf { sSup 尾部 }`、liminf 镜像；
  `liminf_le_limsup`：有界时下极限不超过 上极限；
  `tendsto_of_liminf_eq_limsup`：两极限相等（都 = a）⟹ `u → a`。
  数学的直觉表述："最矮天花板"（limsup）与"最高地板"（liminf）——天花板从不低于地板，重合即收敛。
- **签名**：`[ConditionallyCompleteLattice α] (u : β → α) (f : Filter β) : α`；
  `liminf u f ≤ limsup u f`（需上下两向 `IsBoundedUnder`）；
  `Tendsto u f (𝓝 a)`（需 hinf=hsup=a）。
- **出处**：`Mathlib/Order/Filter/` 与 `Mathlib/Topology/Order/LiminfLimsup.lean`
- **谁在用**：`analysis.sequence.liminf-limsup`。
- **坑**：两者相等 ⟹ 收敛这个方向需要序拓扑与两向有界（`tendsto_of_liminf_eq_limsup` 带默认界假设，
  显式提供更稳）。

---

## G10. 聚点 / cluster point / 子列（完备性等价环专用）

> 支撑 `analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`：从"有界无限集有聚点"一步步走到"Cauchy 收敛"。
> 语言核心：𝓝 x（邻域）与 𝓟 s（principal 滤子，即"在 s 里"）的交乘积。

### `AccPt`
- **人话**：**聚点**：x 的每个去心邻域里都还有 s 的点（(𝓝[≠] x ⊓ 𝓟 s).NeBot）。用它写"集合能堆积出来"的极限位置。
- **签名**：`AccPt (x : X) (F : Filter X) : Prop`（对 𝓟 s 即为"集合 s 的聚点"）
- **出处**：`Mathlib/Topology/ClusterPt.lean`
- **谁在用**：真定理 `analysis.completeness.accumulation-point`、`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`、`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`。

### `accPt_iff_nhds`
- **人话**：把"聚点"翻成邻域语言：`AccPt x (𝓟 s) ⟺ ∀ U ∈ 𝓝 x, ∃ y ∈ U ∩ s, y ≠ x`。一推否定就是"存在邻域里 s 的点至多只有 x 自己"。
- **签名**：`AccPt x (𝓟 C) ↔ ∀ U ∈ 𝓝 x, ∃ y ∈ U ∩ C, y ≠ x`
- **出处**：`Mathlib/Topology/ClusterPt.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`（not_accPt_iff_exists_nhds 引理）。

### `accPt_principal_iff_clusterPt`
- **人话**：把"去心聚点"压平为 cluster point：`AccPt x (𝓟 C) ⟺ ClusterPt x (𝓟 (C \ {x}))`。它让"聚点"和"cluster point"两套语言可自由切换。
- **签名**：`AccPt x (𝓟 C) ↔ ClusterPt x (𝓟 (C \ {x}))`
- **出处**：`Mathlib/Topology/ClusterPt.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（核心桥）。

### `clusterPt_principal_iff`
- **人话**：cluster point 的邻域语言：`ClusterPt x (𝓟 s) ⟺ ∀ U ∈ 𝓝 x, (U ∩ s).Nonempty`（每个邻域都被 s 碰到，不要求"去心"）。
- **签名**：`ClusterPt x (𝓟 s) ↔ ∀ U ∈ 𝓝 x, (U ∩ s).Nonempty`
- **出处**：`Mathlib/Topology/ClusterPt.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（核心桥）。

### `MapClusterPt` / `mapClusterPt_iff_frequently`
- **人话**：x 是**序列 u 的映射聚点**：ClusterPt x (map u F)（u 把 F 推过去后 x 仍是 cluster）；对 atTop：∀ s ∈ 𝓝 x, ∃ᶠ n in atTop, u n ∈ s（每个邻域被无限多次命中）。
- **签名**：`MapClusterPt x F u ↔ ∀ s ∈ 𝓝 x, ∃ᶠ a in F, u a ∈ s`
- **出处**：`Mathlib/Topology/ClusterPt.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（聚点 ⟹ MapClusterPt ⟹ 子列）。

### `MapClusterPt.tendsto_subseq`
- **人话**：cluster point ⟹ **有收敛子列**：`MapClusterPt x atTop u ⟹ ∃ φ, StrictMono φ ∧ (u ∘ φ) → x`。
- **签名**：`(hx : MapClusterPt x atTop u) : ∃ φ, StrictMono φ ∧ Tendsto (u ∘ φ) atTop (𝓝 x)`
- **出处**：`Mathlib/Topology/Bases.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`。

### `tendsto_nhds_of_cauchySeq_of_subseq`
- **人话**：**Cauchy + 有收敛子列 ⟹ 整体收敛**：种子收敛到 x，Cauchy 把差距全部拉平。这是"聚点 → Cauchy 收敛"的最后一步。
- **签名**：`(hu : CauchySeq u) (hf : Tendsto φ p atTop) (ha : Tendsto (u ∘ φ) p (𝓝 a)) : Tendsto u atTop (𝓝 a)`
- **出处**：`Mathlib/Topology/UniformSpace/Cauchy.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`、`analysis.completeness.equivalence-cycle.cauchy-to-sup`（子列/常值子列拉平）。

### `Nat.exists_strictMono_subsequence`
- **人话**：**"无限多次成立"能挑成子列**：`(∀ N, ∃ n > N, P n) ⟹ ∃ φ, StrictMono φ ∧ ∀ n, P (φ n)`。鸽笼里"某值被取了无限次"就调它挑下标。
- **签名**：`(∀ N, ∃ n > N, P n) : ∃ φ, StrictMono φ ∧ ∀ n, P (φ n)`
- **出处**：`Mathlib/Order/Monotone/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（常值子列）。

### `Nat.frequently_atTop_iff_infinite`
- **人话**：atTop 上"无限多次" ⟺ 被测集合无限：`(∃ᶠ n in atTop, p n) ⟺ {n | p n}.Infinite`。
- **签名**：`(∃ᶠ n in atTop, p n) ↔ {n | p n}.Infinite`
- **出处**：`Mathlib/Order/Filter/Cofinite.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（可改用 Set.Infinite.exists_gt 更直接）。

---

## G11. 单调序列构造与度量开集件（二分进程装配）

> 支撑二分进程 halfbiseq / bisect_upper：左端单调增、右端单调减、区间直径 → 0、每层从开集/邻域里取 ε-球。

### `monotone_nat_of_le_succ` / `antitone_nat_of_succ_le`
- **人话**：**单步单调 ⟹ 全程单调**：f n ≤ f(n+1) 对每个 n ⟹ f 单调增（monotone_nat_of_le_succ）；f(n+1) ≤ f n ⟹ 反单调（antitone_nat_of_succ_le）。二分左/右端点装配全靠它。
- **签名**：`(hf : ∀ n, f n ≤ f (n + 1)) : Monotone f`；`(hf : ∀ n, f (n + 1) ≤ f n) : Antitone f`
- **出处**：`Mathlib/Order/Monotone/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`、`analysis.completeness.equivalence-cycle.cauchy-to-sup`（halfbiseq / bisect_upper 的 lₙ 增、rₙ 减）。

### `Metric.isOpen_iff`
- **人话**：开集判准：`IsOpen s ⟺ ∀ x ∈ s, ∃ ε > 0, ball x ε ⊆ s`（每点含一整颗开球）。从"Uᵢ 开"里取 ε-球的标准入口。
- **签名**：`IsOpen s ↔ ∀ x ∈ s, ∃ ε > 0, Metric.ball x ε ⊆ s`
- **出处**：`Mathlib/Topology/MetricSpace/`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`（Metric.isOpen_iff.mp (hUo i₀) x hxi₀ 取覆盖的 ε 球）。

### `Metric.mem_nhds_iff`
- **人话**：邻域判准：`s ∈ 𝓝 x ⟺ ∃ ε > 0, ball x ε ⊆ s`（邻域里藏着以 x 为心的一颗开球）。从"U 是 x 的邻域"换出开球。
- **签名**：`s ∈ 𝓝 x ↔ ∃ ε > 0, Metric.ball x ε ⊆ s`
- **出处**：`Mathlib/Topology/MetricSpace/`
- **谁在用**：`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`（Metric.mem_nhds_iff.mp hU 取 ε 球）。

### `Metric.mem_ball_self` / `Metric.isOpen_ball`
- **人话**：自己必在自己球里：0 < ε ⟹ x ∈ ball x ε；开球是开集：IsOpen (ball x ε)。二分的最终落点：把 x ∈ Icc (A N) (B N) 换成 x ∈ ball x ε，从而被 Uᵢ 收纳。
- **签名**：`Metric.mem_ball_self (h : 0 < ε) : x ∈ ball x ε`；`Metric.isOpen_ball`
- **出处**：`Mathlib/Topology/MetricSpace/`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`、`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`。

### `IsOpen.mem_nhds`
- **人话**：开集含 x ⟹ 它是 x 的邻域：IsOpen.mem_nhds hs hx。配合 Set.Finite.isClosed 完美实现"x 与有限个点分离"。
- **签名**：`(hs : IsOpen s) (hx : x ∈ s) : s ∈ 𝓝 x`
- **出处**：`Mathlib/Topology/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy`（核心桥）。

### `Metric.mem_nhdsWithin_iff` / `tendsto_nhdsWithin_iff`
- **人话**：**受限邻域的判据**：`s ∈ 𝓝[t] x ⟺ ∃ ε > 0, ball x ε ∩ t ⊆ s`（邻域含一整颗与 t 相交的开球）；
  `tendsto_nhdsWithin_iff`：`Tendsto f l (𝓝[s] a) ⟺ Tendsto f l (𝓝 a) ∧ ∀ᶠ x in l, f x ∈ s`。
  函数极限的定义语言（去心邻域 `𝓝[≠] a`）全靠它们进出。
- **签名**：`Metric.mem_nhdsWithin_iff : s ∈ 𝓝[t] x ↔ ∃ ε > 0, ball x ε ∩ t ⊆ s`；`tendsto_nhdsWithin_iff`
- **出处**：`Mathlib/Topology/MetricSpace/`、`Mathlib/Topology/Basic.lean`
- **谁在用**：`analysis.func-limit.definition`（helper `eventually_nhds_within_iff_delta`）。

---

## G12. 连续函数（第五章：连续函数论）

> 支撑 `analysis.continuity.*`。连续性 = 拓扑空间之间的态射性质。

### `Continuous` / `ContinuousAt` / `ContinuousOn` / `continuous_iff_continuousAt`
- **人话**：`Continuous f` = f 处处连续；`ContinuousAt f x` = f 在点 x 连续；
  `ContinuousOn f s` = 限制到 s 仍连续；`continuous_iff_continuousAt` 把"处处"展开成"每点"。
- **签名**：`Continuous f ↔ ∀ x, ContinuousAt f x`
- **出处**：`Mathlib/Topology/Basic.lean`
- **谁在用**：`analysis.continuity.definition`。

### `continuous_const` / `continuous_id`
- **人话**：常函数与恒等映射连续。一切连续性的"原子零件"。
- **签名**：`Continuous fun _ => y`；`Continuous id`
- **出处**：`Mathlib/Topology/Basic.lean`
- **谁在用**：`analysis.continuity.const`、`analysis.continuity.identity`。

### `Continuous.add/mul/div/comp`（及 `ContinuousAt.comp`）
- **人话**：连续函数四则与复合仍连续（`div` 需分母处处非零）；点连续版本供链式法则用。
- **签名**：`Continuous f → Continuous g → Continuous (f + g)`（mul/div 同构）；`Continuous.comp hg hf : Continuous (g ∘ f)`
- **出处**：`Mathlib/Topology/Algebra/Group/`、`Mathlib/Topology/Basic.lean`
- **谁在用**：`analysis.continuity.add/mul/div/comp`。

### `intermediate_value_Icc`
- **人话**：**介值定理**：闭区间连续函数的值域包含其端点值之间的整段。取遍中间所有值。
- **签名**：`(hab : a ≤ b) (hf : ContinuousOn f (Icc a b)) : Icc (f a) (f b) ⊆ f '' Icc a b`
- **出处**：`Mathlib/Topology/Order/IntermediateValue.lean`
- **谁在用**：`analysis.continuity.intermediate-value`。

### `IsCompact.image_of_continuousOn`
- **人话**：连续函数把紧集映成紧集（ContinuousOn 版）。最值定理的第一步。
- **签名**：`(hs : IsCompact s) (hf : ContinuousOn f s) : IsCompact (f '' s)`
- **出处**：`Mathlib/Topology/Compactness/Compact.lean`
- **谁在用**：`analysis.continuity.max-min`。
- **坑**：`IsCompact.image` 要全域 `Continuous f`；闭区间上只有 `ContinuousOn` 时用 `image_of_continuousOn`（Playbook §1.1 的 `exact?` 发现）。

### `IsCompact.exists_isGreatest` / `IsCompact.exists_isLeast`
- **人话**：紧集含其最大/最小元素。配合"像紧"即得最值定理。
- **签名**：`(hs : IsCompact s) (ne_s : s.Nonempty) : ∃ x, IsGreatest s x`
- **出处**：`Mathlib/Topology/Order/Compact.lean`
- **谁在用**：`analysis.continuity.max-min`。

### `Metric.uniformContinuous_iff` / `Metric.continuousAt_iff`
- **人话**：一致连续的 ε-δ 判据；点连续的 ε-δ 判据（度量空间）。
- **签名**：`UniformContinuous f ↔ ∀ ε>0, ∃ δ>0, ∀ a b, dist a b < δ → dist (f a) (f b) < ε`
- **出处**：`Mathlib/Topology/MetricSpace/`
- **谁在用**：`analysis.continuity.uniform`。

### `StrictMono.orderIso` / `OrderIso.lt_iff_lt` / `OrderIso.apply_symm_apply` / `Subtype.dist_eq`
- **人话**：严格单调函数到值域的序同构（`StrictMono.orderIso f hf : ℝ ≃o ↑(range f)`）；
  序同构保序（`e x < e y ↔ x < y`）；`e (e.symm y) = y`（反函数性质）；
  子类型度量 = 父空间度量（`Subtype.dist_eq`）。
- **签名**：`(StrictMono.orderIso f hf).symm : ↑(Set.range f) → ℝ`；`Subtype.dist_eq`
- **出处**：`Mathlib/Order/OrderIso.lean`、`Mathlib/Order/Subtype.lean`
- **谁在用**：`analysis.continuity.inverse`（反函数连续，教材 ε-δ 证明）。

---

## G13. 导数（第六章：导数与微分）

> 支撑 `analysis.derivative.*`。`HasDerivAt` 是"在一点有导数值 f'"的判据，`deriv f x` 是导数算子。

### `HasDerivAt` / `deriv` / `HasDerivAt.unique`
- **人话**：`HasDerivAt f f' x` = f 在 x 处可导且导数值为 f'；`deriv f x` 是导数（默认为 0 若不可导）。
  `HasDerivAt.unique` 保证导数唯一。
- **签名**：`HasDerivAt f f' x : Prop`；`deriv f x : ℝ`；`HasDerivAt.unique ha hb : a = b`
- **出处**：`Mathlib/Analysis/Calculus/Deriv/`
- **谁在用**：`analysis.derivative.unique`、`analysis.derivative.*`。

### `deriv_const` / `deriv_id` / `deriv_add_const` / `deriv_const_mul` / `deriv_add` / `deriv_mul` / `deriv_div` / `deriv_comp`
- **人话**：导数算子的基本法则：常数 0、恒等 1、加常数不动、数乘、和差、积（Leibniz）、商、链式。
  每条都是一行调用 mathlib 的结果。
- **签名**：`deriv (fun _=>c) x = 0`；`deriv id x = 1`；`deriv (f+g) x = deriv f x + deriv g x`；…；`deriv_comp x hg hf : deriv (g∘f) x = deriv g (f x)·deriv f x`
- **出处**：`Mathlib/Analysis/Calculus/Deriv/`
- **谁在用**：`analysis.derivative.const/add/mul/div/const-mul/chain-rule`。
- **坑**：`deriv_add` 需要 `DifferentiableAt` 前提；`deriv_mul` 的 Leibniz 形式需注意 x 依赖项。

---

## G14. 微分中值定理（第七章）

> 支撑 `analysis.mvt.*`。中值定理族把"导数信息"反推成"函数在区间上的增量信息"。

### `exists_deriv_eq_zero` / `exists_deriv_eq_slope` / `exists_hasDerivAt_eq_slope`
- **人话**：罗尔（端点相等 ⟹ 内部某点导数为 0）；Lagrange（内部某点导数 = 割线斜率）；
  以及带导函数的 Lagrange 版。一行调用即得。
- **签名**：`(hab : a < b) (hfc : ContinuousOn f (Icc a b)) (hfI : f a = f b) : ∃ c ∈ Ioo a b, deriv f c = 0`；
  `exists_deriv_eq_slope f hab hfc hfd : ∃ c ∈ Ioo a b, deriv f c = (f b - f a)/(b - a)`
- **出处**：`Mathlib/Analysis/Calculus/MeanValue.lean`
- **谁在用**：`analysis.mvt.rolle`、`analysis.mvt.lagrange`、`analysis.mvt.lagrange-deriv`。

### `monotoneOn_of_deriv_nonneg` / `strictMonoOn_of_deriv_pos` / `strictAntiOn_of_deriv_neg`
- **人话**：导数符号判别单调（MVT 推论）：f'≥0 ⟹ 单调不减，f'>0 ⟹ 严格递增，f'<0 ⟹ 严格递减。
  需凸区间 D 与 interior D 上的导数条件。
- **签名**：`(hD : Convex ℝ D) (hf : ContinuousOn f D) (hf' : ∀ x ∈ interior D, 0 ≤ deriv f x) : MonotoneOn f D`
- **出处**：`Mathlib/Analysis/Calculus/Monotone.lean`
- **谁在用**：`analysis.mvt.monotone-deriv`。
- **坑**：区间用 `Set.Icc` 且 `interior_Icc = Set.Ioo` 桥接（`simpa [interior_Icc]`）。

### `exists_ratio_deriv_eq_ratio_slope` / `HasDerivAt.lhopital_zero_nhdsNE`
- **人话**：柯西中值定理（deriv 版）：(g b−g a)·f'(c)=(f b−f a)·g'(c)；
  L'Hôpital 0/0 型：f'/g'→l 且 f,g→0 ⟹ f/g→l。
- **签名**：`exists_ratio_deriv_eq_ratio_slope f hab hfc hfd g hgc hgd : ∃ c ∈ Ioo a b, ...`；
  `HasDerivAt.lhopital_zero_nhdsNE hff' hgg' hg' hfa hga hdiv : Tendsto (f/g) (𝓝[≠] a) (𝓝 l)`
- **出处**：`Mathlib/Analysis/Calculus/Deriv/MeanValue.lean`、`Mathlib/Analysis/Calculus/LHopital.lean`
- **谁在用**：`analysis.mvt.cauchy`、`analysis.mvt.lhopital`。
- **坑**：L'Hôpital 在 `HasDerivAt` 命名空间内（非根命名空间）；柯西 MVT 的 f、g 显式且位置分离。

### `taylor_mean_remainder_lagrange` / `taylorWithinEval` / `iteratedDerivWithin`
- **人话**：**Taylor 定理（Lagrange 余项）**：f x = Taylor 多项式(x) + f⁽ⁿ⁺¹⁾(x')·(x−x₀)ⁿ⁺¹/(n+1)!，
  其中 x' 在 x₀ 与 x 之间。对应 Rudin Thm 5.15。
- **签名**：`(hx : x₀ ≠ x) (hf : ContDiffOn ℝ (↑n) f (Set.uIcc x₀ x)) (hf' : DifferentiableOn ℝ (iteratedDerivWithin n f ...) (Set.uIoo x₀ x)) : ∃ x', f x - taylorWithinEval f n ... = ...`
- **出处**：`Mathlib/Analysis/Calculus/Taylor.lean`
- **谁在用**：`analysis.mvt.taylor`。
- **坑**：`Set.uIcc`（unordered interval）自动处理 x₀<x 与 x<x₀；Taylor 多项式用 `taylorWithinEval` 求值。

---

## G15. 线性代数（第一学期 L1-L4：向量空间 / 线性映射矩阵秩 / 行列式 / 特征值）

> 支撑 `linear-algebra.vector-space.*`。教材的"向量空间 V、维数 dim、基"在 mathlib 形式化层
> 落在模理论（`Module`、`Submodule`、`Module.finrank`、`Module.rank`）。
> **词条与叙述层只用教材记号（dim、基、秩）**，这里给实现用的 mathlib 名作白话锚点。

### `Module` / `Submodule` / `Submodule.span` / `LinearIndependent`
- **人话**：`Module R M` = R 上的模（向量空间是系数为域的模）；`Submodule` = 子空间/子模；
  `Submodule.span R s` = s 张成的子空间；`LinearIndependent R v` = 向量族 v 线性无关。
- **签名**：`LinearIndependent R v : Prop`；`x ∈ Submodule.span R s`
- **出处**：`Mathlib/LinearAlgebra/`
- **谁在用**：`linear-algebra.vector-space.independent`。

### `Module.finrank` / `Module.rank` / `Module.Basis`
- **人话**：`Module.finrank R M` = 有限维空间 M 的维数（ℕ）；`Module.rank R M` = 一般维数（基数）；
  `Module.Basis ι R M` = 指标集 ι 张成的一组基。
- **签名**：`Module.finrank R M : ℕ`；`Module.Basis ι R M`
- **出处**：`Mathlib/LinearAlgebra/Dimension/`、`Mathlib/LinearAlgebra/Basis.lean`
- **谁在用**：`linear-algebra.vector-space.def/basis/dimension`。

### `Module.finrank_eq_card_basis` / `LinearIndependent.fintype_card_le_finrank` / `Module.finrank_zero_iff` / `Module.finrank_eq_rank`
- **人话**：维数 = 基的大小；线性无关组长度 ≤ 维数；dim=0 ⟺ 平凡空间；有限维时 dim 与秩一致。
- **签名**：`(h : Module.Basis ι R M) : finrank R M = |ι|`；`LinearIndependent.fintype_card_le_finrank`
- **出处**：`Mathlib/LinearAlgebra/`
- **谁在用**：`linear-algebra.vector-space.dimension/basis/independent`。
- **坑**：维数涉及选择（noncomputable），`dim` 别名需标 `noncomputable`。

### `LinearMap.range` / `LinearMap.ker` / `Matrix.rank` / `LinearMap.finrank_range_add_finrank_ker` / `Matrix.rank_eq_finrank_span_cols` / `Matrix.rank_mul_le`
- **人话**：线性映射的像 `f.range` 与核 `f.ker`（都是子空间）；矩阵秩 `A.rank`；
  **秩-零度定理**（rank+nullity=dim）、列秩、秩的乘法界。
- **签名**：`LinearMap.finrank_range_add_finrank_ker f : rank f + nullity f = dim V`；
  `Matrix.rank_eq_finrank_span_cols A`；`Matrix.rank_mul_le A B`
- **出处**：`Mathlib/LinearAlgebra/`（Matrix/Rank.lean、Dimension/LinearMap.lean）
- **谁在用**：`linear-algebra.maps.rank-nullity/matrix-rank/rank-mul`。
- **坑**：教材"秩"= 像的维数，形式化是 `Module.finrank K f.range`；词条用教材记号 rank/nullity。

### `Matrix.det` / `Matrix.det_mul` / `Matrix.det_transpose` / `Matrix.nonsing_inv_mul` / `Matrix.mul_nonsing_inv` / `Matrix.det_one` / `Matrix.det_zero`
- **人话**：行列式 `A.det`；det(AB)=det A·det B；转置不变；det≠0 ⟹ 有逆 A⁻¹（左右逆）；det I=1、det 0=0。
- **签名**：`(A * B).det = A.det * B.det`；`(h : IsUnit A.det) : A⁻¹ * A = 1 ∧ A * A⁻¹ = 1`
- **出处**：`Mathlib/LinearAlgebra/Matrix/Determinant.lean`
- **谁在用**：`linear-algebra.det.mul/transpose/invertible/one-zero`。
- **坑**：教材"det A ≠ 0"在 mathlib 是 `IsUnit A.det`（域上等价）；`Matrix.det_ne_zero_iff` 不存在。

### `Module.End.HasEigenvalue` / `Module.End.HasEigenvector` / `Module.End.eigenspace` / `spectrum` / `Matrix.charpoly`
- **人话**：线性变换 T 的特征值 `HasEigenvalue`、特征向量 `HasEigenvector`、特征子空间 `eigenspace μ`、
  谱 `spectrum`、特征多项式 `Matrix.charpoly`。
- **签名**：`T.HasEigenvalue μ ↔ T.eigenspace μ ≠ ⊥`；`T.HasEigenvector μ x : T x = μ • x`；
  `(diagonal d).charpoly = ∏ᵢ (X - dᵢ)`
- **出处**：`Mathlib/LinearAlgebra/Eigenspace/`、`Mathlib/LinearAlgebra/Matrix/Charpoly/`
- **谁在用**：`linear-algebra.eigen.vector/value/spectrum/charpoly`。
- **坑**：特征向量是"方向不变"的拉伸；特征多项式对角情形 ∏(X−dᵢ) 显式给出特征值。

### `Module.End.hasEigenvalue_iff_isRoot_charpoly` / `Matrix.charpoly_toLin'`
- **人话**：特征值 ⟺ 特征多项式根（`Module.End` 版）；矩阵 charpoly 与线性变换 charpoly 一致
  （`(toLin' A).charpoly = A.charpoly`）。
- **签名**：`(f : Module.End R M) (μ : R) : f.HasEigenvalue μ ↔ f.charpoly.IsRoot μ`；`Matrix.charpoly_toLin'`
- **出处**：`Mathlib/LinearAlgebra/Eigenspace/`、`Mathlib/LinearAlgebra/Matrix/Charpoly/`
- **谁在用**：`linear-algebra.eigen.charpoly-root`。
- **坑**：矩阵特征值经 `A.toLin'` 桥接；charpoly 一致（`Matrix.charpoly_toLin'`）在证明内完成。

### `Module.End.eigenvectors_linearIndependent` / `Module.End.mem_eigenspace_iff`
- **人话**：不同特征值对应特征向量线性无关（教材核心）；`x ∈ eigenspace μ ↔ T x = μ·x`（桥接记号）。
- **签名**：`eigenvectors_linearIndependent T μs xs (h_eigenvec : ∀ μ, T.HasEigenvector μ (xs μ)) : LinearIndependent xs`
- **出处**：`Mathlib/LinearAlgebra/Eigenspace/`
- **谁在用**：`linear-algebra.eigen.independent`。
- **坑**：教材"特征向量（T x=μ·x）"在证明内经 `mem_eigenspace_iff` 桥接到 mathlib 自同态语言。

### `Matrix.nonsing_inv_mul` / `Matrix.mul_nonsing_inv` / `Matrix.det_nonsing_inv`
- **人话**：det 可逆（≠0）⟹ A⁻¹ 是左右逆（A⁻¹·A = A·A⁻¹ = 1）；逆的行列式。
- **签名**：`(h : IsUnit A.det) : A⁻¹ * A = 1 ∧ A * A⁻¹ = 1`
- **出处**：`Mathlib/LinearAlgebra/Matrix/NonsingularInverse.lean`
- **谁在用**：`linear-algebra.eigen.similar-diagonal`。

### `Matrix.det_mul` / `Matrix.det_nonsing_inv` / `Matrix.mul_smul` / `Matrix.smul_mul`
- **人话**：det 乘性（det(AB)=det A·det B）；逆的行列式（det A⁻¹=(det A)⁻¹）；
  标量矩阵乘矩阵 = 逐项缩放（c·1 与任何矩阵交换的根源）。
- **签名**：`(M * N).det = M.det * N.det`；`Matrix.det_nonsing_inv`
- **出处**：`Mathlib/LinearAlgebra/Matrix/Determinant.lean`、`Mathlib/LinearAlgebra/Matrix/`
- **谁在用**：`linear-algebra.eigen.similar-charpoly`。
- **坑**：相似保持特征多项式用**逐点 det** 证明（det(c·1−A) 对每个 c），
  不引入多项式矩阵/环同态，项始终是域元素（保留域性质）。

### `Matrix.adjugate` / `Matrix.mul_adjugate` / `Matrix.adjugate_mul` / `Matrix.cramer` / `Matrix.mulVec_cramer` / `Matrix.rank_transpose`
- **人话**：伴随矩阵 `A.adjugate`（A·adj(A)=adj(A)·A=det A·I）；Cramer 法则
  （AX=b 时 (A.cramer b)ᵢ=det(A 第 i 列换 b)，A·(A.cramer b)=det A·b）；行秩=列秩（rank Aᵀ=rank A）。
- **签名**：`A * A.adjugate = A.det • 1`；`Matrix.mulVec_cramer A b : A *ᵥ A.cramer b = A.det • b`；`A.transpose.rank = A.rank`
- **出处**：`Mathlib/LinearAlgebra/Matrix/`（Adjugate.lean、Cramer.lean、Rank.lean）
- **谁在用**：`linear-algebra.det.adjugate`、`linear-algebra.det.cramer`、`linear-algebra.maps.row-rank`。

## G16. 抽象代数基础

### `Group` / `Subgroup` / `Subgroup.ext` / `Subgroup.one_mem` / `Subgroup.mul_mem` / `Subgroup.inv_mem` / `Subgroup.mem_bot` / `Subgroup.mem_top`
- **人话**：`Group G` 是群 typeclass（乘法 `*`、单位元 `1`、逆 `⁻¹`）；`Subgroup G` 是子群结构；
  `ext` 子群外延性；子群含单位元/对乘/逆封闭；`⊥` 平凡子群（只含 1）、`⊤` 全子群。
- **签名**：`Subgroup.ext : (∀x, x∈H ↔ x∈K) → H = K`；`Subgroup.one_mem H : 1 ∈ H`；`Subgroup.mem_bot : x∈⊥ ↔ x=1`
- **出处**：`Mathlib/GroupTheory/Subgroup/Basic.lean`
- **谁在用**：`abstract-algebra.group.def`。
- **坑**：`(⊥ : Subgroup G)` 不是 `Set`，与 `{1}` 类型不同，用 `((⊥ : Subgroup G) : Set G) = {1}`。

### `mul_left_cancel` / `mul_right_cancel` / `mul_inv_rev` / `zpow_add` / `zpow_neg`
- **人话**：群中的左右消去律、乘积取逆反序，以及整数幂的加法与负指数法则。
- **谁在用**：`abstract-algebra.group.def` 的群公理直接推论。
- **坑**：`zpow_add` 的指数是整数；自然数幂使用对应的 `pow_add`。非交换群只能合并同底幂。

### `Subgroup.closure` / `Subgroup.closure_le` / `Subgroup.closure_union` / `Subgroup.zpowers_eq_closure` / `MonoidHom.map_closure`
- **人话**：集合生成的最小子群、其最小性、并集生成公式、单元素生成与整数幂子群的对应，
  以及同态像与生成子群可交换。
- **谁在用**：`abstract-algebra.group.def` 的生成子群和子群格接口。
- **坑**：这里的 `closure` 是代数闭包，不是拓扑闭包。

### `mem_leftCoset_iff` / `leftCoset_eq_iff` / `Subgroup.leftCosetEquivSubgroup` / `Subgroup.card_mul_index` / `Subgroup.index_eq_card`
- **人话**：左陪集 `a • (H : Set G)` 的成员刻画 `x∈aH ↔ a⁻¹·x∈H`；陪集相等 `aH=bH ↔ b⁻¹·a∈H`；
  陪集与子群等势（`leftCosetEquivSubgroup` 显式双射）；**Lagrange** `Nat.card H * H.index = Nat.card G`；
  `H.index = Nat.card (G ⧸ H)`（指数=陪集数）。
- **签名**：`Subgroup.leftCosetEquivSubgroup (g : α) : (g • s : Set α) ≃ s`；`Subgroup.card_mul_index H`
- **出处**：`Mathlib/GroupTheory/Coset/Basic.lean`
- **谁在用**：`abstract-algebra.group.coset`。
- **坑**：`leftCoset_eq_iff` mathlib 方向是 `a⁻¹*b`，与教材 `b⁻¹*a` 相反需换参+symm；
  `leftCosetEquivSubgroup` 在 `namespace Subgroup`，其余陪集引理在根级。

### `Subgroup.Normal` / `Subgroup.Normal.conj_mem` / `Subgroup.normal_bot` / `Subgroup.normal_top` / `QuotientGroup.mk_mul` / `QuotientGroup.mk_one` / `QuotientGroup.mk_inv`
- **人话**：`H.Normal` 是正规子群属性（共轭稳定）；`conj_mem` 给 `n∈H → g·n·g⁻¹∈H`；
  ⊥、⊤ 正规；商群 `G ⧸ H` 的投影 `QuotientGroup.mk` 保乘/单位元/逆（商群构成群）。
- **签名**：`Subgroup.Normal.conj_mem (self : H.Normal) (n : G) : n∈H → ∀ g, g·n·g⁻¹∈H`；`QuotientGroup.mk_mul N [N.Normal] a b`
- **出处**：`Mathlib/GroupTheory/Subgroup/Basic.lean`、`Mathlib/GroupTheory/QuotientGroup/Basic.lean`
- **谁在用**：`abstract-algebra.group.normal`。

### `normal_iff_eq_cosets` / `Subgroup.Normal.comap` / `Subgroup.Normal.map`
- **人话**：正规子群等价于所有左右陪集相等；正规子群的逆像仍正规，沿满同态的像仍正规。
- **谁在用**：`abstract-algebra.group.normal` 的等价刻画和稳定构造。
- **坑**：`Normal.map` 需要同态满射；`Normal.comap` 不需要。

### `QuotientGroup.ker_mk'` / `QuotientGroup.lift` / `QuotientGroup.lift_mk'` / `QuotientGroup.mk'_surjective`
- **人话**：商投影的核恰为原正规子群；若 `H ≤ ker f`，则 f 唯一下降到 `G/H`，
  且在代表元上满足 `f̄(gH)=f(g)`。商投影本身是满射。
- **谁在用**：`abstract-algebra.group.normal` 的商映射泛性质。
- **坑**：`QuotientGroup.lift` 需要 `[H.Normal]` 和明确的核包含证明。
- **坑**：商群引理需要 `[nN : N.Normal]` typeclass 参数；`G ⧸ H` 是商群类型记号。

### `Subgroup.normal_of_index_eq_two`
- **人话**：**指数 2 子群必正规**：`H.index = 2 ⟹ H.Normal`（教材经典定理：最小指数非平凡子群必正规）。
- **签名**：`Subgroup.normal_of_index_eq_two {H : Subgroup G} (hH : H.index = 2) : H.Normal`
- **出处**：`Mathlib/GroupTheory/Subgroup/Basic.lean`
- **谁在用**：`abstract-algebra.group.index-two`。

### `MonoidHom` / `MonoidHom.mem_ker` / `MonoidHom.mem_range` / `MonoidHom.ker_eq_bot_iff` / `MonoidHom.range_eq_top` / `QuotientGroup.quotientKerEquivRange`
- **人话**：`G →* N` 群同态；核 `f.ker`、值域 `f.range` 的元素刻画；**单射 ⟺ 核平凡**、
  满射 ⟺ 值域全；**同态基本定理** `G/ker φ ≃* range φ`（Noether 第一同构定理）。
- **签名**：`MonoidHom.ker_eq_bot_iff f : f.ker = ⊥ ↔ Function.Injective f`；`QuotientGroup.quotientKerEquivRange φ`
- **出处**：`Mathlib/Algebra/Hom/Group.lean`、`Mathlib/GroupTheory/QuotientGroup/Basic.lean`
- **谁在用**：`abstract-algebra.group.hom`。
- **坑**：同态基本定理在 mathlib 是现成定义（非需自证）；`f.ker = ⊥` 中 `⊥` 是平凡子群。

### `MonoidHom.comp` / `Subgroup.map` / `Subgroup.comap` / `MonoidHom.range_comp`
- **人话**：群同态的复合、子群沿同态的像与逆像，以及复合同态的像公式。
- **谁在用**：`abstract-algebra.group.hom` 的函子性和子群接口。
- **坑**：`map` 与同态同向，`comap` 与同态反向。

### `MulEquiv.ofBijective` / `MulEquiv.orderOf_eq` / `Nat.card_congr`
- **人话**：双射群同态升级为群同构；群同构保持元素阶，并由底层等价保持群的基数。
- **谁在用**：`abstract-algebra.group.hom` 的同构构造与不变量。

### `Ring` / `Subring` / `Subring.ext` / `Subring.one_mem` / `Subring.zero_mem` / `Subring.mem_bot` / `Subring.mem_top` / `RingHom`
- **人话**：`Ring R` 环 typeclass；`Subring R` 子环结构（含 1）；外延性；子环含 1/0；
  `⊥` 平凡子环（n·1 形式，n:ℤ）、`⊤` 全子环；`RingHom` 环同态（`R →+* S`，保加乘单位元）。
- **签名**：`Subring.ext : (∀x, x∈S ↔ x∈T) → S = T`；`Subring.mem_bot : x∈⊥ ↔ ∃ n:ℤ, ↑n = x`
- **出处**：`Mathlib/RingTheory/Subring/Basic.lean`、`Mathlib/Algebra/Ring/`
- **谁在用**：`abstract-algebra.ring.def`。`Ring`、`Subring`、`RingHom` 只作为可靠的数据
  承载和实现桥；公开教材定义分别是 `RingAxioms` / `CommutativeRingAxioms`、
  `SubringSet`、`RingHomomorphism`。
- **坑**：`Subring.mem_bot` 的 n 是 ℤ 不是 ℕ。

### `Ideal` / `Ideal.mul_mem_left` / `Ideal.mul_mem_right` / `Ideal.eq_top_of_isUnit_mem` / `Ideal.Quotient.eq` / `Ideal.Quotient.mk` / `RingHom.ker` / `RingHom.range`
- **人话**：`Ideal R` 理想（R 作为自身模的子模）；左/右吸收乘法；含单位元理想 = ⊤；
  商环 `R ⧸ I` 判等 `mk x = mk y ⟺ x-y ∈ I`；环同态核是理想（`RingHom.ker : Ideal R`）、值域是子环。
- **签名**：`Ideal.Quotient.eq : mk x = mk y ↔ x - y ∈ I`；`RingHom.ker f : Ideal R`
- **出处**：`Mathlib/RingTheory/Ideal/Basic.lean`、`Mathlib/RingTheory/Ideal/Quotient/Basic.lean`
- **谁在用**：`abstract-algebra.ring.ideal`。
- **坑**：`RingHom.ker f` 已是 `Ideal R`（非 Subgroup）；商环投影需 `[I.IsTwoSided]`。

### `Quotient`（本库商环的实现承载）
- **人话**：本库先用 `TwoSidedIdealSet` 定义模理想同余，再以通用 `Quotient` 承载等价类；
  加法、乘法、环公理、自然投影、核与泛性质均由本库证明。
- **谁在用**：`abstract-algebra.ring.quotient`。
- **边界**：Mathlib `Ideal.Quotient` 不是本条教材定义；它只保留在旧兼容接口中。

### `IsDomain` / `IsField.mul_inv_cancel` / `Ideal.isPrime_iff` / `Ideal.IsMaximal` / `Ideal.Quotient.isDomain` / `Ring.isField_iff_maximal_bot`
- **人话**：整环 `IsDomain`（无零因子）；域 `IsField`（非零元可逆）；素理想判据
  `I.IsPrime ↔ I≠⊤ ∧ (x·y∈I → x∈I ∨ y∈I)`；极大 ⟹ 素；素理想 ⟹ 商环整环；**R 是域 ⟺ 零理想极大**。
- **签名**：`Ideal.isPrime_iff`；`Ideal.Quotient.isDomain I [I.IsPrime] : IsDomain (R ⧸ I)`；
  `Ring.isField_iff_maximal_bot [Nontrivial R] : IsField R ↔ (⊥:Ideal R).IsMaximal`
- **出处**：`Mathlib/RingTheory/Ideal/Basic.lean`、`Mathlib/RingTheory/Ideal/Quotient/Basic.lean`
- **谁在用**：`abstract-algebra.ring.domain`。
- **坑**：`IsField` 是 Prop 不是 typeclass（不能 `[IsField R]` binder）；`isField_iff_maximal_bot` 在 `namespace Ring`。

### `Ideal.IsPrime` / `Ideal.IsMaximal`（素理想与极大理想桥）
- **人话**：Mathlib 的素性、极大性用于把本库 `PrimeIdealSet`、`MaximalIdealSet` 接到成熟的
  理想 API；教材主判据及商整环／商域双向定理由本库定义陈述。
- **谁在用**：`abstract-algebra.ring.prime-ideal`。
- **边界**：不能把 Mathlib 的单向商环实例冒充本库双向判据。

### `TopologicalSpace` / `IsOpen` / `IsClosed` / `nhds` / `Continuous` / `Homeomorph`
- **人话**：这些 Mathlib 接口分别承载拓扑空间、开闭集、邻域滤子、连续映射与同胚，语义与教材
  定义一致。`topologicalSpace_open_axioms`、开闭集原像刻画、邻域的含点开集刻画和同胚的正逆
  连续刻画负责把类型类与滤子表示解释成教材语言。
- **谁在用**：`topology.foundation.structure` 以它们作为正式课程承载；
  `topology.foundation.mathlib-compatibility` 只负责迁移旧 `TextbookTopology`。
- **坑**：允许直接复用 Mathlib 接口，但必须在课程文档解释量词、typeclass 和滤子成员关系。
  `fromMathlib` 只能服务旧声明迁移，新课程不得先转回旧载体再发展。

### `RingHom.quotientKerEquivRange` / `Ideal.Quotient.maximal_of_isField`
- **人话**：**环版第一同构定理** `R/ker f ≃+* im f`；**商环是域 ⟹ 理想极大**（极大理想 ⟺ 商域的反方向）。
- **签名**：`RingHom.quotientKerEquivRange f : R ⧸ ker f ≃+* ↥f.range`；`Ideal.Quotient.maximal_of_isField I hqf`
- **出处**：`Mathlib/RingTheory/Ideal/Quotient/Basic.lean`、`Mathlib/RingTheory/Ideal/`
- **谁在用**：`abstract-algebra.ring.iso`、`abstract-algebra.ring.domain`。
- **坑**：商环域判据是"商环是域 ⟺ 理想极大"（`Ideal.Quotient.maximal_of_isField` 是其中方向之一）。

### `Polynomial` / `Polynomial.X` / `Polynomial.C` / `Polynomial.ext` / `Polynomial.eval` / `Polynomial.dvd_iff_isRoot` / `Polynomial.isUnit_iff` / `Polynomial.isDomain_iff`
- **人话**：`Polynomial R` 多项式环；`X` 不定元、`C` 常数嵌入、`eval` 代入求值；外延性（系数定多项式）；
  **因式定理** `X−C a ∣ p ↔ p.IsRoot a`；单位元 = 非零常数 `IsUnit p ↔ ∃r, IsUnit r ∧ C r = p`；
  `IsDomain R[X] ↔ IsDomain R ∧ IsCancelAdd R`。
- **签名**：`Polynomial.dvd_iff_isRoot {p : R[X]} (a : R) : X - C a ∣ p ↔ p.IsRoot a`
- **出处**：`Mathlib/Algebra/Polynomial/`
- **谁在用**：`abstract-algebra.poly.def`。
- **坑**：`[CommRing R] [IsDomain R]` 下 `IsDomain R[X]` 可 infer_instance。

### `Irreducible` / `Irreducible.isUnit_or_isUnit` / `Polynomial.irreducible_X_sub_C` / `Polynomial.irreducible_X` / `Polynomial.irreducible_of_degree_eq_one` / `Polynomial.modByMonic` / `Polynomial.degree_modByMonic_lt`
- **人话**：`Irreducible p` 不可约（`p=ab → IsUnit a ∨ IsUnit b`）；X−a、X 不可约；域上次数 1 不可约；
  带余除法 `p %ₘ q`（余式）、`p /ₘ q`（商），整除 ⟺ 余式 0，余式次数 < 除式次数（欧几里得）。
- **签名**：`Polynomial.irreducible_X_sub_C (a : R) : Irreducible (X - C a)`；`Polynomial.modByMonic_eq_zero_iff_dvd (hq : q.Monic) : p %ₘ q = 0 ↔ q ∣ p`
- **出处**：`Mathlib/Algebra/Polynomial/`、`Mathlib/RingTheory/Polynomial/`
- **谁在用**：`abstract-algebra.poly.irreducible`。
- **坑**：带余除法需 `q.Monic` 前提；`Polynomial.instEuclideanDomain`（域上多项式环欧几里得）是实例非 Prop。

### `Polynomial.roots` / `Polynomial.mem_roots` / `Polynomial.root_mul` / `Polynomial.card_roots`
- **人话**：`p.roots` 根 multiset；`a ∈ p.roots ↔ p.IsRoot a`；乘积的根 = 根的析取（整环）；
  **非零多项式根的个数 ≤ 次数** `p.roots.card ≤ p.degree`（教材"n 次多项式至多 n 个根"）。
- **签名**：`Polynomial.card_roots (hp : p ≠ 0) : ↑p.roots.card ≤ p.degree`；`Polynomial.mem_roots hp`
- **出处**：`Mathlib/Algebra/Polynomial/Roots.lean`
- **谁在用**：`abstract-algebra.poly.roots-card`。
- **坑**：`card_roots` 用 `WithBot ℕ` 的 `degree`；根个数含重数（multiset）。

## G17. 点集拓扑与度量空间

### `TopologicalSpace` / `IsOpen` / `IsClosed` / `isOpen_iUnion` / `isClosed_iInter` / `isOpen_compl_iff`
- **人话**：`TopologicalSpace X` 拓扑 typeclass；`IsOpen`/`IsClosed` 开闭集谓词；开集公理
  （空/全集开、有限交开、任意并开）；闭集任意交闭；`s 开 ⟺ sᶜ 闭`。
- **签名**：`IsOpen.inter : IsOpen s → IsOpen t → IsOpen (s ∩ t)`；`isOpen_iUnion h`
- **出处**：`Mathlib/Topology/`
- **谁在用**：`topology.space.def`。
- **坑**：定理名加 `topo_` 前缀避免与 mathlib 同名。

### `nhds` / `IsOpen.mem_nhds` / `Continuous` / `continuous_def` / `continuous_iff_continuousAt` / `Continuous.tendsto` / `Continuous.comp`
- **人话**：`nhds x` 邻域滤子；开集是每点邻域；`Continuous f`（开集原像开定义）；
  连续 ⟺ 处处点连续；连续保极限；恒等/常/复合连续。
- **签名**：`continuous_def : Continuous f ↔ ∀ s, IsOpen s → IsOpen (f⁻¹' s)`；`IsOpen.mem_nhds hs hx`
- **出处**：`Mathlib/Topology/`
- **谁在用**：`topology.space.neighborhood`、`topology.space.continuous`。
- **坑**：`Continuous` 是 Prop；`Continuous.isOpen_preimage hf s hs` 参数顺序。

### `Homeomorph` / `Homeomorph.continuous` / `Homeomorph.bijective` / `Homeomorph.isOpen_image`
- **人话**：`X ≃ₜ Y` 同胚；双向连续双射；同胚保开集 `IsOpen (h '' s) ↔ IsOpen s`。
- **签名**：`Homeomorph.isOpen_image (h : X ≃ₜ Y) {s} : IsOpen (h '' s) ↔ IsOpen s`
- **出处**：`Mathlib/Topology/Homeomorph.lean`
- **谁在用**：`topology.space.homeo`。
- **坑**：同胚复合/对称是构造操作（非 Prop）。

### `continuous_subtype_val` / `ContinuousOn.restrict` / `continuous_fst` / `continuous_snd` / `isOpen_induced_iff`
- **人话**：子空间嵌入连续；限制连续；积空间投影连续；诱导拓扑开集刻画
  `IsOpen s ↔ ∃ t, IsOpen t ∧ f⁻¹' t = s`（子空间/商拓扑共用）。
- **签名**：`isOpen_induced_iff (f : α → β) : IsOpen s ↔ ∃ t, IsOpen t ∧ f ⁻¹' t = s`
- **出处**：`Mathlib/Topology/Constructions.lean`
- **谁在用**：`topology.space.subspace`。
- **坑**：商拓扑用 `isOpen_coinduced`（对偶）。

### `IsConnected` / `IsPreconnected` / `IsConnected.image` / `isConnected_Icc` / `isPreconnected_Ioo` / `Homeomorph.isConnected_image`
- **人话**：连通集 `IsConnected`；连续像连通；ℝ 闭/开区间连通；同胚保连通。
- **签名**：`IsConnected.image (H : IsConnected s) (f) (hf : ContinuousOn f s)`；`isConnected_Icc h`
- **出处**：`Mathlib/Topology/Connected/`
- **谁在用**：`topology.space.connected`。
- **坑**：`isConnected_Icc` 需 `[OrderTopology]`（ℝ 满足）；介值定理是连通像推论。

### `IsCompact` / `isCompact_iff_finite_subcover` / `IsCompact.elim_finite_subcover` / `IsCompact.image` / `IsCompact.union` / `isCompact_singleton` / `isCompact_Icc` / `CompactSpace`
- **人话**：紧集 `IsCompact s`（有限覆盖定义）；有限子覆盖抽取 `elim_finite_subcover`；
  连续像紧、有限并紧、单点紧；闭区间紧 `isCompact_Icc`；`CompactSpace X` 全空间紧。
- **签名**：`IsCompact.elim_finite_subcover hs U hUo hsU : ∃ t, s ⊆ ⋃ i∈t, U i`；`isCompact_Icc`
- **出处**：`Mathlib/Topology/Compactness/`
- **谁在用**：`topology.compact.def`、`topology.compact.closed-bdd`。
- **坑**：`IsCompact.image` 需 `Continuous f`（全域），`image_of_continuousOn` 可放宽到 ContinuousOn。

### `IsCompact.isClosed` / `IsCompact.inter` / `T1Space` / `T2Space` / `RegularSpace` / `NormalSpace` / `tendsto_nhds_unique` / `t2Space_iff_disjoint_nhds` / `regularSpace_iff`
- **人话**：**T2 中紧集闭** `IsCompact.isClosed`、紧集交仍紧 `IsCompact.inter`（都需 `[T2Space]`）；
  分离公理 T1/T2/正则/正规（Prop）；T2 极限唯一 `tendsto_nhds_unique`；
  T2 ⟺ 邻域不相交；正则 ⟺ 闭集与点可分离。
- **签名**：`tendsto_nhds_unique [T2Space X] (ha : Tendsto f l (nhds a)) (hb : Tendsto f l (nhds b)) : a = b`
- **出处**：`Mathlib/Topology/Separation/`
- **谁在用**：`topology.compact.finite`、`topology.separations`。
- **坑**：T1/T2 是 typeclass；`regularSpace_iff X` 需显式 X 参数；T3Space/T4Space 是 T2+正则/正规组合。

### `MetricSpace` / `Metric.ball` / `Metric.mem_ball` / `Metric.isOpen_ball` / `Metric.ball_subset_ball` / `dist_comm` / `dist_triangle` / `dist_self` / `dist_eq_zero`
- **人话**：度量空间 typeclass；开球 `Metric.ball x ε`（`y ∈ ball x ε ↔ dist y x < ε`）、开球开、球单调；
  距离公理（对称/三角/自反/零距判等）。度量拓扑由开球生成。
- **签名**：`Metric.mem_ball : y ∈ Metric.ball x ε ↔ dist y x < ε`；`Metric.isOpen_ball`
- **出处**：`Mathlib/Topology/MetricSpace/`
- **谁在用**：`topology.metric.def`。
- **坑**：定理名加 `metric_` 前缀避免与 mathlib 同名。

### `UniformContinuous` / `Metric.uniformContinuous_iff` / `UniformContinuous.continuous` / `uniformContinuous_id`
- **人话**：一致连续 `UniformContinuous f`（全局 ε-δ）；一致连续 ⟹ 连续；恒等一致连续。
- **签名**：`Metric.uniformContinuous_iff : UniformContinuous f ↔ ∀ ε>0, ∃ δ>0, ∀ a b, dist a b < δ → dist (f a) (f b) < ε`
- **出处**：`Mathlib/Topology/UniformSpace/`
- **谁在用**：`topology.metric.uniform`。

### `CauchySeq` / `Metric.cauchySeq_iff` / `cauchySeq_tendsto_of_complete` / `CompleteSpace` / `IsComplete`
- **人话**：Cauchy 列 ε-N 判据；完备空间中 Cauchy 列收敛（`cauchySeq_tendsto_of_complete`）；
  `CompleteSpace` 完备、`IsComplete s` 子集完备。
- **签名**：`Metric.cauchySeq_iff : CauchySeq u ↔ ∀ ε>0, ∃ N, ∀ m≥N, ∀ n≥N, dist (u m) (u n) < ε`
- **出处**：`Mathlib/Topology/UniformSpace/`
- **谁在用**：`topology.metric.cauchy-complete`。

### `UniformSpace.Completion` / `UniformSpace.Completion.coe'` / `uniformContinuous_coe` / `coe_injective` / `instCompleteSpace` / `instMetricSpace`
- **人话**：完备化 `Completion α`（任意一致空间嵌入完备空间）；嵌入一致连续、T0 中单射；
  Completion 完备且是度量空间（instance）。与实数构造（CauSeq）一脉相承。
- **签名**：`UniformSpace.Completion.coe' : α → UniformSpace.Completion α`；`UniformSpace.Completion.uniformContinuous_coe`
- **出处**：`Mathlib/Topology/UniformSpace/`
- **谁在用**：`topology.metric.completion`。
- **坑**：完备性/度量结构是 instance（非 Prop）。

### `exists_continuous_zero_one_of_isClosed` / `C(X, ℝ)`
- **人话**：**Urysohn 引理**：正规空间中不相交闭集 s、t 存在连续 f:X→[0,1] 使 f=0 在 s、f=1 在 t。
  `C(X, ℝ)` 是连续函数空间（ContinuousMap）。
- **签名**：`exists_continuous_zero_one_of_isClosed (hs : IsClosed s) (ht : IsClosed t) (hd : Disjoint s t) : ∃ f : C(X, ℝ), Set.EqOn (⇑f) 0 s ∧ Set.EqOn (⇑f) 1 t ∧ ∀ x, f x ∈ Set.Icc 0 1`
- **出处**：`Mathlib/Topology/Separation/`
- **谁在用**：`topology.separations.urysohn`。
- **坑**：`C(X, ℝ)` 是 ContinuousMap（用 `⇑f` 取函数）；值域在 [0,1] 用 `Set.Icc 0 1`。

### `zorn_le` / `zorn_subset` / `zorn_superset` / `IsChain` / `BddAbove` / `IsMax`
- **人话**：**Zorn 引理**（偏序每条链有上界 ⟹ 极大元）；⊆ 序版（子集族极大元）；⊇ 序版（极小元）。
  `IsChain r s` 链、`BddAbove` 有上界、`IsMax` 极大元。等价于选择公理，是极大理想/基存在性/Tychonoff 的工具。
- **签名**：`zorn_le (h : ∀ c, IsChain (·≤·) c → BddAbove c) : ∃ m, IsMax m`
- **出处**：`Mathlib/Order/Zorn.lean`
- **谁在用**：`settheory.zorn.zorn`。
- **坑**：Zorn 引理需要 `[Nonempty X]`（非空偏序集）；实际用子集族版更常见。

### `isCompact_pi_infinite` / `isCompact_univ_pi` / `Pi.compactSpace`
- **人话**：**Tychonoff 定理**：一族紧集的积紧（`isCompact_pi_infinite`/`isCompact_univ_pi`）；
  各因子紧 ⟹ 积空间紧（`Pi.compactSpace`）。等价于选择公理。
- **签名**：`isCompact_pi_infinite : (∀ i, IsCompact (s i)) → IsCompact {x | ∀ i, x i ∈ s i}`
- **出处**：`Mathlib/Topology/Compactness/Compact.lean`
- **谁在用**：`topology.compact.tychonoff`。
- **坑**：无限积的紧致性才是 Tychonoff 的本质；有限积紧可绕过（不需要 AC）。

## G18. 测度空间与外测度基础

### `MeasurableSpace` / `MeasurableSet` / `MeasurableSet.empty/compl/iUnion/inter/union`
- **人话**：σ-代数 `MeasurableSpace X`；可测集 `MeasurableSet s`；公理：∅/X 可测、补可测、
  可数并可测（`[Countable ι]`）、有限交并可测。测度的定义域。
- **签名**：`MeasurableSet.iUnion {ι} [Countable ι] : (∀ i, MeasurableSet (f i)) → MeasurableSet (⋃ i, f i)`
- **出处**：`Mathlib/MeasureTheory/MeasurableSpace/`
- **谁在用**：`real-analysis.measure.sigma-algebra`。
- **坑**：定理名加 `meas_` 前缀避免同名。

### `Measure` / `measure_empty` / `measure_sUnion` / `measure_mono` / `measure_union`
- **人话**：测度 `Measure X`（值域 ℝ≥0∞）；空集零测；**可数可加** `measure_sUnion`；
  单调性 `measure_mono`；有限可加 `measure_union`。Lebesgue 测度 `volume` 是其特例。
- **签名**：`measure_sUnion (hs : S.Countable) (hd : S.Pairwise Disjoint) : μ (⋃₀ S) = ∑' s : S, μ s`

### `MeasureTheory.measure_biUnion_finset` / `MeasureTheory.measure_iUnion_null` / `measure_toMeasurable`
- **人话**：有限个两两不交集合的测度可以相加；可数个零测集的并仍为零测；`toMeasurable` 把集合扩成同测度的可测集合。
- **签名**：`measure_biUnion_finset` 处理有限指标并；`measure_iUnion_null` 处理可数并的零测结论；`measure_toMeasurable` 保持测度不变。
- **谁在用**：`real-analysis.riemann.lebesgue-criterion`，用于把正振荡层的零测性组装成不连续点集零测，以及把零测集放入开覆盖。

### `Set.exists_isOpen_lt_of_lt` / `ENNReal.le_of_forall_pos_le_add`
- **人话**：零测集可以被任意小测度的开集覆盖；若一个非负无穷值小于任意正数加项，则它为零。
- **谁在用**：`real-analysis.riemann.lebesgue-criterion`，分别用于正向覆盖和反向测度矛盾。

### `Metric.ediam` / `Metric.uniformContinuousOn_iff` / `OscillationWithin.eq_zero_iff_continuousWithinAt`
- **人话**：`ediam` 描述集合像的扩展直径；紧集上的连续函数可用一致连续性控制振荡；局部振荡为零等价于区间内连续。
- **谁在用**：`real-analysis.riemann.lebesgue-criterion`，用于连续区域的有限覆盖和不连续点集的振荡分层。

### `Real.volume_Ioc`
- **人话**：实数半开区间的 Lebesgue 测度等于端点差（取非负部分）。
- **谁在用**：`real-analysis.riemann.lebesgue-criterion`，用于把区间长度估计翻译成测度估计。

## G19. 特殊函数、经典极限与三角恒等式

### `Real.exp_pos` / `Real.exp_add` / `Real.continuous_exp` / `Real.hasDerivAt_exp`
- **人话**：指数函数处处为正、把加法变成乘法、处处连续且导数等于自身。
- **谁在用**：`analysis.special-functions.basic`。

### `Real.continuous_sin` / `Real.continuous_cos` / `Real.hasDerivAt_sin` / `Real.hasDerivAt_cos`
- **人话**：正弦和余弦处处连续，且导数分别为余弦和负正弦。
- **谁在用**：`analysis.special-functions.basic`。

### `Real.log_mul` / `Real.continuousOn_log` / `Real.hasDerivAt_log`
- **人话**：对数把非零乘法变成加法；在正半轴连续；非零点导数为倒数。
- **谁在用**：`analysis.special-functions.log-tan-pow`。

### `Real.hasDerivAt_tan` / `Continuous.pow` / `HasDerivAt.pow`
- **人话**：正切函数的导数公式，以及自然幂函数的连续性和导数公式。
- **谁在用**：`analysis.special-functions.log-tan-pow`。

### `HasDerivAt.comp` / `HasDerivAt.congr_of_eventuallyEq` / `HasDerivAt.unique`
- **人话**：导数链式法则、邻域内相等函数可替换导数、同一点导数唯一。
- **谁在用**：`analysis.derivative.inverse-function`，用于反函数求导。

### `taylor_mean_remainder_lagrange_iteratedDeriv` / `taylor_within_apply` / `iteratedDerivWithin_zero`
- **人话**：有限阶 Taylor–Lagrange 余项、Taylor 多项式有限项展开，以及零阶导数退化为原函数。
- **谁在用**：`analysis.mvt.taylor-examples` 用于低阶有限展开；`analysis.series.taylor` 用于任意阶完整展开。

### `iteratedFDerivWithin_eq_iteratedFDeriv`
- **人话**：在唯一可微集合上且函数足够光滑时，集合内迭代导数等于全局迭代导数。
- **出处**：Mathlib 的高阶连续可微接口。
- **谁在用**：`analysis.series.taylor`，把区间 Taylor 多项式转换成教材系数公式。

### `NormedSpace.expSeries_div_hasSum_exp` / `Real.hasSum_sin` / `Real.hasSum_cos`
- **人话**：指数、正弦和余弦的完整幂级数在全部实数上分别收敛到原函数。
- **出处**：Mathlib 的指数级数与三角函数级数模块。
- **谁在用**：`analysis.series.taylor`。

### `Real.abs_iteratedDeriv_sin_le_one` / `Real.abs_iteratedDeriv_cos_le_one`
- **人话**：正弦和余弦的任意阶导数仍为带符号的正弦或余弦，故绝对值不超过一。
- **出处**：`Mathlib/Analysis/SpecialFunctions/Trigonometric/Deriv.lean`。
- **谁在用**：`analysis.series.taylor` 的任意阶余项估计。

### `Real.continuousOn_log` / `Real.strictMonoOn_log` / `Real.log_mul` / `Real.exp_log` / `Real.log_exp` / `Real.hasDerivAt_log`
- **人话**：自然对数在正半轴上连续且严格递增，乘法变加法，并与指数函数互为反函数；导数为 `1 / x`。
- **谁在用**：`analysis.special-functions.log`，用于后续经典极限和初等函数计算。

### `Real.continuous_arctan` / `Real.hasDerivAt_arctan` / `Real.tan_arctan` / `Real.hasDerivAt_arcsin` / `Real.hasDerivAt_arccos`
- **人话**：反正切、反正弦、反余弦的连续性与导数，以及 `tan` 与 `arctan` 的互逆恒等式。
- **谁在用**：`analysis.special-functions.tan-pow`，用于反三角函数的教材层性质。

### `Real.tendsto_log_atTop` / `Real.isLittleO_log_id_atTop` / `Real.tendsto_exp_div_pow_atTop` / `Real.isLittleO_pow_exp_atTop`
- **人话**：对数趋于无穷但比恒等函数慢，指数函数比任意固定自然幂增长更快。
- **谁在用**：`analysis.limits.asymptotic`，用于无穷小与无穷大阶比较。

### `Real.exp_pos` / `Real.exp_one_gt_two` / `Real.exp_one_lt_three` / `Real.log_exp`
- **人话**：自然常数 `e = exp 1` 为正且满足 `2 < e < 3`，并有 `log e = 1`。
- **谁在用**：`analysis.constants.e-definition`，作为重要常数的教材层接口。

### `Real.pi_pos` / `Real.pi_ne_zero` / `Real.sin_pi` / `Real.cos_pi` / `Real.two_pi_pos`
- **人话**：圆周率 `π` 为正且非零，`2π` 为正，并满足 `sin π = 0`、`cos π = -1`。
- **谁在用**：`analysis.constants.pi-definition`，作为圆周率的教材层接口。

### `Real.exp_zero` / `Real.log_one` / `Real.sin_zero` / `Real.cos_zero` / `Real.sin_pi_div_two` / `Real.cos_pi_div_two`
- **人话**：指数、对数、正弦和余弦在教材常用点 `0、1、π/2、π` 的特殊值。
- **谁在用**：`analysis.constants.special-values`，用于后续极限、级数和积分计算。

### `Real.sin_neg` / `Real.cos_neg` / `Real.sin_add_two_pi` / `Real.cos_add_two_pi` / `Real.neg_one_le_sin` / `Real.cos_le_one`
- **人话**：正弦奇、余弦偶，二者以 `2π` 为周期，并且都被 `[-1,1]` 控制。
- **谁在用**：`analysis.trigonometric.basic-identities`，作为高中三角恒等式批次的基础。

### `Real.sin_add` / `Real.sin_sub` / `Real.cos_add` / `Real.cos_sub`
- **人话**：正弦、余弦的和角与差角公式。
- **谁在用**：`analysis.trigonometric.add-sub`，用于倍角、半角和积化和差公式。

### `Real.sin_two_mul` / `Real.cos_two_mul` / `Real.sin_sq_eq_half_sub` / `Real.cos_sq` / `Real.sin_sq_add_cos_sq`
- **人话**：正弦余弦倍角、降幂和平方和恒等式。
- **谁在用**：`analysis.trigonometric.double-half`，用于后续积化和差与三角积分。

### `Real.sin_add` / `Real.sin_sub` / `Real.cos_add` / `Real.cos_sub`（环算术组合）
- **人话**：把乘积改写成和差，便于化简三角表达式和计算积分。
- **谁在用**：`analysis.trigonometric.product-sum`。

### `Real.sin_add` / `Real.sin_sub` / `Real.cos_add` / `Real.cos_sub`（半角代换组合）
- **人话**：把正弦、余弦的和差改写成两个半和半差的乘积。
- **谁在用**：`analysis.trigonometric.sum-product`。

### `Real.sin_pi_div_six` / `Real.cos_pi_div_six` / `Real.tan_pi_div_six` / `Real.sin_pi_div_four` / `Real.cos_pi_div_four` / `Real.tan_pi_div_four` / `Real.sin_pi_div_three` / `Real.cos_pi_div_three` / `Real.tan_pi_div_three`
- **人话**：`π/6、π/4、π/3` 三个高中常用特殊角的正弦、余弦和正切值。
- **谁在用**：`analysis.trigonometric.special-angles`。

### `Real.tan_add` / `Real.tan_sub` / `Real.tan_two_mul`
- **人话**：正切的和角、差角和倍角公式；和差公式保留正切极点条件。
- **谁在用**：`analysis.trigonometric.tan-identities`。

### `Real.abs_sin_half` / `Real.cos_sq` / `Real.sqrt_sq_eq_abs` / `Real.sin_nonneg_of_nonneg_of_le_pi` / `Real.cos_nonneg_of_mem_Icc`
- **人话**：半角平方根公式，以及在指定区间内正确选择平方根正号。
- **谁在用**：`analysis.trigonometric.half-root`。

### `irrational_nrt_of_notint_nrt`
- **人话**：一个实数的正整数次幂是整数，但该整数不是整数同次幂时，这个实数必无理。
- **谁在用**：`analysis.constants.nth-root-irrational`，作为 `√2` 等具体无理性结论的通用引理。

### `Real.exp_bound` / `Real.sum_le_exp_of_nonneg`
- **人话**：指数级数的有限截断不超过指数函数，并且截断误差有显式阶乘上界；在 `x=1` 时可把 `e` 的尾项压到两个相邻阶乘控制的区间内。
- **出处**：`Mathlib/Analysis/Complex/Exponential.lean`。
- **谁在用**：`analysis.constants.e-irrational`，用于证明缩放后的指数级数尾项严格位于 `0` 与 `1` 之间。

### `Nat.factorial_dvd_factorial` / `Nat.dvd_factorial` / `Rat.cast_def`
- **人话**：较小阶乘整除较大阶乘，正自然数整除自身阶乘；有理数在实数中的值等于其约分分子除以正分母。
- **出处**：`Mathlib/Data/Nat/Factorial/Basic.lean` 与 `Mathlib/Data/Rat/Cast/Defs.lean`。
- **谁在用**：`analysis.constants.e-irrational`，用于把有限级数和假设中的有理数同时缩放成整数。

### `irrational_pi`
- **人话**：实圆周率 `Real.pi` 是无理数；Mathlib 使用 Cartwright 积分法给出完整证明。
- **出处**：`Mathlib/Analysis/Real/Pi/Irrational.lean`。
- **谁在用**：`analysis.constants.pi-irrational`，将 Mathlib 结论转接到本库的教材层 `pi` 接口。

## G20. 一元 Riemann 积分与数值公式

### `intervalIntegral.integral_add` / `intervalIntegral.integral_sub` / `intervalIntegral.integral_const_mul`
- **人话**：在区间可积前提下，区间积分保持函数加法、减法与常数乘法。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean`。
- **谁在用**：`real-analysis.riemann.algebra`；先由本库等值桥梁识别积分值，再推出自建 Riemann 积分的线性。

### `intervalIntegral.integral_nonneg` / `intervalIntegral.integral_mono_on`
- **人话**：区间上非负的函数积分非负；两个区间可积函数逐点有序时，积分保持顺序。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean`。
- **谁在用**：`real-analysis.riemann.algebra`，用于自建 Riemann 积分的正性与单调性。

### `intervalIntegral.abs_integral_le_integral_abs` / `intervalIntegral.integral_add_adjacent_intervals`
- **人话**：积分绝对值不超过绝对值的积分；相邻两个区间的积分之和等于合并区间的积分。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean`。
- **谁在用**：`real-analysis.riemann.algebra`，经连续函数积分值等同定理转回 Riemann 教材接口。

### `intermediate_value_uIcc`
- **人话**：连续函数在两个点之间的无序闭区间上取遍两个端点函数值之间的所有值，不必预先判断两点或两函数值的顺序。
- **出处**：`Mathlib/Topology/Order/IntermediateValue.lean`。
- **谁在用**：`real-analysis.riemann.mean-value`，从积分平均值位于最小值与最大值之间推出中值点存在。

### `Function.Periodic.intervalIntegral_add_eq`
- **人话**：周期函数在任意一个完整周期上的区间积分与积分起点无关。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/Periodic.lean`。
- **谁在用**：`real-analysis.riemann.mean-value`，经积分值桥梁得到连续周期函数的 Riemann 积分版本。

### `HasSum` / `Summable` / `hasSum_geometric_of_norm_lt_one` / `Real.not_summable_one_div_natCast` / `Summable.of_norm` / `summable_iff_cauchySeq_finset`
- **人话**：级数的和与收敛、几何级数、调和级数发散、绝对收敛和 Cauchy 准则。
- **谁在用**：`analysis.series.basic`。

- **主题**：数项级数判别法
- **Mathlib 接口**：`summable_of_isBigO_nat`、`summable_of_ratio_test_tendsto_lt_one`、`not_summable_of_ratio_test_tendsto_gt_one`、`Antitone.cauchySeq_alternating_series_of_tendsto_zero`
- **本库封装**：`analysis.series.tests`
- **备注**：比值、根值与交错级数判别法均已转正；根值判别法另使用实数幂与最终控制接口，见 `analysis.series.root-test`。

### `HasDerivAt.tendsto_slope_zero` / `Real.cos_two_mul_eq_one_sub`
- **人话**：导数给出一点处的差商极限；余弦二倍角公式把余弦二阶极限化为正弦平方极限。
- **谁在用**：`analysis.limits.classical`，用于四个经典重要极限。
- **出处**：`Mathlib/MeasureTheory/Measure/`
- **谁在用**：`real-analysis.measure.def`。
- **坑**：可数可加前提是两两不交 + 可测；测度值用 ENNReal 可含 ∞。

## G21. Lebesgue 测度与积分

### `OuterMeasure` / `measure_iUnion_le` / `OuterMeasure.caratheodory` / `isCaratheodory_iff`
- **人话**：外测度 `OuterMeasure`（全体子集上次可加函数）；次可加 `measure_iUnion_le`；
  **Carathéodory 定理**：可测集构成 σ-代数（`caratheodory : MeasurableSpace`），判据
  `isCaratheodory_iff`（∀t, m t = m(t∩s)+m(t\s)）。Lebesgue 测度的构造基础。
- **签名**：`OuterMeasure.caratheodory m : MeasurableSpace X`；`measure_iUnion_le (s : ι → Set X) : μ (⋃ i, s i) ≤ ∑' i, μ (s i)`
- **出处**：`Mathlib/MeasureTheory/OuterMeasure/`
- **谁在用**：`real-analysis.measure.outer`、`real-analysis.measure.caratheodory`。
- **坑**：判据是 `=`；`caratheodory` 返回 MeasurableSpace（instance 非 Prop，不立条）。

### `Measurable` / `measurable_id` / `measurable_const` / `Measurable.comp`
- **人话**：可测函数 `Measurable f`（可测集原像可测）；恒等/常函数可测；可测复合可测。
  可测性是积分的必要条件。
- **签名**：`Measurable.comp (hg : Measurable g) (hf : Measurable f) : Measurable (g ∘ f)`
- **出处**：`Mathlib/MeasureTheory/MeasurableSpace/Defs.lean`
- **谁在用**：`real-analysis.measure.measurable-function`。

### `lintegral` / `lintegral_const` / `lintegral_mono` / `lintegral_eq_zero_iff`
- **人话**：非负积分 `∫⁻ f ∂μ`（f : X → ℝ≥0∞）；常数积分 `∫⁻c = c·μ(X)`；单调；∫f=0 ⟺ f=0 a.e.。
- **签名**：`lintegral_const (c : ℝ≥0∞) : ∫⁻ _, c ∂μ = c * μ Set.univ`；`lintegral_eq_zero_iff (hf : Measurable f)`
- **出处**：`Mathlib/MeasureTheory/Integral/Lebesgue/Basic.lean`
- **谁在用**：`real-analysis.measure.lintegral`。
- **坑**：lintegral 值域 ℝ≥0∞；一般积分（integral）是另一套。

### `lintegral_iSup` / `lintegral_liminf_le` / `tendsto_lintegral_of_dominated_convergence`
- **人话**：**单调收敛定理** `lintegral_iSup`（∫⁻(⨆fₙ)=⨆∫⁻fₙ，可测单调）；**Fatou**
  `lintegral_liminf_le`（∫⁻liminf ≤ liminf∫⁻）；**控制收敛** `tendsto_lintegral_of_dominated_convergence`
  （被可积控制 ⟹ 极限穿积分）。三大收敛定理是 Lebesgue 积分的核心。
- **签名**：`lintegral_iSup (hf : ∀ n, Measurable (f n)) (h_mono : Monotone f) : ∫⁻ (⨆ n, f n a) ∂μ = ⨆ n, ∫⁻ f n a ∂μ`；
  `tendsto_lintegral_of_dominated_convergence bound hF_meas h_bound h_fin h_lim`
- **出处**：`Mathlib/MeasureTheory/Integral/Lebesgue/`
- **谁在用**：`real-analysis.measure.monotone-convergence`、`real-analysis.measure.fatou`、`real-analysis.measure.dominated-convergence`。
- **坑**：liminf 用 `Filter.liminf`（需 `open Filter`）；𝓝 需 `open scoped Topology`；Fatou 需 `[u.IsCountablyGenerated]`。

### `intervalIntegral.integral_eq_sub_of_hasDerivAt` / `intervalIntegral.integral_hasStrictDerivAt_right`
- **人话**：**微积分基本定理**。FTC-2 `∫ₐᵇ f' = f b - f a`（f' 可积）；FTC-1 变上限积分可导
  `HasStrictDerivAt (u ↦ ∫ₐᵘ f) (f b) b`（f 在端点连续）。区间积分 `∫ x in a..b`。
- **签名**：`intervalIntegral.integral_eq_sub_of_hasDerivAt (hderiv : ∀ x ∈ [[a,b]], HasDerivAt f (f' x) x) (hint : IntervalIntegrable f' volume a b)`
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean`
- **谁在用**：`real-analysis.calculus.ftc`、`real-analysis.calculus.ftc-differentiate`。
- **坑**：`[[a,b]]` = uIcc 记法；FTC-1 需端点连续（FTCFilter 前提）。

### `volume` / `Real.volume_Icc` / `Real.volume_Ioo` / `measurableSet_Icc`
- **人话**：ℝ 上 **Lebesgue 测度** `volume`（MeasureSpace 规范测度）；区间长度 `volume [a,b] = ofReal (b-a)`；
  区间 Lebesgue 可测。由外测度+Carathéodory 构造，是测度积分的基础。
- **签名**：`Real.volume_Icc : volume (Icc a b) = ofReal (b - a)`；`Real.volume_Ioo`
- **出处**：`Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean`（namespace Real）
- **谁在用**：`real-analysis.lebesgue-measure`。
- **坑**：`volume_Icc` 在 `namespace Real`（全名 `Real.volume_Icc`）。

### `sSup` / `sInf` / `Finset.sum_range`（黎曼积分自建用）
- **人话**：黎曼积分自建的核心构件。`sSup`/`sInf` 取区间上确界/下确界（达布和）；
  `Finset.sum_range` 求和。mathlib 无黎曼积分定义，全部自建（Playbook §4.1）。
- **签名**：`sSup s`、`sInf s`；`∑ i ∈ Finset.range n, f i`
- **谁在用**：`real-analysis.riemann.def`。
- **坑**：达布上下和定义在 `DarbouxPartition` 上（自建结构）。

### `Metric.uniformContinuousOn_iff` / `Metric.continuousOn_iff` / `IsCompact.elim_finite_subcover` / `Finset.min'`（一致连续自建用）
- **人话**：Mathlib 已有 `IsCompact.uniformContinuousOn_of_continuous` 给出紧集上的 Heine--Cantor
  定理；本库仍保留 Lebesgue 数式的独立教材证明，用每点 δx、有限子覆盖和有限最小值完成论证。
- **签名**：`Metric.uniformContinuousOn_iff : UniformContinuousOn f s ↔ ∀ ε>0, ∃ δ>0, ∀ x∈s, ∀ y∈s, dist x y < δ → dist (f x) (f y) < ε`
- **谁在用**：`analysis.continuity.uniform-compact`。
- **坑**：有限子覆盖的 `⋃ i ∈ t` 解构会绑架 binder（Playbook §3.12），用 `simpa [Set.mem_iUnion]`。

### 黎曼积分自建全套（`DarbouxPartition`/`upperSum`/`lowerSum`/`RiemannIntegrable`/`uniformPartition`/`continuous_on_riemannIntegrable_lt`）
- **人话**：**黎曼积分完全自建**（mathlib 无）。达布分划/上下和/可积定义；
  **连续 ⟹ 可积**：一致连续（`continuousOn_compact_uniformContinuousOn`）给 δ，
  均匀分划步长 < δ，每子区间振荡 ≤ 2ε'（`C2_subinterval`），求和 ≤ 2ε'·(b-a) < ε。
- **签名**：`RiemannIntegrable f a b ↔ ∀ ε > 0, ∃ P : DarbouxPartition a b, upperSum f P - lowerSum f P < ε`
- **谁在用**：`real-analysis.riemann.cont-integrable`。
- **坑**：退化 [a,a] 无 Darboux 分划（严格增矛盾），主定理限 a<b；sSup/sInf 用 cs 版（§2.7.2）；
  含 |·| 目标不用 linarith（§2.7.0）。

### 黎曼积分数值=Lebesgue（自建全套: 达布和=阶梯积分/夹逼/相等）
- **人话**：连续函数黎曼积分值 = Lebesgue 区间积分。核心链：`integral_indicator`（阶梯函数积分 =
  达布和）→ 下和 ≤ ∫ ≤ 上和（上下阶梯夹逼 + 积分保序）→ `riemannIntegral = intervalIntegral`。
  全部自证（mathlib 无黎曼积分）。
- **签名**：`riemannIntegral_eq_interval (hab : a < b) (hf : ContinuousOn f (Icc a b)) : riemannIntegral f a b = ∫ x in Ioc a b, f x`
- **谁在用**：`real-analysis.riemann.eq-lebesgue`。
- **坑**：含 |·| 不用 linarith（§2.7.0）；sSup/sInf 用 cs 版（§2.7.2）；先立带 sorry 框架逐个填（§0）。

### `Measure.integrableOn_of_bounded` / `integral_indicator` / `integral_mono`（一般 Riemann 可积函数积分值桥梁）
- **人话**：Lebesgue 判据先把标准 Riemann 可积函数转成几乎处处连续；零测坏点不影响
  可测性，再由闭区间有界和有限测度得到 Lebesgue 可积。随后将 Darboux 上下阶梯函数
  写成 indicator 的有限和，并用积分保序夹住原函数。
- **签名用途**：`Measure.integrableOn_of_bounded` 从几乎强可测、有限测度和一致范数界推出
  可积；`integral_indicator` 识别区间积分；`integral_mono` 对可积函数实施逐点保序。
- **谁在用**：`real-analysis.riemann.eq-lebesgue-general`。
- **坑**：一般 Riemann 可积函数不是处处连续，不能复用连续函数的 `integrableOn_Icc`；
  必须先经 Lebesgue 判据删去可测零测坏点。Darboux 像集的上下确界合法性来自显式
  `BoundedOn`，对应 `csInf_le` 与 `le_csSup` 的有界性前提。

### `eventually_gt_nhds` / `HasDerivAt.congr_of_eventuallyEq`（变上限 Riemann 积分求导）
- **人话**：积分值桥只在 `a<u` 时可用。若目标点满足 `a<x`，则邻域中最终有
  `a<u`，从而自建变上限 Riemann 积分与 Mathlib 的变上限区间积分局部相等；导数只
  依赖局部函数值，因此可把已有 FTC 导数结论转移过来。
- **谁在用**：`real-analysis.riemann.ftc`。
- **坑**：不能要求两种变上限函数在所有实数上相等；本库尚未给 `u≤a` 的自建积分
  规定有向区间约定。应使用最终相等，而非证明全局函数相等。

### `intervalIntegral.integral_mul_deriv_eq_deriv_mul` / `intervalIntegral.integral_comp_mul_deriv`
- **人话**：前者是区间积分上的分部积分，后者是连续函数的换元积分。通过连续函数
  Riemann–Lebesgue 积分值桥，可直接转写成本库自建 `riemannIntegral` 的教材公式。
- **谁在用**：`real-analysis.riemann.parts-substitution`，以及其中 `∫xeˣ`、
  `∫c exp(cx+d)` 两个例题。
- **坑**：Mathlib 公式使用有向区间 `[[a,b]]`，而当前自建积分桥只覆盖严格正向区间；
  换元后的两个端点也必须显式证明保持严格次序。

### `hasDerivAt_pow` / `Real.hasDerivAt_exp` / `Real.hasDerivAt_sin` / `Real.hasDerivAt_cos`
- **人话**：初等函数的标准导数，用 Newton–Leibniz 公式计算自建 Riemann 定积分。
- **谁在用**：`analysis.integral.examples`，得到自然数幂、指数、正弦、余弦的公式；
  线性余弦例还复用 Riemann 换元定理。
- **坑**：`x^n` 的原函数含实数分母 `(n+1 : ℝ)`，化简导数时需要先证明该分母非零；
  正弦的原函数是 `-cos`，应显式处理两次负号。

### `taylor_integral_remainder` / `iteratedDerivWithin_eq_iteratedDeriv`
- **人话**：Mathlib 给出 Taylor 区间积分余项；唯一可微闭区间上，区间内高阶导数在
  内部等于全局高阶导数。再经积分值桥可得到教材的 Riemann 积分余项。
- **谁在用**：`analysis.mvt.taylor-integral-remainder`。
- **坑**：底层公式使用 `taylorWithinEval`、`iteratedDerivWithin` 和有向区间积分，不能
  直接作为本库教材结果登记；必须逐层转换，并用 `integral_congr_uIoo` 忽略端点差异。

### `Real.tendsto_prod_pi_div_two` / `Stirling.factorial_isEquivalent_stirling` / `Stirling.le_factorial_stirling` / `Stirling.le_log_factorial_stirling`
- **人话**：Wallis 乘积趋于 `π/2`；以此确定归一化阶乘序列的极限后，得到
  `n! ~ √(2πn)(n/e)ⁿ`。后两个结果分别给出对所有自然数有效的主项下界，以及正整数
  上展开后的对数下界。
- **出处**：`Mathlib/Analysis/Real/Pi/Wallis.lean`、
  `Mathlib/Analysis/SpecialFunctions/Stirling.lean`。
- **谁在用**：`analysis.asymptotic.stirling`。
- **坑**：Stirling 定理位于顶层命名空间 `Stirling`，不是 `Real.Stirling`；在本库同名
  命名空间内引用时应写 `_root_.Stirling`。渐近等价只控制充分大的指标，不能替代
  对每个 `n` 有效的 `le_factorial_stirling`。

---

## G22. 乘积测度与 Lp 空间

### `MeasureTheory.Measure.prod_prod` / `MeasureTheory.lintegral_prod` / `MeasureTheory.lintegral_prod_symm`
- **人话**：乘积测度在矩形上等于边测度之积；Tonelli 定理把非负可测函数的乘积
  积分写成迭代 `lintegral`，并可在两个 `SFinite` 测度之间交换次序。
- **出处**：`Mathlib/MeasureTheory/Measure/Prod.lean`。
- **谁在用**：`real-analysis.measure.product-measure`、`real-analysis.measure.tonelli`。
- **坑**：`lintegral` 的值域是 `ℝ≥0∞`，允许结果为无穷；不能把它误当成已经证明
  一般实值函数绝对可积。反向次序版本还需要 `[SFinite μ]`。

### `MeasureTheory.integral_prod` / `MeasureTheory.integral_integral_swap`
- **人话**：Fubini 定理。乘积测度下可积的 Banach 空间值函数，其 Bochner 积分等于
  迭代积分；柯里化版本直接给出交换积分次序。
- **出处**：`Mathlib/MeasureTheory/Integral/Prod.lean`。
- **谁在用**：`real-analysis.measure.fubini`。
- **坑**：换序前提是 `Integrable (Function.uncurry f) (μ.prod ν)`，不是仅仅要求两个
  内层积分逐点存在；两个测度均需 `SFinite`。

### `MeasureTheory.Lp` / `MeasureTheory.MemLp` / `MeasureTheory.MemLp.toLp`
- **人话**：`MemLp f p μ` 是普通函数“几乎处处强可测且 `p`-半范数有限”的性质；
  `Lp E p μ` 是按几乎处处相等取商后的有限范数函数空间；`toLp` 把满足条件的普通
  函数送入该商空间。
- **出处**：`Mathlib/MeasureTheory/Function/LpSeminorm/Defs.lean`、
  `Mathlib/MeasureTheory/Function/LpSpace/Basic.lean`。
- **谁在用**：`real-analysis.lp.basic`。
- **坑**：`Lp` 元素虽然可强制转换为函数，但其代表元只在几乎处处意义下确定；因此
  逐点运算接口通常返回 `=ᵐ[μ]`，不能擅自改成函数逐点相等。

### `MeasureTheory.MemLp.coeFn_toLp` / `MeasureTheory.MemLp.toLp_eq_toLp_iff` / `MeasureTheory.Lp.norm_toLp` / `MeasureTheory.Lp.coeFn_add` / `MeasureTheory.Lp.eq_zero_iff_ae_eq_zero`
- **人话**：连接普通函数与 `Lᵖ` 商空间的基本 API：恢复代表元、判定两个类相等、
  计算构造元素的范数、解释加法，以及用“几乎处处为零”判定零元素。
- **出处**：`Mathlib/MeasureTheory/Function/LpSpace/Basic.lean`。
- **谁在用**：`real-analysis.lp.basic`。
- **坑**：`norm_toLp` 的右侧是 `ENNReal.toReal (eLpNorm ...)`；转成实数合法是因为
  `MemLp` 已含有限性。不要在没有 `MemLp` 前提时直接对 `eLpNorm` 取实数值并当作范数。

### `MeasureTheory.integral_mul_norm_le_Lp_mul_Lq` / `MeasureTheory.integral_mul_le_Lp_mul_Lq_of_nonneg` / `MeasureTheory.MemLp.integrable_mul`
- **人话**：Hölder 不等式的范数版本、非负实函数版本，以及抽象的
  `Lᵖ · Lᑫ ⊆ L¹` 可积性结论。
- **出处**：`Mathlib/MeasureTheory/Integral/Bochner/Basic.lean`、
  `Mathlib/MeasureTheory/Function/L1Space/Integrable.lean`。
- **谁在用**：`real-analysis.lp.holder`。
- **坑**：前两个定理用实指数和 `Real.HolderConjugate`；乘积可积性用扩展实指数及
  `ENNReal.HolderTriple p q 1`。两套接口不可在不转换指数的情况下混用。

### `MeasureTheory.mul_meas_ge_le_pow_eLpNorm'`
- **人话**：Chebyshev–Markov 不等式的乘法型版本，以 `Lᵖ` 半范数控制范数超水平集
  的测度，并允许阈值为零。
- **出处**：`Mathlib/MeasureTheory/Function/LpSeminorm/ChebyshevMarkov.lean`。
- **谁在用**：`real-analysis.lp.chebyshev`。
- **坑**：指数是 `ℝ≥0∞`，必须排除 `0` 与 `∞`；水平集使用 `enorm`。若改用除法型
  版本，还必须另加非零阈值以及无穷值集合的边界条件。

### `MeasureTheory.eLpNorm_add_le` / `ENNReal.lintegral_Lp_add_le`
- **人话**：前者是一般赋范群值函数的 `Lᵖ` 半范数三角不等式，后者是非负扩展
  实值函数的显式幂积分 Minkowski 公式。
- **出处**：`Mathlib/MeasureTheory/Function/LpSeminorm/TriangleInequality.lean`、
  `Mathlib/MeasureTheory/Integral/MeanInequalities.lean`。
- **谁在用**：`real-analysis.lp.minkowski`。
- **坑**：二者的指数类型不同：前者是 `ℝ≥0∞` 并覆盖 `∞`，后者是 `ℝ`；都要求
  `1 ≤ p`。显式版本的函数值域为 `ℝ≥0∞`，不能直接代入带符号实函数。

### `MeasureTheory.Lp.instCompleteSpace` / `CompleteSpace.complete`
- **人话**：值域完备且 `p≥1` 时，`Lᵖ` 空间完备；通用完备空间接口进一步把任意
  Cauchy 滤子（特别是 Cauchy 序列）送到某个极限。
- **出处**：`Mathlib/MeasureTheory/Function/LpSpace/Complete.lean`、
  `Mathlib/Topology/MetricSpace/Completion.lean`。
- **谁在用**：`real-analysis.lp.complete`。
- **坑**：`Lp` 的拓扑实例本身要求 `[Fact (1 ≤ p)]`，不能只在证明体内迟到地提供
  普通假设 `hp : 1 ≤ p`。具体使用时应先把 `hp` 安装为局部 `Fact` 实例。

### `Real.young_inequality` / `Real.inner_le_Lp_mul_Lq` / `Finset.sum_mul_sq_le_sq_mul_sq` / `Real.Lp_add_le`
- **人话**：有限实数族上的 Young、Hölder、Cauchy–Schwarz 与 Minkowski 不等式，
  是积分型 `Lᵖ` 不等式之前的有限维原型。
- **出处**：`Mathlib/Analysis/MeanInequalities.lean`、
  `Mathlib/Algebra/Order/BigOperators/Ring/Finset.lean`。
- **谁在用**：`analysis.inequalities.young`、`analysis.inequalities.holder-finite`、
  `analysis.inequalities.cauchy-schwarz`、`analysis.inequalities.minkowski-finite`。
- **坑**：指数是实数，幂使用 `Real.rpow` 记法；Hölder 的底层定理控制带符号内积，
  标准绝对值版本需应用于 `|f|,|g|`。Minkowski 必须显式假设 `1 ≤ p`。

## G23. 赋范空间与多元微积分

### `NormedAddCommGroup` / `NormedSpace` / `CompleteSpace` / `dist_eq_norm`
- **人话**：依次表达带范数的加法群、标量数乘与范数相容、底层一致空间完备，
  以及范数诱导距离公式 `dist x y = ‖x-y‖`。
- **出处**：`Mathlib/Analysis/Normed/Group/Basic.lean`、
  `Mathlib/Analysis/Normed/Module/Basic.lean`。
- **谁在用**：`topology.normed-space.def`。
- **坑**：`NormedSpace 𝕜 E` 不单独携带 `E` 的范数和加法群，签名中仍需
  `[NormedAddCommGroup E]`；`CompleteSpace` 只表达完备性，也不是完整 Banach 结构。

### `norm_nonneg` / `norm_eq_zero` / `norm_add_le` / `abs_norm_sub_norm_le` / `norm_smul`
- **人话**：范数的正定性、三角不等式、反三角不等式和标量数乘公式。
- **出处**：`Mathlib/Analysis/Normed/Group/Basic.lean`、
  `Mathlib/Analysis/Normed/Module/Basic.lean`。
- **谁在用**：`topology.normed-space.inequalities`。
- **坑**：Mathlib 底层定理可推广到半范数群，但本库当前教材签名统一限制在
  `[NormedLinearSpace ℝ E]`。一般空间的范数不是实数绝对值，不可混用 `abs_*` 接口。

### `Metric.tendsto_atTop` / `Metric.cauchySeq_iff` / `cauchySeq_tendsto_of_complete`
- **人话**：度量序列的 ε–N 收敛判据、Cauchy 判据，以及完备空间中 Cauchy 列
  必收敛；通过 `dist_eq_norm` 即得到范数版本。
- **出处**：`Mathlib/Topology/MetricSpace/Pseudo/Constructions.lean`、
  `Mathlib/Topology/MetricSpace/Isometry.lean`。
- **谁在用**：`topology.normed-space.banach`。
- **坑**：`CauchySeq` 使用底层一致结构；范数空间中它与范数 Cauchy 等价，但在
  一般拓扑空间中不能无条件写 ε–N 距离判据。

### `HasFDerivAt` / `DifferentiableAt` / `HasFDerivAt.comp` / `HasFDerivAt.fderiv`
- **人话**：Fréchet 全微分的存在、可微性、链式法则以及已知导数与 `fderiv` 的一致性。
- **出处**：`Mathlib/Analysis/Calculus/FDeriv/Basic.lean`、`FDeriv/Comp.lean`。
- **谁在用**：`analysis.multivariable.frechet`。
- **坑**：`fderiv` 在不可微点取零；计算公式必须携带可微或 `HasFDerivAt` 前提。

### `HasGradientAt` / `HasGradientAt.hasFDerivAt` / `HasGradientAt.fderiv_apply`
- **人话**：用 Riesz 表示把实值函数的全微分写成梯度内积，并计算任意方向导数。
- **出处**：`Mathlib/Analysis/Calculus/Gradient/Basic.lean`。
- **谁在用**：`analysis.multivariable.gradient`。
- **坑**：梯度需要内积和完备性；一般赋范空间只有全微分，不一定存在梯度向量。

### `LinearMap.pi_apply_eq_sum_univ` / `Pi.single`
- **人话**：将有限维坐标向量按标准基展开，并计算线性映射在该展开上的作用。
- **出处**：`Mathlib/LinearAlgebra/Pi.lean`、`Mathlib/Algebra/BigOperators/Pi.lean`。
- **谁在用**：`analysis.multivariable.coordinates`。
- **坑**：标准基的底层指示函数可能写成 `if i = j`，而 `Pi.single` 展开成
  `if j = i`；证明函数相等时需要显式使用等号对称性。

### `Matrix.mulVec` / `Matrix.mul_apply`
- **人话**：矩阵乘列向量以及矩阵乘法的逐元素有限和公式。
- **出处**：`Mathlib/Data/Matrix/Mul.lean`。
- **谁在用**：`analysis.multivariable.coordinates`。
- **坑**：本库 Jacobian 以输出分量为行、输入变量为列；复合函数对应
  `Jg(f(x)) * Jf(x)`，不可把乘法次序写反。

### `iteratedFDeriv` / `ContDiffAt.isSymmSndFDerivAt`
- **人话**：任意阶 Fréchet 导数，以及二阶连续可微时二阶导数交换两个方向的定理。
- **出处**：`Mathlib/Analysis/Analytic/IteratedFDeriv.lean`、
  `Mathlib/Analysis/Calculus/FDeriv/Symmetric.lean`。
- **谁在用**：`analysis.multivariable.hessian-taylor`。
- **坑**：`iteratedFDeriv ℝ k f x` 接受一个 `Fin k → E` 的方向族；Hessian 元素必须
  明确给出两个标准基方向，不能把它当作普通二元函数直接应用。

### `Matrix.IsSymm` / `Matrix.IsSymm.ext_iff` / `Matrix.transpose_add`
- **人话**：方阵等于自身转置、该性质的逐元素判据，以及转置保持矩阵加法。
- **出处**：`Mathlib/LinearAlgebra/Matrix/Symmetric.lean`、
  `Mathlib/Data/Matrix/Defs.lean`。
- **谁在用**：`linear-algebra.matrix.symmetric`、`linear-algebra.matrix.skew-symmetric`。
- **坑**：`IsSymm` 只使用普通转置；复矩阵内积理论通常需要共轭转置与 Hermitian，
  二者不可混淆。反对称矩阵的对角元为零还需排除特征二。

### `map_add_eq_sum_add_integral_iteratedFDeriv`
- **人话**：实赋范空间上的任意阶 Taylor 公式，余项写成沿线段的区间积分。
- **出处**：`Mathlib/Analysis/Calculus/TaylorIntegral.lean`。
- **谁在用**：`analysis.multivariable.hessian-taylor`。
- **坑**：次数 `N` 的余项使用 `N+1` 阶导数；值域需完备，光滑性假设覆盖整条
  `x+t y` 线段，而不只是基点 `x`。

### `ContDiffAt.toOpenPartialHomeomorph` / `HasStrictFDerivAt.to_localInverse`
- **人话**：可逆全微分把 `C¹` 映射提升为局部同胚，并给出局部逆的严格导数。
- **出处**：`Mathlib/Analysis/Calculus/InverseFunctionTheorem/ContDiff.lean`、
  `InverseFunctionTheorem/FDeriv.lean`。
- **谁在用**：`analysis.multivariable.inverse-function`。
- **坑**：定理构造的是带 source/target 的局部同胚，不是全局双射；逆映射导数的
  基点必须是 `f a`。

### `ContDiffAt.implicitFunction` / `ContDiffAt.eventually_apply_eq_iff_implicitFunction`
- **人话**：偏全微分可逆时构造隐函数，并把原水平集在邻域内刻画为隐函数图像。
- **出处**：`Mathlib/Analysis/Calculus/ImplicitContDiff.lean`、
  `ImplicitFunction/ProdDomain.lean`。
- **谁在用**：`analysis.multivariable.implicit-function`、
  `analysis.multivariable.full-rank-theorem`。
- **坑**：`.inl/.inr` 决定哪组变量保留、哪组变量被解出；交换二者会得到类型正确但
  数学方向相反的定理。Mathlib 尚无一般常秩 `r` 正规形的直接接口。

## 多元积分、Jordan 区域与换元

### `nullMeasurableSet_of_null_frontier` / `closure_ae_eq_of_null_frontier`
- **人话**：边界为零测集时，原集合是零可测集；而且集合与其闭包只相差一个零测集，
  因此二者上的测度和积分相同。
- **出处**：`Mathlib/MeasureTheory/Order/UpperLower.lean`。
- **谁在用**：`analysis.multivariable.jordan-region`。
- **坑**：这里得到的是 `NullMeasurableSet`，比 `MeasurableSet` 弱但足够定义限制测度和
  集合积分；不能无条件把任意 Jordan 区域断言为 Borel 可测。

### `AEContinuous.hasBoxIntegral` / `integral_indicator₀`
- **人话**：盒上有界且几乎处处连续的函数，其 Riemann 型盒积分等于相应 Lebesgue
  积分；零可测集合的示性函数全空间积分等于该集合上的积分。
- **出处**：`Mathlib/Analysis/BoxIntegral/Integrability.lean`、
  `Mathlib/MeasureTheory/Integral/Bochner/Set.lean`。
- **谁在用**：`analysis.multivariable.jordan-riemann-bridge`。
- **坑**：`AEContinuous.hasBoxIntegral` 的“有界”是在 `Box.Icc I` 上逐点有界，而连续性
  是相对于整个测度空间几乎处处成立；`integral_indicator₀` 接受零可测而非必须可测。

### `BoxIntegral.IntegrationParams.Riemann` / `ContinuousOn.hasBoxIntegral`
- **人话**：前者选择标签盒分割中的经典 Riemann 过滤器；后者说明闭盒上连续函数的
  盒积分存在，并且数值等于盒上的 Lebesgue 积分。
- **出处**：`Mathlib/Analysis/BoxIntegral/Partition/Filter.lean`、
  `Mathlib/Analysis/BoxIntegral/Integrability.lean`。
- **谁在用**：`analysis.multivariable.riemann-box`。
- **坑**：`BoxIntegral` 的盒由有限指标类型给坐标；`IntegrationParams.Riemann` 与
  Henstock、McShane 参数不同，不可仅凭都叫 `HasIntegral` 就混用。

### `MeasureTheory.integral_indicator`
- **人话**：可测集合上的 Bochner 集合积分等于该集合示性函数在全空间的积分，是在
  Fubini 前后展开和收回区域限制的标准桥梁。
- **出处**：`Mathlib/MeasureTheory/Integral/Bochner/Set.lean`。
- **谁在用**：`analysis.multivariable.x-normal-domain`。
- **坑**：该版本需要 `MeasurableSet`；集合仅零可测时应使用 `integral_indicator₀`。
  重写方向经常相反，集合积分展开为示性函数时通常使用 `.symm`。

### `MeasureTheory.volume_preserving_finTwoArrow`
- **人话**：坐标等价 `(Fin 2 → ℝ) ≃ ℝ × ℝ` 保持 Lebesgue 体积，因此盒积分使用的
  二维向量坐标可以无 Jacobian 因子地改写为 Fubini 使用的积坐标。
- **出处**：`Mathlib/MeasureTheory/Constructions/Pi.lean`。
- **谁在用**：`analysis.multivariable.x-normal-domain`。
- **坑**：单有类型等价不保证积分不变；必须使用其 `MeasurePreserving` 证明，并配合
  `MeasurableEmbedding` 调用 `integral_comp`。

### `MeasureTheory.setIntegral_prod` / `MeasureTheory.intervalIntegral_intervalIntegral_swap`
- **人话**：第一条是矩形集合上的 Fubini 公式；第二条在绝对可积条件下交换两个有向
  区间积分的次序。
- **出处**：`Mathlib/MeasureTheory/Integral/Prod.lean`。
- **谁在用**：`analysis.multivariable.rectangle-integral`。
- **坑**：`setIntegral_prod` 使用无向集合积分；`intervalIntegral_intervalIntegral_swap`
  使用有向区间，并以 `uIoc` 上的可积性统一处理端点次序。

### `MeasureTheory.integral_image_eq_integral_abs_det_fderiv_smul`
- **人话**：可测区域上可微且单射的有限维变换满足 Bochner 积分换元公式，像区域积分
  等于原区域上复合函数乘以 Fréchet 导数行列式绝对值后的积分。
- **出处**：`Mathlib/MeasureTheory/Function/Jacobian.lean`。
- **谁在用**：`analysis.multivariable.change-variables`。
- **坑**：底层签名要求显式给出导数场 `f'`；本库用 `fderivWithin` 封装。因子必须是
  `|det|`，不能在未固定定向时去掉绝对值。

### `MeasureTheory.integrableOn_image_iff_integrableOn_abs_det_fderiv_smul`
- **人话**：在同一换元假设下，函数在像区域可积，当且仅当复合后乘 Jacobian
  绝对值的函数在原区域可积。
- **出处**：`Mathlib/MeasureTheory/Function/Jacobian.lean`。
- **谁在用**：`analysis.multivariable.change-variables`。
- **坑**：积分等式对 Bochner 积分的默认零值约定仍可形式成立；要进行教材中的合法
  数值计算，应先用本条确认可积性，而不是只引用积分等式。

## 分析基础、级数与积分工具

### `Continuous.mul` / `Continuous.div`
- **人话**：连续实函数的乘积仍连续；分母处处非零时商函数连续。
- **出处**：`Mathlib/Topology/Algebra/Ring/Basic.lean`。
- **谁在用**：`analysis.continuity.mul`、`analysis.continuity.div`。
- **坑**：除法版本必须提供分母非零条件；它不是由连续性自动推出的。

### `Filter.Tendsto.mul` / `Filter.Tendsto.div` / `Filter.Tendsto.pow`
- **人话**：滤子极限保持乘法、非零分母下的除法以及固定自然数次幂。
- **出处**：`Mathlib/Topology/Algebra/Group/Basic.lean`、
  `Mathlib/Topology/Algebra/Order/Field.lean`。
- **谁在用**：`analysis.func-limit.mul/div`、`analysis.sequence.mul/div`、
  `analysis.limits.classical`。
- **坑**：`div` 的非零条件落在极限值而非仅逐点分母；`pow` 的指数是固定自然数。

### `Metric.tendsto_nhds`
- **人话**：度量空间中趋于点邻域等价于最终进入每个正半径球，是 ε 定义的滤子版本。
- **出处**：`Mathlib/Topology/MetricSpace/Pseudo/Constructions.lean`。
- **谁在用**：`analysis.func-limit.definition`。
- **坑**：展开后使用距离 `dist`；实数绝对值形式还需 `Real.dist_eq` 对齐。

### `Summable.abs` / `Summable.tendsto_sum_tsum_nat`
- **人话**：绝对可和级数本身可和；可和自然数级数的部分和趋于其无穷和。
- **出处**：`Mathlib/Topology/Algebra/InfiniteSum/Basic.lean`、
  `Mathlib/Topology/Algebra/InfiniteSum/NatInt.lean`。
- **谁在用**：`analysis.series.absolute`、`analysis.power-series.definition`。
- **坑**：`Summable.abs` 是实数绝对值版本；一般赋范空间应使用范数可和条件。

### `Antitone.cauchySeq_alternating_series_of_tendsto_zero` / `Antitone.tendsto_alternating_series_of_tendsto_zero`
- **人话**：递减趋零的非负项满足 Leibniz 交错级数判别；分别给出部分和 Cauchy 性和
  收敛到无穷和。
- **出处**：`Mathlib/Analysis/SpecificLimits/Normed.lean`。
- **谁在用**：`analysis.series.tests`、`analysis.series.conditional`。
- **坑**：`Antitone`、非负和趋零缺一不可；符号交错已编码在定理中的项形状里。

### `summable_of_ratio_test_tendsto_lt_one` / `not_summable_of_ratio_test_tendsto_gt_one`
- **人话**：比值趋于小于一的数时级数绝对收敛；比值趋于大于一时级数不收敛。
- **出处**：`Mathlib/Analysis/SpecificLimits/Normed.lean`。
- **谁在用**：`analysis.series.tests`。
- **坑**：定理通常作用于范数或相邻项比值，并需处理分母为零及最终条件。

### `summable_of_isBigO_nat`
- **人话**：若数列最终被一个已知可和数列以大 O 控制，则该数列也可和，是比较判别
  法的渐近记号接口。
- **出处**：`Mathlib/Analysis/Asymptotics/Asymptotics.lean`、级数相关模块。
- **谁在用**：`analysis.series.tests`。
- **坑**：大 O 位于 `atTop` 滤子；比较对象必须先有 `Summable` 证明。

### `Equiv.summable_iff` / `Equiv.tsum_eq`
- **人话**：双射重编号保持可和性，并且保持无穷和数值，是绝对收敛级数任意重排的
  底层接口。
- **出处**：`Mathlib/Topology/Algebra/InfiniteSum/Basic.lean`。
- **谁在用**：`analysis.series.rearrangement`。
- **坑**：这些结论针对 `Summable`；条件收敛级数不能直接调用，必须另做 Riemann 重排构造。

### `le_sSup` / `lt_sSup_iff`
- **人话**：完全序中的上确界上界性质及严格小于上确界的刻画。
- **出处**：`Mathlib/Order/CompleteLattice/Basic.lean`。
- **谁在用**：`analysis.power-series.radius`。
- **坑**：这是完全格版本；实数上对一般非空有界集合常应改用条件完备的 `le_csSup`。

### `le_csSup` / `csInf_le`
- **人话**：条件完备线性序中，集合元素不超过其上确界，且下确界不超过集合元素。
- **出处**：`Mathlib/Order/ConditionallyCompleteLattice/Basic.lean`。
- **谁在用**：`real-analysis.riemann.eq-lebesgue-general`。
- **坑**：必须提供集合非空和相应有界性；实数不是带无穷端点的完全格。

### `intervalIntegral.integral_of_le` / `intervalIntegral.integral_congr_uIoo`
- **人话**：正向有向区间积分等于半开区间集合积分；在无向开区间上逐点相等的函数
  有相同的区间积分。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean`。
- **谁在用**：`real-analysis.riemann.ftc`、`analysis.mvt.taylor-integral-remainder`。
- **坑**：前者需要端点有序；后者忽略端点值，但仍需满足相应可积性条件。

### `MeasureTheory.measure_mono` / `MeasureTheory.measure_toMeasurable`
- **人话**：测度关于集合包含单调；集合的可测包络与原集合具有相同测度。
- **出处**：`Mathlib/MeasureTheory/Measure/Basic.lean`、
  `Mathlib/MeasureTheory/Measure/Regular.lean`。
- **谁在用**：`real-analysis.riemann.lebesgue-criterion`。
- **坑**：`measure_toMeasurable` 依赖有限测度条件；可测包络不是集合闭包。

### `interior` / `mem_closure_iff`
- **人话**：`interior s` 是集合内部；点属于闭包当且仅当每个该点邻域都与集合相交。
- **出处**：`Mathlib/Topology/Defs/Basic.lean`、`Mathlib/Topology/Closure.lean`。
- **谁在用**：`topology.space.closure`。
- **坑**：`interior` 是定义而非定理；`mem_closure_iff` 的邻域表述需要相应拓扑假设版本。

## 线性代数与矩阵基础工具

### `Module.finrank_pi` / `Module.finrank_self`
- **人话**：有限坐标函数空间的维数等于各坐标维数之和；域作为自身的一维向量空间
  维数为一。
- **出处**：`Mathlib/LinearAlgebra/FiniteDimensional/Basic.lean`、
  `Mathlib/LinearAlgebra/Dimension/Finrank.lean`。
- **谁在用**：`linear-algebra.vector-space.def`。
- **坑**：需要有限指标类型和有限维实例；不要与无限基数维数 `Module.rank` 混淆。

### `Submodule.span_le` / `Submodule.span_mono`
- **人话**：生成子空间包含于某子空间等价于生成元全在其中；扩大生成元集合会扩大
  生成子空间。
- **出处**：`Mathlib/LinearAlgebra/Span/Basic.lean`。
- **谁在用**：`linear-algebra.vector-space.span`。
- **坑**：`span_le` 是消去生成闭包的核心 iff；包含方向写反时优先检查 `≤` 的子空间语义。

### `IsUnit`
- **人话**：元素是单位，即存在乘法逆元；矩阵行列式是单位等价于矩阵可逆。
- **出处**：`Mathlib/Algebra/Group/Units/Defs.lean`。
- **谁在用**：`linear-algebra.det.invertible`。
- **坑**：一般交换环上应说 `IsUnit det`，只有在域上才能简化为行列式非零。

### `Matrix.cramer_apply`
- **人话**：Cramer 法则的逐坐标形式，用替换一列后的行列式除以原矩阵行列式表示
  线性方程组解。
- **出处**：`Mathlib/LinearAlgebra/Matrix/NonsingularInverse.lean`。
- **谁在用**：`linear-algebra.det.cramer`。
- **坑**：需要矩阵可逆/行列式非零，且列替换索引和矩阵乘向量的约定必须一致。

### `Matrix.charpoly_diagonal` / `Matrix.charpoly_monic`
- **人话**：对角矩阵特征多项式是各对角项对应一次因子的乘积；任意方阵特征多项式
  都是首一多项式。
- **出处**：`Mathlib/LinearAlgebra/Matrix/Charpoly/Basic.lean`。
- **谁在用**：`linear-algebra.eigen.charpoly`。
- **坑**：特征多项式符号约定是 `det(XI-A)`；与手写 `det(A-λI)` 相差可能的符号。

### `Module.End.HasEigenvector.apply_eq_smul` / `Module.End.HasEigenvalue.mem_spectrum`
- **人话**：特征向量满足线性算子作用等于特征值数乘；特征值属于算子的谱。
- **出处**：`Mathlib/LinearAlgebra/Eigenspace/Basic.lean`、
  `Mathlib/LinearAlgebra/Spectrum/Basic.lean`。
- **谁在用**：`linear-algebra.eigen.vector`、`linear-algebra.eigen.spectrum`。
- **坑**：特征向量结构包含非零条件；无限维或一般环上的谱与有限维矩阵根的表述不同。

### `Matrix.transpose_neg` / `Matrix.transpose_sub`
- **人话**：转置保持取负和减法，用于证明反对称矩阵对线性组合封闭。
- **出处**：`Mathlib/Data/Matrix/Basic.lean`。
- **谁在用**：`linear-algebra.matrix.skew-symmetric`。
- **坑**：普通转置不含共轭；复矩阵 Hermitian/反 Hermitian 性质应使用共轭转置。

## 多元微分、特殊函数与坐标积分

### `ContDiffAt.hasStrictFDerivAt_implicitFunction`
- **人话**：隐函数定理构造出的局部隐函数具有严格 Fréchet 导数，并给出由偏导数组合
  得到的导数公式。
- **出处**：`Mathlib/Analysis/Calculus/ImplicitFunction.lean`。
- **谁在用**：`analysis.multivariable.implicit-function`。
- **坑**：隐函数的变量块由 `.inl/.inr` 嵌入决定；导数逆映射作用在哪个偏变量上必须核对。

### `Real.continuous_arcsin` / `Real.continuous_arccos`
- **人话**：实反正弦与反余弦函数在全实线上连续（定义在区间外采用截断延拓）。
- **出处**：`Mathlib/Analysis/SpecialFunctions/Trigonometric/Inverse.lean`。
- **谁在用**：`analysis.special-functions.log-tan-pow`。
- **坑**：反函数恒等式只在标准值域/定义域成立，连续性本身不提供 `sin (arcsin x)=x` 的范围条件。

### `Real.neg_one_le_cos` / `Real.sin_le_one`
- **人话**：余弦下界为 `-1`，正弦上界为 `1`，是三角函数值域估计的基本端点。
- **出处**：`Mathlib/Analysis/SpecialFunctions/Trigonometric/Bounds.lean`。
- **谁在用**：`analysis.trigonometric.basic-identities`。
- **坑**：完整绝对值界通常还需另一侧不等式，或直接使用 `abs_sin_le_one` 等接口。

### `integral_comp_polarCoord_symm`
- **人话**：除去零测的负实轴后，二维极坐标逆映射把全平面积分变成
  `(0,∞)×(-π,π)` 上带半径权重的积分。
- **出处**：`Mathlib/Analysis/SpecialFunctions/PolarCoord.lean`。
- **谁在用**：`analysis.multivariable.coordinate-integrals`。
- **坑**：定理方向是“极坐标积分等于全平面积分”；教材常用方向需要取对称等式。

### `hasFDerivAt_polarCoord_symm` / `det_fderivPolarCoordSymm`
- **人话**：给出极坐标映射 `(r,θ) ↦ (r cos θ,r sin θ)` 的 Fréchet 导数，并证明
  该导数矩阵的行列式等于 `r`。
- **出处**：`Mathlib/Analysis/SpecialFunctions/PolarCoord.lean`。
- **谁在用**：`analysis.multivariable.coordinate-integrals`。
- **坑**：行列式是 `r`，换元公式实际使用 `|r|`；只有在标准区域 `r>0` 上才能化成 `r`。

### `HasDerivAt.smul_const`
- **人话**：若实函数 `f` 在一点的导数为 `f'`，则固定向量倍函数
  `x ↦ f x • v` 的导数为 `f' • v`。
- **出处**：`Mathlib/Analysis/Calculus/Deriv/Mul.lean`。
- **谁在用**：`analysis.multivariable.parametrized-curves-surfaces`，用于计算仿射直线速度。
- **坑**：这是“标量函数乘固定向量”，不要与两个变量函数相乘的乘积法则混淆。

### `intervalIntegral.integral_const`
- **人话**：常向量在有向区间上的积分为 `(b-a) • c`；当 `a>b` 时符号自动反向。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean`。
- **谁在用**：`analysis.multivariable.parametrized-curves-surfaces`，用于仿射直线弧长公式。
- **坑**：结果使用标量作用 `•`；对实数值函数可再化成普通乘法。

### `HasDerivAt.scomp`
- **人话**：向量值函数与实参数函数复合时的链式法则：新速度等于参数变化率数乘原速度。
- **出处**：`Mathlib/Analysis/Calculus/Deriv/Comp.lean`。
- **谁在用**：`analysis.multivariable.parametrized-curves-surfaces`，已转成教材层的
  `curveVelocity_comp`。
- **坑**：向量值外层函数使用 `scomp`；普通标量乘法版本使用 `comp`。

### `intervalIntegral.integral_comp_mul_deriv_of_deriv_nonneg`
- **人话**：一维保向换元公式；若参数函数连续、可导且导数非负，则
  `∫ g(φ(t)) φ'(t) dt = ∫ g(u) du`，积分端点随 `φ` 变化。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/IntegrationByParts.lean`。
- **谁在用**：`analysis.multivariable.parametrized-curves-surfaces`，已转成保向换参数下的
  弧长不变性。
- **坑**：非负导数负责保向；若允许反向，速率中的绝对值与有向积分端点必须分别处理。

## 对偶、张量、外代数与微分形式

### `Fintype.linearIndependent_iff`
- **人话**：有限向量族线性无关，当且仅当任意有限系数组合等于零时每个系数都为零。
- **出处**：`Mathlib/LinearAlgebra/LinearIndependent/Defs.lean`。
- **谁在用**：`analysis.multivariable.parametrized-curves-surfaces`，用于把仿射平面微分单射
  转成两个生成方向线性无关的教材判据。
- **坑**：系数写成整个有限类型上的函数；二元情形需要把它展开成两个坐标。

### `Submodule.mem_span_pair`
- **人话**：向量属于 `u,v` 张成的子空间，当且仅当它可以写成 `a u + b v`。
- **出处**：`Mathlib/LinearAlgebra/Span/Defs.lean`。
- **谁在用**：`analysis.multivariable.parametrized-curves-surfaces`，已用于证明仿射平面的像是
  `p + span{u,v}`，并推出生成方向换基不改变平面。
- **坑**：等式方向是 `a • u + b • v = z`；从点集条件恢复参数时要先处理基点平移。

### `Subspace.dual_finrank_eq`
- **人话**：向量空间与其对偶空间的维数相同。
- **出处**：`Mathlib/LinearAlgebra/Dual/Lemmas.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，已转成教材层的 `dim_dual_eq_dim`。
- **坑**：定理历史上位于 `Subspace` 命名空间，名字容易误以为需要先给一个子空间。

### `Module.Dual.eval`
- **人话**：自然地把向量 `v` 送入双对偶，所得泛函在 `φ` 上取值为 `φ(v)`。
- **出处**：`Mathlib/LinearAlgebra/Dual/Defs.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，用于双对偶评价映射。
- **坑**：这是无需选择基的自然映射；断言它是同构还需要有限维等条件。

### `Module.bijective_dual_eval`
- **人话**：反身模的自然双对偶评价映射是双射；有限维向量空间自动满足此前提。
- **出处**：`Mathlib/LinearAlgebra/Dual/Defs.lean` 与 `Dual/Lemmas.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，用于有限维空间与双对偶的自然对应。
- **坑**：无限维代数对偶通常不与原空间同构，不能无条件使用。

### `Module.finrank_tensorProduct`
- **人话**：有限维张量积的维数等于两个因子维数的乘积。
- **出处**：`Mathlib/LinearAlgebra/Dimension/Constructions.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，已转成 `dim_tensor_eq_mul`。
- **坑**：这是有限维 `finrank` 公式；无限维时应改用基数值的 `Module.rank`。

### `TensorProduct.lift`
- **人话**：张量积的泛性质，把一个双线性映射唯一线性化为张量积上的线性映射。
- **出处**：`Mathlib/LinearAlgebra/TensorProduct/Basic.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，已包装为教材接口 `tensorLift`。
- **坑**：应先把双线性映射写成柯里化的线性映射 `V →ₗ W →ₗ X`。

### `contractLeft`
- **人话**：对偶张量的自然缩并，把 `φ ⊗ v` 送到标量 `φ(v)`。
- **出处**：`Mathlib/LinearAlgebra/Contraction.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`。
- **坑**：左右缩并的张量因子顺序不同；这里采用 `V* ⊗ V`。

### `ExteriorAlgebra.ι_sq_zero`
- **人话**：向量嵌入外代数后与自身楔乘为零，即 `v ∧ v = 0`。
- **出处**：`Mathlib/LinearAlgebra/ExteriorAlgebra/Basic.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，已转成 `vectorWedge_self`。
- **坑**：结论发生在整个外代数中；所属的齐次外幂需要另行登记。

### `ExteriorAlgebra.ι_add_mul_swap`
- **人话**：两个一次向量的两个乘法次序之和为零，由此得到 `u ∧ v = -v ∧ u`。
- **出处**：`Mathlib/LinearAlgebra/ExteriorAlgebra/Basic.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，已转成向量楔积反交换律。
- **坑**：特征为二时负号等于正号，但“平方为零”的交替性质仍是核心定义。

### `AlternatingMap.map_eq_zero_of_eq`
- **人话**：交替多重线性映射只要两个不同位置输入相同向量，输出就为零。
- **出处**：`Mathlib/LinearAlgebra/Alternating/Basic.lean`。
- **谁在用**：`linear-algebra.tensor-exterior`，已转成教材层交替形式判据。
- **坑**：除了输入相等，还必须提供两个位置指标不同。

### `ContinuousAlternatingMap.compContinuousLinearMap`
- **人话**：把交替形式的每个输入都先经过同一个连续线性映射；这是微分形式拉回的点态操作。
- **出处**：`Mathlib/Analysis/Normed/Module/Alternating/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`。
- **坑**：真正的拉回还要在每一点代入映射的导数，而不只是复合底层函数。

### `extDeriv`
- **人话**：对赋范空间上的微分形式作外微分，把 `k`-形式变成 `k+1`-形式。
- **出处**：`Mathlib/Analysis/Calculus/DifferentialForm/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`，已包装为 `exteriorDerivative`。
- **坑**：定义采用 Fréchet 导数后交替化；不同教材可能在归一化系数上使用另一约定。

### `extDeriv_add`
- **人话**：外微分保持形式的加法。
- **出处**：`Mathlib/Analysis/Calculus/DifferentialForm/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`。
- **坑**：点态版本需要两个形式在该点可微。

### `extDeriv_smul`
- **人话**：外微分与常数数乘交换。
- **出处**：`Mathlib/Analysis/Calculus/DifferentialForm/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`。
- **坑**：这里的系数是常数；函数系数对应 Leibniz 法则，不能直接套用。

### `extDeriv_constOfIsEmpty`
- **人话**：函数视为零次形式时，其外微分就是函数的 Fréchet 微分对应的一次形式。
- **出处**：`Mathlib/Analysis/Calculus/DifferentialForm/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`。
- **坑**：零次形式用空指标集编码，需通过 `constOfIsEmpty` 与普通函数连接。

### `extDeriv_extDeriv`
- **人话**：充分光滑的微分形式满足 `d(dω)=0`。
- **出处**：`Mathlib/Analysis/Calculus/DifferentialForm/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`，已转成 `exteriorDerivative_squared_zero`。
- **坑**：证明依赖二阶导数对称性，因此需要至少二阶光滑性。

### `extDeriv_pullback`
- **人话**：外微分与光滑映射的拉回交换，即 `d(f*ω)=f*(dω)`。
- **出处**：`Mathlib/Analysis/Calculus/DifferentialForm/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`。
- **坑**：映射需要足够光滑，形式也必须在像点可微。

### `extDeriv_apply`
- **人话**：外微分在一组方向上的值等于逐项删去一个方向、沿该方向求导并乘
  `(-1)^i` 后的总和。
- **出处**：`Mathlib/Analysis/Calculus/DifferentialForm/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`，用于公开教材计算公式。
- **坑**：Lean 的 `Fin` 从零编号，所以第一项符号对应 `i=0`；与从一编号教材比较时要平移。

### `AlternatingMap.domCoprod`
- **人话**：对两个交替多重线性映射按全部 shuffle 作带符号求和，得到取值于两个陪域张量积的交替映射。
- **出处**：`Mathlib/LinearAlgebra/Alternating/DomCoprod.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`，用于形式楔积的代数核心。
- **坑**：指标先变成和类型 `Fin k ⊕ Fin l`，值先落入 `ℝ ⊗[ℝ] ℝ`；还需分别重新编号和收缩。

### `AlternatingMap.domCoprod'`
- **人话**：把 `domCoprod` 打包成从两个交替映射的张量积出发的线性映射，因此可直接推出楔积对两个变量的加法性。
- **出处**：`Mathlib/LinearAlgebra/Alternating/DomCoprod.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`，用于证明楔积左右可加及零元性质。
- **坑**：它表达的是双线性化后的代数构造，不会自动给出连续交替映射所需的范数界。

### `AlternatingMap.mkContinuous`
- **人话**：若一个代数交替多重线性映射满足统一的“常数乘各输入范数之积”估计，就把它连同该估计打包成连续交替映射。
- **出处**：`Mathlib/Analysis/Normed/Module/Alternating/Basic.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`，用于把有限 shuffle 和恢复为真正的连续形式楔积。
- **坑**：构造器不会生成范数估计；必须先显式证明每个输入组上的乘积界。

### `LinearMap.mk₂`
- **人话**：由一个对左右变量分别满足加法和数乘规律的二元运算，构造柯里化双线性映射。
- **出处**：mathlib 线性映射双线性接口。
- **谁在用**：`analysis.multivariable.differential-forms`，用于楔积的代数双线性封装。
- **坑**：只提供代数结构，不包含连续性。

### `LinearMap.mkContinuous₂`
- **人话**：由 `‖f x y‖ ≤ C‖x‖‖y‖` 将双线性映射升级为连续双线性算子。
- **出处**：`Mathlib/Analysis/Normed/Operator/Bilinear.lean`。
- **谁在用**：`analysis.multivariable.differential-forms`，用于构造 `wedgeContinuousBilinear`。
- **坑**：后续求导时需统一连续交替映射的半范数与范数实例。

## 定向、第二型积分与经典积分公式

### `Orientation` / `Orientation.map`
- **出处**：`Mathlib/LinearAlgebra/Orientation.lean`。
- **人话**：把非零顶次交替形式的正射线作为定向，并让线性同构搬运定向。
- **谁在用**：`topology.orientation.vector-space`；分析层据此定义正向线性重参数化。
- **坑**：这是向量空间的线性定向，不是一般流形的定向图册或可定向性。

### `Orientation.map_eq_iff_det_pos` / `Orientation.map_eq_neg_iff_det_neg`
- **出处**：`Mathlib/LinearAlgebra/Orientation.lean`。
- **人话**：维数与顶次指标匹配时，保向等价于行列式为正，反向等价于行列式为负。
- **谁在用**：`topology.orientation.vector-space` 与微分形式的正向重参数化判据。
- **坑**：必须显式提供指标基数与空间维数相等的证明。

### `AlternatingMap.map_smul_univ`
- **人话**：多重线性映射的每个输入分别数乘后，总因子等于所有标量之积。
- **出处**：`Mathlib/LinearAlgebra/Alternating/Basic.lean`。
- **谁在用**：`analysis.multivariable.second-kind-integrals` 的换参数密度公式。

### `intervalIntegral.integral_deriv_eq_sub`
- **人话**：可积导数在有向区间上的积分等于函数的终值减初值。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean`。
- **谁在用**：`analysis.multivariable.second-kind-integrals` 的恰当 1-形式端点公式；
  `analysis.multivariable.green-gauss-stokes` 对双正常域的每条水平、竖直截面使用该公式。

### `MeasureTheory.integral_biUnion_finset`
- **人话**：有限个两两不交可测集合上的积分之和，等于它们并集上的积分。
- **出处**：`Mathlib/MeasureTheory/Integral/Bochner/Set.lean`。
- **谁在用**：`analysis.multivariable.green-gauss-stokes` 的有限分片 Green 拼接定理。
- **坑**：闭分片通常共享边界，应用前要利用边界零测性改成互不相交的半开分片，
  或明确把公共边只分配给其中一片。

### `intervalIntegral.integral_comp_mul_deriv_of_deriv_nonpos`
- **人话**：导数非正的参数替换仍满足有向积分换元，端点次序会自动反转。
- **出处**：`Mathlib/MeasureTheory/Integral/IntervalIntegral/IntegrationByParts.lean`。
- **谁在用**：`analysis.multivariable.second-kind-integrals` 的曲线反向变号公式。

### `HasDerivAt.const_sub`
- **人话**：若 `f'=c`，则常数减函数的导数为 `-c`。
- **出处**：`Mathlib/Analysis/Calculus/Deriv/Add.lean`。
- **谁在用**：反向仿射参数 `t ↦ a+b-t` 的导数计算。

### `MeasureTheory.integral_add`
- **人话**：两个 Bochner 可积函数之和的积分等于积分之和。
- **出处**：`Mathlib/MeasureTheory/Integral/Bochner/Basic.lean`。
- **谁在用**：`analysis.multivariable.second-kind-integrals` 的曲面积分线性。
- **坑**：必须提供两项可积性，不能对默认零值的不可积积分无条件使用。

### `MeasureTheory.integral2_divergence_prod_of_hasFDerivAt`
- **人话**：平面矩形内部的散度二重积分等于四条边上的外向通量之和。
- **出处**：`Mathlib/MeasureTheory/Integral/DivergenceTheorem.lean`。
- **谁在用**：`analysis.multivariable.green-gauss-stokes`；对旋转场 `(Q,-P)` 使用后得到 Green 公式。

### `MeasureTheory.integral_divergence_of_hasFDerivAt_off_countable`
- **人话**：有限维实坐标盒内的散度积分等于所有相对面的外向通量差之和。
- **出处**：`Mathlib/MeasureTheory/Integral/DivergenceTheorem.lean`。
- **谁在用**：`analysis.multivariable.green-gauss-stokes` 的三维盒 Gauss 公式。
- **坑**：空间维数写成 `Fin (n+1)`；三维实例化时取 `n=2`，每个面使用 `Fin 2` 参数。

### `HasFDerivAt.neg`
- **人话**：函数取负后，Fréchet 导数也取负。
- **出处**：Mathlib Fréchet 导数的加法群运算接口。
- **谁在用**：Green 公式中从 `P` 转到 `-P`。

## 内积空间、正交化与伴随

### `abs_real_inner_le_norm`
- **人话**：实内积的绝对值不超过两向量范数之积，即 Cauchy–Schwarz 不等式。
- **谁在用**：`linear-algebra.inner-product` 的教材不等式接口。

### `InnerProductSpace.gramSchmidtNormed_orthonormal`
- **人话**：线性无关有限向量组经归一化 Gram–Schmidt 后成为标准正交组。
- **谁在用**：`linear-algebra.inner-product` 的标准正交基构造。
- **坑**：保持张成空间还需配合 `span_gramSchmidtNormed_range` 与
  `span_gramSchmidt`，归一化结论本身不包含张成性。

### `Submodule.starProjection`
- **人话**：把向量正交投影到一个具有正交投影的闭子空间；有限维子空间自动满足条件。
- **谁在用**：`linear-algebra.inner-product` 的有限向量组唯一正交分解。
- **坑**：这是证明内部接口；公开教材定理不暴露 `Submodule`。

### `LinearMap.adjoint_inner_right`
- **人话**：有限维伴随满足 `⟪x,T*y⟫=⟪Tx,y⟫`，并由此唯一确定。
- **谁在用**：`linear-algebra.inner-product` 的伴随刻画与自伴判据。

## 实谱定理与二次型

### `LinearMap.IsSymmetric.eigenvectorBasis`
- **人话**：有限维自伴算子存在按实特征值排列的标准正交特征基。
- **谁在用**：`linear-algebra.spectral-quadratic` 的实谱定理教材接口。
- **坑**：需要显式给出空间维数等于指标 `n`；返回的是标准正交基，不只是普通基。

### `LinearMap.IsSymmetric.apply_eigenvectorBasis`
- **人话**：上述基的每个向量都满足特征方程，特征值是实数。
- **谁在用**：谱定理的逐基向量特征方程与二次型对角公式。

### `QuadraticForm.equivalent_one_zero_neg_one_weighted_sum_squared`
- **人话**：任意有限维实二次型经可逆线性换基后成为系数为 `-1,0,1` 的平方和。
- **谁在用**：`linear-algebra.spectral-quadratic` 的 Sylvester 标准形存在性。

### `QuadraticForm.sigPos_of_equiv_weightedSumSquares`
- **人话**：任何等价加权平方和中正权重的个数等于原二次型的正惯性指数。
- **谁在用**：Sylvester 惯性定律的唯一性；负指数使用对应的 `sigNeg` 版本。

## 对偶基、张量积基与外幂维数

### `Module.Basis.dualBasis`
- **人话**：有限基诱导对偶空间的一组基，并满足坐标泛函的 Kronecker 配对公式。
- **谁在用**：`linear-algebra.tensor-exterior` 的对偶基存在性。

### `Module.Basis.tensorProduct`
- **人话**：两组基的所有逐对纯张量构成张量积的一组基。
- **谁在用**：`linear-algebra.tensor-exterior` 的张量积基定理。

### `exteriorPower.finrank_eq`
- **人话**：有限维空间的 `k` 次外幂维数等于 `Nat.choose n k`。
- **谁在用**：`linear-algebra.tensor-exterior` 的外幂分次维数公式。

## 正交矩阵与酉矩阵

### `Matrix.mem_unitaryGroup_iff`
- **人话**：方阵属于酉群当且仅当它与共轭转置的乘积为单位阵。
- **谁在用**：`linear-algebra.matrix.orthogonal-unitary` 的教材定义桥。

### `Matrix.mem_orthogonalGroup_iff`
- **人话**：实方阵属于正交群当且仅当它与转置的乘积为单位阵。
- **谁在用**：正交矩阵教材定义桥。

### `Matrix.det_of_mem_unitary`
- **人话**：酉矩阵的行列式是酉标量；复数情形即模长为一。
- **谁在用**：酉矩阵及实正交矩阵的行列式结论。

### `Unitary.star_mem`
- **人话**：酉元素取星后仍是酉元素；矩阵的星就是共轭转置。
- **谁在用**：酉矩阵的共轭转置封闭性。

## 正规与 Hermitian 矩阵

### `Matrix.IsHermitian.spectral_theorem`
- **人话**：有限 Hermitian 方阵可由酉矩阵对角化，且对角元来自实特征值。
- **谁在用**：`linear-algebra.matrix.normal` 的 Hermitian 酉对角化。

### `Matrix.IsHermitian.eigenvectorUnitary`
- **人话**：Hermitian 方阵的标准正交特征向量组成一个酉矩阵。
- **谁在用**：酉对角化中换基矩阵的构造。

### `Matrix.conjTranspose_add`
- **人话**：共轭转置保持矩阵加法。
- **谁在用**：Hermitian 部分 `(A+Aᴴ)/2` 的验证。

### `Matrix.conjTranspose_sub`
- **人话**：共轭转置保持矩阵减法。
- **谁在用**：斜 Hermitian 部分 `(A-Aᴴ)/2` 的验证。

## 辛矩阵与辛群

### `Matrix.J`
- **人话**：分块矩阵 `[[0,-I],[I,0]]`，即标准辛形式的矩阵。
- **谁在用**：`linear-algebra.matrix.symplectic` 的标准辛矩阵。

### `Matrix.symplecticGroup`
- **人话**：保持标准辛形式的方阵组成的乘法群。
- **谁在用**：辛矩阵教材定义的群运算封闭性。

### `SymplecticGroup.det_eq_one`
- **人话**：交换环上的辛矩阵行列式等于一。
- **谁在用**：实辛矩阵的行列式定理。

## 循环群与元素阶

### `Subgroup.zpowers`
- **人话**：元素 `g` 的所有整数次幂组成的循环子群 `⟨g⟩`。
- **谁在用**：`abstract-algebra.group.cyclic` 的循环子群定义。

### `Subgroup.mem_zpowers_iff`
- **人话**：`x ∈ ⟨g⟩` 当且仅当存在整数 `n` 使 `gⁿ=x`。
- **谁在用**：循环子群的教材元素刻画。

### `Nat.card_zpowers`
- **人话**：循环子群 `⟨g⟩` 的基数等于元素 g 的阶。
- **谁在用**：循环子群阶公式。

### `isCyclic_iff_exists_zpowers_eq_top`
- **人话**：群是循环群当且仅当某个元素生成顶子群，即生成整个群。
- **谁在用**：循环群的生成元判据。

### `Subgroup.le_zpowers_iff`
- **人话**：`⟨g⟩` 的每个子群都形如 `⟨gⁿ⟩`。
- **谁在用**：循环群子群分类的存在性陈述。

### `zpowers_eq_top_of_prime_card`
- **人话**：素数阶群中任意非单位元生成整个群。
- **谁在用**：素数阶群为循环群的经典结论。

### `zmodMulEquivOfGenerator`
- **人话**：给定阶为 n 的循环群及指定生成元 g，构造
  `Multiplicative (ZMod n) ≃* G`，并把 `1 mod n` 送到 g。
- **谁在用**：`abstract-algebra.group.cyclic` 的指定生成元分类同构。

### `zmodCyclicMulEquiv`
- **人话**：不指定生成元时，任意循环群与 `Multiplicative (ZMod (Nat.card G))` 同构。
- **谁在用**：循环群的统一分类；`Nat.card G=0` 时同时覆盖无限循环群。

### `mulEquivOfCyclicCardEq`
- **人话**：两个基数相同的循环群彼此同构。
- **谁在用**：有限循环群由群阶唯一决定的教材结论。

## 群的高阶同构定理

### `QuotientGroup.quotientInfEquivProdNormalQuotient`
- **人话**：若 `N` 正规，给出 `H/(H∩N) ≃ (H∨N)/N` 的规范群同构。
- **谁在用**：`abstract-algebra.group.iso-theorems` 的第二同构定理。

### `QuotientGroup.quotientQuotientEquivQuotient`
- **人话**：若 `N ≤ M` 且二者正规，给出 `(G/N)/(M/N) ≃ G/M`。
- **谁在用**：`abstract-algebra.group.iso-theorems` 的第三同构定理。

### `QuotientGroup.comapMk'OrderIso`
- **人话**：以商映射原像构造 `G/N` 子群与包含 `N` 的 `G` 子群之间的保序同构。
- **谁在用**：`abstract-algebra.group.iso-theorems` 的对应定理。

## 群的自同构与内自同构

### `MulAut`
- **人话**：一个群到自身的乘法同构；这些自同构在复合下组成 `Aut(G)`。
- **谁在用**：`abstract-algebra.group.automorphism` 的自同构群定义。

### `MulAut.conj`
- **人话**：把 `g` 送到共轭自同构 `x ↦ gxg⁻¹` 的群同态 `G → Aut(G)`。
- **谁在用**：内自同构群、共轭同态的核与中心。

### `Subgroup.center`
- **人话**：由所有与群中每个元素交换的元素组成的中心子群 `Z(G)`。
- **谁在用**：`ker(conj)=Z(G)` 与 `G/Z(G) ≅ Inn(G)`。

### `QuotientGroup.quotientMulEquivOfEq`
- **人话**：相等的正规子群给出对应商群之间的规范同构。
- **谁在用**：把第一同构定理中的 `G/ker(conj)` 改写为 `G/Z(G)`。

## 群的直积与半直积

### `MulEquiv.prodComm`
- **人话**：交换两个直积因子得到规范群同构。
- **谁在用**：`abstract-algebra.group.product` 的直积交换律。

### `MulEquiv.prodAssoc`
- **人话**：给出三个群直积的规范结合群同构。
- **谁在用**：`abstract-algebra.group.product` 的直积结合律。

### `MonoidHom.noncommCoprod`
- **人话**：当两个同态的值逐元素交换时，坐标乘法定义从直积出发的同态。
- **谁在用**：`abstract-algebra.group.product` 的内部直积同构。

### `SemidirectProduct.mulEquivProd`
- **人话**：平凡作用形成的半直积同构于通常直积。
- **谁在用**：`abstract-algebra.group.product` 的平凡作用退化公式。

### `SemidirectProduct.mulEquivSubgroup`
- **人话**：正规互补子群按共轭作用形成的半直积同构于环境群。
- **谁在用**：`abstract-algebra.group.product` 的内部半直积定理。

## 群作用、轨道与稳定子

### `MulAction.orbit`
- **人话**：点 `x` 在群作用下所有像 `g • x` 组成的轨道。
- **谁在用**：`abstract-algebra.group.action` 的轨道定义与轨道分割。

### `MulAction.stabilizer`
- **人话**：所有满足 `g • x = x` 的群元素组成的稳定子群。
- **谁在用**：稳定子成员刻画和轨道—稳定子定理。

### `MulAction.orbitEquivQuotientStabilizer`
- **人话**：轨道与稳定子陪集空间 `G/Gₓ` 之间的规范集合等价。
- **谁在用**：轨道—稳定子定理的结构形式。

### `MulAction.orbitProdStabilizerEquivGroup`
- **人话**：轨道与稳定子的笛卡尔积作为集合等价于作用群。
- **谁在用**：`|Orb(x)|·|Gₓ|=|G|` 的基数公式。

### `MulAction.stabilizerEquivStabilizerOfOrbitRel`
- **人话**：同一轨道中两点的稳定子群同构。
- **谁在用**：同轨稳定子不变量。

### `Group.nat_card_center_add_sum_card_noncenter_eq_card`
- **人话**：有限群阶等于中心阶加所有非中心共轭类大小之和。
- **谁在用**：`abstract-algebra.group.action` 的类方程。

## 置换群、循环与奇偶性

### `Equiv.Perm.subgroupOfMulAction`
- **人话**：忠实群作用把作用群同构到相应置换表示的值域子群；正则作用给出 Cayley 定理。
- **谁在用**：`abstract-algebra.group.permutation` 的 Cayley 同构。

### `Equiv.Perm.cycleFactorsFinset`
- **人话**：有限置换的规范互不相交循环因子有限集。
- **谁在用**：循环因子性质与循环乘积恢复原置换。

### `Equiv.Perm.truncSwapFactors`
- **人话**：有限置换存在换位列表分解，不依赖底集上的线性次序选择。
- **谁在用**：换位分解存在性。

### `Equiv.Perm.sign`
- **人话**：置换符号同态 `Sym(X) → {±1}`，区分偶置换和奇置换。
- **谁在用**：符号乘法性、换位为奇置换及交错群。

### `alternatingGroup`
- **人话**：符号同态的核，即所有偶置换组成的交错群。
- **谁在用**：交错群成员判据、指数二与 `n!/2` 阶公式。

## Cauchy 与 Sylow 理论

### `IsPGroup`
- **人话**：Mathlib 对“群中每个元素都被某个 `p` 的幂次消去”的底层表示。
- **谁在用**：仅用于证明本库 `IsPrimePowerGroup` 与底层实现定义等价；公开教材签名使用本库定义。

### `Sylow`
- **人话**：Mathlib 将极大 `p`-子群打包成结构的底层表示。
- **谁在用**：仅用于本库 `SylowSubgroup` 的私有等价桥和后续证明；公开教材签名使用本库定义。

### `exists_prime_orderOf_dvd_card'`
- **人话**：素数 `p` 整除有限群阶时，存在阶为 `p` 的元素。
- **谁在用**：`abstract-algebra.group.sylow` 的 Cauchy 定理。

### `IsPGroup.exists_le_sylow`
- **人话**：每个 `p`-子群都包含在某个极大 `p`-子群中。
- **谁在用**：Sylow 第一定理的包含形式。

### `Sylow.card_eq_multiplicity`
- **人话**：Sylow `p`-子群阶为 `p ^ v_p(|G|)`。
- **谁在用**：Sylow 第一定理的群阶公式。

### `Sylow.isPretransitive_of_finite`
- **人话**：群对 Sylow `p`-子群的共轭作用是传递的。
- **谁在用**：Sylow 第二定理。

### `card_sylow_modEq_one`
- **人话**：Sylow `p`-子群个数模 `p` 余一。
- **谁在用**：Sylow 第三定理的同余条件。

### `Sylow.card_dvd_index`
- **人话**：Sylow `p`-子群个数整除任一 Sylow 子群的指数。
- **谁在用**：Sylow 第三定理的整除条件。

## 有限生成交换群结构

### `Group.fg_iff`
- **人话**：Mathlib 的有限生成群类等价于存在有限生成集合。
- **谁在用**：仅用于本库 `IsFinitelyGeneratedGroup` 与底层实现的定义桥。

### `CommGroup.equiv_free_prod_prod_multiplicative_zmod`
- **人话**：有限生成交换群分解为有限秩自由交换群与素数幂阶循环群的有限直积。
- **谁在用**：`finitely_generated_abelian_structure`；公开前提使用本库有限生成定义。

### `AddCommGroup.equiv_directSum_zmod_of_finite`
- **人话**：有限交换群的加法版本可分解为有限多个素数幂阶 `ZMod` 的直和。
- **谁在用**：`finite_abelian_prime_power_structure`，证明内部转回乘法群直积语言。

### `CommGroup.equiv_prod_multiplicative_zmod_of_finite`
- **人话**：有限交换群同构于有限多个非平凡有限循环群的直积。
- **谁在用**：`finite_abelian_cyclic_structure` 及双向分类的正向。

## 初等数论：整除与素因子分解

### `Nat.mod_add_div`
- **人话**：自然数先取余数，再加上除数乘商，可以恢复原数。
- **出处**：Mathlib 的自然数 Euclidean 除法接口。
- **谁在用**：`number-theory.elementary.divisibility` 的带余除法。

### `Nat.mod_lt`
- **人话**：除数为正时，余数严格小于除数。
- **出处**：Mathlib 的自然数 Euclidean 除法接口。
- **谁在用**：`number-theory.elementary.divisibility` 的余数范围。

### `Nat.dvd_gcd_iff`
- **人话**：`d` 整除两个自然数，当且仅当 `d` 整除它们的最大公因数。
- **出处**：`Mathlib/Data/Nat/GCD/Basic.lean`。
- **谁在用**：`number-theory.elementary.divisibility` 的最大公因数刻画。

### `Nat.gcd_eq_gcd_ab`
- **人话**：扩展 Euclidean 算法算出的两个整数系数给出 Bézout 等式。
- **出处**：`Mathlib/Data/Int/GCD.lean`。
- **谁在用**：`number-theory.elementary.divisibility` 的 Bézout 等式。

### `Int.gcd_dvd_iff`
- **人话**：两个整数的最大公因数整除自然数 `d`，当且仅当 `d` 可写成这两个整数的线性组合。
- **出处**：`Mathlib/Data/Int/GCD.lean`。
- **谁在用**：互素线性组合判别的反向证明。

### `Nat.Prime.dvd_mul`
- **人话**：素数整除两个自然数的乘积，当且仅当它整除其中至少一个因子。
- **出处**：Mathlib 的自然数素数与最大公因数接口。
- **谁在用**：`number-theory.elementary.divisibility` 的 Euclid 引理。

### `Nat.exists_prime_and_dvd`
- **人话**：不等于 `1` 的自然数存在一个素因子；用于大于 `1` 的教材式版本。
- **出处**：`Mathlib/Data/Nat/Prime/Basic.lean`。
- **谁在用**：`number-theory.elementary.divisibility` 的素因子存在性。

### `Nat.factorization`
- **人话**：把自然数编码为有限支撑的“素数到指数”函数。
- **出处**：`Mathlib/Data/Nat/Factorization/Defs.lean`。
- **谁在用**：`number-theory.elementary.prime-factorization`。

### `Nat.prod_factorization_pow_eq_self`
- **人话**：非零自然数的全部素因子幂相乘会重构原数。
- **出处**：`Mathlib/Data/Nat/Factorization/Defs.lean`。
- **谁在用**：算术基本定理的存在性（重构形式）。

### `Nat.eq_of_factorization_eq`
- **人话**：两个非零自然数的素因子指数逐点相等，则两数相等。
- **出处**：`Mathlib/Data/Nat/Factorization/Defs.lean`。
- **谁在用**：算术基本定理的唯一性。

## 初等数论：同余、中国剩余与 Fermat–Euler

### `ZMod.natCast_eq_natCast_iff`
- **人话**：两个自然数映入 `ZMod n` 后相等，当且仅当它们模 `n` 同余。
- **谁在用**：`number-theory.elementary.congruence` 的同余—剩余环桥。

### `Nat.ModEq.add` / `Nat.ModEq.mul` / `Nat.ModEq.pow`
- **人话**：自然数同余对加法、乘法和自然数次幂保持相容。
- **谁在用**：`number-theory.elementary.congruence` 的运算封闭性。

### `Nat.chineseRemainder`
- **人话**：互素模数下构造满足两个指定余数条件的共同自然数解。
- **谁在用**：中国剩余定理的存在形式。

### `ZMod.chineseRemainder`
- **人话**：互素 `m,n` 下建立 `ZMod (m*n) ≃+* ZMod m × ZMod n`。
- **谁在用**：中国剩余定理的结构形式。

### `ZMod.card_units_eq_totient`
- **人话**：`ZMod n` 的单位群基数等于 Euler φ 函数值。
- **谁在用**：`number-theory.elementary.totient`。

### `Nat.ModEq.pow_totient`
- **人话**：与模数互素的自然数，其 `φ(n)` 次幂模 `n` 余一。
- **谁在用**：Euler 定理。

### `Nat.totient_prime`
- **人话**：素数 `p` 满足 `φ(p)=p-1`。
- **谁在用**：由 Euler 定理推出 Fermat 小定理的既约形式。

### `Nat.modEq_zero_iff_dvd`
- **人话**：`a ≡ 0 (mod p)` 当且仅当 `p ∣ a`。
- **谁在用**：Fermat 小定理无条件形式的整除分支。

## 初等数论：素数、Diophantine 方程与勾股数

### `Nat.prime_def_le_sqrt` / `Nat.not_prime_iff_exists_dvd_lt`
- **人话**：用平方根界内的试除刻画素数，并在合数情形给出有限范围内的真因子证书。
- **谁在用**：`number-theory.elementary.prime-tests`。

### `Nat.minFac_prime` / `Nat.minFac_dvd` / `Nat.Prime.dvd_factorial`
- **人话**：最小素因子确为素数且整除原数；不超过 `n` 的素数整除 `n!`。
- **谁在用**：`number-theory.elementary.infinite-primes` 的 Euclid 构造。

### `Set.infinite_of_not_bddAbove`
- **人话**：自然数集合若没有上界，则该集合无限。
- **谁在用**：把“任意界之上都有素数”转成素数集合无限。

### `Int.gcd_eq_gcd_ab` / `Int.gcd_dvd_left` / `Int.gcd_dvd_right`
- **人话**：扩展 Euclidean 算法给出 Bézout 系数，且 gcd 整除两个输入。
- **谁在用**：`number-theory.elementary.linear-diophantine` 的可解判据和显式解。

### `PythagoreanTriple.coprime_classification'` / `PythagoreanTriple.classification`
- **人话**：分别分类规范化的本原勾股三元组和带符号、交换及公因子的整数勾股三元组。
- **谁在用**：`number-theory.elementary.pythagorean-triples`；公开概念使用本库谓词。

## 初等数论：二次剩余与互反律

### `legendreSym.eq_one_iff` / `legendreSym.eq_neg_one_iff` / `isSquare_iff_exists_sq`
- **人话**：Legendre 符号的正负值分别对应非零二次剩余和非剩余，并桥接显式平方证书。
- **谁在用**：`number-theory.elementary.quadratic-residues`。

### `ZMod.euler_criterion` / `ZMod.gauss_lemma`
- **人话**：分别以幂同余和上半区代表元计数的奇偶性计算 Legendre 符号。
- **谁在用**：Euler 判别法和 Gauss 引理的教材接口。

### `neg_one_pow_eq_one_iff_even` / `neg_one_pow_eq_neg_one_iff_odd`
- **人话**：`(-1)^n` 的正负号分别精确刻画指数 `n` 的偶性与奇性。
- **谁在用**：把 Gauss 上半区计数的符号等式改写成本库二次剩余／非剩余奇偶判据。

### `jacobiSym.legendreSym.to_jacobiSym` / `jacobiSym.mul_left` / `jacobiSym.at_two` / `χ₈`
- **人话**：把素模 Legendre 符号送入 Jacobi 符号，给出分子乘法性及分子为二的补充律。
- **谁在用**：Jacobi 符号接口及“Jacobi 等于一未必是平方”的合数模反例。

### `jacobiSym.eq_one_or_neg_one`
- **人话**：分子与奇分母互素时，Jacobi 符号只能取 `1` 或 `-1`。
- **谁在用**：本库 Jacobi 平方律与合数模反例的符号分类。

### `legendreSym.quadratic_reciprocity` / `legendreSym.sq_one`
- **人话**：给出 Legendre 二次互反律和非零符号平方为一。
- **谁在用**：`number-theory.elementary.quadratic-reciprocity` 的乘积式、等式式和模四特化。

### `prime_ne_zero` / `legendreSym.eq_zero_iff`
- **人话**：素数非零；Legendre 符号为零当且仅当分母素数整除分子。
- **谁在用**：排除互异素数交换时的零符号分支，使互反律能从乘积式转成等式式。

### `neg_one_pow_div_two_of_one_mod_four` / `neg_one_pow_div_two_of_three_mod_four`
- **人话**：奇数模 `4` 余 `1` 或 `3` 时，`(-1)^((n-1)/2)` 分别化简为 `1` 或 `-1`。
- **谁在用**：Legendre 与 Jacobi 互反律的两个模四特化。

### `jacobiSym.quadratic_reciprocity`
- **人话**：奇正合数参数下的 Jacobi 二次互反律。
- **谁在用**：二次互反律的 Jacobi 推广。

## 初等数论：连分数与 Pell 方程

### `Real.convergent` / `Real.convergent_zero` / `Real.convergent_succ`
- **人话**：实数简单连分数收敛子的定义、零阶值和递归公式。
- **谁在用**：连分数收敛子定义及递归条目；Mathlib 对象只作为实现承载。

### `Int.fract`
- **人话**：实数减去其整数部分所得的小数部分，是简单连分数递归尾项的输入。
- **谁在用**：`number-theory.elementary.continued-fraction-recursion` 的误差量与递归解释。

### `Finset.exists_min_image`
- **人话**：非空有限候选集上，取值函数可以达到最小值。
- **谁在用**：`number-theory.elementary.finite-best-approximation`。

### `Real.exists_rat_eq_convergent`
- **人话**：满足 Legendre 误差界的有理数是给定实数的某个连分数收敛子。
- **谁在用**：`number-theory.elementary.legendre-criterion`。

### `Pell.Solution₁.exists_pos_of_not_isSquare` / `Pell.Solution₁.prop`
- **人话**：正非平方参数存在正 Pell 解，Mathlib 解对象满足对应 Pell 恒等式。
- **谁在用**：本库坐标式 Pell 正解存在定理的私有桥。

### `Pell.IsFundamental` / `Pell.IsFundamental.exists_of_not_isSquare`
- **人话**：Mathlib 的基本 Pell 解谓词及其存在定理。
- **谁在用**：`number-theory.elementary.pell-fundamental-solution` 的最小正解证明后端。

### `Pell.Solution₁.mk` / `Pell.Solution₁.x_mk`
- **人话**：由坐标和方程证书构造 Mathlib Pell 解，并读取第一坐标。
- **谁在用**：本库坐标接口与 Mathlib 基本解接口之间的私有桥。

## 序数理论

### `Ordinal.type_eq`
- **人话**：两个良序的序型相等，当且仅当两个关系之间存在序同构。
- **谁在用**：`settheory.ordinal.order-type`。

### `Ordinal.type_nat_lt`
- **人话**：自然数通常严格序的序型是最小无限序数 `ω`。
- **谁在用**：`settheory.ordinal.order-type`。

### `Ordinal.type`
- **人话**：把一个良序关系取为其序型；本库由具体良序构造序数运算时使用。
- **谁在用**：`settheory.ordinal.addition`、`settheory.ordinal.multiplication` 的私有正确性桥。

### `Ordinal.type_sum_lex`
- **人话**：不交并上的字典序序型等于原生序数加法。
- **谁在用**：验证本库以 `Sum.Lex` 定义的 `ordinalAdd`；原生 `+` 不是公开定义。

### `Ordinal.type_prod_lex`
- **人话**：直积上的字典序序型等于原生序数乘法。
- **谁在用**：验证本库以 `Prod.Lex` 定义的 `ordinalMul`；原生 `*` 不是公开定义。

### `WellFoundedLT.induction`
- **人话**：在线性严格序的良基实例上执行良基归纳；对序数即超限归纳。
- **谁在用**：`settheory.ordinal.transfinite-induction`。

### `Ordinal.limitRecOn`
- **人话**：按零、后继和非零极限三个分支定义序数上的递归对象。
- **谁在用**：`settheory.ordinal.transfinite-recursion`。

### `Ordinal.add_omega0`
- **人话**：任何小于 `ω` 的序数加在 `ω` 左边都会被吸收。
- **谁在用**：`settheory.ordinal.addition`。

### `Order.lt_succ`
- **人话**：任意无最大元后继序中的元素都严格小于自己的后继。
- **谁在用**：`settheory.ordinal.addition`、`settheory.ordinal.successor-limit`。

### `Ordinal.natCast_mul_omega0`
- **人话**：任意正自然数对应的有限序数左乘 `ω` 仍等于 `ω`。
- **谁在用**：`settheory.ordinal.multiplication`。

### `Ordinal.mul_two`
- **人话**：序数右乘二等于它与自身的序数和。
- **谁在用**：`settheory.ordinal.multiplication`。

### `Ordinal.mul_succ`
- **人话**：原生序数乘法在右侧后继处按加法递推。
- **谁在用**：验证本库 `ordinalMul_succ`，其公开右端调用本库 `ordinalAdd`。

### `Ordinal.opow_succ`
- **人话**：序数幂在后继指数处满足 `a^(b+1)=a^b·a`。
- **谁在用**：`settheory.ordinal.exponentiation`。

### `Ordinal.opow_limit`
- **人话**：非零底数的原生序数幂在极限指数处等于此前各值的上确界。
- **谁在用**：验证本库由 `Ordinal.limitRecOn` 定义的 `ordinalPow`。

### `Ordinal.opow_lt_opow_iff_right`
- **人话**：底数严格大于一时，序数幂的严格大小等价于指数的严格大小。
- **谁在用**：`settheory.ordinal.power-bridge`，把 Mathlib 原生比较转回本库 `ordinalPow` 接口。

### `Order.lt_succ_iff`
- **人话**：在线性后继序中，`a < succ b` 当且仅当 `a ≤ b`。
- **谁在用**：`settheory.ordinal.successor-limit`。

### `Ordinal.isSuccLimit_omega0`
- **人话**：`ω` 是非零极限序数。
- **谁在用**：`settheory.ordinal.successor-limit`。

### `Ordinal.lt_iSup_iff`
- **人话**：序数严格小于一个小指标族的上确界，当且仅当严格小于其中某项。
- **谁在用**：`settheory.ordinal.supremum`。

### `Order.cof`
- **人话**：一个良序类型的最小共尾子集基数。
- **谁在用**：本库 `ordinalCofinality` 的公开定义。

### `Ordinal.cof_toType`
- **人话**：序数规范良序载体的共尾数等于 Mathlib 原生 `Ordinal.cof`。
- **谁在用**：本库共尾数定义到实现层的私有桥。

### `Ordinal.cof_zero`
- **人话**：零序数的共尾数是零。
- **谁在用**：`settheory.ordinal.cofinality`。

### `Ordinal.cof_add_one`
- **人话**：任意后继序数的共尾数是一。
- **谁在用**：`settheory.ordinal.cofinality`。

### `Ordinal.cof_omega0`
- **人话**：首个无限序数 `ω` 的共尾数是可数无限基数 `ℵ₀`。
- **谁在用**：`settheory.ordinal.cofinality`。

### `Ordinal.isNormal_opow`
- **人话**：底数大于一时，序数幂关于指数是严格递增且保持极限的正规函数。
- **谁在用**：`settheory.ordinal.normal-function`。

### `Ordinal.CNF.foldr`
- **人话**：按幂、系数和余项求值 Cantor 正规形会还原原序数。
- **谁在用**：`settheory.ordinal.cantor-normal-form`。

### `Ordinal.omega0_opow_epsilon`
- **人话**：每个 epsilon 数都是函数 `α ↦ ω^α` 的不动点。
- **谁在用**：`settheory.ordinal.epsilon-zero`。

### `Ordinal.epsilon_zero_le_of_omega0_opow_le`
- **人话**：若 `ω^α ≤ α`，则首个 epsilon 数 `ε₀` 不大于 `α`。
- **谁在用**：`settheory.ordinal.epsilon-zero`。

### `Ordinal.lt_wf`
- **人话**：序数的严格小于关系是良基关系，不存在无限严格下降。
- **谁在用**：`settheory.ordinal.no-infinite-descent`。

## 基数理论、递归层级与可计算性

### `Embedding.schroeder_bernstein` / `Equiv.ofBijective`
- **人话**：双向嵌入给出等势，并把显式双射包装为等价。
- **谁在用**：`settheory.cardinal.cantor-bernstein` 与基数比较闭环；本库的
  `Equinumerous`、`CardinalLE` 仍是公开教材定义。

### `Equiv.sumCongr` / `Equiv.prodCongr` / `Equiv.arrowCongr`
- **人话**：等价可分别提升到不交并、直积和函数空间。
- **谁在用**：三种教材基数算术的等势保持证明。

### `Cardinal.aleph` / `Cardinal.aleph_zero` / `Cardinal.succ_aleph`
- **人话**：Mathlib 的 aleph 层级、首项和后继递推。
- **谁在用**：`settheory.cardinal.aleph-hierarchy` 的实现承载与证明后端。

### `Cardinal.beth` / `Cardinal.beth_zero` / `Cardinal.beth_succ` / `Cardinal.beth_one`
- **人话**：beth 层级及其零、后继和第一项公式。
- **谁在用**：beth 层级和连续统假设的本库接口。

### `Cardinal.two_power_aleph0`
- **人话**：实数连续统的基数等于二的可数无限次幂。
- **谁在用**：`settheory.cardinal.continuum-hypothesis` 的准确命题桥。

### `Cardinal.ord` / `Ordinal.cof_ord_le` / `Cardinal.isRegular_aleph0`
- **人话**：取基数的初始序数、其共尾性上界，以及 `ℵ₀` 的正则性。
- **谁在用**：基数共尾性与正则／奇异分类入口。

### `Cardinal.sum_lt_prod` / `Cardinal.lt_power_cof_ord`
- **人话**：König 型基数和小于基数积，以及共尾性控制的幂严格不等式。
- **谁在用**：`settheory.cardinal.konig-theorem`。

### `Classical.choice` / `WellOrderingRel`
- **人话**：在 Lean 的经典基础中选择见证，并为任意类型取得良序关系。
- **谁在用**：`settheory.cardinal.classical-choice-wellordering`；这里只证明可用性，不冒充
  AC、良序定理与 Zorn 在无选择基础中的双向等价。

### `Nat.rec` / `Nat.hyperoperation` / `Nat.ack`
- **人话**：自然数递归、Mathlib 超运算和 Ackermann 函数的对照实现。
- **谁在用**：本库原始递归、超运算与 Ackermann 计算方程；Mathlib 名称只作对照后端。

### `Finset.range` / `Finset.map` / `Finset.sup` / `Classical.choose`
- **人话**：枚举有限候选、映射候选并取有限上确界，再从经典存在证明中抽取见证。
- **谁在用**：有限燃料 Busy Beaver 候选、经典最大值及最终稳定性。

### `Ordinal.opow_mul_lt_opow` / `Ordinal.opow_mul_add_lt_opow`
- **人话**：有限系数和有限余项仍严格低于下一层 `ω` 幂。
- **谁在用**：Goodstein 的平方／有限幂借位与 Hydra 局部复制下降。

### `Ordinal.natCast_lt_omega0` / `Order.IsNormal.strictMono`
- **人话**：每个有限序数小于 `ω`，正规函数严格保序。
- **谁在用**：嵌套指数 `B^(B¹)` 的 Goodstein 度量下降及 Hydra 脊柱提升。

### `Nat.add_sub_assoc` / `Nat.sub_one_lt` / `Order.lt_succ`
- **人话**：在正数证书下移动减一、证明减一严格变小，并使用后继严格上界。
- **谁在用**：Goodstein 的局部换底减一和显式借位公式。

### `Nat.pair` / `Nat.unpair` / `Nat.unpair_pair`
- **人话**：自然数有序对的显式配对、拆对和恢复定理。
- **谁在用**：`settheory.computability.concrete-pairing-code`；尚未证明由本库 `NatProgram`
  实现。

### `wellFounded_iff_isEmpty_descending_chain`
- **人话**：良基关系等价于不存在自然数长度的无限严格下降链。
- **谁在用**：排除每一步都携带最右脊柱证书的无限 Hydra 轨迹。

### `Nat.strongRec` / `Nat.div_add_mod`
- **人话**：按所有更小自然数作强递归，并用商乘除数加余数还原原数。
- **谁在用**：`settheory.googology.hereditary-natural-encoding` 的商余递归、终止与精确求值。

### `WellFounded.onFun` / `WellFounded.mono` / `WellFounded.induction`
- **人话**：沿秩函数拉回良基关系、限制到子关系，并执行良基归纳。
- **谁在用**：认证 Hydra 步骤子关系的 `WellFounded`、`Acc` 与归纳接口；不覆盖任意
  `Hydra.Step`。

### `add_lt_add_iff_left` / `add_lt_add_right` / `mul_lt_mul_of_pos_left`
- **人话**：在共同左前缀或正左因子下保持严格不等式。
- **谁在用**：Goodstein 与 Hydra 序数赋值的局部下降组装。

### `Nat.cast_lt` / `Ordinal.mul_succ`
- **人话**：把自然数不等式送入序数，并展开序数右乘后继。
- **谁在用**：有限复制森林和有限序数度量计算。

### `hasDerivAt_iff_tendsto_slope` / `DifferentiableAt.hasDerivAt` / `HasDerivAt.tendsto_slope`
- **人话**：在复数域上连接去心差商极限、导数见证与 Fréchet 可微。
- **谁在用**：复分析 C1 的教材复可微定义及其 Mathlib 兼容桥。

### `curveIntegral` / `intervalIntegral.integral_comp_mul_deriv` / `Complex.circleIntegral`
- **人话**：承载复路径积分、有向参数换元与圆周积分公式。
- **谁在用**：复分析 C2 路径积分、Cauchy 公式与 C3 圆周残数 foundation。

### `AnalyticAt.taylorSeries_eq` / `AnalyticAt.sum_taylorSeries` / `HasFPowerSeriesAt.coeff_unique`
- **人话**：解析函数的 Taylor 系数、级数求和与局部系数唯一性。
- **谁在用**：`complex-analysis.series.taylor`；本库仍公开自己的 Taylor 系数与展开接口。

### `MeromorphicAt.order` / `Complex.circleIntegral_sub_center_inv` / `Complex.integral_inv_one_add_sq`
- **人话**：亚纯函数阶、简单极点圆周计算与一个广义实积分后端。
- **谁在用**：C3 奇点分类 foundation、简单极点公式和实积分例题；不代表一般 Laurent 或残数定理已完成。

### `Relation.TransGen` / `WellFounded.transGen`
- **人话**：关系的非空传递闭包及其良基性保持。
- **谁在用**：认证 Hydra 有限多步下降与闭包归纳；不覆盖普通 `Hydra.Step`。

### `Fintype.equivFin` / `Fintype.card`
- **人话**：把固定的有限类型规范地等价到由其基数确定的 `Fin`，并读取有限类型的元素总数。
- **谁在用**：`settheory.computability.binary-machine-coding` 的非可计算有限机器索引桥；不是通用解释器。

### `Nat.mul_div_left` / `Nat.mul_mod_left`
- **人话**：计算自然数幂按底数整除和取余时的商、余数。
- **谁在用**：`settheory.googology.hereditary-natural-power-rank` 的 `q^(k+1)` 商余递推。

### `Convex.exists_forall_hasDerivWithinAt` / `HasDerivWithinAt.comp_hasDerivAt`
- **人话**：在闭凸三角形内构造相对原函数，并沿参数化线段使用链式法则得到端点公式。
- **谁在用**：`complex-analysis.cauchy.triangle` 的一般局部三角形 Cauchy--Goursat 定理。

### `ContinuousMap.Homotopy.curveIntegral_add_curveIntegral_eq_of_hasFDerivWithinAt` / `ContDiffOn`
- **人话**：对具有二阶光滑证书的正方形同伦应用边界积分公式，从而比较两条端点固定道路的积分。
- **谁在用**：`complex-analysis.cauchy.smooth-homotopy-foundation`；不代表普通连续同伦已正则化。

### `HasFDerivWithinAt.curveIntegral_segment_source` / `curveIntegrable_segment`
- **人话**：短线段积分随终点变化的导数等于被积函数，并保证连续函数沿线段可积。
- **谁在用**：由路径积分无关构造原函数，以及开连通域的 admissible 道路可达性。

### `ContinuousLinearMap` / `ContinuousLinearMap.le_opNorm` / `ContinuousLinearMap.opNorm_le_bound`
- **人话**：连续线性算子的正式承载，以及算子范数作为最小全局放大界的两个方向。
- **谁在用**：泛函分析 F1 的连续线性算子、有界等价和算子空间完备性。

### `Summable.of_norm` / `norm_tsum_le_tsum_norm`
- **人话**：Banach 空间中范数级数可和推出向量级数可和，并控制其总和范数。
- **谁在用**：`functional-analysis.series.summable`。

### `QuotientAddGroup.norm_mk` / `Submodule.Quotient.completeSpace`
- **人话**：商范数等于到子空间的距离，闭子空间的 Banach 商保持完备。
- **谁在用**：`functional-analysis.subspace.quotient`。

### `Polynomial` / `Polynomial.Monic` / `divByMonic` / `modByMonic`
- **人话**：以有限支撑系数多项式为正式承载，并提供首一除法的商、余数、次数界和唯一性。
- **谁在用**：`abstract-algebra.poly.def` 与 `abstract-algebra.poly.division`；旧
  `PolynomialSequence` 只作为双向兼容表示保留。

### `EuclideanDomain.mod_add_div` / `Polynomial.degree_mod_lt`
- **人话**：域上多项式满足带余除法恒等式，且非零除式下余数次数严格下降。
- **谁在用**：把正式 `Polynomial K` 组装进本库 A2 Euclidean 算法，得到 gcd 与 Bézout。

### `Metric.isOpen_iff` / `unitInterval` / `Path`
- **人话**：标准实拓扑可用正半径度量球刻画；`unitInterval` 是闭区间
  `[0,1]` 的 subtype；`Path x y` 打包其上的连续轨迹与两个端点。
- **谁在用**：`topology.foundation.real-line`、
  `topology.homotopy.path-definition-foundation` 及 legacy compatibility 桥。

### `ContinuousLinearMap.adjoint` / `ContinuousLinearMap.eq_adjoint_iff`
- **人话**：Hilbert 空间上的伴随是唯一满足内积转移公式的反向有界算子。
- **谁在用**：`functional-analysis.hilbert.adjoint` 与酉算子的“伴随等于逆”性质。

### `HilbertBasis` / `HilbertBasis.hasSum_repr` / `HilbertBasis.tsum_inner_mul_inner`
- **人话**：Hilbert 基同时记录正交规范性、稠密张成、平方可和 Fourier 坐标、
  级数重构和 Parseval 内积恒等式。
- **谁在用**：`functional-analysis.hilbert.orthonormal-basis`。

### `LinearIsometryEquiv` / `LinearIsometryEquiv.adjoint_eq_symm`
- **人话**：线性等距等价同时打包线性、距离保持与双射；在 Hilbert 空间中
  其对应有界算子的伴随等于逆。
- **谁在用**：`functional-analysis.hilbert.unitary`。

## 附：登记清单自动核对

- 登记过的名字在此文件的 `### ` 标题里。
- 快速检查"某个名字有没有登记"：`grep "### \`名字\`" docs/MATHLIB-RADAR.md`。
- 叙述层每条目 front matter 的 `mathlib:` 字段应都能在本文找到锚点。
## 抽象代数：有限中国剩余定理

### `Ideal.exists_forall_sub_mem_ideal`
- **人话**：有限个两两互素理想允许同时选择一个满足所有指定剩余类的环元素。
- **谁在用**：`abstract-algebra.ring.crt` 的有限族规范映射满射证明。
- **本库边界**：只在证明体中把本库集合型理想局部桥接为 Mathlib `Ideal`；公开 CRT 定义与
  同构签名仍使用本库 `TwoSidedIdealSet`、`quotientRingSet` 和 `RingIsomorphism`。
