---
id: topology.covering.definition-standard
family: topology.covering
variant: mathlib-evenly-covered-product-chart-with-optional-surjectivity
kind: definition
state: research
title: 覆盖映射与均匀覆盖邻域
summary: 直接采用 Mathlib 的均匀覆盖点与覆盖映射谓词，展开离散纤维乘积图，并说明连续、开映射、局部同胚及满射时为商映射
premises: []
mathlib: [IsEvenlyCovered, IsCoveringMap, Homeomorph, DiscreteTopology, IsLocalHomeomorph, IsQuotientMap]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

覆盖空间把一个基空间的小邻域“复制”为若干互不混合的 sheet。道路提升和同伦提升都依赖同一个局部
乘积结构，因此必须在进入提升定理前冻结覆盖映射的 carrier、纤维索引和满射约定。本条目直接解释
Mathlib 的成熟接口，不再建立本库 `CoveringMap` structure。

# 教材定义

对映射 `p : E → X`，点 `x : X` 被均匀覆盖，是指存在包含 `x` 的开邻域 `U`，使 `p⁻¹(U)` 与
`U × I` 同胚，其中 `I` 是离散空间，并且该同胚的第一坐标正是 `p`。直观上，每个 `i : I` 给出一张
位于 `p⁻¹(U)` 中、同胚投影到 `U` 的 sheet。

覆盖映射要求每个基点都被均匀覆盖。Mathlib 选择该点的实际纤维 `p⁻¹({x})` 作为离散索引，避免额外
选择一个等势类型。

# Lean 正式承载

```lean
def IsEvenlyCovered (p : E → X) (x : X) (I : Type*) [TopologicalSpace I] : Prop :=
  DiscreteTopology I ∧
    ∃ U, x ∈ U ∧ IsOpen U ∧ IsOpen (p ⁻¹' U) ∧
      ∃ H : p ⁻¹' U ≃ₜ U × I, ∀ e, (H e).1.1 = p e

def IsCoveringMap (p : E → X) : Prop :=
  ∀ x, IsEvenlyCovered p x (p ⁻¹' {x})
```

本模块的两个 `..._iff_...` 定理公开上述量词展开；`coveringMap_exists_open_product_neighborhood` 从
覆盖映射证书提取每点的实际开乘积图。

# 与常见教材约定的差异

Mathlib 的 `IsCoveringMap p` 不要求 `p` 满射，因此允许某些基点纤维为空。此时定义仍要求空原像在
某个邻域上保持为空；这对限制到映射像之外的点和局部接口很方便。许多教材把满射写进“覆盖映射”
定义；在本库使用这种约定时必须显式同时假设 `Function.Surjective p`，不能从 `IsCoveringMap p`
自动推出。

在额外满射假设下，`coveringMap_isQuotientMap_of_surjective` 说明 `p` 是商映射。这里没有另定义
“surjective covering map”谓词，以免复制一个只多一个合取的 carrier。

# 基本性质

`coveringMap_discreteTopology_fiber` 给出每个实际纤维的离散拓扑。局部乘积图在每一点沿固定 sheet
限制为局部同胚，因此覆盖映射自动连续、开，并且是 `IsLocalHomeomorph`；三项由
`coveringMap_continuous_and_isOpenMap_and_isLocalHomeomorph` 统一展示。满射开连续映射进一步是
`IsQuotientMap`。

# 自然语言 ↔ Lean 映射

“均匀覆盖邻域”对应 `IsEvenlyCovered p x I`；“离散 sheet 索引”对应 `DiscreteTopology I`；“邻域
上的复制”对应 `H : p ⁻¹' U ≃ₜ U × I`；“投影与 p 相容”对应 `(H e).1.1 = p e`；“实际纤维”是
subtype `p ⁻¹' {x}`；“每点均匀覆盖”对应 `IsCoveringMap p` 的全称量词。`Homeomorph`、开集、连续、
局部同胚和商映射均直接采用 Mathlib 的语义一致承载。

# 证明与复用

两个刻画定理由定义展开得到；开乘积邻域与离散纤维分别投影 Mathlib `IsEvenlyCovered` 的证书及其
`discreteTopology_fiber` 定理。连续、开和局部同胚性质直接组合 Mathlib 已证明的标准结果；满射时的
商映射由开放映射判据得到。本库新增的是稳定的教材入口和差异说明，不重证底层 trivialization 理论。

# 应用与边界

AT2-C2 将在此 carrier 上冻结道路提升的起点、端点和唯一性量词；AT2-C3 再处理同伦提升。本条目本身
不选择任何提升、不定义 monodromy，也不讨论覆盖空间分类。Hatcher 第一章 §1.3 提供覆盖空间与提升
的教材语境；Mathlib product chart 允许空纤维这一实现边界已在上文明确披露。
