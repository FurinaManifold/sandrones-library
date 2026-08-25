---
id: topology.foundation.mathlib-compatibility
family: topology.foundation
variant: legacy-carrier-equivalence
kind: bridge
state: staging
title: 旧教材拓扑与 Mathlib 拓扑的兼容等价
summary: 证明冻结的 TextbookTopology 及其实线、单位区间和道路与 Mathlib 正式承载具有相同数据，并建立双向等价以支持分层迁移
premises: [topology.foundation.structure]
mathlib: [TopologicalSpace, IsOpen, IsClosed, nhds, Homeomorph, unitInterval, Path]
provenance:
  source_type: migration
  ref: "Topology Mathlib reuse migration RFC"
---

# 动机

早期拓扑课程为了展示开集公理，自建了 `TextbookTopology`；Mathlib 的 `TopologicalSpace` 实际采用完全相同的开集数据和三条公理。继续同时发展两套道路、同伦和基本群会制造无必要的转换成本，因此新课程改用 Mathlib 正式承载，同时为旧成果保留可验证的迁移通道。

# 直觉

两种结构都只记录“哪些集合开”，以及全空间开、有限交开、任意并开。转换时逐字段原样复制即可；来回转换后开集谓词不变，而其余字段都是命题证明，所以结构本身也不变。

# 陈述（自然语言）

任意 Mathlib 拓扑都能转成旧教材拓扑，且开集、闭集、邻域与同胚数据一致。旧诱导、子空间、积、实线与单位区间拓扑转到 Mathlib 后分别严格等于规范构造或实例。旧道路与 Mathlib `Path` 也能保持参数函数和端点双向转换。

# 陈述（Lean 对照）

```lean
def TextbookTopology.fromMathlib (τ : TopologicalSpace X) : TextbookTopology X
theorem TextbookTopology.isOpen_fromMathlib (τ : TopologicalSpace X) (s : Set X) :
  (fromMathlib τ).IsOpen s ↔ IsOpen s
theorem TextbookTopology.toMathlib_fromMathlib (τ : TopologicalSpace X) :
  (fromMathlib τ).toMathlib = τ
theorem TextbookTopology.fromMathlib_toMathlib (τ : TextbookTopology X) :
  fromMathlib τ.toMathlib = τ
def TextbookTopology.equivMathlib : TextbookTopology X ≃ TopologicalSpace X
theorem TextbookTopology.isClosed_toMathlib (τ : TextbookTopology X) (s : Set X) :
  IsClosed[τ.toMathlib] s ↔ τ.IsClosed s
theorem TextbookTopology.isNeighborhood_iff_mem_nhds
    (τ : TextbookTopology X) (x : X) (s : Set X) :
  τ.IsNeighborhood x s ↔ s ∈ @nhds X τ.toMathlib x
def TextbookTopology.Homeomorphism.toMathlib
    (e : Homeomorphism τX τY) : @Homeomorph X Y τX.toMathlib τY.toMathlib
def TextbookTopology.Homeomorphism.fromMathlib
    (e : @Homeomorph X Y τX.toMathlib τY.toMathlib) : Homeomorphism τX τY
theorem TextbookTopology.toMathlib_induced :
  (induced f τY).toMathlib = TopologicalSpace.induced f τY.toMathlib
theorem TextbookTopology.toMathlib_subspace :
  (subspace s τX).toMathlib = @instTopologicalSpaceSubtype X s τX.toMathlib
theorem TextbookTopology.toMathlib_product :
  (product τX τY).toMathlib = @instTopologicalSpaceProd X Y τX.toMathlib τY.toMathlib
theorem TextbookTopology.toMathlib_realLine :
  realLine.toMathlib = (inferInstance : TopologicalSpace ℝ)
theorem TextbookTopology.toMathlib_unitInterval :
  unitInterval.toMathlib = instTopologicalSpaceSubtype
def TextbookTopology.Path.toMathlib
def TextbookTopology.Path.fromMathlib
```

# 思维脉络（thinking trace）

`fromMathlib` 逐字段读取拓扑数据。闭集、邻域、同胚及空间构造桥分别使用补集、邻域展开、连续性桥和拓扑外延。实线桥把标准度量开集改写为绝对值 ε 邻域；单位区间桥复用 subtype 规范性。道路桥再转换连续性并原样保留参数函数与端点，两侧往返由道路外延成立。

# 自然语言 ↔ Lean 映射

基础拓扑往返对应 `equivMathlib`；同胚转换对应 `Homeomorphism.toMathlib/fromMathlib`；空间构造对应 `toMathlib_induced/subspace/product`；实线和单位区间对应 `toMathlib_realLine/unitInterval`；道路无损转换对应 `Path.toMathlib/fromMathlib` 及其往返定理。

# 依赖（人话版）

依赖既有拓扑与连续性桥、正式构造和标准实线的教材刻画，以及 Mathlib 的 `TopologicalSpace.ext`、`Homeomorph`、`unitInterval` 与 `Path`。没有建立新的拓扑概念，也没有调用同伦或基本群理论。

# 应用与陷阱

该等价只用于迁移已经存在的旧声明。新课程应直接量化 `[TopologicalSpace X]` 并使用 Mathlib 的 `Continuous`、`Path` 等接口；先用 `fromMathlib` 转回旧结构再继续开发，会重新制造已经冻结的平行层级，因此不属于允许的应用。
