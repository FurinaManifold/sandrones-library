---
id: abstract-algebra.ring.domain
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 零因子、整环与域
summary: 自建零因子、无零因子、整环和域的教材公理，并证明域必为整环
premises: [abstract-algebra.ring.def]
mathlib: [NoZeroDivisors, IsDomain, IsField]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

“整环没有零因子”和“域中每个非零元可逆”是后续整除、不可约分解和多项式理论的基础。
这些概念应先以教材公理出现，再与 Mathlib 的实现类连接，不能把 `IsDomain` 或 `IsField`
直接当作本库定义。

# 直觉

零因子是一个非零元素，它能与另一个非零元素相乘得到零。整环是非平凡的交换环，并且没有
零因子。域进一步要求每个非零元素都有双侧乘法逆元；用逆元消去一个非零因子，就能直接
证明域没有零因子，因此每个域都是整环。

# 陈述（自然语言）

本库定义零因子元素和无零因子公理，并把交换环公理、非平凡性和无零因子合成整环公理；
把交换环公理、非平凡性和非零元可逆性合成域公理。无零因子等价于不存在零因子；整环中
非零元素的乘积非零；域公理直接推出整环公理。最后分别建立与 Mathlib 三个实现谓词的桥。

# 陈述（Lean 对照）

- `ZeroDivisorElement a`：`a` 非零且右乘某个非零元素得到零。
- `NoZeroDivisorsAxiom R`：乘积为零必有一个因子为零。
- `IntegralDomainAxioms R`：交换环、`0 ≠ 1`、无零因子。
- `FieldAxioms R`：交换环、`0 ≠ 1`、每个非零元满足 `UnitElement`。
- `noZeroDivisorsAxiom_iff_no_zero_divisor`：无零因子的元素刻画。
- `fieldAxioms_implies_integralDomainAxioms`：域直接推出整环。
- `noZeroDivisorsAxiom_iff_mathlib`、`integralDomainAxioms_iff_isDomain`、
  `fieldAxioms_iff_isField`：三个兼容桥。

# 思维脉络（thinking trace）

定义顺序从元素性质到全环公理，再组合成整环与域。证明域无零因子时，从非零 `a` 的双侧
逆元 `c` 出发，把 `a*b=0` 左乘 `c`，由结合律和 `c*a=1` 得到 `b=0`。由于定义层没有
借用 Mathlib 环实例中的派生定理，证明中还从本库环公理推出零乘法为零，完整保留教材依赖。
只有全部主定理完成后，才构造到 Mathlib 类型类的双向桥。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| `a` 是零因子 | `ZeroDivisorElement a` |
| `R` 无零因子 | `NoZeroDivisorsAxiom R` |
| `R` 是整环 | `IntegralDomainAxioms R` |
| `R` 是域 | `FieldAxioms R` |
| 域必为整环 | `fieldAxioms_implies_integralDomainAxioms` |
| Mathlib 整环 | `IsDomain R`，仅在桥中出现 |
| Mathlib 域 | `IsField R`，仅在桥中出现 |

# 依赖（人话版）

本条目依赖 `CommutativeRingAxioms` 和 `UnitElement`。定义与教材主定理只使用普通运算和本库
公理结构；`NoZeroDivisors`、`IsDomain`、`IsField` 是实现生态的兼容边界。素理想、极大
理想及商环判据尚未迁移，属于后续定义层批次。

# 应用与陷阱

- 零因子定义明确排除零本身，并要求被消去的另一因子也非零。
- `0 ≠ 1` 必须单列；仅有无零因子条件不能排除零环。
- 本库 `FieldAxioms` 要求双侧逆元，不能把单侧逆元未经证明地替代它。
- 旧 `is_domain_mul_eq_zero`、`is_field_inv_exists` 及素/极大理想结论仍是 Mathlib 兼容接口。
- 后续公开教材定理应优先接收 `IntegralDomainAxioms` 或 `FieldAxioms`。
