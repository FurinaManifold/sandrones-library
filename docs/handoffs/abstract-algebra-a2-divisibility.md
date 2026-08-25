# 抽象代数 A2 整除理论交接

## 接收窗口

- 分支：`codex/abstract-algebra`。
- 本窗口提交为本 handoff 所在提交；不得合并整个长期分支，只可 cherry-pick 固定窗口。
- 新源码：`SandronesLibrary/AbstractAlgebra/RingDivisibility.lean`。
- 八段文档：`docs/entries/abstract-algebra/ring/divisibility.md`。
- Entry：`abstract-algebra.ring.divisibility`。

## 教材定义层六列表

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 整除 | `DividesElement` | `dividesElement_refl`、`dividesElement_trans` | `dividesElement_iff_dvd` | 相伴、素元、gcd | `abstract-algebra.ring.divisibility` |
| 相伴 | `AssociateElements` | 反身、对称、传递及与互相整除的双向关系 | `associateElements_iff_associated` | gcd 相伴唯一 | 同上 |
| 不可约元 | `IrreducibleElement` | 非零、非单位与二因子分解判据 | `irreducibleElement_iff_irreducible` | 素元推出不可约 | 同上 |
| 素元 | `PrimeElement` | 非零、非单位与整除乘积判据 | `primeElement_iff_prime` | `primeElement_implies_irreducibleElement` | 同上 |
| 最大公因子 | `GreatestCommonDivisor` | 公因子与整除泛性质 | 不使用 `GCDMonoid`；未假设普遍存在 | `greatestCommonDivisor_unique_up_to_associates` | 同上 |

## 公开签名分类

| 分类 | 名称 | 边界 |
|---|---|---|
| 1. 已验收底层承载 | `CommRing`、`Monoid`、`Semigroup`、`IntegralDomainAxioms`、`UnitElement` | 基础环运算及此前 A2 定义层。 |
| 2. 具名桥一侧 | `Dvd.dvd` 记号、`Associated`、`Irreducible`、`Prime` | 只出现在四个命名清楚的兼容桥一侧。 |
| 3. 私有证明后端 | `IsDomain`、`IsUnit`、`IsLeftCancelMulZero` | 由已有桥在证明体局部获得，用于可靠消去或单位打包。 |
| 4. 申请例外 | 无 | 主课程定理不泄漏 Mathlib 分解结构。 |

`GCDMonoid`、`NormalizedGCDMonoid`、`DecompositionMonoid`、`Associates` 与 `Units` 均未进入
教材主签名。本批不声称不可约必为素元，也不声称任意交换整环中 gcd 存在。

## 定义链组装与验证

- 聚合链一：`DividesElement` → 反身／传递 → `AssociateElements` → 互相整除双向判据 → gcd
  相伴唯一。
- 聚合链二：`UnitElement` → `IrreducibleElement`／`PrimeElement` → 三个 Mathlib 兼容桥 →
  `primeElement_implies_irreducibleElement`。
- `lake build SandronesLibrary.AbstractAlgebra.RingDivisibility`：8707 jobs 通过。
- `/tmp/check_ring_divisibility.lean`：20 个定义、性质、桥及上层使用者的 `#check` 通过。
- 两个核心上层定理的公理集合均为 `[propext, Classical.choice, Quot.sound]`。
- Entry 声明映射唯一；所有映射声明的公理探测可解析。
- 正式源码无 `sorry`、`admit`、`sorryAx`、`native_decide`、`Module`、`Submodule` 或
  `@[instance_reducible]`；`git diff --check` 通过。

## Main 集成建议

- 顶层 import：`SandronesLibrary.AbstractAlgebra.RingDivisibility`。
- Registry：登记 `abstract-algebra.ring.divisibility`，premises 为
  `abstract-algebra.ring.def`、`abstract-algebra.ring.domain`。
- ROADMAP：A2.5 可标记完成；下一项进入 A2.6 Euclidean 环。
- RADAR：登记 `Associated`、`Irreducible`、`Prime` 仅为具名兼容桥后端；不要登记
  `GCDMonoid` 为本条目依赖。

## 子 Agent 与诚实边界

- 接口审查 Agent 只读核对 Mathlib API，并指出不可约推出素元需要额外分解条件。
- 实验框架 Agent 未及时产出，负责人中止后在 `/tmp` 重建上层框架并亲自消除全部九个
  `sorry`；正式源码由负责人复核后迁入。
- 下一批可以稳定依赖五个教材定义、相伴等价关系、素元推出不可约和 gcd 唯一性；不能依赖
  gcd 存在、Bézout、Euclidean 算法、不可约推出素元或唯一分解。
