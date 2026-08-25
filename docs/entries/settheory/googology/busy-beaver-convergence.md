---
id: settheory.googology.busy-beaver-convergence
kind: theorem
state: verified
title: "有限燃料 Busy Beaver 候选的最终稳定"
premises: ["settheory.googology.busy-beaver-candidate", "settheory.googology.busy-beaver-existence"]
mathlib: []
provenance: {source_type: derivation, ref: "rado-non-computable-functions-1962"}
---

# 动机

固定燃料的 `busyBeaverCandidate` 可以实际穷举，但可能漏掉稍后才停机的机器；经典
`classicalBusyBeaverValue` 覆盖所有最终停机机器，却由经典选择构造而不可直接计算。本条说明这两个
层次并不冲突：不断增加燃料时，有限候选最终会达到经典值，而且达到后不会再改变。

# 直觉

多给机器一些运行时间，不会抹掉已经停机的成绩：机器一旦停机，后续执行保持同一最终纸带。因此
每台机器的限定分数只会保持或上升，所有机器的最高分也一样。经典冠军终究在某个有限时刻停机；
燃料超过那个时刻后，有限搜索已经看见冠军，同时又不可能超过经典冠军，于是两边相等。

# 陈述（自然语言）

对固定机器，`boundedOnesScore fuel machine` 关于 `fuel` 单调；所以固定状态数的
`busyBeaverCandidate n fuel` 也单调。任意有限燃料候选都不超过 `classicalBusyBeaverValue n`。
此外存在某个自然数阈值，使每个不小于该阈值的燃料都让有限候选恰好等于经典值。

# 陈述（Lean 对照）

```lean
theorem boundedOnesScore_mono (machine : BinaryMachine (n + 1)) :
  Monotone (fun fuel => boundedOnesScore fuel machine)
theorem busyBeaverCandidate_mono (n : ℕ) :
  Monotone (busyBeaverCandidate n)
theorem busyBeaverCandidate_le_classical (n fuel : ℕ) :
  busyBeaverCandidate n fuel ≤ classicalBusyBeaverValue n
theorem exists_threshold_candidate_eq_classical (n : ℕ) :
  ∃ threshold, ∀ fuel, threshold ≤ fuel →
    busyBeaverCandidate n fuel = classicalBusyBeaverValue n
```

# 思维脉络（thinking trace）

先证明多步执行的加法分解：先跑 `first` 步再跑 `extra` 步，等于一次跑 `first+extra` 步；再证明
停机状态对任意后续步数都是吸收态。于是若机器在较小燃料时未停，其分数是零；若已经停机，增加
燃料仍留下同一纸带。这给出逐机单调性，有限上确界继承单调性。经典值规格提供全局上界和冠军
机器；既有桥定理给出一个燃料使候选等于经典值，随后用单调下界和经典上界夹出永久相等。

# 自然语言 ↔ Lean 映射

- “增加燃料” ↔ `first ≤ later`。
- “先跑一段再跑剩余步数” ↔ 私有引理 `runSteps_add`。
- “停机后纸带不再变化” ↔ 私有引理 `runSteps_halted`。
- “单台机器成绩不下降” ↔ `boundedOnesScore_mono`。
- “全体机器最高分不下降” ↔ `busyBeaverCandidate_mono`。
- “始终受经典值控制” ↔ `busyBeaverCandidate_le_classical`。
- “达到后永久稳定” ↔ `exists_threshold_candidate_eq_classical`。

# 依赖（人话版）

依赖可执行的有限候选值、无时间界最大值关系，以及上一条已经证明满足该关系的
`classicalBusyBeaverValue`。本条复用 `exists_candidate_eq_of_isValue` 取得某个冠军停机燃料；不重新
定义机器、停机关系或经典值。证明只使用自然数序、有限上确界和本库确定执行语义。

# 应用与陷阱

该定理允许下游把经典值理解为有限候选序列的“最终常值”，也能证明任何超过稳定阈值的完整有限
搜索都返回正确答案。但这里只证明 `∃ threshold`，没有给出计算阈值的方法；不能据此设计一个知道
何时停止扩大燃料的算法。本条同样没有证明经典值不可计算。稳定是每个固定 `n` 分别成立，不能
误读为存在一个同时适用于全部状态数的统一燃料界。
