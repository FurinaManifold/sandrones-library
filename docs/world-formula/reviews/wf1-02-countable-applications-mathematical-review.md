# World Formula mathematical review: WF1-02 / 第二章第 5–6 节

- fact cutoff: `e1d5bc0`
- author commit: `b38823d0d89667b91259d86fbadf20679dffedcf`
- reviewed file: `docs/world-formula/chapters/00-02-finite-countable-uncountable.md`
- mathematical reviewer: independent World Formula mathematical reviewer
- editorial reviewer: pending; not covered by this record
- reviewed at: 2026-08-26
- mathematical-round verdict: `needs_changes`
- whole-chapter status: remains `draft`

## 审核范围与事实链

本轮按 `docs/world-formula/REVIEW-PROTOCOL.md` 第一轮，只读逐断言检查第 5–6 节的对象、量词、
假设、方向、事实地位、来源和误读边界；不复审第 1–4 节已经闭环的数学内容，也不修改章节。
核验对象为 verified Entry `settheory.cardinal.countable-rat` 与
`settheory.cardinal.countable-union`，对应 Lean 声明为 `countable_rat` 与
`countable_iUnion`，并核对两份 Entry 文档、handoff 来源账、事实截止处 Registry 和
`jech-set-theory-2003` 书目键。

事实截止 `e1d5bc0` 是作者提交 `b38823d` 的祖先；两条 Entry 在该截止均为 `verified`。其中
`countable_iUnion` 的精确签名为：对类型 `ι, α`，在 `[Countable ι]` 下，任给
`s : ι → Set α`，若 `∀ i : ι, (s i).Countable`，则 `(⋃ i, s i).Countable`。该 Entry 的
Registry 与文档均登记 `Classical.choice` 公理依赖。

## 逐断言审核表

| 章节行号／锚点 | 核验对象、量词、假设与地位 | 依据 | 评级与结论 |
|---|---|---|---|
| 3–26，章首元信息 | 状态准确写明已完成第 1–6 节；覆盖清单加入两条本轮 Entry。数学、文字和 Main 的 `accepted` 均逐项限定为第 1–4 节，末段另明示第 5–6 节尚未验收，没有把旧验收扩张到本轮。 | 三份 foundations review；章节 245–251 行 | 通过 |
| 188–192，稠密与可数的区分 | 在通常次序下，两个不同有理数之间仍有有理数；该性质与是否存在 `ℚ → ℕ` 单射属于不同问题。正文没有从稠密性推出可数或不可数。 | `jech-set-theory-2003` 出版背景；`countable_rat` | 通过 |
| 194–201，有理数可数的正式结论与地位 | 正式结论准确限定为 `Countable ℚ`，并借第 4 节已核验刻画解释为存在单射 `ℚ → ℕ`。稠密性明确标为未由本 Entry 形式化核验的出版背景。 | `countable_rat : Countable ℚ`；`countable_iff_injective_nat` | 通过 |
| 203–210，分子分母与对角编码图景 | 分数表示、格点分层／对角扫描和规范表示／去重只承担可数性的教材直觉；正文明确说明 Lean 证明只复用现成 `Countable ℚ` 实例，没有冒充实现具体枚举或配对公式。 | `countable-rat` Entry 41–59 行；Lean `infer_instance` | 通过；未形式化边界清楚 |
| 212–228，可数并的陈述与反例边界 | 对象准确为 `s : I → Set α`；量词完整保留“指标类型 `I` 可数”和“对每个 `i`，`S_i` 可数”，结论准确为 `⋃ i, S_i` 可数。单个不可数片和不可数族单元素集合正确说明两项假设不能互相替代；没有扩张为任意并。 | `countable_iUnion` 的完整 Lean 签名；`countable-union` Entry 29–44、83–87 行 | 通过 |
| 230–243，`(i,m)` 编码直觉 | 正文正确把 `(i,m)` 标为教材路线而非 Lean 证明体，并注意同一元素可来自多片。但“片内编号组成一个可数网格”“可以先枚举所有出现位置”与“为它选定一个来源”的写法，未披露要从逐片的可数性证明统一取得整族编码／来源选择；在一般集合论中这不是仅靠已列两项假设即可无条件完成的显式构造。当前形式化资产确实依赖 `Classical.choice`。 | Registry `axioms`；`countable-union` Entry 66–74 行；Lean 72–76 行 | **R1 assumption/status**；见 F-01 |
| 245–257，半章来源与未完成边界 | 六条 Entry 的归属准确；第 5–6 节未经验收、不可数结果尚未书写、全章仍是 draft 均被明确说明。 | 章节元信息与 handoff | 通过 |

## Findings

- **F-01 [R1 factual/assumption] 230–243**：可数并的定理陈述本身与 Lean 完全一致，但其编码说明
  把“对每个 `i`，存在一个片内编码”直接叙述成一张已经统一配好的可数网格，并提出为每个并集元素
  选定一个来源。这里存在选择步骤：逐片存在的编码不自动给出一族同时选定的编码；为每个属于多片的
  元素统一选来源也同样是选择。一般集合论中“可数个可数集的并可数”涉及可数选择，不能把它写成仅凭
  两条显式可数性假设就得到的无条件显式算法。本库当前证明复用 `Set.countable_iUnion`，而事实截止处
  Registry 和对应 Entry 明确登记 `Classical.choice`，所以省略这一形式化／基础假设边界会让读者误以为
  不需要选择，或误以为 `hs : ∀ i, (s i).Countable` 已经提供统一枚举族。

  验收：保留 `(i,m)` 作为思路，但明确说明在当前经典形式化背景中可统一选取所需片内编码／来源，
  当前 Lean 结论的公理依赖含 `Classical.choice`；不得声称 `hs` 本身给出了统一枚举。也可只采用
  “所有带来源的出现位置”这一条路线，但仍须披露从逐片可数性到统一编码族的选择边界。

## 特别核验结论

1. **`ℚ` 可数与稠密性**：`Countable ℚ` 是 verified 结论；稠密性只作出版背景，章节已明确说明未由
   本 Entry 形式化，地位没有冒进。
2. **可数并的量词**：章节完整保留 `Countable ι`、`∀ i, (s i).Countable` 和
   `(⋃ i, s i).Countable`，没有漏掉片内量词或误写为任意指标并。
3. **`(i,m)` 的地位**：章节没有冒充 Lean proof，但对统一取得片内编码／来源所需的选择边界披露
   不足，构成 F-01。
4. **统一枚举与选择**：`Countable` 只断言相应编码存在；一族逐点存在的编码不是正文可无说明直接
   使用的统一枚举数据。当前 Entry 的实际形式化链含 `Classical.choice`。
5. **旧验收范围**：章首三项 `accepted` 均诚实限定为第 1–4 节，章末也明确第 5–6 节尚未验收；未
   发现把旧数学／文字／Main 验收扩张到新内容的错误暗示。

## Resolution

- F-01: `still blocked`；等待章节作者在第 6 节补足经典选择／统一编码族的边界后只读复验。

## Verdict

对 author commit `b38823d` 的第 5–6 节数学轮 verdict 为 **`needs_changes`**。有理数可数、稠密性
背景边界、可数并的完整量词以及 `(i,m)` 仅作思路等主体内容均正确；但 F-01 是协议明确要求检查的
假设遗漏，且会把依赖 `Classical.choice` 的统一选择步骤误读成由逐片可数性直接给出的显式数据，故在
修订并复验前不能判为 `accepted`。本 verdict 只覆盖第 5–6 节，不改变第 1–4 节既有验收结论。
