---
id: complex-analysis.singularity.classification-foundation
family: complex-analysis.singularity
variant: foundation
kind: theorem
state: verified
title: 孤立奇点分类的基础接口
summary: 定义可去、极点与本性奇点，证明逻辑三分并在 MeromorphicAt 下桥接阶数
premises: [complex-analysis.holomorphic.definition]
mathlib: [MeromorphicAt, meromorphicOrderAt, tendsto_nhds_iff_meromorphicOrderAt_nonneg, tendsto_cobounded_iff_meromorphicOrderAt_neg]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

只有先要求函数在某个删去圆盘上全纯，才能准确谈孤立奇点的三种类型。

# 直觉

穿孔极限有限时奇点可去；函数逃离每个有界集时是极点；在孤立前提下，两者都不是就是本性奇点。

# 陈述（自然语言）

每个孤立奇点按上述定义落入可去、极点或本性一类。若另有 `MeromorphicAt f a`，则阶数非负等价于可去，阶数为负等价于极点，所以 meromorphic germ 不是本性奇点。

# 陈述（Lean 对照）

```lean
def IsolatedSingularityAtTextbook ...
def RemovableSingularityAtTextbook ...
def PoleAtTextbook ...
def EssentialSingularityAtTextbook ...
theorem isolatedSingularity_classification ...
theorem removableSingularityAtTextbook_iff_order_nonneg ...
theorem poleAtTextbook_iff_order_neg ...
theorem meromorphicAt_not_essential ...
```

# 思维脉络（thinking trace）

先以删去圆盘上的 `HolomorphicOnTextbook` 定义孤立性，再以有限极限和 cobounded 极限定义前两类，本性类作为剩余情形。对两谓词依次排中得到逻辑三分。仅在假设 `MeromorphicAt` 后调用 Mathlib 的 order 等价定理。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 删去圆盘全纯 | `HolomorphicOnTextbook f (ball a r \ {a})` |
| 穿孔邻域 | `nhdsWithin a {a}ᶜ` |
| 趋向无穷 | `Bornology.cobounded ℂ` |
| meromorphic 阶数 | `meromorphicOrderAt f a` |

# 依赖（人话版）

`HolomorphicOnTextbook` 提供教材全纯前提。Mathlib 的两个 order 定理分别把非负阶与有限极限、负阶与 cobounded 极限对齐。

# 应用与陷阱

该 foundation 可为可去奇点定理、极点阶数和留数接口铺路。`MeromorphicAt` 要求有限次幂清除奇性，只覆盖可去与有限阶极点；绝不能冒充包含本性奇点的完整孤立奇点理论。
