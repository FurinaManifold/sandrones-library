---
id: examples.settheory.quotients
kind: example
state: verified
title: 等价关系与商：模 5 同余类、商映射满射与「不同代表元同一商元素」的辨析
summary: 模 5 同余是 ℤ 上的 Setoid，7 与 2 显式判定同类、商映射满射；反例给出 ⟦7⟧ = ⟦2⟧ 而 7 ≠ 2，精确否定「商元素唯一决定代表元」
premises: [settheory.set.relations.equivalence-class-eq, settheory.set.relations.quotient-surj]
mathlib: [Int.ModEq, Int.modEq_iff_dvd, Quotient.eq, Quotient.sound, Quotient.exact, Quotient.mk_surjective, Setoid.ker, ZMod]
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

Roadmap E1.3 要求为「等价关系与商」给出可实际检查的例子：模 `n` 同余类与商映射、
**显式判定两个代表元同类**，以及「不同代表元可给同一商元素」的辨析。本 Entry 服务理论条目
`settheory.set.relations.equivalence-class-eq`（等价类相等 ⟺ 元素等价）与
`settheory.set.relations.quotient-surj`（商映射满射）：前者给出商集「钉合」的判定法，
后者保证商集没有多余元素。取 `n = 5` 作具体实例，把这两个抽象条目落到能算出余数的整数上。

# 直觉

- 商集就是把**等价**的元素钉成同一个点。模 5 同余把 `ℤ` 分成 5 个类：
  `…, -8, -3, 2, 7, 12, …` 是同一个类。
- 商映射 `π : z ↦ ⟦z⟧` 把每个整数送到它所在的类。它**满射**：每个类至少有一个代表元。
- 它一般**不单射**：同一个类有很多代表元。所以「商元素相等」比「代表元相等」粗——
  `⟦7⟧ = ⟦2⟧` 成立，而 `7 ≠ 2` 也成立，两者不矛盾。
- 单射失败不是 `Quotient.mk` 的缺陷，而是**关系**造成的：换成等号关系，商映射就是单射。

# 陈述（自然语言）

在 `ℤ` 上取模 5 同余关系 `a ≈ b ⟺ a % 5 = b % 5`：

1. `≈` 是等价关系（自反、对称、传递），因此定义了一个 `Setoid`（记作 `modFive`）。
2. 等价刻画：`a ≈ b ⟺ 5 ∣ b - a`。
3. 显式判定同类：`7 ≈ 2`（两者余数都是 2）；`-3 ≈ 2`（`-3 % 5 = 2`）；而 `7 ≉ 1`。
4. 等价类相等：`⟦a⟧ = ⟦b⟧ ⟺ a ≈ b`（理论条目 `equivalence-class-eq` 的实例）。
5. 商映射满射：`∀ q, ∃ z, ⟦z⟧ = q`（理论条目 `quotient-surj` 的实例）；
   具体地，`⟦7⟧` 还有一个不同的代表元 `2`。
6. **反例（辨析）**：`⟦7⟧ = ⟦2⟧ ∧ (7 : ℤ) ≠ 2`。
   前件「7 与 2 模 5 同类」**满足**；后件「7 与 2 相等」**不满足**。
   这精确否定命题「商元素相等 ⟹ 代表元相等」，等价地否定「商映射是单射」。
7. **对照（非反例）**：等号关系 `Setoid.ker id` 的商映射是单射。所以「非单射」的来源是
   等价关系把不同元素钉在一起，而不是商构造本身。
8. **反例（辨析）**：`<` 不是等价关系（自反性失败：`0 < 0` 为假），因此**不存在**以 `<`
   为 `≈` 的 `Setoid`。前件「`<` 是 `ℤ` 上的二元关系」满足，后件「它是等价关系／能充当
   商构造的等价关系」不满足。这否定「任何二元关系都能拿来作商」。
9. 同一现象在 mathlib 标准商环里的写法：`(7 : ZMod 5) = 2`。

# 陈述（Lean 对照）

```lean
def modFive : Setoid ℤ                       -- r a b := Int.ModEq 5 a b
theorem modFive_iff_emod (a b : ℤ) : modFive a b ↔ a % 5 = b % 5
theorem modFive_iff_dvd (a b : ℤ) : modFive a b ↔ (5 : ℤ) ∣ b - a

theorem seven_emod_five : (7 : ℤ) % 5 = 2
theorem seven_modFive_two : modFive 7 2
theorem neg_three_modFive_two : modFive (-3) 2
theorem seven_not_modFive_one : ¬ modFive 7 1

theorem quotient_mk_seven_eq_two :
    Quotient.mk modFive (7 : ℤ) = Quotient.mk modFive 2
theorem quotient_mk_eq_not_imp_eq :
    Quotient.mk modFive (7 : ℤ) = Quotient.mk modFive 2 ∧ (7 : ℤ) ≠ 2
theorem quotient_mk_not_injective : ¬ Function.Injective (Quotient.mk modFive)
theorem quotient_mk_eq_injective :
    Function.Injective (Quotient.mk (Setoid.ker (id : ℤ → ℤ)))

theorem quotient_mk_eq_iff (a b : ℤ) :
    Quotient.mk modFive a = Quotient.mk modFive b ↔ modFive a b
theorem quotient_mk_surjective : Function.Surjective (Quotient.mk modFive)
theorem exists_other_rep :
    ∃ z : ℤ, z ≠ 7 ∧ Quotient.mk modFive z = Quotient.mk modFive 7
theorem seven_eq_two_zmod_five : (7 : ZMod 5) = 2

theorem lt_not_equivalence : ¬ Equivalence (· < · : ℤ → ℤ → Prop)
theorem not_exists_setoid_lt : ¬ ∃ s : Setoid ℤ, ∀ a b : ℤ, s a b ↔ a < b
```

# 思维脉络

- **承载选择**：本版 mathlib 的 `Int.ModEq n a b` 定义为 `a % n = b % n`（不是 `n ∣ b - a`），
  三律是 `Int.ModEq.refl/symm/trans`，整除刻画是 `Int.modEq_iff_dvd`。`modFive` 是 `def`
  而不是 instance，因此 `modFive a b` 在命题层可 definitional 展开（`modFive_iff_emod` 的
  证明体就是 `Iff.rfl`），但 `simp`/`norm_num` **不会**自动展开它（结构投影不 reducible）——
  具体判定先 `rw [modFive_iff_emod]` 再 `norm_num`。
- **两条理论前提怎么用**：`quotient_mk_eq_iff` 直接实例化 `Quotient.eq`（即
  `equivalence-class-eq`）；`quotient_mk_surjective` 直接实例化 `Quotient.mk_surjective`
  （即 `quotient-surj`）。二者都是「引用型」正例，本 Entry 不重证理论。
- **反例的证法**：先由 `Quotient.sound seven_modFive_two` 得 `⟦7⟧ = ⟦2⟧`，再用 `norm_num`
  算 `(7 : ℤ) ≠ 2`；非单射由二者直接矛盾（把 `h : ⟦7⟧ = ⟦2⟧` 代进单射性即得 `7 = 2`）。
- **对照的证法**：等号关系的商映射单射，就是 `Quotient.exact` 本身——它把商元素相等还原成
  底层关系，而这里的底层关系恰是相等。
- **`<` 的反例**：`Setoid` 要求 `r` 自反。假设存在 `s` 且 `s a b ↔ a < b`，则 `s.refl 0`
  给出 `s 0 0`，经假设折成 `0 < 0`，与 `lt_irrefl` 矛盾。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 模 5 同余 | `Int.ModEq 5 a b`（`a % 5 = b % 5`） |
| 「模 5 同余」这个等价关系 | `modFive : Setoid ℤ` |
| `a` 与 `b` 同类 | `modFive a b` |
| `a` 的等价类（商元素） | `Quotient.mk modFive a` |
| 商映射 | `Quotient.mk modFive` |
| 等价类相等 ⟺ 同类 | `Quotient.eq` |
| 同类 ⟹ 商元素相等 | `Quotient.sound` |
| 商元素相等 ⟹ 同类 | `Quotient.exact` |
| 商映射满射 | `Quotient.mk_surjective` |
| 等号关系的商 | `Setoid.ker (id : ℤ → ℤ)` |
| 模 5 商环 | `ZMod 5` |

# 依赖（人话版）

- `settheory.set.relations.equivalence-class-eq`（`SandronesLibrary/SetTheory/Relations.lean`）：
  「`⟦x⟧ = ⟦y⟧ ↔ x ≈ y`」。本 Entry 的 `quotient_mk_eq_iff` 就是它的 `modFive` 实例；
  反例 6 的等式方向也由它（经 `Quotient.sound`）提供。
- `settheory.set.relations.quotient-surj`：商映射满射。本 Entry 的 `quotient_mk_surjective`
  直接实例化它，`exists_other_rep` 是它的一个具体见证。
- **mathlib 角色**：`Int.ModEq` 与 `Setoid`/`Quotient` 是语义一致的正式承载（本库直接复用，
  不另造包装）；`ZMod 5` 是同一商构造在环论中的标准实例，此处只作对照；本 Entry 不引入新的
  理论定义，只引入一个具体的 `Setoid` 实例与具体数值判定。

# 应用与陷阱

- **应用**：这是商集构造最小的可计算模型。实数用有理数柯西序列的等价类构造时，
  需要的就是「等价类相等 ⟺ 元素等价」与「商映射满射」这两条；模 5 的例子把同一机制
  缩小到能算出余数的整数上。`ZMod 5` 是它在环论里的同一个商。
- **陷阱 1（核心）**：商元素相等**不**决定代表元相等（反例 6）。`Quotient.exact` 给的是
  「同类」，不是「相等」；把 `⟦a⟧ = ⟦b⟧` 读成 `a = b` 是最常见的误用。
- **陷阱 2**：商映射满射是构造性的——`quotient_mk_surjective` 的 `#print axioms` 是零公理，
  不要因为「满射要选代表元」就以为它需要选择公理；这里代表元就是元素本身。
- **陷阱 3**：`ℤ` 上的 `%` 取**非负**余数（`-3 % 5 = 2`），与某些编程语言的截断余数不同；
  负代表元照样落进同一个类。
- **陷阱 4**：不是任何二元关系都能充当商构造的等价关系。`<` 缺自反性（反例 8），
  严格偏序、相容关系等都需要先补成等价关系才能取商。
- **诚实边界**：本 Entry 只把 `n = 5` 做成具体实例；「模任意 `n` 的同余是等价关系」这类
  一般性定理属于原学科，不在 Examples 里重证。
