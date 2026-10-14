---
id: examples.settheory.countability
kind: example
state: verified
title: 可数性：ℕ×ℕ 配对、整数枚举与「无限不必不可数」的辨析
summary: Nat.pair 的显式配对与真值、ℤ 的显式枚举及其单射、偶数∪奇数与 ℤ = ⋃{-n,n} 两个可数并实例，以及「ℕ 无限却可数」「Fin 3 幂集 2³ = 8 > 3」两条反例
premises: [settheory.cardinal.countable-def, settheory.cardinal.countable-union, settheory.cardinal.uncountable-real]
mathlib: [Nat.pair, Nat.unpair, Nat.pair_unpair, Nat.unpair_pair, Nat.pair_eq_pair, Nat.pairEquiv, Equiv.countable_iff, Set.countable_range, Set.Countable.union, Set.countable_univ, Set.countable_univ_iff, Set.countable_iUnion, Set.infinite_univ, Fintype.card_fun, Fintype.card_le_of_surjective, Fintype.card_le_of_injective, Finset.card_powerset, Int.toNat_of_nonneg]
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

Roadmap E1.4 要求为「可数性」给出可实际计算的例子：`ℕ×ℕ` 配对、整数枚举、两个可数集之并，
以及两条反例——「无限集不必不可数」与「幂集严格更大」的有限原型。本 Entry 服务理论条目
`settheory.cardinal.countable-def`（可数 ⟺ 可嵌入 `ℕ`）、`settheory.cardinal.countable-union`
（可数个可数集之并可数）与 `settheory.cardinal.uncountable-real`（`ℝ` 不可数）。可数性的抽象
定义落回具体集合时需要能算的编号：配对把 `(2,3)` 编成几号、`-4` 是第几号、偶数与奇数怎么
拼成整个 `ℕ`。本 Entry 给出这组计算与辨析。

# 直觉

- **可数 = 能编号**：给集合的每个元素发一个互不相同的自然数号码（单射），就说明它可数。
- **`ℕ×ℕ` 用配对折成一条线**：Cantor 配对把数对 `(a,b)` 编码成一个自然数，于是平面的
  格点可以排成一列——「两个 `ℕ` 不比一个 `ℕ` 大」。
- **`ℤ` 用奇偶分工编号**：非负整数发偶数号码（`z ↦ 2z`），负整数发奇数号码
  （`z ↦ -2z-1`）。两半互不重叠，合起来正好是 `ℕ`。
- **可数集之并仍可数**：把「第 `n` 层」的元素排到位置 `n` 上，再用配对把层号与层内号
  折成一个自然数。
- **无限 ≠ 不可数**：`ℕ` 无限且可数，所以「无限 ⟹ 不可数」是假的；`ℝ` 才是那个
  无限但不可数的例子。幂集则提供了「严格更大」的有限原型：`Fin 3` 只有 3 个元素，
  它的幂集却有 `2³ = 8` 个。

# 陈述（自然语言）

1. **配对**：`Nat.pair` 把 `(a,b)` 编码成一个自然数，`Nat.unpair` 解回数对；
   `Nat.pairEquiv : ℕ × ℕ ≃ ℕ` 是双射。真计算：`Nat.pair 2 3 = 11`、
   `Nat.unpair 11 = (2,3)`。配对是单射；因此 `ℕ × ℕ` 可数。
2. **整数枚举**：`intToNat z = if 0 ≤ z then 2z else -2z-1`。真计算：`intToNat 0 = 0`、
   `intToNat 3 = 6`、`intToNat (-1) = 1`、`intToNat (-4) = 7`。
   `intToNat` 是单射；因此（经 `countable-def`）`ℤ` 可数。
3. **两个可数集之并（具体实例一）**：`evens`（`2k` 的像）与 `odds`（`2k+1` 的像）都可数，
   且 `evens ∪ odds = ℕ`；所以 `ℕ` 可数。真计算：`4 ∈ evens`（见证 `k = 2`）、
   `5 ∈ odds`（见证 `k = 2`）、`1 ∉ evens`。
4. **可数并（具体实例二）**：`ℤ = ⋃ n : ℕ, {-n, n}`。每层 `{-n,n}` 是二元集故可数，
   指标集 `ℕ` 可数，由 `countable-union` 得 `ℤ` 可数。
5. **反例 1（无限不必不可数）**：`ℕ`（全集）**满足**前件「无限」且**满足**「可数」，
   于是命题「无限 ⟹ 不可数」（形式化为 `∀ s : Set ℕ, s.Infinite → ¬ s.Countable`）为假。
   这是对「无限集一定不可数」这一错误命题的精确否定。
6. **辨析（无限与不可数的差别）**：`ℕ` 与 `ℝ` 都无限，但 `ℕ` 可数、`ℝ` 不可数
   （后者由理论条目 `uncountable-real`）。「无限」只否定有限，比「不可数」弱。
7. **反例 2（幂集严格更大的有限原型）**：`Fin 3` 的幂集（用特征函数 `Fin 3 → Bool` 表示）
   有 `2³ = 8` 个元素，而 `Fin 3` 只有 3 个，故 `8 > 3`。
   前件「`f : Fin 3 → 幂集` 是映射」**满足**，后件「`f` 满射」**不可能满足**：
   不存在满射；对称地，也不存在从幂集到 `Fin 3` 的单射。这精确演示「幂集严格更大」。
8. **真计算（子集枚举）**：`Fin 3` 的全部子集确实有 8 个（`Finset.univ.powerset` 的势），
   `{0,2}` 是其中之一。

# 陈述（Lean 对照）

```lean
-- 配对
theorem pair_two_three : Nat.pair 2 3 = 11
theorem unpair_eleven : Nat.unpair 11 = (2, 3)
theorem pairEquiv_symm_eleven : Nat.pairEquiv.symm 11 = (2, 3)
theorem pair_injective : Function.Injective (fun p : ℕ × ℕ => Nat.pair p.1 p.2)
theorem countable_prod_nat : Countable (ℕ × ℕ)

-- 整数枚举
def intToNat (z : ℤ) : ℕ := if 0 ≤ z then z.toNat * 2 else (-z).toNat * 2 - 1
theorem intToNat_of_nonneg {z : ℤ} (hz : 0 ≤ z) : intToNat z = z.toNat * 2
theorem intToNat_of_neg {z : ℤ} (hz : ¬ 0 ≤ z) : intToNat z = (-z).toNat * 2 - 1
theorem intToNat_zero : intToNat 0 = 0
theorem intToNat_three : intToNat 3 = 6
theorem intToNat_neg_one : intToNat (-1) = 1
theorem intToNat_neg_four : intToNat (-4) = 7
theorem intToNat_injective : Function.Injective intToNat
theorem exists_injective_int_nat : ∃ f : ℤ → ℕ, Function.Injective f
theorem countable_int_of_enumeration : Countable ℤ

-- 两个可数集之并
def evens : Set ℕ := Set.range fun k : ℕ => 2 * k
def odds : Set ℕ := Set.range fun k : ℕ => 2 * k + 1
theorem four_mem_evens : 4 ∈ evens
theorem five_mem_odds : 5 ∈ odds
theorem one_not_mem_evens : 1 ∉ evens
theorem evens_union_odds : evens ∪ odds = Set.univ
theorem countable_evens : evens.Countable
theorem countable_odds : odds.Countable
theorem countable_evens_union_odds : (evens ∪ odds).Countable
theorem countable_nat_univ : (Set.univ : Set ℕ).Countable

-- 可数并：ℤ = ⋃ n, {-n, n}
def intHalves (n : ℕ) : Set ℤ := ({-(n : ℤ), (n : ℤ)} : Set ℤ)
theorem int_univ_eq_iUnion : (Set.univ : Set ℤ) = ⋃ n : ℕ, intHalves n
theorem countable_intHalves (n : ℕ) : (intHalves n).Countable
theorem countable_int_univ : (Set.univ : Set ℤ).Countable
theorem countable_int : Countable ℤ

-- 反例：无限不必不可数
theorem infinite_nat_univ : (Set.univ : Set ℕ).Infinite
theorem infinite_not_imp_uncountable :
    ¬ (∀ s : Set ℕ, s.Infinite → ¬ s.Countable)
theorem nat_real_infinite_contrast :
    (Set.univ : Set ℕ).Infinite ∧ (Set.univ : Set ℕ).Countable ∧
      (Set.univ : Set ℝ).Infinite ∧ ¬ (Set.univ : Set ℝ).Countable

-- 反例：幂集严格更大的有限原型
theorem card_powerset_fin_three : Fintype.card (Fin 3 → Bool) = 8
theorem card_fin_three_lt_powerset : Fintype.card (Fin 3) < Fintype.card (Fin 3 → Bool)
theorem card_finset_powerset_fin_three :
    (Finset.univ.powerset : Finset (Finset (Fin 3))).card = 8
theorem subset_zero_two_mem : ({0, 2} : Finset (Fin 3)) ∈ Finset.univ.powerset
theorem no_surjection_fin_three_powerset :
    ¬ ∃ f : Fin 3 → (Fin 3 → Bool), Function.Surjective f
theorem no_injection_powerset_fin_three :
    ¬ ∃ g : (Fin 3 → Bool) → Fin 3, Function.Injective g
```

# 思维脉络

- **配对的承载**：mathlib 已有 `Nat.pairEquiv : ℕ × ℕ ≃ ℕ`（`pair` 用平方根公式实现），
  本 Entry **直接复用**而不另造包装；真值计算用 `decide`，而 `Nat.unpair 11 = (2,3)` 不能
  `decide`（归约会卡在 `Nat.sqrt`），改走 `← pair_two_three` 再 `Nat.unpair_pair` 的改写链。
- **整数枚举的单射**：按 `0 ≤ z`、`0 ≤ w` 分四支。两支同号时用 `Int.toNat_of_nonneg` 把
  `toNat` 折回整数，再 `omega`；两支异号时用「非负支给偶数 `2m`、负支给奇数 `2m-1`
  （`m ≥ 1`）」直接矛盾。枚举的构造意图就是让两支的像分居偶、奇两半。
- **`Int.toNat` 的坑**：它是 `@[implicit_reducible]` 的 match 定义，`norm_num` 不归约它，
  而 `decide` 可以（`intToNat 3 = 6`、`intToNat (-4) = 7` 的收尾因此用 `decide`）。
- **并集**：`evens`/`odds` 都定义为 `Set.range`，可数性直接来自 `Set.countable_range`；
  `evens ∪ odds = ℕ` 用 `Nat.even_or_odd` 分情况（偶支 `n = k+k` 折成 `n = 2k`，
  奇支直接取 `Odd` 的见证）。
- **`ℤ` 的可数并**：把每个整数按符号送进第 `n = |z|` 层。非负取 `n = z.toNat`、
  负取 `n = (-z).toNat`；每层是 `insert` 出来的二元集，用 `Set.Finite.countable`；
  最后套理论条目 `countable_iUnion`。
- **幂集原型**：`Fin 3 → Bool` 是 `Set (Fin 3)` 的特征函数表示（有限情形二者一一对应），
  `Fintype.card_fun` 给 `2³ = 8`。无满射由 `Fintype.card_le_of_surjective` 得 `8 ≤ 3`，
  与 `norm_num` 矛盾；无单射对称地用 `Fintype.card_le_of_injective`。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| Cantor 配对 | `Nat.pair a b` / `Nat.unpair n` |
| 配对双射 | `Nat.pairEquiv : ℕ × ℕ ≃ ℕ` |
| 配对是单射 | `Function.Injective (fun p : ℕ × ℕ => Nat.pair p.1 p.2)` |
| 整数枚举 | `intToNat : ℤ → ℕ` |
| 「可数 ⟺ 存在到 `ℕ` 的单射」 | `SandronesLibrary.SetTheory.Cardinal.countable_iff_injective_nat` |
| 偶数集 / 奇数集 | `evens` / `odds`（`Set.range`） |
| 可数集 | `Set.Countable`（`s.Countable`） |
| 两个可数集之并 | `Set.Countable.union` |
| 可数个可数集之并 | `SandronesLibrary.SetTheory.Cardinal.countable_iUnion` |
| 无限集 | `Set.Infinite`（`Set.infinite_univ`） |
| 幂集（有限原型） | `Fin 3 → Bool` |
| 有限势 | `Fintype.card`、`Finset.card_powerset` |

# 依赖（人话版）

- `settheory.cardinal.countable-def`：本 Entry 的 `countable_int_of_enumeration` 用它把
  `intToNat` 的单射性翻译成 `Countable ℤ`；`exists_injective_int_nat` 是它的显式见证。
- `settheory.cardinal.countable-union`：本 Entry 的 `countable_int_univ` 直接实例化它
  （`ℤ = ⋃ n, {-n, n}`）；`countable_evens_union_odds` 是二元情形的另一条路径
  （mathlib 的 `Set.Countable.union`）。
- `settheory.cardinal.uncountable-real`：辨析 6 用它给出「无限但不可数」的对照。
- **mathlib 角色**：`Nat.pairEquiv` 是配对的正式承载（本库复用，不另造包装）；
  `Set.Countable` 系列是「集合可数」的正式承载；`Fintype.card_*` 是有限势的正式承载。
  本 Entry 新增的命名对象只有具体枚举与具体集合（`intToNat`、`evens`、`odds`、`intHalves`）。

# 应用与陷阱

- **应用**：`ℕ×ℕ` 配对是可数性几乎所有证明背后的同一编码——可数并（本 Entry 实例二）、
  有理数可数（理论条目 `countable-rat`）都靠它把两个自然数折成一个。整数枚举则给出
  「`ℤ` 与 `ℕ` 等势」的最直观编号方案。
- **陷阱 1**：**无限 ≠ 不可数**（反例 1）。「无限」只排除有限；`ℕ` 就是无限可数的例子。
  把「无限集」直接当成「不可数集」会让「可数并」「可数笛卡尔积」一类结论失去前提检查。
- **陷阱 2**：本 Entry 证的是 `intToNat` 的**单射**（这正是 `countable-def` 要求的
  「可嵌入 `ℕ`」），并据此得到 `Countable ℤ`；**没有**构造显式的双射 `ℤ ≃ ℕ`
  或证明 `intToNat` 满射。若后续需要「枚举不漏」，那是一条更强的结论，不在本 Entry。
- **陷阱 3**：`ℕ×ℕ` 可数**不**意味着任意乘积可数——`ℝ × ℕ` 就不可数。配对只处理两个
  `ℕ` 的情形；可数并/可数积的一般定理需要额外前提（指标集可数、每层可数）。
- **陷阱 4**：`Fin 3` 的幂集原型只演示 `2³ = 8 > 3`，是 Cantor 定理的**有限原型**，
  不是 Cantor 定理本身；一般情形的对角论证属于理论学科。
- **陷阱 5**：`Fintype.card (Fin 3 → Bool)` 里的 `Bool` 是「可判定子集」的表示，
  与 `Set (Fin 3)`（`Prop` 值函数）在有限情形一一对应；无穷集合上没有这种可判定性。
- **陷阱 6**：`intToNat` 的偶数/奇数分工依赖 `0 ≤ z` 这个二分；若把 `ℤ` 的 `%` 当成
  截断余数（见 `examples.settheory.quotients` 的陷阱 3），枚举的奇偶分工就会对不上。
