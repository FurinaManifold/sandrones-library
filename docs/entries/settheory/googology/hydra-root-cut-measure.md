---
id: settheory.googology.hydra-root-cut-measure
kind: theorem
state: verified
title: "Hydra 根旁砍头：一个诚实的局部序数下降"
premises: ["settheory.googology.hydra-game-step", "settheory.ordinal.no-infinite-descent"]
mathlib: ["Ordinal", "Nat.cast_lt"]
provenance: {source_type: internal, ref: "kirby-paris-independence-1982"}
---

# 动机

Hydra 终止证明的核心不是“树看起来变小”，而是找到每一步都严格下降的良基度量。本库的深层砍头会复制子树，节点数可能上升；不过，直接连在根上的叶头不会触发复制。先把这个完整的局部情形证明清楚，可以准确划出简单度量能够承担的范围。

# 直觉

给每棵有限 Hydra 数一数节点，并把所得自然数看成有限序数。若删除根的第 `i` 个孩子，而该孩子确实是叶头，那么其余孩子保持原顺序，整棵树至少少掉这个叶节点。因此节点数对应的序数严格下降。

# 陈述（自然语言）

定义 `ordinalMeasure h` 为 Hydra `h` 的节点总数所对应的有限序数。对任意阶段、任意根孩子编号，只要路径 `[i]` 的 `chop` 成功得到 `after`，就有 `after` 的序数度量严格小于砍头前的度量。

# 陈述（Lean 对照）

`nodeCount` 递归计算根节点加所有子树节点数；`ordinalMeasure` 将它强制转换为 `Ordinal`。定理 `ordinalMeasure_decreases_root_cut` 从等式 `chop stage before [i] = some after` 推出 `ordinalMeasure after < ordinalMeasure before`。`single_head_ordinal_descent` 是只有一个根旁头时的具体实例。

# 思维脉络（thinking trace）

证明先展开长度为一的路径规则。成功返回迫使第 `i` 个孩子为叶子，并迫使 `replaceAtWith` 删除该项。辅助引理沿列表和下标归纳，证明删除一个权重恒正的元素会严格减小权重和；Hydra 的每棵子树节点数至少为一。最后利用自然数到序数的保序性把自然数不等式提升为序数不等式。

# 自然语言 ↔ Lean 映射

“节点总数”对应 `nodeCount`；“看成有限序数”对应 `ordinalMeasure` 中的自然数强制转换；“根旁”对应单元素路径 `[i]`；“合法删除”由 `chop ... = some ...` 表达；“严格下降”对应序数上的 `<`。

# 依赖（人话版）

本条依赖本库已经明确规定的有限有序 Hydra、路径砍头函数，以及序数的严格序。证明只分析本库 `chop` 的根旁分支，不借用标准 Kirby–Paris Hydra 的终止定理，也没有假定两套游戏规则相同。

# 应用与陷阱

这个结论可以处理连续删除根旁头的局部过程，也展示了序数排名证明的基本形状。但它不是所有 `Hydra.Step` 的排名：深层砍头会按阶段复制修剪后的父子树，有限节点数可能增加。因而本条不能推出本库 Hydra 游戏整体终止，更不能冒充 Kirby–Paris 定理；完整证明需要能吸收复制效应的更精细序数赋值。
