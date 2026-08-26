---
id: topology.fundamental-group.van-kampen-edge-gauge
family: topology.fundamental-group
variant: unified-edge-rebasing-finite-telescope
kind: theorem
state: verified
title: van Kampen 内部边的统一 gauge 与有限望远镜消去
summary: 将同标签和异标签公共边统一成端点重基公式，并严格消去有限边链的全部中间 frame
premises: [topology.fundamental-group.van-kampen-switch-shared-edge]
mathlib: [Group, List.prod, Fin.dfoldl, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

van Kampen 网格证明要把小格边界关系相乘并消去内部公共边。但各小格可能为同一顶点选取不同基点
连接道路，因此两侧公共边一般不以字面相等的群元素出现。本条目显式记录端点 frame 变化，把
common 与 switch 两类局部关系统一后再证明有限链的中间 frame 逐项消去。

# 直觉

若一条定向边的起点连接改变 `s`、终点连接改变 `e`，道路乘法的反序约定使新表示成为
`e⁻¹ * edge * s`。相邻两边共享的中间 frame 在反序乘积中恰好以一个元素及其逆元相邻出现；沿
有限链反复消去后，只留下整条链的起始 frame、终止 frame 和未重基的边词。

# 陈述（自然语言）

定义端点重基运算 `rebaseEdge` 和只保存起终点变化的 `EdgeTransitions`。对水平、竖直内部边，不论
相邻小格标签相同还是不同，都存在统一 transition，使一侧真实边元素等于另一侧边元素的重基。
对任意有限相接边链，各边分别重基后的反序乘积等于整条未重基边词的一次首末端重基；闭链情形只
剩起点 frame 的共轭。单格四边关系在任选四角 frame 后仍为单位元。

# 陈述（Lean 对照）

```lean
def rebaseEdge (startChange endChange edge : G) : G :=
  endChange⁻¹ * edge * startChange

structure EdgeTransitions (G : Type*) where
  startChange : G
  endChange : G

theorem rebasedEdgeChainProduct_eq_rebaseEdge ...
theorem BinaryOpenCoverSquareSubdivision.horizontalInternalEdge_relation ...
theorem BinaryOpenCoverSquareSubdivision.verticalInternalEdge_relation ...
```

# 思维脉络（thinking trace）

先用纯群计算核对两条边的中间 frame 消去、反向边和四边闭环次序。再把 VK3b-02 common relation 与
VK3b-03 switch Pushout relation分别整理成相同的 `rebaseEdge` 形式，按标签相等与否定义统一
transition。有限链主定理对列表归纳，每一步用二边重基乘法合并首边与尾链；`Fin` 和 `dfoldl`
版本随后只负责把数组式网格折叠与列表反序乘积对齐。

# 自然语言 ↔ Lean 映射

“frame 变化”是 `EdgeTransitions.startChange/endChange`；“同/异标签统一”是两个
`*InternalEdgeTransitions` 及其 `*InternalEdge_relation`；未重基边词是 `reverseEdgeChainProduct`，
逐边重基边词是 `rebasedEdgeChainProduct`，链末 frame 是 `edgeChainEnd`。正长度有限下标出口由
`rebasedEdgeChainProduct_ofFn_eq_reverseEdgeChainProduct_of_pos` 给出。

# 依赖（人话版）

纯 telescope 只使用一般群、列表和有限下标，不要求交换律。具体内部边 transition 复用前两条目
建立的同标签 piece relation 与异标签 Pushout relation；Mathlib `Monoid.PushoutI` 仍是正式代数
承载。本库没有重新定义道路、基本群或 Pushout，只补 Mathlib 尚无的网格端点 gauge 组合层。

# 应用与陷阱

乘法次序由道路约定决定，不能把反序边词换成通常列表同序乘积。闭链并非无条件保持原边词，而是
留下首 frame 的共轭。本模块只建立局部内部边和抽象有限链 telescope，尚未执行整行、周界或整张
网格消去，也不证明 kernel 消失、单射或 van Kampen 同构。
