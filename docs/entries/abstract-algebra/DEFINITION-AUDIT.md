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
- [ ] Euclidean 环、PID、UFD、局部化。

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

- [ ] 多项式、系数、次数、求值和根目前直接使用 `Polynomial` API。
- [ ] 不可约、首一、整除与重数需要在 A2 整除定义层完成后回修。
- [ ] 域扩张相关概念尚未开始；不得直接用 `Algebra`、`IntermediateField` 等结构充当教材定义。
