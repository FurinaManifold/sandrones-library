---
id: topology.homotopy.path-cod-restrict
family: topology.homotopy
variant: subtype-codomain-restriction
kind: definition
state: verified
title: 道路到子空间的余域限制
summary: 将值域包含于集合的环境道路提升为该子空间中的道路，并保持底层函数逐点不变
premises: [topology.homotopy.path-definition-foundation]
mathlib: [Path, Set, Continuous.subtype_mk]
provenance:
  source_type: book
  ref: "munkres-topology-2000"
---

# 动机

拓扑证明经常先在环境空间中构造道路，再证明其像位于某个子空间。基本群或子空间同伦接口却需要
一条真正以 subtype 为余域的道路。本条目提供一次性的通用转换，避免每个覆盖、流形或邻域论证
重新包装同一条道路。

# 直觉

若对所有参数 `t` 都有 `p(t)∈S`，就把每个值 `p(t)` 与这份成员证明配成 subtype 点
`⟨p(t), hp(t)⟩`。subtype 的连续性恰好等价于底层函数连续且值域位于 subtype，端点则使用给定的
`hx`、`hy`。

# 陈述（自然语言）

设 `p` 是从 `x` 到 `y` 的道路，且 `x,y∈S` 并且道路每一点都属于 `S`。则存在 subtype `S` 中从
`⟨x,hx⟩` 到 `⟨y,hy⟩` 的道路。把新道路强制转换回环境空间后，在每个参数处严格等于 `p`。

# 陈述（Lean 对照）

```lean
def pathCodRestrict (S : Set X) (p : Path x y)
    (hx : x ∈ S) (hy : y ∈ S) (hp : ∀ t, p t ∈ S) :
    Path (⟨x, hx⟩ : S) ⟨y, hy⟩

@[simp] theorem pathCodRestrict_coe ... (t : unitInterval) :
    ((pathCodRestrict S p hx hy hp t : S) : X) = p t
```

# 思维脉络（thinking trace）

新道路的函数值定义为 `⟨p t, hp t⟩`。连续性由 `p.continuous.subtype_mk` 得到；source、target 字段
先用 subtype 外延降为 ambient 点相等，再使用原道路端点规则。coercion 定理由定义计算直接成立。

# 自然语言 ↔ Lean 映射

集合是 `S : Set X`；端点成员证明是 `hx`、`hy`；整条道路的值域证书是 `hp`；提升后的道路是
`pathCodRestrict S p hx hy hp`；“底层函数不变”对应 `[simp]` 引理 `pathCodRestrict_coe`。

# 依赖（人话版）

Mathlib `Path` 承载带固定端点的连续映射，`Continuous.subtype_mk` 将连续函数及逐点成员证明提升到
subtype。此构造不依赖开性、道路连通性、开覆盖、基本群或 Pushout；Mathlib 当前没有同用途的
`Path` 余域限制构造可直接复用。

# 应用与陷阱

调用者必须给出整条道路的逐点成员证明，仅有两个端点属于 `S` 不够。不同的成员证明不会改变强制
转换后的底层函数，但依赖类型中的 subtype 道路仍可能需要 proof irrelevance 或 cast 引理来比较。
正式源码只有这一套构造；VK2 通过 import 消费它，没有保留旧定义或 alias。
