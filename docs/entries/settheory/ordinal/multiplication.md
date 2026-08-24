---
id: settheory.ordinal.multiplication
kind: definition
state: verified
title: "序数乘法不交换"
premises: ["settheory.ordinal.addition"]
mathlib: ["Ordinal.type", "Ordinal.type_prod_lex", "Ordinal.mul_succ", "Ordinal.natCast_mul_omega0", "Ordinal.mul_two"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Ordinal Arithmetic"}
---

# 动机
序数乘法也必须从良序构造，而不能把 mathlib 的 `*` 当作教材定义直接包装。

# 直觉
用右因子给副本编号，每个副本内部按左因子排列，并让较早编号的整块排在较晚编号之前。

# 陈述（自然语言）
定义 `ordinalMul a b` 为 `b.ToType × a.ToType` 上字典序的序型。它满足
`ordinalMul a (succ b) = ordinalAdd (ordinalMul a b) a`，且
`ordinalMul 2 ω=ω` 而 `ordinalMul ω 2≠ω`。

# 陈述（Lean 对照）
```lean
def ordinalMul (a b : Ordinal) : Ordinal :=
  Ordinal.type (Prod.Lex ((· < ·) : b.ToType → b.ToType → Prop)
    ((· < ·) : a.ToType → a.ToType → Prop))
```

`ordinalMul_zero`、`ordinalMul_succ` 给出递推方程，`multiplication_not_commutative` 给出反例。

# 思维脉络（thinking trace）
1. 在 `b × a` 上取字典序，表达按 `b` 编号的多个 `a` 副本。
2. 取其序型作为公开定义 `ordinalMul`。
3. 私有桥只验证它与 mathlib 实现一致。
4. 后继递推的右侧明确调用本库 `ordinalAdd`，形成“加法定义 → 乘法定义”的依赖链。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 字典序副本族 | `Prod.Lex` |
| 本库序数乘法 | `ordinalMul a b` |
| 乘法后继递推 | `ordinalMul_succ` |

# 依赖（人话版）
使用本库 `ordinalAdd` 表达新增一个左因子副本的后继递推。

# “多少个副本”由右因子决定

`ordinalMul a b` 表示按 `b` 的顺序排列 `b` 个 `a` 的副本。因此载体写成
`b.ToType × a.ToType`：第一坐标指出当前位于第几个副本，第二坐标指出在该副本内部的位置。
字典序首先比较副本编号，只有位于同一副本时才比较内部位置。

这也解释了为什么顺序不能写反。`ordinalMul a b` 是“`b` 个 `a`”，而不是“`a` 个 `b`”。

# 具体例子

- `ordinalMul 3 2` 是两个三点块首尾相接，序型为有限序数 `6`。
- `ordinalMul 2 ω=ω`：有 `ω` 个二点块，依次编号仍可排成一个自然数列。
- `ordinalMul ω 2=ω+ω`：只有两个块，但每块已经是完整的 `ω`；必须走完第一条自然数列，
  才进入第二条，因此严格大于 `ω`。

# 递推方程

零个 `a` 副本给出零：`ordinalMul a 0=0`。`succ b` 个副本等于先放 `b` 个副本，再在末尾
增加一个 `a`，所以
`ordinalMul a (succ b)=ordinalAdd (ordinalMul a b) a`。这条公式明确使用本库加法，
而不是把 mathlib 乘法当黑箱。

# 应用与陷阱
mathlib 原生 `*` 只允许出现在私有验证桥及桥之后的证明后端中。序数乘法通常不交换。
- 与普通代数习惯相比，必须牢牢记住右因子控制副本数。
- `2·ω=ω` 与 `ω·2=ω+ω` 的差异来自块的排列次序，不来自基数大小。
