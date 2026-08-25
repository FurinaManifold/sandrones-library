# 抽象代数 A3.3 多项式不可约交接

## 接收窗口

- 分支：`codex/abstract-algebra`。
- 新源码：`SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean`。
- Entry：`abstract-algebra.poly.irreducible`。
- 正式承载：Mathlib `Polynomial R`；本批零 `PolynomialSequence` 新依赖。

## 概念清单

| 概念 | 教材语义 | 正式承载 | 展开／性质 | 复用说明 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 不可约 | 分解必有单位因子 | `Irreducible` | `irreducible_factor_isUnit` | 语义一致 | Gauss/Eisenstein | `poly.irreducible` |
| 本原 | 所有常数因子为单位 | `Polynomial.IsPrimitive` | iff 展开、乘法封闭 | 语义一致 | Gauss | 同上 |
| content | 系数的规范化 gcd | `Polynomial.content` | 本原 iff content=1、乘法 | 语义一致 | 本原部分分解 | 同上 |
| 本原部分 | 除去 content 后的因子 | `Polynomial.primPart` | `p=C(content p)*primPart p` | 语义一致 | content 分解 | 同上 |
| 有理根 | 异系数环求值为零 | `Polynomial.aeval` | 分子／分母整除 | 语义一致 | 整根推论 | 同上 |
| Eisenstein | 素理想上的三项系数条件 | `Polynomial.IsEisensteinAt` | 一般及整数素数版 | 语义一致 | 不可约判别 | 同上 |

## 公开签名扫描

- 正式公开承载：`Polynomial`、`Irreducible`、`IsPrimitive`、`content`、`primPart`、`aeval`、
  `IsEisensteinAt`、`Ideal`；均在课程文档解释。
- 精确代数假设：`NormalizedGCDMonoid`、`StrongNormalizedGCDMonoid`、`IsDomain`；没有
  `Module`、`Submodule` 或未解释的扩域结构公开泄漏。
- 私有后端仅有整数主理想的素性、成员和平方成员桥。
- `IsFractionRing.num/den` 出现在有理根结论，角色是 `ℚ` 的规范约分接口，不是另建分式域课程。

## Main 集成事项

- 顶层 import 加入 `SandronesLibrary.AbstractAlgebra.PolynomialIrreducibility`。
- Registry 把 `abstract-algebra.poly.irreducible` 唯一映射到新文件；旧 `Poly.lean` 中同 Entry 的
  历史包装应由 Main 改归兼容 Entry，避免跨文件 Entry。
- ROADMAP A3.3 可改为完成；A3.4 仍等待本批验收。
- RADAR 记录 GaussLemma、RationalRoot 与 Eisenstein 为解释完毕的正式证明接口。
- 运行生成索引、公理审计、audit 与全库 build。

## 诚实边界

- 一般 Gauss 引理采用课程最常用的 `ℤ[X] ↔ ℚ[X]` 版本；没有公开尚未教学的任意分式域
  `Algebra/IsFractionRing` 签名。
- 有理根结论给出规范分子与分母整除，首一推论只断言根来自整数。
- A3.4 的唯一分解、根重数和导数重根判据不属于本批。
