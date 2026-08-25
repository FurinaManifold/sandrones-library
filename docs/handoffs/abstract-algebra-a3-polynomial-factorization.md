# 抽象代数 A3.4 多项式分解与根重数交接

## 接收窗口

- 分支：`codex/abstract-algebra`。
- 新源码：`SandronesLibrary/AbstractAlgebra/PolynomialFactorization.lean`。
- Entry：`abstract-algebra.poly.factorization`。
- 正式承载：Mathlib `Polynomial K`；本批零 `PolynomialSequence` 新依赖。

## 本批覆盖

- 域上不可约因子分解存在，以及规范化因子多重集的唯一性。
- 首项系数乘规范因子乘积的重构公式。
- 首一不可约分解的严格多重集唯一性。
- 根重数与 `(X-C a)^n` 整除的双向刻画、乘积重数可加。
- `SimpleRoot`、`RepeatedRoot` 教材谓词及导数判据。
- 特征零下求导使根重数减一和迭代导数判据。
- 根多重集计数等于根重数。

## 公开签名与诚实边界

- 公开承载只使用正式 `Polynomial`、`normalizedFactors`、`rootMultiplicity`、`derivative`、
  `List` 与 `Multiset`；没有新建平行多项式体系。
- 分解唯一性通过规范化因子表达“忽略单位与排列”；首一假设下另给严格唯一性。
- 根与正重数的对应显式要求非零多项式；乘积重数公式显式要求乘积非零。
- 精确导数重数公式和迭代导数判据显式要求 `CharZero`。
- `roots.count` 定理显式要求 `[DecidableEq K]`，未把 classical tactic 藏入公开类型。

## Main 集成事项

- 顶层 import 加入 `SandronesLibrary.AbstractAlgebra.PolynomialFactorization`。
- Registry 将 `abstract-algebra.poly.factorization` 唯一映射到新源码和本条目文档。
- ROADMAP 将 A3.4 标为完成，并按真实依赖解锁后续域扩张条目。
- RADAR 登记唯一分解、根重数、单根／重根导数判据和特征零边界。
- 运行 register、`check_axioms`、audit、Entry 唯一映射检查与全库 `lake build`。
