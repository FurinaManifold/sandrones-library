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
- **谁在用**：`analysis.sequence.subsequence`。

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
- **谁在用**：`analysis.func-limit.le`（极限保序）。

### 函数极限四条（`Filter.Tendsto.add/sub/mul/div`）
- **人话**：**函数极限的四则运算**：`f → L`、`g → M` 时，和/差/积/商（商要求 `M ≠ 0`）
  分别趋于 `L+M`、`L−M`、`L·M`、`L/M`。是序列极限四则的函数版，一行调完。
- **签名**：`Tendsto.add : f→L → g→M → (f+g)→(L+M)`（sub/mul/div 同构）
- **出处**：`Mathlib/Topology/Algebra/Group/`（域上加法/乘法连续）
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
- **谁在用**：`analysis.real.complement-union/complement-inter` 等一切集合等式证明。

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
- **谁在用**：`analysis.real.complement-union`、`analysis.real.complement-inter`。
- **坑**：`compl_inter` 用到的 `¬(P∧Q) → ¬P∨¬Q` 就是排中律，改写不动（见条目叙述层）。

### `Set.sdiff_eq`
- **人话**：**差集 = 交补**：s \ t = s ∩ tᶜ。`sdiff` 是 mathlib 新版的名字（旧 `diff` 已弃用）。
- **签名**：`(s t : Set α) : s \ t = s ∩ tᶜ`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`analysis.real.diff-inter-complement`。

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
  **必用 `Set.mem_iUnion.mp`** 拿到正确类型的 i——直接 rcases 会被 bigUnion 记法绑架成 Set（Playbook §3.12）。
- **签名**：`x ∈ ⋃ i, s i ↔ ∃ i, x ∈ s i`
- **出处**：`Mathlib/Data/Set/Basic.lean`
- **谁在用**：`analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover`、`analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point`（`Set.mem_iUnion.mp (hcover hxab)` 解出 i₀ : ι）。

### `Set.mem_biUnion`
- **人话**：**构造**"受限并"的元素：`x ∈ s` 且 `y ∈ t x` ⟹ `y ∈ ⋃ x ∈ s, t x`。这是构造方向（往并集里塞元素）的规则；反向解构请用 `Set.mem_iUnion.mp`。别用嵌套 rcases（Playbook §3.16）。
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
- **人话**：**全集无限**（[Infinite α] 时）；`Infinite` 与 `¬ Finite` 同义（definitional，Playbook §3.16）；`Infinite.nonempty` 给非空。ℕ 无限（Set.infinite_univ）是鸽笼矛盾的弹药。
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
- **谁在用**：`settheory.function.inject-surject.respects-comp`。

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
- **坑**：`#print axioms` 会因 `≈` 的类型展开带出 choice（Playbook §3.9）。

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

## 附：登记清单自动核对

- 登记过的名字在此文件的 `### ` 标题里。
- 快速检查"某个名字有没有登记"：`grep "### \`名字\`" docs/MATHLIB-RADAR.md`。
- 叙述层每条目 front matter 的 `mathlib:` 字段应都能在本文找到锚点。