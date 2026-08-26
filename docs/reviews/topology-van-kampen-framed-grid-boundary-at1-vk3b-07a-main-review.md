# Main review：AT1-VK3b-07a framed 行与有限网格外边界

- branch: `codex/topology-foundations`
- reviewed_commit: `fd72676`
- integrated_commit: `bf6ebcf`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-26

## 验收结论

本批以四顶点 frames 重基化小格边界，先按列建立非交换 framed-row telescope，再按行消去公共横边，
最终给出完整有限网格的四侧 perimeter relation。公开结论没有把“四侧乘积为一”加强成任一外侧词
单独为一，也没有提前声称 kernel、单射或 van Kampen 同构。

首次预审发现源码把约 46 个递归 proof-state 和粘合 helper 一并公开。负责人返工后收缩为 16 个
public / 32 个 private 声明；`FramedHorizontalRowPrefixState` 两项只为 07a -> 07b 物理拆批保持
可见，08a/08b 对 prefix 名称没有源码引用。`FocusedBoundary` 因出现在公开 full-row state 返回类型
且由 07b 读取字段而保留公开，其 attach 构造链仍为 private。四个高层 boundary-word 定义隔离了
私有跨行递归状态，最终公开 theorem type 没有 private 名泄漏。

Main 在收缩后的正式源码上独立构建 07a（1756 jobs），并用未修改的 07b 候选复验跨模块消费；
全库构建 8972 jobs 通过。Registry 登记 16 个公开声明的公理并集仅为 `propext`、
`Classical.choice`、`Quot.sound`；依赖、文献、派生索引、排行、禁用项和 `git diff --check` 均通过。

## 后续权限

- AT1-VK3b-07a 已接收，公开接口从此按维护规程管理；
- AT1-VK3b-07b `VanKampenNormalizedGridGauge` 继续为 `development_open`，须以最新 Main 为基线，
  可消费 07a 的 prefix 拆批接口，但不得把 prefix 继续泄漏给 08+；
- AT1-VK3b-08a/08b 仍开放但保持依赖顺序 `07b -> 08a -> 08b`，只消费 full-row 高层投影；
- AT1-VK3b-09 继续冻结，直到 07b、08a、08b 全部进入 Main。
