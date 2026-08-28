# Pr3 Lévy 与 CLT 特征函数基础正式交接

- entries：
  - `probability.characteristic-function.levy-continuity`
  - `probability.clt.characteristic-foundation`
- branch：`codex/probability`
- synced Main：`d0acd5f`
- gate：`development_open`
- formal sources：
  - `SandronesLibrary/Probability/LevyContinuity.lean`
  - `SandronesLibrary/Probability/CLTCharacteristicFoundation.lean`
- documents：两篇对应 Entry 与本 handoff

## 文件所有权与依赖

- `LevyContinuity.lean` 只拥有已知目标概率测度的 Lévy iff 与任意连续点态极限推出 tightness。
- `CLTCharacteristicFoundation.lean` import 前者，拥有归一化和律、特征函数幂公式、二阶幂极限及标准
  正态弱收敛消费者。
- 两个 Entry 不跨文件吸入；CLT foundation 的最终证明真实调用本库 Lévy wrapper。

## 概念冻结表

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 弱收敛 | 有界连续测试函数积分收敛 | `Tendsto` on `ProbabilityMeasure ℝ` | Lévy iff | 直接复用弱拓扑 | Lévy theorem | levy-continuity |
| 特征函数收敛 | 每个实参数处逐点收敛 | `∀ t, Tendsto ...` | `probabilityMeasure_tendsto_iff_charFun` | Mathlib 有限维定理 | CLT foundation | levy-continuity |
| 任意极限 tightness | 点态极限在零点连续推出紧性 | `IsTightMeasureSet` | `tight_of_charFun_tendsto_continuousAt_zero` | 不宣称极限测度存在 | 后续 existence | levy-continuity |
| 归一化和律 | `(√n)⁻¹ Σ Xₖ` 的分布 | `normalizedSumLaw` | 推前概率测度 | a.e. 可测性保证概率实例 | weak limit | clt foundation |
| iid 幂公式 | 和的特征函数是单项值 n 次幂 | `normalizedSum_charFun_eq_pow` | 独立有限和乘积 | 复用 `iIndepFun` 与 `IdentDistrib` | Taylor limit | clt foundation |
| 二阶幂极限 | 中心 0、二阶矩 1 时趋 `exp(-t²/2)` | `centeredVarianceOne_charFun_pow_tendsto` | `taylor_charFun_two` | 只需二阶矩 | weak limit | clt foundation |
| 标准正态弱极限 | 归一化和律趋 `gaussianReal 0 1` | ProbabilityMeasure `Tendsto` | Lévy 反向 | 不调用最终 CLT | 最终消费者 | clt foundation |

## 公开签名扫描

- Lévy 文件公开两个 theorem；CLT foundation 公开一个 def 和三个 theorem。
- 正式 Mathlib 承载：`ProbabilityMeasure`、`IsTightMeasureSet`、`iIndepFun`、`IdentDistrib`、
  `gaussianReal`、`charFun`、`Tendsto` 和 `isLittleO`；两篇 Entry 均解释其教材意义。
- 私有证明后端：有限和特征函数乘积、`taylor_charFun_two`、幂指数极限和 Gaussian 特征函数。
- 无最终 CLT、`TendstoInDistribution`、三阶矩、高维或三角阵接口泄漏。

## 负责人验收

- `/tmp/LevyCLTFormalFramework.lean` 先列五个 `sorry` 并完成跨 Entry 上层组装；随后逐项替换为已验证
  证明，最终零错误、零 warning、零占位。
- `lake build SandronesLibrary.Probability.LevyContinuity
  SandronesLibrary.Probability.CLTCharacteristicFoundation` 通过（3159 jobs）。
- `/tmp/LevyCLTAggregate.lean` 联合导入并检查弱收敛、tightness、归一化和律和四个最终消费者，通过。
- 两个 Entry 分别精确映射 2 与 4 个公开声明，无跨文件吸入。
- 六项 `#print axioms` 均仅含 `propext`、`Classical.choice`、`Quot.sound`，没有 `sorryAx`。
- 正式源码占位、最终 CLT import／名称扫描和 `git diff --check` 均通过。

## 诚实边界与 Main 建议

- weak convergence iff 的目标是已知概率测度；任意 `f` 版只交付 tightness。
- CLT foundation 是中心零、二阶矩一版本；一般均值方差、方差零和随机变量分布收敛桥未完成。
- Main 集成时请分别登记两个 Entry、加入两个顶层 imports 并更新 ROADMAP；Examples 不属本窗口。
