---
id: settheory.googology.hydra-one-level-descent
kind: theorem
state: verified
title: "含阶段复制的一层 Hydra 砍头严格下降"
premises: ["settheory.googology.hydra-ordinal-assignment"]
mathlib: ["Ordinal.opow_mul_lt_opow", "Ordinal.natCast_lt_omega0"]
provenance: {source_type: book, ref: "kirby-paris-independence-1982"}
---

# 动机

上一条只证明了根旁最右头的删除会下降；这种步骤没有发生 Hydra 游戏最有特色的“砍一头、复制多枝”。要真正推进终止分析，至少应验证一个包含阶段参数的深层步骤。本条选择最小但不退化的形状：身体只有一个父分支，该父分支只有一个头。砍头后父分支变空，却会在身体处复制 `stage + 1` 份。节点数可随阶段增大，而序数赋值仍应下降。

# 直觉

砍之前，唯一父分支含一个叶头。叶头使父分支的值为 `1`，所以整个 Hydra 的贡献是 `ω¹=ω`。砍之后，每个空父分支的值为 `0`，每一份只贡献 `ω⁰=1`；无论阶段多大，`stage + 1` 份仍只是某个有限序数。每个有限序数都小于 `ω`，所以这次复制虽然可能制造许多节点，却不能抵消指数从 `1` 降到 `0` 带来的序数下降。

# 陈述（自然语言）

先证明一般关键不等式：任意序数层级 `level` 和任意有限份数 `copies`，`ω^level` 的 `copies` 次本库重复和严格小于 `ω^(level+1)`。然后定义一层复制砍头：旧树固定为“根—父节点—叶头”，新树是 `stage + 1` 个空父节点。该形状确实由上一条 `chop stage` 在路径 `[0,0]` 的单步产生，并且对每个自然数阶段，其结构序数赋值都严格下降。

# 陈述（Lean 对照）

```lean
theorem ordinalRepeat_omegaPow_lt_succ
    (level : Ordinal) (copies : Nat) :
    ordinalRepeat (ordinalPow Ordinal.omega0 level) copies <
      ordinalPow Ordinal.omega0 (Order.succ level)

def OneLevelReplicatedCut (stage : Nat) (before after : Hydra) : Prop :=
  before = .node [.node [Hydra.head]] ∧
    after = .node (List.replicate (stage + 1) (.node []))

theorem oneLevelReplicatedCut_verified
    (cut : OneLevelReplicatedCut stage before after) :
    Hydra.Step stage before after ∧
      hydraOrdinal after < hydraOrdinal before
```

# 思维脉络（thinking trace）

证明先处理序数侧，再接树侧。`ordinalRepeat` 公开定义为本库 `ordinalAdd` 的递归；私有证明桥说明它等于同一项右乘有限序数。`ordinalPow` 与 `ordinalMul` 同样只在私有桥中转到 Mathlib 后端，从 `copies < ω` 和 `level < succ level` 得到有限份 `ω^level` 小于下一幂。树侧则直接计算 `[0,0]` 路径，确认结果不是人为挑选的比较对象，而是 `Hydra.Step` 的真实阶段再生。最后把复制森林公式和一般序数不等式组装起来。

# 自然语言 ↔ Lean 映射

“根—父—头”对应 `.node [.node [Hydra.head]]`，“砍头后的空父节点”对应 `.node []`，“阶段复制”对应 `List.replicate (stage + 1) (.node [])`。“这确实是一局游戏”对应 `oneLevelReplicatedCut_isStep`，“复制后仍下降”对应 `oneLevelReplicatedCut_decreases`。有限份同阶项对应 `ordinalRepeat (ordinalPow omega0 level) copies`，指数提高一级对应 `ordinalPow omega0 (Order.succ level)`。

# 依赖（人话版）

依赖有限 Hydra 的可执行 `chop`、上一条结构序数赋值、复制森林公式，以及本库已经定义的序数加法、乘法和幂。公开定理仍使用 `ordinalRepeat` 与 `ordinalPow`；Mathlib 原生乘法和幂只在私有正确性桥中帮助调用“有限系数小于 `ω` 时，较低幂的有限倍仍低于较高幂”这一序数不等式。没有把原生运算冒充成本库定义。

# 应用与陷阱

本条首次覆盖了份数随 `stage` 变化的真实深层复制步骤，说明节点数增长和序数下降可以同时发生。关键不等式可供以后处理父树删头后指数降低的更一般形状。不过，`OneLevelReplicatedCut` 只含一个父分支且该父分支原先只有一个头；它没有处理父节点保留其他孩子、根有前后兄弟分支、任意深路径或孩子顺序造成的序数加法吸收。因此本条不证明所有 `Hydra.Step` 下降，也不证明完整游戏终止、`ε₀` 上界或 PA 不可证性。
