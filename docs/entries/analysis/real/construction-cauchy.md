---
id: analysis.real.construction-cauchy
family: analysis.real
variant: ecnu
kind: theorem
state: verified
title: 实数构造（Cantor）
summary: 实数 = 有理柯西序列等价类；差趋于 0 是等价关系，商判等即差趋于 0；有理数可嵌入
premises: [settheory.set.relations.equivalence-class-eq, settheory.set.relations.quotient-surj]
mathlib: [CauSeq, CauSeq.equiv, CauSeq.Completion.mk, Real.ofCauchy]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第一章 实数（补：Cantor 构造）
---

# analysis.real.construction-cauchy

- **家族**: `analysis.real`
- **变体**: ecnu（华东师大《数学分析》第五版）；构造本体借力 mathlib 的 `CauSeq`。
- **状态**: verified
- **一句话**: 实数 = 有理柯西序列的等价类；"差序列趋于 0"是等价关系；
  两条序列给出同一实数 ⟺ 之差趋于 0；每个有理数给出常量柯西序列。

## 动机（为什么要这条）

教材直接给出"实数集"，说它是完备的。但"完备"从哪来？为什么有理数不够？
Cantor 的回答：**把有理数里"该收敛却没收敛"的所有序列补出来**。这是实数构造的
两条经典路线之一（另一条是 Dedekind 分割），也是 supply 确界原理的底层理由。
理解构造，才算真正"拥有"实数；后面数列极限的完备性定理（Cauchy 收敛准则）
都是这条结论的推论。

## 直觉

- 想逼近 √2：小数展开 1、1.4、1.41、1.414、… 是一串有理数。
  它们彼此"越来越近"，却没有任何有理数收敛到（有理数里没有极限）。
- 特征捕捉：**互相之间可以要多近有多近**的序列，就叫柯西序列。
- 但很多不同的柯西序列在逼近同一个数（1.4、1.40、1.400…）。
  给它们分类：差序列趋于 0 的归为一类。**每个类就是一个实数**。
- 这一步"归类"就是商集：把"相差趋于 0"做成等价关系即可。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 有理数的柯西序列 | `CauSeq ℚ (abs : ℚ → ℚ)` |
| f 与 g 之差趋于 0 | `CauSeq.LimZero (f - g)`（即 `f ≈ g`） |
| 由 f 给出的实数 | `Real.ofCauchy (CauSeq.Completion.mk f)` |
| 常量序列（有理数嵌入） | `CauSeq.const q` |

## 思维脉络

1. 等价关系三性质，难点在**传递性**：
   - 自反：和自身的差恒 0。
   - 对称：|a−b| = |b−a|。
   - 传递：|aₙ−cₙ| ≤ |aₙ−bₙ| + |bₙ−cₙ|。已知 |aₙ−bₙ|<ε/2 与 |bₙ−cₙ|<ε/2 对大的 n 成立，
     用三角不等式把两步"趋近"接力成一步，这是整条构造的灵魂。
2. 商判别准则：商里"两个类相等"⟺ "类代表之差趋于 0"。
   Lean 里 `Real.ofCauchy` 是构造壳、`CauSeq.Completion.mk` 是到商的投影，
   组合起来正好逐段展开成这条准则。
3. 嵌入：每个有理数 q 给出常量序列 (q, q, q, …)（显然柯西），其类记为 q 自己。
   Cantor 视角下"有理数 ⊂ 实数"就这么来。

## 依赖

- `settheory.set.relations`（等价关系/商集）
- （严格性由 mathlib 的 `CauSeq` 商构造承载）

## 应用与陷阱

- 这是"实数为什么完备"的构造性答案；第三章的 Cauchy 收敛准则、单调有界定理
  都能从这里推出。
- 别混淆两件事：柯西序列的**类**是实数；把"差趋于 0"做成等价关系才谈得上"类"。
  没有这套等价关系，序列之和、积无法良定义。
- 证明体是纯 ε-δ 的构造性写法，但 `#print axioms` 仍报 `Classical.choice`：
  来源是 `CauSeq.equiv` 实例（reducible 展开）带入的库内证明开销，不是本条目新增
  数学公理。详见 Playbook §3.9（严禁用投影 `.Rel` 伪装零公理）。

## 形式化层

```lean
theorem cau_equiv_refl (f : CauSeq ℚ (abs : ℚ → ℚ)) : f ≈ f := by
  intro ε hε
  refine ⟨0, ?_⟩  -- 一切的 j 都满足，取 i = 0 即可
  intro j hj
  simpa [sub_eq_add_neg] using hε   -- |f j - f j| = |0| = 0 < ε

theorem cau_equiv_symm {f g : CauSeq ℚ (abs : ℚ → ℚ)} (h : f ≈ g) : g ≈ f := by
  intro ε hε
  rcases h ε hε with ⟨i, hi⟩
  refine ⟨i, ?_⟩
  intro j hj
  simpa [abs_sub_comm] using hi j hj  -- |g j - f j| = |f j - g j|

theorem cau_equiv_trans {f g h : CauSeq ℚ (abs : ℚ → ℚ)}
    (hfg : f ≈ g) (hgh : g ≈ h) : f ≈ h := by
  intro ε hε
  rcases hfg (ε / 2) (half_pos hε) with ⟨i, hi⟩
  rcases hgh (ε / 2) (half_pos hε) with ⟨j, hj⟩
  refine ⟨max i j, ?_⟩
  intro k hk
  -- 三角不等式：|f − h| ≤ |f − g| + |g − h| < ε/2 + ε/2 = ε
  calc
    abs (f k - h k) = abs ((f k - g k) + (g k - h k)) := by ring_nf
    _ ≤ abs (f k - g k) + abs (g k - h k) := abs_add_le _ _
    _ < ε := by linarith

theorem real_eq_iff_cau_equiv {f g : CauSeq ℚ (abs : ℚ → ℚ)} :
    Real.ofCauchy (CauSeq.Completion.mk f) = Real.ofCauchy (CauSeq.Completion.mk g)
      ↔ CauSeq.LimZero (f - g) := by
  rw [Real.ofCauchy.injEq, CauSeq.Completion.mk_eq]

def rat_const_cauchy (q : ℚ) : CauSeq ℚ (abs : ℚ → ℚ) :=
  CauSeq.const (abv := (abs : ℚ → ℚ)) q
```

**公理依赖（#print axioms）**

```
cau_equiv_refl/symm/trans, real_eq_iff_cau_equiv, rat_const_cauchy 依赖:
[propext, Classical.choice, Quot.sound]
```

choice 有两个成分：
1. `CauSeq.equiv` 实例被 reducible 展开，带入库内 LimZero 证明的经典路径（**非本条目新增**；
   本条目证明体纯 ε-δ 构造，见 Playbook §3.9）；
2. 商构造与 ℝ 本身（`Real.ofCauchy` 走 `CauSeq.Completion`）携带的制造开销。
数学上 Cantor 构造本身对"验证等价关系"并不需要选择公理——是 mathlib 的实现路径带来报告。

## mathlib 参考

- `CauSeq`, `CauSeq.equiv`, `CauSeq.Completion.mk / ofRat`, `Real.ofCauchy`, `Real.cauchy`