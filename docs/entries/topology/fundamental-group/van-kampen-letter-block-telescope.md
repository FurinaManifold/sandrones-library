---
id: topology.fundamental-group.van-kampen-letter-block-telescope
family: topology.fundamental-group
variant: single-letter-fine-edge-telescope
kind: theorem
state: verified
title: van Kampen 单字母 block 的细边 telescope
summary: 将一个输入 letter block 内全部真实右锚定左边界 cell edges 的反序乘积压缩为原 Pushout 字母在 block 首末 combined frames 下的一次整体 rebase
premises: [topology.fundamental-group.van-kampen-block-boundary-cocycle]
mathlib: [Group, List, Fin, FundamentalGroup, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

12b 给出每条左边界细边的 cell factor 到 letter factor 的 rebase，13a–13c 证明这些 rebase frames 在
细边内部及 block 接缝处相容。本批执行第一层有限 telescope：固定一个输入 letter，只在其 dyadic
block 内将全部细边相乘，使所有中间 combined frames 消去。

# combined endpoint frames

`leftBoundaryCombinedStartFrame` 和 `leftBoundaryCombinedEndFrame` 分别把逐边 cell-to-letter transition
与二维右锚定 cell frame 相乘。次序使用 13a 已冻结的 `inner * outer`：前者负责从 letter 表示转到
cell 表示，后者负责将 cell 表示放入右锚定网格 frame。

`leftBoundaryCombinedFrames_adjacent` 处理同 block 内相邻细边；
`leftBoundaryCombinedBlockFrames_adjacent` 使用 13c 的 block seam cocycle处理相邻输入 letters。这两条
公式公开，因为第二层 telescope 必须统一读取 block 内和 block 间的 frame 相容性。

# 细边 chain

`leftBoundaryBlockEdgeChain` 按 block 内有限索引保存每条 letter-side factor 及其 combined end frame。
`leftBoundaryFramedCellEdgeChain` 保存二维右锚定网格实际使用的左边界 cell factors。两条 chain 使用
同一细边顺序，但基本群乘法与道路拼接方向相反，最终都通过 `reverseEdgeChainProduct` 读取。

私有逐项定理使用 12b 的真实 factor transport 与 13a 的 nested rebase，将每个 actual framed cell
edge 改写为命名 block factor 在 combined frames 下的 rebase。

# 接回二维右锚定网格

`rightAnchoredFramedLeftBoundaryCellEdge_eq_rowLeftEdge` 证明本批使用的 actual cell edge 就是 08b
completed-row 高层接口的左端项。它刻意调用
`rightAnchoredGridFullRow_leftEdge_eq_leftmost`，不展开或引用 07b 的 row-prefix 实现递归。

该定理必须公开：14b 在 flatten 全部 blocks 时直接把单 block actual chain 接回完整网格左边界词。

# 单 block telescope

通用 edge-chain telescope 从 block 的 combined start frame 出发，逐项消去相邻 end/start frames。
11a 已证明 block 内全部 corrected-loop factors 的反序乘积恢复原输入字母。因此
`leftBoundaryFramedCellEdges_eq_rebaseLetter` 得到

```text
actual framed cell edges of block i
  = rebaseEdge blockStart blockEnd (Pushout.of letterᵢ).
```

`leftBoundaryFramedCellEdges_eq_rebaseLetter_explicit` 将 chain 的抽象终点展开为最后细边的真实 combined
end frame，供 14b 构造第二层 block chain。

# Lean 对照

```lean
def PathConcatAlignedSquareSubdivision.leftBoundaryCombinedStartFrame ...
def ...leftBoundaryCombinedEndFrame ...
def ...leftBoundaryBlockEdgeChain ...
theorem ...rightAnchoredFramedLeftBoundaryCellEdge_eq_rowLeftEdge ...
def ...leftBoundaryFramedCellEdgeChain ...
theorem ...leftBoundaryCombinedFrames_adjacent ...
theorem ...leftBoundaryCombinedBlockFrames_adjacent ...
theorem ...leftBoundaryFramedCellEdges_eq_rebaseLetter ...
theorem ...leftBoundaryFramedCellEdges_eq_rebaseLetter_explicit ...
```

# 正式承载与公开面

群、列表、有限索引、基本群与 Pushout 复用 Mathlib；`EdgeChain`、`reverseEdgeChainProduct`、aligned
subdivision、right-anchored frames 和 letter block word 复用前序本库接口。本批没有新增 Path、基本群、
Pushout、instance 或 notation。

公开面为 9 项：三个 combined/chain definitions、actual-grid bridge、framed chain、两条 frame
adjacency 和两条 telescope 出口。十个 private 只处理逐项 factor、chain length/end 与顺序改写。

# 尚未完成的边界

本批只 telescope 一个 letter block。它没有把所有 blocks 组成第二层 chain，没有证明完整网格左边界
等于原字母词的 rebase，也没有消去首末 residual frames；kernel、单射和最终 van Kampen 同构均未
证明。
