# F4.7 Eberlein--Šmulian handoff

- 分支：`codex/functional-analysis`
- Main 基线：`d2dc95f`，已通过 merge 同步
- 权限：F4.7 `development_open`
- 范围：Bühler--Salamon 定理 3.4.1 的闭单位球四项等价

## 交付内容

- `EberleinSmulian.lean` 给出闭单位球、自反性、弱紧致、弱序列紧致和有界序列抽取的完整链。
- Goldstine 单位球版本由闭凸分离与弱星连续泛函表示证明，不依赖最终定理。
- 困难方向逐步实现教材 Step 1--3：有限插值、核单位切片弱星闭、Banach--Dieudonné 回推。
- 一般非可分情形通过序列生成的可分闭子空间处理；闭子空间自反性由 Hahn--Banach 延拓和
  连续零化子恢复定理证明。

## 定义挂靠与边界

- 直接使用 Mathlib `WeakSpace`、`WeakDual`、`StrongDual`、`IsCompact`、`IsSeqCompact` 和
  `NormedSpace.inclusionInDoubleDual`。
- `weakClosedUnitBall` 只是教材对象的集合命名，不建立弱拓扑或自反性的平行接口。
- 本批不声称任意子集版本的 Eberlein--Šmulian，也不提前开发 F4.8 Krein--Milman。

## Main 集成建议

- 新增顶层 `EberleinSmulian` import。
- 登记 `functional-analysis.eberlein-smulian` Entry，并将 ROADMAP F4.7 标记完成。
- F4.8 当前仍为 `research_open`，除非 Main 另行开放，不将其与本提交合并。
