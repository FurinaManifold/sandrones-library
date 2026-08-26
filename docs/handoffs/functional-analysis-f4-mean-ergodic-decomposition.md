# F4.9 mean-ergodic.decomposition handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`2c67e3c`
- 权限：第一批 `development_open`
- Entry：`functional-analysis.ergodic.mean`
- integration_waits_for：无；只复用已进入 Main 的弱拓扑、双零化子与基础 Birkhoff average

## 文件

- `SandronesLibrary/FunctionalAnalysis/MeanErgodicDecomposition.lean`
- `docs/entries/functional-analysis/mean-ergodic-decomposition.md`
- 本 handoff

## 概念清单

| 概念 | 教材语义 | 正式承载 | 展开／桥 | 首个使用者 |
|---|---|---|---|---|
| 幂一致有界 | `∃ c≥1, ∀n, ‖Tⁿ‖≤c` | `IsPowerBounded` | 定义本身 | 汇总分解定理 |
| Cesàro 平均 | `n⁻¹∑_{k<n}Tᵏx` | Mathlib `birkhoffAverage` | `meanErgodicAverage_apply` | 统一范数界 |
| 收敛域 | 平均在范数中有极限 | `meanErgodicConvergenceSubmodule` | carrier 展开 | 分解等式 |
| fixed space | `Tx=x` | `LinearMap.eqLocus T 1` | `meanErgodicFixedSubmodule` abbrev | 直和左项 |
| 差分像闭包 | `closure(range(T-1))` | `Submodule.topologicalClosure` | `meanErgodicDifferenceClosure` abbrev | 直和右项 |
| 弱收敛子列 | 逐连续泛函收敛 | `StrongDual` + `Tendsto` | 最终 iff | 收敛判据 |

## 公开签名扫描

- 正式 Mathlib 承载：`birkhoffAverage`、`ContinuousLinearMap`、`LinearMap.eqLocus`、
  `Submodule.topologicalClosure`、`StrongDual`、`Tendsto`；均在 Entry 解释。
- 本库特殊定义：只有教材确实需要的 `IsPowerBounded`、算子值平均提升与收敛域；平均提升有公开
  点值桥，固定点和差分闭包只是透明 abbrev。
- 私有后端：两个闭分量的加法 CLM、anti-Lipschitz 闭值域证明。
- 越级泄漏：无；未要求内积、正交投影、谱或测度结构。

## 交付强度

- 收敛域闭且 `T`-不变；
- 收敛域等于 fixed space 与 `closure(range(T-1))` 的和；
- 两个分量交为零，故为内部直和；
- 范数收敛 iff 存在逐对偶泛函弱收敛子列。

## 冻结边界

本批不包含自反空间处处收敛和极限投影。Main 原权限要求它们等待本接口验收，不能从已集成 F4.7
自行推断为当前批次授权。

## Main 集成建议

- 增加顶层 `MeanErgodicDecomposition` import；
- 登记 Entry，并将 F4.9 decomposition 第一批标记完成；
- 若接口验收，下一窗可开放 reflexive convergence / limit projection；
- 共有 Registry、ROADMAP、RADAR 与生成索引仍由 Main 修改。
