---
id: settheory.googology.hydra-parent-sibling-descent
kind: theorem
state: verified
title: "父节点内部保留左兄弟的 Hydra 复制下降"
premises: ["settheory.googology.hydra-sibling-descent"]
mathlib: []
provenance: {source_type: book, ref: "kirby-paris-independence-1982"}
---

# 动机

上一条允许根部保留左兄弟，却仍假设被复制的父节点内部只有一个头。下一步应允许这个父节点在被砍头之外还保留其他分支，否则“砍后父树”的复杂度始终只是零，尚未体现指数层级如何随一般父树变化。本条允许根部和父节点内部各自保留任意有限有序左兄弟，并把被复制父节点及被砍叶头分别限制在各自列表的最右端。

# 直觉

设父节点内部未被砍的森林值为 `α`。因为被砍头位于该森林最右侧，砍前父节点值恰好是 `succ α`，砍后父节点值是 `α`。于是砍前父分支对根的贡献是 `ω^(succ α)`；砍后即使复制 `stage + 1` 份，也只得到有限份 `ω^α` 的重复和，仍严格小于前者。根部任意左兄弟再形成共同的序数加法前缀，不会破坏这个严格比较。

# 陈述（自然语言）

旧树由两段有序前缀描述：根的孩子先是 `rootSiblings`，最右端是被选父节点；该父节点的孩子先是 `parentSiblings`，最右端是叶头。新树保留 `rootSiblings`，并把删去最右叶头后的父节点，也就是只含 `parentSiblings` 的节点，复制 `stage + 1` 份。路径正是两段前缀长度 `[rootSiblings.length, parentSiblings.length]`。此路径产生合法 `Hydra.Step`，且新树的结构序数严格小于旧树。

# 陈述（Lean 对照）

```lean
def ParentRightmostHeadReplicatedCut (stage : Nat)
    (rootSiblings parentSiblings : List Hydra)
    (before after : Hydra) : Prop

theorem copiedParentSuffix_decreases (stage : Nat)
    (parentSiblings : List Hydra) :
    forestOrdinal (List.replicate (stage + 1) (.node parentSiblings)) <
      forestOrdinal [.node (parentSiblings ++ [Hydra.head])]

theorem parentRightmostHeadReplicatedCut_verified
    (cut : ParentRightmostHeadReplicatedCut stage
      rootSiblings parentSiblings before after) :
    Hydra.Step stage before after ∧ hydraOrdinal after < hydraOrdinal before
```

# 思维脉络（thinking trace）

证明仍分程序与序数两侧，但现在两层都需精确处理。程序侧复用“在前缀长度处替换”的列表引理：先在父节点内部删除 `parentSiblings` 后的头，再在根部把 `rootSiblings` 后的原父节点替换成多份删头父节点；两次下标都由各自前缀长度确定。序数侧先用 `forestOrdinal_append_head` 把父内追加叶头化为后继，再调用有限重复 `ω` 幂界，最后用共同根部左前缀保持严格比较的引理完成组装。

# 自然语言 ↔ Lean 映射

“根部保留的左兄弟”对应 `rootSiblings`，“父内保留的左兄弟”对应 `parentSiblings`。“两个最右位置”分别对应根下编号 `rootSiblings.length` 和父内编号 `parentSiblings.length`。“砍前父节点”是 `.node (parentSiblings ++ [Hydra.head])`，“砍后父节点”是 `.node parentSiblings`，“阶段复制”是 `List.replicate (stage + 1)`。局部指数下降由 `copiedParentSuffix_decreases` 表达，完整合法性与下降由 `parentRightmostHeadReplicatedCut_verified` 合并。

# 依赖（人话版）

依赖有限 Hydra 的路径砍头程序、结构序数赋值、父树复制的森林公式、有限份 `ω^α` 小于 `ω^(α+1)` 的不等式，以及共同左森林保持下降的序数加法接口。本条没有新增 Mathlib 高层依赖；关键顺序事实均通过前两批已经转成的本库接口使用。列表下标与替换计算在本文件重新给出精确证明。

# 应用与陷阱

本条已经处理非空且任意复杂的砍后父树：阶段复制的每份贡献可为一般 `ω^α`，不再局限于 `1`。但两个“最右”条件仍是证明边界。父内若被砍头右侧还有孩子，删头未必把父值变成后继的前项；根部若被复制父节点右侧还有兄弟，后缀也可能吸收局部差异。本条还没有沿任意更高祖先链传播变化，因此不覆盖全部 `Hydra.Step`，也没有证明全局终止、`ε₀` 上界或 PA 不可证性。
