---
id: settheory.googology.hydra-sibling-descent
kind: theorem
state: verified
title: "保留左兄弟森林的一层 Hydra 复制下降"
premises: ["settheory.googology.hydra-one-level-descent"]
mathlib: ["add_lt_add_right"]
provenance: {source_type: book, ref: "Laurie Kirby and Jeff Paris, Accessible Independence Results for Peano Arithmetic, 1982; 本条证明最右复制分支子类"}
---

# 动机

一层复制下降条目只处理根恰好有一个孩子的树。真实树往往还有其他分支；加入兄弟后，不能仅说“共同部分约掉”就算证明，因为序数加法不交换，也不存在一般的左右消去直觉。本条允许根保留任意有限的有序兄弟森林，但把发生砍头与复制的父分支严格放在最右端，从而能准确利用序数加法对右参数的严格单调性。

# 直觉

先把根下的孩子排成一列：左边是完全不动的兄弟，最右边是“父节点—独头”分支。砍最右分支的头以后，该父节点变空，并按阶段复制若干份。上一条已经证明变化部分从 `ω` 降到某个有限和。共同的左兄弟贡献像固定前缀 `A`，于是整个比较成为 `A + finite < A + ω`。序数加法虽不交换，但固定左项后会随右项严格增加，所以局部下降能够穿过整个左前缀。

# 陈述（自然语言）

首先证明两个结构引理：本库序数加法在右参数上严格递增；若两个后缀森林的赋值严格有序，那么在二者左边追加同一个有序森林后仍严格有序。随后定义最右分支复制砍头：旧树的根孩子为 `siblings` 后接一个“父—独头”分支，新树为相同 `siblings` 后接 `stage + 1` 个空父节点。沿路径 `[siblings.length, 0]` 执行 `chop` 确实得到新树，并且结构序数赋值严格下降。

# 陈述（Lean 对照）

```lean
theorem ordinalAdd_lt_of_lt_right (h : left < right) (initial : Ordinal) :
  ordinalAdd initial left < ordinalAdd initial right

theorem forestOrdinal_append_lt (initial : List Hydra)
    (h : forestOrdinal left < forestOrdinal right) :
    forestOrdinal (initial ++ left) < forestOrdinal (initial ++ right)

def RightmostBranchReplicatedCut (stage : Nat) (siblings : List Hydra)
    (before after : Hydra) : Prop

theorem rightmostBranchReplicatedCut_verified
    (cut : RightmostBranchReplicatedCut stage siblings before after) :
    Hydra.Step stage before after ∧ hydraOrdinal after < hydraOrdinal before
```

# 思维脉络（thinking trace）

证明分为列表位置与序数顺序两侧。列表侧先证明 `replaceAtWith` 在前缀长度处替换时会原样保留前缀，再用 `getElem?` 在追加点的计算确定被选中的确是最右父分支，由此核验 `chop` 而非另造一个抽象关系。序数侧从本库 `ordinalAdd` 建立右参数严格单调接口，再对共同兄弟列表归纳，把局部不等式逐个包入相同的 `ω^(孩子值) + ·`。最末端的局部下降直接复用上一条含阶段复制的证明。

# 自然语言 ↔ Lean 映射

“保留的左兄弟”对应 `siblings`，“最右父—独头分支”对应列表末项 `.node [Hydra.head]`，“其在根下的编号”对应 `siblings.length`，头在父节点内的编号为 `0`，合成路径 `[siblings.length, 0]`。“砍后复制空父节点”对应 `List.replicate (stage + 1) (.node [])`。“共同左前缀保持不等式”对应 `forestOrdinal_append_lt`，而实际合法步骤与下降的合取由 `rightmostBranchReplicatedCut_verified` 给出。

# 依赖（人话版）

依赖上一条一层复制砍头的合法性与下降结论、Hydra 路径执行器、森林序数赋值及本库序数加法。Mathlib 的顺序基础只用于验证固定左加数时右参数严格递增；公开陈述继续使用本库从良序拼接定义的 `ordinalAdd`。列表下标和拼接替换均在本文件直接证明，没有假定程序计算结果。

# 应用与陷阱

本条表明局部复制下降能稳定穿过任意复杂的共同左兄弟森林，因此比单分支例子更接近一般树。但“最右端”不是装饰条件：若被砍分支右边还有兄弟，整体表达式是 `A + changed + B`，后缀 `B` 可能在序数加法中吸收 `changed` 的差别，不能直接套用本证明。当前也仍只处理父节点原先有一个头，不覆盖保留父内兄弟、任意深祖先链、所有 `Hydra.Step`、全局终止或 PA 不可证性。
