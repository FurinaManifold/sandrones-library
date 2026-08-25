---
id: topology.fundamental-group.triviality-standard
family: topology.fundamental-group
variant: simply-connected-contractible-convex
kind: theorem
state: staging
title: 单连通与可缩空间的平凡基本群
summary: 由道路同伦类唯一推出单连通空间基本群平凡，并专门化到可缩空间与非空凸集
premises: [topology.fundamental-group.operations-standard, topology.homotopy.equivalence-standard]
mathlib: [SimplyConnectedSpace, simply_connected_iff_unique_homotopic, SimplyConnectedSpace.ofContractible, Convex.contractibleSpace]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

基本群用环路探测空间中的洞。若空间单连通，任意两条同端点道路都同伦，特别地每条基点环路都同伦于恒等环路，所以基本群只能有一个元素。可缩空间可以连续收缩到一点，是单连通空间的主要来源；凸集沿直线收缩到任一点，因而给出最常用的具体例子。

# 直觉

在道路同伦商中，“所有环路都能收缩”表示任意商类都等于恒等道路类。F2a 已说明基本群的单位元正是这个恒等类，因此基本群元素全等于 `1`。可缩性通过同伦等价于单点空间提供单连通性；非空凸集选一个中心，用线段同伦把每一点拉到中心。

# 陈述（自然语言）

在单连通空间的任意基点处，每个基本群元素都等于单位元，每个环路同伦商类都等于恒等道路类。在任意可缩空间中同样成立。若 `s` 是实拓扑向量空间中的非空凸集，则子空间 `s` 可缩，因此 `s` 在任意基点处的基本群平凡。

# 陈述（Lean 对照）

```lean
theorem fundamentalGroup_eq_one_of_simplyConnected
    [SimplyConnectedSpace X] (g : FundamentalGroup X x) : g = 1

theorem fundamentalGroup_eq_one_of_contractible
    [ContractibleSpace X] (g : FundamentalGroup X x) : g = 1

theorem fundamentalGroup_eq_one_of_convex
    (hs : Convex ℝ s) (hne : s.Nonempty)
    (x : s) (g : FundamentalGroup s x) : g = 1
```

# 思维脉络（thinking trace）

Mathlib 的 `simply_connected_iff_unique_homotopic` 把单连通解释为非空且每对端点间的道路同伦商唯一，并据此为 `FundamentalGroup X x` 建立 `Subsingleton` 实例。前三个结论直接使用 `Subsingleton.elim`。凸集结论先调用 `Convex.contractibleSpace` 得到子空间的可缩实例，再沿 `ContractibleSpace → SimplyConnectedSpace → Subsingleton FundamentalGroup` 的定义链结束。

# 自然语言 ↔ Lean 映射

“单连通空间”对应 `SimplyConnectedSpace`；“道路同伦类唯一”对应 `simply_connected_iff_unique_homotopic`；“基本群平凡”在元素层写成 `g = 1`；“可缩空间”对应 `ContractibleSpace`；“非空凸集可缩”对应 `Convex.contractibleSpace hs hne`；“恒等环路类”对应 `Path.Homotopic.Quotient.refl x`。

# 依赖（人话版）

本条目依赖 F1 的道路同伦商和基本群承载、F2a 的单位元解释，以及 Mathlib 的标准单连通与可缩结构。`SimplyConnectedSpace`、`ContractibleSpace`、`Convex` 和子空间拓扑均与教材语义一致，直接复用；本库不再定义第二套“平凡群”谓词，而用所有元素等于单位元这一可操作结论表达计算结果。

# 应用与陷阱

“基本群平凡”不反推空间单连通：单连通还包含道路连通性，并且高维洞也不由基本群完全探测。凸集结论要求非空，否则无法选择收缩中心；其基本群是在子空间拓扑 `s` 上计算，不是环境空间 `E` 的基本群。本条目没有计算圆周基本群，也没有用某个现成最终等价包装 `π₁(S¹) ≅ ℤ`；圆周需要独立的覆盖空间、提升与绕数证明链。
