# AT2-C5b 道路类商签名 Main 预审

结论：签名通过，C5b 转为 `development_open`。

Main 实际复跑 `/tmp/CoveringSubgroupPathClassCandidate.lean`，结果零错误、零警告；另置的
`CoveringSubgroupPathClassDifferenceBridge.lean` 只有已明确延后的教材差环路 iff `sorry`，不进入
本轮正式源码。

冻结决定如下：

- 使用含变动终点及端点固定道路同伦类的 dependent structure；
- `prepend_mul` 保留 Mathlib 基本群乘法导致的反作用公式；基点 fiber 方向记为右陪集 `gH`；
- `related_refl`、`related_symm`、`related_trans` 保持公开，它们是 setoid 与后续关系推理的自然小接口；
- 本批只允许 carrier、prepend、轨道关系及等价性、setoid、quotient 和 endpoint projection；
- 差环路 iff、任何 topology instance、连续性、局部 chart 与 `IsCoveringMap` 全部留待后续。

C5c 继续冻结，等待 C5b 正式 handoff 与 Main 验收。
