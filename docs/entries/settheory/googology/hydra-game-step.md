---
id: settheory.googology.hydra-game-step
kind: definition
state: verified
title: "有限 Hydra 游戏的定义与阶段相关单步"
premises: []
mathlib: []
provenance: {source_type: book, ref: "Laurie Kirby and Jeff Paris, Accessible Independence Results for Peano Arithmetic, 1982; 本条固定一种有限有序树变体"}
---

# 动机

Hydra 故事常被缩写成“砍掉一个头，却长出更多头”，但这句话还不是数学定义：什么算头，在哪里复制，复制几份，以及根旁的头是否再生，都必须固定下来。不同资料采用的树是否有序、阶段从零还是从一计数、复制原父树还是砍头后的父树，也可能不同。本条因此不借用含糊的“标准 Hydra”，而是明确建立一种有限有序树版本及其可计算单步。

# 直觉

把 Hydra 看成一棵以身体为根的有限树，没有子节点的叶子就是头。Hercules 用一串子节点编号指出要砍的头。如果头直接长在身体上，砍掉便结束；如果头还有父节点和祖父节点，就先从父节点删掉它，再在祖父节点原来放置这个父节点的位置，放入若干份砍头后的父子树。第 `stage` 阶段放 `stage + 1` 份，所以零阶段仍保留一份，二阶段会放三份。

# 陈述（自然语言）

有限 Hydra 是子 Hydra 的有限有序列表构成的递归树。位置是自然数列表：每个数选择当前节点的第几个孩子；非空有效路径若终点是叶子，便是可砍的头位置。`chop stage h path` 在路径无效或终点不是头时返回失败；对根的直接孩子只删除；对更深的头，在其祖父处把原父子树替换成 `stage + 1` 份删头后的父子树，并沿更高路径只更新被选中的分支。`Step stage before after` 表示存在一个合法头位置，使这次计算恰好得到 `after`。

# 陈述（Lean 对照）

```lean
inductive Hydra where
  | node (children : List Hydra)
def IsHeadPosition (h : Hydra) (path : List Nat) : Prop
def chop (stage : Nat) : Hydra → List Nat → Option Hydra
def Step (stage : Nat) (before after : Hydra) : Prop
theorem chop_single_head (stage : Nat) :
  chop stage (.node [head]) [0] = some (.node [])
theorem chop_regrows_three :
  chop 2 (.node [.node [head, head]]) [0, 1] =
    some (.node [.node [head], .node [head], .node [head]])
```

# 思维脉络（thinking trace）

定义从可执行数据向关系接口搭建。首先用递归归纳类型保证每棵树有限，并用列表顺序消除“选的是哪一枝”的歧义；其次用 `subtreeAt` 检查路径，把“头”落实为非根叶节点；然后用 `replaceAtWith` 同时完成删除、单枝替换和多份复制。`chop` 对路径长度分三种情况：长度一是根旁删除，长度二恰好到达发生再生的祖父，长度更大则递归进入唯一孩子。最后把成功计算封装为 `Step`，使后续既能运行具体例子，也能用关系式讨论任意合法选择。

# 自然语言 ↔ Lean 映射

“身体或分叉点”对应 `Hydra.node children`，“头”对应 `head = .node []`，“从根走到头的编号”对应 `List Nat`，“路径确实落在非根叶子”对应 `IsHeadPosition`。“砍掉列表第 `i` 项”是 `replaceAtWith children i []`，“用三份砍后父树取代原父树”是 `replaceAtWith children i (List.replicate 3 pruned)`。“这一局允许从旧树走到新树”不是任意等式，而是存在合法路径且 `chop` 返回该树的 `Step`。

# 依赖（人话版）

只依赖自然数、有限列表、可选返回值和递归归纳类型。有限树、路径解释、头位置、阶段再生和单步关系均由本库公开定义；Mathlib 仅提供基础列表设施，没有把现成 Hydra 定理包装成本条。该定义受 Kirby–Paris Hydra 思想启发，但有序孩子、零编号阶段及 `stage + 1` 复制是本条明确固定的版本约定。

# 应用与陷阱

两个可执行例子分别核对了根旁独头被完全删除，以及二阶段砍掉深层双头之一后得到三个单头父树。它们可作为后续定义完整对局、策略或序数度量时的回归测试。当前没有构造小于 `ε₀` 的度量，没有证明每一步使该度量下降，也没有证明所有选择序列终止；因此本条不是 Hydra 终止定理，更没有声称相关命题在 PA 中不可证。比较其他文献前还必须核对树的有序性、阶段编号和复制规则，不能只因都称为 Hydra 就直接互换结论。
