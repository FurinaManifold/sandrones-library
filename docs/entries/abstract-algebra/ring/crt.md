---
id: abstract-algebra.ring.crt
family: abstract-algebra.ring
variant: textbook
kind: theorem
state: verified
title: 中国剩余定理与有限商环直积
summary: 用集合型理想与本库商环证明二元及有限族中国剩余定理
premises: [abstract-algebra.ring.ideal, abstract-algebra.ring.quotient, abstract-algebra.ring.iso-theorems]
mathlib: [Ideal.exists_forall_sub_mem_ideal]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

一组同余条件何时能由同一个环元素同时满足？整数中国剩余定理的本质不是整数除法，而是各模
理想两两互素。为了让这个结论能直接用于后续多项式环和局部化，本条目在任意交换环上表述它。

# 直觉

理想 `I` 与 `J` 互素，意味着能找到 `i∈I`、`j∈J` 使 `i+j=1`。于是 `j` 在模 `I` 意义下
等于 `1`、在模 `J` 意义下等于 `0`；`i` 的作用相反。表达式 `x*j+y*i` 因而同时实现指定的
两个剩余类。有限族版本把这一思想推广到两两互素的有限理想族。

# 陈述（自然语言）

本条目定义集合型理想的互素性、理想交以及到商环直积的规范映射。规范映射的核是理想交；
互素时规范映射满射，故 `R/(I∩J)` 与 `R/I × R/J` 同构。若有限理想族两两互素，则全部理想
之交的商环与各商环的有限直积同构。

# 陈述（Lean 对照）

- `ComaximalIdealSets I J`：`idealSetSum I J = Set.univ`。
- `comaximalIdealSets_iff_exists_add_eq_one`：互素性的 Bézout 型见证。
- `chineseRemainderMap_eq_zero_iff`：二元规范映射的核判据。
- `chineseRemainderEquiv`、`chineseRemainderEquiv_projection`：二元中国剩余正式
  `RingEquiv` 核心及代表元公式。
- `chineseRemainderIsomorphism`：旧 `RingIsomorphism` 返回类型的薄兼容接口。
- `PairwiseComaximalIdealSets I`：有限理想族两两互素。
- `finiteChineseRemainderMap_eq_zero_iff`：有限族规范映射的核判据。
- `finiteChineseRemainderEquiv`、`finiteChineseRemainderEquiv_projection`：有限中国剩余
  正式核心及代表元公式。
- `finiteChineseRemainderIsomorphism`：旧返回类型的薄兼容接口。

# 思维脉络（thinking trace）

先从互素定义提取 `i+j=1`，直接构造二元规范映射的原像。规范映射按本库商环泛性质下降到
交理想的商环；核判据给出单射，显式构造给出满射，再由选择出的逆映射组装正式
`RingEquiv`。旧 `RingIsomorphism` 结果只经 A2.3 已验收的 `ofRingEquiv` 桥退回，不重复证明
逆映射保持运算。有限族证明先把每个集合型理想局部桥接为 Mathlib `Ideal`，仅在满射证明体
调用其有限 CRT，然后重新回到本库商环；该 `Ideal` 后端不进入公开签名。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 两个理想互素 | `ComaximalIdealSets I J` |
| 全部理想之交 | `finiteIdealIntersection I` |
| 同时取所有剩余类 | `finiteChineseRemainderMap I hI` |
| 二元 CRT 正式同构 | `chineseRemainderEquiv` |
| 二元代表元公式 | `chineseRemainderEquiv_projection` |
| 有限 CRT 正式同构 | `finiteChineseRemainderEquiv` |
| 有限代表元公式 | `finiteChineseRemainderEquiv_projection` |
| 旧接口兼容 | 两个 `...Isomorphism` 名称及其旧公式 |

# 依赖（人话版）

主陈述依赖本库 `TwoSidedIdealSet`、`quotientRingSet`、`RingHomomorphism`，并直接复用已在
A2.3 解释为正式环同构承载的 `RingEquiv`。旧 `RingIsomorphism` 只服务兼容。Mathlib `Ideal`
和 `Ideal.exists_forall_sub_mem_ideal` 仅用于有限族满射的局部证明后端，没有进入教材公开签名。

# 应用与陷阱

- 有限族结论要求两两互素；只要求所有理想之和等于全环并不足够。
- 商掉的是理想交。互素时交等于理想积，但本条目不把两者未经证明地混写。
- 空指标族也被有限版本自然覆盖：交是全环，右侧是空直积。
- 当前结论只处理有限族；无限族的规范映射一般不满射。
- 新证明应消费两个 `...Equiv` 正式核心；不要先退回旧 `...Isomorphism` 再继续组装。
