---
id: topology.homotopy.path-definition-foundation
family: topology.homotopy
variant: textbook-unit-interval
kind: definition
state: staging
title: 道路与环路的正式承载
summary: 解释 Mathlib Path 如何打包单位区间上的连续轨迹与端点，并保留旧道路结构作为迁移兼容层
premises: [topology.foundation.real-line, topology.foundation.structure]
mathlib: [Path, Path.refl, Path.map, unitInterval]
provenance:
  source_type: book
  ref: "Hatcher, Algebraic Topology, Section 1.1"
---

# 动机

道路、同伦和单连通性是复分析全局 Cauchy 理论的拓扑基础。Mathlib `Path` 可以作为正式起点，但必须把它携带的参数函数、连续性和端点条件逐项解释清楚。

# 直觉

道路是在单位时间内连续移动的轨迹。Mathlib 把连续函数包装为 `ContinuousMap`，再附加零、一两个端点等式；环路就是起点和终点相同的道路，连续映射用 `Path.map` 逐点作用。

# 陈述（自然语言）

`Path x y` 非空，当且仅当存在连续函数 `f:[0,1]→X`，满足 `f(0)=x`、`f(1)=y`。`Path.refl` 给出常值道路，`Path.map` 给出连续像；环路直接写成 `Path x x`。旧本库 `Path/Loop` 只为已提交下游保留。

# 陈述（Lean 对照）

```lean
theorem nonempty_path_iff_exists_continuous [TopologicalSpace X] (x y : X) :
  Nonempty (Path x y) ↔
    ∃ f : unitInterval → X, Continuous f ∧ f 0 = x ∧ f 1 = y
def TextbookTopology.Path.toMathlib
def TextbookTopology.Path.fromMathlib
```

# 思维脉络（thinking trace）

正向拆开 `Path`，取得底层函数、连续性和两个端点等式；反向把这些数据填回结构。兼容模块借助单位区间拓扑等式和连续性桥，保持同一参数函数构造旧／新道路，并用道路外延证明两侧往返。

# 自然语言 ↔ Lean 映射

“单位时间”对应根 `unitInterval`；“连续轨迹与端点”对应 `nonempty_path_iff_exists_continuous`；“停留不动”对应 Mathlib `Path.refl`；“连续像”对应 `Path.map`；“基点环路”对应 `Path x x`；旧道路迁移对应 `TextbookTopology.Path.toMathlib/fromMathlib`。

# 依赖（人话版）

正式接口依赖 Mathlib 的 `Topology.Path`、标准 `unitInterval` 和根 `Continuous`。旧道路仍依赖旧单位区间与旧连续性，只作为冻结兼容层。

# 应用与陷阱

本批只迁移道路数据、常值道路与连续像；逆道路和拼接仍由相邻 Entry 单独迁移。新声明不得把 Mathlib 道路转回旧 `Path` 再开发。严格道路等式与道路同伦不能混淆，A2 仍锁定。
