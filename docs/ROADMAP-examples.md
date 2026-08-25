# Sandrone's Library — Examples 跨学科例证路线图

## 定位

Examples 负责把各学科的教材定义和主定理变成可看、可算、可辨错的具体对象。理论学科回答
“为什么成立”，Examples 进一步回答“拿一个什么东西来看”“怎么算出来”“少一个条件会怎样”。

负责人执行 `docs/roles/EXAMPLES-MAINTAINER-ROLE.md`。理论模块不得依赖 Examples。

## 覆盖状态

- `covered`：命名对象、基本性质、正例／计算，以及适用时的反例均有 Lean 定理和 Examples Entry。
- `partial`：已有可编译例子，但缺 Entry、文档、覆盖映射或必要反例。
- `missing`：重要知识点尚无正式例子。
- `blocked`：理论定义层或所需公开接口尚未验收，Examples 不自行绕过。

## E0 建制与存量转正 🚧

| 批次 | 范围 | 当前状态 | 出口 |
|---|---|---|---|
| E0.1 | Examples ROLE、路线图、目录依赖规则 | covered | Main 文件建立并登记学科 |
| E0.2 | 坐标积分与球体矩 | partial | 为球体体积、质量、重心、转动惯量补 Examples Entry 与课程文档 |
| E0.3 | Green/Gauss/Stokes 具体区域 | partial | 为三角形、圆盘、立方体和正方形例子补 Entry，并检查是否需要定向反例 |
| E0.4 | 既有 `analysis.integral.examples`、Taylor examples 归档 | partial | 保留原理论 Entry 或迁移为 Examples Entry 的影响审计，不破坏下游 |

## E1 基础分析巡检 🔒

| 例子家族 | 重点覆盖 |
|---|---|
| `examples.analysis.sequence` | 收敛、发散、Cauchy、子列、liminf/limsup；给出“有界不必收敛”等反例 |
| `examples.analysis.function-limit` | 双侧／单侧／无穷极限计算；区分不存在与无穷极限 |
| `examples.analysis.continuity` | 分段函数、介值、紧区间最值、一致连续；区分连续与一致连续 |
| `examples.analysis.derivative` | 多项式、初等函数、链式法则；连续不可导、导数不连续等标准反例 |
| `examples.analysis.series` | 几何、调和、交错、绝对／条件收敛、重排与 Cauchy 乘积 |
| `examples.analysis.riemann` | 可积计算、可积不连续、稠密不连续反例及 FTC/换元/分部积分 |

## E2 线性代数、抽象代数与数论巡检 🔒

| 例子家族 | 重点覆盖 |
|---|---|
| `examples.linear-algebra` | 线性相关／无关、基与坐标、核像、秩、特征值、对角化及失败反例 |
| `examples.abstract-algebra.group` | 子群、商群、同态核像、循环群、非交换群与逆命题反例 |
| `examples.abstract-algebra.ring` | 理想、商环、整环／域、Euclidean/PID/UFD、CRT、局部化的具体计算 |
| `examples.number-theory` | gcd、同余、CRT、Euler φ、Fermat、连分数、Pell 方程的显式数值例 |

## E3 拓扑、实分析与复分析巡检 🔒

| 例子家族 | 重点覆盖 |
|---|---|
| `examples.topology` | 开闭集、子空间、紧致／连通、商空间、同伦；分离相近概念的反例 |
| `examples.real-analysis` | 可测／不可测边界、a.e.、收敛定理、乘积测度、`Lᵖ`、RN 与微分定理 |
| `examples.complex-analysis` | 全纯函数、路径积分、Cauchy 公式、Laurent 展开、奇点与残数计算 |

## E4 Analysis 第三学期巡检 🔒

| 例子家族 | 重点覆盖 |
|---|---|
| `examples.analysis.function-family` | 点态但非一致收敛、极限与求导不可交换等反例 |
| `examples.analysis.parameter-integral` | 含参积分、积分号下求导、Gamma/Beta 型计算 |
| `examples.analysis.fourier-series` | 典型周期函数的系数、部分和、跳跃点平均、Parseval 计算 |
| `examples.analysis.fourier-transform` | Gaussian、平移、缩放、微分和卷积的初步计算 |

## 持续覆盖门

每个学科批次进入 Main 时，Main 检查其重要知识点是否已有 `covered` Examples 映射：

- 已覆盖：登记复用关系；
- 未覆盖但不阻塞理论：加入本路线图最近一轮巡视；
- 该例子本身是课程出口的一部分：与理论批次共同开门；
- 理论接口不足：标记 `blocked` 并向原学科提出最小接口需求。

Examples 的缺口通常不打回数学正确的理论提交，但 Main 必须把缺口排入巡视，不能让“以后补例子”
成为永久状态。
