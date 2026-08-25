# 抽象代数 A3.2 多项式除法交接

## 接收窗口

- 分支：`codex/abstract-algebra`。
- 新源码：`SandronesLibrary/AbstractAlgebra/PolynomialDivision.lean`。
- 新 Entry：`abstract-algebra.poly.division`。

## 定义与结果

| 层次 | 本库接口 | 适用范围 | 结论 |
|---|---|---|---|
| 首一除法 | `Monic`、`monicQuotient`、`monicRemainder` | 交换环 | 除法恒等式、余式次数下降、整除判据、唯一性 |
| 一般除法 | `polynomialQuotient`、`polynomialRemainder` | 域、非零除式 | 除法恒等式与零安全度量下降 |
| Euclidean 结构 | `polynomialEuclideanDomainAxioms` | 域上的本库多项式 | 接入 A2 自建 Euclidean 算法 |
| 算法后果 | `polynomialGCD_isGreatestCommonDivisor`、`polynomialGCD_bezout` | 域上的本库多项式 | gcd 泛性质与 Bézout 等式 |

## Main 集成清单

- 顶层 import：加入 `SandronesLibrary.AbstractAlgebra.PolynomialDivision`。
- Registry：新增 `abstract-algebra.poly.division`，premises 为 `poly.def` 与 `ring.euclidean`。
- ROADMAP：A3.2 可改为完成；A3.3 的不可约判据、Gauss 引理等仍未完成。
- RADAR：记录 Mathlib `Polynomial` 除法仅为桥后的证明后端。
- 重生成索引与公理字段，运行 audit 和 full build。

## 验证边界

- 全部下层接口先在 `/tmp` 的完整上层框架中组装，最终零 `sorry` 后才入库。
- 零多项式的度量为 `0`，次数为 `n` 的非零多项式度量为 `n+1`；这避免 `natDegree 0 = 0`
  对严格下降造成的边界错误。
- 公开签名不含 `Module`、`Submodule` 或 `Algebra`。
- A3.3 的一般不可约理论、Gauss 引理、有理根判别与 Eisenstein 判别不属于本批次。
