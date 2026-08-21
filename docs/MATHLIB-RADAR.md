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

### `Set.inter_union_distrib_left`
- **人话**：**交对并分配律**：s ∩ (t ∪ u) = (s ∩ t) ∪ (s ∩ u)。
- **签名**：`(s t u : Set α) : s ∩ (t ∪ u) = s ∩ t ∪ s ∩ u`
- **出处**：`Mathlib/Data/Set/Operations.lean`

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

### `Group` / `Subgroup` / `Subgroup.ext` / `Subgroup.one_mem` / `Subgroup.mul_mem` / `Subgroup.inv_mem` / `Subgroup.mem_bot` / `Subgroup.mem_top`
- **人话**：`Group G` 是群 typeclass（乘法 `*`、单位元 `1`、逆 `⁻¹`）；`Subgroup G` 是子群结构；
  `ext` 子群外延性；子群含单位元/对乘/逆封闭；`⊥` 平凡子群（只含 1）、`⊤` 全子群。
- **签名**：`Subgroup.ext : (∀x, x∈H ↔ x∈K) → H = K`；`Subgroup.one_mem H : 1 ∈ H`；`Subgroup.mem_bot : x∈⊥ ↔ x=1`
- **出处**：`Mathlib/GroupTheory/Subgroup/Basic.lean`
- **谁在用**：`abstract-algebra.group.def`。
- **坑**：`(⊥ : Subgroup G)` 不是 `Set`，与 `{1}` 类型不同，用 `((⊥ : Subgroup G) : Set G) = {1}`。

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

### `Ring` / `Subring` / `Subring.ext` / `Subring.one_mem` / `Subring.zero_mem` / `Subring.mem_bot` / `Subring.mem_top` / `RingHom`
- **人话**：`Ring R` 环 typeclass；`Subring R` 子环结构（含 1）；外延性；子环含 1/0；
  `⊥` 平凡子环（n·1 形式，n:ℤ）、`⊤` 全子环；`RingHom` 环同态（`R →+* S`，保加乘单位元）。
- **签名**：`Subring.ext : (∀x, x∈S ↔ x∈T) → S = T`；`Subring.mem_bot : x∈⊥ ↔ ∃ n:ℤ, ↑n = x`
- **出处**：`Mathlib/RingTheory/Subring/Basic.lean`、`Mathlib/Algebra/Ring/`
- **谁在用**：`abstract-algebra.ring.def`。
- **坑**：`Subring.mem_bot` 的 n 是 ℤ 不是 ℕ。

### `Ideal` / `Ideal.mul_mem_left` / `Ideal.mul_mem_right` / `Ideal.eq_top_of_isUnit_mem` / `Ideal.Quotient.eq` / `Ideal.Quotient.mk` / `RingHom.ker` / `RingHom.range`
- **人话**：`Ideal R` 理想（R 作为自身模的子模）；左/右吸收乘法；含单位元理想 = ⊤；
  商环 `R ⧸ I` 判等 `mk x = mk y ⟺ x-y ∈ I`；环同态核是理想（`RingHom.ker : Ideal R`）、值域是子环。
- **签名**：`Ideal.Quotient.eq : mk x = mk y ↔ x - y ∈ I`；`RingHom.ker f : Ideal R`
- **出处**：`Mathlib/RingTheory/Ideal/Basic.lean`、`Mathlib/RingTheory/Ideal/Quotient/Basic.lean`
- **谁在用**：`abstract-algebra.ring.ideal`。
- **坑**：`RingHom.ker f` 已是 `Ideal R`（非 Subgroup）；商环投影需 `[I.IsTwoSided]`。

### `IsDomain` / `IsField.mul_inv_cancel` / `Ideal.isPrime_iff` / `Ideal.IsMaximal` / `Ideal.Quotient.isDomain` / `Ring.isField_iff_maximal_bot`
- **人话**：整环 `IsDomain`（无零因子）；域 `IsField`（非零元可逆）；素理想判据
  `I.IsPrime ↔ I≠⊤ ∧ (x·y∈I → x∈I ∨ y∈I)`；极大 ⟹ 素；素理想 ⟹ 商环整环；**R 是域 ⟺ 零理想极大**。
- **签名**：`Ideal.isPrime_iff`；`Ideal.Quotient.isDomain I [I.IsPrime] : IsDomain (R ⧸ I)`；
  `Ring.isField_iff_maximal_bot [Nontrivial R] : IsField R ↔ (⊥:Ideal R).IsMaximal`
- **出处**：`Mathlib/RingTheory/Ideal/Basic.lean`、`Mathlib/RingTheory/Ideal/Quotient/Basic.lean`
- **谁在用**：`abstract-algebra.ring.domain`。
- **坑**：`IsField` 是 Prop 不是 typeclass（不能 `[IsField R]` binder）；`isField_iff_maximal_bot` 在 `namespace Ring`。

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

---

## 附：登记清单自动核对

- 登记过的名字在此文件的 `### ` 标题里。
- 快速检查"某个名字有没有登记"：`grep "### \`名字\`" docs/MATHLIB-RADAR.md`。
- 叙述层每条目 front matter 的 `mathlib:` 字段应都能在本文找到锚点。