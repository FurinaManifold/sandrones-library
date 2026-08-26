# World Formula mathematical review: WF1-02 / 第二章第 7 节 Cantor–Bernstein

- fact cutoff: `cfbf141b74ffa283af1d3cf6f94ab3075b17e40e`
- author commit: `75c42a4a54f7059f515de484e4a5b9aae60733b3`
- reviewed file: `docs/world-formula/chapters/00-02-finite-countable-uncountable.md`
- mathematical reviewer: independent World Formula mathematical reviewer
- editorial reviewer: pending; not covered by this record
- reviewed at: 2026-08-26
- mathematical-round verdict: `needs_changes`
- whole-chapter status: remains `draft`

## 审核范围与事实链

本轮按 `docs/world-formula/REVIEW-PROTOCOL.md` 第一轮，只读逐断言检查第 7 节的对象、量词、
函数方向、结论强度、证明直觉地位、人物场景中的函数性质、事实截止与未覆盖边界；不修改章节，
也不复审第 1–6 节已经闭环的内容。核验对象为 verified Entry
`settheory.cardinal.cantor-bernstein`，并交叉检查其两项直接前驱
`settheory.cardinal.equinumerous`、`settheory.cardinal.comparison`、Entry 文档、handoff 来源账、
事实截止处 Registry，以及 `SandronesLibrary/SetTheory/CardinalTheory.lean` 中的
`CardinalLE`、`Equinumerous`、`cantor_bernstein` 和 `cardinalLE_antisymm`。

事实截止 `cfbf141` 是作者提交 `75c42a4` 的祖先；目标 Entry 在截止处为 `verified`。Lean 的输入
精确为 `CardinalLE A B` 与 `CardinalLE B A`，即分别存在单射 `A → B` 与 `B → A`；结论精确为
`Equinumerous A B = Nonempty (A ≃ B)`，等价于存在某个双射 `A → B`。定理没有给出输入函数必定
不是结论见证的否定信息。

## 逐断言审核表

| 章节行号／锚点 | 核验对象、量词、方向与地位 | 依据 | 评级与结论 |
|---|---|---|---|
| 3–24，章首元信息 | 事实截止可解析，覆盖清单新增目标 Entry；旧数学、文字与 Main 验收仍分别限定于第 1–4 节和第 5–6 节，没有把旧结论扩张到第 7 节。 | 作者 commit；既有 review 记录；截止 Registry | 通过 |
| 259–265，双向单射输入 | 对象为任意两个类型 `A,B`；量词是分别存在 `f : A → B`、`g : B → A` 且二者单射。两条函数方向相反，没有偷换成同方向函数，也没有要求满射或互逆。 | `CardinalLE`；`cantor_bernstein` | 通过 |
| 267–272，定理结论 | 从双向单射推出存在双射 `h : A → B`，与 `Equinumerous A B` 的公开展开完全一致。正文没有写成 `A = B`，也没有把两条输入单射写成互逆。 | `cantor_bernstein`；`equinumerous_iff_exists_bijective` | 通过 |
| 274–277，“必须另行构造” | “不保证 `h=f`”准确；但“`h` 必须另行构造”把未保证相同加强为必定要另造。若 `f` 已是双射，完全可取 `h=f`；定理只保证存在见证，不要求见证不同于输入。 | `Equinumerous := Nonempty (A ≃ B)`；`cantor_bernstein` | **R1 factual/quantifier**；见 F-01 |
| 279–289，两张安置表 | 第一张明确为场地 `→` 档案且不同场地不共用档案，第二张明确反向且“同样没有冲突”，两者都对应单射，而不是一般关系。第一张的反向关系未必对每份档案给出唯一场地，这一警告正确区分单射与双射。专业约束被明确从抽象数量结论中剥离。 | `CardinalLE` 的函数与单射量词；handoff 候选 B | 通过；但 286–287 行“另找”重复 F-01 的过强措辞 |
| 291–294，链／分量图景 | 两侧画出两条单射的边并按连通分量选取配对方向，是标准的证明直觉；正文明确标作出版背景图像，而非本章新增形式化构造，并准确披露 Lean 后端复用 `Embedding.schroeder_bernstein`。“链、环和其他连通分量”是非穷尽的直觉性列举，不被写成已形式化的完整分量分类。 | Entry “直觉”与“自然语言 ↔ Lean 映射”；Lean 86–87 行 | 通过；无 R2。若文字轮追求术语严整，可将“链、环和其他连通分量”改为“按连通分量（包括链与环等情形）”，但这不是数学返工门 |
| 296–310，来源与验收边界 | 直接前驱、证明后端与目标 Entry 均可解析；正文明确第 7 节尚未经过三轮验收，第 1–6 节既有验收范围未被冒进。 | handoff 88–95 行；Entry front matter；截止 Registry | 通过 |
| 314–316，全章未覆盖边界 | 仍明确全章未完成、不可数性结果尚未写、完整章末边界与后半章待补；没有借 Cantor–Bernstein 声称任意两类型已可比较，也没有推出幂集或连续统结论。 | 章节末段；handoff 120–127 行 | 通过 |

## Findings

- **F-01 [R1 factual/quantifier] 274、286–287**：正文正确说定理“不保证 `h=f`”，但又说
  “`h` 必须另行构造”以及“能否另找一张”配对表。这把“现有资料不足以预先认定哪条输入单射就是
  双射”误写成“任何结论见证都必须不同于输入函数”。反例很直接：取 `A=B`，令 `f=g=id`；两条
  输入单射满足假设，而结论双射可直接取 `h=f=id`。更一般地，只要输入的 `f` 已经双射，它自身就可
  作为存在性结论的见证。Lean 定理返回某个双射数据，但其陈述没有 `h ≠ f`，也没有“必须重新构造”
  这一量词或否定条件。

  验收：把必然语气改为“定理可能需要／允许重新配对”或“不能仅凭假设预先断定 `f` 已是所需双射”；
  场景相应改为“能否得到一张不重不漏的配对表”，允许在特殊情形复用原表。保留“输入函数不要求
  互逆”“结论不保证 `h=f`”“结论只是等势”即可，不得新增 `h` 必须不同于 `f,g` 的暗示。

## R1／R2／R3 汇总

- **R1**：1 项开放 finding，即 F-01；涉及存在见证与“必须另造”的量词强度，必须返工。
- **R2**：未发现开放 finding。链／连通分量图景被准确降格为证明直觉，人物场景也确实给出两个方向
  的单射，不是把一般关系冒充函数或单射。
- **R3**：未发现需要数学作者返工的 finding。链／分量一句可在后续文字轮做非阻塞术语润色。

## 特别核验结论

1. **双向单射的量词与方向**：完整且正确；分别是存在 `A → B` 单射与存在 `B → A` 单射，输入函数
   不要求互逆、满射或由同一规则产生。
2. **结论强度**：准确核心是 `Equinumerous A B`，展开为存在某个 `A → B` 双射；不是类型字面相等，
   也不自动保存采光、通行等附加结构。
3. **新双射与输入函数**：定理不保证输出见证等于任何输入，但也不保证不同；“可能重新配对”正确，
   “必须另行构造／另找”错误。
4. **链分量图景**：作为出版背景证明直觉是合适的；正文没有声称本章形式化了分量分类或构造，实际
   Lean 后端确为 `Embedding.schroeder_bernstein`。
5. **场景中的两张表**：两张表都有明确函数方向和无冲突条件，足以分别表示单射；正文也正确指出
   第一张单射的反向关系未必是函数，更不必满足第二张表的专业约束。
6. **事实截止与边界**：`cfbf141` 可解析且为作者提交祖先；目标 Entry 在该截止为 verified；直接前驱、
   Entry 文档和 Lean 声明均可解析。第 7 节尚未经验收及全章未完成的状态披露准确。

## Resolution

- F-01: `still blocked`；等待章节作者按上述验收条件修订后进行只读复验。

## Verdict

对 author commit `75c42a4` 的第 7 节数学轮 verdict 为 **`needs_changes`**。双向单射的方向、
`Equinumerous` 结论、场景中的单射条件、链分量图景地位、事实截止和未覆盖边界均通过；但 F-01
把“结论不保证沿用输入函数”加强成“见证必须另行构造”，构成开放 R1，不能以文字润色处理。
本 verdict 只覆盖第 7 节数学第一轮，不修改章节，不代替后续独立文字审稿或 Main 一致性验收。
