---
id: topology.covering.semilocally-simply-connected-standard
family: topology.covering
variant: open-neighborhood-inclusion-with-trivial-fundamental-group-image
kind: definition
state: verified
title: 半局部单连通空间
summary: 每一点具有一个开邻域，使该邻域 inclusion 诱导的基本群同态之像为底群，并给出小环路展开及强假设桥
premises: [topology.covering.lifting-criterion-standard, topology.fundamental-group.functoriality-standard]
mathlib: [FundamentalGroup.map, StronglyLocallyContractibleSpace, SimplyConnectedSpace, Path.Homotopic.Quotient.map_comp]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

覆盖空间分类需要用足够小的邻域制作 evenly-covered charts。局部道路连通只保证邻域中能选道路，并
不保证小环路在整个空间里消失；半局部单连通恰好补上后一项控制：每一点附近存在一个开邻域，该邻域
内的所有基环路放回全空间后都成为平凡同伦类。

这个性质比单连通弱，也不同于局部可缩。它不要求小邻域自身单连通，只要求 inclusion 在基本群上的
像平凡。

# 教材定义

拓扑空间 `X` 在点 `x` 半局部单连通，若存在含 `x` 的开集 `U`，使 inclusion `i : U ↪ X` 诱导的
同态 `i₍*₎ : π₁(U,x) → π₁(X,x)` 具有平凡像。若每一点都满足这个条件，则称 `X` 半局部单连通。

等价地，可要求 `U` 中每个以 `x` 为基点的环路，在作为 `X` 中的环路后端点固定零同伦。这里不要求
`U` 道路连通，也不把基点换到 `U` 的其他分支。

# Lean 正式接口

```lean
def SemilocallySimplyConnectedAt (x : X) : Prop :=
  ∃ (U : Set X) (_hU : IsOpen U) (hx : x ∈ U),
    (FundamentalGroup.map
      (⟨Subtype.val, continuous_subtype_val⟩ : C(U, X)) ⟨x, hx⟩).range = ⊥

class SemilocallySimplyConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  semilocallySimplyConnectedAt : ∀ x : X, SemilocallySimplyConnectedAt x

theorem semilocallySimplyConnectedAt_iff_exists_open_loops ...
theorem semilocallySimplyConnectedSpace_iff_forall_exists_open_loops ...
theorem semilocallySimplyConnectedSpace_of_stronglyLocallyContractible ...
theorem semilocallySimplyConnectedSpace_of_simplyConnected ...
```

# 主定义与小环路展开

主定义采用基本群同态的 `range = ⊥`，因为 C4b 提升判据及后续子群恢复都直接消费 subgroup inclusion。
开集 `U` 作为 subtype 获得子空间拓扑，基点是依赖证明的 `⟨x,hx⟩`，inclusion 则由 bundled
continuous map `⟨Subtype.val,continuous_subtype_val⟩` 承载。

点态 iff 的正向把任意 `q` 的像视为 range 成员，再用 range 为底群推出它等于 `1`；反向对 range
成员拆出原像 `q`，由每个 `q` 映为 `1` 得到 subgroup 小于等于底群。全局 iff 只逐点应用该展开，
没有建立第二个 loops predicate 或 class。

# 两个强假设桥

单连通时可取 `U=X`；目标基本群是 subsingleton，因此 inclusion 的每个基本群元素都映为单位元。这个
结论说明半局部单连通并不额外要求局部结构，但不把单连通当成定义。

强局部可缩时，Mathlib `contractible_basis` 给出含 `x` 的可缩邻域 `S`。从 `S ∈ 𝓝 x` 缩出开集
`U⊆S` 后，`U→X` 经 `U→S→X` 因子化；`S` 可缩因而单连通，第一段在基本群上的像平凡，再由道路
同伦商 `map_comp` 得出 inclusion `U→X` 的像平凡。两项桥都只是普通 theorem，当前不注册 instance。

# 自然语言 ↔ Lean 映射

“开邻域”由 `U : Set X`、`IsOpen U` 和 `hx : x∈U` 分开记录；“inclusion 诱导基本群同态”是
`FundamentalGroup.map ... ⟨x,hx⟩`；“像平凡”是该同态的 `Subgroup.range = ⊥`；“所有小基环路”量化
`q : FundamentalGroup U ⟨x,hx⟩` 并要求映射结果为 `1`。全局 class 的字段只负责为每个 `x` 提供
点态主定义，没有额外数据或选择函数。

# 类型假设和依赖

主定义只要求 `TopologicalSpace X`，不要求 `X` 道路连通、局部道路连通、Hausdorff 或非空。指定
点 `x` 已处理当前连通分支；分类阶段若想以单一基本群描述整个空间，仍须另加道路连通假设。

本模块复用基本群 functoriality、Mathlib `SimplyConnectedSpace` 与
`StronglyLocallyContractibleSpace`。后两者只是充分条件：局部道路连通本身不推出当前性质，较弱的
`LocallyContractibleSpace` 也没有在本批被静默升级为桥。

# 应用与边界

半局部单连通将在 C5c 中保证道路类商投影具有均匀覆盖邻域，是一般 universal cover 存在性的局部
假设。本批只建立定义层，没有构造道路类商、覆盖映射、子群恢复、pointed/unpointed 分类或 universal
cover。非连通 cover 不能由这里的单一基点定义自动对应一个子群；该区别仍属于后续分类路线。
