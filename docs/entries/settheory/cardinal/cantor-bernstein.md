---
id: settheory.cardinal.cantor-bernstein
kind: theorem
state: verified
title: "Cantor–Bernstein 定理"
premises: ["settheory.cardinal.equinumerous", "settheory.cardinal.comparison"]
mathlib: ["Embedding.schroeder_bernstein", "Equiv.ofBijective"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机

在无限集合之间直接写出双射通常困难，构造单射却往往容易。Cantor–Bernstein 把两个方向“都放得进去”升级为真正的一一配对，是用比较关系证明等势的核心工具。

# 直觉

把 `α`、`β` 画成左右两列，并画出两条单射的边。单射保证每个点的入边至多一条；沿连通分量分析双向无限链、环和带起点的链，再在不同分量选择正向边或反向边，便可使每个点恰好配对一次。

# 陈述（自然语言）

若 `α` 能单射到 `β`，同时 `β` 能单射到 `α`，则 `α` 与 `β` 等势。结论只保证存在某个双射，不声称输入的两个单射互为逆。

# 陈述（Lean 对照）

```lean
theorem cantor_bernstein
    (hαβ : CardinalLE α β) (hβα : CardinalLE β α) :
    Equinumerous α β
```

`CardinalLE` 和 `Equinumerous` 是本库公开接口。`Embedding.schroeder_bernstein` 是 mathlib 的证明后端，负责从两个嵌入构造双射函数；`Equiv.ofBijective` 再把函数及双射性打包成 `Equiv`。

# 思维脉络（thinking trace）

先展开两个 `CardinalLE`，取得 `f : α → β`、`g : β → α` 及各自单射证明。把它们包装为 embedding 后交给 Schröder–Bernstein 后端完成分量选择，得到双射数据；最后打包为 `α ≃ β` 并放入 `Nonempty`，正好满足 `Equinumerous`。

# 自然语言 ↔ Lean 映射

- “两个方向都能嵌入” ↔ `hαβ : CardinalLE α β` 与 `hβα : CardinalLE β α`。
- “两集合等势” ↔ `Equinumerous α β`。
- “按连通分量重选配对” ↔ `Embedding.schroeder_bernstein` 的内部证明工作。
- “把双射函数变成等价” ↔ `Equiv.ofBijective`，属于实现桥。

# 依赖（人话版）

依赖本库的等势与单射比较定义。数学证明不要求先良序化所有集合；Lean 中复用 mathlib 已验证的 Schröder–Bernstein 构造，而不是在本条重新实现整套分量递归。

# 应用与陷阱

它可把 `CardinalLE` 的双向成立解释为等势，构成未来反对称接口的数学核心。必须提供相反方向的两条单射；两个同方向单射无效。也不能直接令 `g` 为 `f` 的逆，因为输入函数可能完全无关。
