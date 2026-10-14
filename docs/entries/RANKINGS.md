# 条目依赖排行

> 本文件由 `scripts/gen_entry_rankings.py` 生成，请勿手工编辑。

排名只覆盖 `verified` 非兼容桥条目。总分为四项百分位的加权和：加权直接引用 30%、
距离衰减的传递影响 30%、跨学科影响 20%、Lean 实际使用文件数 20%。
Lean 使用采用去注释后的主声明文本扫描；短名碰撞时该项记为 0，详细证据见 JSON。

## 综合榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 98.99 |
| 2 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 97.11 |
| 3 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 96.91 |
| 4 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 95.63 |
| 5 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 95.62 |
| 6 | `complex-analysis.integral.path` | 复路径与路径积分 | 95.37 |
| 7 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 94.20 |
| 8 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 93.95 |
| 9 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 93.24 |
| 10 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 92.57 |
| 11 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 92.46 |
| 12 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 92.01 |
| 13 | `analysis.series.basic` | 数项级数基础 | 91.35 |
| 14 | `abstract-algebra.group.def` | 子群判定与基本性质 | 91.16 |
| 15 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 90.82 |
| 16 | `real-analysis.riemann.def` | 黎曼积分定义 | 90.63 |
| 17 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 90.50 |
| 18 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 90.45 |
| 19 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 89.56 |
| 20 | `functional-analysis.baire.theorem` | Banach 空间上的 Baire 范畴定理 | 88.72 |
| 21 | `analysis.multivariable.jordan-region` | Jordan 可测区域 | 88.65 |
| 22 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 88.18 |
| 23 | `number-theory.elementary.continued-fraction-convergent` | 实数连分数的有理收敛子 | 88.13 |
| 24 | `linear-algebra.det.mul` | 积的行列式 | 88.08 |
| 25 | `topology.fundamental-group.van-kampen-cover-subdivision` | 二开集覆盖下的有限带标签道路细分 | 87.97 |
| 26 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 87.57 |
| 27 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 87.33 |
| 28 | `settheory.googology.bounded-halting` | 限定步数停机 | 87.26 |
| 29 | `statistics.estimator.definition` | 统计量、随机化估计量与风险 | 87.24 |
| 30 | `topology.space.def` | 拓扑空间与开闭集公理 | 87.21 |

## 教材枢纽榜（加权直接引用）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 9.393 |
| 2 | `topology.space.def` | 拓扑空间与开闭集公理 | 6.500 |
| 3 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 5.750 |
| 4 | `complex-analysis.integral.path` | 复路径与路径积分 | 5.060 |
| 5 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 5.000 |
| 6 | `analysis.derivative.chain-rule` | 链式法则 | 4.750 |
| 7 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 4.583 |
| 8 | `real-analysis.measure.def` | 测度公理 | 4.083 |
| 9 | `settheory.set.ext` | 外延性原理 | 4.000 |
| 10 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 3.833 |
| 11 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 3.833 |
| 12 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 3.750 |
| 13 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 3.500 |
| 14 | `commutative-algebra.module.definition` | 模、子模与模同态 | 3.500 |
| 15 | `topology.fundamental-group.operations-standard` | 基本群的运算、复合次序与群律 | 3.500 |
| 16 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 3.333 |
| 17 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 3.250 |
| 18 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 3.167 |
| 19 | `number-theory.elementary.divisibility` | 带余除法、最大公因数与 Bézout 等式 | 3.000 |
| 20 | `probability.space.definition` | 概率空间与事件 | 3.000 |
| 21 | `real-analysis.signed-measure.definition` | 有符号测度与正／负／零集 | 3.000 |
| 22 | `settheory.googology.goodstein-ordinal-measure` | Goodstein 序数度量：把有限底数换成 ω | 3.000 |
| 23 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 2.917 |
| 24 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 2.833 |
| 25 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 2.833 |
| 26 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2.750 |
| 27 | `analysis.series.basic` | 数项级数基础 | 2.750 |
| 28 | `linear-algebra.vector-space.def` | 向量空间定义 | 2.750 |
| 29 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 2.750 |
| 30 | `functional-analysis.baire.theorem` | Banach 空间上的 Baire 范畴定理 | 2.583 |

## 基础设施榜（传递影响）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 21.375 |
| 2 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 19.125 |
| 3 | `topology.space.def` | 拓扑空间与开闭集公理 | 18.812 |
| 4 | `linear-algebra.vector-space.def` | 向量空间定义 | 18.688 |
| 5 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 18.281 |
| 6 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 17.750 |
| 7 | `real-analysis.measure.def` | 测度公理 | 17.312 |
| 8 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 16.875 |
| 9 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 16.594 |
| 10 | `topology.foundation.constructions` | 诱导拓扑、子空间拓扑与积拓扑 | 15.344 |
| 11 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 14.656 |
| 12 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 14.500 |
| 13 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 13.531 |
| 14 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 13.312 |
| 15 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 13.312 |
| 16 | `settheory.set.ext` | 外延性原理 | 13.250 |
| 17 | `real-analysis.measure.sigma-algebra` | σ-代数公理 | 12.906 |
| 18 | `analysis.continuity.definition` | 连续性定义 | 12.719 |
| 19 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 12.625 |
| 20 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 12.438 |
| 21 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 11.875 |
| 22 | `complex-analysis.integral.path` | 复路径与路径积分 | 11.375 |
| 23 | `real-analysis.measure.measurable-function` | 可测函数 | 10.562 |
| 24 | `functional-analysis.operator.continuous-linear-map` | 连续线性算子 | 10.438 |
| 25 | `probability.space.definition` | 概率空间与事件 | 10.344 |
| 26 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 10.031 |
| 27 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 9.969 |
| 28 | `topology.metric.def` | 度量空间与开球 | 9.969 |
| 29 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 9.531 |
| 30 | `probability.distribution.pushforward` | 分布作为推前测度 | 9.188 |

## 跨学科桥梁榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `linear-algebra.vector-space.def` | 向量空间定义 | 4.000 |
| 2 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 2.750 |
| 3 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2.000 |
| 4 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 2.000 |
| 5 | `probability.space.definition` | 概率空间与事件 | 2.000 |
| 6 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 2.000 |
| 7 | `settheory.set.ext` | 外延性原理 | 2.000 |
| 8 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 2.000 |
| 9 | `analysis.continuity.definition` | 连续性定义 | 1.750 |
| 10 | `topology.metric.def` | 度量空间与开球 | 1.750 |
| 11 | `analysis.continuity.uniform-compact` | 紧集上连续 ⟹ 一致连续 | 1.500 |
| 12 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 1.500 |
| 13 | `linear-algebra.det.mul` | 积的行列式 | 1.500 |
| 14 | `probability.expectation.definition` | 期望与可积性 | 1.500 |
| 15 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 1.500 |
| 16 | `real-analysis.riemann.cont-integrable` | 连续函数黎曼可积 | 1.500 |
| 17 | `real-analysis.riemann.def` | 黎曼积分定义 | 1.500 |
| 18 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 1.500 |
| 19 | `topology.homotopy.path-polygonal-approximation` | 开集内道路的相对折线逼近 | 1.500 |
| 20 | `topology.homotopy.piecewise-c1-path` | 分段 C1 道路及开集内正则替换 | 1.500 |
| 21 | `analysis.continuity.uniform` | 一致连续 | 1.250 |
| 22 | `analysis.derivative.const` | 常数/线性函数导数 | 1.250 |
| 23 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 1.250 |
| 24 | `linear-algebra.vector-space.subspace` | 子空间 | 1.250 |
| 25 | `probability.convergence.modes` | 随机变量的四种收敛模式 | 1.250 |
| 26 | `probability.distribution.pushforward` | 分布作为推前测度 | 1.250 |
| 27 | `probability.moments.variance` | 方差与协方差 | 1.250 |
| 28 | `probability.variable.definition` | 随机变量与可测性 | 1.250 |
| 29 | `real-analysis.calculus.ftc` | 微积分基本定理（第二形式） | 1.250 |
| 30 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 1.250 |

## 形式化复用榜（Lean 调用文件数）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `analysis.complex.definition` | 复数的定义与基本运算 | 56 |
| 2 | `topology.homotopy.definition-foundation` | 同伦与相对端点道路同伦 | 35 |
| 3 | `topology.fundamental-group.van-kampen-cover-subdivision` | 二开集覆盖下的有限带标签道路细分 | 21 |
| 4 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 21 |
| 5 | `topology.fundamental-group.van-kampen-surjectivity` | 二开集 van Kampen 规范同态的满射 | 18 |
| 6 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 17 |
| 7 | `topology.fundamental-group.path-corrected-loop` | 道路段的基点修正环路与有限望远镜公式 | 15 |
| 8 | `topology.fundamental-group.van-kampen-letter-word` | van Kampen Pushout 字母词与拼接环路 | 13 |
| 9 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 11 |
| 10 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 11 |
| 11 | `functional-analysis.compact-operator.composition` | 紧算子的理想性质与范数极限 | 10 |
| 12 | `settheory.ordinal.addition` | 序数加法不交换 | 10 |
| 13 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 9 |
| 14 | `settheory.ordinal.multiplication` | 序数乘法不交换 | 9 |
| 15 | `topology.fundamental-group.van-kampen-vertex-potential` | van Kampen 网格顶点的 connector potential | 7 |
| 16 | `functional-analysis.subspace.annihilator-closure` | 连续零化子、双零化子与子空间闭包 | 5 |
| 17 | `topology.fundamental-group.van-kampen-row-anchoring` | van Kampen 单行 frames 的右锚定 | 5 |
| 18 | `topology.homotopy.path-cod-restrict` | 道路到子空间的余域限制 | 5 |
| 19 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 4 |
| 20 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 4 |
| 21 | `complex-analysis.integral.path` | 复路径与路径积分 | 4 |
| 22 | `functional-analysis.fredholm.alternative` | 恒等算子的紧扰动 | 4 |
| 23 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 3 |
| 24 | `abstract-algebra.ring.quotient` | 商环及其泛性质 | 3 |
| 25 | `analysis.multivariable.jordan-region` | Jordan 可测区域 | 3 |
| 26 | `complex-analysis.path-integral.dyadic-assembly` | 分段 C1 道路的可积性桥与 dyadic 积分组装 | 3 |
| 27 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 3 |
| 28 | `linear-algebra.det.mul` | 积的行列式 | 3 |
| 29 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 3 |
| 30 | `abstract-algebra.field.galois-correspondence` | 有限 Galois 基本对应 | 2 |
