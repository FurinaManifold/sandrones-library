# 正式章节目录

本目录只收录已经进入 WF 正式批次的章节。卷册骨架见上级 [`README.md`](../README.md)，批次状态见
[`ROADMAP-LONGTERM.md`](../../ROADMAP-LONGTERM.md)。没有通过双重审核的研究草稿不得放进本目录。

## 章节头

每章开头使用以下纯文本元信息；它不是 Registry front matter，也不创建新的 Entry：

```text
状态：draft | mathematical_review | editorial_review | accepted
事实截止：Main <commit>
前驱章节：<chapter links>
覆盖条目：<verified Entry ids>
出版来源：<reference.bib keys>
数学审稿：<review record>
文字审稿：<review record>
```

## 章节正文顺序

1. 本章的问题；
2. 概念怎样生长；
3. 精确定义与关键例子；
4. 核心结果及其思想；
5. 与前后学科的连接；
6. 已核验范围；
7. 本章没有声称什么；
8. 来源账。

这不是僵硬的八段模板；作者可以为了叙事调整小节，但八类信息不能缺失。正文保持纯自然语言和
通常数学记号，不插入 Lean 代码、tactic 或 proof state。
