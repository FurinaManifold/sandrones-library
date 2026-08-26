---
id: topology.fundamental-group.van-kampen-rebased-letter-word
family: topology.fundamental-group
variant: actual-left-boundary-to-input-word
kind: theorem
state: verified
title: van Kampen 真实左边界与 rebased 字母词
summary: 将完整真实网格左边界词识别为原输入 Pushout 字母词在全局首末 frames 下的一次 rebase，并由右锚定网格取消证明该 rebased 字母词等于一
premises: [topology.fundamental-group.van-kampen-global-block-telescope]
mathlib: [Path, List, Fin, FundamentalGroup, Monoid.PushoutI, Group]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

14b 已把全部实际细边压缩成第二层 letter block chain 的一次整体 rebase，但该 chain 按
`letters.reverse` 的 dyadic blocks 构造，并通过反序 edge-chain product 读取。必须严格证明这两层反序
最终恢复原 `binaryVanKampenLetterWord letters`，而不是得到反向词。还要把抽象 factor chain 接回真实
同伦方格左边界，才能使用 08b 的网格取消定理。

# 真实 block 与输入 segment

`leftBoundarySegmentGridEdge` 把最左网格细边 transport 到输入 concat 道路的对应细网格端点，并严格
识别为 `Path.subpath`。同一 dyadic block 内全部细边用 `Path.concat` 拼接后，与该 block 的完整 subpath
端点相对同伦。

`leftBoundaryConcatDyadicSegment_homotopic` 再将整个真实 block transport 到输入 `Path.concat` 的规范
segment 端点，并使用 10a 已验收的 dyadic segment 同伦恢复原输入道路 segment。该定理只比较道路
同伦类，不声称不同参数化的原始 paths 严格相等。

# 两层反序代数桥

`reverseDfoldl_reverse_get_eq_map_prod` 是任意群中的有限依赖折叠公式：对 reverse 列表按 `get` 形成的
反向 fold，恰好等于原列表映射后的正序 `List.prod`。`binaryVanKampenLetterWord_eq_map_prod` 则把
Pushout 字母词定义展开为每个 letter 规范映射像的正序乘积。

二者与 14b 的 `reverse_flatten_prod` 一起锁定三层顺序：block 内反序、blocks 反序、输入 letters 原
顺序。全程只使用结合律，没有使用交换律。

# 从 block chain 到原字母词

`leftBoundaryFramedBlocks_eq_rebaseWord` 将 14b 的第二层 telescope factor product 改写为
`binaryVanKampenLetterWord letters`。首 frame 是第一个 block 第一细边的 combined start frame；末
frame 由第二层 chain 的最终 end frame给出。

`leftBoundaryAllFramedCellEdges_eq_rebaseWord` 再用 flatten/grid bridge 将该等式左侧换成所有真实网格
左边界细边的 framed 反序乘积。

# rebased word 等于一

08b 已证明右锚定网格的完整左边界词为单位元。14a 的 actual-grid bridge 和 14b 的 flatten 顺序定理
表明本批左侧正是该网格词。因此 `rebasedLetterWord_eq_one` 得到

```text
rebaseEdge globalStart globalEnd (binaryVanKampenLetterWord letters) = 1.
```

这是 telescope 链的正确终点；它尚未推出原字母词本身为一，因为 `globalStart` 与 `globalEnd` 可能留下
residual gauge。

# Lean 对照

```lean
theorem PathConcatAlignedSquareSubdivision.leftBoundaryConcatDyadicSegment_homotopic ...
theorem reverseDfoldl_reverse_get_eq_map_prod ...
theorem binaryVanKampenLetterWord_eq_map_prod ...
theorem PathConcatAlignedSquareSubdivision.leftBoundaryFramedBlocks_eq_rebaseWord ...
theorem ...leftBoundaryAllFramedCellEdges_eq_rebaseWord ...
theorem ...rebasedLetterWord_eq_one ...
```

# 正式承载与公开面

道路、同伦、列表、有限索引、群、基本群和 Pushout 复用 Mathlib。dyadic alignment、网格细边、block
chains、right-anchored cancellation 与字母词承载均复用前序本库接口。本批没有新增 carrier、instance、
notation、Path、基本群或 Pushout。

公开面为一个几何 block 同伦、两个通用／Pushout 顺序桥以及三个逐级收束主定理，共六项。八个
private 只处理 subpath casts、block concat、corrected-loop quotient 与第二层 chain 的实现改写。

# 尚未完成的边界

本批只证明原字母词在 residual frames 下 rebase 后为一。它不证明首末 frames 相等、residual gauge
平凡、kernel word 为一、规范同态单射或最终 van Kampen 同构；这些属于 VK3b-15。
