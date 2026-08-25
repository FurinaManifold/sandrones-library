---
id: topology.foundation.structure
family: topology.foundation
variant: open-set-axioms
kind: definition
state: verified
title: 拓扑、连续映射与同胚的库内定义层
summary: 以开集公理定义本库拓扑，并由此定义闭集、邻域、连续映射和同胚，再建立到 Mathlib 的显式桥
premises: [settheory.set.extensionality]
mathlib: [TextbookTopology.toMathlib, TextbookTopology.continuous_iff_mathlib]
provenance:
  source_type: book
  ref: "Munkres, Topology, Section 12"
---

# 动机

拓扑是复分析、流形和代数拓扑的共同语言。如果公开理论直接从 Mathlib 的专用结构开始，库内便没有可以解释和继续推导的教材定义链。本条先固定自己的开集公理，再把 Mathlib 降为实现后端。

# 直觉

一个拓扑只规定哪些集合叫开集：全集必须开，有限交保持开，任意并保持开。闭集、邻域、连续映射和同胚都能依次由“开集”定义，不需要另加新的原始概念。

# 陈述（自然语言）

`TextbookTopology X` 由 `X` 上的开集谓词以及三条公理组成。闭集是补集为开集的集合；`s` 是 `x` 的邻域，是指 `s` 包含某个含 `x` 的开集；连续映射要求每个开集的原像为开集；同胚是双射且正逆映射都连续。

# 陈述（Lean 对照）

```lean
structure TextbookTopology (X : Type*) where
  IsOpen : Set X → Prop
  isOpen_univ : IsOpen Set.univ
  isOpen_inter : ∀ s t, IsOpen s → IsOpen t → IsOpen (s ∩ t)
  isOpen_sUnion : ∀ S, (∀ s ∈ S, IsOpen s) → IsOpen (⋃₀ S)

def Continuous (τX : TextbookTopology X) (τY : TextbookTopology Y) (f : X → Y) : Prop :=
  ∀ v, τY.IsOpen v → τX.IsOpen (f ⁻¹' v)
```

# 思维脉络（thinking trace）

先以任意并公理作用于空集合族推出空集开，再以二元集合族推出两个开集的并开。随后所有映射概念只引用本库的 `IsOpen` 与 `Continuous`。互操作在独立的 `MathlibBridge.lean` 中构造 `toMathlib`，逐字段把三条公理交给 Mathlib，并证明连续性的两个定义完全一致。

# 自然语言 ↔ Lean 映射

“开集族”对应 `TextbookTopology.IsOpen`；“任意并”对应 `isOpen_sUnion`；“闭集”对应 `TextbookTopology.IsClosed`；“邻域”对应 `IsNeighborhood`；“开集原像开”对应 `Continuous`；“双向连续的双射”对应 `Homeomorphism`；“实现桥”对应 `toMathlib`。

# 依赖（人话版）

数学定义只依赖集合、补集、原像、交、任意并和集合间等价。`Foundation.lean` 不导入 Mathlib 拓扑层；`TopologicalSpace` 与 `continuous_def` 仅在隔离的 `MathlibBridge.lean` 中用于互操作校验。

# 应用与陷阱

后续道路、同伦、连通与单连通核心模块只能引用 `Foundation` 与 `Constructions`，不得导入 `MathlibBridge`。只有证明后端适配模块可按需安装 `toMathlib`；不要把它声明成全局实例，否则同一类型上的多个教材拓扑会发生实例歧义，也不要把桥后的 Mathlib 名称重新描述成本库定义。
