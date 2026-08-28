# F6.6 全纯函数演算概念冻结 handoff

- 分支：`codex/functional-analysis-restart`
- 权限：`main-f65-accepted-f66-holomorphic-calculus-research-open.md` / `research_open`
- 目标 Entry：`functional-analysis.functional-calculus.holomorphic`
- 调查：`docs/maintenance/functional-analysis-f6-holomorphic-calculus-audit.md`

## 核心结论

当前 Mathlib 没有一般复 Banach 代数的 Dunford／holomorphic functional calculus package。
`ContinuousFunctionalCalculus`/`cfc` 是 C*-代数连续函数演算，定义域、对象范围和函数正则性都与
F6.6 不同，不能替代。

可立即冻结的最小 carrier 是：

```lean
variable {A : Type*} [NormedRing A] [NormedAlgebra ℂ A] [CompleteSpace A]

def HolomorphicOnNhdSpectrum (a : A) (f : ℂ → ℂ) : Prop :=
  ∃ U : Set ℂ, IsOpen U ∧ spectrum ℂ a ⊆ U ∧ DifferentiableOn ℂ f U
```

但完整 Dunford 定义还缺有限 cycle carrier、避谱／绕数条件和 cycle 选择无关性。单个
`circleIntegral` 或 C*-连续函数演算都不能填补这个缺口。

## 请求 Main 决策

建议只把 `foundation-neighborhood` 提升为窄幅 `development_open`：讲清谱邻域上的全纯函数定义，
证明限制／并集见证与常数、恒等、多项式正例，不定义 `f(a)`。完整 F6.6 保持研究状态，等待 Main
决定 cycle foundation 由泛函分析还是复分析 C2 负责。

请求冻结：

1. 一般 Banach 代数 carrier，而非仅有界算子或 C*-正规元素；
2. 谱邻域量词采用上述存在开集表达，暂不建立 germ quotient；
3. cycle foundation 的所有权与依赖 Entry；
4. 谱映射必须在乘法后单独证明，复合在谱映射后开放；
5. 连续函数演算、谱投影、谱测度继续保持现有冻结。
