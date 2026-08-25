# Main review：A2.9 局部化与分式域

- reviewed_commit: `bc719a6`
- integrated_commit: `96ff8ee`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-25

本批从本库 `MultiplicativeSet` 和带消去因子的分式判等出发，构造一般交换环局部化，验证分式运算、
环公理、规范映射、分母可逆性、分式表示和存在唯一泛性质；对本库整环的非零元乘法集进一步证明
分式域公理。含零因子时没有错误删去判等关系中的额外消去因子，规范映射也没有被宣称总是单射。

公开签名未挂靠 Mathlib 的最终 `Localization` 或 `IsLocalization` 接口。本批完成 A2.9 的数学门；
顶层导入、Registry、合法 citation key 和 ROADMAP 完成状态由 Main 补齐，不构成学科返工。

至此 A2.1--A2.9 环论路线全部完成，G-A2 关闭。后续交换代数仍按 CA1 模论、CA3 局部化的依赖
顺序另行开发，不能把 A2 的环局部化冒充模局部化、素理想对应或 Noether 理论。
