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
| E1.8 递归与增长 | `examples.settheory.recursion-growth` | 小输入计算原始递归、Ackermann、规范 Goodstein 状态／`B^(B^k)` 借位、Hydra 的前若干步，并演示固定机器代码的燃料检查 | “前几步下降”不等于全程终止；有限燃料返回假不等于永不停机；条件式换底兼容性不得冒充完整 Goodstein 下降 | ST3 |

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
| E6.8 域扩张 | `examples.abstract-algebra.field-extensions` | 有理数嵌入实数、二次代数元、`X²-2` 最小多项式及单扩张 | 域扩张必须固定嵌入；超越元没有最小多项式；子域集合不自动包含指定基域像 | A3.5 |
| E6.9 扩张次数 | `examples.abstract-algebra.extension-degree` | 二次扩张的显式二元基、坐标唯一性、恒等扩张次数一与简单塔次数乘法 | 次数依赖指定嵌入；无限扩张不能编码成次数零；塔式公式必须核对两层基 | A3.6 |
| E6.10 分裂域 | `examples.abstract-algebra.splitting-fields` | 二次多项式在实数／复数上的根集、一次因子分解及最小分裂扩域 | 零多项式虽满足 Mathlib 分裂约定却没有本条意义的分裂域；唯一性只到基域上同构 | A3.7 |
| E6.11 可分与正规扩张 | `examples.abstract-algebra.separable-normal` | 有限域扩张可分、二次不可约多项式的导数判据及分裂域正规性 | 不完美域上不可约多项式可有零导数；有限扩张不自动可分 | A3.8 |
| E6.12 有限 Galois 对应计算 | `examples.abstract-algebra.galois-correspondence` | 二次扩张、有限域与低次多项式分裂域的自同构群、固定域和中间域—子群对应 | 只列出若干自同构不等于证明群已穷尽；固定域计算必须验证逐点固定与恢复两向 | A3.9b |

## E7 拓扑学

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E7.1 拓扑与邻域 | `examples.topology.spaces` | 离散、不可分辨、实线拓扑的开闭集和邻域 | 开集不必闭、闭集不必开；同一集合可有不同拓扑 | T1 |
| E7.2 连续与同胚 | `examples.topology.continuity-homeomorphism` | 具体连续映射和区间同胚 | 连续双射不必同胚（缺逆连续条件） | T1 |
| E7.3 子空间与商 | `examples.topology.subspace-quotient` | 区间／圆周的子空间和端点粘合 | 子空间开集不必在母空间中开 | T2 |
| E7.4 紧致与分离 | `examples.topology.compactness-separation` | 有限空间、闭区间、有限积 | 有界不必紧致（非欧氏／非闭情形）；紧集闭需要分离条件 | T2-T3 |
| E7.5 连通与道路 | `examples.topology.connected-path` | 标准单位区间上的常值、线性道路，圆周和凸集道路，以及 `Path.symm`/`Path.trans` 的逐点计算 | 连通不必道路连通；固定二倍速拼接的单位律、结合律不应误写成严格道路等式 | T3-T4 |
| E7.6 同伦与同伦等价 | `examples.topology.homotopy-equivalence` | 区间缩并、同胚诱导同伦等价、双侧同伦逆的两个方向 | 同伦等价不要求双射或严格互逆；相对同伦必须全程固定指定子集 | T4-H1-T4-E |
| E7.6 度量与完备化 | `examples.topology.metric-completion` | `ℚ` 的 Cauchy 序列及实数完备化直观接口 | 有界不必完全；完全不必紧致 | T3 |
| E7.7 同伦与基本群 | `examples.topology.homotopy` | 常值／凸集收缩、圆周道路、逆向和拼接 | 同伦等价不等于同胚 | T4 |
| E7.8 道路同伦商 | `examples.topology.path-homotopy-quotient` | 两条重参数化道路落入同一商类，并展示代表满射 | 商类相等不等于道路函数严格相等；代表没有规范唯一性 | T4-F1a |
| E7.9 基本群标准承载 | `examples.topology.fundamental-group-carrier` | 由具体基点环路构造商类并在 `toPath/fromPath` 间往返 | 群胚态射只在端点匹配时复合；群乘法次序不能按路径书写顺序猜测 | T4-F1b |
| E7.10 基本群运算 | `examples.topology.fundamental-group-operations` | 恒等环路、逆环路和两个代表环路的乘法公式 | `p*q` 对应先走 `q` 再走 `p`；原始道路拼接不严格满足群律 | T4-F2a |
| E7.11 基本群计算 | `examples.topology.fundamental-group-computations` | 单连通／凸集的平凡基本群、圆周绕数，以及两个具体空间积上的逐坐标环路 | 基本群依赖基点；二元积公式不能直接外推到任意无限积；圆周结果不能只靠最终同构黑箱展示 | T4-F2c1–F2c3 |
| E7.12 van Kampen 道路细分 | `examples.topology.van-kampen-subdivision` | 取一条跨越两个重叠开集的具体道路，展示有限子道路标签及一次标签切换顶点属于交集 | 道路逐点落在覆盖并中不等于整条道路落在单个成员；有限细分本身不等于 van Kampen 同构 | AT1-VK1 |
| E7.13 van Kampen 满射词 | `examples.topology.van-kampen-surjectivity` | 对一个二开集覆盖和具体基环路展示修正分段环路及其 `PushoutI` 原像词 | 规范同态满射不等于单射；列出生成词不等于证明关系已经穷尽 | AT1-VK2 |
| E7.14 子群对应的 canonical covering | `examples.topology.covering-subgroup-charts` | 平凡子群与全基本群在标准道路连通空间上的 fiber、局部 chart 和投影行为 | chart 的离散索引不是另一套 fiber 定义；从子群构造 cover 不等于已经证明分类双射 | AT2-C5c |

## E8 现代实分析

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E8.1 σ-代数与测度 | `examples.real-analysis.measures` | 有限集计数测度、Dirac、Lebesgue 区间测度 | 可数可加不能降成只检查有限可加 | R1 |
| E8.2 可测函数与积分 | `examples.real-analysis.measurable-integral` | 指示函数、简单函数、单调逼近和显式积分 | 几乎处处相等不等于逐点相等 | R2 |
| E8.3 收敛定理 | `examples.real-analysis.convergence-theorems` | MCT、Fatou、DCT 的具体函数列 | 去掉单调／支配条件时交换极限与积分失败 | R2 |
| E8.4 乘积测度 | `examples.real-analysis.product-measure` | 矩形、可分离函数、Tonelli/Fubini 换序 | 非绝对可积时 Fubini 换序可失败 | R4 |
| E8.5 `Lᵖ` | `examples.real-analysis.lp` | 指示函数范数、Hölder/Minkowski 等号例 | `Lᵖ` 函数是 a.e. 等价类；不同 `p` 的包含依赖测度空间 | R4 |
| E8.6 有符号／复测度与 RN | `examples.real-analysis.signed-rn` | 有限离散空间 Jordan 分解、正／负／全变差的具体计算、复测度实部虚部分解；密度与 RN 导数（属 RA-F2） | 绝对连续与互奇异的区分；第一预解式类的符号陷阱不适用但要看住：`totalVariation` 是测度而非数，谱点上 `resolvent` 为 0 类的边界对应有符号测度在零变差集上取零 | RA-F1 ✅（RA-F2 未开） |
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

复分析负责人只开发 Laurent、残数、轮廓估计等一般理论接口；本节所有具体圆周计算、实积分和
低次多项式零点计数均由 Examples 负责人领取。历史理论目录中的已验证实积分 Entry 作为可复用
资产保留，新增题目不得继续写入 `ComplexAnalysis/**`。

## E9P 概率论与统计推断

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E9P.1 概率空间与随机变量 | `examples.probability.foundations` | 有限样本空间、Bernoulli／离散分布、推前分布与期望 | 可测函数条件不能省略；概率质量函数不能冒充一般测度 | Pr1 |
| E9P.2 独立性、矩与方差 | `examples.probability.independence-moments` | 独立 Bernoulli 和、均值、方差与协方差计算 | 不相关不等于独立；有限期望不自动给有限方差 | Pr1 |
| E9P.3 条件期望与鞅 | `examples.probability.conditional-martingale` | 有限分割条件期望、简单随机游走鞅与有界停时 | 条件期望是 a.e. 等价类；无界停时不能直接套有界可选停止 | Pr2 |
| E9P.4 收敛与大数律 | `examples.probability.convergence-lln` | 样本均值的概率／几乎必然收敛及收敛模式比较 | 概率收敛不自动推出几乎必然收敛；弱大数律不等于强大数律 | Pr3 |
| E9P.5 特征函数 | `examples.probability.characteristic-functions` | Bernoulli、正态及独立和的特征函数计算 | 只写形式积分不等于满足可测性；连续性不需要矩条件 | Pr3.4 ✅ |
| E9P.6 统计模型、风险与偏差—方差 | `examples.statistics.estimators` | Bernoulli 模型样本均值、平方损失风险与偏差—方差分解 | 无偏不等于风险最小；随机化估计量需要明确 kernel | S1.1-S1.3 |
| E9P.7 相合性 | `examples.statistics.consistency` | 共同样本轨道上的样本均值，展示 `L²` 误差趋零推出逐参数概率相合 | 逐参数相合不等于一致相合；不同样本空间无 coupling 时不能直接用 `TendstoInMeasure` | S1.4 |
| E9P.8 中心极限定理 | `examples.probability.clt` | 标准化 iid 和的特征函数逐点收敛到标准正态特征函数，并接上 Lévy 连续性定理得到弱收敛 | 特征函数逐点收敛本身不足以保证弱收敛（Lévy 定理必须用过连续性点或紧性条件）；证明链走特征函数二阶 Taylor 小量，不能只写"由中心极限定理" | Pr3.5 ✅ |
| E9P.9 充分统计量 | `examples.statistics.sufficiency` | Bernoulli／正态模型下样本和或样本均值为充分统计量，核验共同正规条件分布与参数无关 | 充分不等于最小充分；"条件分布与参数无关"必须落在共同正规条件分布上，不能只比较形式密度 | S1.5 ✅ |

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
| E11.0 拓扑向量空间 | `examples.functional-analysis.topological-vector-spaces` | `ℝⁿ` 的加法、数乘与平移自同胚 | 分别连续不能静默替代联合连续；一般拓扑向量空间不必范数化 | F4.1 |
| E11.1 连续线性算子与算子范数 | `examples.functional-analysis.operators` | 恒等、零、坐标投影的算子范数与全局界 | 一般线性映射不自动连续；界常数不唯一而算子范数最小 | F1 |
| E11.2 Banach 值级数 | `examples.functional-analysis.series` | 有限维向量几何级数及部分和收敛 | 条件可和不等于范数级数可和；完备性不可静默省略 | F1 |
| E11.3 闭子空间商 | `examples.functional-analysis.quotients` | 有限维子空间商、商范数距离计算 | 非闭子空间会出现非零陪集范数为零的边界 | F1 |
| E11.4 Banach 三大定理 | `examples.functional-analysis.banach-theorems` | 具体算子族的一致有界、开映射与有界逆应用 | 逐点有界与一致有界不能在缺 Baire 条件时混同 | F2 |
| E11.5 Hilbert 空间 | `examples.functional-analysis.hilbert` | 正交投影、Riesz 表示、矩阵伴随、有限正交基 Parseval 与正交/酉变换计算 | 投影需要闭性；正交规范族不稠密时只有 Bessel 不等式；等距线性映射不满时不是酉算子 | F3 |
| E11.6 Hahn–Banach、双对偶与弱拓扑 | `examples.functional-analysis.duality-weak` | 有限维范数化泛函和凸集分离、坐标子空间零化子、有限维典范双对偶同构、坐标泛函族的弱／弱星收敛 | 代数零化子不等于连续零化子；一般空间不必自反；闭单位球弱紧刻画不能脱离 F4；范数、弱与弱星收敛不可混同 | F2+/F4 |
| E11.6a Banach–Alaoglu | `examples.functional-analysis.banach-alaoglu` | 有限维对偶闭球在弱星坐标下的紧致实例 | 弱星紧致不等于范数紧致，也不直接等于原空间闭球弱紧 | F4.3 |
| E11.6b 弱星序列抽取 | `examples.functional-analysis.weak-star-subsequences` | 可分空间对偶单位球序列的弱星收敛子列 | 只对紧子集断言可度量化；不可把弱星收敛写成范数收敛 | F4.4 |
| E11.6c Banach–Dieudonné 判据 | `examples.functional-analysis.banach-dieudonne` | 有限维对偶的坐标子空间：直接比较整体弱星闭性与单位球截面闭性，并展示外点分离向量 | 判据只针对线性子空间；单位球截面弱星闭不能外推到任意非线性集合；原空间完备性不可省略 | F4.5 |
| E11.7 紧算子与 Fredholm | `examples.functional-analysis.compact-fredholm` | 有限秩算子、对角紧算子、核／余核和指数计算 | 有界算子不必紧；紧算子不必有限秩；闭值域不可省略 | F5 |
| E11.8 有界谱理论 | `examples.functional-analysis.spectrum` | 有限维矩阵、移位和紧对角算子的谱／预解计算；多项式及两个不同谱邻域全纯函数的共同交集见证；两个谱参数处预解元的第一预解恒等式与乘法交换的具体验算 | 无限维谱不等于特征值集合；谱半径不必等于算子范数；只在谱上给值不等于已给出开邻域全纯输入；第一预解恒等式要显式带上 `z,w ∈ resolventSet`，不可省成 `Ring.inverse` 的恒等式（谱点上 `resolvent` 为 0） | F6 ✅ |
| E11.9 无界算子 | `examples.functional-analysis.unbounded-operators` | 微分／乘法算子的定义域、图、伴随和预解例 | 同一公式配不同定义域会给不同算子；对称不自动自伴 | F7 |
| E11.10 算子半群 | `examples.functional-analysis.semigroups` | 平移、乘法和热半群的轨道及生成元计算 | 每点连续不能代替强连续；生成元通常不是有界算子 | F8 |
| E11.11 半范数与 Fréchet 空间 | `examples.advanced-functional-analysis.frechet` | `ℝⁿ` 坐标半范数、`C∞` 导数半范数及可数族生成度量 | 单个半范数可不分离点；Fréchet 不等于“具有某个完备范数” | AFA1-AFA2 |
| E11.12 桶、Bornological 与 Montel | `examples.advanced-functional-analysis.space-properties` | 标准 Fréchet、LF 和 Montel 空间的性质核对 | 完备不自动 Montel；有界集概念不能静默换成范数有界 | AFA3-AFA4 |
| E11.13 测试函数与分布 | `examples.advanced-functional-analysis.distributions` | Dirac、函数诱导分布、导数和 Fourier 变换 | 点值对一般 `L¹` 函数无意义；分布收敛不等于逐点收敛 | AFA5 |
| E11.14 Banach–Steinhaus 凝集定理 | `examples.functional-analysis.condensation` | 可数行连续线性算子族各行各有输出无界点时，构造公共无界点；同时发散版本给出公共非 Cauchy 点 | 结论是"公共点集稠密 `Gδ`"而不是全空间或某个固定点；行数必须可数，Baire 范畴条件与 Banach 定义域不可省略；各行值域完备性只在同时发散版本里用到 | F2 ✅ |

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

## E13 表示论与高阶代数

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E13.1 特征标表 | `examples.representation-theory.character-tables` | 循环群、有限阿贝尔群和最小非阿贝尔群的共轭类、不可约特征标与完整表 | 一组类函数满足部分正交关系不等于已经穷尽不可约特征标 | RT3 |
| E13.2 Deligne–Lusztig 低秩对象 | `examples.representation-theory.deligne-lusztig-low-rank` | 在理论接口完成后实例化最小秩有限 Lie 型群、相应簇作用和虚特征标计算 | 低秩计算不能冒充一般表示分类或上同调迹公式 | landmark RT gate |

## E14 Fourier 与调和分析

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E14.1 Fourier 变换 | `examples.harmonic-analysis.fourier-transform` | Gaussian、矩形函数、平移调制缩放及卷积的完整常数计算 | 不同归一化不可混用；`L¹` 反演条件不能静默省略 | HAna1 |
| E14.2 Fourier 级数核 | `examples.harmonic-analysis.fourier-series` | 方波／锯齿波系数、Dirichlet／Fejér／Poisson 核部分和 | 点态、Cesàro、`L²` 与 a.e. 收敛不得混称 | HAna2 |
| E14.3 奇异积分 | `examples.harmonic-analysis.singular-integrals` | 截断 Hilbert 变换、极大函数和简单 Calderón–Zygmund 分解 | 主值存在不等于绝对可积；弱型不等于强型 | HAna3–HAna4 |
| E14.4 频率分解 | `examples.harmonic-analysis.frequency-decomposition` | dyadic 频带、Littlewood–Paley 平方函数和简单乘子 | 有界符号不自动给所有 `Lᵖ` 乘子有界性 | HAna4–HAna5 |

## E15 多复变函数论

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E15.1 多变量全纯 | `examples.several-complex-variables.holomorphic` | 多项式、乘积函数、多圆盘 Cauchy 积分与多重指标导数 | 分别连续／实可微不能替代联合复 Fréchet 可微 | SCV1 |
| E15.2 Hartogs 与延拓 | `examples.several-complex-variables.hartogs` | 一个 Hartogs 图形上的延拓构造与 Laurent 系数消失 | 一元带孔域直觉不能无条件搬到 `ℂⁿ, n≥2` | SCV2 |
| E15.3 拟凸与 Levi | `examples.several-complex-variables.pseudoconvex` | 球、多圆盘和一般定义函数的 Levi 形式计算 | 边界实凸与拟凸不是同一概念 | SCV3 |
| E15.4 解析集 | `examples.several-complex-variables.analytic-sets` | 超曲面正则点、Jacobian 秩及简单奇点 | 零集不可约、光滑、连通三者不能混同 | SCV5 |

## E16 Riemann 曲面

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E16.1 图册与映射 | `examples.riemann-surfaces.atlases` | Riemann 球面、复环面和开子域的图册转移函数 | 拓扑曲面不自动具有指定复结构 | RS1 |
| E16.2 亚纯函数与除子 | `examples.riemann-surfaces.divisors` | 球面有理函数的零极点、次数和留数总和 | 局部主部数据不自动来自全局亚纯函数 | RS2–RS4 |
| E16.3 周期与 genus | `examples.riemann-surfaces.periods-genus` | 环面的一阶微分周期、基本环路和 genus 计算 | 同调类相同与道路严格相同不可混称 | RS3/RS6 |
| E16.4 Riemann–Roch | `examples.riemann-surfaces.riemann-roch` | genus `0/1` 上低次数除子的维数核对 | 几个低 genus 核对不能冒充一般 Riemann–Roch 证明 | RS5 |

## E17 博弈论

| 项目 | Examples Entry 家族 | 必做正例／计算 | 必做反例或辨析 | 开工门 |
|---|---|---|---|---|
| E17.1 战略式均衡 | `examples.game-theory.normal-form` | 囚徒困境、协调、鹰鸽的纯／混合最优反应和均衡 | 占优策略、Nash 均衡与社会最优互不等价 | GT1–GT2 |
| E17.2 零和与极小极大 | `examples.game-theory.zero-sum` | 匹配硬币和小矩阵博弈的值及最优混合策略 | `max min` 与 `min max` 不因有限性自动相等，需定理条件 | GT2 |
| E17.3 扩展式博弈 | `examples.game-theory.extensive-form` | 有限博弈树逆向归纳和子博弈完美均衡 | Nash 均衡不自动序贯可信 | GT3 |
| E17.4 Bayesian 与机制 | `examples.game-theory.bayesian-mechanism` | 两类型 Bayesian 博弈、直接机制和激励约束 | 事后、Bayesian 与占优策略激励相容不得混称 | GT5/GT8 |
| E17.5 合作解 | `examples.game-theory.cooperative` | 小型特征函数博弈的 core 与 Shapley 值 | core 可为空；Shapley 值不必属于 core | GT6 |

## E18 后续学科自动扩展

后续学科首次进入 main 时，Main 按相同模板在本文件新增项目组。最低要求仍是“标准对象 +
计算／构造 + 必要反例”，不得只把理论文档中的一句例子复制过来。

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
- 该例子本身是课程出口的一部分：理论批次与 Examples 批次使用同一课程门联动，但必须由两位
  对应负责人分别开发、分别提交；理论负责人不得代写 Examples，Examples 未完成时只保持课程门
  未关闭，不把已经数学验收合格的理论提交打回；
- 理论接口不足：标记 `blocked` 并向原学科提出最小接口需求。

Examples 的缺口通常不打回数学正确的理论提交，但 Main 必须把缺口排入巡视，不能让“以后补例子”
成为永久状态。

### 巡视记录

- **2026-10-13（Main `1e7bf87`）**：补齐上一轮两次集成的登记缺口。`1762942`
  （Banach–Steinhaus 1927 凝集定理 I／II）登记为 E11.14；`46ea736`（Lévy 连续性定理、
  CLT 特征函数基础链、充分统计量）登记为 E9P.8 与 E9P.9，并把 E9P.5 的开门口
  `Pr3.4` 标注为已验收。四条新项目均为 `missing`（尚无 Examples Entry），按"未覆盖但不阻塞
  理论"排入本路线图，不打回已通过数学验收的理论提交。

> 本次巡视发现的问题：`1762942` 与 `46ea736` 集成时漏了本文件登记。登记本身是 Main 的集成
> 职责（MAIN-ROLE 验收顺序第 5 步），此前未执行，现补记于此，供后续 Main 核对节奏。

## Wave R1 Examples 交付台账（2026-10-13，已集成）

首批正式 `examples.*` Entry 进入 Main，覆盖三个学派的最新增量（RA-F2、Pr3.5、Wave E 拓扑条目）：

| 台账项 | 已交付 Entry | 覆盖状态 | 说明 |
|---|---|---|---|
| E7.1 拓扑与邻域（Wave E `topology.space.closure`） | `examples.topology.spaces` | **partial** | 开区间闭包、闭区间内部、开区间边界，以及「开集不必闭／闭集不必开」两个精确反例；离散、不可分辨与「同一集合不同拓扑」尚未补 |
| E8.6 有符号／复测度与 RN（RA-F2 侧） | `examples.real-analysis.measure-derivative` | **partial** | 常密度测度、标准正态的 RN 导数，以及 Dirac 测度相对 Lebesgue 的互奇异与 Lebesgue 分解；有符号／复测度 Jordan 分解与变差的 `examples.real-analysis.signed-rn` 仍缺 |
| E9P.8 中心极限定理 | `examples.probability.clt` | **covered（主链）** | 标准正态坐标无限乘积空间上的 iid／L²／均值零／方差一，代入一般 iid CLT 得弱收敛，并经 Lévy 接口读回特征函数极限；「逐点特征函数收敛不足以保证弱收敛」的反例仍只在叙述层辨析，未 Lean 化 |

**剩余边界**：E0.2–E0.4 存量转正未做；E9P.8 的反例未 Lean 化；上表三行的 partial 项须在后续巡视补足。
