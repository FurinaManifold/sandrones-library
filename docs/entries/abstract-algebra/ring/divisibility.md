---
id: abstract-algebra.ring.divisibility
family: abstract-algebra.ring
variant: textbook
kind: theorem
state: verified
title: 整除、相伴、不可约元、素元与最大公因子
summary: 在交换整环中自建整除理论，并证明素元必不可约及最大公因子相伴唯一
premises: [abstract-algebra.ring.def, abstract-algebra.ring.domain]
mathlib: [Associated, Irreducible, Prime]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

唯一分解理论必须先回答“整除”“只差一个单位”“不能再非平凡分解”和“整除乘积必整除某个
因子”分别是什么意思。若直接使用 Mathlib 的专用谓词，这些教材定义及其逻辑差异会被隐藏，
也难以说明最大公因子为何通常只能确定到相伴。

# 直觉

`a` 整除 `b` 表示 `b` 能从 `a` 乘上某个元素得到。相伴元素只差一个可逆因子，因此携带相同
整除信息。不可约元控制自身的二因子分解，素元则控制它对任意乘积的整除行为；后者更强。
最大公因子不是按大小比较，而是整除偏序中的最大公因子，所以不同选择彼此整除并因而相伴。

# 陈述（自然语言）

本条目显式定义整除、相伴、不可约元、素元和最大公因子。整除具有反身性和传递性，单位整除
任意元素；相伴是等价关系并蕴含互相整除，而交换整环中互相整除也蕴含相伴。交换整环中的素元
必为不可约元；同一对元素的任意两个最大公因子相伴。

# 陈述（Lean 对照）

- `DividesElement a b`：存在 `c` 使 `b = a*c`。
- `AssociateElements a b`：存在满足 `UnitElement` 的 `u` 使 `b = a*u`。
- `IrreducibleElement p`、`PrimeElement p`：教材分解判据与整除乘积判据。
- `GreatestCommonDivisor d a b`：`d` 是公因子且吸收所有公因子。
- `associateElements_refl/symm/trans`：相伴的三个等价关系性质。
- `primeElement_implies_irreducibleElement`：交换整环中素元必不可约。
- `greatestCommonDivisor_unique_up_to_associates`：gcd 相伴唯一。

# 思维脉络（thinking trace）

基础整除定理直接操作显式乘子。相伴的对称性取单位逆元，传递性使用两个单位的乘积。证明互相
整除推出相伴时，若首元素为零，则另一元素也为零；否则把两次整除的乘子代回，并用整环消去律
证明乘子互逆。素元分解 `p=a*b` 后，对 `p∣a*b` 应用素性，再消去非零的 `p`，得到另一个因子
可逆。两个 gcd 按其泛性质互相整除，最后调用同一相伴判据。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| `a` 整除 `b` | `DividesElement a b` |
| `a,b` 相伴 | `AssociateElements a b` |
| `p` 不可约 | `IrreducibleElement p` |
| `p` 是素元 | `PrimeElement p` |
| `d` 是 `a,b` 的 gcd | `GreatestCommonDivisor d a b` |
| 素元必不可约 | `primeElement_implies_irreducibleElement` |
| gcd 相伴唯一 | `greatestCommonDivisor_unique_up_to_associates` |

# 依赖（人话版）

教材主定理依赖本库 `UnitElement` 与 `IntegralDomainAxioms`。Lean 的基础整除记号以及 Mathlib
`Associated`、`Irreducible`、`Prime` 只出现在四个具名兼容桥或证明后端；公开课程结论不要求
`IsDomain`、`GCDMonoid`、`DecompositionMonoid` 或 `NormalizedGCDMonoid`。

# 应用与陷阱

- 素元必不可约只需整环；不可约元必为素元一般需要更强的分解条件，当前没有反向声明。
- gcd 在一般整环中即使存在也只确定到相伴；没有规范化结构时不能声称字面相等。
- `AssociateElements` 使用本库 `UnitElement`，不能把互相整除在含零因子的任意环中直接升级为相伴。
- 本条目只处理 gcd 的性质与唯一性，不声称任意交换整环中 gcd 总存在。
