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

### 3.9 `Setoid` 的 `≈` 与 `#print axioms` 盲区（诚实比零公理重要）

- 现象：`f ≈ f`（`CauSeq ℚ` 上）带 `Classical.choice`，即使证明体是纯 ε-δ 构造。
- 根源：`≈` 是 `CauSeq.equiv`（instance，reducible 展开）的 `Rel` 字段，
  展开会把**实例内置证明**（mathlib 的 `LimZero` 证明路径，用 classical）计入 axiom 集。
  这是"引用现成 Setoid 实例"的库开销，不是本条目新增的数学公理。
- 陷阱：把类型改写为结构投影 `CauSeq.equiv.Rel f f`，`#print axioms` 报**零公理**。
  **这是漏报，不是真零**——投影非 reducible，#print axioms 不再展开就停止报告。
  **禁用**：不能用投影改写来"伪装零公理"，违背公理透明的系统性求真。
  对照：同一证明体，`LimZero (f - f)` 与 `f ≈ f` 都带 choice；只有投影形式报零。
- 正确做法：诚实保留 ≈/LimZero 形式，在叙述层注明
  "choice 来源是 `CauSeq.equiv` 实例内部（mathlib 的 LimZero 证明），非本条目内容"。
- 出处：`analysis.real.construction-cauchy`（实验文件 /tmp/opencode/pb.lean）。

### 3.10 `lake build` 的增量失误：改顶层 import 的子模块后，顶层 olean 可能不刷新

- 现象：`lake build` 显示成功，但外部测试文件 `import SandronesLibrary` 里
  `#check` / `#print axioms` **新加的定理报 unknown identifier**；旧定理却一切正常。
- 破局方法（三分校准）：
  1. 最小复现：单条 `#check <全限定名>` 单独验证，确认不是批量脚本造成。
  2. 对照：`#check` 旧定理（同命名空间）仍能解析 → 排除"命名空间写错/改名"。
  3. 隔离 olean：把 `#print axioms` **临时写进源码文件本身**编译 → 若成功，
     说明源文件内容与命名没问题，问题在**顶层模块的 olean 缓存的导入依赖过期**。
- 根治：删顶层缓存（`rm .lake/build/lib/lean/SandronesLibrary*.olean`）后 `lake build`，
  或直接 `lake build SandronesLibrary` 强制重编顶层；此后测试文件正常。
- 语义：lean 顶层 olean 含其 import 的依赖信息，lake 增量追踪对"源文件没变"
  的顶层常常跳过重建，导致体验 import 到旧依赖。**凡是改了被子模块 import 的源，
  都应强制重编顶层后再跑外部 `#check`/`#print axioms`。**
- 出处：第三章第四批（len analysis.sequence 四新定理），实验文件 /tmp/opencode/ax2.lean。

### 3.11 做题也要列 todo：一道定理 = 一个微项目，一次 edit 只喂一条引理

- 现象：写"闭区间套 ⟹ 有限覆盖"这种 C 类大定理时，把
  （二分定义 + 长度引理 + 保序引理 + 保"无有限子覆盖"引理 + 主定理）**整块塞进
  一次 Edit**，结果十余个错误连环爆炸（syntax + 未知名 + 类型不匹配 + 方向错误），
  且中途还留下了 `sorry` 占位，把自己拖进"修到你烦"的泥潭。
- 教训：**把证明方案先写成 todo list，一条引理一个 item，逐条 edit + 编译通过再下一条。**
  - 写大定理前先在文件里立下 `/- 引理清单 -/` 注释（含每个引理的类型签名），
    等于把"思维脚手架"固化下来，不用每轮重推。
  - 每轮只动一个最小可验证单元（小引理 / 主定理的分支），跑 `lean` 无错即完成一项。
  - 中途**严禁留 `sorry`**：敢留一个，下一个错误就离它十万八千里。
- 与 §3.10 的区别：§3.10 是"改完才编"的增量缓存陷阱；§3.11 是"一次喂太多"
  的注意广度陷阱。两者的共同解法都是**缩小验证单元、及时编译**。
- 出处：第三章第五批（analysis.completeness 等价环第三道 NIT→FC）。

### 3.12 `⋃ i ∈ t, U i`（t : Finset）会把绑定变量绑架成 `Set ℝ` —— 改用纯 ∃ 描述

- 现象：`x ∈ ⋃ i ∈ t, U i`（`t : Finset ι`）被反复解构时，`rcases` 给出的
  `i` 类型是 `Set ℝ`，目标是诡异的 `i ∈ Set.range fun i => ⋃ (_ : i ∈ t), U i`；
  `Finset.mem_union_left` 等全套 Finset 引理全部失配，跟类型死磕数轮。
- 根因：Lean 4.33 里 `⋃ binder ∈ s, f` 记法默认把 `s` 当 `Set` 解析，
  对 `Finset` 的 coercion 路径不稳定；`∈` 的 instance 在未知类型时容易拐错。
- 对策：**有限集合参与"覆盖/成员"描述时，一律写成纯 ∃ 记法**：
  `∃ t : Finset ι, ∀ x ∈ Set.Icc l r, ∃ i ∈ t, x ∈ U i`
  （= "存在有限 t 使每点都被 t 里某片盖住"）。∃/∀ 的 `∈` 记法很稳，
  `rcases` 直接给出 `hit : i ∈ t`（Finset 成员），配 `Finset.mem_union_left` 无摩擦。
- 推广：任何"big ∪/∩ 带 ∈ binder 且集合是 Finset"的命题，写完先想好解构路径。
- 方法论（用户强调）：**一小段证明从失败改到成功，当场就把坑写进 Playbook**，
  不要攒到最后凭记忆 batch——记忆会蒸发，Playbook 不会。
- 补充（无 Finset 也会踩）：`rcases` 直接解构 `x ∈ ⋃ i, U i`（U : ι → Set ℝ，**无** ∈ binder）
  给出的 `i₀` 类型是 `Set ℝ`、`hxi₀ : (i₀ ∈ Set.range fun i => U i) ∧ x ∈ i₀`，
  后续 `hUo i₀` 立刻类型失配。对策：先 `Set.mem_iUnion.mp`（或 `(Set.mem_iUnion.mp h)`）
  拿到 `∃ i : ι, x ∈ U i` 再 `rcases`。`Set.mem_iUnion` 知道正确类型，绕过绑架。
- 出处：第三章第五批（analysis.completeness 等价环 NIT→FC，finite_cover_halves / 主定理）。

### 3.13 带 `if` 的递归 def：`by_cases` + `simp only` + `dif_pos/dif_neg`

- 场景：想证明某种 `def halfbiseq … | 0 => … | n+1 => let (l,r) := … in if _h : P l r then (l, m) else (m, r)` 的性质，
  需要在任意 `n+1` 处按 `if` 分两支。
- 失败模式：`by_cases h : P (halfbiseq … n).1 ((halfbiseq … n).1 + …)/2` 时，
  - 漏括号：`P X Y / 2` 被解析为 `(P X Y) / 2`（Prop 相除，报 `HDiv Prop ℕ`）。条件是 `P X ((X + Y) / 2)`，必须全括号。
  - `simp [halfbiseq, h]`：默认 simp 会把 `(l + r)/2` 归一成 `l * (1/2) + r * (1/2)`，
    使 if 条件的语法形与 `h` 对不上，`if` 化简成 `if True`（带 binder 的依赖 if，`if_true` 又配不上）。
- 正确套路：
  ```
  by_cases h : P X ((X + Y) / 2)        -- 条件与 def 内 if 逐字一致
  · simp only [halfbiseq]               -- 只展开 def，禁止额外归一
    rw [dif_pos h]                      -- 依赖 if 的真分支（h 即条件）
    ring / nlinarith …
  · simp only [halfbiseq]
    rw [dif_neg h]
    ring / nlinarith …
  ```
- 区分：`if c then a else b`（`ite`，c : Bool/Prop 非依赖）配 `if_pos/if_neg`；
  `if h : c then a else b`（`dite`，h 在分支可用）配 `dif_pos/dif_neg`。
- 出处：第三章第五批（NIT→FC，halfbiseq_length_step）。

### 3.14 `No goals to be solved`：直接把多余的 tactic 删掉，别干别的

- 症状：某一行（常是 `exact …` / `rfl` / `nlinarith`）报 `error: No goals to be solved`。
- 语义：**goal 在上一行就已经被关掉了**，你这一行是多余的。前面某个 tactic（常见 `rw [dif_pos h]`/`rw [dif_neg h]`、`simp`、`omega`）
  已经把目标证明完，剩下的 tactic 找不到目标可证，于是报错。
- 正确做法：**删掉这一行多余的 tactic**，重新编译。一行即可解决。
- 反例（浪费时间的错误走法）：看到 `No goals to be solved` 就去怀疑定义、给谓词加 `@[irreducible]`、改 def、
  排查 rw 失配。结果引入连环新错（`intro h` 打不开 `¬∃`、重复声明、`Did not find dite`）。
  这全是"目标早已关闭"这一个简单事实引发的连锁误判。
- 铁律：报 `No goals to be solved` ⟹ 先删多余行；只有删完仍 `unsolved goals` 才回头找真正的证明缺口。
- 出处：第三章第五批（NIT→FC，halfbiseq_left_mono_step / right_antitone_step）。

### 3.15 两个小陷阱：`push_neg` 已弃用；`Type*` 在 `def X : Prop` 里会卡 universe

- `push_neg` 在 lean 4.33 已弃用，改用 `push Not`（`push Not at h` / `push Not`）。
  语义同 push_neg：把 `¬∀` 推成 `∃¬`、`¬∃` 推成 `∀¬`、`¬(P∧Q)` 推成 `P→¬Q`。
- `Type*` 陷阱：`def X : Prop := ∀ (ι : Type*) …` 会让 `Type*` 变成 X 的 universe 参数
  （`X.{u}`），调用 `h` 时传 `ι := ℝ`（ℝ : Type 0）无法 unify `u := 0`，报
  `ℝ has type Type but expected Type u_1`。凡"Prop 里显式量化的指标类型"直接写 `Type`
  （Sort 1，覆盖 ℝ/ℕ/普通类型）即可，别用 `Type*`。
- 出处：第三章第五批（NIT→FC 主定理；FC→AccPt 的 `accumulation_point_of_finite_cover`）。

### 3.16 构造 `⋃ c ∈ s, t c` 的元素用 `Set.mem_biUnion`；无限子集的枚举用 `Set.Infinite.exists_gt`

- 构造 `n ∈ ⋃ c ∈ s, t c`（s : Set ι）时，别用 `rcases` 式嵌套 `⟨c, hc, ht⟩`（会把 c 绑成 `Set`，
  报 `expected Set ℕ`）。用 `Set.mem_biUnion`：`Set.mem_biUnion (hc : c ∈ s) (ht : n ∈ t c)`。
  例（鸽笼覆盖）：`Set.mem_biUnion ⟨n, rfl⟩ rfl : n ∈ ⋃ c ∈ Set.range u, {m | u m = c}`。
- `Set.Infinite.exists_gt (hs : s.Infinite) (a) : ∃ b ∈ s, a < b`——无限子集在任意 a 之后还有元素；
  配 `Nat.exists_strictMono_subsequence (h : ∀ N, ∃ n > N, P n)` 得到 `StrictMono φ ∧ ∀ n, P (φ n)`。
- `Set.Infinite s` 与 `¬ s.Finite` 是 definitional 相等：`h : ¬ s.Finite` 直接就是 `s.Infinite`，勿再 `not_not.mp`。
- 出处：第三章第五批（AccPt→Cauchy 的 `cauchySeq_tendsto_of_finite_range`）。

### 3.17 `exact` 报类型不匹配时，先用 `exact?` / `apply?` / `rw?` 问编译器

- 症状：`exact <某引理/项>` 报 `Application type mismatch` 或 `expected to have type`，
  你手头这个项"看起来对"但 Lean 不认。多半是**参数顺序/隐式参数/函数 vs 值的结构**对不上，
  而不是缺证明——这类用肉眼看很费时。
- 对策：把该行换成 `exact?`（或 `apply?`、`rw?`），Lean 会在可用引理里搜索并给出
  **可直接粘贴的完整命令**（常带 `Try this: ...`）。它特别擅长发现：
  - 该用 `.mp`/`.mpr`、`Eq.symm` 的方向问题；
  - 需要先 `change`/`dsimp` 让类型 definitional 对齐；
  - 正确的引理名或参数写法（如 `IsCompact.image hK hf` 该给哪个 `Continuous`）。
- 与 §0 的顺序配合：先 `exact?` 拿到候选，再人工核对语义对不对，再粘贴——不要盲抄。
- 反例（浪费时间）：在 `exact` 上手动调参/加 `by`/拆解参数来回试，不如一次 `exact?`。
- 出处：第五章（Continuity 最值定理：`IsCompact.image` 需要全域 `Continuous f`，
  而 `ContinuousOn.restrict hf` 给的是子类型连续——`exact?` 会指向 `ContinuousOn.domRestrict`
  与正确的像-非空-存在极值组合）。

### 3.18 "转正"（Promote to Textbook Form）：mathlib 广泛形式 → 库当前阶段的教材陈述

- **定义**："转正" = 一个**教材上的重要结果**，在 mathlib 里可能只以**很广泛/抽象的形式**存在
  （如 `Module.finrank`、`Submodule.span_le`、`IsCompact` 的某引理），但我们的库还没用
  **当前阶段的语言**把它作为正式词条写下来。转正就是把这种结果"用教材陈述 + 库记号 + 证明"立成词条。
- **为什么要转正**：
  1. 教材结果是学生要学的、可检索可调用的核心知识；mathlib 的广泛形式是"实现细节"。
  2. 检查某条目时，若其 `mathlib` 字段指向的抽象引理在教材里对应一个重要结论
     （而库没单独立条），就说明该转正。
  3. 防止"mathlib 有就算完"——库的价值是**教材层**的可读词条，不是 mathlib 名目清单。
- **判据（满足其一就该转正）**：
  - a) RADAR 里登记的 mathlib 名，其"人话"对应一个教材定理，但 registry 里没有对应词条。
  - b) 某词条的 summary 声称涵盖某教材结果（如"span 是最小子空间"），但代码里没真正实现该结论。
  - c) 某教材核心结论（如生成子空间最小性、秩-零度、可逆⟺det≠0、相似不变）仅以 mathlib 广泛形式存在。
- **转正流程（每个候选）**：
  1. **确认教材陈述**：翻参考书/讲义，写下该结果的教材语言（变量、前提、结论）。
  2. **定位 mathlib 抽象**：找出承载该结果的 mathlib 引理（RADAR 或 `#check`）。
  3. **用库当前阶段语言立条**：
     - 签名只用当前阶段的教材记号（`LinearSpace`/`dim`/`det`/`rank`…），
       **`:= by` 前不出现 mathlib 广泛名**（`Module.*`、`Submodule`、`LinearIndependent`…）。
     - 高级结构只允许出现在证明内部（或作为"此概念是 mathlib 某概念的实例"的旁注）。
  4. **证明**：优先基础/教材办法（纯 det、纯 ε-N、纯集合论）；能绕开多项式环/环同态等
     更广泛结构就绕开（§3.18 同源原则：保留当前阶段的域性质）。
  5. **注册 + 叙述层 + RADAR**：词条 id 用 `linear-algebra.*`/`analysis.*` 教材命名；
     叙述层写教材陈述，mathlib 名只作实现注记。
  6. **验收**：`lake build`、`check_axioms --fix`、`audit.py` 全过。
- **反例（不算转正）**：直接把 mathlib 广泛定理 `exact` 一下立个词条，签名全是
  `Module.*`/`Submodule`——那是"抄 mathlib"，不是转正。
- **定期动作**：每完成一批，回头扫已有条目的 `mathlib` 字段与 RADAR，
  找出"教材结果 vs 广泛形式"的缺口并转正（本节即由此触发）。
- 出处：线性代数批（`vector-space.span` 的最小性曾因桥接繁琐被删——正是转正缺口）。

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
