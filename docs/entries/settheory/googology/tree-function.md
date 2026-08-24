---
id: settheory.googology.tree-function
kind: definition
state: verified
title: "TREE 函数：有限标号树与坏序列的严格定义入口"
premises: []
mathlib: []
provenance: {source_type: paper, ref: "Harvey Friedman, finite forms of Kruskal's tree theorem"}
---

# 动机

`TREE(3)` 常被当作“巨大得无法想象的数”传播，但只报出这个名字并没有给出数学对象。TREE 的内容来自一个有限极值问题：依次选择越来越大的有限标号根树，同时禁止较早的树嵌入较晚的树；问题问这种坏序列最长能有多长。严格定义必须先说明树、嵌入、大小限制和“坏”分别是什么意思。

# 直觉

把一棵根树看成家谱：根是最早的祖先，每个顶点的祖先沿唯一方向排成一条链。把小树拓扑嵌入大树时，可以把一条边拉成长路径，却不能合并两个顶点、改变标号或把不同分支压成同一条祖先链。坏序列则故意避免任何“前面的树出现在后面的树中”的情形。

# 陈述（自然语言）

一个具有 `colors` 种标号的有限根树由非空有限顶点集、每点标号和祖先关系组成；祖先关系是偏序，根是所有点的祖先，同一顶点的任意两个祖先可比较。拓扑嵌入是保持根和标号的单射，并双向保持祖先关系。长度为 `m` 的坏序列要求第 `i` 棵树至多有 `i+1` 个顶点，且当 `i<j` 时第 `i` 棵树不能嵌入第 `j` 棵树。`value` 是 TREE 值，意为长度 `value` 可实现，而且所有可实现长度都不超过它。

# 陈述（Lean 对照）

`FiniteLabeledRootedTree colors` 用 `Fin vertexCount` 表示顶点，并把树序公理作为结构字段保存。`TreeTopologicalEmbedding source target` 保存顶点单射及根、标号、祖先关系的保持条件，`TreeEmbeds` 表示存在这样的证书。`TreeBadSequence colors length` 保存由 `Fin length` 编号的树、`vertexCount ≤ i.val + 1` 大小界和坏序列条件。`IsTREEValue colors value` 直接写成“可实现且支配所有可实现长度”，`treeValue_iff` 展开这一含义。

# 思维脉络（thinking trace）

定义从最底层向上搭建。先用有限类型确保每棵树确实有限；再把根树刻画为祖先偏序，而不是依赖某个现成图论结构；随后单独定义嵌入证书，最后才量化有限序列。由于“每个标号数都有最大坏序列长度”需要有限形式的 Kruskal 树定理，当前批次不使用无证明的选择算子强行制造自然数函数，而是把最大值写成可供后续证明存在唯一性的关系。

# 自然语言 ↔ Lean 映射

“顶点数”对应 `vertexCount`，“非空”对应 `hasVertex`，“标号”对应 `label`，“是祖先”对应 `ancestor`。根使用编号 `0`，其合法性来自 `hasVertex`。拓扑嵌入的“边可拉长但分支不混合”由祖先关系的双向保持表达。“第 `i` 棵至多 `i+1` 个点”对应 `size_bound`；“前树不嵌入后树”对应 `bad`；“最大可实现长度”对应 `IsTREEValue` 的合取定义。

# 依赖（人话版）

只依赖有限自然数类型、函数单射、偏序式逻辑和自然数次序。核心树、嵌入与坏序列都是本库公开定义，没有把 Mathlib 图、树或 Kruskal 定理直接包装成教材条目。理解上与有限组合学和良拟序理论有关，但这些高层结果尚未成为本条的证明依赖。

# 应用与陷阱

本条提供了以后证明 TREE 值存在、唯一及研究小参数的精确接口，但当前没有证明任意 `colors` 都存在 `value` 满足 `IsTREEValue colors value`，因此尚未定义一个可直接调用的总函数 `TREE : ℕ → ℕ`。也没有计算 `TREE(1)`、`TREE(2)` 或 `TREE(3)`，更没有证明它与 Graham 数、Busy Beaver 或其他大数的比较。不同文献可能采用略有差异的标号序和嵌入约定；任何迁移都必须先证明与这里的根保持、标号相等、祖先双向保持版本等价。
