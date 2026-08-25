/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.MathlibBridge

/-!
# 旧教材拓扑与 Mathlib 拓扑的兼容层

旧 `TextbookTopology` 载体与 Mathlib 的 `TopologicalSpace` 在结构上等价。本模块提供迁移期间
使用的临时双向兼容层。新的拓扑学开发应直接使用 Mathlib 载体，不得仅为延续旧平行层级而先经过
`fromMathlib`。

当前条目：

* `topology.foundation.mathlib-compatibility`.
-/

namespace SandronesLibrary.Topology.TextbookTopology

variable {X : Type*}

set_option warn.classDefReducibility false in
/-- 把一个 Mathlib 拓扑看作具有完全相同开集的冻结旧教材载体。这是迁移桥，而不是拓扑空间的
新定义。

> **Entry**: topology.foundation.mathlib-compatibility -/
def fromMathlib (τ : TopologicalSpace X) : TextbookTopology X where
  IsOpen := @_root_.IsOpen X τ
  isOpen_univ := @_root_.isOpen_univ X τ
  isOpen_inter := fun s t ↦ @_root_.IsOpen.inter X τ s t
  isOpen_sUnion := @_root_.isOpen_sUnion X τ

/-- 反向桥在定义层面保持开集谓词不变。 -/
@[simp]
theorem isOpen_fromMathlib (τ : TopologicalSpace X) (s : Set X) :
    (fromMathlib τ).IsOpen s ↔ @_root_.IsOpen X τ s :=
  Iff.rfl

/-- Mathlib 拓扑转到旧载体再转回后，拓扑不变。 -/
@[simp]
theorem toMathlib_fromMathlib (τ : TopologicalSpace X) :
    (fromMathlib τ).toMathlib = τ := by
  apply TopologicalSpace.ext
  rfl

/-- 旧拓扑转到 Mathlib 再转回后，旧拓扑不变。 -/
@[simp]
theorem fromMathlib_toMathlib (τ : TextbookTopology X) :
    fromMathlib τ.toMathlib = τ := by
  cases τ
  rfl

/-- 该桥也保持闭集：两侧的“闭”都表示补集是开集。 -/
@[simp]
theorem isClosed_toMathlib (τ : TextbookTopology X) (s : Set X) :
    @_root_.IsClosed X τ.toMathlib s ↔ τ.IsClosed s := by
  constructor
  · intro h
    exact h.isOpen_compl
  · intro h
    exact @IsClosed.mk X τ.toMathlib s h

/-- 安装同一个拓扑后，旧邻域谓词等价于属于 Mathlib 的邻域滤子。 -/
theorem isNeighborhood_iff_mem_nhds (τ : TextbookTopology X) (x : X) (s : Set X) :
    τ.IsNeighborhood x s ↔ s ∈ @nhds X τ.toMathlib x := by
  rw [@SandronesLibrary.Topology.mem_nhds_iff_exists_open X τ.toMathlib x s]
  rfl

/-- 冻结的旧拓扑载体与 Mathlib 拓扑载体结构等价。

这个等价只用于迁移旧声明，不能据此把面向 Mathlib 的新定理搬回旧层级。 -/
def equivMathlib : TextbookTopology X ≃ TopologicalSpace X where
  toFun := toMathlib
  invFun := fromMathlib
  left_inv := fromMathlib_toMathlib
  right_inv := toMathlib_fromMathlib

namespace Homeomorphism

variable {Y : Type*}

/-- 底层集合等价相同的两个旧同胚相等。 -/
theorem ext {τX : TextbookTopology X} {τY : TextbookTopology Y}
    {e e' : Homeomorphism τX τY} (h : e.toEquiv = e'.toEquiv) : e = e' := by
  cases e
  cases e'
  cases h
  rfl

/-- 把旧同胚转换为 Mathlib 的正式 `Homeomorph` 承载。 -/
def toMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : Homeomorphism τX τY) :
    @Homeomorph X Y τX.toMathlib τY.toMathlib :=
  @Homeomorph.mk X Y τX.toMathlib τY.toMathlib e.toEquiv
    ((continuous_iff_mathlib τX τY _).mp e.continuous_toFun)
    ((continuous_iff_mathlib τY τX _).mp e.continuous_invFun)

/-- 把桥接拓扑之间的 Mathlib 同胚转换到旧载体。 -/
def fromMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : @Homeomorph X Y τX.toMathlib τY.toMathlib) :
    Homeomorphism τX τY := by
  let _ := τX.toMathlib
  let _ := τY.toMathlib
  exact {
    toEquiv := e.toEquiv
    continuous_toFun := (continuous_iff_mathlib τX τY _).mpr e.continuous
    continuous_invFun := (continuous_iff_mathlib τY τX _).mpr e.symm.continuous }

/-- 旧同胚转到 Mathlib 再转回后，数据不变。 -/
@[simp]
theorem fromMathlib_toMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : Homeomorphism τX τY) : fromMathlib (toMathlib e) = e := by
  apply ext
  rfl

/-- Mathlib 同胚转到旧载体再转回后，数据不变。 -/
@[simp]
theorem toMathlib_fromMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : @Homeomorph X Y τX.toMathlib τY.toMathlib) :
    toMathlib (fromMathlib e) = e := by
  let _ := τX.toMathlib
  let _ := τY.toMathlib
  apply _root_.Homeomorph.ext
  intro x
  change e x = e x
  rfl

end Homeomorphism

end SandronesLibrary.Topology.TextbookTopology
