# Topology AT2-C4a/C4b Main 验收

- 提交：`052578d`、`1ed923b`
- Main 数学集成：`47c5cb8`、`180d64c`
- 结论：接受

## C4a monodromy

代表道路的 monodromy 值被精确识别为 C2 标准提升的终点；基环路提升闭合等价于初始 fiber 点为
monodromy 固定点。正文说明 `Path.trans` 的先后顺序和 transport 复合方向，而不是另造 action、
置换表示或道路商。两项桥连接了本库 C2 与 Mathlib 的成熟 monodromy carrier，具有明确教材消费者。

## C4b 提升判据

必要方向不是最终定理 alias：它从已有保持基点的连续提升构造基本群像中的真实 witness，并通过道路
同伦商的 `map_comp` 证明像包含。充分方向才复用 Mathlib。存在 iff 与存在唯一 iff 均保留定义域
道路连通、局部道路连通假设；没有偷加 C5 的半局部单连通假设。

定向构建、Entry/公理审计与差异检查通过。C4a/C4b 均改为已集成。

## C4c/C5 决定

C4c 的 simply-connected 特例在没有真实消费者时保持 `research_open`，不为填编号制造 alias。
C5a 只开放定义原型研究；C5b 以后冻结。路径连通、局部路径连通、半局部单连通、总空间连通与
pointed/unpointed 分类的职责必须分别记录，不能合并成含糊的“good space”。
