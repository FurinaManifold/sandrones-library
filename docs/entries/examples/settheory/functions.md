---
id: examples.settheory.functions
kind: example
state: verified
title: 像、原像与单射／满射／双射的具体计算与反例
summary: 命名线性函数 2n+1、折半函数 n/2、平方函数 n² 与平移函数 n+1，逐元素算出它们的像与原像，并给出单射不必满射、满射不必单射、像不保持交三组精确反例与双射、复合的正例
premises: [settheory.function.inj-comp, settheory.function.surj-comp, settheory.function.image-preimage.preimage-union, settheory.function.image-preimage.preimage-inter, settheory.function.inject-surject.bijective-iff-inverse, settheory.set.ext]
mathlib: [Function.Injective, Function.Surjective, Function.Bijective, Function.LeftInverse, Function.RightInverse, Set.ext, Set.mem_image, Set.mem_preimage, Set.mem_insert_iff, Set.mem_singleton_iff, Set.mem_inter_iff, Set.mem_empty_iff_false, Set.image_empty, Set.image_inter_subset, Nat.mul_div_right, mul_eq_zero]
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

理论条目 `settheory.function.*` 把像、原像、单射、满射、双射与复合建立为抽象接口。
抽象接口最容易混淆的地方恰好是几个“单向直觉”：看到单射就想反推满射，看到像就以为它像
原像一样保持交。本 Entry 用四个可以手算的函数把这些直觉逐条钉死：

- `doubleAddOne n = 2n + 1`（线性／仿射，`ℕ → ℕ`）；
- `half n = n / 2`（折半，`ℕ → ℕ`）；
- `sq n = n²`（平方，`ℤ → ℤ`）；
- `shift n = n + 1`（平移，`ℤ → ℤ`）。

# 直觉

- 像 `f '' S` 是“把 `S` 里的点逐个送过去，再收集结果”；原像 `f ⁻¹' T` 是“把 `T` 里的点
  逐个往回找，找出所有能落到 `T` 里的自变量”。前者可能把不同点压成同一个值（`sq` 把
  `-1` 和 `1` 都送到 `1`），后者不会漏（`sq ⁻¹' {1} = {-1,1}` 把两个来源都收进来）。
- 单射 = “不会撞车”，满射 = “目标全覆盖”。`2n+1` 不撞车但漏掉所有偶数；
  `n/2` 全覆盖但 `0` 与 `1` 撞在一起。两者互不推出。
- 原像对并、交都“全通”，像只对并全通、对交只能得到包含：`sq '' ({-1} ∩ {1}) = ∅`，
  而 `sq '' {-1} ∩ sq '' {1} = {1}`。

# 陈述（自然语言）

**正例（定义展开与计算）**：

1. 定义展开：`doubleAddOne n = 2n+1`、`half n = n/2`、`sq n = n²`、`shift n = n+1`；
2. 线性函数的像与原像：`doubleAddOne '' {0,1,2} = {1,3,5}`，
   `doubleAddOne '' {1,2,3} = {3,5,7}`，`doubleAddOne ⁻¹' {1,3,5} = {0,1,2}`；
3. 原像的分片计算：`doubleAddOne ⁻¹' {1,3} = {0,1}`，`doubleAddOne ⁻¹' {3,5} = {1,2}`，
   `doubleAddOne ⁻¹' {3,5,7} = {1,2,3}`；
4. 原像保并：`doubleAddOne ⁻¹' ({1,3} ∪ {3,5}) = doubleAddOne ⁻¹' {1,3} ∪ doubleAddOne ⁻¹' {3,5}`
   （两侧都算成 `{0,1,2}`）；原像保交：`doubleAddOne ⁻¹' ({1,3,5} ∩ {3,5,7}) =
   doubleAddOne ⁻¹' {1,3,5} ∩ doubleAddOne ⁻¹' {3,5,7}`（两侧都算成 `{1,2}`）；
5. 平方函数的像与原像：`sq '' {0,1,2} = {0,1,4}`，`sq ⁻¹' {1} = {-1,1}`，
   `sq ⁻¹' {4} = {-2,2}`；
6. 单射时像保交（正例）：`doubleAddOne '' (S ∩ T) = doubleAddOne '' S ∩ doubleAddOne '' T`
   （两侧都算成 `{3,5}`，其中 `S = {0,1,2}`、`T = {1,2,3}`）；
7. 双射：`shift` 双射，逆映射 `g n = n - 1` 同时是左逆与右逆；并且
   `shift` 双射 ⟺ 存在这样的 `g`（理论条目 `bijective-iff-inverse` 的实例）；
8. 复合：`(shift ∘ shift) 0 = 2`，且 `shift ∘ shift` 单射、满射、双射。

**反例（逐条写清前件与后件）**：

- **反例 1（单射不必满射）**：`doubleAddOne` 满足**前件**“单射”，
  但不满足**后件**“满射”——偶数 `0` 没有原像（`2n+1` 恒为奇数）。
  精确陈述：`Function.Injective doubleAddOne ∧ ¬ Function.Surjective doubleAddOne`。
- **反例 2（满射不必单射）**：`half` 满足**前件**“满射”（任意 `m` 有原像 `2m`），
  但不满足**后件**“单射”——`half 0 = half 1 = 0`。
  精确陈述：`Function.Surjective half ∧ ¬ Function.Injective half`。
- **反例 3（像不保持交）**：取 `A = {-1}`、`B = {1}`。左边 `sq '' (A ∩ B) = sq '' ∅ = ∅`，
  右边 `sq '' A ∩ sq '' B = {1} ∩ {1} = {1}`，故
  `sq '' (A ∩ B) ≠ sq '' A ∩ sq '' B`；见证 `1 ∈ 右边` 而 `1 ∉ 左边`。
  一般否定命题：`∃ A B : Set ℤ, sq '' (A ∩ B) ≠ sq '' A ∩ sq '' B`。
  它反驳“像总保持交”的误命题；无条件成立的只有包含方向
  `sq '' (A ∩ B) ⊆ sq '' A ∩ sq '' B`。

# 陈述（Lean 对照）

```lean
def doubleAddOne (n : ℕ) : ℕ := 2 * n + 1
def half (n : ℕ) : ℕ := n / 2
def sq (n : ℤ) : ℤ := n ^ 2
def shift (n : ℤ) : ℤ := n + 1

theorem image_doubleAddOne_S : doubleAddOne '' S = ({1, 3, 5} : Set ℕ)
theorem preimage_doubleAddOne : doubleAddOne ⁻¹' ({1, 3, 5} : Set ℕ) = S
theorem preimage_union_instance :
    doubleAddOne ⁻¹' (({1, 3} : Set ℕ) ∪ {3, 5}) =
      doubleAddOne ⁻¹' ({1, 3} : Set ℕ) ∪ doubleAddOne ⁻¹' ({3, 5} : Set ℕ)
theorem preimage_inter_instance :
    doubleAddOne ⁻¹' (({1, 3, 5} : Set ℕ) ∩ {3, 5, 7}) =
      doubleAddOne ⁻¹' ({1, 3, 5} : Set ℕ) ∩ doubleAddOne ⁻¹' ({3, 5, 7} : Set ℕ)

theorem image_sq_zero_one_two : sq '' ({0, 1, 2} : Set ℤ) = ({0, 1, 4} : Set ℤ)
theorem preimage_sq_one : sq ⁻¹' ({1} : Set ℤ) = ({-1, 1} : Set ℤ)
theorem image_inter_doubleAddOne :
    doubleAddOne '' (S ∩ T) = doubleAddOne '' S ∩ doubleAddOne '' T

theorem doubleAddOne_injective_not_surjective :
    Function.Injective doubleAddOne ∧ ¬ Function.Surjective doubleAddOne
theorem half_surjective_not_injective :
    Function.Surjective half ∧ ¬ Function.Injective half
theorem sq_image_inter_ne :
    sq '' (negOne ∩ posOne) ≠ sq '' negOne ∩ sq '' posOne
theorem exists_image_inter_ne :
    ∃ A B : Set ℤ, sq '' (A ∩ B) ≠ sq '' A ∩ sq '' B
theorem image_sq_inter_subset :
    sq '' (negOne ∩ posOne) ⊆ sq '' negOne ∩ sq '' posOne

theorem shift_bijective : Function.Bijective shift
theorem shift_bijective_iff_inverse :
    Function.Bijective shift ↔
      ∃ g : ℤ → ℤ, Function.LeftInverse g shift ∧ Function.RightInverse g shift
theorem shift_comp_bijective : Function.Bijective (shift ∘ shift)
```

# 思维脉络

1. **先命名函数与集合**：四个 `def` 与四个 `abbrev` 让后续每条定理都能写成短签名，
   避免把 `fun n => 2 * n + 1` 反复内联。
2. **像的计算**：`ext y` 后左方向用 `rintro ⟨x, hx, rfl⟩` 取出见证并枚举 `hx` 的三种可能，
   每支 `norm_num` 算出具体值；右方向直接给出 `⟨0, …⟩` 形式的见证。
3. **原像的计算**：`ext x` 后目标变成“`2x+1 ∈ {1,3,5}` ⟺ `x ∈ {0,1,2}`”这类算术命题，
   用 `simp only` 展开成员条件后交给 `omega`；平方的原像需要解 `x² = 1`，
   用因式分解 `(x-1)(x+1) = 0` 配 `mul_eq_zero` 拆成两支，再 `linarith` 定符号。
4. **恒等式靠“两侧都算出来”**：`preimage_union_instance`、`preimage_inter_instance` 都是
   先把两边的原像算成显式集合，再用 `ext` + `omega` 对齐，而不是直接引用一般定理。
5. **反例给足见证**：`doubleAddOne_not_surjective` 用 `0` 无原像；
   `half_not_injective` 用 `0`、`1` 撞车；`sq_image_inter_ne` 用 `1 ∈ 右边 \ 左边`。
   每条反例都单独给出“前件成立 ∧ 后件不成立”的合取陈述。
6. **双射走等价刻画**：`shift_bijective` 经理论条目 `bijective-iff-inverse` 用显式逆
   `g n = n - 1` 证出，顺带演示了该等价定理两侧如何互相读取。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 线性函数 `2n+1` | `doubleAddOne : ℕ → ℕ` |
| 折半函数 `n/2` | `half : ℕ → ℕ` |
| 平方函数 `n²` | `sq : ℤ → ℤ` |
| 平移函数 `n+1` | `shift : ℤ → ℤ` |
| 像 | `f '' S`（成员展开 `Set.mem_image`） |
| 原像 | `f ⁻¹' T`（成员展开 `Set.mem_preimage`） |
| 单射 / 满射 / 双射 | `Function.Injective` / `Surjective` / `Bijective` |
| 左逆 / 右逆 | `Function.LeftInverse` / `RightInverse` |
| 函数复合 | `shift ∘ shift`（`Function.comp`） |
| “逐元素求值” | `ext` + `rintro ⟨x, hx, rfl⟩` + `norm_num` / `omega` |

# 依赖（人话版）

- `settheory.function.image-preimage.preimage-union`：`preimage_union_instance` 的抽象原型。
- `settheory.function.image-preimage.preimage-inter`：`preimage_inter_instance` 的抽象原型。
- `settheory.function.inj-comp`：`shift_comp_injective` 直接调用它。
- `settheory.function.surj-comp`：`shift_comp_surjective` 直接调用它（Lean 声明名是
  `surjective_comp`，与 Entry id `surj-comp` 不同名）。
- `settheory.function.inject-surject.bijective-iff-inverse`：`shift_bijective_iff_inverse`
  与 `shift_bijective` 使用的等价刻画。
- `settheory.set.ext`：所有像／原像等式的降维入口。
- Mathlib 角色：`Set.mem_image`、`Set.mem_preimage`、`Set.mem_insert_iff`、
  `Set.mem_singleton_iff`、`Set.mem_inter_iff`、`Set.image_empty`、`Nat.mul_div_right`、
  `mul_eq_zero` 是证明后端（成员展开与算术）；`Set.image_inter_subset` 是“像与交”的
  正式承载（本 Entry 用它给出无条件成立的包含方向）；`Function.Injective` 等是单射／满射
  ／双射的正式承载。

# 应用与陷阱

- **应用**：像／原像是拓扑与分析里“用原像定义开集”的起点；本 Entry 的
  `sq ⁻¹' {1} = {-1,1}` 与 `sq '' ({-1} ∩ {1}) = ∅` 是“原像保交、像不保交”的最小模型。
- **陷阱 1**：单射 **不**蕴含满射（反例 1），满射 **不**蕴含单射（反例 2）；
  只有在“有限集到同基数有限集”这类额外条件下两者才等价——本 Entry 的函数都定义在无限集上，
  所以两个方向都能失败。
- **陷阱 2**：像不保持交（反例 3）。无条件成立的只有
  `f '' (A ∩ B) ⊆ f '' A ∩ f '' B`；等式需要单射（正例 6 演示了单射时等式成立）。
- **陷阱 3**：原像里可能有两个不同的点（`sq ⁻¹' {1} = {-1,1}`），
  这正是“原像保交但像不保交”的同一个事实的另一面。
- **陷阱 4**：`half` 的满射性依赖自然数除法的取整约定（`(2m)/2 = m`）；
  若换成实数除法，`half` 反而变成双射。
