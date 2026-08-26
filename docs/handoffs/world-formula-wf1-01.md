# Handoff：World Formula WF1-01

- 分支：`codex/world-formula`
- 事实截止 Main：`3af0be230ac58fe27cdce1576eef972acbbd331c`
- 章节文件：`docs/world-formula/chapters/00-01-sets-relations-and-maps.md`
- 状态：`draft`（E1–E4 修订已起草；两处人物情景已按最小 ROLE 证据重写，等待独立复验）
- 作者：World Formula 章节编辑子 Agent
- 数学审稿人：独立 World Formula 数学审稿人；commit `7bc36b0`，verdict `accepted`
- 文字审稿人：独立 World Formula 文字审稿人；commit `6700f41`，原 verdict `needs_changes`
- 当前 verdict：数学轮 `accepted`；E1–E4 已由作者起草处理，但用户要求先建人物 ROLE 再重写
  场景，故当前补交人物证据与两处场景供复验；尚未经过 Main 第三轮验收，作者不自批 `accepted`

## 一　本批范围

WF1-01 建立卷零第一章“集合、关系与函数：数学对象如何获得共同语言”。章节从外延性和逐元素
成员性出发，依次发展包含、集合运算、关系与商集、函数的单满双射、原像，并以拓扑连续性和
柯西序列商构造作为两个真实下游。正文只使用自然语言和通常数学记号，没有 Lean 代码、tactic、
proof state 或 API 清单。

按用户新增的全书基调，章节加入四个“提瓦特闲谈”原创情景框。它们与定义、定理和来源段落明确
分隔，只承担直觉、误解诊断和跨学科连接，不作为数学事实或游戏官方设定。作者已从 Main
`2283535` 读取并逐项对照 `docs/world-formula/TONE-AND-SCENES.md`；该提交只增加书稿规范，
不改变本章数学事实截止点。

初稿批只修改章节与 handoff。本轮按两份独立 review 另更新其 Resolution 处理记录，并新增两个
章节人物 ROLE；仍未修改 ROADMAP、Playbook、README、AGENTS、共享治理 ROLE（`docs/roles/`）、
Registry、参考文献库、Entry 或 Lean 源码。

## 二　来源 Entry

### 集合、函数与商集主线

1. `settheory.set.ext`
2. `settheory.set.subset.definition`
3. `settheory.set.subset.trans`
4. `settheory.set.subset.antisymm`
5. `settheory.set.empty-subset`
6. `settheory.set.operations.inter-distrib`
7. `settheory.set.operations.complement-union`
8. `settheory.set.operations.complement-inter`
9. `settheory.set.operations.diff-inter-complement`
10. `settheory.function.inj-comp`
11. `settheory.function.surj-comp`
12. `settheory.function.image-preimage.preimage-union`
13. `settheory.function.image-preimage.preimage-inter`
14. `settheory.function.inject-surject.bijective-iff-inverse`
15. `settheory.set.relations.equivalence-class-eq`
16. `settheory.set.relations.quotient-surj`

### 真实跨学科消费者

17. `analysis.real.construction-cauchy`
18. `topology.foundation.structure`

上述 18 项均已在事实截止 Main 的 `index/registry.json` 中核对为 `verified`。作者还逐项读取了
相应 Entry 文档，并对 16 个基础条目的三个 Lean 文件核对了定理方向、量词和对象类型。两个下游
以 Registry 前提和其 Entry 的正式陈述为依据，不从 ROADMAP 完成语气反推数学事实。

## 三　出版来源

- `jech-set-theory-2003`：集合、关系、函数与商集的标准背景；
- `ecnu-mathematical-analysis-5`：柯西序列商构造的分析背景；
- `munkres-topology-2000`：开集原像刻画连续性的拓扑背景。

三个 citation key 均在 `reference.bib` 中解析。一般二元关系、函数定义、任意族原像公式、等价类
的具体集合论写法目前没有独立 verified Entry，故章节把它们明确标作“出版背景”，没有伪装为
库内已验收定义。数学 review 的 F-01 要求精确章／节或页码；现有书目和 Entry 材料不足以可靠核对，
本轮不猜定位，诚实记为 `deferred (non-blocking R3)`，待出版编辑或 Main 取得登记版本后补。

## 四　跨章与术语首现

- 本章无前驱章节，是“集合”“成员”“子集”“有序对”“笛卡尔积”“关系”“等价关系”“商集”
  “函数”“单射”“满射”“双射”“陪域”“整体像”“子集像”“原像”的暂定首现位置。
- 后续拓扑章节应回指本章的“原像保并、保交”，但必须另行定义开集与连续性。
- 后续实数构造章节应回指本章的“商判等、商映射满射”，但必须另行说明柯西条件、等价关系的
  具体内容和运算良定义性。
- 后续抽象代数与几何章节可回指商语言，但不得把本章的商集基础误作商结构已完成。

当前章节没有链接尚不存在的后继章节，以免制造死链。

## 五　情景框账与审查功能

| 位置 | 角色与情景 | 数学作用 | 类比失效处 | 原创性自查 |
|---|---|---|---|---|
| §2.1 外延性之后 | 纳西妲请同伴寻找只在一份名单中的记录，并主动加入日期再问 | 让“找反例”推动外延判等，并区分元素选择与选定后的成员性判等 | 元素若是带日期、作者、版本的记录，就不同于只比较地名；外延性不替人选择对象 | 按 content `5111` 的观察—检查—修正约束新写；无台词、任务文本或官方事件复述 |
| §4.2 商集之后 | 砂糖按指定试验给样本分柜 | 解释等价关系三性质，以及“忽略哪些差别取决于问题” | 同柜只表示指定响应相同，不表示样本所有性质相同；换问题可换关系 | 新写研究室侧写；只借人物的实验视角，不借官方设定作证 |
| §5.1 函数定义之后 | 艾尔海森与卡维争论多方案设计 | 区分一般关系与每个输入唯一输出的函数 | 建筑方案只是候选关系的类比；补规则会丢失多值信息，也不自动涉及集合论选择公理 | 新写争论；双方观点各有合理目标，无故意贬低或改写台词 |
| §7.1 拓扑连接之后 | 莫娜拒绝虚构唯一逆答案，改为圈出全部合条件输入 | 区分原像、逆函数及连续性的额外开集条件 | 多对一时仍有原像而未必有逆函数；没有指定两端拓扑时不能推出连续性 | 按 content `1057` 的准确报告—承认边界约束新写；不声称真实占星、官方剧情或世界观定律 |

四段均为本章原创、转化性的同人情景。删除它们会分别损失：外延性对额外数据的边界直觉、商关系
选择标准的视角、关系与函数之间的真实建模取舍，以及从集合原像到拓扑连续性的停顿。它们没有
替代定义或证明。Main 的文字审稿除通常叙事检查外，还需审查角色认知视角的一致性与版权边界；
若人物理解存在争议，应优先保留数学功能并改写场景，不把争议性设定写入来源账。

**当前暂停门**：用户判定旧情景仍有“角色名生硬插入”的问题，并要求先从指定 Wiki 角色／剧情
文本建立逐角色 ROLE。本轮已为纳西妲、莫娜建立最小 `review` ROLE，并只重写对应两段：前者以
“寻找反例—改变对象数据”推动外延性讨论，后者以拒绝不存在的逆函数推动原像讨论。砂糖及
艾尔海森／卡维两段仍是占位草稿，等待各自 ROLE；任何一段都不能沿用原文字 review 的通过结论
宣布定稿。ROLE 与场景仍须做人物一致性、来源边界与版权复验。

本轮新增角色材料：

- `docs/world-formula/characters/roles/nahida.md`：content `5111`，状态 `review`；
- `docs/world-formula/characters/roles/mona.md`：content `1057`，状态 `review`。

两份 ROLE 只登记官方页面栏目、版本和转述约束，不保存台词或剧情原文；作者不得自行把状态改为
`usable`。

独立只读人物复验曾提出三项局部问题：语音证据标题不够精确、纳西妲仍像通用教师、文件范围中的
“ROLE”措辞有歧义。本轮已分别改为单一语音标题定位、由“拒绝凭身份裁定—让实际记录员执行可
重复检查—主动反查漂亮结论遗漏”推动场景，并明确区分章节人物 ROLE 与 `docs/roles/` 共享治理
ROLE。复验者对这三项给出局部 `accepted`；该结论不验收整章、E1–E4、人物 ROLE 的 `usable`
状态或其余两个人物场景。

### 角色资料抓取器的 Main-side 更新建议

本 worktree 与 Main worktree 的 `.cache/world-formula/` 均未发现现成角色页面缓存。本轮只读请求了
纳西妲 `5111` 与莫娜 `1057` 的官方 `entry_page` API 来核对结构，没有把响应写入 Git。Main 当前
抓取器使用旧 `content/info` 端点；建议后续改用：

```text
https://act-api-takumi-static.mihoyo.com/hoyowiki/genshin/wapi/entry_page?entry_page_id=<ID>
```

所需字段映射如下；这是 handoff 建议，不在本批修改 Main 脚本：

| 用途 | JSON 路径／解析办法 |
|---|---|
| 角色名 | `.data.page.name` |
| 页面事实版本 | `.data.page.version` |
| 栏目序列 | `.data.page.modules[]`；栏目名为 `.name` |
| 组件类型 | `.components[].component_id` |
| 组件正文 | `.components[].data` 先按 JSON 字符串再次解析 |
| 中文语音定位 | `component_id == "role_voice"` 后取 `data.list[]` 中 `tab_name == "汉语"` 的 `table[].name`；ROLE 不缓存 `content` 或音频 |
| 角色故事定位 | `component_id == "collapse_panel"` 后取二次解析的 `rich_text`；只为证据提取转述，原文不得进入 ROLE |
| 关系网定位 | `component_id == "role_relation"` 后解析 `tables`；只有场景真实消费关系动态时才使用 |

同一个 `.name == "角色故事 N"` 的 module 可能既有 `rich_text` 仅为 `<p></p>` 的空壳，又有后置的
有效模块，不能按栏目名取第一个；应在二次解析、去除 HTML 空白后选择非空内容。抓取器还应保留
`entry_page_id`、抓取时间和 `.data.page.version`，以便 ROLE 的维护触发器比较版本；原始响应只放
被 `.gitignore` 排除的缓存，不进入书稿提交。

## 六　作者逐断言自查

作者按照对象、量词、假设、方向、事实地位、来源与边界七项自查：

- 外延性写为双向逐元素成员性，不写成单向包含；
- 子集允许相等，并明确禁止把包含逆向使用；
- 空集子集解释为空真，没有虚构空集中的见证；
- 集合运算均相对于固定论域，补集没有脱离论域；
- 两条德摩根律的通常数学结论相同成立，但构造性／经典证明边界分开说明；
- 复合保持单射和满射只写正向，并为逆向误读给出限制；
- 双射刻画要求同一个逆函数同时满足左右逆；
- 原像不要求逆函数存在，并与整体像、子集像明确区分；
- 只把原像保二元并、二元交列为 verified；任意族版本明确标作出版背景；
- 商判等写成双向等价，商映射只称满射、不称单射；
- 商点与具体等价类子集的对象层级明确区分；
- 拓扑与实数只作为已经验收的真实下游，不声称推出完整理论；
- ROADMAP 中未完成的选择等价、独立性及高阶商结构只列入未声称内容。

## 七　写作中发现并修正的问题

1. 初始提纲容易把“一般关系”和“函数定义”写成库内已验收定义；核对 Registry 后发现没有相应
   独立 Entry，现已在正文与来源账中明确降为出版背景。
2. 初始叙事容易把 (f^{-1}) 同时用作原像和逆函数而不加区分；现统一对集合使用方括号，并明确
   原像不要求双射。
3. 初始跨学科连接可能把“原像保并、保交”误写成连续性的充分条件；现明确指出这些等式对任意
   函数成立，连续性另要求开集被拉回为开集。
4. 初始商集叙述可能把“等价类是子集”和“商元素是点”混成一个对象层级；现分别说明具体实现
   与抽象使用位置。
5. Entry 文档中有“像只保并不保交”的教学性概括；正文将其收窄为“像一般不保交”，并明确这
   只是边界解释，不冒充新的 verified Entry。
6. `topology.foundation.structure` 的 Entry 文件 front matter 仍显示旧 staging 状态，而事实截止
   Registry 已为 verified。章节以 Main Registry 与当前源码为事实源；这一陈旧文档状态留给 Main
   判断是否另开维护，不在本批越权修改。
7. 新增情景框时，初稿可能让角色对话承担定义本身；现已按 Main `2283535` 的规范把四段放在正式
   定义或结论之后，并逐段写明原创性质、数学作用及类比停止适用的位置。
8. 文字 review E1 指出关系定义依赖尚未首现的有序对和笛卡尔积；§4.1 已补两者的角色、逐元素
   定义和次序边界，不展开不需要的集合编码。
9. 文字 review E2 指出二元原像公式无提示跳到任意并、有限交；§6.2 已新增任意指标族公式及逐元素
   解释，明确其是出版背景，§7.1 同步区分核验地位。
10. 文字 review E3 指出像／值域／陪域可能漂移；现固定“陪域 $Y$—整体像 $f[X]$—子集像
    $f[A]$”三层术语，并停用含义易歧的“值域”。
11. 文字 review E4 指出审计声线打断正文；具体公理审计已集中到 §8，概念段只保留普通数学语言。

## 八　等待独立审稿的边界

作者自查不能替代 `REVIEW-PROTOCOL.md` 的独立审核。数学轮已经 `accepted`；本轮返工后仍需：

1. 原文字审稿人复验 E1–E4，确认有序对／笛卡尔积首现、任意族背景分层、像术语和审计声线已经
   闭环；另由非作者审阅纳西妲、莫娜 ROLE 及新版场景，砂糖、艾尔海森、卡维仍待建 ROLE；
2. Main 核对事实截止提交与当前 Main 的差异、18 个 Entry 状态、citation key、链接和跨章一致性；
3. F-01 的精确书目定位保持 deferred R3，不得用未核对页码换取表面闭环；
4. 所有 finding 必须有 `resolved`、`declined with reason` 或 `still blocked` 的处理记录。

在这些步骤完成前，本章保持 `draft`，不得进入 `accepted` 状态，也不得被目录描述成正式验收章节。

## 九　验证

仓库当前没有 `scripts/check_docs_links.py` 或其他专用链接检查器，因此实际扫描本批涉及文件中的
Markdown 链接；本轮新增的两个 ROLE 与改写场景没有引入本地 Markdown 链接，也没有链接尚未创建
的后继章节。

另以只读 Registry 检查逐一验证本章 18 个 Entry id：全部存在、`state` 均为 `verified`，对应
Lean 文件与 Entry 文档路径均可解析。最后运行：

```text
git diff --check
```

结果无输出并以成功状态结束。本批不把局部检查冒充全库文档链接审计；全库一致性仍由 Main 第三轮
验收负责。

## 十　下一批稳定依赖

独立审稿接收 WF1-01 后，下一批可以稳定回指本章的集合外延性、子集、函数、原像与商集术语。
在此之前，下一章可以研究或起草，但不得把本章状态写成 `accepted`。
