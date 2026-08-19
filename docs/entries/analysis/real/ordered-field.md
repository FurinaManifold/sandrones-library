---
id: analysis.real.ordered-field
family: analysis.real
variant: ecnu
kind: theorem
state: verified
title: 实数是有序域
summary: ℝ 是线性有序环（Field+全序+序环相容）
premises: []
mathlib: [IsStrictOrderedRing ℝ, Field ℝ, ConditionallyCompleteLinearOrder ℝ]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第二章（数列极限·预备）"
---

# 动机

实数的全部理论建立在"实数是有序域"这一结构之上：加法、乘法与序必须和谐共处
（正数之和为正、正数之积为正、序对加法/乘法有平移/放大性质）。确界原理、
极限论都是在这块地基上盖起来的。

# 直觉

有序域 = "四则运算" + "比大小" 两套语言兼容：a < b 两边同加 c、同乘正数都不改变方向。
有理数 ℚ 也是有序域；实数多出来的东西是**完备性**（见 sup 条目），有序域本身不唯一。

# 陈述（自然语言）

实数集 ℝ 在通常的加、乘与序关系下构成一个线性有序域：
- 域：加、乘、分配律、逆元（0 与 1 之外每个元素有倒数）；
- 全序：任意两数可比；
- 相容：x < y 且 c > 0 ⟹ c·x < c·y；x < y ⟹ x + c < y + c。

# 陈述（Lean 对照）

```lean
theorem real_ordered_field : IsStrictOrderedRing ℝ := by
  infer_instance
```

| 人话 | Lean |
|---|---|
| 有序环 | `IsStrictOrderedRing ℝ`（序与环相容） |
| 域结构 | `Field ℝ` |
| 条件完备线性序（sSup 存在） | `ConditionallyCompleteLinearOrder ℝ` |

> 注意：mathlib 4.33 已把老的 `LinearOrderedField` 类拆散成
> `Field` + `LinearOrder` + `IsStrictOrderedRing` + `ConditionallyCompleteLinearOrder`
> 的组合（官方弃用提示）。本条目确认核心的"序环相容"结构。

# 思维脉络（thinking trace）

1. **定位概念**：教材说"实数是有序域"，数学结构是域 + 全序 + 相容性。
2. **拆到 mathlib 4.33 的类**：老的 `LinearOrderedField` 已不存在，被拆成四个类。
   `IsStrictOrderedRing ℝ` 恰好覆盖"序环相容"这一核心。
3. **证明**：这些都是 mathlib 已注册的实例，`infer_instance` 按实例图解析即可。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 有序域 | `Field α` + `LinearOrder α` + `IsStrictOrderedRing α` |
| 序环相容 | `IsStrictOrderedRing` |

# 依赖（人话版）

无库内依赖（mathlib 已提供全部实例）。

# 公理依赖（#print axioms）

```
real_ordered_field 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：mathlib 4.33 的 `ℝ` 序结构实例（`instLEReal`、`LinearOrder ℝ`）
定义体本身是经典构造的。已实测：连 `a ≤ b ↔ a ≤ b := by rfl`（证明体为 `Iff.rfl`）
都报告 `Classical.choice`，而 ℕ/ℚ 的同款 rfl 为零公理。因此凡涉及 ℝ 序性质的命题
必带 choice——这是结构底线。本条目为 `infer_instance`，choice 全部来自结构本身。

# 应用与陷阱

**应用**：
- 一切使用不等式论证的实分析结果的公共地基。
- 与 `archimedean`、`sup` 组合成"实数的序结构"完整图景。

**陷阱**：
- **别找 `LinearOrderedField`**：在 mathlib 4.33 里这个名字已弃用/不存在，
  用 `Field ℝ` + `IsStrictOrderedRing ℝ` + `ConditionallyCompleteLinearOrder ℝ`。
- 有序域 ≠ 完备：ℚ 是有序域但无确界原理。别把"有序"与"完备"混为一谈。