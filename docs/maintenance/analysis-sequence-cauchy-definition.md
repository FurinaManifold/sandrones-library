# 分析维护说明：Cauchy 列教材定义

## 现状

`analysis.sequence.cauchy` 已证明实数列收敛当且仅当满足 Mathlib 的 `CauchySeq`，课程文档也解释
了双指标 ε-N 条件，但源码没有给这一教材条件命名。读者因此只能先把 `CauchySeq` 经
`Metric.cauchySeq_iff` 展开，才能看到定义本身。

## 本轮补充

新增：

```lean
def SequenceIsCauchy (u : ℕ → ℝ) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ m ≥ N, ∀ n ≥ N, |u m - u n| < ε
```

并提供定义展开定理 `sequenceIsCauchy_iff_epsilon_N` 以及等价桥：

```lean
sequenceIsCauchy_iff_cauchySeq : SequenceIsCauchy u ↔ CauchySeq u
```

桥由 `Metric.cauchySeq_iff` 和 `Real.dist_eq` 得到，两个方向都没有额外前提。

## 接口边界与影响

本项是 M1 定义补充。原有 `convergent_is_cauchy`、`cauchy_seq_convergent` 以及 Analysis 中其他
接受 `CauchySeq` 的定理全部保持原名、原签名和原证明。`CauchySeq` 在级数、完备性和幂级数中
继续作为正式接口；不要求替换，不设退役计划，也不以使用计数归零为目标。

新定义是普通 `Prop`，不增加 notation、instance 或 simp 属性，不改变导入闭包和 typeclass 搜索。
课程文档只需明确区分教材定义、Mathlib 桥和依赖实数完备性的收敛准则。

## 只读影响证据

- 直接源码使用者：`Analysis/Sequence.lean`、`Completeness.lean`、`PowerSeries.lean`、`Series.lean`。
- 全库 Lean 中 `CauchySeq` 共 22 处，其中 Analysis 为 17 处；课程文档中共 14 处。它们是有效
  Mathlib 接口使用，不是待清零债务。
- Entry premises：`analysis.series.basic` 与
  `analysis.completeness.equivalence-cycle.cauchy-to-sup` 直接依赖 `analysis.sequence.cauchy`。
- 间接上层包括级数判别、实数完备性等价循环和幂级数收敛论证。
- 导入闭包：新定义位于原 `Sequence.lean`，没有新增 import；普通 `Prop` 不影响 instance、notation
  或 simp 搜索。

回滚点为 `507485c`。回滚本项不会影响任何既有声明。

## 本轮不处理

不改完备性定理接口，不新增一般度量空间版本，不处理函数列的一致 Cauchy 条件，不修改 Registry、
RADAR、ROADMAP、Playbook 或顶层 import。
