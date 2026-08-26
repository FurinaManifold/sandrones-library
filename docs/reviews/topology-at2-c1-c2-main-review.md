# Topology AT2-C1/C2 Main 验收

- 提交：`20ff2ef`、`85e360f`
- 结论：接受并集成
- Main 集成提交：`30d3211`、`60ced8b`

## 验收判断

C1 直接使用 `IsEvenlyCovered` 与 `IsCoveringMap`，文档清楚解释了 Mathlib 允许空 fiber，而常见教材
可能把满射写入定义；需要教材约定时显式增加 `Function.Surjective p`。这正符合“可以复用成熟
Mathlib 接口，但必须在教材层解释”的规范，没有重复建立 covering carrier。

C2 真实消费 C1 和 Mathlib `liftPath`：公开存在唯一性的完整量词、标准 `Path` 视图、逐点投影式与
终点 fiber。没有复制逐片提升算法，也没有预先指定一个未必可达的目标 fiber 点。

定向构建通过，注册与自然语言文件一致，公开接口未引入非标准公理。C1/C2 均改为已集成。

## 后续权限

- AT2-C3 同伦提升：`development_open`；
- AT2-C4 monodromy 与提升判据：`research_open`，C3 handoff 后自动开发；
- AT2-C5 覆盖空间分类：`research_open`，只做假设、接口和 Mathlib 缺口审计。

三条路线必须分文件。可继续复用 Mathlib，但文档必须解释参数空间、初始截面、唯一性以及分类定理
所需的局部连通性假设；禁止另造 covering carrier。
