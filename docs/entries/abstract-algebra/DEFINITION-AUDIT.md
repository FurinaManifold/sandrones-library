# 抽象代数教材定义层审计

本清单记录“源码已有定理，但核心概念或运算仍直接挂靠 Mathlib”的技术债。完成一项的
标准不是增加中文注释，而是：先给出本库教材定义，再证明与 Mathlib 承载结构的桥，并让
后续公开主定理优先使用本库定义。

## 修复原则

1. 运算和公理必须在概念首次出现处明确列出。
2. Mathlib 类型可留在私有桥、证明体和可靠的数据承载层，不能充当自然语言定义。
3. 若需要计数或量化满足某性质的对象，使用本库谓词形成子类型，而不是直接暴露 Mathlib
   的专用打包结构。
4. 修复顺序必须自底向上；上层条目不能在底层定义尚未建立时继续扩建。

## A2 环论

- [x] 环公理与交换环公理：`RingAxioms`、`CommutativeRingAxioms`。
- [x] 单位元素：`UnitElement`。
- [x] 子环集合：`SubringSet`。
- [x] 环同态：`RingHomomorphism`。
- [x] 理想（`abstract-algebra.ring.ideal`，`Ring.lean`）：区分左理想、右理想和双边理想，
  定义理想和、积与生成理想，并完成 Mathlib 桥。
- [x] 商环（`abstract-algebra.ring.quotient`，`RingQuotient.lean`）：`idealCongruent`、
  `quotientRingSet` 与自然投影已经建立；商集上的具名运算、
  `RingAxioms`、投影的核以及下降映射的存在唯一泛性质均已证明。Mathlib
  `Ideal.Quotient` 仅保留为兼容接口。
- [x] 零因子、整环与域：`ZeroDivisorElement`、`NoZeroDivisorsAxiom`、
  `IntegralDomainAxioms`、`FieldAxioms` 已建立；域推出整环直接由本库单位元素与环公理证明，
  Mathlib 的 `NoZeroDivisors`、`IsDomain`、`IsField` 只出现在具名桥接接口中。
- [x] 素理想与极大理想（`abstract-algebra.ring.prime-ideal`，`RingPrimeIdeal.lean`）：
  `PrimeIdealSet`、`MaximalIdealSet` 已自建；极大推出素、商整环与商域的双向判据均使用
  本库 `quotientRingSet`、`IntegralDomainAxioms`、`FieldAxioms`。Mathlib 理想属性只保留在
  两个具名承载桥和旧兼容接口中。
- [x] 环同构定理：新课程条目 `abstract-algebra.ring.iso-theorems` 已用本库
  `RingHomomorphism`、核、像、子环与双边理想承载和显式商映射证明第一、第二、第三同构定理
  及理想对应，并给出三个同构的规范代表元公式。历史条目 `abstract-algebra.ring.iso` 仅记录
  `RingHom.quotientKerEquivRange` 的 Mathlib 兼容接口，不等同于新课程条目的定义层迁移成果。
  Registry 不应令二者互为虚构前提：旧条目保留其兼容性质，新条目只列实际使用的环定义、
  理想与显式商环前提；`dependedOnBy` 仅由真实 premises 关系生成。
- [x] 整除、相伴、不可约、素元与 gcd：`DividesElement`、`AssociateElements`、
  `IrreducibleElement`、`PrimeElement`、`GreatestCommonDivisor` 已建立；素元推出不可约及 gcd
  相伴唯一已经证明，并提供与 Mathlib 对应谓词的具名桥。
- [x] Euclidean 环：`DivisionWithRemainder`、`EuclideanDomainAxioms`、递归 gcd 与扩展
  Euclidean 算法已自建；gcd 泛性质和 Bézout 恒等式已经证明，公开签名不依赖 Mathlib
  `EuclideanDomain`。
- [x] PID 与 UFD：`PrincipalIdealSet`、`PrincipalIdealDomainAxioms`、
  `AtomicFactorizationAxiom`、`UniqueFactorizationDomainAxioms` 已自建，并证明
  Euclidean⇒PID⇒UFD；Mathlib 分解结构只在局部证明后端出现。
- [x] 中国剩余定理：`ComaximalIdealSets`、`PairwiseComaximalIdealSets`、集合型理想交与
  本库商环规范映射已建立；二元及有限族 CRT 同构均已证明，Mathlib `Ideal` 只作为有限满射
  的局部证明后端。
- [ ] 局部化。

## A1 群论回修

- [x] 群公理与交换群公理：`GroupAxioms`、`CommutativeGroupAxioms`。
- [x] 子群集合与生成子群集合：`SubgroupSet`、`generatedSubgroupSet`，并完成承载桥。
- [x] 群同态谓词：`GroupHomomorphism`，并完成 `MonoidHom` 双向桥。
- [ ] 旧子群格与同态公开接口仍使用 `Subgroup`、`MonoidHom`，需迁移到上述定义层。
- [ ] 陪集、正规子群、商同余、商群与商映射需自建定义层。
- [ ] 群作用、轨道、稳定子目前直接使用 `MulAction` API。
- [ ] 循环群目前直接使用 `IsCyclic`。
- [ ] 自同构、内自同构、置换循环、换位、符号和交错群缺本库定义层。
- [ ] 直积、内部直积和半直积需区分本库概念与 Mathlib 数据承载。
- [x] `p`-群与 Sylow 子群已经自建定义层。
- [x] 有限生成群已经自建定义层。

## A3 多项式与域扩张

- [x] 多项式、系数、次数、求值和根：`PolynomialSequence` 已按有限支撑系数序列自建，
  并提供具名 Mathlib 双向桥、环运算、系数公式、求值同态、因式定理及整环性。旧
  `Poly.lean` 的直接 Mathlib 接口已降为独立兼容 Entry。
- [x] 首一多项式与带余除法：`Monic` 已由系数自建；交换环上的首一除法、域上的一般
  非零除式除法、Euclidean 度量、gcd 与 Bézout 均已迁移到本库多项式和 A2 定义层。
- [x] 不可约与判别：后续课程正式复用语义一致的 `Irreducible`、`Polynomial.IsPrimitive`、
  `content` 与 `IsEisensteinAt`，并已完成教材展开、Gauss 引理、有理根和 Eisenstein 判别。
- [x] 唯一分解、根的重数、导数与重根判据：A3.4 以正式 `Polynomial`、
  `normalizedFactors`、`rootMultiplicity` 和 `derivative` 承载，已解释规范因子唯一性、
  线性因子整除、单根／重根及特征零下导数重数递降的精确边界。
- [x] 域扩张第一层：A3.5 已自建显式 `FieldEmbedding`、`SubfieldSet`、
  `IntermediateFieldSet`、生成中间域、代数／超越元、最小多项式关系和单扩张；Mathlib
  `Algebra`、`IntermediateField` 不充当教材定义，`Algebra` 与 `minpoly` 只在私有证明桥中使用。
- [x] 扩张次数：A3.6 已以显式嵌入上的有限和定义线性无关、张成和域基，证明次数唯一与正性、
  有限扩张必代数及塔式公式；`Algebra`、`Module`、`Submodule`、Mathlib 基和维数只在私有桥中。
- [ ] 分裂域、可分／正规扩张与 Galois 理论仍须继续使用上述显式定义层，不能重新退回隐式
  `Algebra`、`IntermediateField` 或 `Module` 公开签名；是否启动服从 Main 依赖门通知。
