# Pr3 特征函数正式交接

- entry：`probability.characteristic-function`
- branch：`codex/probability`
- synced Main：`7adf2f0`（merge commit `c20bf3b`）
- gate：`development_open`
- formal source：`SandronesLibrary/Probability/CharacteristicFunction.lean`
- files：
  - `SandronesLibrary/Probability/CharacteristicFunction.lean`
  - `docs/entries/probability/characteristic-function.md`
  - `docs/handoffs/probability-pr3-characteristic-function.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 实值特征函数 | `φ_X(t)=E exp(i t X)` | `charFun (μ.map X)` | `realCharFun_eq_integral` | 分布测度 carrier 语义一致，直接复用 | 基本性质 | `probability.characteristic-function` |
| 零点与模界 | 概率质量和模一被积函数给出归一化、模界 | `charFun_zero`、`norm_charFun_le_one` | 两个公开消费者 | 推前概率实例由可测性建立 | 连续与极限前置 | 同上 |
| 共轭对称 | `φ(-t)=conj(φ(t))` | `charFun_neg` | `realCharFun_neg` | 直接复用复指数共轭恒等式 | 基本性质 | 同上 |
| 仿射变换 | 缩放改参数，平移乘相位 | map-scaling / map-translation | `realCharFun_scale`、`realCharFun_translate` | 先组装两次推前测度 | 后续标准化 | 同上 |
| 独立和 | 独立卷积变乘积 | `IndepFun.charFun_map_fun_add_eq_mul` | `realCharFun_independent_add` | 复用完整独立—卷积链 | 有限和／CLT 前置 | 同上 |
| 分布唯一性 | 实值分布由特征函数唯一决定 | `Measure.ext_of_charFun` | `identDistrib_iff_realCharFun_eq` | 实数自动满足完备和第二可数条件 | 同分布判据 | 同上 |

## 公开签名扫描

- 正式承载：`charFun (μ.map X)`、`AEMeasurable`、`IsProbabilityMeasure`、`IndepFun` 与
  `IdentDistrib`；Entry 已逐项解释概率语义和类型类边界。
- 九个公开声明覆盖积分展开、零点、连续性、模界、共轭、缩放、平移、独立和与分布唯一性。
- 私有证明后端：`charFun_apply_real`、`integral_map`、`charFun_map_mul_comp`、
  `charFun_map_add_const` 和 `Measure.ext_of_charFun`。
- 越级泄漏：无 `InnerProductSpace`、`StrongDual`、`PiLp` 或 Banach 空间接口进入公开签名。

## 负责人验收

- `/tmp/CharacteristicFunctionFramework.lean` 先完成九项上层组装，再逐项消除全部 `sorry`；最终
  `lake env lean` 零错误、零 warning、零占位。
- `lake build SandronesLibrary.Probability.CharacteristicFunction` 通过（3091 jobs）。
- `/tmp/CharacteristicFunctionAggregate.lean` 联合导入，检查正式 carrier、积分展开及九个公开声明，
  编译通过。
- Entry 映射得到唯一 id `probability.characteristic-function`，准确覆盖九个公开声明。
- 九项 `#print axioms` 均仅含 `propext`、`Classical.choice`、`Quot.sound`，没有 `sorryAx`。
- 正式源码占位扫描与 `git diff --check` 均通过。

## 诚实边界与 Main 建议

- 首批固定为实值随机变量；向量值和 Banach 值特征泛函未进入公开接口。
- 未证明矩 Taylor 展开、Lévy 连续性或中心极限定理，也未调用最终 CLT。
- Main 集成时请登记唯一 id、导入 `CharacteristicFunction.lean` 并更新 ROADMAP；Examples 不属本窗口。
