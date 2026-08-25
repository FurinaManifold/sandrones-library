---
id: topology.foundation.real-line
family: topology.foundation
variant: epsilon-open
kind: definition
state: verified
title: 标准实拓扑与单位区间的正式承载
summary: 解释 Mathlib 标准实拓扑的 ε 邻域刻画和 unitInterval subtype，并保留旧显式构造作为迁移兼容层
premises: [topology.foundation.constructions, real.order.absolute-value]
mathlib: [Real.instTopologicalSpace, Metric.isOpen_iff, unitInterval, Set.Icc]
provenance:
  source_type: book
  ref: "Munkres, Topology, Sections 13 and 20"
---

# 动机

道路需要一个带拓扑的参数区间。Mathlib 的标准实拓扑和 `unitInterval` 与教材定义语义一致，因此课程直接使用它们，并通过 ε 邻域刻画说明其含义；没有必要维护第二套实拓扑和区间类型。

# 直觉

实直线中的集合开，是指集合内每一点周围都有足够小的正半径邻域仍留在集合中；`|y-x|<ε` 就是标准度量球条件。Mathlib 的 `unitInterval` 是闭区间 `[0,1]` 的 subtype，并自动继承标准实拓扑。

# 陈述（自然语言）

标准实拓扑中的集合 `s` 开，当且仅当对每个 `x∈s`，存在 `ε>0`，使所有满足 `|y-x|<ε` 的 `y` 都属于 `s`。Mathlib 的 `unitInterval` 定义上就是 `Set.Icc 0 1`。旧 `realLine/UnitInterval/unitInterval` 只为已提交道路链保留。

# 陈述（Lean 对照）

```lean
theorem real_isOpen_iff_abs (s : Set ℝ) :
  IsOpen s ↔ ∀ x ∈ s, ∃ ε : ℝ, 0 < ε ∧ ∀ y, |y - x| < ε → y ∈ s
theorem unitInterval_eq_Icc : unitInterval = Set.Icc (0 : ℝ) 1
theorem TextbookTopology.toMathlib_realLine :
  realLine.toMathlib = (inferInstance : TopologicalSpace ℝ)
theorem TextbookTopology.toMathlib_unitInterval :
  unitInterval.toMathlib = instTopologicalSpaceSubtype
```

# 思维脉络（thinking trace）

从 `Metric.isOpen_iff` 出发，把实数距离用 `Real.dist_eq` 改写为绝对值即可得到教材刻画。`unitInterval_eq_Icc` 是定义等式。兼容模块再用拓扑外延和 subtype 桥，证明旧实拓扑与旧单位区间转入 Mathlib 后分别等于规范实例。

# 自然语言 ↔ Lean 映射

“ε 邻域”对应 `real_isOpen_iff_abs`；“标准度量开集”对应 `Metric.isOpen_iff`；“闭单位区间”对应根 `unitInterval` 与 `Set.Icc 0 1`；“继承拓扑”对应 subtype 规范实例；“旧构造没有改变语义”对应 `toMathlib_realLine` 和 `toMathlib_unitInterval`。

# 依赖（人话版）

正式接口依赖 Mathlib 的标准实数度量拓扑、`Topology.UnitInterval` 与 subtype 拓扑实例。旧 ε 拓扑、仿射连续性、闭半区和区间反射仍留在文件后半部，只用于冻结旧道路实现；新课程不依赖这些平行声明。

# 应用与陷阱

半径必须严格为正。单位区间在实线中是闭集，但作为 subtype 仍有自己的开集。新道路必须使用 Mathlib `unitInterval`；旧大写 `UnitInterval` 与旧小写拓扑只出现在兼容桥和冻结下游中。
