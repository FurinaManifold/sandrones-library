---
id: statistics.method-of-moments
family: statistics.estimator
variant: textbook
kind: definition
state: verified
title: 矩估计
summary: 以总体矩映射的配平等式定义矩估计，显式列出模型族可测性、矩存在性、识别性与矩方程适定性，并给出相合性的拓扑转移
premises: [statistics.model.definition, statistics.estimator.definition]
mathlib: [MeasureTheory.integral, MeasureTheory.Integrable, MeasureTheory.StronglyMeasurable.integral_kernel, MeasureTheory.TendstoInMeasure, ProbabilityTheory.Kernel.deterministic]
provenance:
  source_type: book
  ref: "schervish-theory-statistics-1995"
---

# 动机

矩估计是参数估计最古老的方法：选取若干统计量，令其**样本矩**等于**总体矩**，再解出参数。
教材写法通常停留在"解方程"的层面，但要把这件事写成 Lean 定理，必须先回答三个问题：

1. **总体矩是什么对象？** 它是统计量关于模型纤维的积分，因此"模型族随参数可测"不是自动的，
   需要一条真实的引理。
2. **积分何时真的表示矩？** Bochner 积分对不可积函数返回 `0`；不写清可积性，"矩"就退化成
   一个常数零，而不是概率论对象。
3. **"解方程"何时给出相合估计？** 单射（识别性）只保证"矩相等 ⟹ 参数相等"，不保证
   "矩接近 ⟹ 参数接近"；后者是收敛性证明真正需要的东西。

本条目的目标就是把这三点全部显式化，而不是把它们塞进一个模糊的"矩估计"定义里。

# 教材定义与量词

设 `P : Kernel Θ 𝓧` 是统计模型（`[IsMarkovKernel P]`），`T : 𝓧 → 𝓨` 是实赋范空间值的统计量。
参数 `θ` 下的**总体矩**是

\[
  m_T(\theta)=\int_{\mathcal X} T(x)\,P_\theta(dx).
\]

给定**样本矩**统计量 `S : 𝓧 → 𝓨`（例如 `n` 份样本的经验均值，但本条目不构造它），
**矩估计**是可测映射 `θ̂ : 𝓧 → Θ`，使得对**每个**观测 `x`

\[
  m_T(\hat\theta(x))=S(x).
\]

量词层级是：等式逐点成立（不是几乎处处），可测性是估计量身份的一部分。这里不需要"几乎处处"
是因为 `m_T` 是真正的函数而不是密度版本——与最大似然估计必须写成 `ν`-a.e. argmax 的情形不同，
矩映射没有"版本差异"问题。

`𝓨` 取任意实赋范空间，因此 `𝓨 = ℝ^k` 的多元矩系统可以直接表达；本条目仍只冻结"一个矩向量"
的载体，不决定"用哪 `k` 个矩"。

# Lean 正式承载

不另建 `Moment`、`EmpiricalMeasure` 或 `MethodOfMoments` 结构：

```lean
noncomputable def momentMap (P : Kernel Θ 𝓧) (T : 𝓧 → 𝓨) (θ : Θ) : 𝓨 :=
  ∫ x, T x ∂(P θ)

def IsMethodOfMomentsEstimator (P : Kernel Θ 𝓧) (T : 𝓧 → 𝓨) (S : 𝓧 → 𝓨)
    (θhat : 𝓧 → Θ) : Prop :=
  Measurable θhat ∧ ∀ x, momentMap P T (θhat x) = S x
```

`isMethodOfMomentsEstimator_iff` 是逐字展开，不引入第二套同义谓词。

# 前提一：模型族可测性

```lean
theorem momentMap_measurable [MeasurableSpace 𝓨] [BorelSpace 𝓨]
    (P : Kernel Θ 𝓧) (T : 𝓧 → 𝓨) (hT : StronglyMeasurable T) :
    Measurable (momentMap P T)
```

这是 kernel 的参数可测性经积分后的结论，正式承载是 Mathlib 的
`MeasureTheory.StronglyMeasurable.integral_kernel`。注意它**只要求 `T` 强可测，不要求可积**：可测性是
"矩函数是参数空间上的可测对象"这一件事，与"这个积分是不是矩"是两回事。额外的
`[MeasurableSpace 𝓨] [BorelSpace 𝓨]` 是从 `StronglyMeasurable` 转到 `Measurable` 的真实代价，
只在需要可测性时出现，不污染其他定理。

# 前提二：矩存在性

Bochner 积分的约定是：不可积时 `∫ x, T x ∂(P θ) = 0`。因此没有可积性假设时 `momentMap P T θ`
只是退化值 `0`。本条目把可积性逐条写进消费者：

```lean
theorem momentMap_add (P) (T T') (θ)
    (hT : Integrable T (P θ)) (hT' : Integrable T' (P θ)) :
    momentMap P (T + T') θ = momentMap P T θ + momentMap P T' θ
```

以及两个语义锚点：

* `momentMap_const`：概率模型下常数统计量的矩就是该常数。证明直接引用
  `statistics.model.definition` 的 `statisticalModel_measure_univ`——模型总质量为一。
* `momentMap_deterministic`：确定性观测模型 `Kernel.deterministic g hg` 下，
  `momentMap (Kernel.deterministic g hg) T θ = T (g θ)`。这把矩估计接到模型条目的确定性桥上。

# 前提三：识别性与矩方程适定性

```lean
def MomentIdentifiable (P : Kernel Θ 𝓧) (T : 𝓧 → 𝓨) : Prop :=
  Function.Injective (momentMap P T)

def MomentEquationWellPosedAt (P : Kernel Θ 𝓧) (T : 𝓧 → 𝓨) (θ₀ : Θ) : Prop :=
  ∀ ε, 0 < ε → ∃ δ, 0 < δ ∧
    ∀ θ, edist (momentMap P T θ) (momentMap P T θ₀) < δ → edist θ θ₀ < ε
```

两者是不同强度的条件，本条目刻意分开：

* **识别性**给出唯一性（`methodOfMomentsEstimator_unique`）：同一个 `S` 至多对应一个矩估计；
  并在样本矩恰好等于真值时迫使估计等于真值
  （`methodOfMomentsEstimator_eq_const_of_sample_moment_eq`）。
* **适定性**是识别性的加强：它说矩映射的逆在 `θ₀` 连续。教材通常由"参数空间紧 + 矩映射连续 +
  单射"推出它；本条目把它作为**显式假设**，不从紧性推导（见边界一节）。

`methodOfMomentsEstimator_isMarkov` 说明矩估计经 Dirac kernel 进入
`statistics.estimator.definition` 的随机化估计量接口，证明直接复用该条目的
`deterministicEstimator_isMarkov`，不重复接口桥。

# 相合性转移

```lean
theorem methodOfMomentsEstimator_tendstoInMeasure (P : Kernel Θ 𝓧) [IsMarkovKernel P]
    (T : 𝓧 → 𝓨) (S : ℕ → 𝓧 → 𝓨) (θhat : ℕ → 𝓧 → Θ) (θ₀ : Θ)
    (hwp : MomentEquationWellPosedAt P T θ₀)
    (hS : TendstoInMeasure (P θ₀) S atTop (fun _ => momentMap P T θ₀))
    (hθ : ∀ n, IsMethodOfMomentsEstimator P T (S n) (θhat n)) :
    TendstoInMeasure (P θ₀) θhat atTop (fun _ => θ₀)
```

三条前提分别对应三件不同的事：**适定性**（矩方程可逆且稳定）、**大数定律**（样本矩依概率收敛到
真值处总体矩，这里只作假设）、**每个阶段确实在解矩方程**。证明本身只是测度单调性加夹逼：

\[
  \{\varepsilon\le d(\hat\theta_n,\theta_0)\}
  \subseteq
  \{\delta\le d(S_n,m_T(\theta_0))\},
\]

右端概率按 `hS` 趋于零。本条目**不证明大数定律**，也不构造样本矩 `S n`；共同观测空间约定与
`statistics.estimator.consistency` 一致，使所有 `S n`、`θ̂ n` 落在同一个概率空间上。

# Mathlib 角色分类

- `MeasureTheory.integral`：**语义一致的正式承载**。总体矩就是 Bochner 积分，不重造积分。
- `MeasureTheory.Integrable`：矩存在性的正式承载，出现在 `momentMap_add` 等公开签名中。
- `MeasureTheory.StronglyMeasurable.integral_kernel`：**私有证明后端**，把 kernel 的参数可测性搬到积分之后；
  公开结论是 `Measurable (momentMap P T)`。
- `MeasureTheory.TendstoInMeasure`：**语义一致的正式承载**，与相合性条目共用同一收敛谓词。
- `ProbabilityTheory.Kernel.deterministic`：估计量身份的桥，经
  `statistics.estimator.definition` 的接口使用。
- `MeasureTheory.integral_add`、`MeasureTheory.integral_const`、
  `ProbabilityTheory.Kernel.integral_deterministic'`：证明后端，不出现在核心公开签名里。

# 依赖与边界

依赖 `statistics.model.definition`（模型与 Markov 纤维、`statisticalModel_measure_univ`）与
`statistics.estimator.definition`（`deterministicEstimator_isMarkov`）。两条依赖都有真实的
声明消费者，不是仅凭概念相邻而登记。

**本条目不证明**：样本矩的构造（无经验测度、无 `(1/n)∑ T(Xᵢ)`）、大数定律、从"参数空间紧 +
矩映射连续 + 单射"推出 `MomentEquationWellPosedAt`、矩估计的渐近正态性与有效性，也不处理
"矩条件个数多于参数维数"的一般 `k` 矩联合系统的选择问题。`MomentEquationWellPosedAt` 用
`edist` 表述（对 `Θ` 只要求 `PseudoMetricSpace`），这是 `TendstoInMeasure` 的原生形式；
在度量空间上它与 `dist` 的 ε-δ 形式等价，本条目不额外搬运这条换算。
