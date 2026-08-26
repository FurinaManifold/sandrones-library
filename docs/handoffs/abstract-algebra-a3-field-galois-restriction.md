# 抽象代数 A3.9c：Galois restriction 与商群批次交接

## 范围与依赖

本批在已完成的 Galois 对应、次数—指数和正规性模块之上，构造正规子群
固定域的真实限制同态，证明核、满射、range 与商群第一同构定理。公开接口
只使用正式 `Subgroup`，没有扩建历史 `SubgroupSet`。

学科分支在正式提交前以 merge 方式同步 Main `22c062d`；该基线已经集成
carrier 桥、次数—指数和正规性三批，故本批不依赖尚未进入 Main 的猜测接口。

## 交付声明

- `fixedFieldRestrictionHom`
- `fixedFieldRestrictionHom_apply`
- `fixedFieldRestrictionHom_ker`
- `fixedFieldRestrictionHom_surjective`
- `fixedFieldRestrictionHom_range`
- `fixedFieldQuotientEquiv`
- `fixedFieldQuotientEquiv_mk_apply`

## 概念清单与公开签名分类

| 概念 | 教材语义 | Lean 正式承载 | 展开／一手性质 | 复用或桥接角色 | 首个使用者 |
|---|---|---|---|---|---|
| 正规子群 | 共轭下封闭的自同构子群 | Mathlib `Subgroup` 与 `Subgroup.Normal` | `Normal.conj_mem'` | 语义一致的正式公开承载 | `fixedFieldRestrictionHom` |
| 固定域 | 被 `H` 中每个自同构逐点固定的元素 | 本库 `fixedFieldIntermediateField` | A3.9b 的 carrier 定义与 fixing 恢复 | 既有本库教材桥 | `fixedFieldRestrictionHom` |
| 限制同态 | 环境自同构在稳定中间域上的限制 | Mathlib `MonoidHom`，函数值为本库 `restrictAutomorphism` | `fixedFieldRestrictionHom_apply` | 同态承载语义一致；限制值复用既有桥 | 核与满射定理 |
| 核与像 | 限制为恒等者、所有可限制得到者 | Mathlib `MonoidHom.ker/range` | `fixedFieldRestrictionHom_ker/range` | 语义一致的正式公开承载 | 商群同构 |
| 商群及群同构 | 按正规子群取陪集并保持群运算的双射 | Mathlib `QuotientGroup` 与 `MulEquiv` | `fixedFieldQuotientEquiv_mk_apply` | 语义一致的正式公开承载 | 教材第一同构公式 |

公开签名中的 `Subgroup.Normal`、`MonoidHom`、`ker/range`、`QuotientGroup`
和 `MulEquiv` 均属已解释且语义一致的正式承载。`FiniteDimensional`、
`IsGalois`、`Normal`、`AlgEquiv.restrictNormalHom_surjective` 与
`IsScalarTower` 只出现在私有证明体，属于 Mathlib 后端，没有公开泄漏。
本批没有本库新造的子群、商群或同构结构。

## 六项路线问题

1. **教材对象是什么？** 是 `Gal(L/K) → Gal(Lᴴ/K)` 的真实限制同态，以及
   由它诱导的 `Gal(L/K)/H ≅ Gal(Lᴴ/K)`。
2. **正式承载是什么？** 自同构复用 `FieldAutomorphismOver`，子群直接使用
   Mathlib `Subgroup`，商群与群同构使用 Mathlib 的成熟正式承载。
3. **定义层是否重造？** 没有。限制值直接消费 A3.9b
   `restrictAutomorphism`；自同构到 `AlgEquiv` 的 MulEquiv 和有限 Galois
   backend 也复用既有公开桥。
4. **Mathlib 扮演什么角色？** 私有 Q04 使用
   `AlgEquiv.restrictNormalHom_surjective` 提供成熟提升定理，Q05 使用
   `quotientKerEquivOfSurjective`。公开同态本身不由最终 Mathlib 同构包装。
5. **关键边界是什么？** 不进入子群格对应、商群作用、无限 Galois 理论或
   Examples；不新增 `SubgroupSet` API。
6. **后续集成需要什么？** Main 加顶层导入、Registry、ROADMAP、RADAR 与
   派生索引，并在 Entry 登记后运行全库条目及公理审计。

## Q01–Q05 的真实 proof-state 转换

- Q01：`PreservesIntermediateField` 展开为正逆两个集合闭包目标。各目标再
  展开为固定域中的任意 `τ ∈ H` 逐点固定；正规性提供两个共轭元素，最后
  用 `left_inverse`/`right_inverse` 消去外层自同构。
- Q02：同态律经 `FieldAutomorphismOver.ext` 化为逐点等式，分别由
  `restrictAutomorphism_identity_apply` 和
  `restrictAutomorphism_comp_apply` 关闭。
- Q03：`mem_ker` 把目标化为 restriction 等于恒等；
  `fixing_iff_restrictAutomorphism_eq_identity` 把它化为 fixing membership；
  有限扩张中的 fixing-fixed 恢复把该集合严格识别为 `H`。
- Q04：先安装 `K → Lᴴ → L` 的 Algebra/塔实例，再由正规性模块取得
  `Normal K Lᴴ`，由 A3.9b backend 取得有限维 Galois 实例。Mathlib 满射
  给出提升 `g`；应用两端公开 MulEquiv 的单射后，目标变成 restriction
  的底层逐点等式，由 `restrictNormal_commutes` 与本库 apply 定理闭合。
- Q05：`quotientKerEquivOfSurjective` 首先产生按 kernel 取商的同构；
  `quotientMulEquivOfEq` 使用 Q03 将 kernel 改写为 `H`。投影后的 apply
  公式由两个构造的定义性计算得到。

## 验证命令

```bash
lake env lean \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequencesRestriction.lean
lake build \
  SandronesLibrary.AbstractAlgebra.FieldGaloisConsequencesRestriction
rg -n "sorry|TODO|admit|sorryAx|native_decide" \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequencesRestriction.lean
git diff --check -- \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequencesRestriction.lean \
  docs/entries/abstract-algebra/field/galois-restriction.md \
  docs/handoffs/abstract-algebra-a3-field-galois-restriction.md

lake env lean /tmp/sandrones-library/GaloisConsequencesRestrictionAudit.lean
```

子 Agent 完成正式模块单编译和目标构建；学科负责人随后逐项复核数学陈述、
公开签名与证明体，并重跑正式模块、目标构建及临时聚合。聚合同时 `#check`
正式承载、固定域桥、七项公开 API，并对五项关键定理执行 `#print axioms`。
Entry 文档、源码 Entry 标记与拟登记 id 均为
`abstract-algebra.field.galois-restriction`；一个 Entry 只对应本 Lean 文件。

正式单文件编译及占位扫描为零 warning、零 error、零命中。Registry 尚未
登记本 Entry 时，条目级 `audit.py`/`check_axioms.py` 无条目属于预期；Main
集成后再运行这些审计与全库 build。

子 Agent 的文件所有权仅限本批三个交付文件，未修改 Main 共有文件、未提交；
负责人复审未发现需退回的数学或接口问题。下一批可稳定依赖七项公开 API，
但不得依赖尚被冻结的 `SubgroupSet` Stage B 迁移。
