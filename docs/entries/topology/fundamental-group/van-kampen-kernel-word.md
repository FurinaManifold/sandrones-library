---
id: topology.fundamental-group.van-kampen-kernel-word
family: topology.fundamental-group
variant: nonempty-nullhomotopic-letter-word
kind: theorem
state: verified
title: van Kampen 非空 kernel 字母词消失
summary: 利用 residual gauge 端点相等消去整体 rebase，证明非空且拼接环路零伦的 Pushout 字母词等于单位元
premises: [topology.fundamental-group.van-kampen-residual-gauge]
mathlib: [Path, FundamentalGroup, Monoid.PushoutI, Fin, Group]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

网格消去在 14c 留下的是整体 rebased 字母词等于一。15a 又证明首末 combined frames 相对于顶点势
留下相同 residual gauge。本条目把这两条信息接合，恢复教材 van Kampen 单射证明的核心结论：若
字母词对应的环境拼接环路零伦，则该词已经在群 pushout 中消失。

# 首末 block chain

`leftBoundaryLetterBlockChain_end` 计算完整 letter-block chain 的终点；它把逐 block 的 endpoint
cocycle 与全局 chain 的递归定义接起来。`leftBoundaryGlobalCombinedFrames_eq` 再用 15a 的 boundary
residual telescope，证明真实全局首 frame 和末 frame 相同。

# 非空 kernel 字母词

`letterWord_eq_one_of_homotopy_of_nonempty` 假设字母列表非空，并给定其 concat loop 到常值环路的
端点相对同伦以及与该同伦对齐的方格细分。14c 给出整体 rebase 为一，首末 frame 相等把 rebase 化为
共轭；左右乘首 frame 及其逆元便得到原 `binaryVanKampenLetterWord` 等于一。证明只用群公理，不使用
交换律。

# 常值 connector 桥

`fundamentalGroup_fromPath_correctedLoop_refl` 说明在一个 loop 两端接上常值 connector 后，取其
`FundamentalGroup.fromPath` 与原 loop 相同。这个公开桥由 15c 的规范同态计算真实消费；它不是额外的
kernel 假设，也没有把最终同构回填到本批。

# Lean 对照

```lean
theorem PathConcatAlignedSquareSubdivision.leftBoundaryLetterBlockChain_end ...
theorem PathConcatAlignedSquareSubdivision.leftBoundaryGlobalCombinedFrames_eq ...
theorem PathConcatAlignedSquareSubdivision.letterWord_eq_one_of_homotopy_of_nonempty ...
@[simp] theorem fundamentalGroup_fromPath_correctedLoop_refl ...
```

# 正式承载与 Mathlib 复用

道路、端点相对道路同伦、基本群、有限索引、群和 `Monoid.PushoutI` 直接复用 Mathlib 的语义一致承载。
字母词、concat loop、aligned square subdivision、combined frames、block chain 和 residual gauge 全部
复用本库前序 Entry。本批不复制 Path、基本群或 pushout，也不新增 carrier、instance 或 notation。

# 证明思路

先由逐 block endpoint 公式 telescope 出全局 chain 终点，再把 15a 的 residual equality 与两端
potential transition 对齐，得到 combined start/end frames 相等。将此等式代入 14c 的 rebased-word
结论后，对等式两侧作同一共轭消去，最终由群正规化得到原词为一。最后单独展开 corrected loop 和
`FundamentalGroup.fromPath`，证明常值 connector 的计算桥。

# 边界

主定理显式要求字母列表非空；空列表由 15c 的简单分支处理。本批不从任意 canonical-map kernel
元素构造字母表示，不证明规范同态单射或最终等价，也不覆盖 many-set、groupoid 或交集不道路连通
版本。
