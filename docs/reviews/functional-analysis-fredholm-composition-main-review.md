# Fredholm 复合稳定性 Main 验收

结论：通过，提交 `bdd37a6` 已由 Main 集成。

证明实际提取两个 Fredholm 算子的连续拟逆，按反序复合后重新构造复合算子的 Fredholm 性；指数公式
则在核、余核有限维实例下使用 `LinearMap.index_comp`。因此这不是对最终结论的薄包装，也没有另造
Fredholm 或指数定义。

后续权限：紧扰动稳定性为 `development_open`；小扰动稳定性为 `research_open`，紧扰动 handoff 后
自动转 `development_open`。两批须分文件，并真实消费本批复合与指数接口。
