# 条目依赖排行

> 本文件由 `scripts/gen_entry_rankings.py` 生成，请勿手工编辑。

排名只覆盖 `verified` 非兼容桥条目。总分为四项百分位的加权和：加权直接引用 30%、
距离衰减的传递影响 30%、跨学科影响 20%、Lean 实际使用文件数 20%。
Lean 使用采用去注释后的主声明文本扫描；短名碰撞时该项记为 0，详细证据见 JSON。

## 综合榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 99.15 |
| 2 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 95.57 |
| 3 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 95.29 |
| 4 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 94.84 |
| 5 | `complex-analysis.integral.path` | 复路径与路径积分 | 94.04 |
| 6 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 93.66 |
| 7 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 92.75 |
| 8 | `analysis.series.basic` | 数项级数基础 | 92.57 |
| 9 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 92.47 |
| 10 | `abstract-algebra.group.def` | 子群判定与基本性质 | 91.87 |
| 11 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 91.51 |
| 12 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 91.19 |
| 13 | `real-analysis.riemann.def` | 黎曼积分定义 | 90.90 |
| 14 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 90.65 |
| 15 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 90.42 |
| 16 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 90.36 |
| 17 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 88.77 |
| 18 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 88.60 |
| 19 | `settheory.googology.bounded-halting` | 限定步数停机 | 88.44 |
| 20 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 88.41 |
| 21 | `linear-algebra.det.mul` | 积的行列式 | 88.27 |
| 22 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 87.87 |
| 23 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 87.74 |
| 24 | `settheory.set.ext` | 外延性原理 | 87.40 |
| 25 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 86.91 |
| 26 | `number-theory.elementary.congruence` | 同余与剩余环 | 86.75 |
| 27 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 86.72 |
| 28 | `linear-algebra.vector-space.def` | 向量空间定义 | 86.72 |
| 29 | `analysis.trigonometric.double-half` | 三角函数倍角与降幂公式 | 86.04 |
| 30 | `topology.space.def` | 拓扑空间与开闭集公理 | 85.93 |

## 教材枢纽榜（加权直接引用）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 8.500 |
| 2 | `topology.space.def` | 拓扑空间与开闭集公理 | 6.000 |
| 3 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 5.250 |
| 4 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 5.000 |
| 5 | `analysis.derivative.chain-rule` | 链式法则 | 4.750 |
| 6 | `settheory.set.ext` | 外延性原理 | 4.000 |
| 7 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 3.833 |
| 8 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 3.750 |
| 9 | `complex-analysis.integral.path` | 复路径与路径积分 | 3.667 |
| 10 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 3.500 |
| 11 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 3.333 |
| 12 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 3.167 |
| 13 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 3.000 |
| 14 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 3.000 |
| 15 | `number-theory.elementary.divisibility` | 带余除法、最大公因数与 Bézout 等式 | 3.000 |
| 16 | `settheory.googology.goodstein-ordinal-measure` | Goodstein 序数度量：把有限底数换成 ω | 3.000 |
| 17 | `analysis.series.basic` | 数项级数基础 | 2.750 |
| 18 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 2.750 |
| 19 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 2.583 |
| 20 | `abstract-algebra.group.def` | 子群判定与基本性质 | 2.500 |
| 21 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2.500 |
| 22 | `analysis.real.sup` | 确界原理 | 2.500 |
| 23 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 2.500 |
| 24 | `linear-algebra.vector-space.def` | 向量空间定义 | 2.500 |
| 25 | `settheory.googology.hereditary-base` | 遗传基表示：连指数也用同一底数展开 | 2.500 |
| 26 | `topology.fundamental-group.operations-standard` | 基本群的运算、复合次序与群律 | 2.500 |
| 27 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 2.500 |
| 28 | `topology.space.continuous` | 连续映射 | 2.500 |
| 29 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 2.333 |
| 30 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 2.333 |

## 基础设施榜（传递影响）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.space.def` | 拓扑空间与开闭集公理 | 16.625 |
| 2 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 16.250 |
| 3 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 16.000 |
| 4 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 15.500 |
| 5 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 14.250 |
| 6 | `linear-algebra.vector-space.def` | 向量空间定义 | 13.969 |
| 7 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 13.531 |
| 8 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 13.312 |
| 9 | `analysis.continuity.definition` | 连续性定义 | 12.281 |
| 10 | `real-analysis.measure.def` | 测度公理 | 11.875 |
| 11 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 11.594 |
| 12 | `settheory.set.ext` | 外延性原理 | 10.781 |
| 13 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 9.969 |
| 14 | `real-analysis.measure.sigma-algebra` | σ-代数公理 | 9.688 |
| 15 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 9.625 |
| 16 | `topology.foundation.constructions` | 诱导拓扑、子空间拓扑与积拓扑 | 9.562 |
| 17 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 9.125 |
| 18 | `real-analysis.measure.measurable-function` | 可测函数 | 9.125 |
| 19 | `analysis.derivative.const` | 常数/线性函数导数 | 8.906 |
| 20 | `analysis.derivative.chain-rule` | 链式法则 | 8.875 |
| 21 | `topology.metric.def` | 度量空间与开球 | 8.688 |
| 22 | `settheory.ordinal.order-type` | 良序与序型 | 8.562 |
| 23 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 8.562 |
| 24 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 8.500 |
| 25 | `abstract-algebra.ring.domain` | 零因子、整环与域 | 8.312 |
| 26 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 8.250 |
| 27 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 8.125 |
| 28 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 8.062 |
| 29 | `analysis.series.basic` | 数项级数基础 | 7.906 |
| 30 | `settheory.ordinal.transfinite-recursion` | 超限递归 | 7.844 |

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
| 16 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 1.000 |
| 17 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 1.000 |
| 18 | `abstract-algebra.field.splitting` | 多项式的分裂域、存在性与唯一到同构 | 1.000 |
| 19 | `abstract-algebra.group.def` | 子群判定与基本性质 | 1.000 |
| 20 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 1.000 |
| 21 | `abstract-algebra.poly.factorization` | 多项式唯一分解与根重数 | 1.000 |
| 22 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 1.000 |
| 23 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 1.000 |
| 24 | `abstract-algebra.ring.domain` | 零因子、整环与域 | 1.000 |
| 25 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 1.000 |
| 26 | `analysis.constants.e-definition` | 自然常数 e 的定义与基本范围 | 1.000 |
| 27 | `analysis.constants.pi-definition` | 圆周率 π 的定义接口与基本特殊值 | 1.000 |
| 28 | `analysis.derivative.chain-rule` | 链式法则 | 1.000 |
| 29 | `analysis.func-limit.definition` | 函数极限定义（ε-δ 判据） | 1.000 |
| 30 | `analysis.multivariable.frechet` | Fréchet全微分与方向导数 | 1.000 |

## 形式化复用榜（Lean 调用文件数）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 11 |
| 2 | `linear-algebra.vector-space.span` | 生成子空间 | 10 |
| 3 | `settheory.ordinal.addition` | 序数加法不交换 | 10 |
| 4 | `settheory.ordinal.multiplication` | 序数乘法不交换 | 9 |
| 5 | `topology.homotopy.definition-foundation` | 同伦与相对端点道路同伦 | 9 |
| 6 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 9 |
| 7 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 7 |
| 8 | `functional-analysis.subspace.annihilator-closure` | 连续零化子、双零化子与子空间闭包 | 5 |
| 9 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 4 |
| 10 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 4 |
| 11 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 3 |
| 12 | `abstract-algebra.ring.quotient` | 商环及其泛性质 | 3 |
| 13 | `complex-analysis.integral.path` | 复路径与路径积分 | 3 |
| 14 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 3 |
| 15 | `linear-algebra.det.mul` | 积的行列式 | 3 |
| 16 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 3 |
| 17 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 2 |
| 18 | `abstract-algebra.field.separable-normal` | 可分多项式、可分扩张与正规扩张 | 2 |
| 19 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2 |
| 20 | `analysis.multivariable.parametrized-curves-surfaces` | 参数曲线与参数曲面 | 2 |
| 21 | `analysis.multivariable.riemann-box` | 多元 Riemann 盒积分 | 2 |
| 22 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 2 |
| 23 | `analysis.power-series.definition` | 实幂级数的定义与收敛点集 | 2 |
| 24 | `real-analysis.riemann.def` | 黎曼积分定义 | 2 |
| 25 | `settheory.googology.hereditary-natural-encoding` | 任意自然数的遗传基编码 | 2 |
| 26 | `settheory.googology.hereditary-natural-encoding-strict-order` | 遗传自然数编码的全局严格保序 | 2 |
| 27 | `settheory.ordinal.no-infinite-descent` | 序数无穷下降不可能 | 2 |
| 28 | `settheory.ordinal.normal-function` | 正规序数函数 | 2 |
| 29 | `abstract-algebra.field.galois-correspondence` | 有限 Galois 基本对应 | 1 |
| 30 | `abstract-algebra.field.splitting` | 多项式的分裂域、存在性与唯一到同构 | 1 |
