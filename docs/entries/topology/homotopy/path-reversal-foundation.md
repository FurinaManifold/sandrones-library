---
id: topology.homotopy.path-reversal-foundation
family: topology.homotopy
variant: reflected-parameter
kind: theorem
state: staging
title: 逆道路及双重反向的正式承载
summary: 解释 Mathlib Path.symm 的单位区间反射参数化及双重反向严格等式，并保留旧实现作为迁移兼容层
premises: [topology.homotopy.path-definition-foundation]
mathlib: [Path.symm, Path.symm_apply, Path.symm_symm, unitInterval.symm]
provenance:
  source_type: book
  ref: "Hatcher, Algebraic Topology, Section 1.1"
---

# 动机

逆道路是道路代数和基本群逆元的来源。Mathlib 已用标准单位区间反射实现 `Path.symm`；本条展开其参数含义，并区分严格道路等式与以后才使用的道路同伦。

# 直觉

`unitInterval.symm` 把参数 `t` 送到 `1-t`，交换零和一，且作用两次恢复原参数。与道路复合后会交换起点、终点；再次逆向逐点回到原道路。

# 陈述（自然语言）

对 Mathlib 道路 `γ : Path a b`，`γ.symm : Path b a` 满足 `γ.symm t = γ (unitInterval.symm t)`；任意道路反向两次严格等于原道路。旧逆道路转换到 Mathlib 后等于正式逆道路。

# 陈述（Lean 对照）

```lean
theorem path_symm_apply (γ : Path x y) (t : unitInterval) :
  γ.symm t = γ (unitInterval.symm t)
theorem path_symm_symm (γ : Path x y) : γ.symm.symm = γ
theorem TextbookTopology.Path.toMathlib_symm :
  toMathlib γ.symm = (toMathlib γ).symm
```

# 思维脉络（thinking trace）

`path_symm_apply` 直接公开 Mathlib `Path.symm_apply` 的参数函数；`path_symm_symm` 使用 Mathlib 已证明的道路外延结果。兼容桥比较两侧参数函数，旧 `UnitInterval.reflect` 与标准 `unitInterval.symm` 定义相同，因此转换与反向交换。

# 自然语言 ↔ Lean 映射

“参数反射”对应 `unitInterval.symm`；“逆道路”对应根 `Path.symm`；“逆道路取值”对应 `path_symm_apply`；“反向两次”对应 `path_symm_symm`；“旧操作语义保留”对应 `TextbookTopology.Path.toMathlib_symm`。

# 依赖（人话版）

正式接口只依赖 Mathlib `Path` 与单位区间反射。旧 `UnitInterval.reflect`、连续性证明和旧 `Path.symm` 留在文件后半部作为冻结兼容实现，不是新课程依赖。

# 应用与陷阱

双重反向是严格道路相等，因为参数反射严格自反。不能由此类推道路拼接的单位律或结合律也是严格等式；后二者通常需要重新参数化同伦，仍属于冻结的 A2 范围。
