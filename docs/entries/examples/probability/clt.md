---
id: examples.probability.clt
kind: example
state: verified
title: 中心极限定理的具体概率空间实例
summary: 在标准正态坐标的无限乘积空间上，坐标随机变量独立同分布、均值零方差一，代入一般 iid CLT 得到标准化和弱收敛到标准正态，并读回特征函数逐点极限
premises: [probability.clt.central-limit-theorem, probability.characteristic-function.levy-continuity]
mathlib: [Measure.infinitePi, Measure.infinitePi_map_eval, iIndepFun_infinitePi, measurable_pi_apply, memLp_map_measure_iff, memLp_id_gaussianReal, integral_map, integral_id_gaussianReal, variance_map, variance_id_gaussianReal, charFun_gaussianReal]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 动机

`probability.clt.central-limit-theorem`（Wave R1 集成）给出的是一般性陈述：任意独立同分布、
二阶矩有限的实值序列，中心化并按 `σ√n` 缩放后弱收敛到标准正态。一般陈述本身不提供一个
“看得见”的概率空间。本 Entry 造出最标准的具体空间——各坐标独立标准正态的乘积空间——
把 CLT 的全部假设逐项核对，再代入定理，得到一条可复核的收敛结论。

# 直觉

取无穷乘积空间 `Ω = ℕ → ℝ`，`P = ⊗ₖ gaussianReal 0 1`，坐标随机变量 `X k (ω) = ω k`。

- 乘积测度的定义性性质给出**独立性**：不同坐标互不影响。
- 每个坐标的边缘分布都是同一个标准正态，给出**同分布**。
- 标准正态的均值是 `0`、方差是 `1`，给出**矩假设**。
- 于是 `(√n)⁻¹ ∑_{k<n} X k` 的分布收敛到 `gaussianReal 0 1`。
- 再经 Lévy 连续性接口，这条弱收敛等价于特征函数逐点趋于 `exp (-t²/2)`。

# 陈述（自然语言）

在概率空间 `(ℕ → ℝ, ⊗ₖ gaussianReal 0 1)` 上定义坐标 `X k (ω) = ω k`。则：

1. `X` 独立（`iIndepFun`）且任意两个坐标同分布；
2. `X 0` 二阶矩有限，`𝔼[X 0] = 0`，`Var[X 0] = 1`；
3. 中心化缩放和 `(1·√n)⁻¹ ∑_{k<n} (X k - 0)` 的分布（`centeredScaledSumLaw X _ 0 1 n`）
   弱收敛到标准正态 `gaussianReal 0 1`；
4. 对每个固定 `t : ℝ`，上述分布的**特征函数**收敛到 `exp (-t²/2)`。

# 陈述（Lean 对照）

```lean
abbrev gaussianSpace : Measure (ℕ → ℝ) := Measure.infinitePi fun _ => gaussianReal 0 1
abbrev coordinate (k : ℕ) : (ℕ → ℝ) → ℝ := fun ω => ω k

theorem coordinate_law (k : ℕ) :
    gaussianSpace.map (coordinate k) = gaussianReal 0 1
theorem coordinate_iIndepFun : iIndepFun coordinate gaussianSpace
theorem coordinate_identDistrib (i : ℕ) :
    IdentDistrib (coordinate i) (coordinate 0) gaussianSpace gaussianSpace
theorem coordinate_memLp_two : MemLp (coordinate 0) 2 gaussianSpace
theorem coordinate_integral : gaussianSpace[coordinate 0] = 0
theorem coordinate_variance : variance (coordinate 0) gaussianSpace = 1

theorem clt_gaussianCoordinates :
    Tendsto
      (fun n : ℕ => centeredScaledSumLaw coordinate
        (fun i => (coordinate_identDistrib i).aemeasurable_fst) 0 1 n)
      atTop (𝓝 (⟨gaussianReal 0 1, inferInstance⟩ : ProbabilityMeasure ℝ))

theorem clt_gaussianCoordinates_charFun (t : ℝ) :
    Tendsto
      (fun n : ℕ => charFun (centeredScaledSumLaw coordinate
        (fun i => (coordinate_identDistrib i).aemeasurable_fst) 0 1 n) t)
      atTop (𝓝 (Complex.exp (-(t ^ 2) / 2)))
```

# 思维脉络

先固定具体空间：`gaussianSpace` 用 `abbrev` 定义，使“概率测度”类型类实例在归约时可见。
坐标的可测性用 `measurable_pi_apply`，而边缘分布用 `Measure.infinitePi_map_eval` 得到
`gaussianReal 0 1`。

独立性走 `iIndepFun_infinitePi`：该引理直接断言“各分量空间上可测映射在乘积空间上独立”，
把 `X := fun _ => id` 代入即得坐标族独立。

矩条件通过“先把积分／方差搬到推前测度上”完成：`memLp_map_measure_iff`、`integral_map`、
`variance_map` 把 `coordinate 0` 的 `L²`、期望、方差化为 `id` 在 `gaussianReal 0 1` 下的
对应量，再分别用 `memLp_id_gaussianReal`、`integral_id_gaussianReal`、`variance_id_gaussianReal`
读出 `L²`、`0`、`1`。

最后把六个假设原样喂给 `iid_centeredScaled_clt` 得到弱收敛；特征函数结论则由
`probabilityMeasure_tendsto_iff_charFun`（Lévy 连续性接口）与 `charFun_gaussianReal` 得到。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 标准正态坐标乘积空间 | `gaussianSpace` |
| 第 `k` 个坐标 | `coordinate k` |
| 独立同分布 | `iIndepFun` / `IdentDistrib` |
| 二阶矩有限 | `MemLp (coordinate 0) 2 gaussianSpace` |
| 标准化和之分布 | `centeredScaledSumLaw coordinate _ 0 1 n` |
| 弱收敛 | `Tendsto ... atTop (𝓝 ⟨gaussianReal 0 1, _⟩)` |
| 特征函数 | `charFun` |

# 依赖（人话版）

- `probability.clt.central-limit-theorem`：一般 iid CLT 的正式陈述，本 Entry 的唯一结论来源；
  本 Entry 不重新证明 CLT，只把它实例化。
- `probability.characteristic-function.levy-continuity`：把概率测度的弱收敛换算成特征函数
  逐点收敛；第 4 条结论经此接口得到。

# 应用与陷阱

- **应用**：这是“CLT 接口真的可用”的机器见证——它同时检查了 iid 构造、二阶矩、均值方差与
  退化的 `σ > 0` 条件都被具体对象满足，而不是停留在抽象假设。
- **陷阱一**：`iid_centeredScaled_clt` 要求 `σ > 0`。本 Entry 取 `σ = 1`；方差为零的常数序列
  由定理 `degenerateVariance_centeredSum_tendsto` 单独处理，不能代入本 Entry 的 `σ`。
- **陷阱二**：第 4 条只是**特征函数逐点收敛**，其成立的依据是目标极限本身是标准正态的特征函数、
  因而 Lévy 定理可直接用。若去掉“极限是已知概率测度的特征函数”这一输入，仅有逐点收敛
  不足以保证弱收敛（这正是 E9P.8 记录的反例边界，本轮未构造 Lean 反例，见 handoff）。
