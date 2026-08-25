---
id: functional-analysis.hahn-banach.extension
kind: theorem
state: verified
title: Hahn–Banach 延拓定理
premises: [functional-analysis.operator.space]
mathlib: [exists_extension_of_le_sublinear, exists_extension_norm_eq]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Section 2.3.1"}
---

# 动机

定义在子空间上的线性泛函只观察到空间的一部分。Hahn–Banach 定理说明，只要它受一个合适的
次线性函数控制，就能把它延拓到整个空间而不破坏控制；在赋范空间里，这进一步意味着可以保持
泛函的算子范数不变。

# 教材定义与正式承载

函数 `N : E → ℝ` 在本条中称为次线性，是指它对正标量满足 `N(c x)=cN(x)`，并满足
`N(x+y)≤N(x)+N(y)`。Mathlib 的核心定理直接接收这两个量词条件，而不是要求额外的 `Sublinear`
包装结构。子空间泛函由 Mathlib 的部分线性映射 `E →ₗ.[ℝ] ℝ` 承载；对用户公开的输入仍是普通
`S →ₗ[ℝ] ℝ`，只在证明中组成部分映射。赋范版本直接使用连续对偶 `StrongDual ℝ E` 和
`exists_extension_norm_eq`。因此本库不重定义次线性函数、子空间或连续对偶。

# 陈述（自然语言）

若 `f` 是实向量空间某子空间上的线性泛函，且 `f(x)≤N(x)`，其中 `N` 正齐次且次可加，则存在
全空间线性泛函 `g`，它在子空间上等于 `f`，并仍满足 `g(x)≤N(x)`。特别地，赋范空间子空间上的
连续线性泛函存在保持算子范数的连续延拓。

# 陈述（Lean 对照）

支配形式、等范数连续延拓和“不增范数”直接推论分别对应 `hahnBanach_dominated_extension`、
`hahnBanach_exists_extension_norm_eq` 与 `hahnBanach_exists_extension_norm_le`。

# 思维脉络

先证明一步延拓：在当前定义域外选一个向量，允许的新取值形成一个非空闭区间，从中选择一点即可
把定义域扩大一维并保持支配。再对所有受支配的部分延拓按包含关系使用 Zorn 引理，极大元若尚未
定义在全空间，就能继续一步延拓，产生矛盾。赋范版本取控制函数 `N(x)=‖f‖‖x‖`；延拓的上界给出
`‖g‖≤‖f‖`，而限制回原子空间给出反向不等式。

# 自然语言 ↔ Lean 映射

- 子空间：`S : Submodule ℝ E`，实数域下也记作 `Subspace ℝ E`。
- 子空间线性泛函：`f : S →ₗ[ℝ] ℝ`。
- 部分线性映射承载：`(⟨S,f⟩ : E →ₗ.[ℝ] ℝ)`，只出现在证明后端。
- 次线性量词：`N_hom` 与 `N_add`。
- 连续对偶：`StrongDual ℝ E`。
- 等范数延拓：`exists_extension_norm_eq`。

# 依赖

依赖 F1 的连续线性泛函与算子范数。下一条范数化泛函会把本定理应用到一维子空间；凸分离则会
把支配函数具体化为 Minkowski 泛函。

# 应用与边界

代数支配形式固定实数域，因为次线性条件使用实数序；赋范形式的 Mathlib 后端也支持复数域，但
本条先保持 Bühler–Salamon 当前实课程陈述。这里不声称延拓唯一，也不延拓一般向量值算子；范数
保持依赖标量值泛函这一边界。
