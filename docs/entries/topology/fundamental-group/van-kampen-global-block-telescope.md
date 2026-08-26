---
id: topology.fundamental-group.van-kampen-global-block-telescope
family: topology.fundamental-group
variant: second-level-letter-block-chain
kind: theorem
state: verified
title: van Kampen 字母 blocks 的全局 telescope
summary: 将所有单 letter block telescope 结果组成第二层 chain，消去跨 block 中间 frames，并证明 flatten 后真实细边反序乘积与嵌套 block 反序乘积一致
premises: [topology.fundamental-group.van-kampen-letter-block-telescope]
mathlib: [Group, List, Fin, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

14a 将每个输入 letter block 内的细边压缩为一个 rebased letter，但完整左边界含有多个 blocks。第二层
telescope 必须把这些 block 视作新的 edge chain，并使用 13c 的接缝相容性消去相邻 blocks 之间的
combined frames。同时还要证明“先 flatten 全部细边再反序相乘”与“两层分别反序相乘”在非交换群中
具有正确次序。

# 三条第二层 chains

`leftBoundaryLetterBlockChain` 的 factors 是 `letters.reverse` 中每个输入 letter 映入 Pushout 后的元素，
end frames 是对应 block 最后一条细边的 combined end frame。

`leftBoundaryFramedBlockChain` 使用相同 end frames，但 factor 改为该 block actual framed cell-edge
chain 的反序乘积。`leftBoundaryAllFramedCellEdgeChain` 则直接 flatten 所有 block 的实际细边 chains，
保持全局网格行顺序。

# 非交换 flatten 次序

私有通用群引理 `reverse_flatten_prod` 证明

```text
(blocks.flatten).reverse.prod
  = ((blocks.map fun block => block.reverse.prod).reverse.prod).
```

这只是列表反转与结合律，不使用交换律。`reverseAllFramedCellEdges_eq_framedBlocks` 将它专门化到真实
framed cell chains；`reverseAllFramedCellEdges_eq_gridLeftBoundaryWord` 再用 14a 的 actual-grid bridge
将 flatten 结果识别为二维右锚定网格的完整左边界词。

# 第二层 telescope

14a 的显式单 block 定理逐项证明 framed-block factor 等于对应 letter factor 在 block combined start/end
frames 下的 rebase。13c 保证前一 block 的 end frame 与后一 block 的 start frame 严格相容。通用
edge-chain telescope 因而消去全部中间 block frames。

`leftBoundaryFramedBlocks_eq_rebaseLetterChain` 的结论是：全部实际 framed blocks 的反序乘积等于第二层
letter block chain 从首 frame 到末 frame 的一次整体 rebase。它尚未把该 letter chain 的 factor
product 改写成原始 `binaryVanKampenLetterWord letters`。

# Lean 对照

```lean
def PathConcatAlignedSquareSubdivision.leftBoundaryLetterBlockChain ...
def ...leftBoundaryFramedBlockChain ...
def ...leftBoundaryAllFramedCellEdgeChain ...
theorem ...reverseAllFramedCellEdges_eq_framedBlocks ...
theorem ...reverseAllFramedCellEdges_eq_gridLeftBoundaryWord ...
theorem ...leftBoundaryFramedBlocks_eq_rebaseLetterChain ...
```

# 正式承载与公开面

群、列表、有限索引与 Pushout 复用 Mathlib；`EdgeChain`、反序 product、combined frames 和单 block
telescope 复用前序本库接口。本批没有新增 Path、基本群、Pushout、instance 或 notation。

公开面为三条 chain definitions、两个真实 flatten/grid bridges 和第二层 telescope，共六项。两个
private 定理分别是一般 `reverse_flatten_prod` 与逐 block rebased factor 对齐，不泄漏实现层给 14c。

# 后续用途

14c 将证明第二层 letter chain 的反序 factor product正是原输入 Pushout 字母词，并把真实 flatten
chain 接到 08b 已知为一的完整网格左边界，从而得到整体 rebased letter word 等于一。

# 尚未完成的边界

本批不声称原字母词本身为一；首末 frames 仍可能留下 residual gauge。它没有证明 kernel 平凡、规范
同态单射或最终 van Kampen 同构。
