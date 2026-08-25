---
id: topology.homotopy.path-concatenation-foundation
family: topology.homotopy
variant: half-interval-gluing
kind: definition
state: staging
title: 道路拼接的正式承载
summary: 解释 Mathlib Path.trans 的左右半区二倍速参数化，并保留旧分段连续性实现作为迁移兼容层
premises: [topology.homotopy.path-definition-foundation]
mathlib: [Path.trans, Path.trans_apply]
provenance:
  source_type: book
  ref: "Hatcher, Algebraic Topology, Section 1.1"
---

# 动机

道路拼接是道路连通、基本群乘法和道路同伦的基础运算。Mathlib 已提供与教材相同的二倍速分段拼接；课程通过左右半区取值公式解释它，不再维护新的拼接实现。

# 直觉

在参数区间前一半以两倍速度走完第一条道路，在后一半以两倍速度走完第二条道路。公共端点保证中点处两段粘合；Mathlib 将连续性证明封装在 `Path.trans` 中。

# 陈述（自然语言）

若 `γ : Path a b`、`δ : Path b c`，则 `γ.trans δ : Path a c`。当 `t≤1/2` 时其值为 `γ(2t)`；否则为 `δ(2t-1)`。旧拼接转到 Mathlib 后严格等于正式拼接。

# 陈述（Lean 对照）

```lean
theorem path_trans_apply_of_le (γ : Path x y) (δ : Path y z)
    (t : unitInterval) (h : t ≤ 1 / 2) :
  γ.trans δ t = γ ⟨2 * t, ...⟩
theorem path_trans_apply_of_not_le (γ : Path x y) (δ : Path y z)
    (t : unitInterval) (h : ¬t ≤ 1 / 2) :
  γ.trans δ t = δ ⟨2 * t - 1, ...⟩
theorem TextbookTopology.Path.toMathlib_trans :
  toMathlib (γ.trans δ) = (toMathlib γ).trans (toMathlib δ)
```

# 思维脉络（thinking trace）

两条取值定理展开 Mathlib `Path.trans_apply` 的 dependent `if`，分别用 `dif_pos` 和 `dif_neg` 选择左右分支；区间成员证明只需线性不等式。兼容桥再用道路外延比较两侧分段函数，说明旧实现与正式拼接逐点相同。

# 自然语言 ↔ Lean 映射

“拼接道路”对应根 `Path.trans`；“左半段走第一条”对应 `path_trans_apply_of_le`；“右半段走第二条”对应 `path_trans_apply_of_not_le`；“旧拼接语义保留”对应 `TextbookTopology.Path.toMathlib_trans`。

# 依赖（人话版）

正式接口依赖 Mathlib `Path.trans` 与 `Path.trans_apply`；`linarith` 只核验缩放参数仍在单位区间。旧分段函数与 ε 连续性证明仍作为冻结兼容实现保留。

# 应用与陷阱

该拼接选择固定二倍速参数化，因此与常值道路拼接通常不是严格相等，结合律也不是参数函数的严格等式。单位律、结合律和逆律必须进入道路同伦后处理，本批不作任何相关声明。
