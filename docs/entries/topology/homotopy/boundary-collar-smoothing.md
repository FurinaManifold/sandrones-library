---
id: topology.homotopy.boundary-collar-smoothing
family: topology.homotopy
variant: path-homotopy-relative-boundary-collar
kind: theorem
state: verified
title: 边界 collar 条件下的道路同伦相对平滑化
summary: 在全局连续延拓于闭方形四边某邻域已 C2 且原像位于开集的条件下，相对四边逼近道路同伦，并使其标准双重 IccExtend 在闭方形上 C2
premises: [topology.homotopy.standard]
mathlib: [Continuous.exists_contDiff_approx_and_eqOn, IsCompact.exists_cthickening_subset_open, Path.Homotopy, Set.IccExtend]
provenance:
  source_type: book
  ref: "lee-smooth-manifolds-2012"
---

# 动机

复分析中的同伦积分论证需要对参数方形上的同伦作微分，但一个拓扑道路同伦起初只有连续性。这里不声称任意连续边界都能被相对平滑：我们隔离一个可严格证明的情形，即原同伦有全局连续延拓，而且该延拓在四条边的一个邻域中已经二阶光滑。

# 直觉

闭方形的像是紧集，并包含在开集 `U` 中，因此它到 `U` 外部具有统一的正余量。相对光滑逼近可以在四边保持原函数，同时在整个平面给出足够接近的 `C²` 函数；统一余量保证逼近后的闭方形像仍留在 `U`。四边相等恰好保留两条端点道路以及道路的两个固定端点。

# 陈述（自然语言）

设 `F` 是道路 `p` 与 `q` 之间的标准道路同伦。假设存在全局连续函数 `f : ℝ² → E`，它在闭单位方形上等于 `F`；还假设 `f` 在闭方形四边的某个邻域中为 `C²`，并且 `F` 的像包含于开集 `U`。则存在从 `p` 到 `q` 的道路同伦 `H`，其像仍包含于 `U`，并且把 `H` 的两个单位区间坐标用标准钳位延拓到实数后，所得函数在闭单位方形上为 `C²`。

# 陈述（Lean 对照）

```lean
theorem exists_contDiffTwo_pathHomotopy_of_boundaryCollar
    (F : p.Homotopy q) (f : ℝ × ℝ → E) (hf : Continuous f)
    (hfF : ∀ z : unitInterval × unitInterval, f (z.1, z.2) = F z)
    (hV : V ∈ nhdsSet closedUnitSquareBoundary)
    (hfV : ContDiffOn ℝ 2 f V) (hU : IsOpen U)
    (hFU : ∀ s t : unitInterval, F (s, t) ∈ U) :
    ∃ H : p.Homotopy q, (∀ s t, H (s, t) ∈ U) ∧
      ContDiffOn ℝ 2
        (fun xy ↦ Set.IccExtend zero_le_one (H.toHomotopy.extend xy.1) xy.2)
        (Set.Icc 0 1)
```

`closedUnitSquareBoundary` 显式定义四边；`pathHomotopyOfEqOnSquareBoundary` 展示“保持四边”如何重新组装成 `Path.Homotopy`，而不是把这一点藏在最终证明中。

# 思维脉络（thinking trace）

先由闭方形紧致及 `F` 的像落在开集 `U`，使用 `IsCompact.exists_cthickening_subset_open` 取得统一厚化余量。再以四边闭集为相对集合，调用 `Continuous.exists_contDiff_approx_and_eqOn`，得到全局 `C²` 逼近 `g`：它在四边等于 `f`，且因逐点误差小于统一余量而把闭方形映入 `U`。把 `g` 限制到两个单位区间得到 `H`；四条边分别证明两个时间切片和两个固定端点。最后在闭方形内部展开两次 `IccExtend`，它逐点就是 `g`，故继承 `g` 的 `C²` 性。

# 自然语言 ↔ Lean 映射

“闭单位方形”对应 `closedUnitSquare`；“四边”对应四个积集合之并 `closedUnitSquareBoundary`；“四边某邻域”对应 `V ∈ nhdsSet closedUnitSquareBoundary`；“相对四边不变”对应 `EqOn g f closedUnitSquareBoundary`；“开域统一余量”由 `IsCompact.exists_cthickening_subset_open` 承载；“相对光滑逼近”由 `Continuous.exists_contDiff_approx_and_eqOn` 承载；“标准实参数延拓”是对 `Path.Homotopy.extend` 再作 `Set.IccExtend`。

# 依赖（人话版）

道路同伦直接使用 Mathlib `Path.Homotopy`，其教材定义已由 `topology.homotopy.standard` 的前置链解释。本条目的新公开对象只有闭方形、其四边及相对平滑化接口；Mathlib 的光滑逼近定理是证明后端，闭集、邻域、紧致像、开集和 `C²` 的量词均在公开陈述中保留。平滑逼近的教材背景参照 Lee 的光滑流形教材；本定理的精确范数空间接口以已编译 Lean 陈述为准。

# 应用与陷阱

这是 boundary-collar 定理，不是一般同伦正则化。它必须给出一个全局连续延拓 `f`，必须证明该延拓与 `F` 在整个闭方形一致，并必须在四边闭集的某个邻域上已有 `C²`；只知道边界连续或分段 `C¹` 不够。结论只断言双重标准延拓在闭方形上的 `ContDiffOn ℝ 2`，不声称全局延拓处处与原同伦相等。本条目不解除 T4-R3，也不单独包装紧集开域余量定理。
