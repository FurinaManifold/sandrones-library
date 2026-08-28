# F5.7 Fredholm stability：紧扰动子窗 handoff

- 分支：`codex/functional-analysis-restart`
- Main 同步提交：`6d83d73`
- 权限：`main-fredholm-composition-accepted-next-open.md` / `development_open`
- Entry：`functional-analysis.fredholm.stability-compact`

## 文件与接口

- `SandronesLibrary/FunctionalAnalysis/FredholmCompactPerturbation.lean`
- `docs/entries/functional-analysis/fredholm/stability-compact.md`
- `ContinuousLinearMap.IsFredholm.add_compact`
- `fredholmIndex_add_compact`

## 证明结构

1. 将有限秩连续线性映射经其有限维 range factorization 识别为紧算子；
2. 用 F5.6 的有限核、有限余核、闭值域链和 Banach 开映射定理，构造
   `identitySubCompact_isFredholm`；
3. 对 `T` 的拟逆 `S`，把 `(T+K)S` 写为 `I-C`，其中 `C` 是有限秩误差与紧误差之和；
4. 由 `(T+K)S` 的拟逆和 `IsQuasiInverse.of_comp_left` 消去 `S`，证明 `T+K` Fredholm；
5. 对 `TS`、`(T+K)S` 两次调用已冻结的 `fredholmIndex_comp`，再用
   `index_identitySubCompact_eq_zero` 消去复合项，得到指数不变。

Mathlib 没有被调用的最终“Fredholm + compact”稳定性 theorem；本提交真正完成了该推导。

## 权限推进

Main 已规定小扰动子窗在本 handoff 后由 `research_open` 自动转 `development_open`。本 handoff
请求核验紧扰动批，并按协议开始独立的小扰动文件；不把两批合并成一个不可审核提交。
