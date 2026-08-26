# WF1-02：有限、可数与不可数——章节提纲与来源账

- 文档性质：未来章节的中文提纲／来源账，不是完整章节
- 事实截止：`453e8115dc87dfca446506cbf723f7634d63f3d7`
- 批次地位：WF1 `development_open`
- 建议章节位置：卷零，紧接 `00-01-sets-relations-and-maps.md`
- 出版来源：`jech-set-theory-2003`
- 人物 ROLE 版本：采用各文件截至 2026-08-26 的 `usable` 版本

## 一　章节目的

本章要回答“集合的大小究竟怎样比较”这一个连续问题。叙事从不依赖排列次序的逐一配对开始，依次区分
等势、单向嵌入、有限枚举、可数编码和不可数；再解释为什么两个方向都能嵌入足以推出等势，以及为什么
幂集总会越出任何既定名单。有限、可数、不可数不应被写成三个孤立标签：读者应看见它们共享函数语言，
但需要的量词与函数性质并不相同。

本章只消费下列已验收 Entry。关于有理数和实数的结果只陈述当前形式化资产已经核验的结论；叙事中的
枚举、对角线或十进制图像不能冒充本库 Lean 证明的逐步复现。

## 二　Registry 中的精确 verified Entry 清单

下表按建议叙事顺序抄录 `index/registry.json` 的关键字段。`—` 表示 registry 数组为空，而不是推测其
数学上没有前驱或实现依赖。

| Entry id | kind | state | registry 标题 | premises | mathlib | Lean／Entry 文档 | axioms |
|---|---|---|---|---|---|---|---|
| `settheory.cardinal.equinumerous` | `definition` | `verified` | 等势：用双射比较集合大小 | — | `Equiv` | `SetTheory/CardinalTheory.lean`；`docs/entries/settheory/cardinal/equinumerous.md` | `Classical.choice`, `Quot.sound` |
| `settheory.cardinal.comparison` | `definition` | `verified` | 基数比较：用单射定义不大于 | `settheory.cardinal.equinumerous` | `Function.Injective` | `SetTheory/CardinalTheory.lean`；`docs/entries/settheory/cardinal/comparison.md` | `Quot.sound` |
| `settheory.cardinal.finite-set` | `definition` | `verified` | 有限集：能够完整编号到某个 Fin n | `settheory.cardinal.equinumerous` | `Fin` | `SetTheory/CardinalTheory.lean`；`docs/entries/settheory/cardinal/finite-set.md` | `Classical.choice`, `Quot.sound`, `propext` |
| `settheory.cardinal.countable-def` | `theorem` | `verified` | 可数集定义 | — | — | `SetTheory/Cardinal.lean`；`docs/entries/settheory/cardinal/countable-def.md` | — |
| `settheory.cardinal.countable-rat` | `theorem` | `verified` | 有理数可数 | — | — | `SetTheory/Cardinal.lean`；`docs/entries/settheory/cardinal/countable-rat.md` | `Classical.choice`, `Quot.sound`, `propext` |
| `settheory.cardinal.countable-union` | `theorem` | `verified` | 可数个可数集的并可数 | — | — | `SetTheory/Cardinal.lean`；`docs/entries/settheory/cardinal/countable-union.md` | `Classical.choice`, `Quot.sound`, `propext` |
| `settheory.cardinal.cantor-bernstein` | `theorem` | `verified` | Cantor–Bernstein 定理 | `settheory.cardinal.equinumerous`, `settheory.cardinal.comparison` | `Embedding.schroeder_bernstein`, `Equiv.ofBijective` | `SetTheory/CardinalTheory.lean`；`docs/entries/settheory/cardinal/cantor-bernstein.md` | `Classical.choice`, `Quot.sound`, `propext` |
| `settheory.cardinal.cantor-theorem` | `theorem` | `verified` | Cantor 定理：幂集严格更大 | `settheory.cardinal.comparison` | — | `SetTheory/CardinalTheory.lean`；`docs/entries/settheory/cardinal/cantor-theorem.md` | `Classical.choice`, `Quot.sound`, `propext` |
| `settheory.cardinal.uncountable-real` | `theorem` | `verified` | 实数不可数 | — | — | `SetTheory/Cardinal.lean`；`docs/entries/settheory/cardinal/uncountable-real.md` | `Classical.choice`, `Quot.sound`, `propext` |

九条的 `provenance.ref` 均为 `jech-set-theory-2003`。特别留意：后三个旧式可数性应用 Entry 的文档
front matter 把 `countable-def` 写成叙事前驱，但当前 registry 的 `premises` 仍为空；未来正文可以先讲
可数性判据再讲应用，却不能把该阅读顺序报告为 registry 已登记的直接依赖边。

## 三　逐节主张与 Entry 来源

### 1. 不数到最后，怎样说“同样多”

- 先从有限名单的逐项配对抽离出不依赖末项的标准：两个类型等势，当且仅当存在双射；也可表述为存在
  一个同时单射且满射的函数。
- 等势只比较数量，不自动保留次序、代数运算、拓扑或任何额外结构。
- 无限集合可与真子集等势，因此“真包含”不能单独充当严格更小的判据。
- 来源：`settheory.cardinal.equinumerous`。

### 2. 从“同样多”到“不比它多”

- 用从 `α` 到 `β` 的单射定义 `|α| ≤ |β|`；必须明确函数方向。
- 该比较自反、可传递；等势给出两个方向的比较。
- 双向单射还不能被当成两条互逆函数；反对称意义要留到 Cantor–Bernstein 后闭合，而且结论是等势，
  不是 Lean 类型字面相等。
- 来源：`settheory.cardinal.comparison`；等势前驱为 `settheory.cardinal.equinumerous`。

### 3. 有限：与某个标准有限类型完整配对

- `α` 有限枚举的精确定义是：存在自然数 `n`，使 `α` 与 `Fin n` 等势。
- 这表达“恰有 `n` 个元素”，强于只存在到某个 `Fin n` 的单射上界；空类型对应 `Fin 0`，所以有限
  不蕴含非空。
- 当前公开结果只从精确枚举推出一个有限单射界；不声称 `n` 的唯一性，也不声称已经给出与所有
  mathlib `Finite`／`Fintype` 接口的完整互换。
- 来源：`settheory.cardinal.finite-set`；概念前驱为 `settheory.cardinal.equinumerous`，比较语言回指
  `settheory.cardinal.comparison`。

### 4. 可数：把元素无冲突地编码进自然数

- `Countable α` 当且仅当存在单射 `α → ℕ`。正文应把“每个元素获得不同号码”与“每个自然数号码都
  必须使用”分开：这里要求单射，不要求满射。
- 可数包含有限与可数无限的情形；反方向的单射 `ℕ → α` 只说明 `α` 至少容得下自然数，不能证明
  `α` 可数。
- 来源：`settheory.cardinal.countable-def`。

### 5. 可数仍能很稠密，也能按可数层合并

- 有理数类型可数；这足以否定“稠密看起来元素很多，所以必不可数”的直觉，但本 Entry 本身不形式化
  有理数在实数中的稠密性。
- 若指标类型可数，且每一片集合可数，则这些集合的并可数。两个条件都必须保留；若某一片不可数，
  或指标族不可数，结论不能由此定理获得。
- 网格／对角扫描可作为理解 `(i,m)` 编码的直觉，但不可声称当前 Lean 文件展开实现了该具体算法；
  `countable-rat` 与 `countable_iUnion` 均复用 mathlib 已有事实。
- 来源：`settheory.cardinal.countable-rat`、`settheory.cardinal.countable-union`；阅读前驱为
  `settheory.cardinal.countable-def`，但当前 registry 未登记这两条 premise 边。

### 6. 两边都放得下，为何足以一样大

- Cantor–Bernstein：若 `α` 单射到 `β` 且 `β` 单射到 `α`，则 `α` 与 `β` 等势。
- 结论只保证存在某个双射；输入的两条单射可以彼此无关，不被宣称互逆。
- 正文若使用链与连通分量的图像，应标作证明直觉；当前形式化复用
  `Embedding.schroeder_bernstein` 作为证明后端。
- 来源：`settheory.cardinal.cantor-bernstein`；直接 registry 前驱为
  `settheory.cardinal.equinumerous`、`settheory.cardinal.comparison`。

### 7. 对角集合：任何“全部子集名单”都会漏项

- 对任意 `f : α → Set α`，对角集合 `{x | x ∉ f x}` 不在 `f` 的像中，因此不存在从 `α` 到其
  幂集的满射，也不存在两者之间的等势。
- 单元素映射给出 `α` 到 `Set α` 的单射；结合 Cantor–Bernstein 排除反向单射，得到本库命题
  `CardinalLT α (Set α)`。
- “严格更大”在这里是本库定义的正向可嵌入且反向不可嵌入；尚未注册为通用序结构。对角集合依赖
  给定名单，不是预先固定的集合，也不是 Russell 悖论。
- 来源：`settheory.cardinal.cantor-theorem`；直接 registry 前驱为
  `settheory.cardinal.comparison`，论证内部使用本库 Cantor–Bernstein。

### 8. 实数不可数，以及两种对角叙事的边界

- 当前已核验结论是 `ℝ` 不可数，即不存在其 `Countable` 证明；结合前述可操作刻画，可解释为不存在
  单射 `ℝ → ℕ`。
- 十进制逐位改写只能作为直觉，并须立即提醒 `0.999… = 1.000…` 一类表示二义性；不能把这段朴素
  小数论证说成当前 Lean 定理的证明体。
- Cantor 幂集定理和实数不可数都使用对角思想，但本批来源并未建立 `ℝ` 与某个幂集等势，也未在
  registry 中登记二者的直接依赖。正文只能比较方法形状，不能伪造形式化推导链。
- 来源：`settheory.cardinal.uncountable-real`；阅读前驱为
  `settheory.cardinal.countable-def`，但当前 registry 未登记该 premise 边。

## 四　本章不声称什么

- 不声称建立了完整基数对象、基数商、基数全序、良序定理、选择公理等价命题或 Aleph 层级。
- 不声称任意两个集合的大小都已经可比较；本批只有 `CardinalLE` 的自反、传递和等势意义下的双向闭合。
- 不声称有限、可数、不可数三类穷尽所有更细的无限基数，也不声称所有不可数集合都与实数等势。
- 不声称实数与自然数幂集等势，不声称连续统假设，也不把 Cantor 幂集定理直接改写成连续统结论。
- 不声称有理数的稠密性、实数展开理论或小数对角构造已由本批 Entry 形式化。
- 不声称可数个可数集之并的结论适用于任意指标并；也不省略“每一片可数”这一假设。
- 不声称 Cantor–Bernstein 的输入单射互为逆，也不把等势误写为元素相等、子集相等或结构同构。
- 不声称 `FiniteByEnumeration` 已与 mathlib 的 `Finite`／`Fintype` 全面互换，或其中的 `n` 已证明唯一。
- 不把 Entry 文档中的叙事前驱自动当作 registry 已登记的 `premises`，不把 mathlib 后端的证明路线
  写成库内新增的显式构造。
- 不提供足以独立授课的习题梯度、课程周次或完整解答体系。

## 五　三个自然人物情景候选

以下只是未来正文的场景种子；均须原创改写，并在成稿后接受独立人物与文字审核。

### 候选 A：两份名单，到底怎样算“同样多”

- 角色：纳西妲（`characters/roles/nahida.md`，`usable`）与砂糖
  （`characters/roles/sucrose.md`，`usable`）。
- 处境与分歧：砂糖整理两柜样本记录，一柜编号有空缺，另一柜编号连续；她本能地想先补齐编号再比较。
  纳西妲请她暂时忘掉号码的形状，只检查能否让每份样本恰好结成一对。砂糖随后指出，若比较目标变成
  “具有同样实验性质”，仅有配对便不够。
- 数学作用：引出等势；区分双射所保留的数量与未保留的额外结构。
- 类比停止处：真实样本可能带有结构和测量误差；配对只能证明所选集合层级上的等势，不能证明样本
  性质相同。

### 候选 B：两边都安排得下，却没有现成的反向表

- 角色：艾尔海森（`characters/roles/alhaitham.md`，`usable`）与卡维
  （`characters/roles/kaveh.md`，`usable`）。
- 处境与分歧：两套场地与设计档案之间各有一张“无冲突安置表”，但两张表是按不同约束独立制作，
  并不互逆。卡维拒绝把任一张表的反向关系冒充施工方案；艾尔海森则把问题重新表述为：已有的是两个
  方向的单射，所需的是另行构造的一次完整配对。
- 数学作用：在真实任务差异中暴露 Cantor–Bernstein 的输入与结论，防止“双向单射就是互逆”误读。
- 类比停止处：现实设计还有成本与偏好，数学定理只保证抽象元素间存在双射，不替委托方决定哪一种
  配对最有价值。

### 候选 C：一份声称收齐所有观察条件的目录

- 角色：莫娜（`characters/roles/mona.md`，`usable`）。
- 处境与分歧：委托人交来一份以每个观测点为索引、并声称列尽所有“应纳入的观测点集合”的目录。
  莫娜不尝试把目录倒过来求唯一输入，而是按每个观测点是否出现在其自身对应条目中，编成一项逐处
  相反的新条件；委托人的“完整”主张因此自行失效。
- 数学作用：让对角集合依赖给定名单这一点可见，并把“未满射”与“没有逆函数”区分开。
- 类比停止处：观测条件只是集合成员关系的载体；星象解释不构成数学证据，新条件是否具有现实意义
  也不是 Cantor 定理所保证的内容。

## 六　下一小批

下一小批只写本章的第 1–4 节初稿：等势、单射比较、有限枚举与可数性判据，并选定候选 A 作为唯一
人物情景。开工前冻结术语首现（“等势”“基数不大于”“有限枚举”“可数”）及与
`00-01-sets-relations-and-maps.md` 的回链；逐断言核对四个 Entry 的自然语言与 Lean 声明；另请一名
数学审稿人检查函数方向、量词和有限／可数边界，再由不同的文字审稿人检查场景与叙事。Cantor–Bernstein、
幂集定理和实数不可数留到其后的独立小批，不在第一稿提前写成完成章节。
