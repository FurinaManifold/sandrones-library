# Main review：AT1-VK3b-11c 同路局部表示的统一 gauge 比较

- reviewed commit: `c7fd9e6`
- integrated commit: `2b0f729`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

本批把同一环境道路在同标签与异标签下的两套局部基本群表示统一为 endpoint gauge 的
`rebaseEdge` 公式。异标签分支复用 11b 的 intersection lift 与 Pushout relation；同标签分支把两套
connectors 放入既有 `CommonEdgeConnectorComparison`，没有复制道路、基本群、Pushout 或 comparison
carrier。`e⁻¹ * q * s` 的逆元与非交换次序被正式保留。

公开面为 20 public / 4 private。Main 独立构建目标模块通过（1765 jobs），aggregate 名称、公理检查
通过，并依次编译未修改的 12a `VanKampenLeftBoundaryEdge` 与 `VanKampenLeftBoundaryTransport`
候选，确认公开面满足真实消费者。11c 接收，12a 转为 `development_open`；12b--15 继续冻结。
