---
id: settheory.googology.hydra-certified-step-well-founded
kind: theorem
state: verified
title: "认证 Hydra 步骤的良基关系与归纳原理"
premises: ["settheory.googology.hydra-certified-play-termination"]
mathlib: ["WellFounded.onFun", "WellFounded.mono", "WellFounded.induction"]
provenance: {source_type: book, ref: "kirby-paris-independence-1982"}
---

# 动机

“不存在无限认证轨迹”适合排除反例，却不是下游证明最方便的接口。若要证明每棵 Hydra 都满足某个性质，常见做法是假设所有一步认证后继已经满足，再推出当前树满足；这需要一个真正的良基关系和相应归纳原理。本条把上一条的轨迹结论提升为 Lean 可复用的 `WellFounded`、`Acc` 和归纳接口，使后续无需反复手工构造无限下降链。

# 直觉

游戏记号习惯写“旧树走到新树”，即 `CertifiedStep before after`；良基关系却把较小对象写在前面，即 `r after before`。因此先把参数倒过来定义 `CertifiedPredecessor`。每个认证后继的结构序数都更小，所以这条关系包含在“按结构序数比较”的关系中。序数小于已经良基，把它沿秩函数拉回 Hydra，再限制到认证步骤，所得关系仍然良基。

# 陈述（自然语言）

`CertifiedPredecessor after before` 当且仅当存在从 `before` 到 `after` 的认证游戏步骤。该前驱关系良基，因此任意起始 Hydra 对它都是可达的 `Acc` 对象。更具体地，若要证明性质 `P` 对所有 Hydra 成立，只需证明：对任意当前树 `before`，只要 `P` 对它的每一个认证后继 `after` 成立，就能推出 `P before`。此时良基归纳给出 `P` 对所有树成立。

# 陈述（Lean 对照）

```lean
def CertifiedPredecessor (after before : Hydra) : Prop :=
  CertifiedStep before after

theorem certifiedPredecessor_wellFounded :
  WellFounded CertifiedPredecessor

theorem certifiedStep_accessible (before : Hydra) :
  Acc CertifiedPredecessor before

theorem certifiedStep_induction {P : Hydra → Prop}
    (step : ∀ before,
      (∀ after, CertifiedStep before after → P after) → P before) :
    ∀ before, P before
```

# 思维脉络（thinking trace）

证明先固定秩函数 `rank h = hydraOrdinal h`。序数严格小于关系的良基性通过 `WellFounded.onFun` 拉回为“`rank after < rank before`”的 Hydra 关系。上一条 `certifiedStep_decreases` 证明每个 `CertifiedPredecessor after before` 都属于这个较大的秩关系，于是 `WellFounded.mono` 将良基性限制到认证前驱。`Acc` 直接取良基关系对任意元素的可达证明；最后展开良基归纳，将前驱假设重新翻译成下游熟悉的 `CertifiedStep before after`。

# 自然语言 ↔ Lean 映射

“前向走一步”对应 `CertifiedStep before after`，“新树是旧树的良基前驱”对应参数倒置的 `CertifiedPredecessor after before`。“用序数给树编号”对应 `rank : Hydra → Ordinal`，“沿编号拉回序数次序”对应 `InvImage (· < ·) rank`。“从任意树向下归纳”对应 `certifiedStep_accessible`，“假设所有认证后继再证当前树”精确对应 `certifiedStep_induction` 中的二层全称量词。

# 依赖（人话版）

依赖上一条认证步骤使结构序数严格下降，以及本库序数严格次序的良基性。Mathlib 只提供三个一般关系工具：沿函数拉回良基关系、把良基性限制到子关系、执行良基归纳。具体秩、具体下降证明和具体认证关系均来自本库。`no_certifiedInfinitePlay` 提供相同数学直觉，但本证明直接从秩函数构造良基接口，不把逻辑结论反向黑箱转换。

# 应用与陷阱

下游可以用 `certifiedStep_induction` 定义或证明沿所有认证后继递归的性质，例如证明某种证书策略下的结果满足不变量。需要注意参数方向：`CertifiedPredecessor after before` 与游戏书写顺序相反，这是 `WellFounded` 所要求的“更小者在前”。该接口只量化 `CertifiedStep` 后继，不包括没有最右脊柱证书的普通 `Hydra.Step`；它也不产生可计算的最大步数、复杂度界、完整 Hydra 终止定理或 PA 不可证性结论。
