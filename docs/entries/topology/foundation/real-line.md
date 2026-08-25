---
id: topology.foundation.real-line
family: topology.foundation
variant: epsilon-open
kind: definition
state: verified
title: 实直线拓扑与单位区间
summary: 用正半径邻域定义实直线开集，并以本库子空间构造闭单位区间
premises: [topology.foundation.constructions, real.order.absolute-value]
mathlib: []
provenance:
  source_type: book
  ref: "Munkres, Topology, Sections 13 and 20"
---

# 动机

道路需要一个带拓扑的参数区间。若直接使用 Mathlib 的单位区间及其拓扑实例，本库的道路定义仍会在最底层挂靠外部拓扑。因此先从实数的距离直觉独立构造实直线拓扑，再用已经建立的子空间操作得到单位区间。

# 直觉

实直线中的集合开，是指集合内每一点周围都有一个足够小的开区间仍留在集合中。这里用 `|y-x|<ε` 表示以 `x` 为中心、半径 `ε` 的开区间。闭单位区间继承实直线的子空间拓扑。

# 陈述（自然语言）

定义 `realLine`：集合 `s⊆ℝ` 开，当且仅当对每个 `x∈s`，存在 `ε>0`，使所有满足 `|y-x|<ε` 的 `y` 都属于 `s`。定义 `UnitInterval={t:ℝ | 0≤t≤1}`，并以 `subspace` 赋予其单位区间拓扑。

# 陈述（Lean 对照）

```lean
def realLine : TextbookTopology ℝ where
  IsOpen s := ∀ x ∈ s, ∃ ε : ℝ, 0 < ε ∧ ∀ y, |y - x| < ε → y ∈ s

def UnitInterval := {t : ℝ // 0 ≤ t ∧ t ≤ 1}
def unitInterval : TextbookTopology UnitInterval :=
  subspace {t : ℝ | 0 ≤ t ∧ t ≤ 1} realLine
```

# 思维脉络（thinking trace）

全集的每一点可统一取半径一。两个开集相交时，分别取得两个半径并取其最小值。任意开集族的并中，一个点先属于某个成员，再复用该成员给出的半径。三条公理完成后，单位区间直接调用本库 `subspace`，无需重复验证拓扑公理。

# 自然语言 ↔ Lean 映射

“ε 邻域”对应 `|y-x|<ε`；“半径为正”对应 `0<ε`；“交集取较小半径”对应 `min εs εt`；“闭单位区间”对应 subtype `UnitInterval`；“继承拓扑”对应 `unitInterval := subspace ... realLine`。

# 依赖（人话版）

拓扑结构依赖本库的 `TextbookTopology` 与 `subspace`。实数只提供顺序、减法、绝对值及其基本不等式；没有使用 Mathlib 的 `TopologicalSpace ℝ`、度量拓扑、单位区间拓扑或连续性接口。`isOpen_realBall` 由绝对值三角不等式证明，`isOpen_unitInterval_iff` 把子空间开集改写为区间内的相对 ε 邻域条件；`continuous_from_unitInterval_iff` 再把这个刻画应用于开集原像。

# 应用与陷阱

“开集”中的半径必须严格为正，否则任意集合都可能通过空条件。单位区间是闭集并不妨碍它作为自身空间具有开集；这些开集是实直线开集与区间的交。后续道路只能引用本条的 `UnitInterval` 和 `unitInterval`，不得换回 Mathlib 的 `unitInterval`。
