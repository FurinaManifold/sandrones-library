---
id: abstract-algebra.ring.pid-ufd
family: abstract-algebra.ring
variant: textbook
kind: theorem
state: verified
title: 主理想整环与唯一分解整环
summary: 自建 PID 与 UFD 教材公理并证明 Euclidean 推出 PID、PID 推出 UFD
premises: [abstract-algebra.ring.divisibility, abstract-algebra.ring.euclidean]
mathlib: [IsPrincipalIdealRing, UniqueFactorizationMonoid]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 2（PID 与 UFD）
---

# 动机

Euclidean 算法、主理想性和唯一分解形成整除理论的核心递进链。教材层必须说明每个理想为何由
一个元素生成，以及“唯一分解”需要分解存在与不可约元的素性，而不能只登记外部类型类实例。

# 直觉

在非零理想中选择 Euclidean 度量最小的非零元素 `d`。任意理想元素除以 `d` 所得余数仍在理想
中；最小性迫使余数为零，所以 `d` 生成整个理想。PID 中主理想严格上升链不能无限延伸，因此
元素能分解为不可约元；不可约元生成的主理想性质又使其成为素元，从而得到唯一分解。

# 陈述（自然语言）

本条目定义主理想集合、主理想整环公理、原子分解存在公理和唯一分解整环公理。每个 Euclidean
环都是主理想整环，每个主理想整环都是唯一分解整环，因而每个 Euclidean 环都是唯一分解整环。

# 陈述（Lean 对照）

- `PrincipalIdealSet I`：存在 `a`，使 `x∈I` 当且仅当 `a` 整除 `x`。
- `PrincipalIdealDomainAxioms R`：整环且每个双边理想集合主生成。
- `AtomicFactorizationAxiom R`：非零非单位元具有有限不可约因子分解。
- `UniqueFactorizationDomainAxioms R`：整环、原子分解存在、不可约元均为素元。
- `euclideanDomain_implies_principalIdealDomain`：最小度量证明。
- `principalIdealDomain_implies_uniqueFactorizationDomain`：PID 推出 UFD。
- `euclideanDomain_implies_uniqueFactorizationDomain`：两步合成。

# 思维脉络（thinking trace）

零理想由零生成。对非零理想，用自然数良序性选取非零元素中的最小 Euclidean 度量；除法余数
因理想封闭性仍在理想中，而严格下降与最小性矛盾，故余数为零。PID 到 UFD 阶段把本库每个
集合理想主生成的证明转换成局部实现后端，再取得有限不可约分解和不可约元素性，最后逐项翻译
回本库 `UnitElement`、`IrreducibleElement` 与 `PrimeElement`。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 理想 `I=(a)` | `PrincipalIdealSet I` |
| `R` 是 PID | `PrincipalIdealDomainAxioms R` |
| 原子分解存在 | `AtomicFactorizationAxiom R` |
| `R` 是 UFD | `UniqueFactorizationDomainAxioms R` |
| Euclidean⇒PID | `euclideanDomain_implies_principalIdealDomain` |
| PID⇒UFD | `principalIdealDomain_implies_uniqueFactorizationDomain` |
| Euclidean⇒UFD | `euclideanDomain_implies_uniqueFactorizationDomain` |

# 依赖（人话版）

教材定义依赖本库整环、整除、不可约元、素元及 Euclidean 除法。Mathlib 的 `Ideal`、
`IsPrincipalIdealRing` 和 `UniqueFactorizationMonoid` 只在 PID⇒UFD 的证明体中局部组装；它们不
出现在本库三个主结论的公开签名中。

# 应用与陷阱

- `PrincipalIdealSet` 量化的是本库双边理想集合，不把 Mathlib `Ideal` 当作教材定义。
- UFD 公理采用“原子分解存在 + 不可约元均为素元”的标准等价刻画。
- 因子使用 `Multiset`，只忽略排列；单位差异由首项 `u` 明确记录。
- 本条目不声称一般 UFD 必为 PID；反向命题是错误的。
