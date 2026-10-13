---
id: linear-algebra.coordinates.change-basis
family: linear-algebra.coordinates
variant: textbook
kind: theorem
state: verified
title: 坐标与换基公式
summary: 过渡矩阵变换向量坐标，并以相似变换联系同一线性算子的两组矩阵
premises: [linear-algebra.vector-space.basis]
mathlib: ["Module.Basis.toMatrix_mulVec_repr", "basis_toMatrix_mul_linearMap_toMatrix_mul_basis_toMatrix"]
provenance:
  source_type: book
  ref: "axler-linear-algebra-2015"
---

# linear-algebra.coordinates.change-basis

- **家族**: `linear-algebra.coordinates`
- **状态**: verified
- **一句话**: 过渡矩阵把旧坐标变成新坐标，同一算子的两组矩阵彼此相似。

## 动机

一组基把抽象向量唯一地写成一列数，但列数依赖基的选择。要在不同基之间翻译向量
和线性算子，需要一个只由两组基决定的换算矩阵；这就是过渡矩阵与换基公式的用途。

## 直觉

更换基并没有改变向量本身，只改变它的坐标列，因此这种变化是线性的，由一个过渡
矩阵表示。从新基换回旧基会撤销原来的变换，所以两个方向的过渡矩阵互逆。对线性
算子先换回旧基、作用旧矩阵、再换到新基，就得到教材中的相似变换公式。

## 陈述（教材记号）

设 `b,b'` 是 `V` 的两组有序基，`P` 是从 `b` 坐标到 `b'` 坐标的过渡矩阵，则

1. `P [x]_b = [x]_{b'}`；
2. `P` 与反向过渡矩阵互逆（左右逆都成立）；
3. 对任意线性算子 `T`，`[T]_{b'} = P [T]_b P⁻¹`，其中反方向的过渡矩阵直接
   充当 `P⁻¹`，无需另行引入矩阵求逆。

## 依赖（人话版）

依赖基与坐标的存在唯一性；本 Entry 只把 `linear-algebra.vector-space.basis` 列为
库内前提。数学上还要用到矩阵乘法和模基表示，但它们由 Mathlib 提供，不进入前提。

## 实现说明

公开接口使用本库的 `LinearSpace` 与 `IsBasis`。`coordinates` 通过 `Module.Basis.mk`
取得唯一坐标，`transitionMatrix b b'` 的第 `j` 列是旧基向量 `b j` 在新基 `b'` 下的
坐标；`transitionMatrix_mulVec_coordinates`、`transitionMatrix_mul_reverse`、
`reverse_mul_transitionMatrix` 与 `operatorMatrix_change_basis` 分别对应上面三条结论。
Mathlib 的模基结构只在定义体和证明内部使用，不进入教材定理签名。
