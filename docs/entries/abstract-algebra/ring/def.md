---
id: abstract-algebra.ring.def
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 环、单位、子环与环同态
summary: 自建环公理、交换环、单位、子环集合与环同态定义，并桥接生成子环和基本运算
premises: []
mathlib: [Ring, CommRing, Subring, Subring.closure, Subring.closure_le, IsUnit, RingHom]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

环把加法、乘法与分配律组织在同一结构中。子环是环内保持全部运算的部分，单位控制哪些
元素可以参与乘法消去，环同态则刻画保持环结构的映射。这些概念是理想、商环和同构定理
的共同起点。

# 基本概念

本库不再把 Mathlib 结构名本身当作教材定义：

- `RingAxioms R` 逐条列出加法结合/交换、零元、加法逆元、乘法结合/单位元和左右分配律；
- `CommutativeRingAxioms R` 是环公理再加乘法交换；
- `UnitElement a` 直接定义为存在同一个双侧逆元；
- `SubringSet S` 直接定义集合含 `0,1` 且对加、乘、负封闭；
- `RingHomomorphism f` 直接定义普通函数保持 `0,1,+,*,−`。

Mathlib 的 `Ring`、`CommRing`、`Subring`、`IsUnit`、`RingHom` 是这些教材概念的可靠打包
实现。桥接定理明确验证两层之间的关系，后续不会再让结构名代替定义。

子集 `S` 若含 `0,1` 并对加法、乘法和取负封闭，就承载一个子环。由 `S` 生成的子环
`generatedSubring S` 是所有包含 `S` 的子环中最小的一个。

# 陈述（Lean 对照）

- `comm_ring_mul_comm`：交换环乘法交换；
- `RingAxioms`、`CommutativeRingAxioms`：本库环与交换环定义；
- `ring_has_ringAxioms`、`commRing_has_commutativeRingAxioms`：Mathlib 实例满足本库公理；
- `UnitElement`、`unitElement_iff_isUnit`：本库单位定义及实现桥；
- `SubringSet`、`subringSet_iff_exists_subring`：本库子环集合定义及实现桥；
- `RingHomomorphism`、`ringHom_is_RingHomomorphism`、`ringHomomorphism_exists_ringHom`：
  本库环同态定义及双向打包桥；
- `isUnit_iff_exists_two_sided_inverse`：单位的双侧逆判据；
- `zero_eq_one_iff_subsingleton`：零环判据；
- `subring_of_closed`：子环判定定理；
- `subring_one_mem`、`subring_zero_mem`、`subring_ext`：子环基本性质；
- `subring_bot`、`subring_top`：最小与最大子环；
- `generatedSubring`、`subset_generatedSubring`、`generatedSubring_le_iff`：生成子环及最小性；
- `generatedSubring_mono`：生成集合扩大时生成子环也扩大；
- `mem_subring_inf_iff`：两个子环之交的成员判据；
- `ring_hom_map_one/add/mul/zero/neg/sub/pow/intCast`：环同态保持全部基本环运算。

# 思维脉络

生成子环可以理解为所有包含 `S` 的子环之交，因此天然包含 `S`，并且小于任何包含 `S`
的子环。环同态保持 `0`、负元、减法和幂并非额外公理，而是由保持 `1`、加法、乘法以及
群消去律推导出来。

# 依赖（人话版）

依赖群的基本运算、幺半群中的单位，以及集合包含和交。Lean 实现使用 `Subring.closure`
承载生成子环，用 `RingHom` 承载环同态。

# 应用与陷阱

- 一般环中乘法不交换，不能随意交换因子；只有 `CommRing` 才允许这样做。
- 非交换幺半群中的单位判据需要同一个逆元同时满足左右逆条件。
- 最小子环 `⊥` 通常不是 `{0}`，因为子环必须含 `1`；它由所有整数倍的 `1` 组成。
- 子环判定强调含 `1`，这与理想只要求含 `0` 并被环乘法吸收不同。
