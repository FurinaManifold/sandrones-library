---
id: topology.fundamental-group.van-kampen-surjectivity
family: topology.fundamental-group
variant: binary-open-cover-path-connected-surjectivity
kind: theorem
state: verified
title: 二开集 van Kampen 规范同态的满射
summary: 道路连通二开集及其交覆盖空间时，基本群合并自由积到环境基本群的规范同态满射
premises: [topology.fundamental-group.van-kampen-cover-subdivision]
mathlib: [FundamentalGroup.map, Monoid.PushoutI, Monoid.PushoutI.lift, Monoid.PushoutI.lift_of, IsPathConnected.joinedIn, Path.Homotopic.Quotient.map_comp]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

Seifert--van Kampen 定理把二开集覆盖的基本群描述为两个覆盖成员基本群沿交集基本群的推送。本条目
完成其中的一维生成性部分：构造规范同态，并证明环境基本群中的每个环路类都来自一个有限的覆盖
成员环路词。单射需要二维零同伦细分，不属于本条目。

# 直觉

先把环境中的基环路细分成有限段，每段落在 `U` 或 `V`。每个网格顶点选择一条从公共基点到它的
连接道路；标签切换时该顶点位于交集，因此可在相邻两个覆盖成员中使用同一连接。给每段左右补上
连接道路及其逆，就得到位于单个覆盖成员中的基环路。所有修正环路相乘时，中间连接逐项抵消，
只剩原环路。于是这些覆盖成员基本群元素组成的有限 `PushoutI` 词就是原环路类的原像。

# 陈述（自然语言）

设 `U,V` 是拓扑空间 `X` 的开集，`U∪V=X`，公共基点 `x₀` 同时属于二者，并且 `U`、`V`、
`U∩V` 都道路连通。两个包含映射诱导从交集基本群到两个覆盖成员基本群的同态，因而得到它们的
合并自由积。由覆盖成员包含到 `X` 所诱导的规范同态到 `π₁(X,x₀)` 是满射。

# 陈述（Lean 对照）

```lean
def binaryVanKampenCanonicalMap (U V : Set X) {x₀ : X}
    (hxU : x₀ ∈ U) (hxV : x₀ ∈ V) :
    binaryVanKampenPushout U V hxU hxV →* FundamentalGroup X x₀

theorem surjective_binaryVanKampenCanonicalMap
    {x₀ : X} (U V : Set X) (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUopen : IsOpen U) (hVopen : IsOpen V) (hcover : U ∪ V = Set.univ)
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (hUV : IsPathConnected (U ∩ V)) :
    Function.Surjective (binaryVanKampenCanonicalMap U V hxU hxV)
```

# 思维脉络（thinking trace）

VK1 给出带布尔标签的有限子道路。`exists_basedConnectors` 用三个道路连通假设选择网格顶点连接：
首末使用常道路；内部同标签顶点在相应覆盖成员中连接；异标签顶点由 VK1 的交集结论在 `U∩V`
中连接。`segmentPieceLoop` 把每个带标签段修正为覆盖成员中的基环路，`pushoutSegmentWord` 将这些
生成元按基本群乘法次序组成有限词。规范同态逐项计算为 `correctedLoopWord`；有限抵消、VK1 拼接
同伦和两个端点 transport 引理证明该词等于原环路类。最后对基本群元素选择代表环路即可得到原像。

# 自然语言 ↔ Lean 映射

“交集沿两侧的包含”对应 `binaryOpenCoverIntersectionMaps`；“合并自由积”对应
`binaryVanKampenPushout`，其承载直接是 Mathlib `Monoid.PushoutI`；“规范同态”对应
`binaryVanKampenCanonicalMap`；“网格顶点连接”对应 `BinaryOpenCoverSubdivision.BasedConnectors`；
“单段修正基环路”对应 `segmentPieceLoop`；“有限覆盖成员词”对应 `pushoutSegmentWord`；“中间
连接抵消后恢复原环路”对应 `correctedLoopWord_eq_loop`；最终满射即
`surjective_binaryVanKampenCanonicalMap`。这里每条 VK1 子道路已经是一个同标签有限块；满射证明
不需要把相邻同标签段额外压缩成极大块。

# 依赖（人话版）

本条目复用 VK1 的有限带标签 `Path.subpath` 数据。Mathlib `FundamentalGroup.map` 负责连续包含诱导的
基本群同态；`Monoid.PushoutI`、`lift` 与 `lift_of` 分别承载合并自由积、给出规范映射及计算生成元；
`IsPathConnected.joinedIn` 选择限制在指定集合内的连接道路；
`Path.Homotopic.Quotient.map_comp` 验证交集经任一覆盖成员再进入环境空间的映射兼容。上述接口只是
证明材料；Mathlib 当前没有提供本条目的 Seifert--van Kampen 满射定理。

# 应用与陷阱

该结论证明规范映射是满射，适合说明环境基本群由两个覆盖成员的像生成。它不证明规范映射单射，
因而不能把 `binaryVanKampenPushout` 与 `FundamentalGroup X x₀` 当作同构，也不能直接推出完整
Seifert--van Kampen 定理。三个道路连通假设用途不同：`U,V` 提供同标签顶点连接，`U∩V` 保证标签
切换处能选同一条连接。`U∪V=Set.univ` 用于任意环境环路；若只覆盖某一条给定环路，只能得到该
环路类有原像，不能推出整个规范同态满射。
