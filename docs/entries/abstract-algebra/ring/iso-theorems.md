---
id: abstract-algebra.ring.iso-theorems
family: abstract-algebra.ring
variant: textbook
kind: theorem
state: verified
title: 环的同构定理
summary: 用本库显式商环证明第一、第二、第三同构定理及商环理想对应定理
premises: [abstract-algebra.ring.def, abstract-algebra.ring.ideal, abstract-algebra.ring.quotient]
mathlib: [Quotient]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

第一同构定理不应只包装 Mathlib 已有的商理想同构。为保持教材定义链，本条目从普通函数
形式的环同态出发，显式构造核、像与本库商环之间的同构。进一步还要说明商投影如何在
包含核的原环理想与商环理想之间建立对应，由子环与理想的交、和得到第二同构定理，并由
两级自然商映射得到第三同构定理。

# 直觉

环同态只会把核中的元素压成零，因此 `f(x)` 只依赖 `x` 的核陪类。反过来，像中的每个
元素都有原像；任选一个原像并取其核陪类，所得商类与选择无关。这两步给出互逆环同态。
对理想也有同样机制：沿满射取像、沿同态取逆像；若原理想包含商映射的核，这两个操作
彼此撤销。对子环 `A` 和双边理想 `I`，规范映射 `A → (A+I)/I` 的核是 `A∩I` 且满射，
所以第一同构定理立即给出第二同构定理。对于 `I ≤ J`，先模去 `I` 再模去 `J/I` 与直接
模去 `J` 得到相同环结构。

# 陈述（自然语言）

环同构是一对互逆且保持加法与乘法的函数；在带单位环之间，这些条件自动控制零元、单位元
和取负。Lean 以 `RingEquiv`（记作 `R ≃+* S`）正式承载这一概念：其中包含一个双射及其
加法、乘法保持律。任意环同态的核是双边理想，其像在继承运算下
构成环。原环模核所得的本库显式商环，与该教材像承载环同构。双边理想按集合包含形成
偏序；任意环同态可取理想逆像，满射环同态可取理想像。包含 `K` 的 `R` 中双边理想与
`R/K` 中双边理想互逆且双向保序。对子环 `A` 和双边理想 `I`，`A/(A∩I)` 与
`(A+I)/I` 环同构。若 `I ≤ J`，则 `(R/I)/(J/I)` 与 `R/J` 环同构。

# 陈述（Lean 对照）

- `RingEquiv`／`R ≃+* S`：环同构的正式公开承载，与上述教材定义语义一致。
- `RingIsomorphism`：历史兼容载体；`toRingEquiv`、`ofRingEquiv` 及两个往返恒等式证明它
  与正式承载无损等价。新证明不再由这个平行结构拥有。
- `TwoSidedIdealCarrier`、`ringHomKernelSet`、`ringHomKernel`：双边理想与核承载。
- `ringHomRange`、`ringHomRangeMap`：由存在原像刻画的像及规范映射。
- `quotientRingSetRing`、`ringHomRangeRing`：从教材公理打包的标准环结构。
- `ringFirstEquiv`：`quotientRingSet (ker f) ≃+* ringHomRange f` 的正式核心。
- `ringFirstEquiv_projection`：正式同构把代表元类 `[x]` 送到像中的 `f(x)`。
- `ringFirstIsomorphism`、`ringFirstIsomorphism_projection`：旧签名的薄兼容包装。
- `twoSidedIdealContained`：双边理想的显式集合包含序。
- `idealComap`、`idealMapOfSurjective`：同态逆像与满射同态像。
- `quotientIdealComapMap_membership`、`quotientIdealMapComap_membership`：两个方向的成员公式。
- `QuotientIdealOrderEquivalence`、`quotientIdealCorrespondence`：教材理想保序对应。
- `SubringCarrier`、`subringIdealIntersection`、`subringIdealSum`：子环、`A∩I` 与 `A+I`。
- `secondIsomorphismCanonicalMap` 及其核、满射定理：第二同构的规范映射数据。
- `ringSecondEquiv`、`ringSecondEquiv_projection`：第二同构正式核心及代表元公式。
- `ringThirdEquiv`、`ringThirdEquiv_projection_projection`：第三同构正式核心及二重投影公式。
- `ringSecondIsomorphism`、`ringThirdIsomorphism` 及其公式：旧签名的薄兼容包装。

# 思维脉络（thinking trace）

先用 `quotientRingSet_ringAxioms` 打包商集环结构，再逐项证明核的加法、取负和双侧吸收。
像使用“值与原像证据”的子类型承载，运算闭包直接由同态公式给出。主映射调用商环下降
接口；逆映射选择原像。两个原像具有同一函数值时，其差落在核中，故其商投影相等。
第二阶段先逐项证明逆像和满射像仍为双边理想，再用商投影判等准则证明 map/comap 的两个
成员等价，最后将它们组装成互逆保序映射。第一、第二、第三同构的证明所有权均落在
`RingEquiv` 正式核心；旧 `RingIsomorphism` 结果只经无损桥退回，不维护第二条证明链。
第二同构定理显式构造 `A+I`，证明从 `A` 到
`(A+I)/I` 的规范映射满射且核为 `A∩I`，再复合第一同构与两个承载同构。第三同构定理使用
自然映射 `R/I → R/J`，再将
它沿 `J/I` 商掉；逆映射通过选择 `R/J` 的代表元构造，良定义性仍由理想同余判等保证。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 双边理想承载 | `TwoSidedIdealCarrier R` |
| `ker(f)` | `ringHomKernelSet f` |
| `im(f)` | `ringHomRange f hf` |
| `R/ker(f)` | `quotientRingSet (ringHomKernelSet f) ...` |
| 环同构正式承载 | `R ≃+* S`（`RingEquiv R S`） |
| 第一同构 | `ringFirstEquiv f hf` |
| `[x] ↦ f(x)` | `ringFirstEquiv_projection f hf x` |
| 理想逆像 | `idealComap f hf J` |
| 满射下理想像 | `idealMapOfSurjective f hf hsurj I` |
| 商环理想对应 | `quotientIdealCorrespondence K` |
| 子环 `A` | `SubringCarrier R` |
| `A∩I` | `subringIdealIntersection A I` |
| `A+I` | `subringIdealSum A I` |
| `A/(A∩I) ≅ (A+I)/I` | `ringSecondEquiv A I` |
| 第二同构的代表元公式 | `ringSecondEquiv_projection A I a` |
| `(R/I)/(J/I) ≅ R/J` | `ringThirdEquiv I J hIJ` |
| `[[x]_I]_{J/I} ↦ [x]_J` | `ringThirdEquiv_projection_projection I J hIJ x` |
| 旧接口兼容 | `RingIsomorphism.ofRingEquiv` 与三个 `...Isomorphism` 名称 |

# 依赖（人话版）

本条目依赖本库 `RingHomomorphism`、`TwoSidedIdealSet`、`quotientRingSet`、商投影及商环
下降映射。`Quotient` 仅承担等价类的底层实现；`RingEquiv` 与教材环同构逐项语义一致，因而
直接作为正式公开承载，而不是私有证明后端。公开签名不要求 `Module` 或 `Submodule`，也不把
本库显式商环替换成 Mathlib 的另一种商对象。理想像要求同态满射，因为验证目标
环任意元素的左右乘法吸收时，需要先为该乘子选择源环原像。

# 应用与陷阱

- 非交换环的核必须验证左右两侧吸收，不能只证明单侧理想条件。
- 逆映射需要选择像元素的原像，因此 `ringFirstEquiv` 及旧兼容包装是 `noncomputable`。
- `RingIsomorphism` 只为既有调用者保留；新定理应消费 `ringFirstEquiv`、
  `ringSecondEquiv`、`ringThirdEquiv`，不要从正式结构退回后再继续证明。
- 原像选择不唯一；良定义性的关键是同值元素之差属于核。
- 代表元公式描述正向映射的实际计算行为，而不只是抽象存在一个同构。
- 一般同态下集合像未必是目标环理想；`idealMapOfSurjective` 明确要求满射。
- 对应定理的原环一侧必须限制为包含 `K` 的理想，否则 comap(map(I)) 会额外吸收核。
- 第二同构中的 `A+I` 是子环与理想的集合和，不是把 `A` 错当成双边理想。
- 第三同构中的 `J/I` 是 `J` 沿 `R → R/I` 的显式理想像，不是未经定义的商理想记号。
