---
id: examples.settheory.ordinals
kind: example
state: verified
title: 序数 0,1,2,ω,ω+1 的序关系与后继／极限辨析
summary: 把 ω+1 命名并证明它是 ω 的后继，给出 0<1<2<ω<ω+1 的序关系链、极限序数与后继序数的区分，以及 1+ω=ω 但 ω+1≠ω 的加法不交换反例
premises: [settheory.ordinal.addition, settheory.ordinal.successor-limit]
mathlib: [Ordinal.natCast_lt_omega0, Order.not_isSuccLimit_succ, Order.lt_succ, Order.succ_eq_add_one]
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

`settheory.ordinal.order-type` 把序数定义为良序的序型，`settheory.ordinal.addition`
用「前后拼接」定义序数加法，`settheory.ordinal.successor-limit` 则给出后继序数与极限序数的
基本性质。这三个定义在 `0,1,2,ω,ω+1` 这五个最小的序数上就能看出全部要害：
序关系是否真的排成一条链、`ω+1` 到底是不是后继、`ω` 与 `ω+1` 谁是极限序数，
以及加法为什么不能交换。本 Entry 把这五个对象显式摆出来，让每条断言都可被编译器核对。

# 直觉

- 有限序数 `0,1,2` 就是自然数的序型；它们都排在 `ω` 前面，因为 `ω` 是全体自然数的序型。
- `ω` 没有前一个序数：它不是任何序数的后继，所以叫**极限序数**。
- `ω + 1` 是把一个点接在 `ω` 后面，因此它是 `ω` 的后继，比 `ω` 多一个点。
- 但把 `1` 接在 `ω` 前面不改变序型：`1 + ω = ω`。接在前面被 `ω` 的无限尾巴「吸收」了，
  接在后面则多出一个新的末元——这就是加法不交换的直观来源。

# 陈述（自然语言）

1. `ω + 1`（即本库加法 `ordinalAdd ω 1`）等于 `succ ω`，因此 `ω < ω + 1`。
2. 序关系链：`0 < 1 < 2 < ω < ω + 1`。
3. `ω` 是极限序数：`IsSuccLimit ω`。
4. 任何后继序数都不是极限序数：`¬ IsSuccLimit (succ a)`。
5. 后继是紧邻的：`a < succ a`，且不存在序数严格落在 `a` 与 `succ a` 之间。
6. `ω + 1` 是后继序数（存在 `a` 使 `ω + 1 = succ a`），而 `ω` 不是。
7. **反例（序数加法不交换）**：前件取 `a = 1`、`b = ω`。`1 + ω = ω` 成立，
   而 `ω + 1 ≠ ω` 也成立（由 `ω < ω + 1`）。于是 `1 + ω ≠ ω + 1`：
   两个加数交换后结果不同。这否定了「序数加法像自然数加法那样可交换」这一误认。

# 陈述（Lean 对照）

```lean
-- 命名对象
def omegaPlusOne : Ordinal := ordinalAdd Ordinal.omega0 1
theorem omegaPlusOne_def : omegaPlusOne = ordinalAdd Ordinal.omega0 1 := rfl

-- 后继与序关系链
theorem omegaPlusOne_eq_succ_omega : omegaPlusOne = Order.succ Ordinal.omega0
theorem omega_lt_omegaPlusOne : Ordinal.omega0 < omegaPlusOne
theorem zero_lt_one_lt_two_lt_omega_lt_omegaPlusOne :
    (0 : Ordinal) < 1 ∧ (1 : Ordinal) < 2 ∧ (2 : Ordinal) < Ordinal.omega0 ∧
      Ordinal.omega0 < omegaPlusOne

-- 后继／极限辨析
theorem omega_is_limit : Order.IsSuccLimit Ordinal.omega0
theorem succ_not_limit (a : Ordinal) : ¬ Order.IsSuccLimit (Order.succ a)
theorem succ_is_immediate (a : Ordinal) :
    a < Order.succ a ∧ ∀ b, a < b → ¬ b < Order.succ a
theorem omega_limit_but_omegaPlusOne_not :
    Order.IsSuccLimit Ordinal.omega0 ∧ ¬ Order.IsSuccLimit omegaPlusOne
theorem omegaPlusOne_is_successor : ∃ a : Ordinal, omegaPlusOne = Order.succ a

-- 反例：加法不交换
theorem one_add_omega_eq_omega : ordinalAdd (1 : Ordinal) Ordinal.omega0 = Ordinal.omega0
theorem omega_add_one_ne_omega : omegaPlusOne ≠ Ordinal.omega0
theorem one_add_omega_ne_omega_add_one :
    ordinalAdd (1 : Ordinal) Ordinal.omega0 ≠ omegaPlusOne
```

# 思维脉络

先把 `ω + 1` 命名成 `omegaPlusOne`，并用 `rfl` 记下它的定义展开——这样后续每条证明都能
用 `rw [omegaPlusOne_def]` 精确控制展开时机（`abbrev` 在 `rw` 下不自动展开，`def` + 展开引理
更可控）。

`omegaPlusOne_eq_succ_omega` 的关键是把 `1` 看成 `succ 0`：序数加法在后继处的递推式
`ordinalAdd_succ` 与 `ordinalAdd_zero` 立刻给出 `ordinalAdd ω 1 = succ (ordinalAdd ω 0) = succ ω`。
有了它，`ω < ω + 1` 就是 `Order.lt_succ`；而 `2 < ω` 用 `Ordinal.natCast_lt_omega0`；
`0 < 1 < 2` 交给 `norm_num` 在序数上直接求值。四段拼起来就是序关系链。

后继／极限部分分三层：`omega_is_limit` 取本库 `successor_and_limit` 的极限分量；
`succ_not_limit` 用 mathlib 的 `Order.not_isSuccLimit_succ`；`succ_is_immediate` 取
`successor_and_limit` 的前两个分量。最后把两者合起来，说明 `ω` 与 `ω + 1` 恰好是
「极限 vs 后继」的一对样本。

反例部分刻意分成两句：`1 + ω = ω` 直接引用本库的 `addition_not_commutative`（这正是该定理的
左半），而 `ω + 1 ≠ ω` 则从上面独立算出的 `ω < ω + 1` 得到，不依赖同一个定理。
两句合起来给出 `1 + ω ≠ ω + 1`——交换两个加数结果不同。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 第一个无限序数 `ω` | `Ordinal.omega0` |
| `ω + 1` | `omegaPlusOne`（`= ordinalAdd Ordinal.omega0 1`） |
| 后继序数 `succ a` | `Order.succ a` |
| 「`a` 是极限序数」 | `Order.IsSuccLimit a` |
| 「`a < b` 且两者紧邻」 | `a < b ∧ ∀ c, a < c → ¬ c < b` |
| 序数加法 | `ordinalAdd a b`（本库定义） |
| 自然数序数 `n` | `(n : Ordinal)` |

# 依赖（人话版）

- `settheory.ordinal.addition`：提供 `ordinalAdd` 及其后继递推式 `ordinalAdd_succ`、
  `ordinalAdd_zero`，以及「加法不交换」的库内结论 `addition_not_commutative`。
- `settheory.ordinal.successor-limit`：提供 `successor_and_limit`，即「后继紧邻」与
  「`ω` 是极限序数」两个事实；本 Entry 的 `omega_is_limit`、`succ_is_immediate` 都取自它。
- mathlib 只补充「自然数序数小于 `ω`」（`Ordinal.natCast_lt_omega0`）与「后继不是极限」
  （`Order.not_isSuccLimit_succ`）这两条通用接口。

# 应用与陷阱

- **应用**：这条链是超限归纳、超限递归「零／后继／极限」三分法的第一组样本；
  后续 Goodstein 与 `ε₀` 的讨论都以「`ω` 是极限、`ω+1` 是后继」为起点。
- **陷阱一**：不要把 `ω + 1` 与 `1 + ω` 混为一谈。前者是 `ω` 的后继，后者仍是 `ω`。
  加法可交换是自然数的性质，不是序数的性质；反例给出的两个序数 `1 + ω` 与 `ω + 1` 甚至
  连「是不是极限序数」都不同。
- **陷阱二**：`ω + 1` 与 `ω` 之间没有别的序数（`succ_is_immediate`），但这不意味着
  `ω + 1` 「紧挨着」某个具体的自然数；它紧挨的是 `ω` 本身。
- **陷阱三**：本库的 `ordinalAdd` 是 `def`，公开接口只有 `ordinalAdd_zero`／`ordinalAdd_succ`
  等递推式，没有把 mathlib 原生 `+` 暴露出来。因此本 Entry 中 `1 + ω = ω` 只能走
  `addition_not_commutative`，而 `ω < ω + 1` 走本库的后继递推式——这正是「先证明定义展开
  与基本性质，再证它是目标概念的实例」的顺序。
