# Pr3 实值特征函数 Main 验收

- 学科提交：`e5993dd`
- Main 接收：`8a0692b`
- Entry：`probability.characteristic-function`
- Verdict：`accepted_main_docs`

## 数学与 carrier 裁决

本批直接以 `charFun (μ.map X)` 承载随机变量的特征函数，并由 `realCharFun_eq_integral` 展开成
教材中的复指数期望。所有推前测度相关公开签名均保留 `AEMeasurable X μ`，没有利用
`Measure.map` 对不可测函数的退化定义冒充随机变量分布。

九个公开声明覆盖零点、连续性、模界、共轭、缩放、平移、独立和与分布唯一性。
`identDistrib_iff_realCharFun_eq` 的反向使用 `Measure.ext_of_charFun`，Entry 明确说明实数自动满足
完备、第二可数实内积空间条件，没有未经披露推广到一般 Banach 空间。

## Main 规范化与边界

Main 复验确认 `continuous_charFun` 当前由 Mathlib 的 `TaylorExpansion` 模块导出，因此保留该
import；这只是连续性定理的模块依赖，不表示本批消费了 Taylor 结论。Main 另补顶层导入、Registry、
ROADMAP 和后续门。本批没有证明矩 Taylor 展开、Lévy 连续性或 CLT。下一窗只开放 Lévy 连续性与归一化独立和接口调查为
`research_open`；最终 CLT 继续冻结。
