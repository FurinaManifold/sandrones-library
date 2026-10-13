---
id: real-analysis.signed-measure.complex
family: real-analysis.signed-measure
variant: tao
kind: theorem
state: verified
title: 复测度
summary: 复测度作为 ℂ-值向量测度；实部／虚部为有符号测度，复测度与有符号测度对一一对应
premises: [real-analysis.signed-measure.definition]
mathlib: [ComplexMeasure.re, ComplexMeasure.im, ComplexMeasure.re_apply, ComplexMeasure.im_apply, SignedMeasure.toComplexMeasure, SignedMeasure.toComplexMeasure_apply, ComplexMeasure.toComplexMeasure_to_signedMeasure, SignedMeasure.re_toComplexMeasure, SignedMeasure.im_toComplexMeasure, ComplexMeasure.equivSignedMeasure, Complex.re_add_im]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.signed-measure.complex

- **家族**: `real-analysis.signed-measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 复测度就是取值在 `ℂ` 的向量测度；取实部／虚部得到一对有符号测度，
  且这一对反过来唯一决定原来的复测度。

## 直觉

实数域上的有符号测度允许取值有正有负，但每个可测集仍取一个**实数**。复测度把这个值域
放宽到复数：一个复测度在每个可测集上给一个复数，可数可加性在复数加法下成立。由于
`ℂ ≅ ℝ²`（实部、虚部），一个复测度自然应当拆成两个实值对象——“实部测度”和“虚部测度”。
Folland 的观察正是：这两个实值对象不只是任意的实值集函数，它们各自是**有符号测度**，
于是复测度理论没有引入新的分析难度，而是化归为有符号测度理论。

## 教材定义（Folland, *Real Analysis* 2nd ed., §3.1）

Folland 把（复）测度定义在可测空间 `(X, M)` 上，要求 `ν : M → ℂ` 满足：

1. **σ-可加**：对两两不交的可测集列 `{E_j}`，`ν(⋃_j E_j) = Σ_j ν(E_j)`，
   且右侧级数无条件收敛（因此与排列无关）；
2. **有限性**：对每个 `E ∈ M`，`|ν(E)| < ∞`（即取值不出现 `∞`，这正是“复值而非
   扩张复值”的含义）。

书中写 `ν = ν_r + i ν_i`，其中 `ν_r, ν_i` 是实值集函数；由 `ν` 的 σ-可加性与有限性可验证
`ν_r`、`ν_i` 分别是有符号测度。同时反向地，任意两个有符号测度 `μ, λ` 拼成
`μ + iλ` 又给出一个复测度。于是“复测度”与“有符号测度的有序对”在信息上等价。
本 Entry 正是把这段话在 Lean 里全部落实。

## 本库 Lean 承载

Mathlib 已有与教材一致的载体，本库直接复用，不另造结构：

- `MeasureTheory.ComplexMeasure α = VectorMeasure α ℂ`（`abbrev`）：**复测度的正式承载**。
  `VectorMeasure α ℂ` 已经内置“可测集上可数可加、非可测集取零”的语义，
  与教材的 σ-可加 + 有限取值一致。
- `ComplexMeasure.re : ComplexMeasure α →ₗ[ℝ] SignedMeasure α` 与
  `ComplexMeasure.im : ComplexMeasure α →ₗ[ℝ] SignedMeasure α`：**实部／虚部**，
  取值分别为 `(re c) i = (c i).re`、`(im c) i = (c i).im`。
- `SignedMeasure.toComplexMeasure (s t) : ComplexMeasure α`：把两个有符号测度拼成复测度，
  满足 `(s.toComplexMeasure t) i = ⟨s i, t i⟩`，即教材的 `s + i t`。
- `ComplexMeasure.equivSignedMeasure : ComplexMeasure α ≃ SignedMeasure α × SignedMeasure α`：
  复测度与有符号测度对的等价，`c ↦ (re c, im c)`，逆为 `(s,t) ↦ s.toComplexMeasure t`。

## Lean 对照（本文件公开定理）

1. `complexMeasure_re_add_im (c) (i) : c i = (re c i : ℂ) + (im c i : ℂ) * Complex.I`
   —— 点式分解，即教材的 `ν = ν_r + i ν_i` 在单个集合上的形式。
2. `complexMeasure_re_apply (c) (i) : (re c) i = (c i).re`，
   `complexMeasure_im_apply (c) (i) : (im c) i = (c i).im` —— 实部／虚部的取值公式。
3. `complexMeasure_toComplexMeasure_re_im (c) : s.toComplexMeasure (re c) (im c) = c`
   —— 由实部、虚部还原复测度（教材“归结”的还原方向）。
4. `complexMeasure_re_toComplexMeasure` / `complexMeasure_im_toComplexMeasure`
   —— 拼回去再取实部／虚部回到原分量。
5. `complexMeasure_apply_toComplexMeasure (s t) (i) : (s.toComplexMeasure t) i = (s i : ℂ) + (t i : ℂ) * I`
   —— 拼回复测度的取值公式。
6. `complexMeasure_eq_zero_iff`、`complexMeasure_ext` —— 复测度为零的判定与外延性，都由
   实部／虚部的相等性刻画。
7. `complexMeasure_equiv_signedMeasure` —— 上面 Mathlib 等价在库内的具名暴露。
8. `complexMeasure_apply_eq_zero_iff (c) (i) : c i = 0 ↔ re c i = 0 ∧ im c i = 0`
   —— 点式分解的直接推论，真实使用了实部／虚部。

## 证明思路

- **点式分解**（定理 1）：对右端用 `Complex.re_add_im`（复数恒等式
  `↑z.re + ↑z.im * I = z`）反向改写，再用实部／虚部的取值引理把
  `re c i`、`im c i` 归约到 `(c i).re`、`(c i).im`，两边定义相等。
- **还原与重构**（定理 3–5）：Mathlib 的 `toComplexMeasure`、`re`、`im` 都是
  “逐点取分量”的定义，`ComplexMeasure.toComplexMeasure_to_signedMeasure`、
  `SignedMeasure.re_toComplexMeasure`、`SignedMeasure.im_toComplexMeasure` 均为 `rfl` 级等式，
  本库只是把它们作为公开对照暴露出来。
- **取值公式**（定理 5）：先 `SignedMeasure.toComplexMeasure_apply` 把左端化为
  `⟨s i, t i⟩`，再用 `Complex.ext` 对实部、虚部两块分别化简。
- **零判定与外延**（定理 6）：利用线性映射的 `map_zero` 从 `c = 0` 推出 `re c = im c = 0`；
  反向用还原等式把 `c` 表示成 `(re c).toComplexMeasure (im c)`，再代入 `re c = 0`、`im c = 0`
  化为 `0.toComplexMeasure 0 = 0`。外延性则把两边的还原等式代入 `hre`、`him`。
- **逐点零判定**（定理 8）：把左端按定理 1 展开、按定理 2 归约，问题变成实系数等式
  `a + b * I = 0 ↔ a = 0 ∧ b = 0`，对 `⇐` 直接代入，对 `⇒` 分别取 `Complex.re`、`Complex.im`。

## 依赖

- 库内前提：`real-analysis.signed-measure.definition`
  （载体 `SignedMeasure α`、正／负／零集、`exists_hahnDecomposition` 等）。
- **Mathlib 角色**：`ComplexMeasure = VectorMeasure α ℂ` 与 `re`/`im`/`toComplexMeasure`/
  `equivSignedMeasure` 是**语义一致的正式承载**；`Complex.re_add_im` 是复数的私有证明后端。
  本库不重造这些结构，只补上教材视角的具名对照。

## 边界与未完成

- **全变差有限性未注册**。复测度 `c` 的变差 `VectorMeasure.variation c` 给出一个
  `Measure α`，但“该变差是有限测度”在当前 Mathlib **没有注册为实例**
  （已实测 `synthInstanceFailed`，即无法自动合成 `IsFiniteMeasure (c.variation)`）。
  因此本 Entry 不声称 `IsFiniteMeasure (c.variation)`；教材中复测度全变差有限这一条
  是后续要补齐的边界，而不是本文件的结论。
- **复测度的绝对连续与 Radon–Nikodym** 属于 RA-F2 的后续内容，不在本 Entry。
  本 Entry 只处理“复测度 = 有符号测度对”这一代数—测度论骨架。
- Folland §3.1 中复测度的 σ-可加与有限性两条，本库以 `VectorMeasure α ℂ` 的既有语义承载，
  未在本文件重复包装其公理展开。
