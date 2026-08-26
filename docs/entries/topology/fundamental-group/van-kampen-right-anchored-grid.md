---
id: topology.fundamental-group.van-kampen-right-anchored-grid
family: topology.fundamental-group
variant: two-dimensional-right-anchor-and-left-holonomy
kind: theorem
state: verified
title: van Kampen 右锚定网格与左边界消失
summary: 由中央 coherence 将最右列的竖直 frame 相容逐格向左传播，递归构造二维右锚定 frames，并证明完整左边界 holonomy 为单位元
premises: [topology.fundamental-group.van-kampen-row-anchoring]
mathlib: [Fin, List, Group]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

单行右锚定使每行横边和最右竖边重基化为一，但相邻行所用 frames 还必须在每一列满足竖直 transition
传播。只有建立这种二维相容性，才能从完整行“左边等于右边”推出每行左边也为一，并把这些左边按
正确非交换次序累积成整个网格的左边界消失。

# 直觉

先在最右列选择后继行锚点为 `vertical.endChange * lower.topRight`。中央 transition 方格说明：若右格
已经竖直相容，则其左侧公共顶点也满足相容；上下两条共享横边都已归一化为一，frame 唯一性进而恢复
左格完整的竖直相容。由最右格向左归纳，得到整行所有列的相容性。

# 陈述（自然语言）

存在从底行开始递归选择的二维右锚定 frames：每行水平相容，相邻行逐列竖直相容，每格上下横边为一，
且每行最右竖边为一。完整行高层边界关系因此推出其最左竖边也为一。按行逆序累积这些完整行左边，
得到整个有限网格的左边界 holonomy 严格等于单位元。

# 陈述（Lean 对照）

```lean
structure VerticalCellFramesCompatible ...
def BinaryOpenCoverSquareSubdivision.rightAnchoredGridRowFramesAt ...
theorem BinaryOpenCoverSquareSubdivision.rightAnchoredGridRowFramesAt_vertical_compatible ...
theorem BinaryOpenCoverSquareSubdivision.rightAnchoredGridFullRow_leftEdge_eq_leftmost ...
def BinaryOpenCoverSquareSubdivision.rightAnchoredGridLeftBoundaryWordAt ...
theorem BinaryOpenCoverSquareSubdivision.rightAnchoredGridFullLeftBoundary_eq_one ...
```

# 思维脉络（thinking trace）

纯群下降引理先用中央 transition 方格和水平 frame 相容把右端相容传到左端，再用 08a 的固定端 frame
唯一性恢复另一端。具体网格版本把 06 的中央 coherence 和 07b 横边单位性代入。随后对列号从右向左
归纳，再对行号从下向上递归选择锚点。完整行 left-edge 投影只调用 07a 的 full-row 接口，不读取
row-prefix。最后对行数递归累积左边，逐项以单位元化简。

# 自然语言 ↔ Lean 映射

单格竖直相容由 `VerticalCellFramesCompatible` 承载；二维 frames 及四项高层性质以
`rightAnchoredGridRowFramesAt*` 给出。完整行的实际最左边识别是
`rightAnchoredGridFullRow_leftEdge_eq_leftmost`。累计左词是 `rightAnchoredGridLeftBoundaryWordAt`，
其完整高度 reverse-row 公式和单位性分别是 `rightAnchoredGridFullLeftBoundary_eq_reverseRows`、
`rightAnchoredGridFullLeftBoundary_eq_one`。下降、reanchor 与 prefix telescope 均为 private。

# 依赖（人话版）

有限索引、列表和群运算复用 Mathlib。07a 提供 full-row 状态与左端投影，07b 提供横边归一化，08a
提供单行右锚定和 frame 唯一性；本条目只负责二维传播与左边界 telescope，没有复制 frame structure，
也完全不读取 row-prefix 名称。网格接口仍只需要道路连通性，不增加开性或覆盖全空间条件。

# 应用与陷阱

后继行锚点的乘法次序必须是 `vertical.endChange * lower.topRight`，不可交换。左边界累计采用
`reverseEdgeChainProduct` 的反序约定，不能换成普通列表乘积。左边界为一尚未把它识别成给定 kernel
word；因此本条目仍未证明规范同态单射或 van Kampen 同构，VK3b-09 以后才建立字母词桥。
