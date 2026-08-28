# F6.6 holomorphic neighborhood foundation handoff

- 分支：`codex/functional-analysis-restart`
- 权限：`main-f66-neighborhood-foundation-development-open.md` / `development_open`
- Entry：`functional-analysis.functional-calculus.holomorphic-neighborhood`
- 前置 Main：`9670fa6`

## 文件与接口

- `SandronesLibrary/FunctionalAnalysis/HolomorphicNeighborhood.lean`
- `docs/entries/functional-analysis/functional-calculus/holomorphic-neighborhood.md`
- `HolomorphicOnNhdSpectrum`
- `holomorphicOnNhdSpectrum_of_open`
- `holomorphicOnNhdSpectrum_of_subset`
- `HolomorphicOnNhdSpectrum.exists_inter`
- `HolomorphicOnNhdSpectrum.const`、`.id`、`.polynomial`、`.add`、`.mul`

## 实现说明

定义准确保留 `∃ U, IsOpen U ∧ spectrum ℂ a ⊆ U ∧ DifferentiableOn ℂ f U`。定义只描述函数演算
输入，因此不人为要求完备性；未来定义 Dunford 积分的消费者仍须在 `[CompleteSpace A]` 下工作。

加法与乘法先用 `exists_inter` 取得共同开谱邻域，再消费 Mathlib 的 `DifferentiableOn.add/mul`，
没有把不同见证邻域静默视为同一个集合。常数、恒等与多项式使用全平面作为见证。

## 冻结边界

没有定义 `f(a)`、germ quotient、Dunford integral、cycle、winding、代数同态、谱映射或复合定理；
也没有调用 C*-连续函数演算 `cfc`。完整 F6.6 继续保持 `research_open`，cycle foundation 仍归复分析。
