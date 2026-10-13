---
id: number-theory.algebraic.number-field
family: number-theory.algebraic
variant: textbook
kind: definition
state: verified
title: 数域与有限扩张
summary: 数域是特征零且作为 ℚ-向量空间有限维的域；对有限扩张与子域封闭，并有单生成元定理
premises: []
mathlib: [NumberField, NumberField.of_module_finite, NumberField.of_subfield, NumberField.isAlgebraic, Field.exists_primitive_element]
provenance:
  source_type: book
  ref: "ireland-rosen-number-theory-1990"
---

# 动机

代数数论的第一步是把研究对象从 `ℤ`、`ℚ` 搬到「`ℚ` 的有限扩张」上。只有先固定这个对象，
后面的代数整数、整数环、范数与迹、理想分解才有共同的宿主。本节因此先给出一门课里最先出现
的对象：数域，以及它最基本的封闭性与单生成元性质。

# 直觉

数域就是「把 `ℚ` 按有限多次代数添加扩大得到的域」。因为它只是把有限多个代数数添进去，
所以它作为 `ℚ`-向量空间是有限维的，维数就是扩张次数 `[K : ℚ]`。有限维立刻带来两个好处：
每个元素都是代数数，而且整个域可以用单个元素生成（单生成元定理）。这两个事实是后续所有
计算的前提。

# 陈述（自然语言）

一个域 `K` 称为数域，若其特征为零，且作为 `ℚ`-向量空间是有限维的。数域满足：

1. 每个元素都是 `ℚ` 上的代数元；
2. 任何有限扩张还是数域；
3. 任何子域还是数域；
4. 它是 `ℚ` 的单扩张：存在 `α ∈ K` 使得 `ℚ(α) = K`。

# 陈述（Lean 对照）

```lean
theorem numberField_iff (K : Type*) [Field K] [CharZero K] :
    NumberField K ↔ FiniteDimensional ℚ K

theorem numberField_finiteDimensional (K : Type*) [Field K] [NumberField K] :
    FiniteDimensional ℚ K

theorem numberField_isAlgebraic (K : Type*) [Field K] [NumberField K] :
    Algebra.IsAlgebraic ℚ K

theorem numberField_of_module_finite (K L : Type*) [Field K] [Field L] [NumberField K]
    [Algebra K L] [Module.Finite K L] : NumberField L

theorem numberField_of_subfield (K : Type*) [Field K] [NumberField K] (E : Subfield K) :
    NumberField E

theorem numberField_exists_primitive_element (K : Type*) [Field K] [NumberField K] :
    ∃ α : K, IntermediateField.adjoin ℚ ({α} : Set K) = ⊤
```

Lean 的正式承载是 Mathlib 类 `NumberField`，它要求 `CharZero K` 与 `FiniteDimensional ℚ K`，
与教材定义逐字一致。`numberField_iff` 把这个类展开成读者可见的「特征零 + 有限维」；其余定理
以这个类为前提，展示教材结论。

# 思维脉络（thinking trace）

1. 教材定义「`ℚ` 的有限扩张」在 Mathlib 中已经存在，语义完全一致，因此不另建结构，直接以
   `NumberField` 为正式承载。
2. 为了让读者能操作这个类，先给出 `numberField_iff`，把类展开为 `CharZero K` 与
   `FiniteDimensional ℚ K` 两条可由类型类检索的条件。
3. `numberField_isAlgebraic` 取 Mathlib 的 `NumberField.isAlgebraic`：有限维蕴含代数性。
4. 封闭性两条分别对应 Mathlib 的有限扩张与子域接口；它们的证明依赖塔性质与子空间维数。
5. 单生成元定理由 `Field.exists_primitive_element` 给出，其可分性前提在特征零时自动成立。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 数域 | `NumberField K` |
| 特征零 | `CharZero K` |
| 作为 `ℚ`-向量空间有限维 | `FiniteDimensional ℚ K` |
| 数域是有限维 `ℚ`-向量空间 | `numberField_finiteDimensional K` |
| 元素都是代数元 | `Algebra.IsAlgebraic ℚ K` |
| 有限扩张仍是数域 | `numberField_of_module_finite K L` |
| 子域仍是数域 | `numberField_of_subfield K E` |
| 单生成元 | `numberField_exists_primitive_element K` |

# 依赖（人话版）

- `NumberField`：Mathlib 的数域类，本条目全部陈述的正式承载，语义与教材定义一致。
- `CharZero K`：特征零，数域定义的一半；它在域上唯一决定 `ℚ`-代数结构。
- `FiniteDimensional ℚ K`：数域定义的另一半，即扩张次数有限。
- `Field.exists_primitive_element`：有限可分扩张的单生成元定理；数域特征零，故可分性自动成立。
- 本条目没有库内前提；它是 N2.2、N2.3 以及后续范数、迹、判别式的基础。

# 应用与陷阱

- 应用：N2.2 的代数整数和 N2.3 的整数环都以数域为宿主；`numberField_of_module_finite`
  说明扩大数域不会跑出数域范畴。
- 陷阱：「`K` 是 `ℚ` 的代数扩张」与「`K` 是数域」不等价；必须是**有限**代数扩张。
  `numberField_iff` 的右端始终含 `FiniteDimensional`。
- 陷阱：`ChainComplex` 等其它 `ℚ`-结构不在这里出现。本节只讲域扩张，不涉及赋值、理想或
  局部化；这些是后续批次的内容。
- 未完成边界：不涉及域嵌入个数、范数与迹、判别式；也不构造具体的数域例子（如二次域）。
