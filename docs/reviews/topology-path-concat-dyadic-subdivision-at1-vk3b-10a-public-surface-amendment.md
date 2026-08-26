# Main amendment：VK3b-10a basepoint coercion 规则公开

- amended at: 2026-08-26
- verdict: `accepted_main_docs`

完整 11--15 真实消费者审计发现，15a 的 top/right boundary residual-gauge 证明需要把依赖覆盖成员中的
`binaryOpenCoverBasepoint` 强制回环境空间并识别为 `x₀`。该规则原在 10a 中为 private，导致候选只能
局部复制同一两行 Bool 分类证明。

`coe_binaryOpenCoverBasepoint` 是公开定义的稳定 coercion 计算规则，并有两个跨模块真实消费者；Main
将它从 private 提升为 public `[simp]`，不改变陈述或证明。10a 最终接口由 17 public / 16 private
修正为 **18 public / 15 private**。15a 正式迁移时必须删除临时候选中的重复 helper，直接消费本规则。
