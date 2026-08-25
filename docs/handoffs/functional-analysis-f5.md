# F5 对偶算子、紧算子与 Fredholm 理论 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`b7c7de8`（以 `git rebase main` 同步）
- 权限：F5.2 四项闭值域加强与 F5.5 Fredholm 定义层 `development_open`；Fredholm 备择和
  指数稳定性仍冻结；具体有限维空间与算子计算归 Examples E11
- 当前阶段：F5.2 第三批闭值域对称定理待审

## 对偶算子基础

- 当前 Mathlib 没有 ROADMAP 所写的 `ContinuousLinearMap.dualMap`专名；成熟后端是 `ContinuousLinearMap.precomp`。
- `dualOperator T` 只将 `T.precomp ℝ` 命名为教材对偶算子，元素化公式为 `(T' f)(x)=f(Tx)`。
- 公开链覆盖求值展开、范数控制、复合反序和恒等算子；文档明确区分对偶算子与 Hilbert 伴随。
- 本窗只依赖已集成 F1–F3，可形成独立提交；不引入紧性或 Fredholm 语言。
- `lake build SandronesLibrary.FunctionalAnalysis.DualOperator`：8723 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖 `ContinuousLinearMap.precomp`、复合范数不等式、对偶算子定义和五个公开性质；
  Entry 精确映射为一个定义与五个定理。
- 六个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 共有文件建议

- Main 集成时新增 `DualOperator` 顶层 import，登记 Entry、RADAR 和 ROADMAP 状态。
- 引用建议挂靠 Bühler–Salamon 第 4.1 节；学科分支不修改 `reference.bib`。

## 紧算子 F5.3--F5.4

- 直接复用 Mathlib 的 `IsCompactOperator` 谓词和 `compactOperator` 子模，没有建立平行包装类型。
- `CompactOperator.lean` 对齐开单位球像闭包紧的教材定义，并提供零算子、有限维定义域／值域与恒等算子判据。
- `CompactOperatorComposition.lean` 给出左右复合、加法稳定性，以及完备值域中的算子范数极限闭性。
- 单模块构建 `SandronesLibrary.FunctionalAnalysis.CompactOperatorComposition`：8711 jobs 通过；
  警告只来自既有 `Topology/Metric.lean` 依赖。
- 聚合 `#check` 覆盖 Mathlib 承载与 9 个本地公开定理；`#print axioms` 和占位符扫描单独记录。

## 紧算子窗口的共有文件建议

- Main 集成时新增 `CompactOperator` 和 `CompactOperatorComposition` 顶层 import，登记两个 Entry 及
  ROADMAP/RADAR 状态。
- 本窗不包含闭值域或 Fredholm 声明，也不把范数极限结论扩张到强／弱算子拓扑。

## F5.2 闭值域的零化子刻画（第一批）

- 同步基线：`main@7078add`，通过 `git rebase main` 同步；F4.5 重复提交被 Git 正确跳过。
- 权限：F5.2 `development_open`；范围按 Main 早期接口审阅收窄为“闭值域的零化子刻画”。
- 正式承载：`ContinuousLinearMap`、`dualOperator`、`StrongDual.polarSubmodule`、`IsClosed (Set.range T)`；
  不建立平行对偶、零化子、闭值域谓词或 Fredholm 结构。
- 公开链覆盖 `ker T' = (range T)⊥`、`range T' ≤ (ker T)⊥`、连续零化子的范数闭性，以及
  `range T` 闭当且仅当 `range T' = (ker T)⊥`。
- 证明后端：核商的连续映射、反 Lipschitz 闭像估计、Hahn--Banach 延拓、对偶范数化函数和
  `ContinuousLinearMap.exists_preimage_norm_le`；均为私有辅助定义或证明。
- 诚实边界：本批未覆盖 `range T'` 范数闭、原/对偶闭值域互推、双零化子四项等价；
  按 Main 裁决这些留作 F5.2 后续独立增量。
- Main 集成建议：新增顶层 `ClosedRange` import，登记 `functional-analysis.closed-range`；
  ROADMAP 应标记第一批零化子刻画完成，不将四项等价标成已完成。

## F5.2 双零化子与对偶闭性（第二批）

- 文件所有权独立为 `ClosedRangeConsequences.lean`，只依赖第一批和已集成 F4.5，不改动正在审核的第一批源码。
- 无条件证明 `closure (range T) = (ker T')⊥`的逐点形式；闭值域时去掉闭包。
- 由 `range T' = (ker T)⊥` 得到对偶值域的范数闭性和弱星闭性；弱星零化子闭性按
  `WeakDual.eval_continuous` 的求值核交直接展开。
- 正式承载仍为 `Submodule.topologicalClosure`、`StrongDual.polarSubmodule`、`weakStarImage`；
  未引入 preannihilator 包装或新拓扑。
- 诚实边界：仍未证明对偶范数闭性的逆向，因此不声称原/对偶四项闭值域等价已完成。
- Main 集成建议：新增 `ClosedRangeConsequences` 顶层 import，登记
  `functional-analysis.closed-range.double-annihilator`。

## F5.2 闭值域对称定理（第三批）

- 基线同步到 `main@b7c7de8`；遵守 Main 新增的 Examples 所有权边界，本批仅含一般算子定理。
- 在实 Banach 空间上证明 `range T` 范数闭当且仅当 `range T'` 范数闭，并给出共同零点形式和
  四项联合形式，完成 Main 开放的 F5.2 加强窗口。
- 逆向证明先由开映射定理取得对偶值域单位截面的统一有界原像，再以弱星紧球连续像证明截面
  弱星闭，最后通过 Banach--Dieudonné 与弱星分离恢复 `range T' = (ker T)⊥`。
- 公共 API 只有三个最终刻画；弱对偶算子、紧性表示和分离论证均保持私有，不制造 Mathlib
  平行接口。
- 边界：没有声称复标量版本，也没有提前开发 Fredholm 备择或指数稳定性。
- Main 集成建议：新增 `ClosedRangeDuality` 顶层 import，登记
  `functional-analysis.closed-range.duality`。

### 第三批概念与公开签名审计

| 概念 | 教材语义 | Lean 承载与展开 | Mathlib 角色 | 上层使用者 |
|---|---|---|---|---|
| 原／对偶值域 | 算子所有输出组成的线性子空间 | `T.range`、`(dualOperator T).range`；成员是存在原像 | 语义一致的正式承载 | `closedRange_four_way` |
| 范数闭值域 | 值域在载体范数拓扑中为闭集 | `IsClosed (Set.range T)` 或子模强制转换后的 `IsClosed` | 语义一致的正式承载 | `isClosed_range_iff_dualOperator_range_isClosed` |
| 共同零点 | 所有属于对偶核的函数在向量上取零 | 显式量词 `∀ f ∈ (dualOperator T).ker, f y = 0` | 不另建 preannihilator 包装 | `isClosed_range_iff_forall_mem_range_iff_dualOperator_ker` |
| 弱星单位截面 | 对偶子空间与闭单位球的交在弱星拓扑中的像 | 既有 `dualUnitSlice`、`weakStarImage` | 已解释桥；仅出现在私有证明链 | 闭值域对称定理 |

公开签名只暴露语义一致的 `ContinuousLinearMap`、`LinearMap.range/ker`、`IsClosed`、
`StrongDual.polarSubmodule` 和显式共同零点量词；`WeakDual`、紧像与开映射受控原像均为私有后端。
