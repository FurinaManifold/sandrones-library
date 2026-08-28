# Pr3 强大数律正式交接

- entry：`probability.law-large-numbers.strong`
- branch：`codex/probability`
- synced Main：`b1a5e86`
- gate：`development_open`
- formal source：`SandronesLibrary/Probability/StrongLaw.lean`
- files：
  - `SandronesLibrary/Probability/StrongLaw.lean`
  - `docs/entries/probability/law-large-numbers/strong.md`
  - `docs/handoffs/probability-pr3-strong-law.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 两两独立 | 任意不同两项独立 | `Pairwise (Function.onFun (fun f g ↦ f ⟂ᵢ[μ] g) X)` | 明示 pairwise 量词 | Etemadi 最小 carrier | 最小 SLLN | `probability.law-large-numbers.strong` |
| 全族独立 | 任意有限子族联合独立 | `iIndepFun X μ` | `.indepFun` 推出 pairwise | 标准 iid carrier | iid 消费者 | 同上 |
| 同分布 | 每项推前分布相同 | `IdentDistrib` | 传递可积与截断分布 | 与 WLLN 一致 | 截断证明 | 同上 |
| 一阶可积 | `E|X₀|<∞` | `Integrable (X 0) μ` | 同分布传给每项 | SLLN 最小矩条件 | 正负与尾部 | 同上 |
| a.s. 收敛 | 零测集外逐点收敛 | a.e. `Tendsto` | Pr3 carrier | 语义一致，直接复用 | 两个最终定理 | 同上 |
| 截断证明 | 截断、几何子列、去截断、填隙 | `strong_law_aux1`–`aux7` | Entry 逐步解释 | 复用完整 Mathlib 证明后端 | `strong_law_ae_real` | 同上 |

## 公开签名扫描

- 正式承载：`Integrable`、`Pairwise`、`IndepFun`、`iIndepFun`、`IdentDistrib`、a.e. `Tendsto`；Entry
  给出量词和假设边界。
- 两个公开消费者：pairwise 一阶可积 Etemadi 版本与标准 iid 版本；后者真实使用前者。
- 私有后端：`strong_law_ae_real` 及 `aux1`–`aux7`；虽不复制证明源码，但 Entry 完整映射教材步骤。
- 越级泄漏：无 Banach 空间类型类、`eLpNorm`、特征函数或 CLT。

## 负责人验收

- `/tmp/StrongLawAudit.lean` 先验证 Mathlib 全部截断接口及两层最终签名，无错误、warning 或 `sorry`。
- `lake build SandronesLibrary.Probability.StrongLaw`：通过（2968 jobs）。
- `/tmp/StrongLawAggregate.lean` 同时检查 carrier、截断首尾接口和两个公开定理：通过。
- `scripts.check_axioms.map_entry_to_decl`：唯一 id 精确映射两个声明，无跨 Entry 吸入。
- 两项 `#print axioms` 仅含 `propext`、`Classical.choice`、`Quot.sound`，无 `sorryAx`。
- 正式源码禁用占位扫描与 `git diff --check`：通过。

## 诚实边界与 Main 建议

- 教材公开层显式保留概率测度；一阶可积和 pairwise 独立是本批最小数学强度。
- 只做实值 SLLN；Banach 值、非同分布、特征函数与 CLT 继续冻结。
- Main 集成时请登记唯一 id、导入 `StrongLaw.lean` 并更新 ROADMAP。
