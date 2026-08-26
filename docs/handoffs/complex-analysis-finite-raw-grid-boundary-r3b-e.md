# Complex analysis handoff：T4-R3b-E finite raw-grid boundary cancellation

## Scope and automatic gate

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`，同步合并提交 `55cc854`；
- direct batch dependencies: C commit `c38b7b7` 与 D commit `40067cb`；
- permission: `main-961f4a6-permissions-expanded.md` 规定 C+D handoff 后 E 自动
  `development_open`；两份 handoff 与 ready notices 均已完成；
- namespace: `SandronesLibrary.ComplexAnalysis`，符合 Main 指示；
- Entry: `complex-analysis.path-integral.finite-raw-grid-boundary`。

本批新增一个模块、一篇 Entry 与本 handoff，不修改共有文件。

## Mathematical result

`finiteRawOpenPathGrid_outerBoundaryIntegral_eq_zero`：若 raw grid 每格开集上 `f` 都有局部 primitive，
则整张网格的下减上、右减左外边界 path-integral 总和为零。

证明为每条内部全局边只选择一次相邻 cellSet 交内的 PiecewiseC1 replacement；每格用局部 primitive
得到四边和为零，再对原生 `Fin` indices telescope。四侧 replacement definitionally 保留 raw outer
edges，因此公开结论不泄漏 choice。

## Concept inventory and public signature

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 逐格局部 primitive | 每格开集上存在导数为 f 的函数 | Mathlib `Complex.IsExactOn` | choose + derivative spec | 正式承载 | cell boundary | 本 Entry |
| 公共边正则替换 | 相邻格交内同端点 PiecewiseC1 道路 | private existential choices | R3a open-set replacement | 私有后端 | two adjacent cells | 本 Entry |
| 单格积分消去 | 四边积分化为 primitive 端点差 | private theorem | C admissibility bridge | path integral 正式承载 | grid telescope | 本 Entry |
| 二维内部边抵消 | 每条内部边一正一负 | private native-`Fin` telescope | row/column adjacent sums | `Finset.sum` 正式承载 | public theorem | 本 Entry |
| raw 外边界 | 下减上、右减左 | public finite sum equality | four raw edge families | raw grid premise | R3b-F | 本 Entry |

唯一公开 theorem 的签名只暴露 `FiniteRawOpenPathGrid ℂ`、`Complex.IsExactOn`、`pathIntegral`、`Fin` 与
有限和；这些均已在本 Entry 或 premise Entry 解释。内部 replacement carrier、Classical.choose、局部
primitive function 和 exact telescoping lemmas 全部 private。无全局 primitive、C2、同伦或 cover label
泄漏，无 instance/notation。

## Verification contract

已验证：

- `lake build SandronesLibrary.ComplexAnalysis.FiniteRawOpenPathGridBoundary`：2834 jobs，通过；
- `/tmp/FiniteRawOpenPathGridBoundaryAggregate.lean` 同时检查 raw-grid carrier、`Complex.IsExactOn`、C
  bridge、公开 theorem，并实际构造 `steps = 0` raw grid、应用公开定理得到退化外边界零等式；
- mapper 精确得到 1 Entry / 1 public theorem；全部 replacement、analytic carrier 与 telescope helper
  保持 private；
- 公开定理公理为 `[propext, Classical.choice, Quot.sound]`；
- placeholder、新 axiom、instance、notation、全名碰撞、冲突标记与 `git diff --check` 扫描通过。

## Honest boundary

本批假设每格 exactness，不从 holomorphic 函数自动构造局部 primitive；该选择由 F 使用 Mathlib 局部
原函数覆盖完成。本结果不产生全局 primitive，也不证明任意同伦的积分不变性。它只交付 F 所需的
有限 raw-grid 外边界等式。
