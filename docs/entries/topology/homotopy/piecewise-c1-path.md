---
id: topology.homotopy.piecewise-c1-path
family: topology.homotopy
variant: inductive-concat-closure
kind: definition
state: verified
title: 分段 C1 道路及开集内正则替换
summary: 将分段 C1 性定义为 Mathlib 道路上由整体 C1、拼接和端点 cast 生成的归纳命题，证明常道路、线段、反向、有限 concat 与折线替换的闭合性
premises: [topology.homotopy.path-polygonal-approximation]
mathlib: [Path, Path.trans, Path.cast, Path.symm, ContDiffOn, IsOpen, NormedSpace]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

连续道路足以定义基本群，但曲线积分和后续光滑拓扑论证还需要有限分段的正则性。R3a 已证明落在
开集内的道路可以相对端点同伦到折线路径；本条目给出能够真实包含整体 C1 道路、又能直接认证
这些有限折线的正式承载。

# 教材直觉

教材中的分段 C1 道路由有限条 C1 道路首尾拼接而成。这里不把道路替换成新的“带断点道路”类型，
而是在既有 Mathlib `Path` 上记录一个命题：整体 C1 道路是基本情形；两条已经认证的道路可以拼接；
端点类型相等带来的 cast 不改变正则性。因此一个证明项就是一棵有限拼接树。

# 定义与边界

`Path.PiecewiseC1 γ` 有三个构造子：

1. `of_contDiffOn` 要求 `γ.extend` 在实区间 `[0,1]` 上为 `C¹`；
2. `trans` 对 Mathlib 的 `Path.trans` 闭合；
3. `cast` 对端点等式产生的 `Path.cast` 闭合。

这一定义刻画由 Mathlib 实际拼接参数化生成的有限二叉树。当前没有证明它等价于“存在任意有限
实数断点，使每个限制分别 C1”的另一种教材表述，因此不能把任意断点版等价性当作已完成结果。

# Lean 对照

```lean
inductive Path.PiecewiseC1 : {x y : E} → Path x y → Prop
  | of_contDiffOn ...
  | trans ...
  | cast ...

theorem Path.piecewiseC1_refl ...
theorem Path.piecewiseC1_segment ...
theorem Path.piecewiseC1_concat ...
theorem Path.PiecewiseC1.symm ...
theorem Path.meshPolygonal_piecewiseC1 ...
theorem Path.exists_piecewiseC1_range_subset_open_and_homotopyWithin ...
```

# 证明思路

常道路由常函数的 `ContDiffOn` 得到；线段使用 Mathlib 仿射 line map 的光滑性。有限 concat 对边数
归纳，并直接使用 `Path.concat_succ` 和归纳构造子 `trans`。反向证明对 PiecewiseC1 证书归纳：整体
C1 情形与光滑反射 `t ↦ 1-t` 复合，拼接情形交换两个反向段，cast 情形交换端点等式。

`meshPolygonal` 展开后是有限条仿射线段的 concat，因此由有限 concat 定理认证。最后直接消费 R3a
已有的开集内折线逼近及完整同伦像集证书，得到分段 C1 replacement theorem。

# 正式承载与桥接

道路、拼接、反向、cast、道路同伦及开集全部直接复用 Mathlib `Path`、`Path.trans`、`Path.symm`、
`Path.cast`、`Path.Homotopy` 和 `IsOpen`，它们与教材对象语义一致。`ContDiffOn ℝ 1 γ.extend (Icc 0 1)`
是“道路在闭参数区间上整体 C1”的正式表达。

本库新增的 `Path.PiecewiseC1` 是必要桥：Mathlib 当前没有恰好对上述三个道路操作闭合的有限分段
C1 谓词。它是既有 `Path` 上的性质，不是第二套道路 carrier，也没有注册全局 instance 或 notation。

# 类型假设

环境空间 `E` 带 `[NormedAddCommGroup E] [NormedSpace ℝ E]`，使导数、仿射线段和凸组合有意义。
定义本身沿用同一环境，避免后续基本性质在不同类型类层级之间迁移。replacement theorem 另要求
`U` 为开集且原道路逐点落在 `U`；它不要求有限维、完备性或开集道路连通。

# 应用与未完成边界

- `piecewiseC1_segment` 和 `piecewiseC1_concat` 可认证折线及有限分段道路。
- `exists_piecewiseC1_range_subset_open_and_homotopyWithin` 同时控制替换道路和整个同伦的像。
- 反向闭合为以后曲线积分方向变换提供正则性输入，但本条目不定义或证明任何积分结论。
- 本结果只正则化一维道路；它没有把任意连续道路同伦正则化成分片 C2 方形。
- T4-R3b-square、一般连续同伦下的积分不变性以及复分析消费者仍属于后续独立批次。
