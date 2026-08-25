---
id: topology.homotopy.path-homotopy-standard
family: topology.homotopy
variant: fixed-endpoint-square
kind: definition
state: staging
title: 标准道路同伦与端点固定
summary: 以 Mathlib Path.Homotopy 正式承载道路间的端点固定连续变形，并展开反身、反向和传递运算
premises: [topology.foundation.constructions, topology.foundation.real-line, topology.homotopy.path-definition-foundation]
mathlib: [Path.Homotopy, ContinuousMap.HomotopyRel, Path.Homotopy.refl, Path.Homotopy.symm, Path.Homotopy.trans]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

两条同起点、同终点的道路若能连续互相变形，并且变形过程中起点和终点始终不动，就应代表相同的走法类别。这是道路拼接的单位律、结合律以及基本群取商的正确层级。

# 直觉

把同伦看成正方形上的连续图像：第一坐标 `t` 是变形时间，第二坐标 `s` 是道路位置。正方形的下、上时间切片分别是原道路和目标道路；左右两条边在整个变形中恒等于固定端点 `x`、`y`。

# 陈述（自然语言）

`p` 到 `q` 的标准道路同伦存在，当且仅当存在连续函数 `F:[0,1]×[0,1]→X`，满足 `F(0,s)=p(s)`、`F(1,s)=q(s)`、`F(t,0)=x` 和 `F(t,1)=y`。恒定时间变形给出反身性；反射时间坐标给出对称性；把两个变形各压缩到一半时间给出传递性。

# 陈述（Lean 对照）

```lean
theorem nonempty_pathHomotopy_iff_exists_fixed_endpoint_deformation :
  Nonempty (p.Homotopy q) ↔
    ∃ F : unitInterval × unitInterval → X, Continuous F ∧
      (∀ s, F (0, s) = p s) ∧ (∀ s, F (1, s) = q s) ∧
      (∀ t, F (t, 0) = x) ∧ (∀ t, F (t, 1) = y)
```

`pathHomotopy_refl_apply`、`pathHomotopy_symm_apply` 和两条 `pathHomotopy_trans_apply_*` 分别展开三种标准运算的逐点公式。

# 思维脉络（thinking trace）

正向从 `Path.Homotopy` 取出连续性、时间零与时间一切片，再用 `source/target` 取得端点固定。反向先用四条边界条件构造一般同伦，再把端点条件装入相对集合 `{0,1}`。反向操作只反射第一坐标；传递操作在时间前后半段分别使用二倍速参数。

# 自然语言 ↔ Lean 映射

“道路同伦”对应 `Path.Homotopy p q`；“相对端点”对应 `ContinuousMap.HomotopyRel p.toContinuousMap q.toContinuousMap {0,1}`；“存在一个同伦”对应 `Nonempty`；“时间反向”对应 `Path.Homotopy.symm`；“先后执行”对应 `Path.Homotopy.trans`。

# 依赖（人话版）

本条目直接依赖已经解释的标准 `Path` 与 Mathlib 的一般相对同伦承载。教材定位为 Hatcher 第 1.1 节。`Path.Homotopy` 与教材语义一致，故直接作为正式接口；旧 `TextbookTopology.Homotopy` 不参与新定义链，也没有新增向旧结构回退的桥。

# 应用与陷阱

道路同伦的两个参数不可互换：Lean 中第一坐标是变形时间，第二坐标是道路位置。`symm` 反转同伦时间，不等于对每条道路执行 `Path.symm`。`trans` 是同伦之间的传递拼接，也不等于道路的 `Path.trans`。本批尚未建立同伦类、基本群或其群运算。
