---
id: complex-analysis.cauchy.homotopy
family: complex-analysis.cauchy
variant: simply-connected-homotopy-primitive
kind: theorem
state: verified
title: 同伦形式的 Cauchy 定理与单连通域原函数
summary: 在单连通开域中由拓扑假设自动得到同端点道路的相对同伦，从而证明全纯函数的路径积分只依赖端点、存在原函数，并推出闭分段 C1 道路积分为零
premises: [complex-analysis.path-integral.piecewise-c1-homotopy-invariance, complex-analysis.cauchy.primitive-from-path-independence-foundation, complex-analysis.cauchy.admissible-path-connectivity-foundation, complex-analysis.holomorphic.definition, complex-analysis.integral.path, topology.homotopy.piecewise-c1-path, topology.homotopy.homotopy-square-grid]
mathlib: [IsSimplyConnected, SimplyConnectedSpace, SimplyConnectedSpace.paths_homotopic, Path.Homotopy, Path.Homotopy.map, Path.map, Path.Homotopic, HasDerivAt, IsOpen]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

C2 已经验收了「连续相对同伦加分段 C1 边界蕴含积分不变」，但它以「使用者已经拿到同伦」为假设。
教材的一般形式不允许这样：Cauchy 定理说的是，只要两条道路在域内**同伦**，积分就相等；在单连通
域上，同伦本身是拓扑假设的推论。缺了这一步，「单连通域上的全纯函数有原函数」——C2 依赖链通向
Laurent 与残数理论的最后一环——就无法从本库自己的课程链推出。本条目补上这一半，并把由它导出的
原函数与闭路积分为零一并交付。

# 教材陈述

设 `U ⊆ ℂ` 是单连通开集，`f` 在 `U` 上全纯。则：

1. `U` 内任意两条同端点、像落在 `U` 内的连续道路相对端点同伦，且同伦像留在 `U` 内；
2. 任意两条同端点、像落在 `U` 内的分段 C1 道路 `gamma`、`delta` 满足
   `∫_gamma f(z) dz = ∫_delta f(z) dz`；
3. `f` 在 `U` 上存在原函数 `g`（即 `g' = f` 于 `U`），从而 `∫_gamma f dz = g(b) - g(a)`；
4. `U` 内每条分段 C1 闭路满足 `∮_gamma f(z) dz = 0`。

这是 Ahlfors 第 4 章的同伦形式 Cauchy 定理及其原函数推论：同伦不变性给出路径无关，路径无关加
连通性给出原函数。条目只处理教材意义上的道路（分段 C1 参数化），不把积分推广到任意连续曲线。

# Lean 定理与边界

```lean
def HomotopicWithin (U : Set ℂ) (gamma delta : Path a b) : Prop :=
  ∃ F : gamma.Homotopy delta, ∀ z, pathHomotopySquare F z ∈ U

theorem homotopicWithin_iff (gamma delta : Path a b) :
    HomotopicWithin U gamma delta ↔ ∃ F : gamma.Homotopy delta, ∀ s t, F (s, t) ∈ U

theorem AdmissiblePath.piecewiseC1 (h : AdmissiblePath f U gamma) : Path.PiecewiseC1 gamma

theorem homotopicWithin_of_isSimplyConnected
    (hU : IsSimplyConnected U) (ha : a ∈ U) (hb : b ∈ U)
    (hgamma : ∀ t, gamma t ∈ U) (hdelta : ∀ t, delta t ∈ U) :
    HomotopicWithin U gamma delta

theorem pathIntegral_eq_of_homotopicWithin
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U)
    (hgamma : Path.PiecewiseC1 gamma) (hdelta : Path.PiecewiseC1 delta)
    (hhom : HomotopicWithin U gamma delta) :
    pathIntegral f gamma = pathIntegral f delta

theorem pathIntegral_eq_of_isSimplyConnected
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U) (hconn : IsSimplyConnected U)
    (hgamma : Path.PiecewiseC1 gamma) (hdelta : Path.PiecewiseC1 delta)
    (himg : ∀ t, gamma t ∈ U) (hdimg : ∀ t, delta t ∈ U) :
    pathIntegral f gamma = pathIntegral f delta

theorem pathIntegralIndependentOn_of_isSimplyConnected
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U) (hconn : IsSimplyConnected U) :
    PathIntegralIndependentOn f U

theorem exists_primitive_of_isSimplyConnected
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U) (hconn : IsSimplyConnected U) :
    ∃ g : ℂ → ℂ, ∀ z ∈ U, HasDerivAt g (f z) z

theorem pathIntegral_eq_zero_of_isSimplyConnected
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U) (hconn : IsSimplyConnected U)
    (hgamma : Path.PiecewiseC1 gamma) (himg : ∀ t, gamma t ∈ U) :
    pathIntegral f gamma = 0
```

边界有三条。其一，拓扑桥 `homotopicWithin_of_isSimplyConnected` 对**任意连续**道路成立，但积分
语句仍要求两条道路是分段 C1：本库的路径积分按 `Path.PiecewiseC1` 的有限拼接定义，一般连续曲线
不在课程层内。其二，原函数存在性只声明存在性，不构造闭式；`exists_primitive_of_isSimplyConnected`
的证明复用 foundation 里「从基点沿可积正则道路积分」的构造，本条目不重写它。其三，
`IsSimplyConnected` 是 Mathlib 的强形式（基本群胚等价于 `Unit`），本条目不声明它与教材中
「域内每条闭路零同伦」的完全等价；零同伦的逐点展开由
`isSimplyConnected_iff_exists_homotopy_refl_forall_mem` 承担。

# 自然语言 ↔ Lean 映射

「`gamma` 与 `delta` 在 `U` 内相对端点同伦」由本库谓词 `HomotopicWithin U gamma delta` 承载，
它量化一个 `Path.Homotopy`（Mathlib 中即固定 `{0,1}` 的 `HomotopyRel`）并要求方形像落在 `U`；
`homotopicWithin_iff` 给出教材 `∀ s t, F (s,t) ∈ U` 的坐标写法。「单连通」用 Mathlib 的
`IsSimplyConnected`（子类型上的 `SimplyConnectedSpace`），不另造谓词。「分段 C1」是本库
`Path.PiecewiseC1` 归纳谓词；原函数构造用的 `AdmissiblePath` 通过 `AdmissiblePath.piecewiseC1`
接上它。「原函数」就是逐点的 `HasDerivAt g (f z) z`，与 foundation 的结论形式一致。「积分只依赖
端点」是本库既有谓词 `PathIntegralIndependentOn`，因此新结论可以直接喂给既有的原函数构造。

# 证明思路

拓扑桥是全部新内容的核心：把两条道路 `gamma`、`delta` 用结构字面量提升为子类型 `U` 上的道路
（连续性由 `Continuous.subtype_mk` 给出，端点等式由 `Subtype.ext` 从 `Path.source/target` 得到）；
单连通的子类型上，`SimplyConnectedSpace.paths_homotopic` 直接给出两者同伦；再沿
`Subtype.val` 用 `Path.Homotopy.map` 把同伦搬回复平面。搬运后道路与原道路定义等价，因此无需
改写同伦的类型；像集条件就是子类型元素的第二分量。

拿到拓扑桥之后，分析部分按教材顺序组装。`pathIntegral_eq_of_isSimplyConnected` 把桥提供的同伦
交给已验收的 `pathIntegral_eq_of_piecewiseC1_homotopyWithin`——该条目内部完成正则化：对同伦像
逐点选开球，做 indexed Lebesgue-number 方形细分，把连续方形换成 dyadic 网格边界，再沿网格消去
内部边；上下边是端点常值道路（端点控制），左右边严格识别为两条道路的 dyadic 小段。
`pathIntegralIndependentOn_of_isSimplyConnected` 对任意两条 `AdmissiblePath` 做同一件事，其中
`AdmissiblePath.piecewiseC1` 把正则承载换成同伦不变性要求的承载。最后
`exists_primitive_of_isSimplyConnected` 把路径无关性喂给
`exists_primitive_of_isSimplyConnected_of_pathIntegralIndependentOn`，闭路积分为零则由闭路与
常值道路比较得到。

# 正式承载与定义链

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | 角色 | 首个使用者 |
|---|---|---|---|---|---|
| 单连通域 | 域内闭路皆零同伦 | Mathlib `IsSimplyConnected` | `isSimplyConnected_iff_exists_homotopy_refl_forall_mem`（Mathlib 提供的教材展开；本条目的证明直接使用 `SimplyConnectedSpace.paths_homotopic`，未调用该 iff，故它不进 front matter 的 `mathlib` 依赖表） | 语义一致的正式承载 | `homotopicWithin_of_isSimplyConnected` |
| 相对端点同伦 | 固定端点的连续变形，像在域内 | Mathlib `Path.Homotopy`；本库 `HomotopicWithin` 包装像集条件 | `homotopicWithin_iff` | 正式承载 + 本库桥侧谓词 | `pathIntegral_eq_of_homotopicWithin` |
| 分段 C1 道路 | 有限段 C1 参数化 | 本库 `Path.PiecewiseC1` | `AdmissiblePath.piecewiseC1` | 本库课程承载 | `pathIntegral_eq_of_isSimplyConnected` |
| 路径积分 | `∫_gamma f dz` | 本库 `pathIntegral` | 既有 `pathIntegral_trans/symm` | 语义一致的正式承载 | `pathIntegral_eq_of_isSimplyConnected` |
| 原函数 | `g' = f` 于域上 | `∀ z ∈ U, HasDerivAt g (f z) z` | `pathIntegral_eq_sub_of_primitive_of_admissiblePath` | Mathlib `HasDerivAt` 正式承载 | `exists_primitive_of_isSimplyConnected` |
| 路径无关 | 积分只依赖端点 | 本库 `PathIntegralIndependentOn` | 定义即展开 | 本库课程承载 | `exists_primitive_of_isSimplyConnected` |

定义链在聚合文件中真实组装：正式承载（`IsSimplyConnected`、`Path.Homotopy`）→ 展开
（`isSimplyConnected_iff_exists_homotopy_refl_forall_mem`、`homotopicWithin_iff`）→ 本库桥
（`homotopicWithin_of_isSimplyConnected`、`AdmissiblePath.piecewiseC1`）→ 上层使用者
（`exists_primitive_of_isSimplyConnected`、`pathIntegral_eq_zero_of_isSimplyConnected`）。
本文件没有新的 typeclass 实例、notation 或全局 instance；`HomotopicWithin` 的引入理由是教材量词
需要「同伦像受控于域」这一合取，`Path.Homotopy` 本身不含它，而三处公开定理都消费该合取。

# 应用与陷阱

可以直接使用的结论是：单连通开域上全纯函数的闭路积分消失、积分只依赖端点、存在原函数。对圆周、
凸域等可缩域，`SimplyConnectedSpace.ofContractible` 直接给出 `IsSimplyConnected`，无需手工构造
同伦。两个常见误用：其一，把 `HomotopicWithin` 当成 `Path.Homotopic` 的别名——前者额外要求像集
受控，缺了它积分不变性不成立；其二，以为本条目重证了正则化——正则化、分段 C1 逼近与端点控制
全部由已验收的 `complex-analysis.path-integral.piecewise-c1-homotopy-invariance` 及其前置条目
承担，本条目只补拓扑一半并组装。另外，本条目不覆盖任意连续曲线的积分，也不覆盖同调形式
（null-homologous cycle）的 Cauchy 定理，后者是残数定理才需要的桥。

# 来源与诚实边界

Ahlfors 第 4 章给出同伦形式 Cauchy 定理与单连通域原函数的标准叙述与证明路线；Hatcher 第一章
提供端点相对道路同伦与单连通性的拓扑对象层。Mathlib 的 `Analysis/Complex/HasPrimitives.lean`
只证到圆盘与全平面上的原函数（文件内 TODO 明言尚未推广到单连通域），因此本条目的原函数存在性
不是 Mathlib 现成定理的改名。诚实边界：本条目交付的是教材依赖链上的「同伦 → 路径无关 →
原函数」三段，它的证明强度依赖已验收的正则化条目；它不声明 `IsSimplyConnected` 与教材
「零同伦」定义的完全等价，也不提供残数理论所需的同调版本 Cauchy 定理。
