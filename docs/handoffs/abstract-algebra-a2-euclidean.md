# 抽象代数 A2 Euclidean 环交接

## 接收窗口

- 分支：`codex/abstract-algebra`；只 cherry-pick 本 handoff 所在固定提交。
- 源码：`SandronesLibrary/AbstractAlgebra/RingEuclidean.lean`。
- 八段文档：`docs/entries/abstract-algebra/ring/euclidean.md`。
- Entry：`abstract-algebra.ring.euclidean`。

## 教材定义层六列表

| 概念 | 本库教材定义 | 展开／一手性质 | Mathlib 桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 带余除法 | `DivisionWithRemainder` | `EuclideanDomainAxioms.division`、`remainder_lt` | 无；不调用 Mathlib 除法类 | 递归终止与 gcd 证明 | `abstract-algebra.ring.euclidean` |
| Euclidean 环 | `EuclideanDomainAxioms` | 整环、度量、商、余数及下降字段 | 无；刻意不注册 `EuclideanDomain` | `euclideanGCD` | 同上 |
| Euclidean gcd | `euclideanGCD` | 零与非零递归方程 | 输出满足 `GreatestCommonDivisor` | gcd 泛性质 | 同上 |
| 扩展算法 | `extendedEuclidean` | gcd 分量及 Bézout 恒等式 | 无 Mathlib xgcd 后端 | Bézout 存在定理 | 同上 |

## 公开签名分类与诚实边界

- 第一类：`CommRing`、`ℕ`、本库 `IntegralDomainAxioms`、`GreatestCommonDivisor`。
- 第二类具名桥：无；本批没有调用 Mathlib Euclidean 结构。
- 第三类私有后端：良基递归和 `ring` tactic，不进入声明类型。
- 第四类例外：无。
- 未完成：Euclidean⇒PID、PID⇒UFD、理想主生成性与唯一分解。

## 验证与 Main 建议

- 目标构建 `SandronesLibrary.AbstractAlgebra.RingEuclidean`：8708 jobs 通过。
- 完整链覆盖带余除法 → 两个展开性质 → 两个递归方程 → gcd 泛性质 → 扩展算法 → Bézout。
- 聚合文件检查 12 个定义、展开性质和上层结论；修正限定名识别后，Entry 唯一映射 12 个
  声明，12 项公理探测全部可解析。
- 正式源码无占位、`Module`、`Submodule`、Mathlib `EuclideanDomain` 签名或全局实例。
- Main 顶层 import 建议加入 `SandronesLibrary.AbstractAlgebra.RingEuclidean`。
- Registry premises：`abstract-algebra.ring.domain`、`abstract-algebra.ring.divisibility`。
- ROADMAP：A2.6 可勾选；下一批 A2.7 PID/UFD。
