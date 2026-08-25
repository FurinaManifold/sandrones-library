---
id: topology.homotopy.path-reversal-foundation
family: topology.homotopy
variant: reflected-parameter
kind: theorem
state: verified
title: 逆道路及双重反向
summary: 使用已建立的连续单位区间反射定义逆道路，并证明反向两次恢复原道路
premises: [topology.foundation.real-line, topology.homotopy.path-definition-foundation]
mathlib: []
provenance:
  source_type: book
  ref: "Hatcher, Algebraic Topology, Section 1.1"
---

# 动机

逆道路是道路代数和基本群逆元的来源。实直线与单位区间模块已经完成参数反射及其连续性；本条只负责用这个前置接口构造道路层的逆向操作。

# 直觉

单位区间反射把零和一交换，而且反射两次恢复原参数。用它重新参数化道路，会交换道路的起点与终点；再次逆向则逐点回到原道路。

# 陈述（自然语言）

设本库单位区间反射已经连续。对从 `a` 到 `b` 的道路 `γ`，定义逆道路 `γ⁻¹(t)=γ(1-t)`；它从 `b` 到 `a`。任意道路反向两次严格等于原道路。

# 陈述（Lean 对照）

```lean
def Path.symm (γ : Path τX a b) : Path τX b a
theorem Path.symm_symm (γ : Path τX a b) : γ.symm.symm = γ
```

# 思维脉络（thinking trace）

把道路函数与已经验收的 `UnitInterval.reflect` 复合。连续性由本库 `Continuous.comp` 和前置的 `continuous_unitInterval_reflect` 得到；源点化简到原道路终点，目标点化简到原道路源点。双重反向通过道路外延，把目标化为区间反射两次的逐点等式。

# 自然语言 ↔ Lean 映射

“已有的参数反射”对应 premise 中的 `UnitInterval.reflect` 与 `continuous_unitInterval_reflect`；“逆道路”对应本文件的 `Path.symm`；“逆道路取值”对应 `symm_apply`；“反向两次”对应 `Path.symm_symm`。

# 依赖（人话版）

本条依赖 `topology.foundation.real-line` 已提供的连续单位区间反射，以及道路定义和本库连续复合。实数反射及区间反射的构造继续归属于 `RealLine.lean`，不计入本 Entry；本条没有调用 Mathlib `Path.symm`。

# 应用与陷阱

本条不能脱离前置的区间反射连续性单独成立。双重反向是严格道路相等，但拼接结合律通常只能在重新参数化或同伦意义下成立；本条尚未完成道路拼接，因此继续保留 foundation id。
