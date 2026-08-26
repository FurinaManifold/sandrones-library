# Main review：AT1-VK3b-08a 单行 frame 右锚定

- branch: `codex/topology-foundations`
- reviewed_commit: `e580a7c`
- integrated_commit: `f0febdc`
- reviewer: `main`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-26

## 验收结论

本批抽取“统一右乘只把重基边共轭”的纯群接口，并把它应用于 07b 的规范单行 frames：最右下 frame
可锚定到指定值，最右上 frame 由真实右竖边决定；水平相容、每格上下横边为一和最右竖边为一均被
保持。两个唯一性定理分别说明固定 end 或 start frame 后，另一端的归一化 frame 唯一。

公开面经预审冻结为 10 public / 6 private。私有项只负责整行统一右乘和锚点计算；公开项包含四个
通用群／frames 接口、08b 直接消费的右锚定行四接口以及两端唯一性。源码没有读取 07a/07b 的
row-prefix，也没有第二套 frame structure。结论止于单行锚定，没有提前声称二维左边界消失、kernel、
单射或 van Kampen 同构。

Main 独立构建正式 08a（1758 jobs，零 warning），并编译未修改的 08b 直接消费者。学科 handoff
提交时仍把已经完成的验证写成“验证计划”；这只是文档状态措辞，Main 已直接改成实际结果，未退回
数学成果。

## 后续权限

- 08a 已接收，公开接口从此按维护规程管理；
- 08b `VanKampenRightAnchoredGrid` 的依赖门已经满足，自动转为 `development_open`，无需再次申请；
- 08b 使用已批准的 10 public / 12 private 方案，并保持零 row-prefix 引用；
- VK3b-09 继续冻结，直到 08b 进入 Main。
