# Main review：AT1-VK3b-07b 二维规范化 gauge

- branch: `codex/topology-foundations`
- reviewed_commit: `8dcab3a`
- integrated_commit: `59038e6`
- reviewer: `main`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-26

## 验收结论

本批利用同伦方形边界的严格基点识别构造格角 potentials，逐列选择使上下横边重基化为单位元的
frames，再沿竖直 transitions 传播到全部行。公开高层结论只证明完整行和完整网格的左右 holonomy
相等，没有把任一侧加强为单位元，也没有提前声称 kernel、单射或 van Kampen 同构。

源码已由 36 public / 1 private 收缩为 17 public / 20 private；通用
`framedRowPrefix_horizontal_words_eq_one` 及全部二维递归状态均为 private。08a/08b 对
`FramedHorizontalRowPrefixState`、`framedHorizontalRowPrefixState` 与 `framedRowPrefix_*` 的引用均为
零，后续只消费 `gaugeNormalizedRowFrames` 三接口和
`framedFullRow_leftEdge_eq_rightEdge`。本模块复用 07a 的 `CellVertexFrames`，没有制造第二套 frame。

Main 独立构建正式 07b（1757 jobs），并编译未修改的 08a 直接消费者。学科 handoff 中“临时
VK3b07 aggregate 通过”的说法不准确：该临时文件仍检查 07a 已转 private 的
`FocusedBoundary.attachRight`。这不影响正式模块或下游接口，Main 已直接修正文档而未退回数学成果。

## 后续权限

- AT1-VK3b-07b 已接收，公开接口从此按维护规程管理；
- AT1-VK3b-08a `VanKampenRowAnchoring` 为 `development_open`，可立即从最新 Main 开工；
- AT1-VK3b-08b `VanKampenRightAnchoredGrid` 保持开放，但正式提交依赖 08a 先进入 Main；
- AT1-VK3b-09 继续冻结，直到 08a、08b 全部进入 Main。
