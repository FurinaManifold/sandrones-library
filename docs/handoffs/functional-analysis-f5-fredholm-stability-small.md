# F5.7 Fredholm stability：小扰动子窗 handoff

- 分支：`codex/functional-analysis-restart`
- 权限：紧扰动 handoff 后按 `main-fredholm-composition-accepted-next-open.md` 自动转
  `development_open`
- Entry：`functional-analysis.fredholm.stability-small`
- 前置提交：`0d30afe`

## 文件与接口

- `SandronesLibrary/FunctionalAnalysis/FredholmSmallPerturbation.lean`
- 更新 `FredholmCompactPerturbation.lean`，公开有限秩推出紧性的共享桥
- `docs/entries/functional-analysis/fredholm/stability-small.md`
- `exists_fredholm_smallPerturbation_radius`

## 证明结构

对 Fredholm `T` 取拟逆 `S`，选择 `ε=(‖S‖+1)⁻¹`。当 `‖K‖<ε` 时：

1. 算子范数次乘性给出 `‖KS‖<1`；
2. Neumann 判据使 `B=I+KS` 可逆，因此 `B` Fredholm 且指数为零；
3. `(T+K)S = B+(TS-I)`，其中 `TS-I` 有限秩，故由紧扰动批推出该复合 Fredholm 且指数为零；
4. `IsQuasiInverse.of_comp_left` 消去 `S`，得到 `T+K` Fredholm；
5. 两次 `fredholmIndex_comp` 比较 `(T+K)S` 与 `TS`，消去 `index(S)`，得到指数局部常值。

## 验收边界

本批与紧扰动批分文件、分提交。它没有调用 Mathlib 最终 Fredholm 开性 theorem，也没有进入仍为
`research_open` 的 F6.5 正式源码。F5.7 三个子窗至此全部具备 handoff。
