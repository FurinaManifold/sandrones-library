# Sandrone's Library — Lean Tactic Playbook（自我驯化手册）

> **用途**：把"用 Lean 表达数学推理"的实战经验沉淀为可检索知识。
> 本库的 LLM 纳客在 Step 3（形式化）中遇到的每一个 tactic 困难，
> 都应该以「教训条目」的形式登记到这里——**经验在库内累积，而不是在每个新会话里从零踩坑**。
>
> **自我驯化（self-harness）铁律**：遇到 tactic 卡住时，
> **先去 mathlib 里看现成的证明是怎么用这个 tactic 的**——
> 看它使用**前**的目标状态、使用**后**的目标状态，用**自然语言语义**理解每一步在做什么，
> 再动手写。禁止低效的盲目尝试（"换个姿势再试一次"）。

---

## 0. 工作流铁律（Step 3 遇到困难时，按此顺序）

1. **读懂目标**：用自然语言把当前目标翻译成一句话（"我要证 X 属于某个并"、"我要把这个等式改成已展开的形式"）。先想清楚数学意图，再选 tactic。
2. **查 mathlib 现成证明**：
   - 用 grep 在 `.lake/packages/mathlib/Mathlib/` 里搜关键词（定理名/记号/人类可读的语义词）。
   - 用 `#check <名字>` 看定理的**精确类型签名**（参数顺序、隐式参数、返回类型）。
   - 找到一段用 `ext` / `rcases` / `rw` / `simpa` 等策略的现成证明，**观察它使用前后目标的变化**。
3. **用小实验验证理解**：在 `/tmp/opencode/*.lean` 写最小复现，确认"我以为的语义"确实成立，再把结论写回正式文件。
4. **登记教训**：如果这次困难/解法值得保留，按 §3 格式追加到本 Playbook，并 commit。

> 一句话：**先理解语义，再写代码；写完代码，沉淀经验。**

---

## 1. 调试工具（状态观察）

| 工具 | 作用 | 例子 |
|---|---|---|
| `#check <名>` | 看定理/定义的精确类型 | `#check Set.ext` → 显示参数与返回类型 |
| `#print <名>` | 看定义展开、定理证明体 | `#print Function.Injective` |
| `#find` / 源码 grep | 在 mathlib 里搜用法 | `grep -rn "div_lt_iff₀" .lake/packages/mathlib/Mathlib --include=*.lean` |
| `set_option pp.all true` | 显示所有隐式参数与类型（排错时） | 行首加一行再编译 |
| `set_option pp.universes true` | 显示类型宇宙 | 诊断多态不匹配时 |
| `#print axioms <名>` | 检查证明依赖了哪些公理 | 确认没有意外使用 `sorry`/`Classical` |
| 临时 `example` | 在 `/tmp/opencode/` 做最小复现 | 见 §2.1 |

## 2. 常见"数学意图 ↔ tactic"映射

按数学意图分组。**这是最常用的部分：想表达什么，就该用什么。**

### 2.1 集合等式 / 函数等式 → `ext x`

- 数学意图：两个集合（或函数）相等。
- 语义：外延性——"逐元素核对"。
- 用法：`ext x` 后目标变成元素层命题。
- 反例：目标是**包含** `A ⊆ B` 时不用 `ext`，展开 `∀ x, x ∈ A → x ∈ B`（`Set.subset_def`）。

### 2.2 目标含存在量词 → 构造 witness

- 数学意图："存在 x 使得 P(x)"。
- 语义：你必须给出一个具体的 x，并证明它满足 P。
- 用法：
  - `use x`（给出 witness，目标变为证明 P(x)）
  - `refine ⟨x, ?_⟩`（等价写法）
  - `exact ⟨x, hx⟩`（如果一切就绪）
- **教训 §3.1**：当 `rcases`/`obtain` 无法从已有存在命题提取 witness 时，用 `.choose` + `.choose_spec`。

### 2.3 手头有存在命题，想取出里面的东西 → `rcases` / `obtain` / `rintro`

- 数学意图：由"存在 b，g b = c"得到具体的 b 和等式。
- 语义：析构一个 `∃` / `∧` / `∨` 结构。
- 用法：
  - `rcases hg c with ⟨b, hb⟩`
  - `obtain ⟨b, hb⟩ := hg c`
  - `rintro ⟨x, hx⟩`（目标也含存在/合取时）
- 注意：模式 `⟨..⟩` 按类型解构：`∃`→（witness, 证明）；`∧`→（两个证明）；`∨`→（分支）。

### 2.4 目标含合取（要证"且"）→ `constructor` 或 `refine ⟨?_, ?_⟩`

- 语义：拆成两个子目标，分别证明。
- 要证"或" → `left` / `right` / `exact Or.inl ...`。

### 2.5 已知含合取（手头有"且"）→ `rcases ... with ⟨h1, h2⟩`

- 语义：把 "x ∈ A ∩ B" 拆成 "x ∈ A" 和 "x ∈ B"。

### 2.6 已知含析取（手头有"或"）→ 分情况

- 语义：`P ∨ Q` 有两种来源，分别处理。
- 用法：`rcases h with hP | hQ`（两个 case），或用 `rintro (hP | hQ)`。

### 2.7 算术 / 序关系 / 线性组合 → 自动化策略

| 策略 | 场景 | 语义 |
|---|---|---|
| `omega` | 自然数/整数线性算术与序 | "这就是整数算术，交给决策过程" |
| `linarith` | 线性序域上的线性不等式组合 | "这些不等式是线性可导出的" |
| `ring_nf` / `ring` | 交换环上的多项式恒等式 | "展开并规约多项式" |
| `norm_num` | 数值计算 | "把 2*3 算成 6" |
| `positivity` | 证明表达式恒正 | 按结构递归地证明正值性 |

### 2.8 目标在句法上需要先改写 → `change` / `rw` / `simp` / `simpa`

- 数学意图：目标看起来是 A，但已知/定理给的是 B，A 与 B 是同一个东西的不同写法。
- 语义（重要）：
  - `change B`：直接告诉 Lean"把目标改成它的定义展开/可逆写法"。
  - `rw [h]`：**句法替换**——把目标里出现的 h 左边整体换成右边。找不到匹配就失败。
  - `simp [h, def_name]`：用等式 + 定义做规范化（重写 + 化简）。
  - `simpa [def_name] using h`：把 h 用定义规范化后，`exact` 到当前目标。
- **教训 §3.2**：`rw` 不做"定义展开"。目标是 `(g ∘ f) a = c` 时，
  `rw` 找不到 `g (f a)`——先 `simpa [Function.comp]` 或 `change g (f a) = c`。

### 2.9 双向蕴含（当且仅当）→ `constructor` 两半

- 语义：`P ↔ Q` = (P→Q) ∧ (Q→P)。`constructor` 后两个子目标。
- 用 `.mp` / `.mpr` 取一个方向的现成 iff。
- 例：`(div_lt_iff₀ hx).mp hn` —— 由 `a/c < b` 得到 `a < b*c`（c>0）。

### 2.10 函数复合 / 函数相等 → 先想"函数延拓"还是"逐点"

- 复合：`(g ∘ f) x` 就是 `g (f x)`（`Function.comp`）。
- 函数相等：`f = g` ↔ `∀ x, f x = g x`，用 `funext x`（函数外延性）。

## 3. 实战教训（本库踩过的坑，按时间登记）

> 登记格式：**症状 → 诊断（语义层面为什么）→ 解法 → 出处（哪个条目）**。

### 3.1 `rcases`/`obtain` 无法从存在命题提取 witness

- **症状**：`rcases exists_nat_gt (y / x) with ⟨n, hn⟩` 后，目标**仍然是存在量词**（`∃ n, ...`），完全没消掉；`obtain` 同样失败。编译报 "Type mismatch ... expected `∃ n, ...`"。
- **诊断（语义）**：`rcases` 依赖对 `∃ n, ...` 结构的模式匹配。在 mathlib 4.33 的某个返回类型带隐式类型参数的存在命题上，析构没有生效。语义上等于"想从盒子里取东西，但盒子没打开"。
- **解法**：绕过模式匹配，直接取 witness：
  ```lean
  let n := (exists_nat_gt (y / x)).choose   -- 取那个存在的自然数
  use n
  exact (div_lt_iff₀ hx).mp (exists_nat_gt (y / x)).choose_spec
  ```
  `.choose` 提取 witness，`.choose_spec` 给出它满足的性质。语义直白："它存在，就把它挑出来用"。
- **出处**：`analysis.real.archimedean`。

### 3.2 `rw` 找不到复合记号的匹配

- **症状**：目标是 `(g ∘ f) a = c`，`rw [ha, hb]` 报 "Did not find an occurrence of the pattern"。
- **诊断（语义）**：`g ∘ f` 是 `Function.comp` 的**记号缩写**，`rw` 只做句法替换、不展开定义。语义上等于"你让我替换 'AB'，但文件里写的是 'A·B'（一个记号）"。`rw` 看不见未展开的定义。
- **解法**：先展开或用会展开的策略：
  ```lean
  exact ⟨a, by simpa [Function.comp] using (congrArg g ha).trans hb⟩
  -- 或更直白：
  change g (f a) = c          -- 把目标改写为展开后的写法
  rw [ha, hb]
  ```
- **语义理解**：`congrArg g ha` 给 `g (f a) = g b`（把等式 ha 两边同套 g），`.trans hb` 接上 `g b = c`，`simpa [Function.comp]` 用定义把 `(g∘f) a` 规约成 `g (f a)`。三步都是"自然语言一句话"的翻译。
- **出处**：`settheory.function.surj-comp`。

### 3.3 `div_lt_iff₀` 的方向（.mp vs .mpr）

- **症状**：初学容易把 `(div_lt_iff₀ hx)` 用在错误方向。
- **诊断（语义）**：`div_lt_iff₀ hc : (b / c < a) ↔ b < a * c`。`.mp` 取正向（除式 → 乘式），`.mpr` 取反向。它等价于"除以正数不改变序"，但**只对 c > 0** 成立（前提 `hc`）。
- **解法**：把前提（`hx : 0 < x`）作为参数传给定理，再取方向。
- **出处**：`analysis.real.archimedean`。

### 3.4 集合恒等式：先 `ext`，再分派逻辑

- **症状**：想直接"套用"集合层定理但手头只有 mathlib 的 `Set.inter_union_distrib_left` 名字对不上，或想演示证明过程。
- **诊断（语义）**：集合等式在语义上就是"逐元素的双向属于"，逻辑层（`∧`/`∨`）的分配律承担实质工作。集合层没有任何额外的结构。
- **解法**：`ext x` → `constructor`（双向）→ 每边用 `rintro`/`rcases` 拆合取与析取 → 元素层组装。见 `settheory.set.operations.inter-distrib` 的完整演示。
- **出处**：`settheory.set.operations.inter-distrib`。

### 3.5 `rw [mathlib 定理]` 可能悄悄引入 `Classical.choice`（公理最小化）

- **症状**：`#print axioms` 显示定理依赖 `Classical.choice`，但教科书证明根本没用到选择公理。
- **诊断（语义）**：`rw [Set.compl_union]` 这类"引用 mathlib 现成定理"会把该定理**证明路径
  上的一切公理**带进本定理。mathlib 里不少看似平凡的引理是经典化的（尽管结论构造性可证）——
  choice 不是"这条定理需要"，而是"这条证明路径经过"。
- **解法**：换成不借道的构造性证明。集合恒等式用 §2.1 的 `ext x` + 逐元素 `Or`/`And`
  消解，往往就能构造性完成。
- **先判来源再动手**：`complement-inter` 的 `¬(P∧Q)→¬P∨¬Q` **数学上**等价于排中律，
  改写无效。口诀：**先分"数学必需"还是"形式化噪声"，噪声才值得改写。**
- **出处**：`settheory.set.operations.complement-union`（改写后 axioms = `[propext, Quot.sound]`）。

### 3.6 `ext` 后的"缺一个方向"往往是排中律缺口

- **症状**：`ext` 拆完双向，其中一个方向（常常是"否定之析取"或"析取之否定"）怎么都推不动，
  `rcases`/`constructor` 走到一半目标还原地踏步。
- **诊断（语义）**：目标形如 `¬P ∨ ¬Q`（从 `¬(P∧Q)` 来）——这在直觉主义逻辑里没有证明，
  因为要"决定 P 还是 ¬P"。它等价于排中律。不是 tactic 不对，是数学上不可证。
- **解法**：接受 `Classical.choice`（`by_cases h : P` 分路），并在叙述层注明"经典必需"；
  不要把时间耗在不可能的构造性路径上。
- **出处**：`settheory.set.operations.complement-inter`。

### 3.7 `ℝ` 的序结构实例本身带 `Classical.choice`（结构底线，不可削减）

- **症状**：连 `rfl`/`infer_instance` 的证明，`#print axioms` 都报告 `Classical.choice`；
  且是**类型里含 `ℝ` 的 `≤`/`<`** 时出现。
- **诊断（语义）**：`#print axioms` 会把定理类型里出现的 reducible 常量 delta 展开。
  mathlib 4.33 的 `ℝ` 序实例（`instLEReal` 等）**定义体**是经典构造的
  （构造顺序：`conditionallyCompleteLinearOrder` → `LinearOrder` 用 `by classical`）。
  于是 `a ≤ b ↔ a ≤ b := by rfl`（证明体就是 `Iff.rfl`，零公理）仍报告 choice。
- **对照实验**（决定"能否最小化"的关键判据）：
  ```
  t9  (a b : ℝ) : a ≤ b ↔ a ≤ b := by rfl   → [propext, Classical.choice, Quot.sound]
  t10 (a b : ℕ) : a ≤ b ↔ a ≤ b := by rfl   → []（零公理）
  t11 (s : Set ℚ) : BddAbove s ↔ ... := by rfl → []（零公理）
  ```
  只有 `ℝ` 中招，`ℕ`/`ℚ` 干净。
- **结论**：涉及 **ℝ 序性质**的条目，`Classical.choice` 是**结构必需**、无法削减——
  这不是形式化噪声，别浪费时间改写（除非重建整个 ℝ 的构造性实现）。
  公理最小化只适用于"同一结构上下文内避免借用额外经典引理"（§3.5 案例）。
- **出处**：`analysis.real.*`（第二章第一批，全部带 choice 均属此类）。

### 3.8 判断"能否削减 choice"的最小实验模板

- 目标：某 ℝ 序条目带 choice，想知道是否可削减。
- 步骤：写一个**无证明难度的极简对照**（如 `a ≤ b ↔ a ≤ b := by rfl`），
  `#print axioms`；若它已带 choice，则你的条目里的 choice 是结构性的，接受并注明。
- 语义：**先确认"地板"本身带不带公理，再决定要不要擦地板。**
- 出处：`analysis.real.*`。

## 4. 怎么从 mathlib 现成证明学到 tactic 用法

mathlib 的证明文件是**最好的教材**。读法：

1. **定位**：`grep -rn "<tactic名> " .lake/packages/mathlib/Mathlib/<相关目录> --include=*.lean`，
   或搜人类可读的语义词（如 `div_lt_iff₀`、`tendsto_nhds`）。
2. **读签名**：`#check <定理名>` —— 参数顺序、隐式参数、返回类型。这是"函数接口文档"。
3. **读使用前后状态**：找一段用该 tactic 的证明，尝试在头脑中重构：
   - 使用前目标是什么？自然语言怎么说？
   - 该 tactic 一步做了什么改变？
   - 用的参数从哪来？（常常来自上一步 `rcases`/`obtain` 提取的变量）
4. **复刻最小例子**：在 `/tmp/opencode/` 写一个 5 行的 `example`，复制结构，确认自己真懂，再放进正式条目。
5. **失败时**：把报错信息翻译成自然语言（"期望类型 vs 实际类型"就是"我要的东西和手头的东西对不上"），回到 §2 找映射，别瞎试。

## 5. self-harness 闭环（保证经验持续累积）

- 每次在 Step 3 解决一个新困难：**必须**在本 Playbook 登记一条 §3 教训（或补进 §2 映射表）。
- 教训的质量标准：**诊断要写到"语义层面"**（为什么这样，而不是只记"这样能过"）。
  因为记"这样能过"只解决一次，记"语义是什么"能迁移到所有类似情形。
- 审计：`audit.py` 之外，人工 review 时检查"新条目是否引入了未登记的新 tactic 模式"。
- Playbook 本身也是库的一部分，随版本管理，随经验增长。
