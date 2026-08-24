---
id: settheory.googology.hydra-certified-play-termination
kind: theorem
state: verified
title: "带最右脊柱证书的 Hydra 轨迹不可能无限"
premises: ["settheory.googology.hydra-rightmost-spine-descent", "settheory.ordinal.no-infinite-descent"]
mathlib: ["wellFounded_iff_isEmpty_descending_chain"]
provenance: {source_type: book, ref: "序数下降终止法；本条只应用于本库最右脊柱证书步骤"}
---

# 动机

前几条已经逐步证明一大类 Hydra 砍头会使结构序数下降，但“每一步下降”和“整局不能无限进行”仍是两个不同层次。要完成后者，必须先明确一局是什么，并把每次局部证书组织成一条时间轨迹。本条同时提供有限轨迹和无限轨迹接口，再用序数严格小于关系的良基性排除处处具有最右脊柱证书的无限游戏。

# 直觉

假设 Hercules 永远能按已验证的规范规则继续砍：每一步都能指出阶段数、从根到复制位置的最右祖先链、祖父处的左兄弟，以及父节点内被保留的左兄弟。把第 `n` 时刻的树换成其结构序数，就得到一列序数。证书下降定理说明后一项总比前一项小；但序数像没有无限向下楼梯的楼层编号，不可能沿自然数时间永远严格下降。因此这样的无限游戏对象根本不存在。

# 陈述（自然语言）

`CertifiedStep before after` 表示存在阶段和完整最右脊柱数据，使 `before` 到 `after` 满足上一条 `RightmostSpineReplicatedCut`。有限认证游戏是一张 Hydra 列表，其中每一对相邻状态构成认证步；空列表和单状态列表也算有限游戏。无限认证游戏则给出每个自然数时刻的 Hydra，并证明每次相邻转换都是认证步。任意认证步都使结构序数严格下降，所以无限认证游戏类型为空。

# 陈述（Lean 对照）

```lean
def CertifiedStep (before after : Hydra) : Prop
def IsCertifiedFinitePlay : List Hydra → Prop

structure CertifiedInfinitePlay where
  state : Nat → Hydra
  certified : ∀ n, CertifiedStep (state n) (state (n + 1))

theorem certifiedStep_decreases (step : CertifiedStep before after) :
  hydraOrdinal after < hydraOrdinal before

theorem no_certifiedInfinitePlay : IsEmpty CertifiedInfinitePlay
```

# 思维脉络（thinking trace）

先把一步所需的四类见证打包进 `CertifiedStep`，避免在轨迹定义里重复所有树形参数。有限轨迹用列表递归检查相邻项，为后续记录实际有限对局提供可直接归约的接口；无限轨迹则用函数 `Nat → Hydra` 表达“每个时间都有下一状态”。主证明将轨迹逐点映射为 `rank n = hydraOrdinal (state n)`，由证书步下降得到 `rank (n+1) < rank n`，最后把这条函数封装成无限下降链，与本库 `ordinal_lt_wellFounded` 矛盾。

# 自然语言 ↔ Lean 映射

“一步的完整规范证书”对应 `CertifiedStep` 中存在的 `stage`、`ancestors`、`grandparentSiblings` 和 `parentSiblings`。“有限对局记录”对应 `List Hydra` 及递归谓词 `IsCertifiedFinitePlay`，“假想的永不结束对局”对应 `CertifiedInfinitePlay.state : Nat → Hydra`。“每走一步楼层降低”对应 `certifiedStep_decreases`，“不存在无限向下楼梯”对应 `wellFounded_iff_isEmpty_descending_chain` 对 `ordinal_lt_wellFounded` 的应用。

# 依赖（人话版）

依赖上一条任意有限最右祖先链的实际 `Hydra.Step` 与严格下降结论，以及序数理论条目中“序数小于关系良基”。Mathlib 的一般桥只把良基关系改写成“下降链类型为空”；具体秩函数是本库 `hydraOrdinal`，具体一步关系也是本库 `RightmostSpineReplicatedCut`。证明不使用选择公理制造下一步，因为无限轨迹本身已经携带每个时刻的认证步骤。

# 应用与陷阱

该结论允许以后放心地执行任何始终能生成最右脊柱证书的策略：它不可能产生无限轨迹。不过，`IsEmpty CertifiedInfinitePlay` 不等于已经给出每棵 Hydra 的可计算步数上界，也不保证任意非空状态总有认证下一步；某局也可能因为不再满足证书形状而停止被本接口追踪。最重要的是，`CertifiedStep` 只是 `Hydra.Step` 的受限子类，本条没有证明所有 Hydra 游戏终止，更没有形式化 Kirby–Paris 完整定理、`ε₀` 精确强度或任何 PA 不可证性结论。
