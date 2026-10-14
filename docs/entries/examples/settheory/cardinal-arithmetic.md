---
id: examples.settheory.cardinal-arithmetic
kind: example
state: verified
title: 有限基数加乘幂的计算与基数算术的两个反例
summary: 有限基数加、乘、幂的显式等势见证与真计算，可数集与有限集之并仍可数，以及「基数相等不等于集合相等」「无限基数加法没有自然数那样的消去律」两个精确反例
premises: [settheory.cardinal.addition, settheory.cardinal.multiplication, settheory.cardinal.exponentiation, settheory.cardinal.finite-set, settheory.cardinal.equinumerous, settheory.cardinal.countable-def]
mathlib: [finSumFinEquiv, finProdFinEquiv, finTwoArrowEquiv, Equiv.natSumNatEquivNat, Fintype.card_congr, Fintype.card_fin, Set.range, Set.countable_range, Set.finite_singleton, Set.Countable.union, Fin.elim0, Nat.add_sub_cancel]
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

`settheory.cardinal.addition`、`settheory.cardinal.multiplication`、`settheory.cardinal.exponentiation`
把基数加、乘、幂分别定义为不交并、笛卡尔积与函数空间的大小，`settheory.cardinal.finite-set`
把有限定义为与某个 `Fin n` 等势，`settheory.cardinal.countable-def` 把可数定义为可单射进 `ℕ`。
这些定义只有落回具体集合才可核对：`2 + 3` 到底是不是 `5`、`3 ^ 2` 到底是不是 `9`、
「可数 ∪ 有限」到底还可不可数。本 Entry 给出这组计算，并用两个 Lean 定理钉死两条最常被误用的推理。

# 直觉

- 不交并就是把两份元素并排摆好再数一遍：`Fin 2` 与 `Fin 3` 并排正好 `5` 个。
- 笛卡尔积是「先选第一个坐标、再选第二个坐标」，所以个数相乘：`2 × 3 = 6`。
- 函数空间是「每个位置独立选一个值」，所以个数取幂：`3 ^ 2 = 9`。
- 可数集丢掉或添上有限多个元素，仍然可数：编号方案只需挪一挪。
- 但基数只记录「有多少个」，不记录「是哪些」：两个集合基数相同完全可以是不同的集合。
- 无限基数还有更反直觉的一点：`ℵ₀ + ℵ₀ = ℵ₀`。加法不再让基数变大，自然数的消去律就随之失效。

# 陈述（自然语言）

1. 有限基数加法：`Fin 2 ⊕ Fin 3` 有 `5` 个元素，且与 `Fin 5` 等势。
2. 有限基数乘法：`Fin 2 × Fin 3` 有 `6` 个元素，且与 `Fin 6` 等势。
3. 有限基数幂：`Fin 2 → Fin 3` 有 `9` 个元素，且与 `Fin 9` 等势。
4. 可数 ∪ 有限：偶数集 `{0,2,4,…}` 与单点集 `{1}` 的并仍可数。
5. **反例一（基数相等不等于集合相等）**：集合 `A = {0,1}` 与 `B = {2,3}` 都与 `Fin 2` 等势，
   所以前件「`A` 与 `B` 基数相等」成立；但 `0 ∈ A` 而 `0 ∉ B`，后件「`A = B`」为假。
   这否定了「等势（基数相等）的两个集合相等」。
6. **反例二（无限基数算术不能照搬自然数消去律）**：取 `x = ℕ`、`y = ℕ`。
   前件「`x + y` 与 `x` 等势」成立（`ℕ ⊕ ℕ ≃ ℕ`，即 `ℵ₀ + ℵ₀ = ℵ₀`）；
   但后件「`y` 与 `0` 等势」为假（`ℕ` 非空，`Fin 0` 空）。
   因此在无限情形，从 `Equinumerous (CardinalSum x y) x` 推不出 `Equinumerous y (Fin 0)`。
7. **对照**：有限情形消去律仍然成立：`Fin 2 ⊕ Fin 3` 有 `5` 个元素，不与 `Fin 2` 等势。
   所以反例二的失效点确实是「无限」，不是「加法」本身。

# 陈述（Lean 对照）

```lean
-- 具体承载（本库定义）
abbrev TwoSumThree  : Type := CardinalSum (Fin 2) (Fin 3)      -- 基数加法 2 + 3
abbrev TwoProdThree : Type := CardinalProduct (Fin 2) (Fin 3)  -- 基数乘法 2 * 3
abbrev ThreePowTwo  : Type := CardinalPower (Fin 3) (Fin 2)    -- 基数幂 3 ^ 2

-- 定义展开
theorem twoSumThree_eq_sum   : TwoSumThree = (Fin 2 ⊕ Fin 3 : Type) := rfl
theorem twoProdThree_eq_prod : TwoProdThree = (Fin 2 × Fin 3 : Type) := rfl
theorem threePowTwo_eq_arrow : ThreePowTwo = (Fin 2 → Fin 3 : Type) := rfl

-- 真计算（decide 实际求值）
theorem card_twoSumThree  : Fintype.card (Fin 2 ⊕ Fin 3) = 5
theorem card_twoProdThree : Fintype.card (Fin 2 × Fin 3) = 6
theorem card_threePowTwo  : Fintype.card (Fin 2 → Fin 3) = 9

-- 显式等势见证
theorem equinumerous_twoSumThree_fin5  : Equinumerous TwoSumThree (Fin 5)
theorem equinumerous_twoProdThree_fin6 : Equinumerous TwoProdThree (Fin 6)
theorem equinumerous_threePowTwo_fin9  : Equinumerous ThreePowTwo (Fin 9)

-- 有限集实例（本库 FiniteByEnumeration）
theorem finiteByEnumeration_twoSumThree  : FiniteByEnumeration TwoSumThree
theorem finiteByEnumeration_twoProdThree : FiniteByEnumeration TwoProdThree
theorem finiteByEnumeration_threePowTwo  : FiniteByEnumeration ThreePowTwo

-- 可数 ∪ 有限
theorem countable_union_finite : (evenNats ∪ oneSet).Countable
theorem countable_union_finite_injection :
    ∃ f : ↥(evenNats ∪ oneSet) → ℕ, Function.Injective f

-- 反例一
theorem cardinal_equinumerous_not_set_eq :
    Equinumerous twoElemSet (Fin 2) ∧ Equinumerous twoElemSetShifted (Fin 2) ∧
      twoElemSet ≠ twoElemSetShifted

-- 反例二与对照
theorem infinite_addition_cancellation_fails :
    Equinumerous (CardinalSum ℕ ℕ) ℕ ∧ ¬ Equinumerous ℕ (Fin 0)
theorem finite_addition_cancellation_holds :
    ¬ Equinumerous (CardinalSum (Fin 2) (Fin 3)) (Fin 2)
```

上表只列了主线声明；下列辅助对象与见证同样属于本 Entry（命名对象 + 显式双射 + 实例）：

```lean
-- 反例一的命名对象与显式双射（{0,1}、{2,3} 到 Fin 2）
def twoElemSet : Set ℕ := Set.range (fun i : Fin 2 => (i : ℕ))
def twoElemSetShifted : Set ℕ := Set.range (fun i : Fin 2 => (i : ℕ) + 2)
def twoElemSetEquivFin2 : twoElemSet ≃ Fin 2
def twoElemSetShiftedEquivFin2 : twoElemSetShifted ≃ Fin 2
theorem twoElemSet_equinumerous_fin2 : Equinumerous twoElemSet (Fin 2)
theorem twoElemSetShifted_equinumerous_fin2 : Equinumerous twoElemSetShifted (Fin 2)
theorem finiteByEnumeration_twoElemSet : FiniteByEnumeration twoElemSet
theorem finiteByEnumeration_twoElemSetShifted : FiniteByEnumeration twoElemSetShifted

-- 可数 ∪ 有限的分解见证
def evenNats : Set ℕ := Set.range (fun k : ℕ => 2 * k)
def oneSet : Set ℕ := {1}
theorem evenNats_countable : evenNats.Countable
theorem oneSet_countable : oneSet.Countable

-- 反例二的等势见证
theorem equinumerous_natSumNat : Equinumerous (CardinalSum ℕ ℕ) ℕ
```

# 思维脉络

先把三个承载命名为 `TwoSumThree`／`TwoProdThree`／`ThreePowTwo`，再用 `rfl` 记录它们与
mathlib 原生 `⊕`、`×`、`→` 的定义对应——本库的 `CardinalSum`／`CardinalProduct`／`CardinalPower`
就是这三个构造的 `def`，所以等势见证可以直接引用 mathlib 的显式双射：
`finSumFinEquiv : Fin m ⊕ Fin n ≃ Fin (m + n)`、`finProdFinEquiv : Fin m × Fin n ≃ Fin (m * n)`，
而函数空间先经 `finTwoArrowEquiv : (Fin 2 → α) ≃ α × α` 拆成有序对、再经 `finProdFinEquiv` 编码。

有限基数计算用 `decide` 实际求值（不是抄公式）：`Fintype.card` 对 `Fin 2 ⊕ Fin 3`、`Fin 2 × Fin 3`、
`Fin 2 → Fin 3` 都是可计算的，编译器直接把结果算成 `5`、`6`、`9`。

反例一取 `A = {0,1}`、`B = {2,3}`，两者都由 `Fin 2` 的像给出，到 `Fin 2` 的双射分别是
「取元素本身」与「元素减二」；`A ≠ B` 则由 `0 ∈ A`、`0 ∉ B` 直接给出。
注意这里的「基数相等」被写成「两者都与 `Fin 2` 等势」——这正是本库对「基数相同」的定义展开，
而不是另造一个基数对象。

反例二用 mathlib 的 `Equiv.natSumNatEquivNat : ℕ ⊕ ℕ ≃ ℕ`（左副本编偶数、右副本编奇数）
给出 `ℵ₀ + ℵ₀ = ℵ₀`，再用 `Fin.elim0` 说明 `ℕ` 不可能与空类型等势。
对照定理 `finite_addition_cancellation_holds` 走另一条路：把等势 `Fin 2 ⊕ Fin 3 ≃ Fin 2`
与 `finSumFinEquiv` 复合得到 `Fin 5 ≃ Fin 2`，由 `Fintype.card_congr` 得 `5 = 2`，与算术矛盾。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 基数加法 `\|A\| + \|B\|` | `CardinalSum α β`（即 `α ⊕ β`） |
| 基数乘法 `\|A\| · \|B\|` | `CardinalProduct α β`（即 `α × β`） |
| 基数幂 `\|A\| ^ \|B\|` | `CardinalPower α β`（即 `β → α`） |
| 两个类型等势 | `Equinumerous α β`（`Nonempty (α ≃ β)`） |
| 有限（能与某个 `Fin n` 一一对应） | `FiniteByEnumeration α` |
| 可数（可单射进 `ℕ`） | `Countable α`，集合版 `s.Countable` |
| `{0,1}` | `twoElemSet = Set.range (fun i : Fin 2 => i.1)` |
| `{2,3}` | `twoElemSetShifted = Set.range (fun i : Fin 2 => i.1 + 2)` |
| 偶数集 | `evenNats = Set.range (fun k : ℕ => 2 * k)` |
| 空集（基数为 `0`） | `Fin 0` |

# 依赖（人话版）

- `settheory.cardinal.equinumerous`：全部等势陈述的语言；`Equinumerous` 就是「存在双射」。
- `settheory.cardinal.addition`／`multiplication`／`exponentiation`：三个承载
  `CardinalSum`／`CardinalProduct`／`CardinalPower` 的定义，本 Entry 只实例化、不重定义。
- `settheory.cardinal.finite-set`：`FiniteByEnumeration` 的定义，用来把三个承载登记为有限集。
- `settheory.cardinal.countable-def`：`Countable ↔ 可单射进 ℕ`，第 4 条正例的「定义展开」用的就是它。
- mathlib 只作为证明后端与显式双射来源（`finSumFinEquiv`、`finProdFinEquiv`、`finTwoArrowEquiv`、
  `Equiv.natSumNatEquivNat`）；本 Entry 不新增基数对象。

# 应用与陷阱

- **应用**：这套「命名承载 → 定义展开 → 等势见证 → 真计算」的骨架可直接复用到任何
  「教材定义 + 具体有限对象」的组合；`decide` 求值也是检查 `Fintype` 实例是否真的可计算的廉价探针。
- **陷阱一**：基数相等（等势）**不是**集合相等。`cardinal_equinumerous_not_set_eq` 给出的是
  满足前件、否定后件的精确反例；`{0,1}` 与 `{2,3}` 之间甚至存在明显的双射（加二），
  但两个集合没有公共元素。
- **陷阱二**：不要把自然数的消去律搬到无限基数上。`x + y = x` 在有限情形迫使 `y = 0`
  （`finite_addition_cancellation_holds`），但在 `x = ℕ` 时 `y = ℕ` 也满足等式。
  使用消去律前必须先确认相关基数是有限的。
- **陷阱三**：`Fintype.card` 只对配有 `Fintype` 实例的类型可计算。本库的
  `CardinalSum` 是普通 `def`，实例合成不会自动展开它；因此真计算写在定义展开后的
  `Fin 2 ⊕ Fin 3` 上，而载体一侧用 `Equinumerous` 陈述。这不是回避，而是把「基数的两种读法」
  分开：`Fintype.card` 给数值，`Equinumerous` 给本库教材定义。
