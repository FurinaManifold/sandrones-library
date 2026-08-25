# 条目依赖排行

> 本文件由 `scripts/gen_entry_rankings.py` 生成，请勿手工编辑。

排名只覆盖 `verified` 非兼容桥条目。总分为四项百分位的加权和：加权直接引用 30%、
距离衰减的传递影响 30%、跨学科影响 20%、Lean 实际使用文件数 20%。
Lean 使用采用去注释后的主声明文本扫描；短名碰撞时该项记为 0，详细证据见 JSON。

## 综合榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 99.23 |
| 2 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 95.89 |
| 3 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 95.72 |
| 4 | `complex-analysis.integral.path` | 复路径与路径积分 | 95.00 |
| 5 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 94.31 |
| 6 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 93.97 |
| 7 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 93.79 |
| 8 | `analysis.series.basic` | 数项级数基础 | 93.61 |
| 9 | `real-analysis.riemann.def` | 黎曼积分定义 | 92.09 |
| 10 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 91.50 |
| 11 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 91.47 |
| 12 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 90.04 |
| 13 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 89.95 |
| 14 | `settheory.googology.bounded-halting` | 限定步数停机 | 89.89 |
| 15 | `linear-algebra.det.mul` | 积的行列式 | 89.29 |
| 16 | `number-theory.elementary.congruence` | 同余与剩余环 | 88.21 |
| 17 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 88.18 |
| 18 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 88.11 |
| 19 | `analysis.trigonometric.double-half` | 三角函数倍角与降幂公式 | 87.58 |
| 20 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 87.27 |
| 21 | `linear-algebra.vector-space.def` | 向量空间定义 | 87.13 |
| 22 | `settheory.set.ext` | 外延性原理 | 87.03 |
| 23 | `topology.space.def` | 拓扑空间与开闭集公理 | 86.29 |
| 24 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 85.93 |
| 25 | `settheory.ordinal.addition` | 序数加法不交换 | 85.36 |
| 26 | `analysis.derivative.chain-rule` | 链式法则 | 85.09 |
| 27 | `analysis.continuity.definition` | 连续性定义 | 84.42 |
| 28 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 84.22 |
| 29 | `real-analysis.measure.def` | 测度公理 | 83.62 |
| 30 | `number-theory.elementary.divisibility` | 带余除法、最大公因数与 Bézout 等式 | 83.31 |

## 教材枢纽榜（加权直接引用）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 8.500 |
| 2 | `topology.space.def` | 拓扑空间与开闭集公理 | 6.000 |
| 3 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 5.250 |
| 4 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 5.000 |
| 5 | `analysis.derivative.chain-rule` | 链式法则 | 4.750 |
| 6 | `settheory.set.ext` | 外延性原理 | 4.000 |
| 7 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 3.750 |
| 8 | `complex-analysis.integral.path` | 复路径与路径积分 | 3.667 |
| 9 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 3.500 |
| 10 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 3.167 |
| 11 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 3.000 |
| 12 | `number-theory.elementary.divisibility` | 带余除法、最大公因数与 Bézout 等式 | 3.000 |
| 13 | `settheory.googology.goodstein-ordinal-measure` | Goodstein 序数度量：把有限底数换成 ω | 3.000 |
| 14 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 3.000 |
| 15 | `analysis.series.basic` | 数项级数基础 | 2.750 |
| 16 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 2.750 |
| 17 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 2.583 |
| 18 | `analysis.real.sup` | 确界原理 | 2.500 |
| 19 | `linear-algebra.vector-space.def` | 向量空间定义 | 2.500 |
| 20 | `settheory.googology.hereditary-base` | 遗传基表示：连指数也用同一底数展开 | 2.500 |
| 21 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 2.500 |
| 22 | `topology.space.continuous` | 连续映射 | 2.500 |
| 23 | `settheory.googology.unbounded-halting-relation` | 无时间界停机关系与最终输出 | 2.250 |
| 24 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2.167 |
| 25 | `analysis.constants.pi-definition` | 圆周率 π 的定义接口与基本特殊值 | 2.083 |
| 26 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 2.000 |
| 27 | `functional-analysis.baire.theorem` | Banach 空间上的 Baire 范畴定理 | 2.000 |
| 28 | `functional-analysis.open-mapping` | Banach 开映像定理 | 2.000 |
| 29 | `linear-algebra.decomposition.qr` | QR 分解 | 2.000 |
| 30 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 2.000 |

## 基础设施榜（传递影响）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 16.250 |
| 2 | `topology.space.def` | 拓扑空间与开闭集公理 | 16.062 |
| 3 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 16.000 |
| 4 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 14.250 |
| 5 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 13.531 |
| 6 | `linear-algebra.vector-space.def` | 向量空间定义 | 13.406 |
| 7 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 13.312 |
| 8 | `analysis.continuity.definition` | 连续性定义 | 12.281 |
| 9 | `real-analysis.measure.def` | 测度公理 | 11.875 |
| 10 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 10.750 |
| 11 | `real-analysis.measure.sigma-algebra` | σ-代数公理 | 9.688 |
| 12 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 9.469 |
| 13 | `real-analysis.measure.measurable-function` | 可测函数 | 9.125 |
| 14 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 8.938 |
| 15 | `analysis.derivative.const` | 常数/线性函数导数 | 8.906 |
| 16 | `analysis.derivative.chain-rule` | 链式法则 | 8.875 |
| 17 | `settheory.ordinal.order-type` | 良序与序型 | 8.500 |
| 18 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 8.250 |
| 19 | `topology.metric.def` | 度量空间与开球 | 8.125 |
| 20 | `settheory.set.ext` | 外延性原理 | 8.000 |
| 21 | `analysis.series.basic` | 数项级数基础 | 7.906 |
| 22 | `analysis.series.tests` | 数项级数判别法 | 7.812 |
| 23 | `settheory.ordinal.transfinite-recursion` | 超限递归 | 7.594 |
| 24 | `settheory.ordinal.transfinite-induction` | 超限归纳 | 7.219 |
| 25 | `settheory.googology.primitive-recursion` | 原始递归：从初值逐步生成自然数函数 | 7.188 |
| 26 | `complex-analysis.integral.path` | 复路径与路径积分 | 7.000 |
| 27 | `abstract-algebra.ring.domain` | 零因子、整环与域 | 6.875 |
| 28 | `settheory.googology.hereditary-base` | 遗传基表示：连指数也用同一底数展开 | 6.875 |
| 29 | `analysis.special-functions.log-tan-pow` | 对数、正切、幂函数与反三角函数 | 6.812 |
| 30 | `real-analysis.riemann.def` | 黎曼积分定义 | 6.750 |

## 跨学科桥梁榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `linear-algebra.vector-space.def` | 向量空间定义 | 3.000 |
| 2 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 2.750 |
| 3 | `settheory.set.ext` | 外延性原理 | 2.000 |
| 4 | `analysis.continuity.definition` | 连续性定义 | 1.750 |
| 5 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 1.750 |
| 6 | `topology.metric.def` | 度量空间与开球 | 1.750 |
| 7 | `linear-algebra.det.mul` | 积的行列式 | 1.500 |
| 8 | `analysis.continuity.uniform` | 一致连续 | 1.250 |
| 9 | `analysis.continuity.uniform-compact` | 紧集上连续 ⟹ 一致连续 | 1.250 |
| 10 | `analysis.derivative.const` | 常数/线性函数导数 | 1.250 |
| 11 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 1.250 |
| 12 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 1.250 |
| 13 | `real-analysis.riemann.cont-integrable` | 连续函数黎曼可积 | 1.250 |
| 14 | `real-analysis.riemann.def` | 黎曼积分定义 | 1.250 |
| 15 | `topology.metric.cauchy-complete` | Cauchy 列与完备空间 | 1.250 |
| 16 | `abstract-algebra.group.def` | 子群判定与基本性质 | 1.000 |
| 17 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 1.000 |
| 18 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 1.000 |
| 19 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 1.000 |
| 20 | `abstract-algebra.ring.domain` | 零因子、整环与域 | 1.000 |
| 21 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 1.000 |
| 22 | `analysis.constants.e-definition` | 自然常数 e 的定义与基本范围 | 1.000 |
| 23 | `analysis.constants.pi-definition` | 圆周率 π 的定义接口与基本特殊值 | 1.000 |
| 24 | `analysis.derivative.chain-rule` | 链式法则 | 1.000 |
| 25 | `analysis.func-limit.definition` | 函数极限定义（ε-δ 判据） | 1.000 |
| 26 | `analysis.multivariable.frechet` | Fréchet全微分与方向导数 | 1.000 |
| 27 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 1.000 |
| 28 | `analysis.mvt.taylor` | 泰勒公式（Lagrange 余项） | 1.000 |
| 29 | `analysis.real.archimedean` | 阿基米德性质 | 1.000 |
| 30 | `analysis.real.bounded-sets.bdd-above` | 有上界集的刻画 | 1.000 |

## 形式化复用榜（Lean 调用文件数）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 10 |
| 2 | `settheory.ordinal.addition` | 序数加法不交换 | 9 |
| 3 | `settheory.ordinal.multiplication` | 序数乘法不交换 | 9 |
| 4 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 9 |
| 5 | `linear-algebra.vector-space.span` | 生成子空间 | 6 |
| 6 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 4 |
| 7 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 3 |
| 8 | `abstract-algebra.ring.quotient` | 商环及其泛性质 | 3 |
| 9 | `complex-analysis.integral.path` | 复路径与路径积分 | 3 |
| 10 | `linear-algebra.det.mul` | 积的行列式 | 3 |
| 11 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 3 |
| 12 | `analysis.multivariable.parametrized-curves-surfaces` | 参数曲线与参数曲面 | 2 |
| 13 | `analysis.multivariable.riemann-box` | 多元 Riemann 盒积分 | 2 |
| 14 | `analysis.power-series.definition` | 实幂级数的定义与收敛点集 | 2 |
| 15 | `real-analysis.riemann.def` | 黎曼积分定义 | 2 |
| 16 | `settheory.ordinal.no-infinite-descent` | 序数无穷下降不可能 | 2 |
| 17 | `settheory.ordinal.normal-function` | 正规序数函数 | 2 |
| 18 | `topology.homotopy.definition-foundation` | 同伦与相对端点道路同伦 | 2 |
| 19 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 1 |
| 20 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 1 |
| 21 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 1 |
| 22 | `abstract-algebra.ring.iso-theorems` | 环的同构定理 | 1 |
| 23 | `analysis.continuity.max-min` | 最值定理 | 1 |
| 24 | `analysis.multivariable.green-gauss-stokes` | Green、Gauss与Stokes公式 | 1 |
| 25 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 1 |
| 26 | `analysis.series.basic` | 数项级数基础 | 1 |
| 27 | `analysis.series.cauchy-product-definition` | Cauchy 乘积的定义与有限三角恒等式 | 1 |
| 28 | `analysis.trigonometric.double-half` | 三角函数倍角与降幂公式 | 1 |
| 29 | `complex-analysis.cauchy.derivatives` | Cauchy 高阶导数公式与估计 | 1 |
| 30 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 1 |
