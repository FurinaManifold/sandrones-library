# Main review：环同构 carrier R2 CRT 下游迁移

- reviewed commit: `ad14a2a`
- integrated commit: `af9e7c1`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

R2 把二元与有限族中国剩余定理的证明所有权迁到四个正式 `RingEquiv` 声明及代表元公式；四个历史
`RingIsomorphism` API 的名称、参数和返回类型保持不变，只经 `ofRingEquiv` 或正式公式薄包装。
原先为旧逆函数重复证明环同态的代码已删除，没有第二条证明链。

修改严格限于 RingCRT 源码、既有 Entry 与 R2 handoff；未改理想、商环、Examples 或共享状态。
Main 重新构建 RingCRT、运行 Entry/公理审计及全库构建后接收 R2。R3 的 deprecation／删除仍冻结；
不能因仓内消费者归零推断可破坏外部兼容性。
