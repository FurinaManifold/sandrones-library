---
id: settheory.googology.hydra-ordinal-assignment
kind: theorem
state: verified
title: "Hydra 的结构性序数赋值与两个已验证接口"
premises: ["settheory.googology.hydra-game-step", "settheory.ordinal.addition", "settheory.ordinal.exponentiation"]
mathlib: ["Order.lt_succ"]
provenance: {source_type: book, ref: "Laurie Kirby and Jeff Paris, Accessible Independence Results for Peano Arithmetic, 1982; 本条仅形式化后续下降证明所需的结构性入口"}
---

# 动机

只观察 Hydra 的节点数不能证明游戏终止，因为一次砍头可能复制许多子树，使有限节点数反而增加。经典思路是给树分配序数：树在自然数大小上可以长大，但若每个合法步骤都让某个良基序数严格下降，就不可能无限进行。不过，“写出一个看起来像序数的式子”不等于已经证明完整下降。本条先构造可检查的赋值，再只证明当前接口足以支持的两个事实，为深层复制分析准备代数零件。

# 直觉

把根的孩子从左到右看成若干项。一个孩子贡献 `ω` 的“该孩子自身复杂度”次幂，然后按孩子顺序做序数加法。叶子没有孩子，所以复杂度是零；因此一个叶头对子树列表贡献 `ω⁰=1`。若它是根下最右边的头，删除前的值恰好是删除后的后继，当然严格变小。若某棵砍头后的父子树被复制多份，它们的贡献则变成同一序数项的有限重复和，这正好隔离出阶段再生需要进一步比较的部分。

# 陈述（自然语言）

`hydraOrdinal` 与 `forestOrdinal` 相互递归：节点的值是其孩子列表的值；空列表值为零；以 `child` 开头的列表值为 `ω^(child 的值)` 与剩余列表值的本库序数加法。`ordinalRepeat term n` 用本库序数加法定义 `term` 的 `n` 次有限重复和。若一步只删除根下最右端的叶头，则赋值严格下降。另一方面，同一父子树复制 `copies` 份后的森林值，等于该父子树贡献项的 `copies` 次重复和。

# 陈述（Lean 对照）

```lean
noncomputable def hydraOrdinal : Hydra → Ordinal
noncomputable def forestOrdinal : List Hydra → Ordinal
noncomputable def ordinalRepeat (term : Ordinal) : Nat → Ordinal
def RightmostRootHeadCut (before after : Hydra) : Prop

theorem rightmostRootHeadCut_decreases
    (cut : RightmostRootHeadCut before after) :
    hydraOrdinal after < hydraOrdinal before

theorem forestOrdinal_replicate (copies : Nat) (parent : Hydra) :
    forestOrdinal (List.replicate copies parent) =
      ordinalRepeat
        (ordinalPow Ordinal.omega0 (hydraOrdinal parent)) copies
```

# 思维脉络（thinking trace）

第一步遵守本库“先定义运算再使用”的边界：赋值没有直接写 Mathlib 原生的序数 `+`、`*`、`^`，而是调用已经从良序拼接和超限递归建立的 `ordinalAdd`、`ordinalPow`。第二步把树值和森林值互递归，使节点构造与 Cantor 风格的有序和逐层对应。第三步选择能够无额外正规形假设闭合的严格下降子类：最右根头的贡献位于和式末端，追加该头正好把原值变成后继。第四步把深层再生中的 `List.replicate` 变成 `ordinalRepeat`，从树操作转换为以后可单独研究的序数不等式。

# 自然语言 ↔ Lean 映射

“树的复杂度”对应 `hydraOrdinal`，“根下从左到右的孩子贡献”对应 `forestOrdinal`。“一个孩子贡献 `ω` 的某次幂”对应 `ordinalPow Ordinal.omega0 (hydraOrdinal child)`，“然后接上剩余贡献”对应 `ordinalAdd`。“删除最右根头”由关系 `RightmostRootHeadCut` 精确限定为从 `children ++ [Hydra.head]` 变成 `children`；它不含糊地排除了中间位置删除。“复制若干父树”对应 `List.replicate copies parent`，其序数侧结果对应 `ordinalRepeat`。

# 依赖（人话版）

依赖上一条有限 Hydra 树定义，以及本库已经公开的序数加法、序数幂和它们的零、后继方程。严格下降最后只调用序数后继确实大于原序数这一良序基础事实。Mathlib 原生序数运算没有成为公开定义；证明内部把“零的后继”规范化时使用了基础序数化简，但教材公式及公开接口始终由本库 `ordinalAdd` 和 `ordinalPow` 表达。

# 应用与陷阱

本条已经能证明根下最右叶头删除下降，并能把阶段相关复制准确改写成有限重复序数和；后续证明可在此基础上研究“复制很多个较低幂项为何仍小于被替换的较高幂项”。但它尚未证明任意根头位置删除，因为序数加法会吸收左侧小项，孩子顺序需要额外规范；也尚未证明 `Hydra.Step` 的所有深层再生都严格下降，更没有给出小于 `ε₀` 的全局界、完整游戏终止或 PA 不可证性结论。`hydraOrdinal_verified_interfaces` 只打包上述两个已验证接口，不应被引用成完整 Hydra 定理。
