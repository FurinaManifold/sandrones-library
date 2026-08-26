# Main review：T4-R3b-path 归纳式分段 C1 道路

- reviewed commit: `729bb33`
- integrated commit: `95b79b5`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

本批在 Mathlib `Path` 上定义由整体 `ContDiffOn`、`Path.trans` 和端点 `Path.cast` 生成的归纳谓词
`Path.PiecewiseC1`，并证明常道路、线段、有限 concat、反向、R3a `meshPolygonal` 和开集内替换。
它修正了旧结构候选无法包含任意整体 C1 道路的语义缺陷，没有引入第二套道路或断点承载。

Main 构建目标 2083 jobs 通过，并复验只读复分析消费者可以按三个构造子归纳得到
`PathIntegrable`。该消费者未进入拓扑提交；本批也没有把连续同伦升级为全局或分片 C2 方形。
T4-R3b-path 接收，T4-R3b-square 与复分析一般连续同伦不变性继续 `research_open`／冻结。
