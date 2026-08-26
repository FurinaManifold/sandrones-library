---
id: topology.covering.monodromy-standard
family: topology.covering
variant: path-class-fiber-transport-and-closed-lift-fixed-point
kind: theorem
state: verified
title: 覆盖映射的 monodromy
summary: 将道路同伦类的 fiber transport 识别为标准道路提升终点，并以 monodromy 不动点刻画环路提升闭合
premises: [topology.covering.homotopy-lifting-standard]
mathlib: [IsCoveringMap.monodromy, IsCoveringMap.monodromy_refl, IsCoveringMap.monodromy_trans_apply, IsCoveringMap.monodromy_bijective, IsCoveringMap.monodromyPerm]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

沿基空间道路提升一个 fiber 点，会在道路终点上方得到另一个 fiber 点。C3 的同伦提升说明端点固定
同伦不会改变这个结果，因此道路同伦类在 fibers 之间产生 transport。对基环路，这些 transports
组成基本群在单个 fiber 上的作用，即 monodromy；提升是否闭合则成为一个不动点问题。

# 教材定理

设 `p : E → X` 是覆盖映射。道路类 `[γ] : x → y` 把 `x` 上方的点 `e` 送到从 `e` 出发的道路提升
终点；这个 transport 只依赖 `[γ]`，并且是两个 fibers 之间的双射。若 `γ` 是基于 `x` 的环路，则
其提升从 `e` 出发后闭合，当且仅当 `[γ]` 的 monodromy 固定 `e`。

# Lean 正式接口

```lean
theorem coveringMap_monodromy_mk_eq_pathLift_endpoint ... :
    cov.monodromy ⟦gamma⟧ e =
      ⟨coveringMapPathLift cov gamma e.1 e.2 1, ...⟩

theorem coveringMap_pathLift_closed_iff_monodromy_fixed ... :
    coveringMapPathLift cov gamma e.1 e.2 1 = e.1 ↔
      cov.monodromy ⟦gamma⟧ e = e
```

# Carrier 与提升终点

Mathlib `cov.monodromy gamma e` 已经以 `Path.Homotopic.Quotient x y` 为道路类 carrier，并返回目标
fiber subtype `p ⁻¹' {y}` 中的点。本库不定义第二套 transport。第一条桥定理说明，对代表
`gamma : Path x y`，其底层点恰是 C2 `coveringMapPathLift` 在 `1` 的值；subtype 的 fiber 证书来自
C2 endpoint theorem，而不是额外选择。

第二条桥在 `x=y` 时把底层终点等式与 subtype 等式相互转换，因此“提升闭合”和“monodromy 固定
初始 fiber 点”具有完全相同的量词。

# 恒等、复合与逆道路方向

Mathlib `monodromy_refl` 说明常道路类作用为恒等；`monodromy_trans_apply` 的公式是
`monodromy (gamma.trans gamma') e = monodromy gamma' (monodromy gamma e)`。因此 `Path.trans` 的语义
是先走 `gamma`、再走 `gamma'`，函数复合书写顺序相反。基本群乘法沿用 Mathlib 已冻结的约定，
`monodromyPerm` 已把这些 transports 组装为置换表示。

逆道路 `gamma.symm` 给出反向 transport：它与原 transport 互逆，这是把
`monodromy_trans_apply` 应用于 `gamma.trans gamma.symm`、再用 `monodromy_refl` 得到的结果；Mathlib
`monodromy_bijective` 已统一记录任意道路类 transport 的双射性。本库不为这些现成定理增加别名。

# 自然语言 ↔ Lean 映射

fiber `p⁻¹(x)` 是 subtype `p ⁻¹' {x}`；道路同伦类是 `Path.Homotopic.Quotient x y`；代表道路写作
`gamma : Path x y`，其商类为 `⟦gamma⟧`；“提升终点”是 C2 标准道路 `coveringMapPathLift ...` 在
`1 : unitInterval` 的值；基本群作用由 `monodromyPerm : FundamentalGroup X x →*
Equiv.Perm (p ⁻¹' {x})` 正式承载。

# 类型假设和依赖

总空间与基空间只需拓扑结构及 `IsCoveringMap p`。输入的 subtype 点已经见证起点 fiber 非空，不要求
覆盖映射按另一种教材约定全局满射，也不要求空间道路连通、局部道路连通或 Hausdorff。C2 提供标准
道路提升终点，C3/Mathlib 同伦提升保证 monodromy 对道路同伦类良定义。

# 应用与边界

闭环不动点刻画是 C4b 提升判据的环路语言，也是后续研究覆盖投影诱导基本群子群的入口。本批没有
陈述全局映射提升 iff、没有构造 universal cover，也没有给出覆盖空间分类；这些不能由
`monodromy_bijective` 单独推出。具体环路和特殊空间的置换计算归 Examples。
