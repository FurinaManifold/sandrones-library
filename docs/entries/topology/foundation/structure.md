---
id: topology.foundation.structure
family: topology.foundation
variant: open-set-axioms
kind: definition
state: staging
title: 拓扑、连续映射与同胚的正式承载
summary: 解释 Mathlib 的 TopologicalSpace、IsOpen、Continuous 与 Homeomorph 如何逐项实现教材定义，并保留旧显式结构的迁移兼容层
premises: [settheory.set.ext]
mathlib: [TopologicalSpace, IsOpen, IsClosed, Continuous, Homeomorph, TextbookTopology.equivMathlib]
provenance:
  source_type: book
  ref: "Munkres, Topology, Section 12"
---

# 动机

拓扑是复分析、流形和代数拓扑的共同语言。课程需要先说明“拓扑、连续、同胚究竟是什么”，但这不要求复制一套与 Mathlib 同构的基础设施。本条把 Mathlib 的成熟接口作为正式承载，并用可展开的教材刻画说明其含义。

# 直觉

一个拓扑只规定哪些集合叫开集：全集开，有限交保持开，任意并保持开；空集作为空族的并自动开放。函数连续是指开集原像开；同胚是一个集合等价，其正向和反向函数都连续。Mathlib 把拓扑放在 typeclass 中，让同一段定理可以自动取得当前空间的拓扑。

# 陈述（自然语言）

`TopologicalSpace X` 记录 `X` 上的开集谓词和教材开集公理；`IsClosed s` 表示补集开。`Continuous f` 当且仅当每个开集的原像开，也当且仅当每个闭集的原像闭。集合 `s` 属于 `x` 的邻域滤子，当且仅当 `s` 包含一个含 `x` 的开集。`X ≃ₜ Y` 存在，当且仅当存在集合等价 `e : X ≃ Y`，使 `e` 和 `e.symm` 都连续。旧 `TextbookTopology` 具有相同数据，但只作为已经提交模块的迁移兼容层。

# 陈述（Lean 对照）

```lean
theorem topologicalSpace_open_axioms [TopologicalSpace X] :
  IsOpen Set.univ ∧ (∀ s t, IsOpen s → IsOpen t → IsOpen (s ∩ t)) ∧
    ∀ S, (∀ s ∈ S, IsOpen s) → IsOpen (⋃₀ S)

theorem continuous_iff_preimage_open [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) :
  Continuous f ↔ ∀ u, IsOpen u → IsOpen (f ⁻¹' u)

theorem continuous_iff_preimage_closed [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) :
  Continuous f ↔ ∀ s, IsClosed s → IsClosed (f ⁻¹' s)

theorem mem_nhds_iff_exists_open [TopologicalSpace X] (x : X) (s : Set X) :
  s ∈ 𝓝 x ↔ ∃ u, IsOpen u ∧ x ∈ u ∧ u ⊆ s

theorem nonempty_homeomorph_iff_exists_equiv [TopologicalSpace X] [TopologicalSpace Y] :
  Nonempty (X ≃ₜ Y) ↔
    ∃ e : X ≃ Y, Continuous e ∧ Continuous e.symm

def TextbookTopology.equivMathlib : TextbookTopology X ≃ TopologicalSpace X
```

# 思维脉络（thinking trace）

先读取 `TopologicalSpace` 的开集字段，把全集、二交和任意并汇成 `topologicalSpace_open_axioms`，让读者看到 typeclass 中保存的数学内容。随后用 `continuous_def` 展开 `Continuous`，借助补集推出闭集刻画；再展开 `mem_nhds_iff`，把滤子成员重排成教材的“包含含点开集”。最后把 `Homeomorph` 拆成底层集合等价与正逆连续性。旧结构没有立即删除：兼容模块逐字段在两种拓扑之间转换，并证明两侧往返都是恒等。

# 自然语言 ↔ Lean 映射

“当前空间的拓扑”对应隐式参数 `[TopologicalSpace X]`；“开集”与“闭集”对应根命名空间 `IsOpen`、`IsClosed`；两种连续性刻画分别对应 `continuous_iff_preimage_open` 与 `continuous_iff_preimage_closed`；“邻域”对应 `s ∈ 𝓝 x` 和 `mem_nhds_iff_exists_open`；“双向连续的双射”对应 `Homeomorph` 和 `nonempty_homeomorph_iff_exists_equiv`；“旧结构不丢失信息”对应 `TextbookTopology.equivMathlib`。方括号表示 Lean 通过 typeclass 自动传递拓扑，并不是省略数学假设。

# 依赖（人话版）

正式承载依赖 Mathlib 的基础拓扑与同胚定义；这些接口与 Munkres 的开集公理、连续和同胚定义语义一致。`MathlibCompatibility.lean` 另行保存旧 `TextbookTopology` 与 `TopologicalSpace` 的结构等价，供旧下游逐波迁移。

# 应用与陷阱

新定理必须直接使用 `[TopologicalSpace X]`、根 `Continuous` 和 `X ≃ₜ Y`，不能先用 `fromMathlib` 转回旧结构再继续发展。旧 `TextbookTopology`、同名 `Continuous` 和 `Homeomorphism` 仍在源码中，只是为了保持已提交道路与同伦模块可编译；它们不是新的课程入口，也不会注册成全局拓扑实例。
