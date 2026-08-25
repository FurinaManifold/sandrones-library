---
id: topology.fundamental-group.carrier-standard
family: topology.fundamental-group
variant: groupoid-endomorphism-carrier
kind: definition
state: staging
title: 基本群胚与基本群的标准承载
summary: 解释基本群胚的对象、道路同伦类态射及基点自同态群，并给出基本群与环路同伦商的定义性对应
premises: [topology.homotopy.path-homotopy-quotient-standard]
mathlib: [FundamentalGroupoid, FundamentalGroupoid.equiv, FundamentalGroup, FundamentalGroup.toPath, FundamentalGroup.fromPath]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

不同端点之间的道路同伦类可以首尾相接，并且每个类都能用逆道路反向。这些对象共同组成基本群胚；固定一个基点后，只看从该点回到自身的态射，就得到基本群的载体。

# 直觉

群胚是一种每条箭头都可逆的范畴：对象是空间中的点，箭头是点间道路的端点固定同伦类。范畴只要求箭头在端点匹配时才能复合。某个对象到自身的箭头可以任意复合，形成该对象的自同态群；在基本群胚中，这正是基点环路的同伦类。

# 陈述（自然语言）

Mathlib 的 `FundamentalGroupoid X` 只把 `X` 的点包装成对象，并通过 `FundamentalGroupoid.equiv X` 与原点集等价。从对象 `x` 到 `y` 的态射类型定义性地等于 `Path.Homotopic.Quotient x y`。`FundamentalGroup X x` 是对象 `x` 的自同态群，其底层类型定义性地等于 `Path.Homotopic.Quotient x x`。`toPath` 与 `fromPath` 只在这两个视角间转换，两个方向均严格往返。

# 陈述（Lean 对照）

```lean
theorem fundamentalGroupoid_hom_eq_pathHomotopyQuotient :
  (FundamentalGroupoid.mk x ⟶ FundamentalGroupoid.mk y) =
    Path.Homotopic.Quotient x y

theorem fundamentalGroup_eq_loopHomotopyQuotient :
  FundamentalGroup X x = Path.Homotopic.Quotient x x
```

`fundamentalGroupoid_equiv_mk_apply` 说明对象包装不增加数据；两条 `toPath/fromPath` 往返定理给出可操作的载体转换。

# 思维脉络（thinking trace）

先用 `FundamentalGroupoid.equiv` 说明对象 wrapper 不增加空间点。Mathlib 的 `Groupoid` 实例把 Hom 字段直接指定为道路同伦商，因此 Hom 类型等式是 `rfl`。`FundamentalGroup` 又缩写为基点对象的 `End`，所以其载体等式仍是 `rfl`；两种转换只是帮助类型检查器的缩写，往返无需选择代表元。

# 自然语言 ↔ Lean 映射

“群胚对象”对应 `FundamentalGroupoid.mk x`；“群胚与点集的对象对应”对应 `FundamentalGroupoid.equiv`；“从 `x` 到 `y` 的箭头”对应范畴 Hom 记号；“基点自同态群”对应 `FundamentalGroup X x`；“作为环路商类查看”对应 `FundamentalGroup.toPath`；“从环路商类恢复”对应 `FundamentalGroup.fromPath`。

# 依赖（人话版）

本条目依赖标准道路同伦商。范畴由对象、态射、恒等态射和结合复合组成；群胚额外要求每条态射可逆；对象的自同态群是从该对象到自身的全部态射。这里直接复用 Mathlib 的成熟承载，因为对象与 Hom 类型逐项符合教材定义，不另造群胚或基本群结构。

# 应用与陷阱

本条目只解释载体，不发布群乘法、单位、逆元或群律。Mathlib 的群乘法服从范畴复合顺序，未来 F2 必须明确 `p*q` 对应 `q.toPath.trans p.toPath`；本批不得提前加入该公式。连续映射诱导函子、基点变换和基本群计算也全部留在 F2。旧 `LoopHomotopyClasses` 及其 `map/concat/inverse` 只作 legacy，不能成为新标准链的定义来源。
