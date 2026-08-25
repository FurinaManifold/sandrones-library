---
id: topology.foundation.mathlib-compatibility
family: topology.foundation
variant: legacy-carrier-equivalence
kind: bridge
state: staging
title: 旧教材拓扑与 Mathlib 拓扑的兼容等价
summary: 证明冻结的 TextbookTopology 与 Mathlib TopologicalSpace 具有完全相同的开集数据，并建立双向结构等价以支持分层迁移
premises: [topology.foundation.structure]
mathlib: [TopologicalSpace, IsOpen]
provenance:
  source_type: migration
  ref: "Topology Mathlib reuse migration RFC"
---

# 动机

早期拓扑课程为了展示开集公理，自建了 `TextbookTopology`；Mathlib 的 `TopologicalSpace` 实际采用完全相同的开集数据和三条公理。继续同时发展两套道路、同伦和基本群会制造无必要的转换成本，因此新课程改用 Mathlib 正式承载，同时为旧成果保留可验证的迁移通道。

# 直觉

两种结构都只记录“哪些集合开”，以及全空间开、有限交开、任意并开。转换时逐字段原样复制即可；来回转换后开集谓词不变，而其余字段都是命题证明，所以结构本身也不变。

# 陈述（自然语言）

任意 Mathlib 拓扑都能转成旧教材拓扑，且开集逐一定义相同。从 Mathlib 转旧再转回，或从旧转 Mathlib 再转回，都得到原结构。因此二者作为拓扑结构的载体等价。

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
```

# 思维脉络（thinking trace）

`fromMathlib` 逐字段读取 `TopologicalSpace` 的开集谓词和公理。Mathlib 一侧的往返等式使用 `TopologicalSpace.ext`，只需核对开集谓词；旧结构一侧析构结构后即可由定义归约完成。最后把两个转换和两条往返定理组装成 `Equiv`。

# 自然语言 ↔ Lean 映射

“同一批开集”对应 `isOpen_fromMathlib`；“Mathlib 一侧来回不变”对应 `toMathlib_fromMathlib`；“旧结构一侧来回不变”对应 `fromMathlib_toMathlib`；“结构等价”对应 `equivMathlib`。这里的 `Equiv` 比只给一个单向函数更强，明确排除了转换丢失拓扑信息的可能。

# 依赖（人话版）

只依赖旧结构已有的显式 `toMathlib` 桥和 Mathlib 的 `TopologicalSpace.ext`。没有建立新的拓扑概念，也没有调用道路、同伦或基本群理论。

# 应用与陷阱

该等价只用于迁移已经存在的旧声明。新课程应直接量化 `[TopologicalSpace X]` 并使用 Mathlib 的 `Continuous`、`Path` 等接口；先用 `fromMathlib` 转回旧结构再继续开发，会重新制造已经冻结的平行层级，因此不属于允许的应用。

