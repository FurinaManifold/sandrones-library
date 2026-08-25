---
id: real-analysis.lp.basic
family: real-analysis.lp
variant: generated
kind: definition
state: verified
title: "Lᵖ 空间与几乎处处等价类"
premises: ["real-analysis.measure.lintegral", "real-analysis.measure.fubini"]
mathlib: ["MeasureTheory.Lp", "MeasureTheory.MemLp", "MeasureTheory.MemLp.toLp", "MeasureTheory.MemLp.coeFn_toLp", "MeasureTheory.MemLp.toLp_eq_toLp_iff", "MeasureTheory.Lp.norm_toLp", "MeasureTheory.Lp.coeFn_add", "MeasureTheory.Lp.eq_zero_iff_ae_eq_zero"]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# 动机

若把 `Lᵖ` 仅定义成满足 `∫|f|ᵖ<∞` 的逐点函数，那么只在零测集上非零的函数会有
范数零，却不等于零函数，这违反范数的正定性。正确的 `Lᵖ` 空间必须把几乎处处相等
的函数视为同一个元素。

# 两层定义

对普通函数 `f : α → E`，`MemLp f p μ` 表示：

1. `f` 几乎处处强可测；
2. `eLpNorm f p μ < ∞`。

随后 `MeasureTheory.Lp E p μ` 先按几乎处处相等取商，再保留有限 `p`-范数的等价类。
本库将它记作 `LpSpace E p μ`。

当 `p<∞` 时，`eLpNorm` 对应

\[
\left(\int \lVert f(x)\rVert^p\,d\mu(x)\right)^{1/p};
\]

当 `p=∞` 时，它对应本质上确界。

# Lean 接口

- `memLp_iff`：展开普通函数的 `Lᵖ` 成员条件；
- `ofFunction`：把满足成员条件的函数送入商空间；
- `ofFunction_ae_eq`：构造所得代表与原函数几乎处处相等；
- `ofFunction_eq_iff`：两个构造所得元素相等恰好等价于原函数几乎处处相等；
- `norm_ofFunction`：商空间范数与函数 `eLpNorm` 对齐；
- `add_ae_eq`：商空间加法由代表元逐点加法诱导；
- `zero_iff_ae_zero`：商空间中的零等价于代表元几乎处处为零。

# 边界

当前条目允许任意 `p : ℝ≥0∞`，只建立底层集合和范数接口。三角不等式、赋范线性
结构和完备性需要 `1 ≤ p`；这些条件将在 Minkowski 与完备性条目中显式出现。

# 公理依赖

由公理审计脚本从 Lean 内核读取。
