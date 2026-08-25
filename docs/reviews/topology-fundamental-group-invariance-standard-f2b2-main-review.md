# Main review：T4-F2b2 基点变换与同伦等价不变性

- branch: `codex/topology-foundations`
- reviewed_commit: `dfbb724`
- integrated_commit: `399bc52`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

提交为 `mapOfEq`、沿道路换基点和 `equivOfHomotopyEquiv` 提供了真实公开使用者。换基点公式明确
依赖所选道路并表现为 `p⁻¹ · g · p`；同伦等价只在对应基点 `x` 与 `e x` 间给出乘法等价，没有
宣称任意目标基点的规范同构，也没有声称基本群同构反推空间同伦等价。

目标模块构建通过；四条公开声明的 Entry 映射与公理审计通过，公理仅为 `propext`、
`Classical.choice`、`Quot.sound`。

## 后续权限

F2b 已完成。T4-F2c3 积空间基本群为 `development_open`；AT1 van Kampen 仅为
`research_open`，按高阶代数拓扑路线另行建设。
