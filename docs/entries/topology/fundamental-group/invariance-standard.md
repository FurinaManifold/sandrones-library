---
id: topology.fundamental-group.invariance-standard
family: topology.fundamental-group
variant: basepoint-change-homotopy-equivalence
kind: theorem
state: staging
title: 基本群的基点变换与同伦等价不变性
summary: 展开指定目标基点的 transport 与沿道路换基点的共轭，并从基本群胚等价提取对应基点基本群等价
premises: [topology.fundamental-group.functoriality-standard, topology.homotopy.equivalence-standard]
mathlib: [FundamentalGroup.mapOfEq, FundamentalGroup.fundamentalGroupMulEquivOfPath, FundamentalGroupoidFunctor.equivOfHomotopyEquiv, CategoryTheory.Functor.FullyFaithful.mulEquivEnd]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

基本群依赖基点，但这种依赖有精确的控制。若两个基点由道路连接，沿该道路作共轭就得到两个基本群的群同构；不同连接道路可能给出不同共轭，所以这不是无条件的规范等价。同伦等价保留全部道路同伦信息，因而在对应基点处必然诱导基本群同构。

# 直觉

要把基点 `x₀` 处的环路搬到 `x₁`，先沿连接道路 `p` 的反向从 `x₁` 回到 `x₀`，走完原环路，再沿 `p` 回到 `x₁`。因此得到 `p⁻¹ · g · p`。若目标基点只是通过等式与 `f x` 识别，Lean 还必须显式 transport 两个端点。同伦等价则先给出整个基本群胚的范畴等价；fully faithful 函子在每个对象的自同态上给出乘法等价。

# 陈述（自然语言）

`mapOfEq` 的道路公式是沿连续映射送出环路类后，用基点等式改写两个端点。道路 `p : x₀ → x₁` 给出的换基点等价把 `g` 送到 `p⁻¹`、`g`、`p` 依次拼接的同伦类。任意同伦等价 `e : X ≃ₕ Y` 在 `x` 与 `e(x)` 处诱导基本群乘法等价，其正向函数正是 `e` 的正向连续映射诱导的群同态。

# 陈述（Lean 对照）

```lean
theorem fundamentalGroup_changeBasepoint_toPath
    (p : Path x₀ x₁) (g : FundamentalGroup X x₀) :
  FundamentalGroup.toPath (FundamentalGroup.fundamentalGroupMulEquivOfPath p g) =
    (Path.Homotopic.Quotient.mk p).symm.trans
      ((FundamentalGroup.toPath g).trans (Path.Homotopic.Quotient.mk p))

noncomputable def fundamentalGroupMulEquivOfHomotopyEquiv
    (e : X ≃ₕ Y) (x : X) : FundamentalGroup X x ≃* FundamentalGroup Y (e x)
```

# 思维脉络（thinking trace）

`mapOfEq_apply` 已给 transport 公式，转换到 `toPath` 后直接使用。换基点等价在 Mathlib 中由连接道路类构成群胚同构，再调用 `Iso.conj`；展开 `Iso.conj_apply` 就得到逆道路、原环路和正道路的三段拼接。同伦等价先由 `equivOfHomotopyEquiv` 变成基本群胚等价，其正向函子 fully faithful；`mulEquivEnd` 把基点对象的自同态群等价提取出来。

# 自然语言 ↔ Lean 映射

“指定相等目标基点”对应 `FundamentalGroup.mapOfEq`；“端点 transport”对应 `Path.Homotopic.Quotient.cast`；“沿道路改变基点”对应 `fundamentalGroupMulEquivOfPath`；“共轭”对应 `Iso.conj`；“同伦等价诱导基本群胚等价”对应 `equivOfHomotopyEquiv`；“从 fully faithful 函子提取自同态群等价”对应 `Functor.FullyFaithful.mulEquivEnd`。

# 依赖（人话版）

本条目依赖 F2b1 的连续映射诱导同态与同伦自然性，以及标准同伦等价。Mathlib 的端点 cast、群胚共轭、范畴等价、fully faithful 函子和乘法等价均与教材对象层级一致，直接复用；本库新增对应基点基本群等价，是从现有群胚等价提取的真实下游接口，不复制基本群胚或同伦等价结构。

# 应用与陷阱

沿不同道路换基点所得同构一般相差内自同构，不能说道路连通空间的基本群在所有基点间有一个规范同构。`mapOfEq` 中的 cast 只处理命题相等的基点，不替代连接不同点的道路。同伦等价给出的群等价目标是 `e x`；若要改成预先指定的 `y`，仍需等式或连接道路。这里证明的是同伦等价保持基本群，不是基本群同构反推空间同伦等价。
