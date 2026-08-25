---
id: topology.homotopy.equivalence-standard
family: topology.homotopy
variant: mathlib-two-sided-inverse
kind: definition
state: staging
title: 标准同伦等价与双侧同伦逆
summary: 以 Mathlib HomotopyEquiv 承载双侧同伦逆，证明存在关系的反身、对称、传递并给出同胚桥
premises: [topology.foundation.structure, topology.homotopy.standard]
mathlib: [ContinuousMap.HomotopyEquiv, ContinuousMap.HomotopyEquiv.refl, ContinuousMap.HomotopyEquiv.symm, ContinuousMap.HomotopyEquiv.trans, Homeomorph.toHomotopyEquiv]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

同胚要求空间之间存在严格互逆的连续映射，通常比拓扑不变量真正需要的条件更强。同伦等价允许两个复合只在连续变形意义下回到恒等映射，是同伦论中空间“具有相同形状”的基本判据。

# 直觉

正向映射 `f:X→Y` 与候选逆 `g:Y→X` 不必逐点互逆，但“先去再回”必须能连续变形成在 `X` 上不动，“先回再去”也必须能在 `Y` 上连续变形成不动。左右两个条件缺一不可。

# 陈述（自然语言）

`X` 与 `Y` 之间存在同伦等价，当且仅当存在连续映射 `f:X→Y`、`g:Y→X`，满足 `g∘f` 同伦于 `id_X` 且 `f∘g` 同伦于 `id_Y`。同伦等价的存在对空间满足反身性、对称性与传递性。每个同胚都自然给出同伦等价，而且其正向函数不变。

# 陈述（Lean 对照）

```lean
theorem nonempty_homotopyEquiv_iff_exists_two_sided_homotopy_inverse :
  Nonempty (X ≃ₕ Y) ↔
    ∃ f : C(X, Y), ∃ g : C(Y, X),
      (g.comp f).Homotopic (ContinuousMap.id X) ∧
      (f.comp g).Homotopic (ContinuousMap.id Y)
```

`nonempty_homotopyEquiv_refl/symm/trans` 给出存在关系的三个闭包性质；`homeomorph_toHomotopyEquiv_apply` 给出同胚桥的逐点公式。

# 思维脉络（thinking trace）

存在刻画正向拆出 `toFun`、`invFun`、`left_inv`、`right_inv`，反向把同样四项数据装回标准结构。反身性来自恒等同胚，对称性交换两个映射与两侧同伦，传递性复合正向映射和逆向映射并用一般同伦的复合与传递消去中间往返。同胚的严格逆等式自动给出所需同伦。

# 自然语言 ↔ Lean 映射

“同伦等价”对应 `X ≃ₕ Y`；“正向映射／候选逆”对应 `toFun/invFun`；“回到 `X`”对应 `left_inv`；“回到 `Y`”对应 `right_inv`；“交换方向”对应 `HomotopyEquiv.symm`；“复合同伦等价”对应 `HomotopyEquiv.trans`；“同胚桥”对应 `Homeomorph.toHomotopyEquiv`。

# 依赖（人话版）

本条目依赖标准一般同伦及其复合，以及已经解释的连续映射和同胚。教材定位为 Hatcher 第 0 节。Mathlib `HomotopyEquiv` 的字段与教材双侧同伦逆定义一致，因此直接作为正式承载；旧本库同伦等价结构不参与新链。

# 应用与陷阱

同伦等价不要求 `f`、`g` 双射，也不要求两个复合严格等于恒等映射。同胚蕴含同伦等价，但本条目没有也不能声称一般同伦等价必为同胚。本批尚未证明具体空间同伦等价、基本群不变性或其他拓扑不变量保持；集成等待 T4-H2。
