# 抽象代数环同构载体维护 RFC

## 现状与问题

本 RFC 基于 `main@8e53d23`，只处理
`SandronesLibrary/AbstractAlgebra/RingIsomorphismTheorems.lean` 中的
`RingIsomorphism`，不把理想、子环、显式商环或局部化载体顺手并入同一批次。

当前 `RingIsomorphism R S` 打包两个互逆普通函数、双向
`RingHomomorphism` 证明，并提供函数强制转换。这个数据与 Mathlib 的正式
`R ≃+* S`（`RingEquiv R S`）表达同一个数学概念；现有 Entry 和 handoff 却把
“不提供 `RingEquiv` 桥”当成设计目标。按照最新 Playbook，语义一致的成熟
正式承载应优先复用，不能只为拥有本库名称而复制同构结构。

这不否定本库 `RingHomomorphism` 的教材价值：后者是普通函数上的逐项谓词，
适合先展开验证同态公理。问题只在于把“同构”再次打包成平行数据结构。

## 可机验的语义对照

调查框架
`/tmp/sandrones-library/RingIsomorphismRingEquivFramework.lean` 已在
`main@8e53d23` 的依赖树上完成以下四项且零 `sorry`：

1. `RingIsomorphism.toRingEquiv : RingIsomorphism R S → R ≃+* S`；
2. `RingIsomorphism.ofRingEquiv : (R ≃+* S) → RingIsomorphism R S`；
3. `toRingEquiv (ofRingEquiv e) = e`；
4. `ofRingEquiv (toRingEquiv e) = e`。

双向转换保留底层函数、逆函数以及加法和乘法，因此 `old_iff_new` 在这里不是
单纯的命题等价，而是两个结构的互逆同构。维护等级为 **M2**：数学语义不变，
但正式公开承载需要分阶段迁移。

## 影响图

### Lean 直接使用者

旧载体的定义与绝大多数消费者同处
`RingIsomorphismTheorems.lean`：

- `ringFirstIsomorphism`；
- `ringThirdIsomorphism`；
- `ringIsomorphismTrans`；
- `ringHomRangeIsomorphismOfSurjective`；
- `quotientRingIsomorphismOfEqualIdeals`；
- `ringSecondIsomorphism`；
- 对应的代表元计算定理。

唯一跨 Lean 文件直接使用者是 `RingCRT.lean`：

- `chineseRemainderIsomorphism`；
- `finiteChineseRemainderIsomorphism`。

全库没有其他 Lean 文件直接引用 `RingIsomorphism`。Registry 也只记录
`abstract-algebra.ring.crt` 依赖
`abstract-algebra.ring.iso-theorems`，与源码影响图一致。

### 文档与共享状态

直接涉及该载体的课程文档为：

- `docs/entries/abstract-algebra/ring/iso-theorems.md`；
- `docs/entries/abstract-algebra/ring/crt.md`。

历史 handoff/review 与 `docs/MATHLIB-RADAR.md` 仍记录旧设计理由。ROADMAP、
Registry、RADAR 和生成索引属于 Main 共有文件，学科维护分支不直接修改。

### 隐式影响

旧结构只提供 `CoeFun`，没有发现以它为源的全局 typeclass、simp 实例或 notation。
迁移为 `RingEquiv` 后仍可直接当函数使用。显式商环所需的局部 `Ring` 实例与本次
载体选择正交；本 RFC 不改变 `quotientRingSet` 的构造或实例生命周期。

## 分阶段迁移

当前状态（Main 2026-08-26）：**R1、R2 均已集成并验收**。正式第一、第二、第三同构定理以及
二元／有限族 CRT 同构均由 `RingEquiv` 核心拥有证明，旧 `RingIsomorphism` 名称保持为薄兼容
包装。理想与商环承载未随 R2 改写；R3 旧接口处置仍未开放。

### R1：双轨桥与正式核心

在 `RingIsomorphismTheorems.lean` 中加入上述双向桥和往返恒等式。新增直接返回
`RingEquiv` 的正式第一、第二、第三同构定理及必要的正式内部组合链；证明所有权
转移到正式核心。旧名称与旧返回类型保持不变，只作为
`RingIsomorphism.ofRingEquiv` 的 compatibility wrapper，不复制原证明。

这一阶段不删除旧结构，不改变 CRT。已由 Main 集成；回滚点是独立的 R1 提交。

### R2：同学科下游

把 `RingCRT.lean` 的两个主同构结果迁移为正式 `RingEquiv` 核心，并视外部兼容策略
保留旧 `RingIsomorphism` 包装。同步两个 Entry 对正式承载和旧兼容层的说明。R2 是
独立提交，可在不撤销 R1 的情况下回滚；现已由 Main 集成。

### R3：旧接口处置

只有全库 Lean、文档、Registry、RADAR 与 Examples 的旧 API 使用计数为零，并且
Main 的审计与全库构建通过后，才重新评估旧结构。默认保留薄兼容层，不因仓内使用
归零推断可破坏外部 API；是否 deprecate 或删除必须由 Main 单独授权。

## 不采用的方案

- 不把 `RingEquiv` 再包装成另一个新结构；这会制造第三套载体。
- 不仅增加一个无人消费的桥而让所有主定理继续由旧结构拥有证明。
- 不在同一提交中改写同构、理想、子环、商环和局部化全部接口。
- 不把普通函数谓词 `RingHomomorphism` 机械删除；它与打包同构承担不同教材角色。

## 本轮边界

`TwoSidedIdealCarrier`、`SubringCarrier`、`QuotientIdealOrderEquivalence` 与
`MultiplicativeSet` 都需要各自核对 Mathlib 语义、真实消费者和显式教学构造边界；
它们不是本 RFC 已批准的迁移对象。`quotientRingSet` 和 `LocalizationRing` 是显式
商构造，不能仅凭 Mathlib 存在同名成熟结构就判为重复载体。
