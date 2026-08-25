# N1 教材定义层维护 handoff

- RFC：`docs/maintenance/number-theory-n1-definition-layer.md`
- 影响等级：M2（新旧语义可证明等价，采用双轨兼容）
- 当前阶段：只读影响审计完成；尚未修改公开 Lean 接口
- 维护分支：`codex/number-theory-maintenance`

## 已确认

- 21 个 Entry 和 11 个 Lean 模块已经在 main；课程覆盖状态不回退。
- 已有本库定义覆盖试除、Diophantine、勾股数、二次剩余性质、连分数近似和 Pell 坐标解。
- 待迁移概念为同余、Euler φ、素因子指数、Euclid 定理结论中的素数、Pell 非平方前提及
  Legendre/Jacobi 数值互反接口。
- 没有发现跨学科模块调用 N1 公开声明；抽象代数自身对 `ZMod`、`Nat.Prime` 的使用不属于 N1
  下游。

## 下一门

先完成 A1 的 `Congruent` 与真正有限计数定义的 `EulerTotient`，证明双向桥并新增使用这些定义的
Euler／Fermat／CRT 上层定理。旧 API 必须完整保留。
