# 条目依赖排行

> 本文件由 `scripts/gen_entry_rankings.py` 生成，请勿手工编辑。

排名只覆盖 `verified` 非兼容桥条目。总分为四项百分位的加权和：加权直接引用 30%、
距离衰减的传递影响 30%、跨学科影响 20%、Lean 实际使用文件数 20%。
Lean 使用采用去注释后的主声明文本扫描；短名碰撞时该项记为 0，详细证据见 JSON。

## 综合榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 99.02 |
| 2 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 95.30 |
| 3 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 95.05 |
| 4 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 94.52 |
| 5 | `complex-analysis.integral.path` | 复路径与路径积分 | 93.88 |
| 6 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 93.34 |
| 7 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 93.25 |
| 8 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 92.51 |
| 9 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 92.42 |
| 10 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 92.24 |
| 11 | `analysis.series.basic` | 数项级数基础 | 92.15 |
| 12 | `abstract-algebra.group.def` | 子群判定与基本性质 | 92.00 |
| 13 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 91.55 |
| 14 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 91.31 |
| 15 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 91.17 |
| 16 | `real-analysis.riemann.def` | 黎曼积分定义 | 90.73 |
| 17 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 90.18 |
| 18 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 89.80 |
| 19 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 88.45 |
| 20 | `settheory.googology.bounded-halting` | 限定步数停机 | 88.18 |
| 21 | `linear-algebra.det.mul` | 积的行列式 | 87.83 |
| 22 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 87.76 |
| 23 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 87.56 |
| 24 | `settheory.set.ext` | 外延性原理 | 87.28 |
| 25 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 86.72 |
| 26 | `number-theory.elementary.congruence` | 同余与剩余环 | 86.59 |
| 27 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 86.55 |
| 28 | `linear-algebra.vector-space.def` | 向量空间定义 | 86.54 |
| 29 | `analysis.trigonometric.double-half` | 三角函数倍角与降幂公式 | 86.01 |
| 30 | `topology.space.def` | 拓扑空间与开闭集公理 | 85.87 |

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
| 11 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 3.333 |
| 12 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 3.333 |
| 13 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 3.167 |
| 14 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 3.000 |
| 15 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 3.000 |
| 16 | `number-theory.elementary.divisibility` | 带余除法、最大公因数与 Bézout 等式 | 3.000 |
| 17 | `settheory.googology.goodstein-ordinal-measure` | Goodstein 序数度量：把有限底数换成 ω | 3.000 |
| 18 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 2.917 |
| 19 | `analysis.series.basic` | 数项级数基础 | 2.750 |
| 20 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 2.750 |
| 21 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 2.583 |
| 22 | `abstract-algebra.group.def` | 子群判定与基本性质 | 2.500 |
| 23 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2.500 |
| 24 | `analysis.real.sup` | 确界原理 | 2.500 |
| 25 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 2.500 |
| 26 | `linear-algebra.vector-space.def` | 向量空间定义 | 2.500 |
| 27 | `settheory.googology.hereditary-base` | 遗传基表示：连指数也用同一底数展开 | 2.500 |
| 28 | `topology.fundamental-group.operations-standard` | 基本群的运算、复合次序与群律 | 2.500 |
| 29 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 2.500 |
| 30 | `topology.space.continuous` | 连续映射 | 2.500 |

## 基础设施榜（传递影响）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.space.def` | 拓扑空间与开闭集公理 | 16.625 |
| 2 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 16.250 |
| 3 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 16.000 |
| 4 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 15.500 |
| 5 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 14.750 |
| 6 | `linear-algebra.vector-space.def` | 向量空间定义 | 13.969 |
| 7 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 13.531 |
| 8 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 13.375 |
| 9 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 13.312 |
| 10 | `analysis.continuity.definition` | 连续性定义 | 12.281 |
| 11 | `real-analysis.measure.def` | 测度公理 | 11.875 |
| 12 | `settheory.set.ext` | 外延性原理 | 11.656 |
| 13 | `topology.foundation.constructions` | 诱导拓扑、子空间拓扑与积拓扑 | 11.656 |
| 14 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 10.719 |
| 15 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 10.469 |
| 16 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 9.969 |
| 17 | `real-analysis.measure.sigma-algebra` | σ-代数公理 | 9.688 |
| 18 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 9.625 |
| 19 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 9.125 |
| 20 | `real-analysis.measure.measurable-function` | 可测函数 | 9.125 |
| 21 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 8.969 |
| 22 | `analysis.derivative.const` | 常数/线性函数导数 | 8.906 |
| 23 | `analysis.derivative.chain-rule` | 链式法则 | 8.875 |
| 24 | `topology.metric.def` | 度量空间与开球 | 8.688 |
| 25 | `settheory.ordinal.order-type` | 良序与序型 | 8.562 |
| 26 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 8.562 |
| 27 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 8.500 |
| 28 | `abstract-algebra.group.def` | 子群判定与基本性质 | 8.469 |
| 29 | `abstract-algebra.ring.domain` | 零因子、整环与域 | 8.375 |
| 30 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 8.250 |

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
| 18 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 1.000 |
| 19 | `abstract-algebra.field.separable-normal` | 可分多项式、可分扩张与正规扩张 | 1.000 |
| 20 | `abstract-algebra.field.splitting` | 多项式的分裂域、存在性与唯一到同构 | 1.000 |
| 21 | `abstract-algebra.group.def` | 子群判定与基本性质 | 1.000 |
| 22 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 1.000 |
| 23 | `abstract-algebra.poly.factorization` | 多项式唯一分解与根重数 | 1.000 |
| 24 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 1.000 |
| 25 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 1.000 |
| 26 | `abstract-algebra.ring.domain` | 零因子、整环与域 | 1.000 |
| 27 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 1.000 |
| 28 | `analysis.constants.e-definition` | 自然常数 e 的定义与基本范围 | 1.000 |
| 29 | `analysis.constants.pi-definition` | 圆周率 π 的定义接口与基本特殊值 | 1.000 |
| 30 | `analysis.derivative.chain-rule` | 链式法则 | 1.000 |

## 形式化复用榜（Lean 调用文件数）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.homotopy.definition-foundation` | 同伦与相对端点道路同伦 | 15 |
| 2 | `topology.fundamental-group.van-kampen-cover-subdivision` | 二开集覆盖下的有限带标签道路细分 | 13 |
| 3 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 12 |
| 4 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 11 |
| 5 | `linear-algebra.vector-space.span` | 生成子空间 | 10 |
| 6 | `settheory.ordinal.addition` | 序数加法不交换 | 10 |
| 7 | `topology.fundamental-group.van-kampen-surjectivity` | 二开集 van Kampen 规范同态的满射 | 10 |
| 8 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 9 |
| 9 | `settheory.ordinal.multiplication` | 序数乘法不交换 | 9 |
| 10 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 9 |
| 11 | `topology.fundamental-group.path-corrected-loop` | 道路段的基点修正环路与有限望远镜公式 | 7 |
| 12 | `topology.fundamental-group.van-kampen-square-subdivision` | 二开集覆盖下的有限带标签方格细分 | 6 |
| 13 | `functional-analysis.subspace.annihilator-closure` | 连续零化子、双零化子与子空间闭包 | 5 |
| 14 | `topology.homotopy.path-cod-restrict` | 道路到子空间的余域限制 | 5 |
| 15 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 4 |
| 16 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 4 |
| 17 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 4 |
| 18 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 3 |
| 19 | `abstract-algebra.ring.quotient` | 商环及其泛性质 | 3 |
| 20 | `complex-analysis.integral.path` | 复路径与路径积分 | 3 |
| 21 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 3 |
| 22 | `linear-algebra.det.mul` | 积的行列式 | 3 |
| 23 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 3 |
| 24 | `topology.fundamental-group.van-kampen-letter-word` | van Kampen Pushout 字母词与拼接环路 | 3 |
| 25 | `topology.fundamental-group.van-kampen-row-anchoring` | van Kampen 单行 frames 的右锚定 | 3 |
| 26 | `abstract-algebra.field.galois-correspondence` | 有限 Galois 基本对应 | 2 |
| 27 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2 |
| 28 | `analysis.multivariable.parametrized-curves-surfaces` | 参数曲线与参数曲面 | 2 |
| 29 | `analysis.multivariable.riemann-box` | 多元 Riemann 盒积分 | 2 |
| 30 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 2 |
