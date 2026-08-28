# Pr3 特征函数接口调查 Main 验收

- 学科提交：`506014b`
- Main 接收：`80e93e4`
- Verdict：`accepted`
- 后续门：`probability.characteristic-function` 为 `development_open`

Main 在当前 Mathlib 上重新编译 `/tmp/CharacteristicFunctionAudit.lean`，其中零点归一化、连续性、
独立和乘积公式及“同分布当且仅当特征函数相同”四条原型均通过且无占位符。

正式 carrier 冻结为 `charFun (μ.map X)`。这直接复用 Mathlib 对分布测度的特征函数定义，但教材
Entry 必须展开推前积分语义，并解释 `AEMeasurable X μ` 为什么不能省略。首批只处理实值随机变量；
内积空间向量值接口和 `charFunDual` 仅作边界说明，不进入基本签名。

CLT、Lévy 连续性与矩 Taylor 展开不在本批开发权限内。它们必须等待特征函数基础条目正式验收，
再分别调查并开放。
