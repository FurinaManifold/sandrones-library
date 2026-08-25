---
id: topology.fundamental-group.functoriality-standard
family: topology.fundamental-group
variant: induced-maps-homotopy-invariance
kind: theorem
state: staging
title: 基本群的函子性、基点变换与同伦不变性
summary: 解释连续映射诱导基本群同态及其恒等复合律，并以自然同构准确表达同伦映射的诱导关系
premises: [topology.fundamental-group.operations-standard, topology.homotopy.equivalence-standard]
mathlib: [FundamentalGroup.map, FundamentalGroup.mapOfEq, FundamentalGroup.fundamentalGroupMulEquivOfPath, FundamentalGroupoidFunctor.homotopicMapsNatIso, FundamentalGroupoidFunctor.equivOfHomotopyEquiv]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

基本群的价值不仅在于给单个空间附加一个群，还在于连续映射会把环路送成环路并保持拼接，从而诱导群同态。恒等映射和映射复合必须分别对应恒等同态和同态复合，这使基本群成为带基点拓扑空间上的函子。同伦映射则应产生相同的拓扑信息，但当同伦移动基点时，正确关系是沿基点轨迹的共轭，而不是两个同态字面相等。

# 直觉

给定 `f : X → Y`，把基点 `x` 处的环路逐点送入 `f`，就得到 `f x` 处的环路；端点固定同伦也能逐点送入 `f`，所以操作在同伦类上良定义。若同伦 `H` 把 `f` 连到 `g`，点 `x` 在同伦期间走出的轨迹从 `f x` 连到 `g x`。任何环路都可以先按 `f` 映射再接这条轨迹，或先接轨迹再按 `g` 映射；方形同伦说明两条合成道路属于同一同伦类。

# 陈述（自然语言）

`FundamentalGroup.map f x` 是从 `π₁(X,x)` 到 `π₁(Y,f(x))` 的群同态，其在道路商上的作用就是 `Path.Homotopic.Quotient.map`。恒等映射诱导恒等群同态，复合 `g ∘ f` 诱导的同态等于先应用 `f_*` 再应用 `g_*`。从 `f` 到 `g` 的同伦诱导基本群胚函子间的自然同构；在 `x` 处的分量就是同伦轨迹 `H.evalAt x` 的道路类，自然性等式表达两个诱导映射之间的基点变换共轭。

# 陈述（Lean 对照）

```lean
theorem fundamentalGroup_map_id (x : X) :
  FundamentalGroup.map (.id X) x = MonoidHom.id (FundamentalGroup X x)

theorem fundamentalGroup_map_comp (f : C(X, Y)) (g : C(Y, Z)) (x : X) :
  FundamentalGroup.map (g.comp f) x =
    (FundamentalGroup.map g (f x)).comp (FundamentalGroup.map f x)
```

`homotopicMapsNatIso_app_eq_pathClass` 展开自然同构分量；`homotopicMapsNatIso_naturality_loop` 给出环路上的自然性方程。若另有证明 `h : f x = y`，Mathlib 的 `FundamentalGroup.mapOfEq f h` 把目标类型改写到指定基点 `y`。

# 思维脉络（thinking trace）

诱导同态的道路公式和自然同构分量按定义成立。恒等律与复合律在任意商类上证明时，先用 `Path.Homotopic.Quotient.ind` 选择一个代表道路；对代表元，逐点恒等映射和函数复合均按定义化简。自然性定理直接专门化自然变换的 `naturality` 字段，它背后的 Mathlib 证明使用同伦方形把“映射道路再走轨迹”和“先走轨迹再映射道路”联系起来。

# 自然语言 ↔ Lean 映射

“诱导群同态”对应 `FundamentalGroup.map`；“指定相等基点”对应 `mapOfEq`；“基点变换”对应 `fundamentalGroupMulEquivOfPath`；“同伦映射的自然同构”对应 `homotopicMapsNatIso`；“同伦等价诱导基本群胚等价”对应 `equivOfHomotopyEquiv`；“同伦期间的基点轨迹”对应 `ContinuousMap.Homotopy.evalAt`。

# 依赖（人话版）

本条目依赖道路同伦商、基本群承载、基本群运算以及一般连续映射同伦。Mathlib 的 `ContinuousMap`、`MonoidHom`、自然同构、范畴等价和基点变换乘法等价都与教材语义一致，直接作为正式承载；本库新增的是恒等/复合的教材级接口和自然同构分量、自然性方程的可见展开，不重建函子或群同态结构。

# 应用与陷阱

`fundamentalGroupMulEquivOfPath p` 依赖所选道路 `p`；在道路连通空间中由 `fundamentalGroupMulEquivOfPathConnected` 选出的等价也不是规范选择。`equivOfHomotopyEquiv` 给出基本群胚等价，但若要比较两个预先指定的目标基点，仍须提供基点等式或连接道路。尤其当 `H.evalAt x` 不是恒定道路时，`f_*` 与 `g_*` 的正确关系是自然性/共轭，不是字面相等。本条目不声称圆周基本群为整数，也不处理单连通、可缩或积空间计算；这些属于 F2c。
