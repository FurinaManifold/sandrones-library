# F6.6 holomorphic neighborhood foundation handoff

- 分支：`codex/functional-analysis-restart`
- 权限：`main-f66-neighborhood-foundation-development-open.md` / `development_open`
- Entry：`functional-analysis.functional-calculus.holomorphic-neighborhood`
- 前置 Main：`9670fa6`
- 学科提交：`efda4de`；Banach carrier 修正：`25e8950`
- Main 接收：`f1cc927`、`7caca86`
- 最终状态：`accepted`

## 文件与接口

- `SandronesLibrary/FunctionalAnalysis/HolomorphicNeighborhood.lean`
- `docs/entries/functional-analysis/functional-calculus/holomorphic-neighborhood.md`
- `HolomorphicOnNhdSpectrum`
- `holomorphicOnNhdSpectrum_of_open`
- `holomorphicOnNhdSpectrum_of_subset`
- `HolomorphicOnNhdSpectrum.exists_inter`
- `HolomorphicOnNhdSpectrum.const`、`.id`、`.polynomial`、`.add`、`.mul`

## 实现说明

定义在显式 `[CompleteSpace A]` 下准确保留
`∃ U, IsOpen U ∧ spectrum ℂ a ⊆ U ∧ DifferentiableOn ℂ f U`，严格采用 Main 冻结的复 Banach
代数 carrier。

加法与乘法先用 `exists_inter` 取得共同开谱邻域，再消费 Mathlib 的 `DifferentiableOn.add/mul`，
没有把不同见证邻域静默视为同一个集合。常数、恒等与多项式使用全平面作为见证。

## 冻结边界

没有定义 `f(a)`、germ quotient、Dunford integral、cycle、winding、代数同态、谱映射或复合定理；
也没有调用 C*-连续函数演算 `cfc`。完整 F6.6 继续保持 `research_open`，cycle foundation 仍归复分析。

## 后续窗口

谱邻域基础已经进入 Main。后续拆分为 `functional-analysis.functional-calculus.resolvent-integrand`
（F6b1，`development_open`）与完整 Dunford 演算（F6b2，`research_open`）；F6b1 不得引入 cycle、
路径积分或 `f(a)`，F6b2 继续等待复分析的中性 finite-cycle / winding carrier。
