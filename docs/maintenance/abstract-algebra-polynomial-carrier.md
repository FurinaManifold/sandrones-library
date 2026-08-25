# 抽象代数多项式承载迁移 RFC

## 结论与等级

本维护为 **M2：公开签名迁移，但新旧承载已证明等价**。后续多项式课程正式采用 Mathlib
`Polynomial R`；现有 `PolynomialSequence R` 及其双向桥完整保留为兼容层。本轮不删除旧声明，
也不启动 A3.3/A3.4。

## 现状与问题

`PolynomialDefinition.lean` 把多项式自建为自然数指标的有限支撑系数序列，并已证明
`toMathlibPolynomial` 与 `fromMathlibPolynomial` 双向互逆。该类型与 Mathlib `Polynomial R`
在对象、系数和环运算上没有课程语义差异。继续以平行类型开发会迫使每个下游重复搬运次数、
求值、整除、不可约性和实例。

Playbook 现规定：语义一致时优先把成熟接口作为正式公开承载；教材解释和边界披露是硬门，
“本库前缀”不是质量目标。因此正式承载切换到 `Polynomial R`，旧类型降为可逆兼容表示。

## 只读影响图

### Lean 直接使用者

| 文件 | 使用方式 | 迁移处理 |
|---|---|---|
| `PolynomialDefinition.lean` | 定义 `PolynomialSequence`、运算和双向桥 | 保留兼容层；补充正式承载说明，不破坏旧 API |
| `PolynomialDivision.lean` | A3.2 全部公开定理使用旧承载 | 先新增 Mathlib 正式承载的平行课程接口；旧接口继续编译 |

当前其他 Lean 文件没有使用 `PolynomialSequence`，也没有直接导入 `PolynomialDivision`；因此阶段 B
只涉及同学科同文件迁移，没有跨学科源码迁移。

### 文档与共享状态

- `docs/entries/abstract-algebra/poly/def.md`：当前误称 Mathlib 只为私有后端，需改为正式承载解释。
- `docs/entries/abstract-algebra/poly/division.md`：需以 Mathlib 多项式接口为主，旧接口列为兼容层。
- `docs/entries/abstract-algebra/poly/mathlib-compat.md`：角色反转后不再称 Mathlib 为待退役旧层；由 Main
  决定合并或重命名 Entry。
- `index/registry.json`、ROADMAP、RADAR、顶层 import：属于 Main 共有文件，本分支只提交修改建议。

未发现 notation、simp attribute 或全局实例依赖 `PolynomialSequence` 的外部使用者。旧类型自己的
`CommRing` 实例仍保留，保证外部兼容。

## 教材语义与正式 Lean 承载

| 教材概念 | 教材语义 | 正式 Lean 承载 | 展开／一手性质 |
|---|---|---|---|
| 多项式 | 非零项有限的系数序列 | `Polynomial R` | `Polynomial.ext`、`coeff`、`support` |
| 次数 | 最高非零系数指标；零多项式为 `⊥` | `Polynomial.degree : WithBot ℕ` | `degree_eq_nat_iff_coeff_ne_zero` 等 |
| 求值 | 有限和 `∑ aₙxⁿ` | `Polynomial.eval` | `eval_eq_sum`、`eval₂_at` |
| 首一 | 最高次系数为一 | `Polynomial.Monic` | `Polynomial.Monic.def` |
| 首一商余 | `p=dq+r` 且 `deg r<deg d` | `divByMonic`、`modByMonic` | `modByMonic_add_div`、`degree_modByMonic_lt` |
| 域上商余 | 任意非零除式的 Euclidean 除法 | `/`、`%` | `EuclideanDomain.mod_add_div`、`degree_mod_lt` |

这些接口与教材定义语义一致；类型类假设分别明确为 `Semiring`、`CommRing`、`Nontrivial` 或
`Field`。本库文档必须解释其数学含义，但不再复制同构对象。

## A3.2 正式签名迁移表

| 旧兼容接口 | 新正式承载接口 | Mathlib 基础 |
|---|---|---|
| `Monic p` | `p.Monic` | `Polynomial.Monic` |
| `monicQuotient p d` | `p.divByMonic d` | `Polynomial.divByMonic` |
| `monicRemainder p d` | `p.modByMonic d` | `Polynomial.modByMonic` |
| `monic_division_identity` | `mathlib_monic_division_identity` | `modByMonic_add_div` |
| `monic_remainder_degree_lt` | `mathlib_monic_remainder_degree_lt` | `degree_modByMonic_lt` |
| `monic_remainder_eq_zero_iff_dividesElement` | `mathlib_monic_remainder_eq_zero_iff_dvd` | `modByMonic_eq_zero_iff_dvd` |
| `monic_quotient_remainder_unique` | `mathlib_monic_quotient_remainder_unique` | `div_modByMonic_unique` |
| `polynomialQuotient` / `polynomialRemainder` | `/` / `%` | `EuclideanDomain` operations |
| `polynomialEuclideanDomainAxioms` | `mathlibPolynomialEuclideanDomainAxioms` | 本库 A2 公理数据，承载为 `Polynomial K` |
| 旧 gcd / Bézout | `mathlibPolynomialGCD_*` | 本库 A2 Euclidean 算法 |

新接口保留教材级命名、中文注释与 A2 的真实上层使用者，不把本轮缩减为一份 Mathlib 名称清单。

## 兼容策略与迁移波次

1. **阶段 A（本轮）**：保留 `PolynomialSequence`；已有双向逆桥作为等价证据；补正式承载课程接口。
2. **阶段 B（本轮）**：A3.2 增加 Mathlib 承载的带余除法、Euclidean、gcd 与 Bézout；聚合测试同时
   检查新接口、旧桥和 A2 真实下游。
3. **阶段 C（暂不执行）**：只有全库旧 API 使用归零、Main 全量审计通过并确认外部兼容策略后，
   才考虑 deprecated 或退役。默认保留薄兼容层。

阶段 A 与 B 分开提交，任一阶段均可独立回滚。

## 诚实边界

- A3.3/A3.4 已冻结，本 RFC 通过 Main 复验前不增加对 `PolynomialSequence` 的依赖。
- 本轮不删除旧类型、旧定理或实例。
- Registry、RADAR、ROADMAP、顶层 import 和最终 review 归档由 Main 更新。
- Mathlib `Polynomial` 的内部实现可使用 `Finsupp`；课程正式语义只承诺有限支撑系数多项式 API，
  不承诺其内部表示细节。
