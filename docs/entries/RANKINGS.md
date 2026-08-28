# 条目依赖排行

> 本文件由 `scripts/gen_entry_rankings.py` 生成，请勿手工编辑。

排名只覆盖 `verified` 非兼容桥条目。总分为四项百分位的加权和：加权直接引用 30%、
距离衰减的传递影响 30%、跨学科影响 20%、Lean 实际使用文件数 20%。
Lean 使用采用去注释后的主声明文本扫描；短名碰撞时该项记为 0，详细证据见 JSON。

## 综合榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 98.94 |
| 2 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 96.99 |
| 3 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 94.77 |
| 4 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 94.62 |
| 5 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 94.26 |
| 6 | `complex-analysis.integral.path` | 复路径与路径积分 | 94.18 |
| 7 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 93.95 |
| 8 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 92.96 |
| 9 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 92.82 |
| 10 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 92.29 |
| 11 | `analysis.series.basic` | 数项级数基础 | 91.85 |
| 12 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 91.80 |
| 13 | `abstract-algebra.group.def` | 子群判定与基本性质 | 91.75 |
| 14 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 91.69 |
| 15 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 91.37 |
| 16 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 91.12 |
| 17 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 90.89 |
| 18 | `real-analysis.riemann.def` | 黎曼积分定义 | 90.41 |
| 19 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 90.12 |
| 20 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 89.67 |
| 21 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 88.75 |
| 22 | `topology.fundamental-group.van-kampen-cover-subdivision` | 二开集覆盖下的有限带标签道路细分 | 88.71 |
| 23 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | 87.93 |
| 24 | `settheory.googology.bounded-halting` | 限定步数停机 | 87.90 |
| 25 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 87.53 |
| 26 | `functional-analysis.banach-alaoglu` | Banach–Alaoglu 定理 | 87.39 |
| 27 | `settheory.set.ext` | 外延性原理 | 87.27 |
| 28 | `linear-algebra.det.mul` | 积的行列式 | 87.03 |
| 29 | `analysis.mvt.lagrange` | 拉格朗日中值定理 | 86.81 |
| 30 | `linear-algebra.vector-space.def` | 向量空间定义 | 86.42 |

## 教材枢纽榜（加权直接引用）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 9.000 |
| 2 | `topology.space.def` | 拓扑空间与开闭集公理 | 6.000 |
| 3 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 5.250 |
| 4 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 5.000 |
| 5 | `analysis.derivative.chain-rule` | 链式法则 | 4.750 |
| 6 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 4.000 |
| 7 | `settheory.set.ext` | 外延性原理 | 4.000 |
| 8 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 3.833 |
| 9 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 3.833 |
| 10 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 3.750 |
| 11 | `complex-analysis.integral.path` | 复路径与路径积分 | 3.667 |
| 12 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 3.500 |
| 13 | `topology.fundamental-group.operations-standard` | 基本群的运算、复合次序与群律 | 3.500 |
| 14 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 3.333 |
| 15 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 3.167 |
| 16 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 3.000 |
| 17 | `number-theory.elementary.divisibility` | 带余除法、最大公因数与 Bézout 等式 | 3.000 |
| 18 | `probability.space.definition` | 概率空间与事件 | 3.000 |
| 19 | `settheory.googology.goodstein-ordinal-measure` | Goodstein 序数度量：把有限底数换成 ω | 3.000 |
| 20 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 2.917 |
| 21 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 2.833 |
| 22 | `analysis.series.basic` | 数项级数基础 | 2.750 |
| 23 | `settheory.cardinal.equinumerous` | 等势：用双射比较集合大小 | 2.750 |
| 24 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 2.583 |
| 25 | `abstract-algebra.group.def` | 子群判定与基本性质 | 2.500 |
| 26 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2.500 |
| 27 | `analysis.real.sup` | 确界原理 | 2.500 |
| 28 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 2.500 |
| 29 | `linear-algebra.vector-space.def` | 向量空间定义 | 2.500 |
| 30 | `probability.expectation.definition` | 期望与可积性 | 2.500 |

## 基础设施榜（传递影响）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 17.875 |
| 2 | `topology.space.def` | 拓扑空间与开闭集公理 | 17.125 |
| 3 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 16.719 |
| 4 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 16.250 |
| 5 | `topology.foundation.structure` | 拓扑、连续映射与同胚的正式承载 | 15.906 |
| 6 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 14.750 |
| 7 | `topology.foundation.constructions` | 诱导拓扑、子空间拓扑与积拓扑 | 14.719 |
| 8 | `linear-algebra.vector-space.def` | 向量空间定义 | 14.469 |
| 9 | `functional-analysis.operator.space` | 算子范数与连续线性算子空间 | 14.125 |
| 10 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 13.781 |
| 11 | `topology.homotopy.path-homotopy-standard` | 标准道路同伦与端点固定 | 13.719 |
| 12 | `analysis.sequence.definition` | 数列收敛的 ε-N 判据 | 13.531 |
| 13 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 13.312 |
| 14 | `settheory.set.ext` | 外延性原理 | 12.906 |
| 15 | `topology.homotopy.path-definition-foundation` | 道路与环路的正式承载 | 12.844 |
| 16 | `analysis.continuity.definition` | 连续性定义 | 12.281 |
| 17 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理 | 11.875 |
| 18 | `real-analysis.measure.def` | 测度公理 | 11.875 |
| 19 | `topology.normed-space.banach` | 范数收敛与Banach完备性 | 11.062 |
| 20 | `functional-analysis.hahn-banach.norming-functional` | 范数化泛函与对偶范数刻画 | 10.031 |
| 21 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 9.969 |
| 22 | `real-analysis.measure.sigma-algebra` | σ-代数公理 | 9.688 |
| 23 | `abstract-algebra.ring.ideal` | 理想的定义与基本运算 | 9.625 |
| 24 | `functional-analysis.bidual.reflexive` | 典范双对偶嵌入与自反性 | 9.531 |
| 25 | `topology.metric.def` | 度量空间与开球 | 9.188 |
| 26 | `real-analysis.measure.measurable-function` | 可测函数 | 9.125 |
| 27 | `functional-analysis.operator.continuous-linear-map` | 连续线性算子 | 9.062 |
| 28 | `analysis.derivative.const` | 常数/线性函数导数 | 8.906 |
| 29 | `analysis.derivative.chain-rule` | 链式法则 | 8.875 |
| 30 | `settheory.ordinal.order-type` | 良序与序型 | 8.562 |

## 跨学科桥梁榜

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `linear-algebra.vector-space.def` | 向量空间定义 | 3.000 |
| 2 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 2.750 |
| 3 | `settheory.set.ext` | 外延性原理 | 2.000 |
| 4 | `analysis.continuity.definition` | 连续性定义 | 1.750 |
| 5 | `probability.space.definition` | 概率空间与事件 | 1.750 |
| 6 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 1.750 |
| 7 | `topology.metric.def` | 度量空间与开球 | 1.750 |
| 8 | `linear-algebra.det.mul` | 积的行列式 | 1.500 |
| 9 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 1.500 |
| 10 | `analysis.continuity.uniform` | 一致连续 | 1.250 |
| 11 | `analysis.continuity.uniform-compact` | 紧集上连续 ⟹ 一致连续 | 1.250 |
| 12 | `analysis.derivative.const` | 常数/线性函数导数 | 1.250 |
| 13 | `analysis.special-functions.basic` | 初等特殊函数基础性质 | 1.250 |
| 14 | `complex-analysis.holomorphic.definition` | 复可微与集合上全纯 | 1.250 |
| 15 | `probability.expectation.definition` | 期望与可积性 | 1.250 |
| 16 | `real-analysis.measure.lintegral` | 非负积分（lintegral） | 1.250 |
| 17 | `real-analysis.riemann.cont-integrable` | 连续函数黎曼可积 | 1.250 |
| 18 | `real-analysis.riemann.def` | 黎曼积分定义 | 1.250 |
| 19 | `topology.foundation.real-line` | 标准实拓扑与单位区间的正式承载 | 1.250 |
| 20 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 1.250 |
| 21 | `topology.homotopy.piecewise-c1-path` | 分段 C1 道路及开集内正则替换 | 1.250 |
| 22 | `topology.metric.cauchy-complete` | Cauchy 列与完备空间 | 1.250 |
| 23 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 1.000 |
| 24 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 1.000 |
| 25 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 1.000 |
| 26 | `abstract-algebra.field.separable-normal` | 可分多项式、可分扩张与正规扩张 | 1.000 |
| 27 | `abstract-algebra.field.splitting` | 多项式的分裂域、存在性与唯一到同构 | 1.000 |
| 28 | `abstract-algebra.group.def` | 子群判定与基本性质 | 1.000 |
| 29 | `abstract-algebra.poly.def` | 多项式的有限支撑系数语义与 Lean 承载 | 1.000 |
| 30 | `abstract-algebra.poly.factorization` | 多项式唯一分解与根重数 | 1.000 |

## 形式化复用榜（Lean 调用文件数）

| # | 条目 | 标题 | 指标 |
|---:|---|---|---:|
| 1 | `topology.homotopy.definition-foundation` | 同伦与相对端点道路同伦 | 33 |
| 2 | `topology.fundamental-group.van-kampen-cover-subdivision` | 二开集覆盖下的有限带标签道路细分 | 21 |
| 3 | `topology.homotopy.unit-interval-mesh` | 单位区间的一致有限网格 | 21 |
| 4 | `topology.fundamental-group.van-kampen-surjectivity` | 二开集 van Kampen 规范同态的满射 | 18 |
| 5 | `topology.fundamental-group.path-corrected-loop` | 道路段的基点修正环路与有限望远镜公式 | 15 |
| 6 | `topology.homotopy.homotopy-square-grid` | 道路同伦方形与一致网格边 | 15 |
| 7 | `topology.fundamental-group.van-kampen-letter-word` | van Kampen Pushout 字母词与拼接环路 | 13 |
| 8 | `linear-algebra.vector-space.span` | 生成子空间 | 12 |
| 9 | `settheory.ordinal.exponentiation` | 序数幂的后继递推 | 11 |
| 10 | `functional-analysis.compact-operator.composition` | 紧算子的理想性质与范数极限 | 10 |
| 11 | `settheory.ordinal.addition` | 序数加法不交换 | 10 |
| 12 | `abstract-algebra.field.extension` | 域扩张、生成中间域、代数元与最小多项式 | 9 |
| 13 | `settheory.ordinal.multiplication` | 序数乘法不交换 | 9 |
| 14 | `topology.normed-space.def` | 赋范线性空间与Banach空间 | 9 |
| 15 | `topology.fundamental-group.van-kampen-vertex-potential` | van Kampen 网格顶点的 connector potential | 7 |
| 16 | `functional-analysis.subspace.annihilator-closure` | 连续零化子、双零化子与子空间闭包 | 5 |
| 17 | `topology.fundamental-group.van-kampen-row-anchoring` | van Kampen 单行 frames 的右锚定 | 5 |
| 18 | `topology.homotopy.path-cod-restrict` | 道路到子空间的余域限制 | 5 |
| 19 | `abstract-algebra.field.degree` | 域扩张次数、有限扩张与塔式公式 | 4 |
| 20 | `abstract-algebra.field.galois-definitions` | Galois 扩张、显式自同构群与固定域 | 4 |
| 21 | `complex-analysis.integral.path` | 复路径与路径积分 | 4 |
| 22 | `functional-analysis.fredholm.alternative` | 恒等算子的紧扰动 | 4 |
| 23 | `real-analysis.riemann.eq-lebesgue` | 黎曼积分值 = Lebesgue 区间积分 | 4 |
| 24 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约元、素元与最大公因子 | 3 |
| 25 | `abstract-algebra.ring.quotient` | 商环及其泛性质 | 3 |
| 26 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 弱星闭性判据 | 3 |
| 27 | `linear-algebra.det.mul` | 积的行列式 | 3 |
| 28 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵与酉矩阵 | 3 |
| 29 | `abstract-algebra.field.galois-correspondence` | 有限 Galois 基本对应 | 2 |
| 30 | `abstract-algebra.ring.def` | 环、单位、子环与环同态 | 2 |
