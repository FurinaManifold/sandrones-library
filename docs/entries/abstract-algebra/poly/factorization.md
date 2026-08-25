---
id: abstract-algebra.poly.factorization
family: abstract-algebra.poly
variant: textbook
kind: theorem
state: verified
title: 多项式唯一分解、根的重数与导数判据
summary: 不可约因子分解及其唯一性；根重数；单根、重根与导数；特征零下的重数递降
premises: [abstract-algebra.poly.def, abstract-algebra.poly.division, abstract-algebra.poly.irreducible]
mathlib: [Polynomial.normalizedFactors, Polynomial.rootMultiplicity, Polynomial.derivative]
provenance:
  source_type: book
  ref: 本科抽象代数与数学分析中的多项式因式分解、重根和导数判据
---

# 动机

不可约判别只能回答一个给定多项式能否继续分解；完整的因式分解理论还必须说明分解存在、除去
单位和排列后唯一，并把线性因子出现的次数同根的重数联系起来。导数则提供了无需先求出全部
因子的重根判据。

# 直觉

域上的非零多项式可写成非零常数与有限个首一不可约多项式的乘积。把每个不可约因子规范化为
首一以后，因子多重集由原多项式唯一决定。对标量 `a`，根重数是使 `(X-a)^n` 整除多项式的
最大自然数 `n`；一次因子只出现一次便是单根，出现至少两次便是重根。

求导会把非零根因子的次数降低一。因此在特征零域中，`a` 是重根当且仅当它同时是原多项式和
导数的根；它是单根当且仅当导数在 `a` 处不为零。正特征中导数可能消灭整个 `p` 次幂，所以
精确的重数递降结论不能省略特征零假设。

# 陈述（自然语言）

本条目给出域上非零多项式的不可约因子分解、一般规范因子唯一性，以及首一不可约分解的严格
多重集唯一性；给出首项系数乘规范因子乘积的重构公式。随后证明根、线性因子整除与正重数三者
的对应，乘积的根重数可加，定义单根和重根，并证明它们与导数取值的经典判据。最后在特征零域
上证明求导使根重数恰好减一，以及用各阶迭代导数刻画根重数。

# Lean 对照与正式承载

| 教材概念 | 正式 Lean 承载 | 关键课程接口 |
|---|---|---|
| 不可约因子多重集 | `p.normalizedFactors` | `polynomial_eq_leadingCoeff_mul_normalizedFactors` |
| 根重数 | `p.rootMultiplicity a` | `pow_X_sub_C_dvd_iff_le_rootMultiplicity` |
| 多项式导数 | `p.derivative` | `coefficient_derivative`、`derivative_mul` |
| 单根 | `SimpleRoot p a` | `simpleRoot_iff_derivative_eval_ne_zero` |
| 重根 | `RepeatedRoot p a` | `repeatedRoot_iff_isRoot_derivative` |
| 迭代导数 | `(Polynomial.derivative)^[m] p` | `lt_rootMultiplicity_iff_iteratedDerivative_isRoot` |

这些对象在 Mathlib 中已有与教材语义一致、且处理了单位规范化和零多项式边界的成熟实现，故
本条目把它们作为正式承载，并用中文定义与具名定理公开其教材含义；不建立第二套多项式或因子
容器。

# 证明思路

存在性来自多项式环的唯一分解整环结构。一般唯一性先比较两个不可约因子列表的乘积，再把因子
逐个规范化；首一条件保证每个因子已经等于自己的规范化，因此得到严格的多重集相等。重构公式
把唯一分解中的单位明确识别为首项系数。

根重数部分使用 `(X-C a)^n` 的整除刻画。乘积非零时，两个因子的最大幂次数相加。导数的系数
公式和 Leibniz 公式给出计算接口；重根判据由“重数大于一”等价于导数仍以 `a` 为根推出。
特征零下可排除自然数系数在域中消失，从而得到精确减一及迭代导数判据。

# 边界与陷阱

- 零多项式的 `rootMultiplicity` 采用库中的零安全约定；根与正重数的双向关系必须假设
  `p ≠ 0`。
- 根重数的乘法公式必须排除乘积为零；在域上这等价于两个因子都非零。
- 因子分解的“唯一”默认忽略单位和排列；只有将因子规范为首一后才得到严格多重集相等。
- 精确的导数重数递降和迭代导数刻画需要 `CharZero K`，不能照搬到正特征域。
- `p.roots.count a` 需要可判定相等，因此相应公开定理显式带有 `[DecidableEq K]`。
