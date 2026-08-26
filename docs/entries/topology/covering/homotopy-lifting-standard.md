---
id: topology.covering.homotopy-lifting-standard
family: topology.covering
variant: unique-cylinder-lift-with-continuous-initial-slice
kind: theorem
state: research
title: 覆盖映射的同伦提升存在唯一性
summary: 给定参数化同伦及时间零切片的连续提升，构造整个参数柱上的唯一连续提升及其时间一端点映射
premises: [topology.covering.path-lifting-standard, topology.homotopy.standard]
mathlib: [IsCoveringMap.liftHomotopy, IsCoveringMap.eq_liftHomotopy_iff', ContinuousMap.Homotopy, ContinuousMap]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

道路提升只控制一条道路。若道路随参数 `a : A` 连续变化，真正需要的是所有提升也随 `(t,a)` 联合
连续变化。覆盖映射的同伦提升性质正把时间零时刻已经选定的一整族提升，唯一延拓到整个参数柱
`I × A`；它是证明道路提升只依赖端点固定同伦类、构造 monodromy 和研究覆盖分类的关键桥梁。

# 教材定理

设 `p : E → X` 为覆盖映射，`H : I × A → X` 为连续映射，并给定连续映射
`f0Lift : A → E`，满足每个 `a` 都有 `H(0,a)=p(f0Lift(a))`。则存在唯一连续映射
`Hlift : I × A → E`，使 `p ∘ Hlift = H`，且 `Hlift(0,a)=f0Lift(a)`。

这里初值不是单个点，也不是任意逐点选择 `a ↦ e_a`，而是整个时间零切片的连续提升。这个连续性
正是结论中对参数 `a` 的联合连续性所需的数据。

# Lean 正式接口

```lean
theorem existsUnique_coveringMap_homotopyLift
    (cov : IsCoveringMap p) (H : C(unitInterval × A, X))
    (f0Lift : C(A, E)) (H0 : ∀ a, H (0, a) = p (f0Lift a)) :
    ∃! Hlift : C(unitInterval × A, E),
      p ∘ Hlift = H ∧ ∀ a, Hlift (0, a) = f0Lift a

noncomputable def coveringMapHomotopyLiftEndpoint ... : C(A, E)

noncomputable def coveringMapHomotopyLift ... :
    f0Lift.Homotopy (coveringMapHomotopyLiftEndpoint cov F f0Lift hf0)

theorem coveringMapHomotopyLift_lifts ... :
    p (coveringMapHomotopyLift cov F f0Lift hf0 z) = F z

theorem coveringMapHomotopyLiftEndpoint_lifts ... :
    p (coveringMapHomotopyLiftEndpoint cov F f0Lift hf0 a) = f1 a
```

# 为什么初始提升是整个连续映射

对每个固定 `a` 使用 C2 道路提升，只会分别得到函数 `I → E`。这并不自动证明把它们拼成的
`I × A → E` 对 `a` 连续。教材同伦提升定理的参数版本必须从 `f0Lift : C(A,E)` 出发，并直接证明
柱面上的联合连续提升；本模块因此直接消费 Mathlib 已完成的 `liftHomotopy`，不从 C2 逐点重建。

同理，时间一的提升 `a ↦ Hlift(1,a)` 自动是连续映射，而不是一族未经连续性证明的 fiber 点。它由
输入唯一决定，不作为额外目标条件预先指定。

# 自然语言 ↔ Lean 映射

“参数柱”是 `unitInterval × A`；“连续同伦”首先由 `ContinuousMap` 承载，标准端点索引视图则是
`ContinuousMap.Homotopy`；“时间零切片的连续提升”是 `f0Lift : C(A,E)` 与逐点兼容式 `H0`；“投影
回原同伦”是函数等式 `p ∘ Hlift = H`；“唯一”由 `∃!` 表达。对标准同伦 `F : f0.Homotopy f1`，
`hf0 : p ∘ f0Lift = f0` 提供零时刻兼容式，时间一切片则定义
`coveringMapHomotopyLiftEndpoint`。

# 证明与 Mathlib 复用

存在 witness 直接取 `cov.liftHomotopy H f0Lift H0`；`liftHomotopy_lifts` 给出投影方程，
`liftHomotopy_zero` 给出初始切片。Mathlib `eq_liftHomotopy_iff'` 说明任何满足同样两项条件的连续候选
都等于该 witness，因此得到严格的 `∃!`。

标准 `Homotopy` 只是同一个柱面连续映射的端点索引视图：零端由 Mathlib 定理填充，一端按定义为
时间一切片。两条投影定理分别在任意 `(t,a)` 和 `(1,a)` 处消费原投影方程。没有复制 Mathlib 的
局部 sheet 延拓算法，也没有引入新的同伦 carrier。

# 类型假设和依赖

`E`、`X`、`A` 只要求拓扑空间结构；不要求 `A` 连通、局部道路连通或 Hausdorff，也不额外要求
`p` 满射。输入的 `f0Lift` 已为实际使用到的基点提供 fiber 元素，因此与 C1 记录的 Mathlib
非满射约定相容。

# 应用与边界

本批给出参数化同伦的存在唯一提升、确定的时间一映射以及标准同伦视图。它尚不证明端点固定／相对
子空间的提升定理、道路同伦诱导的 monodromy 相容性、提升判据或覆盖空间分类；这些必须作为后续
消费者单独陈述，而不能从当前接口名称中推断出来。
