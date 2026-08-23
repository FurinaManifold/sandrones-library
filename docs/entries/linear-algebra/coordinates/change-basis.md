---
id: linear-algebra.coordinates.change-basis
family: linear-algebra.coordinates
variant: textbook
kind: theorem
state: verified
title: 坐标与换基公式
summary: 过渡矩阵变换向量坐标，并以相似变换联系同一线性算子的两组矩阵
premises: [linear-algebra.vector-space.basis, linear-algebra.maps.basic]
mathlib: ["Module.Basis.toMatrix_mulVec_repr", "basis_toMatrix_mul_linearMap_toMatrix_mul_basis_toMatrix"]
provenance:
  source_type: textbook
  ref: "本科线性代数：基变换、坐标变换与线性算子的矩阵"
---

# linear-algebra.coordinates.change-basis

- **家族**: `linear-algebra.coordinates`
- **状态**: verified
- **一句话**: 过渡矩阵把旧坐标变成新坐标，同一算子的两组矩阵彼此相似。

## 直觉

一组基把抽象向量唯一地写成一列数。更换基并没有改变向量本身，只改变这列数；
这种变化是线性的，因此由一个过渡矩阵表示。从新基换回旧基会撤销原来的变换，
所以两个方向的过渡矩阵互逆。

对线性算子也一样：先把输入坐标换回旧基、应用旧基下的算子矩阵、再把输出换到
新基，就得到新基下的算子矩阵。这正是教材中的相似变换公式。

## 陈述（教材记号）

设 `b,b'` 是 `V` 的两组有序基，`P` 是从 `b` 坐标到 `b'` 坐标的过渡矩阵，则

1. `P [x]_b = [x]_{b'}`；
2. `P` 与反向过渡矩阵互逆；
3. 对任意线性算子 `T`，`[T]_{b'} = P [T]_b P⁻¹`。

## 实现说明

公开接口使用本库的 `LinearSpace` 与 `IsBasis`。mathlib 的模基结构只在定义体和证明内部
用于取得唯一坐标，不进入教材定理签名。
