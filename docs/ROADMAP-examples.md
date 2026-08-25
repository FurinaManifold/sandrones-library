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

## E1 集合、映射、基数与序数

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E1.1 集合运算 | `examples.settheory.set-operations` | 两个有限集合逐元素计算并、交、差、补；验证 De Morgan | `A ∪ B = A ∪ C` 不能推出 `B=C` | 集合基础 |
| E1.2 映射性质 | `examples.settheory.functions` | 线性函数、平方函数的像／原像、单射／满射／双射 | 单射不必满射、满射不必单射；像不保持交的反例 | 映射基础 |
| E1.3 等价关系与商 | `examples.settheory.quotients` | 模 `n` 同余类和商映射；显式判定两个代表元同类 | 不同代表元可给同一商元素 | 商集基础 |
| E1.4 可数性 | `examples.settheory.countability` | `ℕ×ℕ` 配对、整数枚举、两个可数集之并 | 无限集不必不可数；幂集严格更大的有限原型 | 基数基础 |
| E1.5 基数算术 | `examples.settheory.cardinal-arithmetic` | 有限基数加乘幂；可数集与有限集运算 | 基数相等不等于集合相等；无限基数算术不能照搬自然数消去律 | ST2 |
| E1.6 序数基础 | `examples.settheory.ordinals` | `0,1,2,ω,ω+1` 的序关系、后继／极限辨析 | `1+ω=ω` 但 `ω+1≠ω`，展示序数加法不交换 | ST1 |
| E1.7 序数算术 | `examples.settheory.ordinal-arithmetic` | 有限序数、`ω` 的加乘幂和 Cantor 正规形小例 | 加法与乘法不交换、左消去失败的具体反例 | 序数运算主线 |
| E1.8 递归与增长 | `examples.settheory.recursion-growth` | 小输入计算原始递归、Ackermann、Goodstein／Hydra 的前若干步 | “前几步下降”不等于全程终止；计算样例不得冒充一般定理 | ST3 |

## E2 一元分析基础

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E2.1 实数完备性 | `examples.analysis.real-completeness` | 有界集合的上确界、单调序列极限、闭区间套 | 有理数中的 Cauchy 序列可没有有理极限 | 实数与完备性 |
| E2.2 数列极限 | `examples.analysis.sequences` | 常数、`1/n`、几何序列；显式子列与 liminf/limsup | 有界不必收敛；有收敛子列不必收敛 | 数列主线 |
| E2.3 函数极限 | `examples.analysis.function-limits` | 多项式、有理函数、`sin x/x` 与无穷远极限 | 左右极限不同导致双侧极限不存在 | 函数极限 |
| E2.4 连续性 | `examples.analysis.continuity` | 分段连续函数、介值取根、闭区间最值 | 连续不必一致连续；紧性假设不可省略 | 连续主线 |
| E2.5 导数与中值 | `examples.analysis.derivatives` | 多项式、复合、反函数、中值点计算 | 连续不必可导；导数为零条件缺失时不能推出常值 | 导数与 MVT |
| E2.6 Taylor 与渐近 | `examples.analysis.taylor-asymptotic` | `exp/sin/cos/log` 低阶展开和误差界 | 截断多项式不是函数恒等式；局部展开不能无条件用于全局 | Taylor 主线 |
| E2.7 数项级数 | `examples.analysis.series` | 几何、调和、交错、望远镜、Cauchy 乘积 | 收敛不必绝对收敛；条件收敛重排改变和 | 级数主线 |
| E2.8 幂级数 | `examples.analysis.power-series` | 几何幂级数、`exp/sin/cos`、收敛半径和端点 | 半径信息不能决定端点收敛 | 幂级数主线 |
| E2.9 Riemann 积分 | `examples.analysis.riemann-integral` | 幂、指数、三角函数、换元、分部积分 | 有界不必 Riemann 可积；可积不必连续 | Riemann 主线 |

## E3 多元分析与向量分析

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E3.1 多元微分 | `examples.analysis.multivariable-derivative` | 梯度、Jacobian、Hessian、方向导数和二阶 Taylor | 各方向导数存在不必 Fréchet 可微 | 多元微分 |
| E3.2 反函数与隐函数 | `examples.analysis.inverse-implicit` | 二维局部逆和隐式曲线导数 | Jacobian 奇异时定理不保证局部逆 | IFT |
| E3.3 多重积分与坐标 | `examples.analysis.coordinate-integrals` | 矩形、圆盘、球体的体积、质量、重心和惯量 | 忽略 Jacobian 得到错误数值的精确辨析 | 换元与坐标积分 |
| E3.4 曲线与曲面 | `examples.analysis.curves-surfaces` | 圆周弧长、球面面积、第一型积分 | 非正则参数化不能直接套用公式 | 参数化接口 |
| E3.5 微分形式 | `examples.analysis.differential-forms` | 低维楔积、外微分、拉回的坐标计算 | 楔积不交换；`dω=0` 的局部／全局边界 | 形式定义层 |
| E3.6 Green/Gauss/Stokes | `examples.analysis.integral-theorems` | 三角形、圆盘、立方体、球面和正方形上的两侧计算 | 定向反转改变符号；非闭边界不能误套闭曲面结论 | 三大公式 |

## E4 Analysis 第三学期

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E4.1 函数列与函数族 | `examples.analysis.function-families` | 一致收敛判据、M 判别法、逐项积分 | 点态但非一致收敛；极限与求导不可交换 | AN3-1--4 |
| E4.2 含参积分 | `examples.analysis.parameter-integrals` | 连续依参数、积分号下求导、Gamma/Beta 型计算 | 缺少一致／支配条件时交换失败 | AN3-5--9 |
| E4.3 正交系 | `examples.analysis.orthogonal-systems` | 三角系正交、Fourier 系数和 Bessel 不等式数值例 | 非正交展开不能直接套系数公式 | AN3-10 |
| E4.4 Fourier 级数 | `examples.analysis.fourier-series` | 方波、锯齿波、绝对值函数的系数和部分和 | 跳跃点收敛到平均而非任一侧函数值 | AN3-11--14 |
| E4.5 Parseval 应用 | `examples.analysis.fourier-parseval` | 由 Parseval 计算一个经典数项级数 | 点态收敛与均方收敛不得混称 | AN3-14 |
| E4.6 Fourier 变换 | `examples.analysis.fourier-transform` | Gaussian、平移、缩放、微分和卷积 | 归一化不同导致常数不同；非 `L¹` 函数不直接套初步定义 | AN3-15 |

## E5 线性代数

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E5.1 向量空间与基 | `examples.linear-algebra.bases` | `ℝ²/ℝ³` 的张成、线性无关、换基坐标 | 生成集不必是基；不同基给不同坐标 | L1-L2 |
| E5.2 线性映射 | `examples.linear-algebra.linear-maps` | 具体矩阵的核、像、秩和 rank-nullity | 单射与满射在无限维／异维时不可混同 | L3 |
| E5.3 行列式与方程组 | `examples.linear-algebra.determinants` | `2×2/3×3` 行列式、逆矩阵、Cramer | 行列式零时 Cramer 不适用 | L4 |
| E5.4 特征理论 | `examples.linear-algebra.eigenvalues` | 特征多项式、特征向量和对角化 | 有特征值不必可对角化；重根不保证足够特征向量 | L5 |
| E5.5 内积与正交 | `examples.linear-algebra.inner-product` | Gram--Schmidt、正交投影、最小二乘 | 代数直和不必正交直和 | L6 |
| E5.6 矩阵分解 | `examples.linear-algebra.decompositions` | QR、Cholesky、SVD、伪逆的小矩阵计算 | Cholesky 的正定条件、可逆矩阵与伪逆的边界 | L7 |
| E5.7 张量与外代数 | `examples.linear-algebra.exterior` | 对偶基、楔积、面积／体积行列式 | `v∧v=0`、交换次序变号 | 张量外代数 |

## E6 抽象代数

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E6.1 群与子群 | `examples.abstract-algebra.groups` | `ℤ/nℤ`、置换群、小循环群的运算和生成元 | 群不必交换；子集对运算封闭仍需检查逆元／单位元 | A1 |
| E6.2 陪集与商群 | `examples.abstract-algebra.quotient-groups` | `ℤ/ nℤ` 陪集、指数二正规性和商映射 | 非正规子群的陪集不能组成所需商群 | A1 |
| E6.3 同态与作用 | `examples.abstract-algebra.hom-actions` | 核、像、第一同构定理和轨道稳定子计算 | 同态不必单射／满射；作用不必忠实／传递 | A1 |
| E6.4 环、理想与商 | `examples.abstract-algebra.rings-ideals` | `ℤ` 的理想、`ℤ/nℤ` 商环、素／极大理想 | 整环不必是域；素理想与极大理想逆向失败例 | A2 |
| E6.5 整除与分解 | `examples.abstract-algebra.factorization` | Euclidean 算法、gcd、不可约分解、PID/UFD 链 | 不可约与素元在一般整环不必等价 | A2 |
| E6.6 CRT 与局部化 | `examples.abstract-algebra.crt-localization` | 小模数 CRT、整数局部化为有理分式的计算 | 含零因子时分式判等不能只交叉相乘 | A2 |
| E6.7 多项式 | `examples.abstract-algebra.polynomials` | 除法、因式分解、重根、不可约判别 | 在不同系数域上不可约性可改变 | A3 |

## E7 拓扑学

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E7.1 拓扑与邻域 | `examples.topology.spaces` | 离散、不可分辨、实线拓扑的开闭集和邻域 | 开集不必闭、闭集不必开；同一集合可有不同拓扑 | T1 |
| E7.2 连续与同胚 | `examples.topology.continuity-homeomorphism` | 具体连续映射和区间同胚 | 连续双射不必同胚（缺逆连续条件） | T1 |
| E7.3 子空间与商 | `examples.topology.subspace-quotient` | 区间／圆周的子空间和端点粘合 | 子空间开集不必在母空间中开 | T2 |
| E7.4 紧致与分离 | `examples.topology.compactness-separation` | 有限空间、闭区间、有限积 | 有界不必紧致（非欧氏／非闭情形）；紧集闭需要分离条件 | T2-T3 |
| E7.5 连通与道路 | `examples.topology.connected-path` | 标准单位区间上的常值、线性道路，圆周和凸集道路，以及 `Path.symm`/`Path.trans` 的逐点计算 | 连通不必道路连通；固定二倍速拼接的单位律、结合律不应误写成严格道路等式 | T3-T4 |
| E7.6 度量与完备化 | `examples.topology.metric-completion` | `ℚ` 的 Cauchy 序列及实数完备化直观接口 | 有界不必完全；完全不必紧致 | T3 |
| E7.7 同伦与基本群 | `examples.topology.homotopy` | 常值／凸集收缩、圆周道路、逆向和拼接 | 同伦等价不等于同胚 | T4 |

## E8 现代实分析

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E8.1 σ-代数与测度 | `examples.real-analysis.measures` | 有限集计数测度、Dirac、Lebesgue 区间测度 | 可数可加不能降成只检查有限可加 | R1 |
| E8.2 可测函数与积分 | `examples.real-analysis.measurable-integral` | 指示函数、简单函数、单调逼近和显式积分 | 几乎处处相等不等于逐点相等 | R2 |
| E8.3 收敛定理 | `examples.real-analysis.convergence-theorems` | MCT、Fatou、DCT 的具体函数列 | 去掉单调／支配条件时交换极限与积分失败 | R2 |
| E8.4 乘积测度 | `examples.real-analysis.product-measure` | 矩形、可分离函数、Tonelli/Fubini 换序 | 非绝对可积时 Fubini 换序可失败 | R4 |
| E8.5 `Lᵖ` | `examples.real-analysis.lp` | 指示函数范数、Hölder/Minkowski 等号例 | `Lᵖ` 函数是 a.e. 等价类；不同 `p` 的包含依赖测度空间 | R4 |
| E8.6 有符号／复测度与 RN | `examples.real-analysis.signed-rn` | 有限离散空间 Jordan 分解、密度与 RN 导数 | 绝对连续与互奇异的区分 | RA-F1-F2 |
| E8.7 微分定理与 a.e. FTC | `examples.real-analysis.differentiation-ftc` | 阶梯／绝对连续函数的 Lebesgue 点和积分表示 | a.e. 导数结论不是逐点结论 | RA-F3-F6 |

## E9 复分析

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E9.1 复可微与全纯 | `examples.complex-analysis.holomorphic` | 多项式、指数、三角函数和局部对数 | 实可微不必复可微；CR 方程缺实可微条件不够 | C1 |
| E9.2 路径积分 | `examples.complex-analysis.path-integrals` | 线段、圆周、反向和拼接积分 | 路径无关需要原函数／拓扑条件 | C2 |
| E9.3 Cauchy 理论 | `examples.complex-analysis.cauchy` | 圆周上的 Cauchy 公式和导数计算 | 奇点落在轮廓内外导致不同结果 | C2 |
| E9.4 级数与奇点 | `examples.complex-analysis.laurent-singularities` | 几何级数在内外环域的 Laurent 展开、三类孤立奇点 | 同一函数在不同环域展开不同 | C3 |
| E9.5 残数 | `examples.complex-analysis.residues` | 简单极点、高阶极点和一个实积分 | 漏计轮廓内极点或方向符号的反例辨析 | C3 |
| E9.6 辐角原理 | `examples.complex-analysis.argument-principle` | 低次多项式零点计数和 Rouché 比较 | 边界上有零点时不能直接套用 | C3 |

## E10 初等数论

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E10.1 整除与 gcd | `examples.number-theory.divisibility` | Euclidean 算法、Bézout 系数、线性丢番图方程 | gcd 条件不满足时方程无解 | N1 |
| E10.2 同余与 CRT | `examples.number-theory.congruence-crt` | 余数运算、两个／多个模数 CRT 的显式解 | 模数不互素时存在性／唯一模积可失败 | N1 |
| E10.3 Euler 与 Fermat | `examples.number-theory.euler-fermat` | 小整数 φ 值、模幂降阶和素数模计算 | 合数模数不能无条件套 Fermat 素数版 | N1 |
| E10.4 素数与分解 | `examples.number-theory.primes-factorization` | 试除、唯一分解和素数无限性的有限见证链 | 通过若干底数测试不等于已经证明素数 | N1 |
| E10.5 二次剩余 | `examples.number-theory.quadratic-residues` | Legendre/Jacobi 符号和二次互反律计算 | Jacobi 符号为 `1` 不保证是二次剩余 | N1 |
| E10.6 连分数 | `examples.number-theory.continued-fractions` | 有理数展开、无理数前若干收敛子和误差 | 任意好近似不必是收敛子，需满足判据 | N1 |
| E10.7 Pell 方程 | `examples.number-theory.pell` | `d=2,3,5` 的基本解、合成和正解序列 | 平方 `d` 不适用正 Pell 存在定理；负 Pell 不总可解 | N1 |

## E11 泛函分析

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E11.1 连续线性算子与算子范数 | `examples.functional-analysis.operators` | 恒等、零、坐标投影的算子范数与全局界 | 一般线性映射不自动连续；界常数不唯一而算子范数最小 | F1 |
| E11.2 Banach 值级数 | `examples.functional-analysis.series` | 有限维向量几何级数及部分和收敛 | 条件可和不等于范数级数可和；完备性不可静默省略 | F1 |
| E11.3 闭子空间商 | `examples.functional-analysis.quotients` | 有限维子空间商、商范数距离计算 | 非闭子空间会出现非零陪集范数为零的边界 | F1 |
| E11.4 Banach 三大定理 | `examples.functional-analysis.banach-theorems` | 具体算子族的一致有界、开映射与有界逆应用 | 逐点有界与一致有界不能在缺 Baire 条件时混同 | F2 |
| E11.5 Hilbert 空间 | `examples.functional-analysis.hilbert` | 正交投影、Riesz 表示、矩阵伴随、有限正交基 Parseval 与正交/酉变换计算 | 投影需要闭性；正交规范族不稠密时只有 Bessel 不等式；等距线性映射不满时不是酉算子 | F3 |
| E11.6 Hahn–Banach、零化子与弱拓扑 | `examples.functional-analysis.duality-weak` | 有限维范数化泛函和凸集分离、坐标子空间零化子、坐标泛函族的弱／弱星收敛 | 代数零化子不等于连续零化子；共同零点一般恢复闭包而非原子空间；范数、弱与弱星收敛不可混同 | F2+/F4 |
| E11.7 紧算子与 Fredholm | `examples.functional-analysis.compact-fredholm` | 有限秩算子、对角紧算子、核／余核和指数计算 | 有界算子不必紧；紧算子不必有限秩；闭值域不可省略 | F5 |
| E11.8 有界谱理论 | `examples.functional-analysis.spectrum` | 有限维矩阵、移位和紧对角算子的谱／预解计算 | 无限维谱不等于特征值集合；谱半径不必等于算子范数 | F6 |
| E11.9 无界算子 | `examples.functional-analysis.unbounded-operators` | 微分／乘法算子的定义域、图、伴随和预解例 | 同一公式配不同定义域会给不同算子；对称不自动自伴 | F7 |
| E11.10 算子半群 | `examples.functional-analysis.semigroups` | 平移、乘法和热半群的轨道及生成元计算 | 每点连续不能代替强连续；生成元通常不是有界算子 | F8 |
| E11.11 半范数与 Fréchet 空间 | `examples.advanced-functional-analysis.frechet` | `ℝⁿ` 坐标半范数、`C∞` 导数半范数及可数族生成度量 | 单个半范数可不分离点；Fréchet 不等于“具有某个完备范数” | AFA1-AFA2 |
| E11.12 桶、Bornological 与 Montel | `examples.advanced-functional-analysis.space-properties` | 标准 Fréchet、LF 和 Montel 空间的性质核对 | 完备不自动 Montel；有界集概念不能静默换成范数有界 | AFA3-AFA4 |
| E11.13 测试函数与分布 | `examples.advanced-functional-analysis.distributions` | Dirac、函数诱导分布、导数和 Fourier 变换 | 点值对一般 `L¹` 函数无意义；分布收敛不等于逐点收敛 | AFA5 |

## E12 偏微分方程

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E12.1 四类线性方程 | `examples.pde.linear-models` | 输运平移、Laplace/Poisson 核、Gaussian 热核和 d’Alembert 公式 | 热方程无限传播与波方程有限传播不可混同 | PDE1 |
| E12.2 非线性一阶方程 | `examples.pde.characteristics` | Burgers 特征线、激波时间和 Rankine–Hugoniot 速度 | 特征线交叉后经典解失效；弱解不唯一 | PDE2 |
| E12.3 表示方法 | `examples.pde.representation` | 区间分离变量、热方程相似解和 Fourier 变换解 | 形式级数／变换表达不自动满足收敛和边界条件 | PDE3 |
| E12.4 Sobolev 空间 | `examples.pde.sobolev` | 分段函数弱导数、磨光、Poincaré 和一维迹计算 | 弱可微不等于经典可微；临界指数不能直接套非临界嵌入 | PDE4 |
| E12.5 椭圆方程 | `examples.pde.elliptic` | 一维弱 Dirichlet 问题、能量极小化和特征值 | 弱解正则性需要系数与边界条件；最大值原理有符号门 | PDE5 |
| E12.6 线性演化 | `examples.pde.evolution` | Galerkin 有限维逼近、热／波能量估计 | 能量界只给弱紧性时不能声称强收敛 | PDE6 |
| E12.7 变分与非变分 | `examples.pde.nonlinear-methods` | Euler–Lagrange、障碍问题和上下解迭代 | 临界点不必是极小值；缺凸性时唯一性可失败 | PDE7-PDE8 |
| E12.8 黏性解与守恒律 | `examples.pde.viscosity-entropy` | Eikonal/Hopf–Lax、Burgers 熵解和 Riemann 问题 | 黏性解与分布解是不同框架；Rankine–Hugoniot 不足以选熵解 | PDE9-PDE10 |
| E12.9 非线性波 | `examples.pde.nonlinear-wave` | 半线性波能量、局部迭代和爆破型 ODE 比较 | 局部解不自动整体；守恒能量不自动排除所有爆破 | PDE10 |

## E13 后续学科自动扩展

概率、统计、泛函分析、微分几何、ODE/PDE、代数拓扑等学科首次进入 main 时，Main 按相同模板在
本文件新增一个项目组。最低要求仍是“标准对象 + 计算／构造 + 必要反例”，不得只把理论文档中的
一句例子复制过来。

## 建议实施优先级

1. **P0：存量转正**：E0.2--E0.4，先让既有 Examples 资产进入正式 Entry 体系。
2. **P0：课程辨析高收益项**：E2.2、E2.4、E2.7、E3.1、E5.4、E7.2、E8.3、E10.2。
3. **P1：可计算主线**：E2.3、E2.5、E2.9、E3.3、E5.2--E5.3、E6.5--E6.6、E10 全线。
4. **P1：当前关键依赖**：T4 开发同步推进 E7.5/E7.7；Analysis 第三学期启动时同步推进 E4。
5. **P2：高阶与大型反例**：需要复杂商空间、不可测集或选择公理的反例，先用 `blocked` 记录，
   等理论接口成熟后再做，不以 Mathlib 成品包装抢跑。

## 持续覆盖门

每个学科批次进入 Main 时，Main 检查其重要知识点是否已有 `covered` Examples 映射：

- 已覆盖：登记复用关系；
- 未覆盖但不阻塞理论：加入本路线图最近一轮巡视；
- 该例子本身是课程出口的一部分：与理论批次共同开门；
- 理论接口不足：标记 `blocked` 并向原学科提出最小接口需求。

Examples 的缺口通常不打回数学正确的理论提交，但 Main 必须把缺口排入巡视，不能让“以后补例子”
成为永久状态。
