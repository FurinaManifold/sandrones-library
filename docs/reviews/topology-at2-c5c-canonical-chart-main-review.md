# AT2-C5c 子群 covering canonical chart Main 验收

- 学科提交：`9247e8f`
- Main 接收提交：`ff0cbe2`
- Entry：`topology.covering.subgroup-canonical-chart-standard`
- Verdict：`accepted`

## 数学裁决

本批从 C5b 的子群道路类商出发，以可消 loop 的开道路连通小邻域建立 canonical product chart。
固定终点道路类商只充当离散局部坐标；重叠转换的 fiber 坐标由
`isLocallyConstant_chartTransitionFiber` 证明局部常值，因而 chart 的双向映射连续。

总空间拓扑由这些 chart generator 生成，没有把未经证明的 quotient topology 当作标准答案。
最终证明使用 `IsEvenlyCovered.to_isEvenlyCovered_preimage` 把私有离散坐标换成实际投影 fiber，
公开结论是 Mathlib `IsCoveringMap`。因此源码、Entry 标题和 ROADMAP 完成强度一致。

## 边界与后续门

本批只完成“由子群构造 covering”的方向；没有从 covering 恢复子群，没有 pointed/unpointed 分类
双射，也没有 universal cover。Main 将 AT2-C5d 的“从 pointed covering 恢复子群”开放为
`research_open`，更后的互逆与分类批次继续冻结。
