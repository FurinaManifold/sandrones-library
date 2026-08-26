# 《水仙十字的世界式》审稿协议

## 为什么采用双重审核

Lean 文件的类型检查只能证明书稿引用的底层定理存在，不能证明作者没有写错方向、省略假设、混淆
概念或把远景写成现实。书稿必须同时经过数学事实审核和整体文字审核；两者不能由同一位章节作者
自批自收。

## 审稿材料

每个章节批次必须提交：

- 章节 diff 与事实截止 Main commit；
- 逐节来源账：Entry id、关键 Lean 声明、出版 citation key；
- 新增术语、符号、跨章链接和状态标签清单；
- 作者自查报告；
- 数学审稿与文字审稿的独立记录。

## 第一轮：逐断言数学审核

数学审稿人逐段检查：

1. **对象**：变量属于什么类型，对象是集合、元素、函数、商类还是结构；
2. **量词**：存在、任意、唯一、有限、可数和几乎处处是否被偷换；
3. **假设**：交换性、完备性、紧致性、连通性、选择公理等是否遗漏；
4. **方向**：充分、必要、等价、嵌入、满射和同构是否写反或写强；
5. **地位**：verified、出版背景、research 与 ROADMAP future 是否明确分开；
6. **来源**：每个实质断言能否落到当前 Entry/Lean 或合规出版来源；
7. **边界**：正文是否说明最容易被误读成更强结论的地方。

抽查不能代替逐断言核验。审稿记录必须引用章节行号或小节锚点，并写出依据的 Entry/声明；“看起来
没问题”不是证据。

## 第二轮：结构与出版编辑审核

由另一名审阅者检查：

1. 定义是否先于使用，符号是否首次解释；
2. 段落是否形成问题—概念—结果—联系的连续脉络，而非 Entry 摘要堆叠；
3. 同一术语、译名、记号和假设是否跨章一致；
4. 交叉引用是否真的帮助读者补足前驱，而不是循环链接；
5. 核验状态说明是否保持纯自然语言，是否避免 Lean 代码、tactic、proof state 和 API 清单化；
6. 人物情景是否服务数学，角色是否只是名字贴纸，类比失效处是否得到解释；
7. 人物情景是否为原创转化性内容，是否避免复制原作文本或伪造官方设定；
8. 是否有无依据的宏大叙事、历史断言、优先权断言或“显然”“容易”等遮蔽步骤的措辞；
9. 引文是否为改写和综合，是否避免长篇复制受版权保护的教材文本；
10. 是否诚实声明本书没有完整习题体系，不把参考书包装成可直接授课教材。

## 第三轮：Main 一致性验收

Main 不重新代写整章，而是核查：

- 事实截止 commit 与当前 Main 的差异是否影响结论；
- 来源 Entry 仍为 verified，citation key 可解析；
- ROADMAP 状态和章节完成语气一致；
- 章节链接、目录和术语首现位置有效；
- 两轮审稿问题均有 `resolved`、`declined with reason` 或 `still blocked` 处理记录；
- `git diff --check` 和仓库文档链接检查通过。

## 严重度与 verdict

- `R1 factual`：数学错误、假设缺失、方向错误、状态冒进或来源不存在；必须返工。
- `R2 structural`：定义顺序、跨章矛盾、关键联系缺失或叙事导致实质误解；必须返工。
- `R3 editorial`：译名、句法、重复、链接和版式问题；可由主编或 Main 直接修正。

最终 verdict 沿用仓库统一词汇：

- `accepted`：三轮完成，可进入正式书稿；
- `accepted_main_docs`：事实与结构通过，只剩 Main 目录／链接／版式整理；
- `needs_changes`：存在 R1 或 R2；
- `blocked`：来源或依赖门尚未满足。

纯文字“写得流畅”不能抵消 R1/R2；同样，只有 R3 时不得把整个章节退回数学作者。

## 审稿记录最小格式

```text
# World Formula review: <batch/chapter>
- fact cutoff: <main commit>
- author commit: <commit>
- mathematical reviewer: <role/worktree>
- editorial reviewer: <role/worktree>
- verdict: accepted | accepted_main_docs | needs_changes | blocked

## Findings
- [R1/R2/R3] <anchor>: <problem>；依据：<Entry/Lean/reference>；验收：<check>

## Resolution
- <finding>: resolved | declined with reason | still blocked；<commit/evidence>
```
