# Main review：AT1-VK3b-08b 二维右锚定与左边界消去

- branch: `codex/topology-foundations`
- reviewed_commit: `fedf0ea`
- integrated_commit: `04eb43a`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-26

## 验收结论

本批从最右列开始选择相邻行锚点，以中央 transition coherence 和横边 frame 唯一性把竖直相容逐格
向左传播，得到二维右锚定 frames。每行的横边与最右竖边均为一，完整行高层关系因此推出最左竖边也
为一；按 reverse-row 次序累积后，完整左边界 holonomy 严格为单位元。

公开面为 10 public / 12 private。下降 helper、行间传播、reanchor 与 prefix telescope 均为 private；
09--15 只消费二维 frames、四项相容／归一性质、completed-row 投影和最终左边界出口。源码对 07a/07b
row-prefix 名称为零引用，也没有复制第二套 frame structure。结论没有把左边界 holonomy 识别成 kernel
word，未提前声称单射或 van Kampen 同构。

Main 独立构建 08b（1759 jobs），并编译未修改的 09 直接消费者；接口、禁用项、Entry 与公理审计均
通过。

## 后续权限

- 08b 已接收，公开接口从此按维护规程管理；
- 09 `VanKampenLetterWord` 的依赖门已满足，自动转为 `development_open`，使用批准的
  11 public / 2 private 方案；
- 10--15 不整体解冻，继续按 09 以后实际依赖逐批开放。
