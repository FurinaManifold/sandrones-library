---
id: settheory.googology.hydra-certified-transitive-descent
kind: theorem
state: verified
title: "认证 Hydra 有限多步的严格下降与良基闭包"
premises: ["settheory.googology.hydra-certified-step-well-founded"]
mathlib: ["Relation.TransGen", "WellFounded.transGen"]
provenance: {source_type: book, ref: "良基关系的有限传递闭包；本条只处理本库认证 Hydra 步骤"}
---

# 动机

单步下降和单步良基归纳还不能直接表达“经过若干步到达”。下游常需要比较一段有限游戏的起点与终点，或者对所有能由非空有限认证轨迹到达的状态统一归纳。此时必须特别区分零步与正步：零步的起终点相同，不可能得到严格不等式；只有真正发生至少一次认证转换，端点序数才严格下降。

# 直觉

把轨迹长度写在关系上。走零步就是原地不动；走 `n+1` 步则先走一步到中间树，再从中间树走 `n` 步。每个认证单步都让序数变小，所以把有限多个严格不等式首尾相接，最终状态严格低于初始状态。若忘掉具体正步数、只保留“存在某个 `n+1`”，就得到通常所说的非空传递闭包；它仍不可能包含无限下降过程。

# 陈述（自然语言）

`CertifiedExactSteps n before after` 表示从 `before` 恰好经过 `n` 个认证步骤到达 `after`。当 `n=0` 时，这与 `before=after` 等价；当步数为 `n+1` 时，终点结构序数严格小于起点。`CertifiedTransitiveStep before after` 表示存在某个正步数的精确轨迹。把参数倒置得到 `CertifiedTransitivePredecessor after before` 后，该关系良基，并可对当前状态的所有非空有限认证可达后继进行良基归纳。

# 陈述（Lean 对照）

```lean
def CertifiedExactSteps : Nat → Hydra → Hydra → Prop
def CertifiedTransitiveStep (before after : Hydra) : Prop :=
  ∃ n, CertifiedExactSteps (n + 1) before after
def CertifiedTransitivePredecessor (after before : Hydra) : Prop

theorem certifiedExactSteps_zero_iff :
  CertifiedExactSteps 0 before after ↔ before = after
theorem certifiedExactSteps_succ_decreases
    (steps : CertifiedExactSteps (n + 1) before after) :
  hydraOrdinal after < hydraOrdinal before
theorem certifiedTransitivePredecessor_wellFounded :
  WellFounded CertifiedTransitivePredecessor
```

# 思维脉络（thinking trace）

定义选择“精确步数递归”而非直接使用不透明闭包，使零步分支在定义上就是等式。正步下降对 `n` 归纳：一步时调用已有 `certifiedStep_decreases`；多一步时把剩余轨迹下降与首步下降用严格次序传递性连接。良基性方面，先把本库非空多步关系嵌入 `Relation.TransGen CertifiedPredecessor`，再复用上一条一阶前驱的良基性及 `WellFounded.transGen`，最后限制回本库公开闭包。

# 自然语言 ↔ Lean 映射

“恰好走 `n` 步”对应 `CertifiedExactSteps n`，“零步原地不动”对应 `certifiedExactSteps_zero_iff`。“至少走一步”通过自然数写成 `n+1`，而“忘掉具体正步数”对应 `CertifiedTransitiveStep` 中的存在量词。“把每步下降串起来”对应 `certifiedExactSteps_succ_decreases` 的自然数归纳，“标准非空传递闭包”对应 `Relation.TransGen`，“按所有非空可达后继归纳”对应 `certifiedTransitiveStep_induction`。

# 依赖（人话版）

依赖认证单步的严格序数下降、认证前驱关系的良基性，以及 Mathlib 对关系非空传递闭包的通用结构与良基保持定理。精确步数关系、非空多步关系及端点下降均由本库定义和证明。这里没有把普通 `Hydra.Step` 混入认证关系，也没有借助完整 Hydra 终止结论。

# 应用与陷阱

该接口适合证明“只要从某树经至少一个认证步骤到达另一树，某个秩或不变量如何变化”，也支持按所有非空有限可达状态归纳。最常见陷阱是把零步也说成严格下降：本条明确规定零步只给端点相等，严格结论的参数必须形如 `n+1`。此外，多步关系的每一段都必须是 `CertifiedStep`；它不覆盖普通 Hydra 步骤，不给出可计算步数上界，也不蕴含完整 Hydra 游戏终止或 PA 不可证性。
