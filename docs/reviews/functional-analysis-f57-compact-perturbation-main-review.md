# F5.7 Fredholm 紧扰动 Main 验收

结论：通过，学科提交 `0d30afe` 已由 Main 集成。

本批从有限秩拟逆误差得到紧算子误差，用 Banach 开映射补齐 `IsFredholm` 的 strictness，再通过
`(T+K)S=I-C` 和拟逆消去证明 Fredholm 性；指数不变真实使用复合指数公式与恒等减紧算子指数零。

Main 将其从复合稳定性 Entry 拆为独立的 `functional-analysis.fredholm.stability-compact`，以满足
一个 Entry 对应唯一正式源文件的登记约定。这是共享文档与 Registry 整理，不构成学科返工。

后续权限：小扰动窗口转为 `development_open`，必须独立文件和独立提交。
