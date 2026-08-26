# Main review：抽象代数环同构载体维护 RFC

- reviewed_commit: `2544794`
- integrated_commit: `b989c2e`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-26

## 验收结论

现有 `RingIsomorphism` 与 Mathlib `RingEquiv` 携带同一组双向函数、互逆性和环同态数据；只读框架的
双向转换及两个 round trip 已由 Main 重新编译通过。旧载体没有除 `CoeFun` 外的全局 instance 或 notation，
唯一跨文件 Lean 消费者是 `RingCRT.lean`，因此 RFC 的 M2 分阶段迁移等级和影响图成立。

这次迁移不是“禁止复用 Mathlib”，而是把证明所有权交给语义一致的成熟正式承载，同时保留旧教材接口
作为薄 compatibility wrapper。`RingHomomorphism` 是展开环同态公理的普通函数谓词，角色不同，不能随
同构载体一起删除。理想、子环、显式商环与局部化也不在本 RFC 授权内。

## R1 权限

R1 提升为 `development_open`，仅修改 `RingIsomorphismTheorems.lean`、对应 Entry 和 handoff。新增公开
面冻结为四个双向桥／round trip，以及第一、第二、第三同构的三个 `RingEquiv` 核心和三个代表元公式；
其余 range-surjective、equal-ideal 与复合 helper 保持 private。旧公开名称、返回类型和签名保持不变，
证明体只包装正式核心。R2 CRT 仍等待 R1 进入 Main；R3 默认关闭。
