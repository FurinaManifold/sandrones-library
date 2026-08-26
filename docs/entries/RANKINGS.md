# 条目依赖排行

> 本文件由 `scripts/gen_entry_rankings.py` 生成，请勿手工编辑。

排名只覆盖 `verified` 非兼容桥条目。总分为四项百分位的加权和：加权直接引用 30%、
距离衰减的传递影响 30%、跨学科影响 20%、Lean 实际使用文件数 20%。
Lean 使用采用去注释后的主声明文本扫描；短名碰撞时该项记为 0，详细证据见 JSON。

## 综合榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 98.93 |
| 2 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 94.92 |
| 3 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 94.83 |
| 4 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 94.51 |
| 5 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 94.33 |
| 6 | `complex-analysis.integral.path` | 复路径与路径积分 | 94.30 |
| 7 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 93.84 |
| 8 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 92.91 |
| 9 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 92.83 |
| 10 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 92.58 |
| 11 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 92.06 |
| 12 | `analysis.series.basic` | 数项级数基础 | 91.93 |
| 13 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 91.87 |
| 14 | `abstract-algebra.group.def` | 子群判定与基本性质 | 91.70 |
| 15 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 91.44 |
| 16 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 91.17 |
| 17 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 91.00 |
| 18 | `real-analysis.riemann.def` | 黎曼积分定义 | 90.55 |
| 19 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 90.05 |
| 20 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 89.71 |
| 21 | `topology.fundamental-group.van-kampen-cover-subdivision` | 二开集覆盖下的有限带标签道路细分 | 88.78 |
| 22 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 88.24 |
| 23 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 88.06 |
| 24 | `settheory.googology.bounded-halting` | 限定步数停机 | 88.04 |
| 25 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 87.56 |
| 26 | `linear-algebra.det.mul` | 积的行列式 | 87.46 |
| 27 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 87.28 |
| 28 | `settheory.set.ext` | 外延性原理 | 87.18 |
| 29 | `functional-analysis.banach-alaoglu` | Banach–Alaoglu 定理 | 87.05 |
| 30 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 86.60 |

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
| 8 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 3.833 |
| 9 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 3.750 |
| 10 | `complex-analysis.integral.path` | 复路径与路径积分 | 3.667 |
| 11 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 3.500 |
| 12 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 3.333 |
| 13 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 3.167 |
| 14 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 3.000 |
| 15 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 3.000 |
| 16 | `number-theory.elementary.divisibility` | 带余除法、最大公因数与 Bézout 等式 | 3.000 |
| 17 | `settheory.googology.goodstein-ordinal-measure` | Goodstein 序数度量：把有限底数换成 ω | 3.000 |
| 18 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 2.917 |
| 19 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 2.833 |
| 20 | `analysis.series.basic` | 数项级数基础 | 2.750 |
| 21 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 2.750 |
| 22 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 2.583 |
| 23 | `abstract-algebra.group.def` | 子群判定与基本性质 | 2.500 |
| 24 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2.500 |
| 25 | `analysis.real.sup` | 确界原理 | 2.500 |
| 26 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 2.500 |
| 27 | `linear-algebra.vector-space.def` | 向量空间定义 | 2.500 |
| 28 | `probability.expectation.definition` | 期望与可积性 | 2.500 |
| 29 | `settheory.googology.hereditary-base` | 遗传基表示：连指数也用同一底数展开 | 2.500 |
| 30 | `topology.fundamental-group.operations-standard` | 基本群的运算、复合次序与群律 | 2.500 |

## 基础设施榜（传递影响）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 16.875 |
| 2 | `topology.space.def` | 拓扑空间与开闭集公理 | 16.812 |
| 3 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 16.250 |
| 4 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 15.969 |
| 5 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 14.750 |
| 6 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 14.625 |
| 7 | `linear-algebra.vector-space.def` | 向量空间定义 | 14.156 |
| 8 | `topology.foundation.constructions` | 诱导拓扑、子空间拓扑与积拓扑 | 13.656 |
| 9 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 13.531 |
| 10 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 13.312 |
| 11 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 13.219 |
| 12 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 12.594 |
| 13 | `analysis.continuity.definition` | 连续性定义 | 12.281 |
| 14 | `settheory.set.ext` | 外延性原理 | 12.281 |
| 15 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 12.281 |
| 16 | `real-analysis.measure.def` | 测度公理 | 11.875 |
| 17 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 11.125 |
| 18 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 11.062 |
| 19 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 9.969 |
| 20 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 9.688 |
| 21 | `real-analysis.measure.sigma-algebra` | σ-代数公理 | 9.688 |
| 22 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 9.625 |
| 23 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 9.531 |
| 24 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 9.188 |
| 25 | `real-analysis.measure.measurable-function` | 可测函数 | 9.125 |
| 26 | `analysis.derivative.const` | 常数/线性函数导数 | 8.906 |
| 27 | `analysis.derivative.chain-rule` | 链式法则 | 8.875 |
| 28 | `topology.metric.def` | 度量空间与开球 | 8.875 |
| 29 | `settheory.ordinal.order-type` | 良序与序型 | 8.562 |
| 30 | `abstract-algebra.group.def` | 子群判定与基本性质 | 8.469 |

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
| 8 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 1.500 |
| 9 | `analysis.continuity.uniform` | 一致连续 | 1.250 |
| 10 | `analysis.continuity.uniform-compact` | 紧集上连续 ⟹ 一致连续 | 1.250 |
| 11 | `analysis.derivative.const` | 常数/线性函数导数 | 1.250 |
| 12 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 1.250 |
| 13 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 1.250 |
| 14 | `real-analysis.riemann.cont-integrable` | 连续函数黎曼可积 | 1.250 |
| 15 | `real-analysis.riemann.def` | 黎曼积分定义 | 1.250 |
| 16 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 1.250 |
| 17 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 1.250 |
| 18 | `topology.homotopy.piecewise-c1-path` | 分段 C1 道路及开集内正则替换 | 1.250 |
| 19 | `topology.metric.cauchy-complete` | Cauchy 列与完备空间 | 1.250 |
| 20 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 1.000 |
| 21 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 1.000 |
| 22 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 1.000 |
| 23 | `abstract-algebra.field.separable-normal` | 可分多项式、可分扩张与正规扩张 | 1.000 |
| 24 | `abstract-algebra.field.splitting` | 多项式的分裂域、存在性与唯一到同构 | 1.000 |
| 25 | `abstract-algebra.group.def` | 子群判定与基本性质 | 1.000 |
| 26 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 1.000 |
| 27 | `abstract-algebra.poly.factorization` | 多项式唯一分解与根重数 | 1.000 |
| 28 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 1.000 |
| 29 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 1.000 |
| 30 | `abstract-algebra.ring.domain` | 零因子、整环与域 | 1.000 |

## 形式化复用榜（Lean 调用文件数）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.homotopy.definition-foundation` | 同伦与相对端点道路同伦 | 30 |
| 2 | `topology.fundamental-group.van-kampen-cover-subdivision` | 二开集覆盖下的有限带标签道路细分 | 21 |
| 3 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 21 |
| 4 | `topology.fundamental-group.van-kampen-surjectivity` | 二开集 van Kampen 规范同态的满射 | 18 |
| 5 | `topology.fundamental-group.path-corrected-loop` | 道路段的基点修正环路与有限望远镜公式 | 15 |
| 6 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 15 |
| 7 | `topology.fundamental-group.van-kampen-letter-word` | van Kampen Pushout 字母词与拼接环路 | 13 |
| 8 | `linear-algebra.vector-space.span` | 生成子空间 | 11 |
| 9 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 11 |
| 10 | `settheory.ordinal.addition` | 序数加法不交换 | 10 |
| 11 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 9 |
| 12 | `settheory.ordinal.multiplication` | 序数乘法不交换 | 9 |
| 13 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 9 |
| 14 | `topology.fundamental-group.van-kampen-vertex-potential` | van Kampen 网格顶点的 connector potential | 7 |
| 15 | `functional-analysis.compact-operator.composition` | 紧算子的理想性质与范数极限 | 5 |
| 16 | `functional-analysis.subspace.annihilator-closure` | 连续零化子、双零化子与子空间闭包 | 5 |
| 17 | `topology.fundamental-group.van-kampen-row-anchoring` | van Kampen 单行 frames 的右锚定 | 5 |
| 18 | `topology.homotopy.path-cod-restrict` | 道路到子空间的余域限制 | 5 |
| 19 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 4 |
| 20 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 4 |
| 21 | `complex-analysis.integral.path` | 复路径与路径积分 | 4 |
| 22 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 4 |
| 23 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 3 |
| 24 | `abstract-algebra.ring.quotient` | 商环及其泛性质 | 3 |
| 25 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 3 |
| 26 | `linear-algebra.det.mul` | 积的行列式 | 3 |
| 27 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 3 |
| 28 | `abstract-algebra.field.galois-correspondence` | 有限 Galois 基本对应 | 2 |
| 29 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2 |
| 30 | `analysis.multivariable.parametrized-curves-surfaces` | 参数曲线与参数曲面 | 2 |
