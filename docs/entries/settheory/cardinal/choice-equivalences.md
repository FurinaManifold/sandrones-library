---
id: settheory.cardinal.choice-equivalences
kind: theorem
state: verified
title: "选择公理、良序定理与 Zorn 引理的等价地位"
premises: ["settheory.zorn.zorn", "settheory.ordinal.order-type"]
mathlib: ["Classical.choice", "WellOrderingRel"]
provenance: {source_type: book, ref: "Thomas Jech, The Axiom of Choice, Chapters 1-2"}
---

# 三种看似不同的原则

选择公理、良序定理与 Zorn 引理谈论的对象完全不同，却在通常集合论中彼此等价：接受其中任意
一条，就能证明另外两条。

- 选择公理：一族非空集合可以同时各选一个元素。
- 良序定理：每个集合都能排成良序，即每个非空子集都有最小元。
- Zorn 引理：若偏序集中每条链都有上界，则存在极大元。

# 选择函数究竟是什么

若 `A i` 是第 `i` 个非空类型，选择函数是一个依赖函数 `f : ∀ i, A i`：输入指标 `i`，输出
属于对应纤维的元素。定义

```lean
def ChoiceFor (A : ι → Type) : Prop :=
  (∀ i, Nonempty (A i)) → Nonempty (∀ i, A i)
```

强调“同时”很重要：对每个 `i` 单独知道存在元素，不自动提供一个随 `i` 一致变化的函数。

# 良序化原则

```lean
def WellOrderable (α : Type) : Prop :=
  ∃ r : α → α → Prop, IsWellOrder α r
```

这里不是说集合原来已有自然顺序，而是断言至少存在某种良序。例如实数的通常大小顺序不是良序，
但在选择公理下，实数仍存在某种通常无法显式写出的良序。

# 等价证明的路线图

- 选择公理推出良序定理：用选择函数不断从尚未选取的余集取下一项，经超限递归得到良序。
- 良序定理推出选择公理：先良序化所有候选，再从每个非空集合取其最小元。
- 选择公理推出 Zorn：沿良序不断扩张相容链，直到无法继续，所得元素极大。
- Zorn 推出选择公理：考虑所有“部分选择函数”，按扩张关系使用 Zorn 得到极大者；若仍漏掉某个
  非空纤维，就能再扩张，与极大性矛盾。

# Lean 中的基础边界

Lean/mathlib 的经典环境已经提供 `Classical.choice` 和全局良序关系，同时现有
`settheory.zorn.zorn` 已提供 Zorn 形式。因此 `choice_and_wellOrder_available` 展示前两种原则在
当前基础中的可用性，而不是假装在一个没有选择公理的弱元理论中重新证明独立的等价性。

这是重要的诚实边界：形式化系统把选择作为环境公理后，“A 推出 B”的证明可能暗中再次使用选择，
不能据此宣称完成了无选择基础上的反向推导。教材中的等价路线由上节明确记录。

# 常见混淆

- 极大元不一定是最大元；极大只表示没有严格更大的可比较元素。
- 良序定理不说通常顺序就是良序，而是说存在某个良序。
- 有限集合族的逐项选择可显式完成；完整选择公理处理任意集合族。
- 本条登记等价地位，不把 Lean 环境中的 `Classical.choice` 误称为由库内 Zorn 定理“无公理推出”。

