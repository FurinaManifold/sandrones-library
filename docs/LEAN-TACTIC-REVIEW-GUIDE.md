# Sandrone's Library 人类审阅者 Lean Tactic 指南

这份指南面向“会读数学，但不一定会写 Lean”的审阅者。目标不是教你从零完成所有形式化，而是让你
看到一段 `by ...` 证明时，能够回答四个问题：

1. 当前要证明什么？手里已经有什么？
2. 每一行 tactic 把数学任务变成了什么新任务？
3. 自动化 tactic 究竟只做了代数整理，还是吞掉了关键数学步骤？
4. 这段证明虽然通过编译，是否仍存在范围、假设、方向或可维护性问题？

本指南解释 Lean 4 与 Mathlib 的通用语义，并以本库真实证明习惯为重点。开发者的排错细节继续放在
[`LEAN-PLAYBOOK.md`](LEAN-PLAYBOOK.md)；本文件首先服务于阅读和审核。

## 1. 社区文档应该怎么用

Lean 官方把 tactic 解释为“逐步构造证明项的指令”：定理陈述产生一个目标，tactic 改变目标或把它
分解为若干子目标，所有子目标关闭后才得到内核可检查的证明项。最适合系统阅读的是：

- [Theorem Proving in Lean 4：Tactics](https://lean-lang.org/theorem_proving_in_lean4/Tactics/)：从目标、
  `apply`、改写、简化到 tactic 组合子的教程。
- [Lean Language Reference：Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)：
  Lean 4 核心语法和每个 tactic 的规范参考。
- [Mathlib Tactics](https://leanprover-community.github.io/mathlib4_docs/tactics.html)：`omega`、`linarith`、
  `ring`、`norm_num` 等 Mathlib 自动化的完整索引。
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/)：面向数学工作者，适合
  看 tactic 如何出现在代数、分析、拓扑等真实证明里。
- [Lean 4 Tactic Cheatsheet](https://leanprover-community.github.io/papers/lean-tactics.pdf)：适合已经理解
  基本语义后快速查名字，不适合替代教程。

阅读社区文档时先确认版本是 **Lean 4 / Mathlib 4**。旧 Lean 3 页面有时仍排在搜索结果前面；概念
可能相似，但语法、命名和实现细节不应直接复制。

## 2. 先学会看“证明状态”

```lean
theorem demo (P Q : Prop) (hP : P) (hPQ : P → Q) : Q := by
  exact hPQ hP
```

`by` 后进入 tactic 模式。编辑器在光标处显示的状态可读作：

```text
P Q : Prop
hP : P
hPQ : P → Q
⊢ Q
```

横线以上是局部上下文：已经固定的对象和可以使用的假设。`⊢` 后是当前目标。把它读成人话：“已知
`P`，且 `P` 推出 `Q`，现在要证 `Q`。”`exact hPQ hP` 给出类型恰为 `Q` 的证明项，所以关闭目标。

一条 tactic 有三种常见结果：

- **关闭目标**：例如 `exact h`、成功的 `ring`。
- **改变目标但仍只有一个**：例如 `intro x`、`change ...`、`rw [...]`。
- **拆成多个子目标**：例如 `constructor`、`by_cases h : P`、`refine ⟨?_, ?_⟩`。

缩进的圆点 `·` 表示“处理当前分支”：

```lean
theorem and_swap (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by
  constructor
  · exact h.2
  · exact h.1
```

`constructor` 后有两个目标；两个圆点分别关闭它们。若不知道一行产生几个目标，可以在编辑器中把
光标放在该行末尾观察状态。

## 3. 证明脚本里的符号和占位符

### 3.1 `by`、`:=`、`=>` 和 `↦`

- `:=` 给定义、定理或局部 `have` 提供值／证明。
- `by` 表示后面用 tactic 构造这个值。
- `=>` 或 `↦` 构造匿名函数，例如 `fun x ↦ f x`。
- 对命题而言，“函数”就是证明：`fun hP ↦ ...` 是 `P → Q` 的证明。

因此 `have h : P → Q := by intro hP; ...` 和 `have h : P → Q := fun hP ↦ ...` 在逻辑上是同一类
对象。

### 3.2 `_`：让 Lean 推断这一项

单独的 `_` 是匿名占位符，要求 elaborator 根据期望类型和周围参数推断内容。信息足够时 Lean 自动
填入；信息不足时编译报告未解决的 metavariable。它不是 `sorry`，也不是绕过证明。过多 `_` 会隐藏
传入的是哪个对象，尤其在多个同类型映射、基点或嵌入并存时，即使能推断也应考虑显式写出。

在 `rcases` 模式中 `_` 表示“不手动命名这个析构字段”，如 `rcases h with ⟨x, _, hx⟩`。

### 3.3 `?_`：这里故意留下一个后续子目标

```lean
refine ⟨witness, ?_⟩
```

若目标是 `∃ x, P x`，这一行先选择 `witness`，再把目标变成 `P witness`。多个 `?_` 按构造器字段
产生多个目标：`refine ⟨?_, ?_, ?_⟩` 是“结构已选定，三个字段稍后分别证明”。正式文件能够编译，
说明这些洞都被后续 tactic 填完；`?_` 不是未完成证明。真正需要拒绝的是 `sorry`、`admit`、未经
授权的 `axiom` 或仍有 unsolved goals 的文件。

### 3.4 `⟨...⟩`：构造或拆开对象

- 目标 `P ∧ Q`：`⟨hP, hQ⟩`。
- 目标 `∃ x, P x`：`⟨x, hx⟩`。
- 目标是 subtype `{x // P x}`：`⟨x, hx⟩`，即值和成员证明。
- 目标是结构：依次提供各字段。

同一符号出现在 `rcases h with ⟨x, hx⟩` 时方向相反：不是构造，而是拆开已有对象。

### 3.5 `;` 与 `<;>`：把下一招应用到多个目标

普通换行和 `;` 都可把 tactic 命令接在一起；`<;>` 则显式表示把右侧 tactic 应用到左侧产生的
**全部**目标，因此它特别常出现在“一次分类，所有分支同样收尾”的证明里。

```lean
constructor <;> linarith
```

先用 `constructor` 产生两个目标，再对**每个新目标**运行 `linarith`。`tac₁ <;> tac₂` 可读成“做
`tac₁`，然后对它产生的所有目标做 `tac₂`”。本库也常见 `cases h : b <;> simp [h]`，即对 Bool
两个分支都简化。

长链 `tac₁ <;> tac₂ <;> tac₃` 会把后续 tactic 广播到多层目标，难以判断哪个 tactic 关闭哪个
分支。核心数学分支不同时，应使用 `·` 或 `case` 明写。

## 4. 从目标形状选择结构 tactic

### 4.1 `intro` 与 `rintro`

目标是 `∀ x, P x` 或 `P → Q` 时：

```lean
intro x   -- 固定 x，证明 P x
intro hP  -- 增加 hP : P，证明 Q
```

`rintro` 是 `intro` 加立即析构：`rintro ⟨hP, hQ⟩` 引入一个 `P ∧ Q` 假设并拆成两部分。

### 4.2 `exact`、`apply`、`refine`

`exact e` 要求 `e` 的类型与目标匹配，成功后直接关闭：

```lean
exact hPQ hP
```

`apply lemma` 从结论反推前提。若 `lemma : A → B → C` 且目标为 `C`，就生成 `A`、`B` 两个目标。

`refine` 允许显式填一部分参数，用 `?_` 留下想看的洞：

```lean
refine lemma knownA ?_
```

只留下 `B`。审阅上，`exact` 最透明；`apply` 简洁但要查看生成目标；`refine` 最适合依赖类型和结构
构造，因为作者能固定关键 witness、映射或基点。本库大量 `refine ⟨对象, ?_⟩` 通常是在说：“数学
对象已经选好，下面验证它满足定义。”

### 4.3 `constructor`、`left`、`right`

目标是 `P ∧ Q` 或具有明确构造器的结构时：

```lean
constructor
· ... -- P
· ... -- Q
```

目标是 `P ∨ Q` 时，`left` 选择证明 `P`，`right` 选择证明 `Q`。目标是 `P ↔ Q` 时，`constructor`
产生正向 `P → Q` 与反向 `Q → P`。选择哪一边、哪个构造器是数学内容，不只是格式动作。

### 4.4 `rcases`、`obtain`、`cases`

`rcases` 递归拆开存在、合取、析取或结构：

```lean
rcases hExists with ⟨x, hx⟩
rcases hAnd with ⟨hP, hQ⟩
rcases hOr with hP | hQ
```

分别读作：“取见证 `x`”“把且拆开”“分两种情况”。Lean 官方 reference 对 `rcases` pattern 有完整
说明，包括 `_`、`rfl`、嵌套 `⟨...⟩` 和 `|`。

`obtain ⟨x, hx⟩ := exists_x` 把“调用存在定理”和“立即拆开”合并，相当于先 `have` 再 `rcases`。

`cases h` 更接近按归纳类型构造器分类。`cases h : b` 中的 `h` 记录分支方程（如 `b = false`），
方便后续 `simp [h]`。依赖类型上的 `cases` 可能同时 transport 上下文，审核时应查看分支后的真实
类型，而不是凭变量名猜。

### 4.5 `by_cases`、`by_contra`、`exfalso`

`by_cases h : P` 产生 `h : P` 与 `h : ¬ P` 两个分支。若定理声称构造性，要检查是否允许经典排中。
`by_contra h` 假设目标的否定后推出矛盾。`exfalso` 把任意目标改为 `False`；得到矛盾后可用
`False.elim` 推出原目标。

### 4.6 `induction`

```lean
induction n with
| zero => ...
| succ n ih => ...
```

按构造器产生分支并在递归分支提供归纳假设。审核要核对：归纳命题是否足够一般；`ih` 是否覆盖
下一步所需参数；递归步骤是否真的使测度变小。`induction ... generalizing x` 会先泛化 `x`，通常
是为了得到更强归纳假设。

### 4.7 `rfl`、`subst`、`use`、`specialize`、`convert`

- `rfl` 证明两边经过定义计算后相同。它不只处理肉眼完全相同的文本，也处理 β 化简、结构投影等
  definitional equality。若一个看似深刻的定理由 `rfl` 完成，通常说明数学内容已被编码进定义，
  应转而审核定义是否正确。
- `subst x` 使用上下文中的 `x = t` 或 `t = x`，把 `x` 全部替换为 `t` 并清除该等式。依赖类型下
  它也负责必要 transport；审核时确认消去的是哪个变量。
- `use w` 为存在目标提供 witness，近似于 `refine ⟨w, ?_⟩`；多个参数可写 `use x, y`。
- `specialize h x` 把全称假设 `h : ∀ x, P x` 就地改成 `h : P x`。若还需要原来的全称形式，先
  `have hx := h x`，不要破坏 `h`。
- `convert h using 1` 尝试用“几乎匹配”的 `h` 关闭目标，并把不匹配部分变成新的相等性目标。
  它在 coercion、结合顺序和等价表示间很方便，但比 `exact` 更隐蔽；必须检查生成的每个 congruence
  子目标，不能把方向错误当成无害格式差异。

## 5. 改写与“让目标露出真面目”

### 5.1 `rw`：按等式定向替换

若 `h : a = b`：

```lean
rw [h]       -- 把匹配的 a 改为 b
rw [← h]     -- 反方向
rw [h] at hx -- 在假设 hx 中改写
rw [h] at *  -- 在全部相关假设和目标中改写
```

`rw` 使用指定等式，方向和位置都可审阅。它不会主动搜索所有化简，也不保证展开记号背后的定义。
若目标写成 `(g ∘ f) x`，引理写成 `g (f x)`，可先 `change` 或 `simp [Function.comp]`。

审阅时检查：等式方向是否符合数学推理；引理是否已包含过强的最终结论；`at *` 是否让关键假设
难以追踪。

### 5.2 `change`：换成定义上相等的目标

```lean
change g (f x) = y
```

要求新旧目标 **definitionally equal**：只靠定义展开和计算即可相同，不使用需要证明的数学定理。
它是在告诉 Lean 和读者“目标的真正计算形状是这个”。这在 coercion、subtype、函数复合、结构字段
和商类型周围很常见。成功的 `change` 没有增加数学假设，但仍要核对新写法是否忠实表达原概念。

### 5.3 `unfold` 与 `dsimp`

- `unfold f` 展开指定定义。
- `dsimp [f]` 做定义性简化，通常比 `simp [f]` 更保守。

要展示教材定义如何落到 Mathlib 承载时，显式 `unfold` 往往比一条大 `simp` 更容易审核。

### 5.4 `simp` 与 `simpa`

`simp` 使用 `[simp]` 引理，把表达式朝预设的简单方向反复重写：

```lean
simp
simp [definition, h]
simp only [lemma₁, lemma₂]
simp at h
simpa [definition] using known
```

- `simp` 使用全局 simp 集。
- `simp [f, h]` 额外展开 `f`、使用 `h`。
- `simp only [...]` 只用列出的规则及必要规约，最可控。
- `simpa ... using known` 把 `known` 的类型和目标都简化，再用前者关闭后者。

`simp` 擅长单位元、投影、构造器判等、已知 if 分支、集合成员和定义规约。若重要教材定理只写
`by simp`，要查看 simp 到底调用了什么：可临时用 `simp?` 获取建议，或要求关键步骤改为
`simp only [...]`。

### 5.5 `simp_rw` 与 `nth_rw`

- `simp_rw [h]` 按给定规则反复改写，并能进入 `∀`、`∃`、lambda 等 binder。
- `nth_rw 2 [h]` 只改写第 2 个匹配位置。

审核时要核对改写范围，尤其 binder 下变量是否仍对应原数学对象。

## 6. 中间结论和等式链

### 6.1 `have`、`let`、`set`、`suffices`

`have hx : P x := by ...` 给中间事实命名，是最重要的可读性工具。长自动化前先列出数学引理，就能
区分“数学步骤”和“末端算术”。

`let y := expression` 给表达式命名；`set y := expression with hy` 还保留 `hy : y = expression`，便于
改写回去。

`suffices h : P by ...` 表示“只要证明 `P`，当前目标就能完成”，随后把 `P` 作为目标。它是逆向
规划；审核时先确认 `P` 的确足够。

### 6.2 `show`

`show P` 把当前目标显示为 definitionally equal 的形式。`exact (show P from hP)` 也可在 term 中
明确期望类型。它常用于澄清 coercion 或隐式类型。

### 6.3 `calc`

```lean
calc
  f x = g x := by ...
  _   = h x := by ...
  _   ≤ C   := by ...
```

`_` 表示上一行右端，连接关系由等号、序关系或传递性组合。`calc` 最接近纸面推导。逐行检查中间量、
关系方向、所用引理强度，以及最后是否回到原目标。

## 7. 外延性、函数相等与结构相等

### 7.1 `ext` 与 `funext`

`ext x` 选择相应 `[ext]` 引理，把集合、子群、线性映射等结构相等变成点态／成员目标。集合恒等式
常变为 `x ∈ A ↔ x ∈ B`，再用 `constructor` 证明双向。要核对选中了哪条外延原则：有时只比较
carrier，有时比较函数值或更多字段。

目标 `f = g` 时，`funext x` 变成 `f x = g x`。这是函数外延性，后面仍需逐点证明相同。

### 7.2 `congr`、`congrArg`、`apply_fun`

- `congrArg f h`：由 `h : a = b` 得 `f a = f b`。
- `apply_fun f at h`：把等式两边应用 `f`，有时产生单射性义务。
- `congr`：把复合表达式相等拆成参数相等。

若用 `apply_fun` 消去映射，要检查映射是否单射以及 Lean 如何获得单射证明。

## 8. 集成自动化 tactic：各自只该做什么

### 8.1 `ring` 与 `ring_nf`

`ring` 证明交换半环／环中的多项式恒等式：加、乘、自然数次幂、减法和系数归一化。

```lean
example (a b : ℝ) : (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by
  ring
```

它适合所有分析、几何或代数前提已处理完后做纯多项式整理。`ring` 尝试关闭等式；`ring_nf` 在目标
或假设中正规化，可能不关闭目标。它不会证明分母非零、序不等式、非交换乘法，也不会理解 `sin`、
`exp` 的分析性质；这些会被当作原子。

### 8.2 `omega`

`omega` 面向 `Nat`、`Int` 的线性离散算术：等式、`<`、`≤`、常数倍、部分整除、常数模／除法及
自然数减法分类。它适合有限索引、网格端点和长度界，不适合实数分析，也不证明变量相乘、变量指数
等非线性自然数命题。

### 8.3 `linarith`

`linarith` 从线性等式／不等式假设作有理线性组合，推出线性目标或矛盾：

```lean
example (x y : ℝ) (h₁ : x ≤ y) (h₂ : y ≤ x + 1) : y - x ≤ 1 := by
  linarith
```

它把不认识的非线性子表达式当原子。本库规定：目标或关键假设仍含绝对值时，不直接期待
`linarith` 理解绝对值；先用 `abs_le`、`abs_lt` 展开成线性界。

### 8.4 `nlinarith`

`nlinarith` 在 `linarith` 前增加多项式规范化，可利用平方非负和变量乘积。适合多项式非线性算术，
不理解任意除法、超越函数或变量指数。它更重；重要论证应先 `have` 写出关键不等式，再让它做末端
组合。

### 8.5 `norm_num`

`norm_num` 计算具体数值并证明规范化后的数值事实，如整数／有理数运算、具体幂、明显非零和数值
不等式。它适合“算完就是答案”的叶子目标，不适合符号变量的普遍定理。

### 8.6 `field_simp`

`field_simp` 清除分母，把域上的有理表达式变成环等式，同时生成或使用分母非零条件。常见组合：

```lean
field_simp [hx]
ring
```

审核重点是非零条件 `hx`：若分母可能为零，清分母后的等式不代表原陈述。

### 8.7 `positivity`

`positivity` 通过表达式结构证明非负、正或非零，例如平方非负、正数乘积为正。它常为开方、除法、
对数或不等式 tactic 准备边界条件，不会自动发现深层估计。

### 8.8 一张边界表

| tactic | 负责的“最后一公里” |
|---|---|
| `simp` | 定义、构造器、单位元、已知分支的重写归一化 |
| `ring` | 交换环多项式等式 |
| `omega` | `Nat`/`Int` 线性离散算术 |
| `linarith` | 有序环／域线性等式与不等式组合 |
| `nlinarith` | 多项式非线性等式与不等式组合 |
| `norm_num` | 具体数值计算 |

若问题不在这一列里，先用数学引理把它变成对应形状，而不是反复调用 tactic 碰运气。

### 8.9 `aesop`、`tauto`、`decide`

- `aesop` 按规则做结构搜索，适合浅层构造器、假设应用和有限搜索。
- `tauto` 处理命题逻辑重言式。
- `decide` 对有 `Decidable` 实例的封闭命题通过计算给出证明。

本库当前正式源码几乎不依赖 `aesop`，证明结构较显式。若引入大范围搜索，应说明搜索解决的是
结构胶水还是核心数学。`native_decide` 涉及不同执行与信任边界，本库正式 Entry 禁止用它逃避
证明。

## 9. 一段本库证明怎样逐行读

以下是 van Kampen 满射证明末端的简化转述，正式代码见
[`Topology/VanKampenSurjectivity.lean`](../SandronesLibrary/Topology/VanKampenSurjectivity.lean)：

```lean
theorem surjective_map (...) : Function.Surjective canonicalMap := by
  intro g
  rcases representative_surjective g with ⟨p, rfl⟩
  have hp : ∀ t, p t ∈ U ∨ p t ∈ V := by
    ...
  obtain ⟨D⟩ := exists_subdivision p hp
  obtain ⟨C⟩ := D.exists_connectors ...
  refine ⟨D.pushoutWord C, ?_⟩
  rw [D.canonicalMap_pushoutWord C]
  exact D.correctedWord_eq_loop C
```

逐行的人话：

1. 要证满射，任取目标元素 `g`。
2. 基本群元素是道路同伦类，选择代表环路 `p`；`rfl` pattern 同时替换 `g`。
3. 由覆盖条件证明环路每点落在 `U` 或 `V`。
4. 从存在定理取有限带标签细分 `D`。
5. 从道路连通性取网格点基点连接 `C`。
6. 为满射显式给出原像 `D.pushoutWord C`，留下“它映到 `g`”的目标。
7. 用规范同态计算公式改写该像。
8. 用有限修正环路词恢复原环路的定理关闭目标。

核心不是末端两行 `rw/exact`，而是此前正式构造并证明的 subdivision、connectors、word 和
cancellation。应沿具名定理上溯，不能因末端短就判定“只挂靠 Mathlib”。

再看典型存在构造：

```lean
refine ⟨u * v, ?_, mul_assoc a u v⟩
```

作者选择 witness `u * v`，第三字段由结合律完成，只把第二字段留作目标。读者能立即看出 witness
和剩余义务。

## 10. 人类审阅的推荐流程

### 第一步：只读 theorem 签名

确认量词、类型类、集合成员、闭性、有限性、基点、标量域和方向与教材陈述一致。证明不能弥补错误
或过强的签名。

### 第二步：给证明分层

1. **结构层**：`intro`、`constructor`、`rcases`、`induction`。
2. **数学层**：调用哪些本库定理，选择什么 witness，关键中间事实是什么。
3. **表示层**：`change`、coercion、transport、`rw`。
4. **归一化层**：`simp`、`ring`、`omega`、`linarith`。

若数学层为空而目标本应是重要教材定理，就要追查自动化或 Mathlib 引理是否已经包含全部内容。

### 第三步：追踪每个强引理

对大 `exact`、`rw [some_equivalence]` 和 `simpa using ...`：查看完整类型；确认前提没有藏在 typeclass
或局部 instance；确认结论不是目标的同义改名；查 Registry/RADAR 判断它是本库课程前提、Mathlib
后端还是未经解释的新依赖。

### 第四步：检查分支是否齐全

看到 `cases`、`by_cases`、`constructor`、`induction`、`<;>` 时数清分支。特别检查空集、零多项式、
零维空间、首末网格点、边界值和分母为零。

### 第五步：检查自动化输入

- `simp` 用了哪些规则？
- `linarith` 是否仍面对绝对值或非线性函数？
- `nlinarith` 的关键非负事实来自哪里？
- `field_simp` 的非零条件在哪里？
- `omega` 是否只处理自然数／整数线性算术？
- `ring` 前是否已经证明所有分析／拓扑事实？

### 第六步：看公理和编译证据

确认无 `sorry`、`admit`、未经批准的 `axiom`；Entry 级公理与 Registry 一致；编译覆盖正式模块及
依赖；文档如实解释 Mathlib 复用、限制条件和未完成边界。

## 11. 常见误读与风险信号

### “证明只有一行，所以没有数学内容”

不一定。一行 `exact` 可能调用本库前面几十行建立的强接口。若它直接调用 Mathlib 最终定理且没有
定义／概念解释层，才是“挂靠”风险。

### “用了自动化，所以不可信”

不对。`ring`、`omega`、`linarith` 等生成由 Lean 内核检查的证明。问题是使用范围是否匹配，以及
自动化是否遮住教材主步骤。

### “`?_` 是没写完”

不对。它是 `refine` 创建的后续目标；文件能编译说明已填完。`sorry` 才是未证明占位。

### “`change` 改了定理”

成功的 `change` 只能换成定义上相等的目标。但依赖类型 transport、coercion 和隐藏参数仍可能难懂，
需要核对对象身份。

### “`simp` 只是无害整理”

通常是，但不能盲信。全局 simp 集可能含强定理，`simp [definition]` 也可能展开大量实现细节。核心
步骤优先要求 `simp only` 或至少用 `simp?` 查看规则。

### “编译通过就等于教材解释正确”

不对。Lean 证明的是精确签名；签名是否对应教材概念、是否漏边界、是否静默采用 Mathlib 的较强／
较弱定义，仍需人类审核和 Entry 文档说明。

## 12. 一页速查表

| 看到 | 读成人话 | 审阅问题 |
|---|---|---|
| `intro x` | 任取／假设 `x` | 引入的是量词变量还是蕴含前提？ |
| `exact h` | `h` 正好就是答案 | `h` 的完整类型和依赖是什么？ |
| `apply thm` | 用定理结论反推其前提 | 产生了哪些子目标？ |
| `refine term ?_` | 固定部分构造，余项稍后证 | witness／映射是否正确？ |
| `constructor` | 按构造器拆目标 | 是合取、等价还是结构字段？ |
| `rcases h with ...` | 拆开存在／合取／析取 | witness 和字段分别是什么？ |
| `obtain ... := thm` | 调用存在定理并取数据 | 前提是否都满足？ |
| `rw [h]` | 用指定等式定向替换 | 方向、位置和引理强度是否正确？ |
| `change P` | 显示成定义等价的 `P` | 隐藏哪些 coercion／参数？ |
| `simp [h]` | 按 simp 规则和 `h` 归一化 | 是否用了过强全局规则？ |
| `simpa using h` | 两边简化后由 `h` 关闭 | 简化前后陈述是否一致？ |
| `calc` | 写传递推理链 | 每一步关系和中间量是否正确？ |
| `ext x` | 转成逐点／成员证明 | 选中了哪种外延原则？ |
| `by_cases h : P` | 分 `P` 与 `¬P` | 是否引入经典排中？ |
| `induction n` | 按构造递归证明 | 归纳假设是否足够一般？ |
| `tac₁ <;> tac₂` | 对全部子目标做 `tac₂` | 分支是否真同质？ |
| `ring` | 交换环多项式归一化 | 核心数学是否此前完成？ |
| `omega` | 解 `Nat/Int` 线性算术 | 是否含变量乘积／非线性？ |
| `linarith` | 线性组合等式／不等式 | 是否仍含绝对值或非线性？ |
| `nlinarith` | 多项式非线性算术 | 关键非负事实是否显式？ |
| `norm_num` | 计算具体数值 | 是否真是封闭数值事实？ |

最终原则：**不要按 tactic 名猜证明；始终追踪“上下文 + 当前目标”在这一行前后怎样变化。**这样即使
不会独立写出同一份 Lean，也能判断作者是在拆逻辑结构、选择数学对象、对齐正式表示，还是只做最后
的机械计算。
