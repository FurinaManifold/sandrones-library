# World Formula mathematical review: WF1-01 / 第一章

- fact cutoff: `3af0be230ac58fe27cdce1576eef972acbbd331c`
- author commit: `29ee105`
- reviewed file: `docs/world-formula/chapters/00-01-sets-relations-and-maps.md`
- mathematical reviewer: independent World Formula mathematical reviewer
- editorial reviewer: pending; not covered by this record
- reviewed at: 2026-08-26
- mathematical-round verdict: `accepted`
- whole-chapter status: remains `draft` until the independent editorial round and Main consistency review finish

## 审核范围与方法

本轮按 `docs/world-formula/REVIEW-PROTOCOL.md` 第一轮要求逐断言审核对象、量词、假设、方向、
事实地位、来源和误读边界。核验链包括：事实截止提交处的 `index/registry.json`，18 个 Entry 的
自然语言文档，实际 Lean 文件 `SetTheory/Set.lean`、`SetTheory/Function.lean`、
`SetTheory/Relations.lean`、`Analysis/Real.lean`、`Topology/Foundation.lean`，以及
`reference.bib` 中三个出版来源。版权与人物情景的原创性不作为本轮数学 verdict 的阻塞项。

## 逐断言审核表

| 章节行号／锚点 | 核验对象、量词、方向与地位 | 依据 | 评级与结论 |
|---|---|---|---|
| 30–46，§一 | 集合、关系、函数和商对象只作为全章路线概括；“函数受唯一性约束”在 §5.1 补全为对每个输入恰有一个输出；两个跨学科问题没有在此处宣称已经推出完整理论。 | `jech-set-theory-2003`；后续精确定义与边界 176–220、237–255、359–382 | 无 finding；通过 |
| 52–64，§2.1 | 对固定类型／论域 `X` 的子集 `A,B`，外延性写成对任意 `x : X` 的成员性双向等价，量词和双向方向与 Lean 完全一致。 | Entry `settheory.set.ext`；声明 `SetTheory.Set.set_ext` | 无 finding；通过 |
| 66–80，§2.1 | 元素 `x` 与单点集 `{x}` 的对象层级得到区分；档案类比明确说明加入日期、作者、版本后对象结构改变，未把类比当证明。 | 集合外延性；`jech-set-theory-2003` | 无 finding；通过 |
| 84–98，§2.2 | 子集定义是同一论域上的全称蕴含；允许相等，并明确否定逆向使用。真子集采用 `A ⊆ B` 加 `A ≠ B`，在本章固定论域语境下正确。 | Entry `settheory.set.subset.definition`；声明 `subset_iff_forall_mem` | 无 finding；通过 |
| 100–113，§2.2 | 传递性、双向包含推出相等、空集最小性三项的假设与方向均准确；空真解释没有虚构见证。 | Entries `settheory.set.subset.trans`、`settheory.set.subset.antisymm`、`settheory.set.empty-subset`；声明 `subset_trans`、`subset_antisymm`、`empty_subset` | 无 finding；通过 |
| 119–152，§3.1 | 并、交、补、差的逐元素解释均相对于固定论域；差集方向为 `A \ B = A ∩ Bᶜ`；交对并的分配律与命题逻辑对应准确。并交定义属于出版背景，分配律与差集恒等式有 verified Entry。 | Entries `settheory.set.operations.inter-distrib`、`settheory.set.operations.diff-inter-complement`；声明 `inter_distrib_left`、`diff_inter_complement`；`jech-set-theory-2003` | 无 finding；通过 |
| 156–170，§3.2 | 两条德摩根律方向正确。`¬(P ∨ Q) ↔ ¬P ∧ ¬Q` 可构造证明；`¬(P ∧ Q) → ¬P ∨ ¬Q` 的正向一般需经典逻辑。章节只区分证明原则，没有声称经典数学下第二式有例外。Registry 的公理审计也分别无／有 `Classical.choice`。 | Entries `settheory.set.operations.complement-union`、`settheory.set.operations.complement-inter`；声明 `complement_union`、`complement_inter`；Registry `axioms` | 无 finding；通过 |
| 176–190，§4.1 | 一般二元关系明确标为出版背景，并准确写成 `X × Y` 的子集；关系可非总、可多值。等价关系三性质的对象和量词正确。几何例只说明可能忽略的差别，没有把任一模糊“形状相同”冒充特定等价关系。 | `jech-set-theory-2003`；Lean `Setoid` 在后续两个商 Entry 中作为正式承载 | 无 finding；通过 |
| 194–224，§4.2 | 等价类、商集和自然投影的对象层级清楚；`[x]=[y] ↔ x∼y` 与 `Quotient.eq` 双向一致；投影只称满射，并明确一般不单射。下降到商所需的代表元相容性被正确列为额外条件，未冒充已核验 Entry。 | Entries `settheory.set.relations.equivalence-class-eq`、`settheory.set.relations.quotient-surj`；声明 `equivalence_class_eq`、`quotient_surjective`；`jech-set-theory-2003` | 无 finding；通过 |
| 226–231，§4.2 情景 | 三性质对应自反、对称、传递；“同柜不等于所有性质相同”和关系随研究问题改变，准确限制了类比强度。 | 等价关系定义；上述两个商 Entry | 无 finding；通过 |
| 237–255，§5.1 | 一般函数定义明确标为出版背景；总性与唯一性、定义域、陪域、像和复合的类型匹配均准确。陪域不同会影响满射性的判断，未偷换为“函数值自动决定陪域”。 | `jech-set-theory-2003`；Lean 函数类型与 `Function.comp` | 无 finding；通过 |
| 257–262，§5.1 情景 | 多个可行方案只给出一般关系；加上每个场地恰好一个方案才成为函数。该段没有把“选择规则”说成已证明存在，也没有暗示集合论选择公理。 | 函数出版背景定义 | 无 finding；通过 |
| 266–289，§5.2 | 单射、满射、双射量词正确；两个因子分别单射／满射推出复合同性质，证明顺序与 Lean 一致。反向边界也正确：复合单射只强迫内因子 `f` 单射，复合满射只强迫外因子 `g` 满射。反向说明被明确标为限制解释，而非对应 Entry 的新增结论。 | Entries `settheory.function.inj-comp`、`settheory.function.surj-comp`；声明 `injective_comp`、`surjective_comp` | 无 finding；通过 |
| 293–309，§5.3 | 同一个 `g : Y → X` 同时满足 `g(f(x))=x` 与 `f(g(y))=y`，与 Lean 的 `LeftInverse g f ∧ RightInverse g f` 一致。双射与双侧逆为充要关系；从双射组装逆函数的形式化路径确有 `Classical.choice` 审计依赖，章节也没有把实现依赖夸大为通常定理的额外数学假设。 | Entry `settheory.function.inject-surject.bijective-iff-inverse`；声明 `bijective_iff_inverse`；Registry `axioms = [Classical.choice]` | 无 finding；通过 |
| 315–331，§6.1 | 原像 `f⁻¹[B]` 的定义不要求逆函数；像集对象分别位于 `X` 与 `Y`，方向和符号边界准确。 | `jech-set-theory-2003`；Lean `Set.preimage`、`Set.image` | 无 finding；通过 |
| 335–353，§6.2 | 本章已核验的恰为二元并、二元交的原像等式；逐元素论证正确。像总保二元并、像一般不保交的对照数学上正确，并明确没有登记为本章 verified Entry。碰撞反例机制足以说明不保交。 | Entries `settheory.function.image-preimage.preimage-union`、`settheory.function.image-preimage.preimage-inter`；声明 `preimage_union`、`preimage_inter`；集合像的标准出版背景 | 无 finding；通过 |
| 359–365，§7.1 | `TopologicalSpace` 的开集公理和 `Continuous f ↔` 每个开集原像开均由实际声明承载。章节正确区分“所有函数的原像代数”与“原像还必须在源拓扑中开”的连续性条件。任意并和有限交的配合是标准出版背景推广，没有被列成两个二元原像 Entry 本身的精确陈述。 | Entry `topology.foundation.structure`；声明 `topologicalSpace_open_axioms`、`continuous_iff_preimage_open`；`munkres-topology-2000` | 无 finding；通过 |
| 367–372，§7.1 情景 | 情景只使用二元并交原像，并明确否定由此单独推出连续性；对象两端和拉回方向均无误。 | 两个原像 Entry；`continuous_iff_preimage_open` | 无 finding；通过 |
| 376–382，§7.2 | `analysis.real.construction-cauchy` 实际给出有理柯西序列的等价关系三性质、相等判据与常序列入口。章节谨慎称“构造入口”；商满射只用于“每个商点有代表序列”，没有扩张成“本章已证明每个实数的完备性”或“任意商自动带运算”。 | Entry `analysis.real.construction-cauchy`；声明 `cau_equiv_refl/symm/trans`、`real_eq_iff_cau_equiv`、`rat_const_cauchy`；两个商 Entry；`ecnu-mathematical-analysis-5` | 无 finding；通过 |
| 386–389，§7.3 | 商群、商环、商空间、同伦类仅作为出版背景路线；正文明确否认其已形式化地位，并补充结构下降必须验证相容性。 | `jech-set-theory-2003` 仅覆盖商语言；高阶结构在此未作为 verified 事实消费 | 无 finding；通过 |
| 393–404，§八 | 已核验范围与来源账 18 项一致；16 个基础 Entry 和两个下游均在事实截止 Registry 为 `verified`。一般关系、一般函数、具体等价类写法与形式化实现边界被分层陈述。 | 事实截止 Registry；18 个 Entry 文档和 Lean 声明 | 无 finding；通过 |
| 408–416，§九 | 九项否定边界与正文一致，准确排除了 ZF/ZFC 重建、完整关系理论、像保交、无条件逆函数、一般商下降、实数完备性、ROADMAP 未来状态和独立授课能力等误读。版权声明不参与本轮数学 verdict。 | 全章及来源账 | 无 finding；通过 |
| 424–441，§10.1 | 18 行 Entry 消费内容逐项与 Registry id、Lean 文件和声明对应；所有“没有扩大成什么”均与正文一致。事实截止状态为 18/18 `verified`。 | `index/registry.json`；18 个 `nl_file`；5 个 Lean 源文件 | 无 finding；通过 |
| 443–457，§10.1–10.3 | 三个 citation key 均存在且是合规出版书籍；研究候选与 ROADMAP future 没有伪装成 verified。唯一缺口是来源账只到书目 key，未给一般关系／函数／等价类定义在 Jech、拓扑观点在 Munkres、柯西构造在华东师大教材中的章节目次定位。 | `reference.bib`；Entry `provenance.ref`；来源账 | R3；见 F-01 |

## Findings

- **F-01 [R3 editorial] §10.2，448–452**：三个出版来源均真实、合规且 citation key 可解析，
  但来源账没有给出本章实际消费内容的章／节定位。由于相应数学陈述已由 Lean／Entry 或标准定义
  独立核实，这不构成 R1 来源不存在，也不改变数学 verdict；它会降低后续出版核查的可追溯性。
  依据：`reference.bib` 的 `jech-set-theory-2003`、`ecnu-mathematical-analysis-5`、
  `munkres-topology-2000`，以及 18 个 Entry 的 `provenance.ref`。验收：出版编辑或 Main 在不改
  数学陈述的前提下，为三类背景补章／节或页码范围，并与所用版本核对。

## 特别核验结论

1. **德摩根逻辑强度**：章节区分准确。第一条可构造证明；第二条从合取否定推出否定析取使用经典
   逻辑。Registry 中只有第二条记录 `Classical.choice`，与源码路径一致。
2. **复合定理的反向边界**：章节没有把“保持”写成等价。所列两条可逆方向恰好是正确的内因子
   单射／外因子满射结论。
3. **商对象层级**：具体等价类作为原集合子集与抽象商点得到明确区分；Lean Entry 使用的是
   `Quotient.mk` 商点，没有发生层级偷换。
4. **双射与选择**：左右逆量词要求同一个函数同时满足两式；经典选择仅作为当前形式化实现审计
   依赖披露，没有被误述为通常经典数学结论的附加假设。
5. **拓扑连接**：原像的集合代数没有被误写成连续性的充分条件；`Continuous` 的额外开集条件与
   `continuous_iff_preimage_open` 精确一致。
6. **柯西商连接**：正文只称“实数构造入口”，没有声称本 Entry 已独立构造完整实数结构或证明
   完备性；商映射满射也只用于商点代表元，不被扩大为未经证明的更强结论。

## Resolution

- F-01: `deferred (non-blocking R3)`；作者返工时复查了现有 `reference.bib`、18 个 Entry 文档及
  已登记书目信息，但这些材料不足以可靠确认三个版本的具体章、节或页码。本版明确不猜定位，并在
  章节 §10.2 登记延后理由；待出版编辑或 Main 取得并核对登记版本后再补。此项不改变本轮数学
  `accepted` verdict。版权风险按用户决定延后，不在本数学审核中建立 finding。

## Verdict

本轮逐断言数学审核为 **`accepted`**：没有 R1 factual 或 R2 structural finding，18 个 Entry 的
对象、量词、假设、方向和完成状态均与事实截止源码及 Registry 一致，出版背景与 verified 事实也
有明确分层。该 verdict 只完成第一轮数学审核；章节仍须保持 `draft`，不能据此跳过独立文字审稿和
Main 第三轮一致性验收。
