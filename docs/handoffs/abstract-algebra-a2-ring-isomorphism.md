# 抽象代数 A2 环同构定理交接

## 接收窗口

- 分支：`codex/abstract-algebra`
- 必须按顺序 cherry-pick：`c799118`、`fb4296c`、`a40754d`、`12ad82b`、`59f13c9`、
  `af6543b`，以及本交接更新所在提交。
- 不得合并整个长期分叉分支；本窗口之外的抽象代数开发不属于此次接收范围。

## 已完成内容

- 新源码：`SandronesLibrary/AbstractAlgebra/RingIsomorphismTheorems.lean`。
- 新八段教材文档：`docs/entries/abstract-algebra/ring/iso-theorems.md`。
- 新 Entry：`abstract-algebra.ring.iso-theorems`。
- 已证明本库显式第一、第二、第三同构定理、商环理想保序对应及相应代表元公式。
- `a40754d` 将两个环结构构造从全局 `instance_reducible` 改为可显式调用的定义；它们只由
  本文件的 `local instance` 使用，不会成为其他模块的全局实例搜索候选。

## 定义层与 Mathlib 边界

公开课程接口使用本库 `RingHomomorphism`、`TwoSidedIdealSet`、`TwoSidedIdealCarrier`、
`quotientRingSet` 与普通函数形式的 `RingIsomorphism`。Mathlib 的 `Quotient` 仅作为商集可靠
承载与判等后端；公开主定理不以 `RingEquiv`、`Ideal.Quotient` 或
`RingHom.quotientKerEquivRange` 代替教材构造。

历史 Entry `abstract-algebra.ring.iso` 记录的是直接调用
`RingHom.quotientKerEquivRange` 的 Mathlib 兼容接口；新 Entry 是更宽的教材课程入口，承担
本库定义迁移、理想对应和第三同构。二者不是同一项成果，也不应为了建立关系而互列虚构
premise。旧接口继续保留；新 Entry 的实际 premises 为 `abstract-algebra.ring.def`、
`abstract-algebra.ring.ideal`、`abstract-algebra.ring.quotient`，`dependedOnBy` 只按真实依赖生成。

## 教材定义层六列表

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 环同构 | `RingIsomorphism` | `left_inverse`、`right_inverse` 与双向 `RingHomomorphism` 字段 | 不提供 `RingEquiv` 桥；避免教材主接口退回 Mathlib | `ringFirstIsomorphism` | `abstract-algebra.ring.iso-theorems` |
| 双边理想承载 | `TwoSidedIdealCarrier` | `carrier` 与 `isTwoSided` 字段；`SetLike` 只给元素记号 | 无新桥；底层 `TwoSidedIdealSet` 已在 `ring.ideal` 验收 | `ringHomKernel` | 同上 |
| 显式商环的标准环结构 | `quotientRingSetRing` | 由 `quotientRingSet_ringAxioms` 的八条环公理打包 | `Ring.ofMinimalAxioms` 仅在定义体内打包，不是公开课程概念 | `ringFirstIsomorphism` 的源环 | 同上 |
| 环同态核 | `ringHomKernelSet`、`ringHomKernel` | `ringHomKernelSet_isTwoSidedIdeal` | 不调用 `RingHom.ker`；无 Mathlib 专用结构泄漏 | `ringFirstIsomorphism` | 同上 |
| 环同态像 | `ringHomRange` | `ringHomRangeMap_is_ringHomomorphism`，并由 `ringHomRangeRing` 验证环公理 | 使用基础 `Subtype` 承载存在原像证据；不调用 `RingHom.range` | `ringFirstIsomorphism` 的目标环 | 同上 |
| 第一同构 | `ringFirstIsomorphism` | `ringFirstIsomorphism_projection` | 不调用历史兼容接口 `RingHom.quotientKerEquivRange` | 代表元公式直接使用该同构 | 同上 |
| 子环承载 | `SubringCarrier` | `SubringSet` 字段及 `subringCarrierRing` 环公理打包 | 不调用 Mathlib `Subring`；`Subtype` 只作底层承载 | `subringIdealIntersection` 与 `subringIdealSum` | 同上 |
| 子环与理想的交、和 | `subringIdealIntersection`、`subringIdealSum`、`subringIdealInSum` | 两个成员展开定理 | 不调用 Mathlib 子环／理想格运算 | 第二同构规范映射 | 同上 |
| 第二同构规范映射 | `secondIsomorphismCanonicalMap` | 环同态、满射及核等于 `A∩I` 三个定理 | 商投影只使用本库 `quotientRingProjection` | `ringSecondIsomorphism` | 同上 |
| 第二同构 | `ringSecondIsomorphism` | `ringSecondIsomorphism_projection` | 由本库第一同构与显式承载同构复合，不调用 Mathlib 第二同构 | 代表元公式直接使用该同构 | 同上 |
| 双边理想包含 | `twoSidedIdealContained` | 本文件验证自反、传递、反对称并局部组装 `PartialOrder` | `LE`、`PartialOrder` 是已验收的基础序数据承载 | `quotientIdealCorrespondence` 的定义域 | 同上 |
| 理想逆像与满射像 | `idealComap`、`idealMapOfSurjective` | `mem_idealComap_iff`、`mem_idealMapOfSurjective_iff` 及两个单调性定理 | 不调用 Mathlib `Ideal.map`／`Ideal.comap` | `quotientIdealCorrespondence` | 同上 |
| 商环理想对应 | `QuotientIdealOrderEquivalence`、`quotientIdealCorrespondence` | `quotientIdealComapMap_membership`、`quotientIdealMapComap_membership` | 不使用 Mathlib 理想格同构；`Quotient` 仅为商集后端 | 第三同构中 `J/I` 的显式理想像构造 | 同上 |
| 第三同构 | `ringThirdIsomorphism` | `ringThirdIsomorphism_projection_projection` | 不调用 Mathlib 第三同构高层定理 | 二重投影代表元公式直接使用该同构 | 同上 |

## 公开签名中的 Mathlib／Lean 专用名分类

| 分类 | 名称 | 出现位置与边界 |
|---|---|---|
| 1. 已验收底层数据承载 | `Ring`、`Set`、`Subtype`、`Function.Surjective`、`Monotone`、`LE`、`PartialOrder`、`SetLike`、`CoeFun` | 环、集合、函数和序的基础承载；本批不把它们当作尚未定义的课程核心概念。`Subtype` 用于像和“包含核的理想”的数据承载。 |
| 2. 具名桥一侧 | 无 | 本批刻意不公开 `RingEquiv`、`Ideal`、`RingHom` 桥；历史 `ring.iso` 兼容接口仍在其旧文件中。 |
| 3. 私有证明后端 | `Quotient`、`Quot.sound`、`Quotient.inductionOn`、`Classical.choice`、`Ring.ofMinimalAxioms` | 只在商集实现、代表元选择或环公理打包中使用；未替代公开教材定义。 |
| 4. 申请例外的公开接口 | 无 | 公开主定理没有需要 Main 特批的 Mathlib 课程结构、class 或 Prop。 |

`quotientRingSet`、`RingHomomorphism`、`TwoSidedIdealSet` 是此前 A2 条目已经验收的本库定义，
故不重复作为 Mathlib 泄漏处理。上述分类覆盖本文件公开声明类型中的专用名称；证明体内 tactic
和普通逻辑联结词不计为公开接口。

第二同构使用的 `SetLike (SubringCarrier R) R` 以及 `Zero`、`One`、`Add`、`Mul`、`Neg` 是全局
实例：它们只让本库 `SubringCarrier` 的元素能够使用基础环运算，不会为任意外部载体自动选择
Mathlib 结构。完整 `Ring (SubringCarrier R)` 仍由 `subringCarrierRing` 显式定义并只在本文件注册
为 local instance，避免下游实例搜索静默取得本批组装的标准环结构。

## Main 集成建议

- 顶层 import：加入 `SandronesLibrary.AbstractAlgebra.RingIsomorphismTheorems`。
- Registry：登记 `abstract-algebra.ring.iso-theorems`，使用上述实际 premises；保留并明确旧
  `abstract-algebra.ring.iso` 的 Mathlib 兼容定位，不要把两个 id 描述成同一成果。
- RADAR：记录可靠后端 `Quotient`；`Ring.ofMinimalAxioms` 仅用于把已验证的教材公理打包成
  局部标准环结构。
- ROADMAP：A2.3 的第一、第二、第三同构及理想对应均可标记完成。

## 验证结果

- `lake build SandronesLibrary.AbstractAlgebra.RingIsomorphismTheorems`：8708 jobs 通过。
- 联合导入后 `#check` 已覆盖 `ringFirstIsomorphism`、`ringFirstIsomorphism_projection`、
  `quotientIdealCorrespondence`、`ringSecondIsomorphism`、`ringSecondIsomorphism_projection`、
  `ringThirdIsomorphism`、
  `ringThirdIsomorphism_projection_projection`。
- 公理审计：第一同构依赖 `[propext, Classical.choice, Quot.sound]`；理想对应依赖
  `[propext, Quot.sound]`；第二、第三同构均依赖 `[propext, Classical.choice, Quot.sound]`。
- 源码无 `sorry`、`admit`、`native_decide`，且无 `@[instance_reducible]`；`git diff --check`
  通过。

### 完整定义链聚合测试

临时聚合文件同时检查以下链，而非只检查最终大定理：

- 环同构：`RingIsomorphism` → `ringFirstIsomorphism` → `ringFirstIsomorphism_projection`；
- 核：`ringHomKernelSet` → `ringHomKernelSet_isTwoSidedIdeal` → `ringHomKernel` →
  `ringFirstIsomorphism`；
- 像：`ringHomRange` → `ringHomRangeRing` → `ringHomRangeMap` →
  `ringHomRangeMap_is_ringHomomorphism` → `ringFirstIsomorphism`；
- 理想映射：`idealComap`／`idealMapOfSurjective` → 两个成员展开定理 → 两个商投影逆律 →
  `QuotientIdealOrderEquivalence` → `quotientIdealCorrespondence`；
- 第三同构：`twoSidedIdealContained` → `quotientIdealCorrespondence` →
  `ringThirdIsomorphism` → `ringThirdIsomorphism_projection_projection`。
- 第二同构：`SubringCarrier` → `subringIdealIntersection`／`subringIdealSum` →
  `secondIsomorphismCanonicalMap` → 环同态、满射与核定理 → `ringSecondIsomorphism` →
  `ringSecondIsomorphism_projection`。

### Entry 声明映射

Main 提交 `76d770f` 已令 `scripts.check_axioms.map_entry_to_decl` 识别 `structure`、`class`、`abbrev`、属性前缀和
`noncomputable def`。加入第二同构后，本文件唯一 Entry 映射得到 45 个声明，包括
`RingIsomorphism`、`TwoSidedIdealCarrier`、`quotientRingSetRing`、`ringHomRangeRing`、
`ringFirstIsomorphism` 与 `ringThirdIsomorphism`。Markdown id、源码 id 和拟登记 Registry id
均唯一为 `abstract-algebra.ring.iso-theorems`，唯一 `lean_file` 为
`AbstractAlgebra/RingIsomorphismTheorems.lean`。新 Entry 尚未由学科分支写入共享 Registry；
Main 登记后应以修复后的审计器运行该 Entry 的正式 Registry audit。

## 未完成事项

本批三个环同构定理与理想对应均已完成。后续整除、Euclidean 环、PID、UFD 与局部化属于下一批，
不在本接收窗口。
