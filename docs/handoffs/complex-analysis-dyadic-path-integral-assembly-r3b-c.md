# Complex analysis handoff：T4-R3b-C dyadic path-integral assembly

## Scope and gate

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`，同步合并提交 `55cc854`；
- prerequisite maintenance: `ae521d8` minimal primitive imports；
- permission: `main-961f4a6-permissions-expanded.md` 授权当前负责人迁移 C，并要求 namespace 保持
  `SandronesLibrary.ComplexAnalysis`；
- Entry: `complex-analysis.path-integral.dyadic-assembly`。

本批新增一个 ComplexAnalysis 模块、一篇 Entry 与本 handoff；不修改共有文件。源码 namespace 与
文件 ownership 均遵守 Main 指示。

## Mathematical results

公开面只有两项：

1. `admissiblePath_of_piecewiseC1` 把拓扑层 PiecewiseC1 证书、道路 range 控制和 `ContinuousOn f U`
   组装为既有解析层 `AdmissiblePath f U`；
2. `pathIntegral_eq_of_dyadicOuterBoundary` 从源／目标 dyadic 小段可积性、水平边贡献为零、左右边值
   等于相应叶子积分及定向外边界总和为零，推出整条源／目标道路积分相等。

第二项内部证明 dyadic leaf sums 重构整道路积分；不以旧同伦不变性作为后端。

## Concept inventory and signature audit

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| admissible path | 位于域内且逐 C1 piece 可积 | 既有 `AdmissiblePath` | `admissiblePath_of_piecewiseC1` | 本库既有解析 carrier | R3b-E | 本 Entry |
| 分段 C1 | 有限整体 C1 道路拼接 | 既有 `Path.PiecewiseC1` | bridge 的源侧 | 本库拓扑谓词 | admissibility bridge | 本 Entry |
| dyadic leaf | `k/2^n` 相邻端点间子道路 | Mathlib `Path.subpath` + shared mesh | private half reindex | 正式承载 | reconstruction | 本 Entry |
| 道路可积与积分 | scalar one-form 的曲线可积／积分 | `PathIntegrable`、`pathIntegral` | midpoint additivity | 正式承载 | outer-boundary theorem | 本 Entry |
| 有限定向边界和 | 下减上、右减左的有限和 | `Finset.sum` on `Fin (2^n)` | `houter` | 正式承载 | final equality | 本 Entry |

公开签名不出现开覆盖选择、local primitive、同伦 carrier、C2 正则性或方格实现 structure。private
后端包括半区间参数变换、dyadic reindex、finite-sum split 与 integrability recursion；没有泄漏新 carrier、
instance 或 notation。

## Entry ownership and verification

已验证：

- `lake build SandronesLibrary.ComplexAnalysis.DyadicPathIntegralAssembly`：2764 jobs，通过；
- `/tmp/DyadicPathIntegralAssemblyAggregate.lean` 同时检查 `Path.PiecewiseC1`、`AdmissiblePath`、bridge、
  `PathIntegrable`、共享 mesh、finite sum 与 outer-boundary theorem，通过；
- mapper 精确得到 1 Entry / 2 public theorems；所有 private dyadic recursion helper 均未吸入；
- 两个公开定理公理均为 `[propext, Classical.choice, Quot.sound]`；
- placeholder、新 axiom、instance、notation、全名碰撞、冲突标记与 `git diff --check` 扫描通过。

E/F 尚未正式迁入，分别在其独立提交中验证真实消费。

## Honest boundary

本批不选开覆盖或局部原函数，不证明任意二维同伦内部边可积，不产生外边界等式，也不直接证明
同伦不变性。R3b-E 负责 raw grid 的解析附加与逐格消去，R3b-F 负责最终组合；全局 relative-`C²`
签名仍被禁止。
