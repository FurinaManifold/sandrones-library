# F5.6 Fredholm 备择接口与教材范围调查

- 分支：`codex/functional-analysis`
- Main 基线：`d2dc95f`
- 权限：`research_open`
- 状态：依赖图与签名风险调查；不提交最终定理

## 教材页面核对

本调查使用 Bühler--Salamon PDF 页面图像，不使用文本抽取：

- PDF 194--198（印刷页 179--183）：Definition 4.3.1、Theorem 4.3.3、Theorem 4.3.8 和
  Main Fredholm Lemma 4.3.9；
- PDF 208（印刷页 193）：Exercise 4.5.13，标题为 Fredholm Alternative。

正文 Theorem 4.3.8 刻画 Fredholm 算子等价于模紧算子可逆；Lemma 4.3.9 从一个下界型估计推出
有限维核与闭值域。Exercise 4.5.13 则只讨论有限秩积分核对应的方程 `u + Ku = h`：或者对每个
`h` 唯一可解，或者齐次方程有非零解。

因此 ROADMAP F5.6 的“一般恒等减紧算子的 Fredholm 备择”强于该练习的对象范围。正式 Entry
必须由 Main 冻结一般版本所依据的教材链；不能把具体有限秩积分方程静默扩写成任意紧算子定理。
具体积分核实例仍应归 Examples E11，而不是泛函分析理论文件。

## Mathlib 当前状态

`Mathlib.Analysis.Normed.Operator.Compact.FredholmAlternative` 已有一般最终结果：

- `IsCompactOperator.antilipschitz_of_not_hasEigenvalue`；
- `IsCompactOperator.hasEigenvalue_or_mem_resolventSet`；
- `IsCompactOperator.hasEigenvalue_iff_mem_spectrum`。

最终定理适用于非平凡赋范域上的 Banach 空间，表述为非零 `μ` 或是紧算子特征值，或属于预解集。
取 `μ = 1`（并处理符号约定）可推出恒等减紧算子的“非平凡核或可逆”形式。但 ROADMAP 已明确
要求不得用该最终 package 代替教材证明链，因此这些声明只用于范围对照和结果校验，不作为未来
课程定理证明的一行后端。

## 已有本库依赖

```text
CompactOperator.lean
  IsCompactOperator 的教材单位球像刻画
        |
        v
ClosedRange.lean / ClosedRangeDuality.lean
  range/ker annihilator 与闭值域四项链
        |
        v
FredholmDefinition.lean
  IsFredholm 展开、核/余核有限维、index
        |
        v
F5.6 待冻结
  I-K 的核有限维与值域闭
  I-K 的余核有限维及 index = 0
  injective <-> surjective <-> invertible
  非平凡核 or 全空间唯一可解
```

## 需要自行证明而非调用最终 package 的桥

1. 对紧算子 `K : E →L[ℝ] E`，建立 `I - K` 的有限维核与闭值域。教材式路线应使用 Riesz lemma
   与紧性反证，对应 Mathlib 最终文件内部的 bounded-below/闭嵌入步骤，但不能调用最终备择。
2. 建立 `I - K` 的余核有限维。可通过对偶算子、紧性的对偶保持以及既有闭值域零化子接口完成；
   需要确认本库是否先补 `K*` 紧致这一 F5.4 教材定理。
3. 证明 `index (I - K) = 0`。可能路线是紧扰动指数稳定性；而该稳定性在当前 ROADMAP 中尚未
   明确开放，不能假定已有。
4. 从 index 零推出 `ker = 0 ↔ cokernel = 0`，再把余核零解释为满射，最后用 Banach 逆算子定理
   得到连续逆。

第 2、3 项是正式开发的实际依赖门。仅有 `FredholmDefinition.lean` 并不足以证明一般备择。

## 建议候选公开签名

以下只供 Main 冻结，不是本批提交的 Lean 声明：

```lean
theorem identity_sub_compact_isFredholm
    [CompleteSpace E] (hK : IsCompactOperator K) :
    (ContinuousLinearMap.id ℝ E - K).IsFredholm

theorem fredholmAlternative_identity_sub_compact
    [CompleteSpace E] (hK : IsCompactOperator K) :
    Function.Injective (ContinuousLinearMap.id ℝ E - K) ↔
      Function.Surjective (ContinuousLinearMap.id ℝ E - K)
```

若课程要求“二择一”形式，应从第二条推导“齐次方程有非零解，或每个右端项唯一可解”，避免另建
solution structure。是否公开 index-zero 中间定理，应由 Main 连同紧扰动稳定性窗口一起冻结。

## 明确边界

- 不创建第二套 compact/Fredholm/index 定义；
- 不调用 `hasEigenvalue_or_mem_resolventSet` 伪装成教材证明；
- 不把 Exercise 4.5.13 的有限秩积分核实例收入理论窗口；
- 不在 index 稳定性和对偶紧致桥未冻结时提交最终定理；
- 本调查不修改正式源码、顶层 import、Registry、ROADMAP 或 RADAR。
