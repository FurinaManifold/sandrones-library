---
id: topology.separations.urysohn
family: topology.separations
variant: munkres
kind: theorem
state: verified
title: Urysohn 引理
summary: 正规空间中不相交闭集可用连续函数分离（f=0在s、f=1在t、值域[0,1]）
premises: [topology.separations]
mathlib: [exists_continuous_zero_one_of_isClosed]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 4（Urysohn 引理）
---

# topology.separations.urysohn

- **家族**: `topology.separations`
- **变体**: munkres
- **状态**: verified
- **一句话**: 正规空间用连续函数分离闭集（[0,1] 值的"分离函数"）。

## 直觉

正规空间中两个不相交闭集 s、t 可被连续函数 f:X→[0,1] 分离：f 在 s 上为 0、在 t 上为 1。
这是正规性的"函数刻画"，也是 Urysohn 度量引理、完全正则性的基础。

## 陈述（教材记号）

`urysohn_lemma`：∃ f : C(X,ℝ)，f=0 在 s、f=1 在 t、值域 ⊆ [0,1]。

## 依赖（人话版）

前提：topology.separations（NormalSpace）。mathlib 的 `exists_continuous_zero_one_of_isClosed`
给出 ContinuousMap，`C(X, ℝ)` 是连续函数空间记号。

## 应用与陷阱

- `C(X, ℝ)` 是 ContinuousMap 类型（不是普通函数），用 `⇑f` 取函数。
- Urysohn 引理 ⟹ 完全正则性、嵌入定理（Tychonoff 嵌入）。
