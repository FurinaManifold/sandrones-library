---
id: topology.foundation.mathlib-compatibility
family: topology.foundation
variant: legacy-carrier-equivalence
kind: bridge
state: staging
title: 旧教材拓扑与 Mathlib 拓扑的兼容等价
summary: 证明冻结的 TextbookTopology 与 Mathlib TopologicalSpace 及其诱导、子空间、积构造具有相同数据，并建立双向等价以支持分层迁移
premises: [topology.foundation.structure]
mathlib: [TopologicalSpace, IsOpen, IsClosed, nhds, Homeomorph]
provenance:
  source_type: migration
  ref: "Topology Mathlib reuse migration RFC"
---

# 动机

早期拓扑课程为了展示开集公理，自建了 `TextbookTopology`；Mathlib 的 `TopologicalSpace` 实际采用完全相同的开集数据和三条公理。继续同时发展两套道路、同伦和基本群会制造无必要的转换成本，因此新课程改用 Mathlib 正式承载，同时为旧成果保留可验证的迁移通道。

# 直觉

两种结构都只记录“哪些集合开”，以及全空间开、有限交开、任意并开。转换时逐字段原样复制即可；来回转换后开集谓词不变，而其余字段都是命题证明，所以结构本身也不变。

# 陈述（自然语言）

任意 Mathlib 拓扑都能转成旧教材拓扑，且开集和闭集逐一定义相同；旧邻域谓词正是 Mathlib 邻域滤子的成员关系。从 Mathlib 转旧再转回，或从旧转 Mathlib 再转回，都得到原结构。因此二者作为拓扑结构的载体等价；旧同胚也能无损转成正式 `Homeomorph`。旧诱导、子空间与积拓扑转到 Mathlib 后，分别严格等于规范构造和规范实例。

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
```

# 思维脉络（thinking trace）

`fromMathlib` 逐字段读取 `TopologicalSpace` 的开集谓词和公理。闭集桥使用“补集开”，邻域桥使用正式条目已经证明的 `mem_nhds_iff_exists_open`。Mathlib 一侧的拓扑往返等式使用 `TopologicalSpace.ext`，只需核对开集谓词；旧结构一侧析构结构后即可由定义归约完成。最后把两个转换和两条往返定理组装成 `Equiv`。同胚桥保留同一个底层 `Equiv`，并通过 `continuous_iff_mathlib` 转换正逆连续性证明。诱导和 subtype 桥在开集谓词层定义相同；积拓扑桥用正式的开矩形刻画逐项重排局部矩形数据。

# 自然语言 ↔ Lean 映射

“同一批开集、闭集”对应 `isOpen_fromMathlib` 和 `isClosed_toMathlib`；“教材邻域就是滤子邻域”对应 `isNeighborhood_iff_mem_nhds`；“Mathlib 一侧来回不变”对应 `toMathlib_fromMathlib`；“旧结构一侧来回不变”对应 `fromMathlib_toMathlib`；“结构等价”对应 `equivMathlib`；同胚的无损转换对应 `Homeomorphism.toMathlib`、`fromMathlib` 及其两条往返定理；三种空间构造的规范性对应 `toMathlib_induced/subspace/product`。

# 依赖（人话版）

依赖旧结构已有的显式 `toMathlib` 桥、正式基础条目的邻域刻画、正式构造条目的开矩形刻画，以及 Mathlib 的 `TopologicalSpace.ext` 和 `Homeomorph`。没有建立新的拓扑概念，也没有调用同伦或基本群理论。

# 应用与陷阱

该等价只用于迁移已经存在的旧声明。新课程应直接量化 `[TopologicalSpace X]` 并使用 Mathlib 的 `Continuous`、`Path` 等接口；先用 `fromMathlib` 转回旧结构再继续开发，会重新制造已经冻结的平行层级，因此不属于允许的应用。
