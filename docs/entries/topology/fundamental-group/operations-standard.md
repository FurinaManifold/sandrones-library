---
id: topology.fundamental-group.operations-standard
family: topology.fundamental-group
variant: group-operations-and-laws
kind: theorem
state: verified
title: 基本群的运算、复合次序与群律
summary: 解释基本群的单位、乘法和逆元在道路同伦商上的含义，并区分商上的群律与原始道路等式
premises: [topology.fundamental-group.carrier-standard]
mathlib: [FundamentalGroup.one_def, FundamentalGroup.mul_def, FundamentalGroup.inv_def, mul_assoc, one_mul, mul_one, inv_mul_cancel, mul_inv_cancel]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

基本群不只是环路同伦类的集合。恒等道路给出单位元，道路反向给出逆元，道路拼接给出乘法；拼接在原始道路层面通常不严格满足结合律和单位律，但经过端点固定同伦取商后，这些变形成为等式，于是得到真正的群。

# 直觉

把环路看成基本群胚中基点到自身的箭头。范畴把 `p ≫ q` 读作先走 `p` 再走 `q`，而自同态群的乘法约定为范畴复合的反向写法。因此 Mathlib 中 `p * q` 的道路视角是先走 `q` 再走 `p`，即 `q.toPath.trans p.toPath`。这只是记号次序，不改变基本群的数学内容。

# 陈述（自然语言）

单位元对应基点处恒等道路的同伦类；乘积 `p * q` 对应商上的拼接 `q.toPath.trans p.toPath`；逆元对应道路反向。若 `p`、`q` 是具体代表道路，则它们的同伦类之积等于拼接道路 `q.trans p` 的同伦类。这里所有代数等式都发生在道路同伦商或基本群中。

# 陈述（Lean 对照）

```lean
theorem fundamentalGroup_one_toPath :
  FundamentalGroup.toPath (1 : FundamentalGroup X x) =
    Path.Homotopic.Quotient.refl x

theorem fundamentalGroup_mul_toPath (p q : FundamentalGroup X x) :
  FundamentalGroup.toPath (p * q) =
    (FundamentalGroup.toPath q).trans (FundamentalGroup.toPath p)

theorem fundamentalGroup_inv_toPath (p : FundamentalGroup X x) :
  FundamentalGroup.toPath p⁻¹ = (FundamentalGroup.toPath p).symm
```

群律不另写本库包装：`mul_assoc`、`one_mul`、`mul_one`、`inv_mul_cancel` 与 `mul_inv_cancel` 可直接作用于 `FundamentalGroup X x`。

# 思维脉络（thinking trace）

Mathlib 把基本群定义为基本群胚中基点对象的 `End`。`End` 的群结构来自群胚：单位是恒等态射，乘法按自同态群约定读取范畴复合，逆元是群胚箭头的逆。展开 `FundamentalGroup.one_def`、`mul_def`、`inv_def` 后，三条操作桥都是定义性等式。商上的 `refl_trans`、`trans_refl`、`trans_assoc`、`trans_symm` 与 `symm_trans` 提供群律所需的道路同伦等式；Mathlib 已据此建立标准 `Group` 实例，所以课程层直接使用通用群律。

# 自然语言 ↔ Lean 映射

“恒等环路类”对应 `Path.Homotopic.Quotient.refl x`；“拼接同伦类”对应 `Path.Homotopic.Quotient.trans`；“道路反向类”对应 `Path.Homotopic.Quotient.symm`；“先右因子再左因子”对应 `FundamentalGroup.mul_def`；“结合律、左右单位律、左右逆元律”分别直接对应 `mul_assoc`、`one_mul`、`mul_one`、`inv_mul_cancel`、`mul_inv_cancel`。

# 依赖（人话版）

本条目依赖 F1b 已解释的基本群载体与 `toPath/fromPath` 转换，也依赖 F1a 的道路同伦商。标准 `Group`、群律定理和范畴复合均直接复用 Mathlib，因为它们与教材中的群、范畴和基本群语义一致；本库只补充操作在道路视角中的明确公式，不复制群结构或通用群律。

# 应用与陷阱

切勿把 `p * q` 写成 `p.toPath.trans q.toPath`：Mathlib 的自同态群乘法顺序与道路拼接书写顺序相反。也不能从商上的 `mul_assoc` 推出原始 `Path.trans` 严格结合；原始三段道路采用不同参数化，只有它们的端点固定同伦类相等。本条目不处理连续映射诱导同态、基点变换、圆周基本群或其他计算，这些属于 F2b。
