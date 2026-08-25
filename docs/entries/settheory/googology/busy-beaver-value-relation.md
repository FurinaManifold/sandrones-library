---
id: settheory.googology.busy-beaver-value-relation
kind: definition
state: verified
title: "经典 Busy Beaver 的最大值关系与有限候选桥"
premises: ["settheory.googology.unbounded-halting-relation", "settheory.googology.busy-beaver-candidate"]
mathlib: ["Finset.sup"]
provenance: {source_type: book, ref: "rado-non-computable-functions-1962"}
---

# 动机

有限燃料候选会漏掉运行很久才停机的机器，所以不能直接称为经典 Busy Beaver 值。另一方面，
在正式证明最大值存在之前若贸然定义一个自然数值，就可能把尚未建立的存在性藏进非构造选择。
稳妥做法是先定义“某自然数确实是全部停机输出的最大值”这一关系。

# 直觉

一个数 `value` 要获得 Busy Beaver 冠军分数的资格，必须同时过两关：任何最终停机机器留下的
`1` 都不能比它多，而且确实有某台机器留下恰好这么多个 `1`。第一关说明它是上界，第二关说明
上界能被取得；二者合起来是“最大值”，不只是一个可能过大的上界。

# 陈述（自然语言）

`IsBusyBeaverValue n value` 表示：每台 `n+1` 状态二符号机器的每个停机输出分数都不超过
`value`，并且某台机器最终取得 `value`。若该关系成立，则任意固定燃料候选都不超过 `value`；
冠军机器在某个有限时刻停机，所以存在燃料使候选恰好等于 `value`。满足关系的值至多一个。

# 陈述（Lean 对照）

```lean
def IsBusyBeaverValue (n value : ℕ) : Prop :=
  (∀ machine : BinaryMachine (n + 1), ∀ score,
    HasHaltingOnesScore machine score → score ≤ value) ∧
  ∃ machine : BinaryMachine (n + 1), HasHaltingOnesScore machine value
theorem busyBeaverCandidate_le_of_isValue (hvalue : IsBusyBeaverValue n value) (fuel) :
  busyBeaverCandidate n fuel ≤ value
theorem exists_candidate_eq_of_isValue (hvalue : IsBusyBeaverValue n value) :
  ∃ fuel, busyBeaverCandidate n fuel = value
theorem isBusyBeaverValue_unique (hx : IsBusyBeaverValue n x)
    (hy : IsBusyBeaverValue n y) : x = y
```

# 思维脉络（thinking trace）

对固定燃料枚举每台机器：仍运行者的限定分数是零，自然不超过 `value`；已停机者的纸带给出
`HasHaltingOnesScore` 见证，故由最大值关系的上界部分控制。对全部机器取有限上确界便得到候选
上界。再取最大值关系提供的冠军机器及其停机步数，此时冠军的限定分数正是 `value`，候选又不小
于任何单机分数，因此两边夹出等号。两个最大值则互相用对方的上界性质比较。

# 自然语言 ↔ Lean 映射

- “所有停机输出都不超过” ↔ `∀ machine score, HasHaltingOnesScore ... → score ≤ value`。
- “冠军确实存在” ↔ `∃ machine, HasHaltingOnesScore machine value`。
- “有限搜索是下界近似” ↔ `busyBeaverCandidate_le_of_isValue`。
- “冠军停机后候选命中真值” ↔ `exists_candidate_eq_of_isValue`。
- “最大值至多一个” ↔ `isBusyBeaverValue_unique`。

# 依赖（人话版）

依赖无时间界停机输出关系和此前的有限燃料候选。mathlib 的 `Finset.sup` 只用于“有限机器列表
中每项受界，则其上确界受界”；机器语义、停机分数和经典最大值关系均由本库明确定义。

# 应用与陷阱

该关系给出了连接有限实验与经典问题的严格接口：在真值关系成立的前提下，候选不会越界并最终
命中。当前条目只证明条件式桥梁和唯一性，尚未证明对每个状态数都有 `value` 满足该关系，因此
没有定义总函数 `busyBeaver : ℕ → ℕ`。它也完全没有证明 Busy Beaver 不可计算；不得把关系定义、
条件式结论或“增长很快”的直觉冒充不可计算性定理。
