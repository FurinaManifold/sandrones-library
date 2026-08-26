---
id: topology.fundamental-group.van-kampen-theorem
family: topology.fundamental-group
variant: binary-path-connected-open-cover
kind: theorem
state: verified
title: 二开集覆盖的 Seifert--van Kampen 定理
summary: 对道路连通开集及道路连通交集组成的二开集覆盖，证明基本群是两个局部基本群沿交集基本群的群 pushout
premises: [topology.fundamental-group.van-kampen-kernel-word, topology.fundamental-group.van-kampen-surjectivity]
mathlib: [Path, FundamentalGroup, Monoid.PushoutI, MulEquiv, IsOpen, IsPathConnected]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

局部基本群通过包含映射进入整体空间，并在交集基本群上相容，因此诱导一个从群 pushout 到整体
基本群的规范同态。van Kampen 定理断言：对道路连通的二开集覆盖且交集道路连通时，这个规范同态
是同构。VK2 已完成满射，本条目用 VK3b 的方格消去链补上单射并封装最终等价。

# 规范同态与字母词

`binaryVanKampenCanonicalMap_letterWord_eq_concatLoop` 证明规范同态作用于一个 Pushout 字母词，恰好
得到对应 concat loop 的基本群类。证明逐字母展开规范映射，并用 15b 的常值 connector 计算桥消去
端点修正。

# kernel 证书

`exists_binaryVanKampenKernelConcatLoopHomotopy` 将规范同态 kernel 中的任意元素表示成字母词，并给出
该字母词 concat loop 到常值环路的端点相对同伦。这里复用 VK2 已有的字母表示，不重证道路细分。
空字母词直接化简；非空分支调用 15b 的 aligned-grid kernel-word 定理。

# 单射

`binaryVanKampenCanonicalMap_eq_one_imp` 证明 kernel 只有单位元，随后
`injective_binaryVanKampenCanonicalMap` 使用群同态的 kernel 判据得到规范同态单射。与 VK2 的
`Path.surjective_binaryVanKampenCanonicalMap` 合并后即得双射。

# 最终等价与计算规则

`binaryVanKampenCanonicalEquiv` 用 `MulEquiv.ofBijective` 将规范同态升级为乘法等价。
`binaryVanKampenCanonicalEquiv_toMonoidHom`、`binaryVanKampenCanonicalEquiv_apply` 和
`binaryVanKampenCanonicalEquiv_of` 分别说明正向同态就是规范同态、给出逐点计算，并计算覆盖两侧
生成元的像。这样下游无需展开 `MulEquiv.ofBijective`。

# Lean 对照

```lean
theorem binaryVanKampenCanonicalMap_letterWord_eq_concatLoop ...
theorem exists_binaryVanKampenKernelConcatLoopHomotopy ...
theorem binaryVanKampenCanonicalMap_eq_one_imp ...
theorem injective_binaryVanKampenCanonicalMap ...
noncomputable def binaryVanKampenCanonicalEquiv ...
theorem binaryVanKampenCanonicalEquiv_toMonoidHom ...
@[simp] theorem binaryVanKampenCanonicalEquiv_apply ...
@[simp] theorem binaryVanKampenCanonicalEquiv_of ...
```

# 正式承载与 Mathlib 复用

`Path`、`FundamentalGroup`、`IsOpen`、`IsPathConnected`、`Monoid.PushoutI` 和 `MulEquiv` 直接复用
Mathlib：它们与教材中的道路、基本群、开覆盖、道路连通、群 pushout 和群同构语义一致。二开集规范
同态、字母、concat loop、细分和 kernel 消去复用本库前序 Entry。本批不重造这些 carrier 或结构。

# 证明思路

先逐字母证明规范同态与 concat loop 类相符。对 kernel 元素选取已有字母表示；规范映射为一使其
concat loop 类等于常值类，商类型等式提供端点相对同伦。空列表由化简完成，非空列表交给 15b 的
方格证明。由 kernel 平凡推出单射，再与已验收满射组合成 `MulEquiv`，最后证明三个消去规则。

# 边界

定理精确处理 `U`、`V` 开、`U ∪ V = univ`，并且 `U`、`V`、`U ∩ V` 均道路连通的带基点二开集版本。
它不声称任意多开集、基本群胚、交集不道路连通、自然性或更弱局部假设版本。
