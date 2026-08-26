# WF1-02 第 5–6 节 Main 一致性验收

- 事实截止：Main `e1d5bc0`
- 数学轮：`accepted`，唯一选择边界 R1 已 resolved
- 文字轮：`accepted_main_docs`，两项 R3 由 Main 处理
- Main verdict：`accepted for sections 5–6`
- 全章状态：保持 `draft`，目前只完成第 1–6 节

## 核对结果

1. `settheory.cardinal.countable-rat` 与 `settheory.cardinal.countable-union` 在事实截止均为
   `verified`，Lean/Entry 文件及 `jech-set-theory-2003` 书目键可解析。
2. 第 5 节只把有理数可数写成已核验结论；稠密性与分子分母网格明确标为出版背景和理解图景，没有
   冒充当前 Lean 证明体。
3. 第 6 节完整保留指标类型可数、每一片可数两个假设，并准确解释二者控制不同膨胀。`(i,m)` 只是
   编码图景；正文说明统一选择片内编码与来源使用经典选择。
4. Mathlib API 与公理账已由 Main 移到半章来源账，正文保留人类读者需要的选择边界。数学信息没有
   因编辑降噪而删失。
5. 章节元信息已分别链接第 5–6 节数学轮、文字轮和本 Main 记录；前三轮只覆盖当前切片，不提升整章。
6. 新两节没有硬插第二个人物场景是有意决定：它们是紧邻的两个可数性应用，既有样本编号场景已承担
   本半章的概念停顿；新增场景会打断应用链。

## Main 处理

Main 仅完成两项 R3：集中实现层追溯，并同步 review 状态与链接。下一批仍不得把 Cantor–Bernstein、
Cantor 定理或实数不可数冒充已写；相应内容须继续独立数学与文字审核。
