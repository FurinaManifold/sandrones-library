---
id: settheory.cardinal.classical-choice-wellordering
kind: theorem
state: verified
title: "经典基础中的选择原则与良序原则可用性"
premises: []
mathlib: ["Classical.choice", "WellOrderingRel"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机

许多集合论构造需要从任意非空族中同时选取元素，或先把任意类型排成良序。Lean/mathlib 的经典基础已经允许这两类操作。本条准确记录它们在当前环境中的可用性，而不是宣称重新证明了选择公理、良序定理与 Zorn 引理的三方等价。

# 直觉

“每个篮子非空”只给出逐篮子的存在性；选择原则把这些局部存在组合成一个统一选择函数。良序原则则说每个类型都存在某种良序，不要求它是熟悉或可计算的顺序。经典环境预先提供二者，所以可以安全地作为后续证明工具使用。

# 陈述（自然语言）

对任意非空类型族 `A i`，经典选择可产生依赖选择函数 `f : ∀ i, A i`。对任意类型 `α`，经典良序设施可提供关系 `r` 使 `α` 在 `r` 下良序。本条公开定理同时给出这两个可用性结论；它没有定义 Zorn 原则，也没有证明三项原则之间任何无选择基础上的双向蕴含。

# 陈述（Lean 对照）

```lean
def ChoiceFor (A : ι → Type) : Prop :=
  (∀ i, Nonempty (A i)) → Nonempty (∀ i, A i)

def WellOrderable (α : Type) : Prop :=
  ∃ r : α → α → Prop, IsWellOrder α r

theorem choice_and_wellOrder_available (A : ι → Type) (α : Type) :
    ChoiceFor A ∧ WellOrderable α
```

证明使用 `Classical.choice` 和全局良序关系。公开定理的结论只有一个合取，不含 `↔`，也没有 Zorn 项。

# 思维脉络（thinking trace）

先把“选择”写成从逐纤维 `Nonempty` 到依赖函数 `Nonempty` 的命题，再把“可良序化”写成存在良序关系。由于当前 Lean 基础已经经典化，证明只需调用环境能力。这样既为后续条目建立稳定接口，又不会把使用现成选择公理误写成选择公理的推导。

# 自然语言 ↔ Lean 映射

- 非空集合族 ↔ `A : ι → Type` 与 `∀ i, Nonempty (A i)`。
- 同时选择 ↔ `Nonempty (∀ i, A i)`。
- 存在某种良序 ↔ `WellOrderable α`。
- 两项在经典环境可用 ↔ `choice_and_wellOrder_available`。
- `Classical.choice`、`WellOrderingRel` ↔ 环境基础／证明后端，不是本库推出的结论。

# 依赖（人话版）

逻辑上依赖 Lean/mathlib 已采用的经典选择设施。历史版本曾把 Zorn 与序数序型列作课程路线背景；
本次降级后，frontmatter 已删除这些 premises，当前为空列表。真正的“选择公理、良序定理、Zorn
引理等价”仍需在明确的无选择弱基础中分别定义三个原则并证明各个方向。

# 应用与陷阱

该接口可用于选代表元、给类型良序化和构造初始序数。不要把存在的良序误认为原有通常顺序，也不要把 `Nonempty` 误当成可执行数据。最重要的边界是：本条仅证明经典环境中的可用性；三原则等价尚未形式化，不能据此将 ROADMAP 的等价项目标为完成。
