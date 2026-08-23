/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib.Analysis.Normed.Module.Alternating.Basic

/-!
# 连续交替映射空间的规范范数模型

mathlib 的连续交替映射同时带有半范数群实例和由值域分离性得到的范数群实例。
在高阶连续线性映射与 Fréchet 微分组合时，自动实例推断可能选中不同但数学上
等价的结构。本模块提供一个定义上独立的规范模型，只暴露一套明确的
`NormedAddCommGroup` 与 `NormedSpace` 实例，并提供与原类型之间的恒等连续线性桥。

这里没有流形、切丛或纤维丛结构；它只是连续交替映射空间的线性代数基础设施。
-/

noncomputable section

namespace SandronesLibrary.LinearAlgebra.NormedAlternating

universe u

/-- 连续交替映射空间的规范范数模型。底层数据与原类型完全相同。 -/
def NormalizedAlternatingSpace (E : Type u)
    [NormedAddCommGroup E] [NormedSpace ℝ E] (k : ℕ) :=
  E [⋀^Fin k]→L[ℝ] ℝ

instance normalizedAlternatingSpaceNormedAddCommGroup {E : Type u}
    [NormedAddCommGroup E] [NormedSpace ℝ E] {k : ℕ} :
    NormedAddCommGroup (NormalizedAlternatingSpace E k) :=
  ContinuousAlternatingMap.instNormedAddCommGroup

instance normalizedAlternatingSpaceNormedSpace {E : Type u}
    [NormedAddCommGroup E] [NormedSpace ℝ E] {k : ℕ} :
    NormedSpace ℝ (NormalizedAlternatingSpace E k) :=
  ContinuousAlternatingMap.instNormedSpace

/-- 从 mathlib 原连续交替映射空间进入规范模型。底层映射是恒等映射。 -/
def toNormalizedAlternatingSpace {E : Type u}
    [NormedAddCommGroup E] [NormedSpace ℝ E] (k : ℕ) :
    (E [⋀^Fin k]→L[ℝ] ℝ) →L[ℝ] NormalizedAlternatingSpace E k :=
  ContinuousLinearMap.id ℝ _

/-- 从规范模型返回 mathlib 原连续交替映射空间。底层映射是恒等映射。 -/
def fromNormalizedAlternatingSpace {E : Type u}
    [NormedAddCommGroup E] [NormedSpace ℝ E] (k : ℕ) :
    NormalizedAlternatingSpace E k →L[ℝ] (E [⋀^Fin k]→L[ℝ] ℝ) :=
  ContinuousLinearMap.id ℝ _

end SandronesLibrary.LinearAlgebra.NormedAlternating
