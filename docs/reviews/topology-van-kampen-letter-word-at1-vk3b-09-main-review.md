# Main review：AT1-VK3b-09 Pushout 字母词与拼接环路

- branch: `codex/topology-foundations`
- reviewed_commit: `d6cdd7f`
- integrated_commit: `a48b658`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-26

## 验收结论

本批把二开集基本群 Pushout 元素表示为有限单侧字母词，为每个基本群字母选择实际基点环路，并沿覆盖
成员包含映入环境空间。反序 `Path.concat` 明确补偿 Mathlib 基本群乘法与道路拼接的方向约定；逐段
成员性保存每个输入环路的覆盖标签。

公开面严格为 11 public / 2 private。`FundamentalGroup`、`Path`、道路同伦商和
`Monoid.PushoutI` 均作为语义一致的正式承载复用；没有第二套自由积、商群、道路或同伦结构。结论止于
字母词、代表道路、单字母规范像及 concat 输入段成员性，没有声称完整 concat 的群类公式、kernel
零伦、单射或 van Kampen 同构。

Main 独立构建目标模块（1760 jobs），运行 11 项公开接口 aggregate，并编译真实 10a 消费者
`PathConcatDyadicSubdivision.lean`；禁用项、Entry、格式与公理边界均通过。

## 后续权限

09 已接收并冻结。10a dyadic subdivision 的依赖门满足，自动转为 `development_open`，使用 Main
批准的 14 public / 18 private 公开面；10b 等待 10a 进入 Main，11--15 继续按线性依赖开放。
