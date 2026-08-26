---
id: topology.fundamental-group.van-kampen-letter-word
family: topology.fundamental-group
variant: binary-pushout-letter-word-and-concat-loop
kind: theorem
state: verified
title: van Kampen Pushout 字母词与拼接环路
summary: 将二开集基本群 Pushout 的任意元素表示为有限单侧字母词，为各字母选择环境环路，并按群乘法方向构造反序 Path.concat 环路
premises: [topology.fundamental-group.van-kampen-right-anchored-grid]
mathlib: [FundamentalGroup, Path, Path.Homotopic.Quotient, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

要证明 van Kampen 规范同态单射，必须把 Pushout 中抽象的群元素转成可以沿同伦方格追踪的有限道路数据。
本条目建立这座桥的第一层：先把 Pushout 元素写成来自两个覆盖成员基本群的有限字母词，再为每个字母
选择实际环路，并把它们拼成环境空间中的一条候选环路。

# 直觉

Pushout 由两侧基本群的像生成，所以每个元素都是有限个单侧字母的乘积。基本群元素本身是道路同伦类，
商映射满射性允许选择一条实际代表环路。把各代表沿覆盖成员包含映入环境空间后，就可以用
`Path.concat` 拼接；由于 Mathlib 基本群乘法与道路拼接的方向约定相反，输入字母必须先反序。

# 陈述（自然语言）

每个二开集 van Kampen Pushout 元素都等于某个有限字母词。每个字母具有一条环境基点环路代表，
规范同态在单字母上的值就是该环路的基本群类。字母列表反序后可以构造一条 `Path.concat` 环路，且
每个输入 segment 逐点位于该字母指定的覆盖成员。若任一基点环路的基本群类为单位元，则它与常值道路
端点相对同伦。

# 陈述（Lean 对照）

```lean
abbrev BinaryVanKampenLetter ...
def binaryVanKampenLetterWord ...
theorem exists_binaryVanKampenLetterWord ...
noncomputable def fundamentalGroupPathRepresentative ...
noncomputable def BinaryVanKampenLetter.ambientLoop ...
theorem binaryVanKampenCanonicalMap_of_letter ...
theorem pathHomotopic_refl_of_fromPath_eq_one ...
noncomputable def binaryVanKampenLetterConcatLoop ...
theorem binaryVanKampenLetterConcatLoop_segment_mem ...
```

# 思维脉络（thinking trace）

`Monoid.PushoutI.induction_on` 分别处理单侧生成元、交集生成元和乘积；乘积分支把两份有限列表连接，
私有 append 引理保证列表解释与群乘法相容。道路代表由 `Path.Homotopic.Quotient.mk_surjective` 选择，
再用覆盖成员的连续包含映入环境空间。单字母公式展开 Pushout 的 lift 并使用代表的商类等式。
最后由 `Path.concat` 形成反序拼接，segment-membership 归约到代表道路值属于相应子类型。

# 自然语言 ↔ Lean 映射

带覆盖标签的单字母由 `BinaryVanKampenLetter` 承载，有限词解释和存在性分别是
`binaryVanKampenLetterWord`、`exists_binaryVanKampenLetterWord`。道路代表的正式承载是 Mathlib
`Path`，其计算规则是 `fundamentalGroupPathRepresentative_mk`。环境环路及逐点展开由
`ambientLoop`、`ambientLoop_apply` 给出；反序拼接和覆盖标签出口分别是
`binaryVanKampenLetterConcatLoop`、`binaryVanKampenLetterConcatLoop_segment_mem`。

# 依赖（人话版）

本条目直接复用 Mathlib 的 `FundamentalGroup`、`Path`、道路同伦商和 `Monoid.PushoutI`，这些分别
正式承载基本群元素、实际道路、道路同伦类以及二群同态 Pushout；没有另造自由积、商群或第二套道路
同伦结构。本库上游提供二开集覆盖成员、基点、包含映射与规范同态。本层不要求开性、道路连通性或
覆盖全空间，因为有限词表示是 Pushout 的纯代数性质。

# 应用与陷阱

`Path.concat` 的断点是 dyadic，而不是把区间等分为字母数份；后续必须使用专门的 dyadic/aligned
subdivision，不能套用等长分段公式。代表道路依赖非计算选择，后续结论不得依赖具体选择结果。本条目
尚未证明整个 concat 环路的基本群类等于字母词，也没有证明 kernel 字母词零伦、规范同态单射或最终
van Kampen 同构；这些属于 VK3b-10 以后的 telescope 链。
