# F5.7 Fredholm stability：复合子窗 handoff

- 分支：`codex/functional-analysis-restart`
- Main 同步提交：`9974026`
- 权限：`main-f5-final-f6-definition-accepted-more-open.md` / `development_open`
- Entry：`functional-analysis.fredholm.stability`

## 文件与接口

- `SandronesLibrary/FunctionalAnalysis/FredholmComposition.lean`
- `docs/entries/functional-analysis/fredholm/stability.md`
- `ContinuousLinearMap.IsFredholm.comp`
- `fredholmIndex_comp`

## 证明承载

复合 Fredholm 性通过提取两边的 `LinearMap.IsQuasiInverse` 并反序复合，再由
`IsFredholm.of_isQuasiInverse` 收尾。指数可加性在显式安装四个有限维核／余核实例后调用
`LinearMap.index_comp`；该 Mathlib theorem 的证明是六项正合列，而非最终 Fredholm 稳定性 package。

## 边界

本提交只冻结复合与指数加法接口。紧扰动、小扰动仍在 F5.7 后续独立文件开发，不把它们伪装成
复合结论的简单 corollary。
