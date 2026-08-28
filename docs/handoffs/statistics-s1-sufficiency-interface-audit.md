# S1 充分统计量与因子分解接口审计

- branch：`codex/probability`
- synced Main：`7adf2f0` 后经 merge `a66d329`
- gate：`statistics.sufficiency.definition = research_open`
- temporary prototype：`/tmp/SufficientStatisticFramework.lean`
- formal source：无；研究阶段没有写入 `SandronesLibrary/`

## 结论与推荐 carrier

Mathlib 当前没有现成 `SufficientStatistic`。一般充分性的字面定义应在标准 Borel 样本空间中使用
参数无关的正规条件分布：对模型 `P : Kernel Θ 𝓧` 和统计量 `S : 𝓧 → 𝓨`，要求 `S` 可测，并存在
同一个 Markov kernel `Q : Kernel 𝓨 𝓧`，使每个参数 `θ` 都满足

```lean
condDistrib id S (P θ) =ᵐ[(P θ).map S] Q
```

这准确表达“给定 `S` 后样本 `x` 的条件律不依赖参数”。`condDistrib` 的被条件变量值域是 `𝓧`，
所以它要求 `[StandardBorelSpace 𝓧] [Nonempty 𝓧]`；这是正规条件分布存在性的真实条件，不应隐藏。

另一个有用但语义不同的 carrier 是 Blackwell 重构：存在参数无关 Markov kernel `Q` 使

```lean
Q ∘ₖ (Kernel.deterministic S hS ∘ₖ P) = P.
```

它说明从统计量实验可随机重建原实验。该式不需要标准 Borel 假设，但单独使用时没有显式保证 `Q`
是“给定同一个 `S` 值”的条件律，因此正式定义优先采用 `condDistrib` 版本；重构式应作为后续刻画，
在适当正则性下由共同条件核推出，而不与定义静默等同。

## 概念六列表

| 概念 | 教材定义／语义 | Lean 正式承载候选 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 统计量 | 样本的可测函数 | `S : 𝓧 → 𝓨` 加 `Measurable S` | 其分布为 `(P θ).map S` | 与 estimator 定义层一致，不另造结构 | 充分性 | `statistics.sufficiency.definition` |
| 正规条件律 | 给定统计量值后的样本分布 | `condDistrib id S (P θ)` | a.e. 定义于 `(P θ).map S` | 复用标准 Borel disintegration | 参数无关性 | 同上 |
| 充分统计量 | 条件律不依赖参数 | 存在共同 `Q : Kernel 𝓨 𝓧` | 对每个 `θ` 的 kernel a.e. 相等 | 本库需建立谓词；Mathlib 无现成概念 | 重构刻画 | 同上 |
| Blackwell 重构 | 统计量实验经随机后处理恢复原模型 | kernel 复合等式 | `Q ∘ₖ (deterministic S ∘ₖ P)=P` | 复用 kernel composition | 条件律推出重构 | 同上 |
| 支配模型密度 | `dPθ/dν` 的联合可测版本 | `P.rnDeriv (Kernel.const Θ ν)` | 已有 `statistics.model.density` | 直接复用本库密度入口 | 因子分解 | `statistics.sufficiency.factorization`（候选） |
| Neyman--Fisher 因子分解 | `fθ(x)=gθ(Sx)h(x)` | `ℝ≥0∞` 联合可测函数及 `=ᵐ[ν]` | 参数逐点、样本 ν-a.e. | 必须保留 RN 版本与 a.e. 量词 | 充分性判据 | 同上 |
| 有限归一化因子分解 | 每个纤维上的 `h` 质量归一为一 | 有限 `ℝ≥0` 质量函数 | 显式构造 `q(y,x)` | 仅作原型，不冒充一般定理 | finite reconstruction | 研究原型 |

## 条件分布接口审计

- `condDistrib Y X μ : Kernel β Ω` 是 `Y` 给定 `X` 的正规条件分布；被条件变量值域 `Ω` 必须是
  standard Borel，底层测度有限。模型纤维 `P θ` 是概率测度，自动满足有限性。
- `condDistrib_comp_map hX hY` 给出
  `condDistrib Y X μ ∘ₘ μ.map X = μ.map Y`。取 `Y=id` 后正是共同条件核推出逐参数重构的核心后端。
- `condDistrib_ae_eq_iff_measure_eq_compProd` 以联合分布的 disintegration 等式刻画 kernel a.e. 相等；
  它可用于证明候选定义与教材“联合律分解”的一致性。
- 条件核只在统计量分布下 a.e. 唯一。要求 kernel 逐点相等会错误地约束零概率统计量值；正式 carrier
  必须保留 `=ᵐ[(P θ).map S]`。
- `condExpKernel` 面向固定测度和子 σ-代数。它可解释事件条件期望，但要比较不同参数 `θ` 的版本时
  仍需处理各自零集；`condDistrib` 的共同输出 kernel 更直接。

## 支配因子分解接口

已有 `Statistics/Density.lean` 提供联合可测密度

```lean
P.rnDeriv (Kernel.const Θ ν) θ x : ℝ≥0∞
```

建议因子分解候选为：存在联合可测 `g : Θ → 𝓨 → ℝ≥0∞` 和可测
`h : 𝓧 → ℝ≥0∞`，使每个 `θ` 都有

```lean
(fun x ↦ P.rnDeriv (Kernel.const Θ ν) θ x)
  =ᵐ[ν] (fun x ↦ g θ (S x) * h x).
```

不能写逐点等式：RN 导数只在 `ν`-a.e. 意义下唯一。也不能静默转成 `ℝ`，因为密度先取
`ℝ≥0∞`；现有条目只证明其 a.e. 非无穷。一般因子分解到共同条件核还需要构造纤维积分／商测度并
处理 `g=0` 的零纤维，正式开发前必须另行冻结证明条件。

## 有限离散无占位原型

`/tmp/SufficientStatisticFramework.lean` 定义有限质量函数的统计量边缘质量、归一化因子分解和重构
性质。假设

```text
pθ(x) = gθ(Sx) h(x),
sum_{x : Sx=y} h(x) = 1.
```

原型显式构造

```text
q(y,x) = if Sx=y then h(x) else 0.
```

并证明：每个 `q(y,·)` 总质量为一；统计量边缘质量等于 `gθ(y)`；最后

```text
pθ(x) = sum_y Pθ(S=y) q(y,x).
```

因此参数无关的 `q` 确实重建原模型。整个框架经
`lake env lean /tmp/SufficientStatisticFramework.lean` 编译通过，零错误、零 warning、零
`sorry/admit/sorryAx/native_decide`。定向依赖
`Mathlib.Probability.Kernel.CondDistrib` 构建通过（2970 jobs）。

## 诚实边界与开发建议

- 有限原型使用了“纤维归一化”的较强因子分解，以避开一般零纤维归一化；它不是完整
  Neyman--Fisher 定理的替代品。
- 一般充分性推荐 `condDistrib` a.e. carrier；Blackwell 重构作为刻画而不是无条件定义等价。
- 尚未证明一般因子分解定理，也没有正式 Entry、MLE、Fisher 信息、Cramér--Rao、完备统计量或
  Rao--Blackwell 定理。
- 请 Main 冻结：是否接受 standard-Borel 条件律定义、Blackwell 重构桥的条件，以及首批是否只
  开放定义与有限模型消费者。冻结前不写正式源码。
