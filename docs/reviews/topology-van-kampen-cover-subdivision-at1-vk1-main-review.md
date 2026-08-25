# Main review：AT1-VK1 二开集覆盖道路细分

- branch: `codex/topology-foundations`
- reviewed_commits: `7db1ab9`, `9a70589`
- integrated_commits: `ac8d3ad`, `5f858a7`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

本批建立了 van Kampen 证明真正需要的有限数据层：二元开覆盖标签、单位区间一致网格、逐段包含
证书、标签切换顶点的交集成员性、子道路值域公式和有限拼接同伦。Lebesgue 数只作用于紧致度量
参数空间 `unitInterval`，公开陈述没有错误地要求原空间可度量。

正式实现直接复用 `Path.subpath`、`Path.range_subpath_of_le`、`Path.concat` 和
`Path.Homotopic.concat_subpath`，没有迁入 RFC 中废弃的自建仿射子段。结论没有构造规范同态，也
没有声称满射、单射、推送或 van Kampen 同构。模块闭包、联合接口、十一条公开声明映射、公理与
占位扫描均通过 Main 复验。

## 后续权限

- AT1-VK1 已接收并冻结公开 subdivision 接口。
- AT1-VK2 规范同态与满射：提升为 `development_open`；必须直接复用 `Monoid.PushoutI`，以 VK1
  数据建立有限 blocks、交集基点修正环路词和满射，不得提前声称单射或同构。
- AT1-VK3 网格零同伦与单射：维持 `research_open`。
- T4-R3：维持 `research_open`。
