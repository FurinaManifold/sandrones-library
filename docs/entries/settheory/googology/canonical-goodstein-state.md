---
id: settheory.googology.canonical-goodstein-state
kind: definition
state: verified
title: "规范 Goodstein 状态与一步重编码"
premises: ["settheory.googology.hereditary-natural-encoding", "settheory.googology.hereditary-natural-encoding-strict-order"]
mathlib: []
provenance: {source_type: book, ref: "pohlers-proof-theory-1989"}
---

# 动机

已有的带证书 Goodstein 状态允许人为提供任意一棵合法表达式。这种设计适合先定义一般迁移关系，却没有回答一个实际问题：给定底数 `b` 和自然数 `n`，下一步究竟选哪棵表达式？现在已有经过证明的 `hereditaryNatEncode`，所以可以去掉这种选择，让状态的表达式由底数和值直接算出来。

# 直觉

把状态想成一张只写着“当前底数”和“当前数值”的卡片。需要查看遗传表示时，统一调用固定编码器，不再额外附上一棵可能因人而异的语法树。走一步时，先把旧树放到新底数 `b+1` 下读出数值，再减去 `1`；得到的新自然数随后由同一个编码器在底数 `b+1` 下重新展开。

# 陈述（自然语言）

一个规范 Goodstein 状态包含底数 `b≥2` 和自然数值 `n`，其表达式规定为 `n` 在底数 `b` 下的商余递归遗传编码。这棵表达式在 `b` 下合法，而且求值正好等于 `n`。规范一步把底数改为 `b+1`，把新值定义成旧规范表达式换底求值后减一，并在 `b+1` 下重新规范编码；新编码同样合法，求值也精确等于这次 Goodstein 步所得的数值。

# 陈述（Lean 对照）

`CanonicalGoodsteinState` 只保存 `base`、证明 `base_ge_two` 和 `value`。`CanonicalGoodsteinState.expression` 定义为 `hereditaryNatEncode base base_ge_two value`。`canonicalGoodsteinStep` 的新底数是 `base+1`，新值是 `goodsteinStep base expression`。定理 `canonicalGoodsteinStep_specification` 同时给出新底数等式、新表达式合法性和新表达式求值等式。

# 思维脉络（thinking trace）

第一步先区分“数值更新”和“语法树重编码”：`goodsteinStep` 负责前者，`hereditaryNatEncode` 负责后者。第二步注意新状态并不需要手工保存合法性证明，因为它的表达式是固定编码器的输出，可以直接调用编码器已经证明的“合法且求值正确”定理。第三步检查底数条件：旧底数至少为 `2`，所以新底数 `b+1` 仍至少为 `2`。这样，一步迁移的每一项证书都由现有定理机械地产生。

# 自然语言 ↔ Lean 映射

“固定选择规范表示”对应 `CanonicalGoodsteinState.expression`；“换底后减一”对应 `goodsteinStep s.base s.expression`；“在新底数重新展开”体现在新状态的 `expression` 会按新 `base` 和新 `value` 再调用 `hereditaryNatEncode`；“新树合法”对应 `expression_valid`；“新树确实表示新数”对应 `expression_evaluates`。

# 依赖（人话版）

本条直接依赖一般自然数的遗传编码器及其合法性、求值证书。文件还调用固定底数下编码序数值严格保序的定理，说明在额外的换底规范化兼容条件成立时，正数的一步减法会带来严格序数下降；这个条件没有被藏在定义或文字里。

# 应用与陷阱

规范状态消除了“下一步随意挑一棵合法树”的歧义，适合作为真正 Goodstein 序列的确定性状态空间。但本条尚未证明一般单步序数下降，更没有证明整个序列终止。缺口非常具体：还需证明，把旧规范树在 `b+1` 下求值得到的自然数重新编码后，其 `omegaValue` 与旧树的 `omegaValue` 相同。源码将这个义务命名为 `CanonicalBaseChangeOmegaCompatible`，并只证明带该前提和正值前提的条件下降定理；不能把这个条件接口误读成已经完成的通用换底不变性。
