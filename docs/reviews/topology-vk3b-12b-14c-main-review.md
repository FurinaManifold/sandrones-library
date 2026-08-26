# Main review：AT1-VK3b-12b--14c 左边界搬运与两层 telescope

- reviewed commits: `981c7ad`、`ba38e35`、`ad063a3`、`25bbba0`、`d80f8d9`、`d02801d`、`b5bd2fc`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

本轮七个正式模块保持严格线性依赖：逐边 cell-to-letter transport，block 内与 block 间 endpoint
cocycle，组合 frames，单 block telescope，全局 block telescope，最后恢复原输入字母词。最终只得到
整体 rebase 后的词为一，并未偷换成原词为一；非交换乘积始终使用反序 edge-chain 约定。

Main 对最终消费者 `VanKampenRebasedLetterWord.lean` 重建通过，因而同时重建全部上游模块；新增源码
无 `sorry`、`admit`、`native_decide` 或新增 `axiom`。各 Entry 解释了复用的 Mathlib `Path`、
`FundamentalGroup` 和 `Monoid.PushoutI`，没有为“禁止挂靠”重复制造基本群或 pushout carrier。

## 后续权限

开放 VK3b-15 release train：15a residual-gauge elimination 立即开放；15b kernel triviality 与 15c
canonical map injectivity/final equivalence 可在前一批于学科 worktree 构建通过、handoff 明确公开接口后
自动继续，不再等待逐批口头许可。每批仍需独立提交，不得把最终同构回填为前置假设。
