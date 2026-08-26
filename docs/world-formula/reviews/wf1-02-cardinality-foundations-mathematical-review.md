# World Formula mathematical review: WF1-02 / 第二章第 1–4 节

- fact cutoff: `7004e154355e65e10533fe3f80281f8671e7147b`
- author commit: `3fb0887f776767e0135c961870345c6f4a068fba`
- revision commit: `2090fc0466320d644da408b33751bfd144ac6833`
- reviewed file: `docs/world-formula/chapters/00-02-finite-countable-uncountable.md`
- mathematical reviewer: independent World Formula mathematical reviewer
- editorial reviewer: pending; not covered by this record
- reviewed at: 2026-08-26
- mathematical-round verdict: `accepted`
- whole-chapter status: remains `draft`

## 审核范围与事实链

本轮按 `docs/world-formula/REVIEW-PROTOCOL.md` 第一轮逐断言检查对象、量词、假设、函数方向、
事实地位、来源和误读边界。核验对象为四个 verified Entry：
`settheory.cardinal.equinumerous`、`settheory.cardinal.comparison`、
`settheory.cardinal.finite-set`、`settheory.cardinal.countable-def`；对应声明为
`Equinumerous`、`equinumerous_iff_exists_bijective`、`CardinalLE`、
`equinumerous_implies_both_le`、`cardinalLE_refl`、`cardinalLE_trans`、
`FiniteByEnumeration`、`finiteByEnumeration_has_finite_bound` 与
`countable_iff_injective_nat`。同时核对事实截止处 Registry、四份 Entry 文档、
`reference.bib` 的 `jech-set-theory-2003` 及前驱章节链接。

事实截止 `7004e15` 是当前章节作者提交的祖先；四个 id 在该截止均为 `verified`，Lean 文件和
Entry 文档路径可解析。作者提交相对事实截止只新增本章草稿，没有改动底层数学资产。

## 逐断言审核表

| 章节行号／锚点 | 核验对象、量词、方向与地位 | 依据 | 评级与结论 |
|---|---|---|---|
| 3–22，章首元信息 | 明确只完成第 1–4 节，列出的四个 Entry 与事实截止 Registry 一致；前驱章节链接有效，出版 key 可解析。 | 截止 `7004e15` 的 Registry；`reference.bib`；前驱文件 | 通过 |
| 26–28，§一开头 | “集合没有最后一个元素”没有先给集合配备次序；即使有次序，“没有最后一个”也不是这四个 Entry 给出的有限性判据。该句把计数直觉写成一般集合论理由。 | `FiniteByEnumeration α := ∃ n, Equinumerous α (Fin n)` | **R1**；见 F-01 |
| 30–45，等势定义 | 对象是类型 `A,B`；函数方向 `A → B`，并同时要求单射与满射。`A∼B` 没有被写成类型相等或通用等价关系记号。 | `Equinumerous`；`equinumerous_iff_exists_bijective` | 通过 |
| 47–64，人物场景与类比边界 | 六对样本准确表现有限双射；正文明确否定等势自动保存温度、来源、次序、运算或拓扑结构。类比只承载数量，不冒充群同构或同胚。 | `Equinumerous` 的对象层级；handoff 候选 A | 通过 |
| 66–71，自然数与偶数 | `n ↦ 2n` 确可给出 `ℕ` 与偶数子类型的双射，从而得到与真子集等势；但四个 Entry 只提供等势概念和一般展开，没有核验这个具体双射。正文的“本节核验来源”未把该例标为出版背景／直接构造。 | `Equinumerous`；`equinumerous_iff_exists_bijective`；`jech-set-theory-2003` | **R1 status/source**；见 F-02 |
| 75–92，基数不大于 | 单射方向严格为 `A → B`，准确表达 `A` 不大于 `B`；没有误用普通函数或满射。 | `CardinalLE` | 通过 |
| 94–107，自反、传递、双向比较 | 恒等函数、自反性和单射复合的论证方向正确；等势通过双射及其逆给出双向单射。正文明确留下双向单射到等势的缺口，没有暗示未覆盖的反对称性。 | `cardinalLE_refl`；`cardinalLE_trans`；`equinumerous_implies_both_le` | 通过；特别确认未偷用 `cardinalLE_antisymm`／Cantor–Bernstein |
| 109–115，包含与比较 | 在共同论域中，子集包含给出包含单射；一般单射不要求来源本来是目标的子集。对象和方向准确。 | `CardinalLE`；标准包含映射 | 通过 |
| 119–135，`Fin n` 与有限枚举 | `Fin n` 被正确解释为编号 `0` 至 `n-1` 的标准 `n` 元类型；量词为存在 `n : ℕ`，且要求与 `Fin n` 等势。 | `FiniteByEnumeration` | 通过 |
| 137–139，`Fin 0` 与末编号 | `Fin 0` 为空类型、`Fin n` 在 `n>0` 时最大值为 `n-1` 均正确；但从“空类型”直接写成“空集”混合了类型与集合对象层级。 | Lean `Fin`；本章一直以类型 `A` 为承载 | **R2**；见 F-03 |
| 141–149，有限单射界 | 从等势忘掉满射信息得到 `A → Fin n` 的单射，方向与公开定理一致；正文没有宣称反向。 | `finiteByEnumeration_has_finite_bound` | 通过 |
| 151–156，有限性边界 | 准确排除 `n` 唯一性以及与 mathlib `Finite`／`Fintype` 的完整互换；没有把四 Entry 之外接口写成已验收。 | `finite-set` Entry 与公开声明 | 通过 |
| 160–175，可数判据与方向 | `A → ℕ` 的单射方向准确；不要求满射。反向单射 `ℕ → A` 只给下界，不能推出可数，边界正确。 | `countable_iff_injective_nat` | 通过，但 160 行再次使用未定义的“最后一个元素”；归入 F-01 |
| 163、182–184，`Countable` 的正式地位 | 数学上准确陈述 `Countable A ↔ ∃` 单射 `A → ℕ`。Lean 中 `Countable A` 是 mathlib 的 Prop-valued typeclass，公开 Entry 是其等价刻画，不是本库另建的定义；正文称“判据／等价刻画”是准确措辞，但尚未披露 typeclass 承载。 | `countable_iff_injective_nat`；mathlib `Countable` | **R2 disclosure**；见 F-04 |
| 177–180，`ℕ` 可数但非有限 | 恒等映射足以由本 Entry 得出 `Countable ℕ`；但“没有最后一个自然数，因此非有限”需要标准次序及有限非空线序有最大元等额外事实，不能由四个 Entry 单独推出。 | `countable_iff_injective_nat`；四 Entry 无 `¬ FiniteByEnumeration ℕ` 定理 | **R1**；见 F-01 |
| 182–190，未覆盖范围 | 有理数可数、可数并、Cantor–Bernstein、幂集严格增大和实数不可数均明确留到后半章；章名中的“不可数”没有冒充已定义或已证明。 | 章节边界；handoff 下一小批范围 | 通过 |

## Findings

- **F-01 [R1 factual/status] 26–28、160、177–180**：正文反复以“没有最后一个元素”刻画无穷，
  最后又用“`ℕ` 没有最后一个自然数”直接推出其非有限。一般集合没有内在的“最后一个”概念；在
  `ℕ` 上补入标准次序后，该反证还需要“有限非空线序有最大元”或直接证明
  `¬ FiniteByEnumeration ℕ`，而四个消费 Entry 均未提供。数学结论 `ℕ` 非有限当然正确，问题在于
  当前论证与核验地位超出来源。验收：把开头与 160 行改成不依赖末项的枚举动机；177–180 行或者
  删除非有限证明，或者明确标为出版背景并补足所用次序定理／合规定位，不再声称由四 Entry 核验。

- **F-02 [R1 status/source] 66–71**：自然数与偶数等势的具体事实正确，但
  `settheory.cardinal.equinumerous` 只核验等势定义和“双射 iff 单射且满射”，没有该具体实例。
  验收：明确说明 `n ↦ 2n` 是本章直接验证或 `jech-set-theory-2003` 的出版背景例，并把目标对象写成
  偶数子类型／偶数集合；不要让“本节核验来源”暗示它已有独立 Lean 结论。

- **F-03 [R2 structural] 137–139**：本章及 Lean 定义的对象是类型，`Fin 0` 是空类型；“所以空集
  同样有限”跳到了集合对象。结论可通过空集的子类型恢复，但该承载未说明。验收：改为“空类型同样
  可由有限枚举”，或显式说明一个集合按其元素子类型讨论有限性。

- **F-04 [R2 structural/disclosure] 163、182–184**：正文对可数性的数学判据没有写错，但核心正式
  承载只写成裸 `Countable A`，未说明它是 mathlib 的 Prop-valued typeclass；本 Entry 是公开等价
  刻画，而非本库新定义。验收：以一句自然语言补足这一承载和“刻画而非新定义”的边界，无需展示
  Lean 代码或 API 清单。

## 特别核验结论

1. **函数方向**：等势用 `A → B` 的双射；比较用 `A → B` 的单射；可数用 `A → ℕ` 的单射。
   三处方向均正确，且可数段明确否定了用 `ℕ → A` 判可数。
2. **比较反对称**：正文只消费自反、传递和“等势推出双向比较”，并明确说明逆向需要后续定理；
   没有把双向单射说成互逆，也没有把等势写成 Lean 类型相等。
3. **`Fin n`**：定义、`n=0`、元素数及 `n>0` 时最大编号均正确；唯一问题是空类型／空集层级滑移。
4. **`Countable`**：自然语言 iff 与 Lean 定理一致；其准确 Lean 地位是 Prop-valued typeclass，
   `countable_iff_injective_nat` 是可操作刻画。
5. **场景边界**：人物情景只说明有限双射和标签无关性，并明确否定保存额外结构；没有数学误导。
6. **事实截止与链接**：`7004e15` 可解析且为作者提交祖先；四 Entry 在截止均 verified；前驱章节、
   四份 Entry 文档和 `jech-set-theory-2003` 均可解析。书目只给版本级元数据，未给本章所用具体
   章／节定位；本轮阻塞问题已由 F-01/F-02 的来源地位覆盖，禁止猜测页码。

## Resolution

- F-01: `resolved` in `2090fc0`。§一开头改为“尚未找到有限枚举时不能预设有限性”；§四不再使用
  “集合没有最后一个元素”。`ℕ` 非有限被明确标为通常集合论出版背景，并明确否认由“没有最后一个
  自然数”或本小批四 Entry 推导。原先遗漏的次序结构和形式化地位问题均已消除。
- F-02: `resolved` in `2090fc0`。正文显式定义偶数集合
  `E = {m ∈ ℕ : m 为偶数}`，说明 `n ↦ 2n` 可直接检查为 `ℕ → E` 的双射，并明确标作出版背景标准例、
  不是本节 Entry 新核验的独立结论。
- F-03: `resolved` in `2090fc0`。正文先称 `Fin 0` 为标准空类型，再把空集按成员类型承载，明确说明
  类型与集合没有被直接视为同一对象。
- F-04: `resolved` in `2090fc0`。正文准确披露 `Countable A` 是 mathlib 已有的 Prop-valued typeclass，
  并说明本 Entry 给出可操作等价刻画而非新定义。

## Round 2 re-review

只读复验 revision commit `2090fc0` 相对作者原提交 `3fb0887` 的章节 diff。该提交只修改目标章节，
逐项处理 F-01 至 F-04；没有改动事实截止、四个 Entry、Lean 源码或出版来源。修订后：

- 有限枚举动机不再依赖未定义的“最后一个元素”；
- `ℕ` 与偶数的具体双射具有明确对象、直接检查地位与非 Lean 核验边界；
- `Fin 0` 的空类型承载与空集成员类型得到区分；
- `Countable` 的 typeclass 地位和 Entry 的“等价刻画”角色得到披露。

复查其余受改段落，函数方向、量词、Cantor–Bernstein 缺口、有限单射界方向与人物场景边界均保持
原审核通过状态，未发现新的 R1、R2 或 R3 finding。

## Verdict

对 revision commit `2090fc0` 的复验 verdict 为 **`accepted`**。F-01 至 F-04 全部 `resolved`，且
未发现新的 R1、R2 或 R3 finding。该 verdict 完成数学第一轮及其返工复验；章节仍为 draft，独立
文字审稿与 Main 一致性验收仍未完成。
