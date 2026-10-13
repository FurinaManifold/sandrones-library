# S1 充分统计量 Main 验收

- 学科 staging：`codex/probability`（本批无独立 worktree）
- 学科提交：`96bb6b0`（前置接口审计 `04da6e0`）
- 已接入 main：`3a15393`
- Main 集成提交：`46ea736`
- Entry：`statistics.sufficiency.definition`
- 来源：`schervish-theory-statistics-1995`
- Verdict：`accepted_main_docs`

## 数学与接口裁决

**定义层设计正确，a.e. 量词被论证而非默认。** 逐项核对：

- `IsSufficientStatistic P S` 要求 `S` 可测且存在**参数无关** Markov kernel `Q`，使每个参数下
  `condDistrib id S (P θ) =ᵐ[(P θ).map S] Q`。这在标准 Borel 样本空间上承载教材“给定统计量后完整
  样本的条件分布不依赖参数”的含义；文档明确论证了为何必须用 `(P θ).map S` 下的 a.e. 相等而非
  逐点相等（零概率纤维上的版本选择没有统计意义），量词层级正确。
- `ReconstructsFromStatistic` 与充分性**分开定义**，避免把任意重构 kernel 直接当成正规条件分布。
- `sufficientStatistic_reconstructs` 真实证明充分性 ⇒ Blackwell 重构：先按 a.e. 相等替换 kernel，
  再用 `condDistrib_comp_map` 得 `condDistrib id S (P θ) ∘ₘ (P θ).map S = P θ`，最后组装到 kernel 级
  等式。方向不是硬凑，反向等价未被声称。
- `NeymanFisherFactorizes` 只用 `ℝ≥0∞` 与 `ν`-a.e. 冻结因子分解语义，**没有**把它当成已证明的
  Neyman--Fisher 定理；有限离散原型在显式纤维归一化下构造参数无关重构，是定义层的首批真实消费者。

范围边界与 ROADMAP S1.5 冻结窗口一致：不做一般 Neyman--Fisher 双向定理、最小／完备统计量、
Rao--Blackwell、MLE、Fisher 信息或 Cramér--Rao。

## 独立复验

- `lake build SandronesLibrary.Statistics.Sufficiency` 在 main 工作树成功，无新增 warning；无
  `sorry`／`admit`／`native_decide`；对该 Entry 的 `#print axioms` 只含标准三项。
- `NeymanFisherFactorizes` 目前只有定义、没有库内使用者；这是 ROADMAP 允许的“定义 + 一手刻画”阶段，
  已如实记录，不作为退回理由。

## Main 规范化

补顶层导入一条、Registry 一条目、`docs/MATHLIB-RADAR.md` 的 `condDistrib`／kernel 段 Mathlib 锚点，
并在 ROADMAP §10 把 S1.5 标为已集成、说明一般因子分解与 MLE 等继续冻结。
