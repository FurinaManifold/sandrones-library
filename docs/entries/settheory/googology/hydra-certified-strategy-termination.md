---
id: settheory.googology.hydra-certified-strategy-termination
kind: theorem
state: verified
title: "认证 Hydra 策略规格必到达终止状态"
premises: ["settheory.googology.hydra-certified-transitive-descent"]
mathlib: []
provenance: {source_type: book, ref: "良基递归的策略终止原理；本条只处理本库认证步骤"}
---

# 动机

关系良基说明不能永远沿认证步骤前进，但应用中还需要把“策略在每个未终止状态都能继续”与“从任意起点确实能到达终止状态”连接起来。仅说不存在无限轨迹，并不会自动给出一段有限轨迹的端点与长度。本条把策略写成明确规格，再用已有良基归纳逐层拼接认证步骤，得到某个有限步数和某个满足策略终止条件的状态。

# 直觉

站在任意 Hydra 状态，策略必须交出两种凭证之一：要么说明这里已经终止，要么指出一个符合最右脊柱规范的下一棵树。如果已经终止，长度为零的轨迹即可；如果还能走一步，就先相信较小的下一状态最终能到达终点，再把当前这一步接到那段轨迹前面。因为认证步骤关系良基，这种“先处理更小后继”的论证对所有起点成立。

# 陈述（自然语言）

认证策略规格包含终止谓词 `Terminal`，并要求每个状态要么满足该谓词，要么存在一个 `CertifiedStep` 后继。`ReachesTerminal strategy start` 表示存在自然数 `steps` 和端点 `endpoint`，从 `start` 恰好走 `steps` 个认证步骤可到达 `endpoint`，且端点满足策略的终止谓词。任何认证策略规格都使每个起始 Hydra 满足这一可达性质。

# 陈述（Lean 对照）

```lean
structure CertifiedStrategySpec where
  Terminal : Hydra → Prop
  progress : ∀ state,
    Terminal state ∨ ∃ next, CertifiedStep state next

def ReachesTerminal (strategy : CertifiedStrategySpec)
    (start : Hydra) : Prop :=
  ∃ steps endpoint,
    CertifiedExactSteps steps start endpoint ∧ strategy.Terminal endpoint

theorem certifiedStrategy_terminates_from
    (strategy : CertifiedStrategySpec) (start : Hydra) :
  ∃ steps endpoint,
    CertifiedExactSteps steps start endpoint ∧ strategy.Terminal endpoint
```

# 思维脉络（thinking trace）

证明把目标性质设为 `ReachesTerminal strategy`，直接调用上一批对所有认证后继成立的 `certifiedStep_induction`。在当前状态展开 `progress`：终止分支选择步数零、端点为当前树，精确零步关系由反身等式成立；继续分支取得后继及认证证明，再从归纳假设取得后继到终点的 `steps` 步轨迹，最后用精确步数定义的后继分支组装为当前树到同一终点的 `steps+1` 步轨迹。

# 自然语言 ↔ Lean 映射

“策略认为已经结束”对应 `CertifiedStrategySpec.Terminal state`，“策略能选下一步”对应 `∃ next, CertifiedStep state next`。“从起点有限到达终点”对应 `ReachesTerminal`，“轨迹的精确长度”对应 `CertifiedExactSteps steps start endpoint`。终止分支给出的零步证书是 `rfl`；继续分支把 `next`、`certified` 与归纳轨迹组成精确多步定义中的存在见证。

# 依赖（人话版）

依赖认证步骤的良基归纳原理和精确有限步关系。本证明没有新增 Mathlib 高层依赖，也没有调用 `Classical.choice` 或建立 `noncomputable` 选择函数：策略规格本身在命题中携带存在后继的证明，归纳证明只在命题层析构并重新组合这些见证。正因接口是 `Prop` 值规格，结论应理解为数学存在性，而不是已经导出可运行程序。

# 应用与陷阱

给出一个具体 `CertifiedStrategySpec` 后，可直接获得任意起点存在有限认证轨迹到其终止谓词。该定理没有证明步数唯一、端点唯一或存在统一的数值上界，也没有把存在证明转成高效可计算的下一步函数；若需要执行策略，应另行提供数据值选择器及其认证证明。更重要的是，继续分支必须产生 `CertifiedStep`，不是任意 `Hydra.Step`，所以本条不是完整 Hydra 游戏终止定理，也不涉及 PA 不可证性。
