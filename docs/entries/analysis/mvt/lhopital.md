---
id: analysis.mvt.lhopital
family: analysis.mvt
variant: rudin
kind: theorem
state: verified
title: L'Hôpital 法则（0/0 型）
summary: f、g 在 a 去心邻域可导、g'≠0，f→0、g→0，若 f'/g'→l 则 f/g→l
premises: [analysis.mvt.cauchy]
mathlib: [HasDerivAt.lhopital_zero_nhdsNE]
provenance:
  source_type: book
  ref: Rudin, Principles of Mathematical Analysis, Thm 5.13（L'Hôpital 规则）
---

# analysis.mvt.lhopital

- **家族**: `analysis.mvt`
- **变体**: rudin（Rudin《Principles of Mathematical Analysis》）
- **状态**: verified
- **一句话**: 0/0 型不定式求极限：把 f/g 的极限换成 f'/g' 的极限（需后者存在）。

## 直觉

f、g 都趋于 0 时，f/g 直接代入无意义。柯西中值定理保证在 a 附近的某点
f/g 的割线斜率等于 f'/g' 在该点的值，把极限传过去。

## 陈述（Lean 对照）

`HasDerivAt.lhopital_zero_nhdsNE`：在 `𝓝[≠] a` 上
`(∀ᶠ x, HasDerivAt f (f' x) x) → (∀ᶠ x, HasDerivAt g (g' x) x) → (∀ᶠ x, g' x ≠ 0) →
 Tendsto f (𝓝[≠] a) (𝓝 0) → Tendsto g (𝓝[≠] a) (𝓝 0) →
 Tendsto (f'/g') (𝓝[≠] a) (𝓝 l) → Tendsto (f/g) (𝓝[≠] a) (𝓝 l)`

## 依赖（人话版）

premises: analysis.mvt.cauchy（柯西中值定理，L'Hôpital 的数学根源）；
mathlib: HasDerivAt.lhopital_zero_nhdsNE（0/0 型去心邻域版本）。

## 应用与陷阱

- 仅 0/0 型；∞/∞ 型用 `HasDerivAt.lhopital_zero_atTop` 等。
- mathlib 的 L'Hôpital 在 `HasDerivAt` 命名空间内（全名 `HasDerivAt.lhopital_zero_nhdsNE`），
  不是根命名空间——同名遮蔽曾触发递归误判（Playbook 教训）。
