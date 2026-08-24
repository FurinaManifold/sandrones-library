---
id: settheory.googology.hydra-rightmost-spine-descent
kind: theorem
state: verified
title: "任意有限最右祖先链上的 Hydra 复制下降"
premises: ["settheory.googology.hydra-parent-sibling-descent"]
mathlib: []
provenance: {source_type: book, ref: "Laurie Kirby and Jeff Paris, Accessible Independence Results for Peano Arithmetic, 1982; 本条证明带最右脊柱证书的子类"}
---

# 动机

双层最右条目已经允许根和被复制父节点各自保留左兄弟，但被砍头的祖父仍被当作整棵树的根。实际头可以位于任意有限深度；此时复制规则仍只发生在头的祖父处，更高祖先只是把变化后的子树放回原位置。本条用一份有限“最右脊柱证书”记录所有更高祖先，使双层局部证明能够沿任意有限深度向上传播。

# 直觉

从某个局部祖父向树根走，每经过一层，都允许左边挂着任意多棵不变的兄弟树，但变化中的分支必须是该层最右孩子。若较深子树的值从 `β` 降到 `α`，上一层会把它变成 `ω^β` 与 `ω^α`；因为 `ω^·` 严格递增，下降仍在。再把相同左兄弟贡献加在前面，序数加法对右参数严格递增，下降继续保留。有限次重复这个论证，就能到达任意高的根。

# 陈述（自然语言）

最右脊柱是左兄弟森林的有限列表。`plugRightmostSpine` 从内向外把焦点子树依次放在每层左兄弟之后；`rightmostSpinePath` 相应地在局部路径前依次加入每层左兄弟的长度。若局部双层最右复制砍头发生在路径 `[grandparentSiblings.length, parentSiblings.length]`，则添加任意脊柱后，所得完整路径仍执行同一次底部复制，在高层只替换唯一右端分支。该路径是合法头位置、`chop` 得到声明的新树，而且结构序数严格下降。

# 陈述（Lean 对照）

```lean
def plugRightmostSpine : List (List Hydra) → Hydra → Hydra
def rightmostSpinePath : List (List Hydra) → List Nat → List Nat

def RightmostSpineReplicatedCut (stage : Nat)
    (ancestors : List (List Hydra))
    (grandparentSiblings parentSiblings : List Hydra)
    (before after : Hydra) : Prop

theorem rightmostSpineReplicatedCut_verified
    (cut : RightmostSpineReplicatedCut stage ancestors
      grandparentSiblings parentSiblings before after) :
    Hydra.Step stage before after ∧ hydraOrdinal after < hydraOrdinal before
```

# 思维脉络（thinking trace）

证明先建立三条可复用的提升引理。第一，沿脊柱再走局部路径，与直接在焦点中走局部路径得到相同子树，因此头位置合法性可上传。第二，对至少含两个下标的局部 `chop`，外包一层最右上下文时，程序进入选中孩子递归，复制不会错误地在更高层重做；对祖先列表归纳便得到任意深的精确计算。第三，局部赋值下降先经正规函数 `ω^·` 保持严格，再经共同左森林保持严格。最后把底部双层复制定理分别接到这三个接口。

# 自然语言 ↔ Lean 映射

“一层祖先及其左兄弟”对应一个 `List Hydra`，“任意有限祖先链”对应 `List (List Hydra)`。“把变化分支放回每层最右端”对应 `plugRightmostSpine`，“每层选择最右孩子的编号”对应该层兄弟列表的 `.length`，由 `rightmostSpinePath` 拼成完整路径。“底部祖父处实际复制、高层只更新”对应 `chop_plugRightmostSpine`，“下降逐层上传”对应 `hydraOrdinal_plugRightmostSpine_lt`。

# 依赖（人话版）

依赖上一条双层最右复制砍头的合法性与下降、Hydra 的可执行路径语义、森林共同左前缀不等式，以及本库已证明的 `ω` 序数幂正规性。程序侧的列表替换和路径长度事实在本文件直接证明。没有新增 Mathlib 高层定理，也没有直接拿原生序数运算替代本库赋值接口。

# 应用与陷阱

本条把可证子类的深度从固定两层推广到任意有限层，并准确遵守当前 `chop` 的语义：复制只在头的祖父层发生一次，更高层绝不重复复制。不过，每层选中分支仍须位于孩子列表最右端，底部被砍头也须是父节点最右孩子；这是一份规范顺序证书，而不是任意路径。若右侧存在兄弟，序数加法吸收问题仍未解决。因此本条不覆盖全部 `Hydra.Step`，不推出所有游戏终止、`ε₀` 总界或 PA 不可证性。
