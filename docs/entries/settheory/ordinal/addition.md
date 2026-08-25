---
id: settheory.ordinal.addition
kind: definition
state: verified
title: "序数加法不交换"
premises: ["settheory.ordinal.order-type"]
mathlib: ["Ordinal.type", "Ordinal.type_sum_lex", "Ordinal.add_omega0", "Order.lt_succ"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机
序数不能先假定已有加法再讨论性质；加法本身必须从良序构造出来。

# 直觉
先排完 `a` 的全部元素，再排 `b` 的全部元素；这个不交并上的良序序型定义 `a` 加 `b`。

# 陈述（自然语言）
定义 `ordinalAdd a b` 为 `a.ToType ⊕ b.ToType` 上“左块全部早于右块”的 `Sum.Lex`
良序之序型。它满足零与后继递推，并且 `ordinalAdd 1 ω=ω`，而
`ordinalAdd ω 1≠ω`。

# 陈述（Lean 对照）
```lean
def ordinalAdd (a b : Ordinal) : Ordinal :=
  Ordinal.type (Sum.Lex ((· < ·) : a.ToType → a.ToType → Prop)
    ((· < ·) : b.ToType → b.ToType → Prop))
```

`ordinalAdd_zero`、`ordinalAdd_succ` 给出递推方程，`addition_not_commutative` 给出反例。

# 思维脉络（thinking trace）
1. 用 `Sum.Lex` 在两个良序的不交并上建立“先左后右”的良序。
2. 取该良序的 `Ordinal.type`，作为本库公开定义，而不是调用原生 `+`。
3. 私有桥 `ordinalAdd_eq_mathlib` 只负责把本库定义交给 mathlib 内核验证。
4. 由桥验证零、后继递推和非交换反例；公开结论全部使用 `ordinalAdd`。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| ω | `Ordinal.omega0` |
| 两个良序前后拼接 | `Sum.Lex` |
| 本库序数加法 | `ordinalAdd a b` |
| 后继 | `Order.succ` / `+ 1` |

# 依赖（人话版）
依赖 `settheory.ordinal.order-type`：加法的结果是拼接良序的序型。

# 拼接模型

`ordinalAdd a b` 的含义不是把两个“数量”相加，而是做如下操作：先完整走过一份 `a`，然后再
完整走过一份 `b`。`Sum.Lex` 给两个副本加上左右标签，避免它们的元素混在一起，并规定：

- 左副本内部保持 `a` 的次序；
- 右副本内部保持 `b` 的次序；
- 每个左副本元素都早于每个右副本元素。

最后取这个新良序的序型，得到 `ordinalAdd a b`。

# 有限例子与无限例子

- `ordinalAdd 2 3 = 5`：先两个点，再三个点，总形状仍是五点有限链。
- `ordinalAdd 1 ω = ω`：先放一个额外点，再接无穷自然数列；把额外点编号为 `0`，后面的点
  依次编号为 `1,2,3,…`，整体仍与自然数列序同构。
- `ordinalAdd ω 1 = succ ω`：先走完全部自然数，再出现一个末尾点。自然数列本身没有末尾，
  所以这个新点无法被重新编号吸收到原来的 `ω` 中。

这解释了非交换性：左右顺序改变的是良序形状，而不只是底集大小。

# 递推方程怎样从模型中读出

`ordinalAdd a 0=a`，因为在 `a` 后面什么也不接。若右侧是 `succ b`，它由一份 `b` 再加一个
末尾点组成，所以 `ordinalAdd a (succ b)=succ (ordinalAdd a b)`。这正是
`ordinalAdd_zero` 和 `ordinalAdd_succ` 的内容。

# 应用与陷阱
`Ordinal` 的原生 `+` 仅出现在私有正确性桥中，不能作为本条目的公开定义。不可把自然数
加法的交换律自动迁移到序数。
- 序数加法结合但不交换；“底集等势”不足以推出序数相等。
- `1+ω=ω` 不是说有限的一被数值上抹掉，而是两个良序存在序同构。
