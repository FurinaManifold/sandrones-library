---
id: topology.fundamental-group.van-kampen-left-boundary-cocycle
family: topology.fundamental-group
variant: adjacent-edge-endpoint-compatibility
kind: theorem
state: verified
title: van Kampen 左边界相邻细边的 transition cocycle
summary: 证明同一 letter block 内相邻左边界细边的 cell-to-letter transitions 与真实竖直公共边 transition 在共享顶点满足非交换 cocycle
premises: [topology.fundamental-group.van-kampen-left-boundary-transport]
mathlib: [Group, Path, FundamentalGroup, Monoid.PushoutI, Fin]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

12b 已逐边证明 cell factor 是 letter block factor 的 endpoint rebase。若要把一个 block 内的所有细边
相乘，必须知道下边终点 frame 与上边起点 frame 如何衔接；否则每条边都会留下无法消去的独立 gauge。
本批证明相邻细边在共享网格顶点满足同一个严格 cocycle，为后续 combined frames 和有限 telescope
提供局部相容性。

# 非交换两层 rebase

`rebaseEdge_rebaseEdge` 冻结两次重基化的合成方向：先使用内层 `(innerStart, innerEnd)`，再使用外层
`(outerStart, outerEnd)`，等价于一次使用

```text
start = innerStart * outerStart,
end   = innerEnd   * outerEnd.
```

这个乘积次序来自 `rebaseEdge start end edge = end⁻¹ * edge * start`，在非交换 Pushout 中不能翻转。
该通用群引理是后续 combined-frame transport 的代数基础。

# potential cocycle

`edgeTransitions_cocycle_of_potentials` 表明：若下格到目标、上格到目标以及下格到上格的三组
transitions 都由同一共享顶点的三个 potentials 给出，则

```text
lowerToTarget.endChange =
  upperToTarget.startChange * vertical.startChange.
```

证明只使用 `transitionFromPotentials_mul`。`combinedVertexFrames_compatible` 再将该 transition cocycle
与既有 `VerticalCellFramesCompatible` 相乘，得到组合顶点 frames 的严格相容性。

# 四种标签分支

设下格标签、上格标签与固定 letter 标签比较。证明内部穷尽四类：上下都等于 letter、仅下格等于、
仅上格等于、上下都不同。上下标签相同时使用 same-path comparison；上下标签切换时使用 dual-path
intersection potentials 和真实 `verticalInternalEdgeTransitions`。

两个 mixed 分支最容易发生类型错位：一侧的 same comparison potential 必须先识别为 switch edge
相应上格或下格 potential，另一侧的 letter potential 再与 dual comparison 在同一共享顶点对齐。
这些 cast 与 subtype 展开均保持 private。

# Lean 对照

```lean
theorem rebaseEdge_rebaseEdge ...
theorem combinedVertexFrames_compatible ...
theorem edgeTransitions_cocycle_of_potentials ...

theorem PathConcatAlignedSquareSubdivision.
  leftBoundaryCellToLetterTransitions_adjacent ...
```

最终主定理只要求相邻细边索引证明 `s.succ = t.castSucc`。它内部计算统一网格行索引，选择 common
或 switch 的真实竖直 transition，并返回同一条高层 cocycle；13b 不再执行 Bool case split。

# 正式承载与公开面

群、道路、基本群、Pushout 和有限索引复用 Mathlib。`EdgeTransitions`、`CellVertexFrames`、
`rebaseEdge`、vertex potentials、aligned subdivision 与 vertical internal-edge transitions 均复用前序
本库接口。本批没有新增 carrier、instance、notation、Path、基本群或 Pushout。

公开面严格为三个通用代数／frame 引理和一个几何相邻边主定理。十二个 private 定理只处理四种标签
分支中的 same/dual comparison 端点正规化，不是下游应依赖的第二套接口。

# 后续用途

13b 将用主定理证明 cell frame 与 letter frame 相乘所得 combined frames 沿 block 内全部细边相容，
并把局部索引搬到全局网格行。13c 再处理两个相邻 letter blocks 的接缝。14 才能在这些严格相容
frames 上执行有限乘积 telescope。

# 尚未完成的边界

本批只处理同一 letter block 内相邻细边。它不处理 block 首末端点、跨 block 接缝、完整左边界有限
乘积或 residual gauge，也不证明 kernel 平凡、规范同态单射或最终 van Kampen 同构。
