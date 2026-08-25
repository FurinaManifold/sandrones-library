# Main review：F5.2 闭值域的零化子刻画

- reviewed_commit: `72e9809`（rebase 前 `ecedddb`）
- integrated_commit: `172c6fd`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-25

本批复用 `ContinuousLinearMap`、`dualOperator` 与 `StrongDual.polarSubmodule`，证明对偶核等于原
值域零化子、对偶值域包含于原核零化子，以及 Banach 空间情形
`range T` 闭当且仅当 `range T' = (ker T)⊥`。正向的核商、反 Lipschitz 估计和 Hahn--Banach
延拓，逆向的受控原像、范数化对偶函数和闭像论证均与公开结论强度一致。

条目诚实限定为第一批“零化子刻画”：尚未证明 `range T'` 的范数闭性、原／对偶四项闭值域等价
或 Fredholm 结论。共享 Registry、ROADMAP、Radar 和聚合导入由 Main 补齐，不构成返工。

后续权限：F5.2 四项闭值域等价继续 `development_open`；F5.5 Fredholm 定义层提升为
`development_open`，其指数稳定性与 Fredholm 备择仍按依赖保持后续门。
