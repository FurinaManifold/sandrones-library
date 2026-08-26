---
id: topology.fundamental-group.van-kampen-row-anchoring
family: topology.fundamental-group
variant: uniform-right-gauge-and-frame-uniqueness
kind: theorem
state: verified
title: van Kampen 单行 frames 的右锚定
summary: 通过底部和顶部统一右乘 gauges 保持横边归一化，并把一行最右 frames 锚定到指定值，同时证明归一化 frame 的两端唯一性
premises: [topology.fundamental-group.van-kampen-normalized-grid-gauge]
mathlib: [Fin, Group]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

二维 gauge 已使每个小格的上下横边重基化为一，但完整行只能推出左右竖边 holonomy 相等。要让右边界
严格为一，需要调整每行 frames 的剩余自由度，同时不能破坏已经获得的水平相容和横边归一化。本条目
抽取这一纯群论的单行右锚定步骤。

# 直觉

一条重基边为 `endFrame⁻¹ * edge * startFrame`。同时把两端 frame 右乘同一个 gauge，只会把结果整体
共轭；原结果若为一，共轭后仍为一。因此可在一行所有格的底部 frames 统一右乘一个 gauge、顶部
frames 统一右乘另一个 gauge，把最右下角和最右上角调整到指定值，而不改变任何水平归一化关系。

# 陈述（自然语言）

统一右乘保持 `CellVertexFrames` 的水平相容性和已归一化的重基边。由此可将任意规范化单行 frames 的
最右下 frame 锚定到指定值，并把最右上 frame 选择为真实右竖边乘该指定值；所得行仍水平相容、每格
上下横边仍为一，且最右竖边也为一。若同一条边固定一个端 frame 后有两个归一化选择，则另一个端
frame 唯一。

# 陈述（Lean 对照）

```lean
def CellVertexFrames.mulRight ...
theorem rebaseEdge_mulRight ...
theorem rebaseEdge_mulRight_eq_one ...
theorem HorizontalCellFramesCompatible.mulRight ...
def BinaryOpenCoverSquareSubdivision.rightAnchoredRowFrames ...
theorem rebaseEdge_startFrame_unique ...
theorem rebaseEdge_endFrame_unique ...
```

# 思维脉络（thinking trace）

先直接展开 `rebaseEdge`，用群结合律得到右乘后的共轭公式。相容性由分别在 bottom/top 等式右侧乘上
对应 gauge 得到。文件内部构造计算最后一列 frames 所需的两个 gauges，并用逆元消去证明锚点值。
公开 `rightAnchoredRowFrames` 将此构造应用到 07b 的规范单行 frames；其三条性质分别复用相容性、
共轭保持单位元和 `rebaseEdge_mul_start_eq_one`。最后两个唯一性定理用左右消去律恢复未知 frame。

# 自然语言 ↔ Lean 映射

单格右乘是 `CellVertexFrames.mulRight`，重基边的共轭和单位性对应 `rebaseEdge_mulRight`、
`rebaseEdge_mulRight_eq_one`。水平相容保持是 `HorizontalCellFramesCompatible.mulRight`。最终单行构造
为 `rightAnchoredRowFrames`，其 compatibility、horizontal edges、right edge 三项 theorem 是下一模块
的完整消费接口。两端唯一性分别是 `rebaseEdge_startFrame_unique` 和 `rebaseEdge_endFrame_unique`。

# 依赖（人话版）

纯右乘与唯一性只使用 Mathlib 群结构。具体行构造复用 07a 的 `CellVertexFrames` 和 07b 的
`gaugeNormalizedRowFrames` 三项高层接口；没有读取任何 row-prefix 状态，也没有复制 frame structure。
拓扑参数只出现在把通用群操作实例化到覆盖网格的最终四个声明中。

# 应用与陷阱

底部和顶部使用两个独立 gauges，但每一层必须对整行统一右乘；逐格任意改变 gauge 会破坏公共边
相容性。右乘产生的是共轭，不是重基边定义相等；只有原元素为一时才能直接保持为一。本条目只锚定
单行，二维相邻行的锚点必须由下一模块按竖直 transition 递归选择。
