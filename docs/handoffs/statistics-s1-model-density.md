# S1 支配模型与联合可测密度交接

- entry：`statistics.model.density`
- branch：`codex/probability`
- formal source：`SandronesLibrary/Statistics/Density.lean`
- files：
  - `SandronesLibrary/Statistics/Density.lean`
  - `docs/entries/statistics/model/density.md`
  - `docs/handoffs/statistics-s1-model-density.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 支配模型 | 每个 `P θ` 都绝对连续于固定参考测度 `ν` | `∀ θ, P θ ≪ ν` | 各定理保留点态假设 `P θ ≪ ν` | 不自建 dominated-model 结构 | 模型密度 | `statistics.model.density` |
| 联合可测密度 | 同一版本 `p(θ,x)` 对参数和样本联合可测 | `P.rnDeriv (Kernel.const Θ ν)` | `statisticalModel_density_jointlyMeasurable` | 直接复用 Kernel RN；不逐参数选择 Measure RN | likelihood／参数积分 | `statistics.model.density` |
| 逐参数 RN 一致性 | kernel 版本与普通 RN 导数 a.e. 相同 | `statisticalModel_density_ae_eq_measure_rnDeriv` | `=ᵐ[ν]` | 复用 `Kernel.rnDeriv_eq_rnDeriv_measure` | 概率重建 | `statistics.model.density` |
| 密度重建 | `Pθ(A)=∫_A pθ dν`，总积分一 | `statisticalModel_withDensity_eq`、`statisticalModel_setLIntegral_density`、`statisticalModel_lintegral_density_eq_one` | 测度等式、集合积分和归一化 | 复用 `withDensity_rnDeriv_eq` 与 `setLIntegral_rnDeriv` | likelihood | `statistics.model.density` |

## 公开边界

- 保留 `CountableOrCountablyGenerated Θ 𝓧`，不隐藏 kernel RN 联合可测性的存在条件。
- 参考测度取有限测度，使 `Kernel.const Θ ν` 满足现有有限 kernel 重建 API；一般 σ-有限版本未冒充完成。
- 密度值域保留 `ℝ≥0∞`；仅证明 `ν`-a.e. 非无穷，没有静默 `.toReal`。
- 唯一性和与 Measure RN 的一致性均为 a.e.，没有声称逐点规范代表。
- 本批未开放 MLE、一般估计量、充分性或 Fisher 信息。

## Main 集成门

- `lake build SandronesLibrary.Statistics.Density`：通过。
- 聚合文件同时检查 Kernel RN carrier、联合可测性、逐参数一致性、重建、集合积分、归一化和
  a.e. 有限性：通过。
- 新增声明 `#print axioms` 仅含 Lean／Mathlib 标准公理；无 `sorryAx`。
- 禁用占位扫描和 `git diff --check`：通过。

Main 集成时请确认 Registry id `statistics.model.density`，唯一 `lean_file` 指向
`SandronesLibrary/Statistics/Density.lean`；运行 Entry 映射、axiom/audit、索引生成和全库构建。
学科 worktree 不修改 Main 所有的共享文件。
