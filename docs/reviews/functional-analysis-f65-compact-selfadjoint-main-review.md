# F6.5 紧自伴谱定理 Main 验收

- subject commit：`1fb292c`
- verdict：accepted
- entry：`functional-analysis.hilbert.compact-selfadjoint-spectral`

公开定理保持批准的 Mathlib-native carrier，并同时组装特征值实性、特征空间正交、全部特征空间的
闭线性张成稠密以及非零特征空间有限维。稠密性不是把最终接口改名：证明从正交补为底出发，经
闭包的正交补不变性和闭子空间判据得到 `Dense`，文档也明确没有声称未闭代数和等于全空间。

本批没有构造选择性的无限维 `HilbertBasis`，也没有越级进入一般正规算子、函数演算或谱测度。
Main 接受本批，并将 F6.6 全纯函数演算开放为 `research_open`。
