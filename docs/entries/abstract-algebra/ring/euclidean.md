---
id: abstract-algebra.ring.euclidean
family: abstract-algebra.ring
variant: textbook
kind: theorem
state: verified
title: Euclidean 环与扩展 Euclidean 算法
summary: 自建带余除法与严格下降数据，构造 gcd 并证明 Bézout 恒等式
premises: [abstract-algebra.ring.domain, abstract-algebra.ring.divisibility]
mathlib: []
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

Euclidean 环的关键不是一个不可见的类型类实例，而是每次非零除法都能产生商和严格变小的余数。
这项下降数据保证算法终止，并把 gcd 的整除泛性质与实际递归计算连接起来。

# 直觉

反复把 `(a,b)` 替换为 `(b,r)`，余数度量严格下降，因此最终到达第二项为零。最后一个非零项
就是 gcd 候选。若同时递推记录线性组合系数，则每一步的余数都仍是原始 `a,b` 的线性组合，
最终得到 gcd 的 Bézout 表示。

# 陈述（自然语言）

本条目定义一次带余除法和 Euclidean 环公理数据，递归定义 Euclidean gcd 与扩展 Euclidean
算法。Euclidean gcd 满足最大公因子的整除泛性质；扩展算法返回同一个 gcd 及两个系数，并证明
该 gcd 等于这两个系数与原始输入的线性组合。

# 陈述（Lean 对照）

- `DivisionWithRemainder`：除法恒等式和余数度量严格下降。
- `EuclideanDomainAxioms`：整环公理、度量、商、余数及每次非零除法证明。
- `euclideanGCD`：按第二参数余数度量递归。
- `extendedEuclidean`：递归返回 `(g,s,t)`。
- `euclideanGCD_isGreatestCommonDivisor`：递归结果满足本库 gcd 定义。
- `extendedEuclidean_bezout`、`euclideanDomain_bezout_for_gcd`：Bézout 恒等式。

# 思维脉络（thinking trace）

两个递归定义都以 `measure b` 为终止度量，下降证明直接来自带余除法字段。gcd 泛性质的递归步
使用 `a=b*q+r`：若候选整除 `b,r`，它就整除 `a`；若 `c` 同时整除 `a,b`，则也整除
`r=a-b*q`。扩展算法把下一步系数 `(s,t)` 更新为 `(t,s-q*t)`，展开并整理即保持线性组合。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 带余除法 | `DivisionWithRemainder measure a b q r` |
| Euclidean 环数据 | `EuclideanDomainAxioms R` |
| Euclidean gcd | `euclideanGCD E a b` |
| 扩展 Euclidean 算法 | `extendedEuclidean E a b` |
| gcd 泛性质 | `euclideanGCD_isGreatestCommonDivisor E a b` |
| Bézout 表示 | `euclideanDomain_bezout_for_gcd E a b` |

# 依赖（人话版）

本条目依赖本库 `IntegralDomainAxioms`、`DividesElement` 与 `GreatestCommonDivisor`。终止性只使用
自然数度量。Mathlib 的 `EuclideanDomain`、`GCDMonoid` 和规范化 gcd 没有出现在公开签名或
证明后端，因此本条目不会把外部类型类当作教材定义。

# 应用与陷阱

- `remainder_lt` 必须在除数非零时成立，否则递归终止性没有依据。
- `euclideanGCD` 给出的 gcd 不带规范化；与其他 gcd 比较时仍应使用相伴而非字面相等。
- Bézout 恒等式依赖环的加法逆元；半环上的 Euclidean 算法需要不同陈述。
- 本条目尚未证明 Euclidean 环的每个理想主生成，也未推出 PID 或 UFD；这些属于下一批。
