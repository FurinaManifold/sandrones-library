---
id: settheory.googology.hydra-general-descent
kind: theorem
state: verified
title: "一般 Hydra 单步的序数下降"
premises: ["settheory.googology.hydra-ordinal-assignment", "settheory.ordinal.power-bridge"]
mathlib: ["Ordinal.CNF.eval", "Ordinal.CNF.coeff", "Ordinal.CNF.coeff_eval", "Ordinal.CNF.eval_lt", "Ordinal.opow_mul_lt_opow", "Ordinal.lt_omega0"]
provenance:
  source_type: book
  ref: "kirby-paris-independence-1982"
---

# 动机

既有的 Hydra 下降链只覆盖一族带证书的砍头：从 `HydraOneLevelDescent` 到 `HydraRightmostSpineDescent`，被砍的父分支在每一层祖先处都必须是最右孩子（"最右脊柱"）。真实的 `Hydra.chop` 允许在父节点内部的任意位置砍头，也允许任意深度的路径，所以这些定理的假设并不是游戏本身的限制，而是**旧序数赋值**的限制：列表序求和在头项右侧出现无穷序数时会吸收掉头项的贡献。本条去掉这条限制，对任意合法 `Hydra.Step` 证明结构序数严格下降。

# 直觉

列表序求和 `ω^{v(c₁)} + … + ω^{v(c_k)}` 让头（叶子，值 0）贡献 `ω^0 = 1`。当它右侧还有非叶兄弟时，`1 + B = B`，砍掉这个头完全不改变父节点的值，随后 `stage+1` 份复制反而让整棵树的值上升——所以旧赋值下一般单步不是下降的。补救办法是换成**自然和**（Hessenberg 和）：它把两个序数的 Cantor 正规形系数逐项相加，在每个自变量上严格单调，于是 `1` 永远排在末尾、永不被吸收，砍头一定让父节点值至少减一；再把 `ω^{值}` 的复制与祖先层的替换接上，就得到任意位置、任意深度的严格下降。

# 陈述（自然语言）

给有限有序树（Hydra）重新赋值：一个节点的值是其子森林的自然和，每个子节点贡献 `ω^(子节点值)`；叶子值为 0。则对任意阶段 `stage` 与任意合法单步 `before → after`（即存在一条以叶头结尾的合法路径，`chop stage before path = after`），都有 `after` 的值严格小于 `before` 的值。这里对路径没有任何"最右"要求，对头在父节点内部的位置也没有要求。

# 陈述（Lean 对照）

```lean
theorem hydraStep_generalOrdinal_lt {stage : Nat} {before after : Hydra}
    (h : Hydra.Step stage before after) :
    hydraGeneralOrdinal after < hydraGeneralOrdinal before
```

文件同时把「旧赋值不够」这一判断固化成定理：

```lean
theorem hydraOrdinal_not_general_descent :
    ∃ before after : Hydra, Hydra.Step 1 before after ∧
      hydraOrdinal before < hydraOrdinal after
```

其中 `hydraGeneralOrdinal`/`forestGeneralOrdinal` 是本文件新定义的互相递归赋值，`ordNadd` 是用 `Ordinal.CNF.coeff` 逐点相加、`Ordinal.CNF.eval` 求值定义的自然和。三条支撑引理把"砍头"分解成三种真实形状：`forestGeneralOrdinal_remove_head`（根层砍头：森林值至少减一）、`forestGeneralOrdinal_replicate_lt`（父内砍头后阶段复制：`ω^{V p'}` 的有限倍低于 `ω^{V p}`）、`forestGeneralOrdinal_lt_of_child_lt`（更深层：子节点值严格下降沿任意位置传播）。

# 思维脉络（thinking trace）

1. 先确认旧赋值真的不够：`chop 1 (node [node [head, node [head]]]) [0,0]` 砍掉父内第 0 个头后，父树被复制两份，而列表序求和给出的序数从 `ω^ω` 变成 `ω^ω·2`，反而上升。这条侦察结论最后固化成定理 `hydraOrdinal_not_general_descent`（`ω^ω < ω^ω * 2`，其中 `1 + ω = ω` 是吸收律 `Ordinal.one_add_omega0`）。它决定了本条的走向：不是去加更多形状假设，而是换度量。
2. 换度量的判据是"砍头必须让父节点值至少减一"。列表序求和在右侧有非叶兄弟时做不到（`1+B=B`）；自然和的系数相加让头项 `1` 落在最小指数上，于是 `nadd a 1 = a + 1` 恒成立，判据自动满足。
3. mathlib 没有 `nadd`，所以先用 `Ordinal.CNF.coeff`/`eval` 定义自然和，并证明它可交换、可结合、`nadd a 1 = a+1`、在每个自变量上严格单调。单调性是靠"按最大差异指数三分系数函数"证出来的：高于该指数的部分两边相同，该指数处系数严格更小，低于它的部分都 `< ω^e`。
4. 再把 `chop` 的三种真实分支写成形状引理：`[i]`（根层删头）、`[i,j]`（父内砍头并复制）、`i::j::k::rest`（递归进子节点）。`chop` 的 `do` 记号编译成 `Bind.bind` 与自动生成的匹配子，直接 `simp` 不动它，需要显式展开 `Bind.bind` 并用 `Option.bind_eq_some_iff` 把结果拆成存在量词。
5. 最后对路径做结构归纳（每次递归都把路径缩短一截），三种形状分别调用第 3 步的三条森林引理；阶段复制那一步把 `ω^{V p'}·(stage+1) < ω^{V p}` 交给 `Ordinal.opow_mul_lt_opow`。

# 自然语言 ↔ Lean 映射

- 「自然和」→ `ordNadd a b := Ordinal.CNF.eval ω (Ordinal.CNF.coeff ω a + Ordinal.CNF.coeff ω b)`
- 「自然和加一」→ `ordNadd_one : ordNadd a 1 = a + 1`
- 「自然和在每个自变量上严格单调」→ `ordNadd_lt_ordNadd_right` / `ordNadd_lt_ordNadd_left`
- 「一般序数赋值」→ `hydraGeneralOrdinal` / `forestGeneralOrdinal`（互相递归）
- 「砍头至少减一」→ `forestGeneralOrdinal_remove_head`
- 「阶段复制严格下降」→ `forestGeneralOrdinal_replicate_lt`
- 「更深层下降沿任意位置传播」→ `forestGeneralOrdinal_lt_of_child_lt`
- 「`chop` 的三种结果形状」→ `chop_singleton_eq_some` / `chop_pair_eq_some` / `chop_deep_eq_some`（均 `private`）
- 「任意合法单步下降」→ `hydraStep_generalOrdinal_lt`
- 「旧赋值不是一般下降度量」→ `hydraOrdinal_not_general_descent`（反例：`ω^ω` 与 `ω^ω * 2`）

# 依赖（人话版）

本条只用 `Hydra`、`chop`、`Step` 这套游戏定义（经 `settheory.googology.hydra-ordinal-assignment` 传入）和本库序数幂 `ordinalPow`（`settheory.ordinal.exponentiation`，以及把它接到 mathlib 幂的 `settheory.ordinal.power-bridge`）。序数一侧的载体是 mathlib 的 `Ordinal` 与其 Cantor 正规形接口 `Ordinal.CNF.coeff`/`eval`；`Ordinal.CNF` 在这里只是定义自然和的机制，公开接口上出现的是本库定义的 `ordNadd` 与两个赋值。旧赋值 `hydraOrdinal` 只作为对照出现在文档里，不参与证明。

# 应用与陷阱

应用：这是"消除最右脊柱证书限制"的那一步，后续 `hydra-termination`（一般 Hydra 游戏终止）可以直接把本条接到良基归纳上，不再需要任何最右假设。

陷阱（诚实边界）：本条**不**证明终止——它只给出单步严格下降；把单步下降变成"所有 play 终止"仍需要额外的良基论证与策略量化。它也不覆盖 Kirby–Paris 定理的强度边界（那需要序数记号系统与 PA 的证明论分析）。另外注意：本条的下降是关于**新赋值** `hydraGeneralOrdinal` 的，不是旧赋值 `hydraOrdinal`；旧赋值在一般位置砍头时确实不下降——这一点由本文件的 `hydraOrdinal_not_general_descent` 显式反例证明，而不是仅作说明。最后，`ordNadd` 是库内自建的自然和（mathlib 目前没有 `nadd`），它的公开接口只覆盖本条与后续终止论证所需的代数性质。
