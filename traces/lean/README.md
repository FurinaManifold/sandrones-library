# `traces/lean/` — Lean 验证轨迹语料

本目录存放**底层 Agent 做 Lean 验证时的原始过程记录**，用作 LLM 训练语料。
规范见 `docs/LEAN-PLAYBOOK.md` §8；交付门见 `AGENTS.md` §7 第 8 条。

- 布局：`traces/lean/<subject>/<task-id>.jsonl`
  （`<task-id>` = Entry id，或原型阶段的工作项名）。
- 格式：JSON Lines，每行一条尝试，schema `sandrones-lean-attempt/1`。
- 写入：`python3 scripts/lean_trace.py append --file <path.jsonl> --record <record.json>`
- 校验：`python3 scripts/lean_trace.py check traces/lean/<subject>/`
- 统计：`python3 scripts/lean_trace.py summary --subject <subject>`

**三条铁律**（摘自 Playbook §8）：

1. **边做边写**：每次把 tactic 块交给编译器之后就追加一条，禁止事后凭记忆重建。
2. **失败也留**：`outcome=error` 的记录是语料的主要价值，只留成功轨迹等于自欺。
3. **不写敏感信息**：令牌、凭据、仓库外绝对路径一律不得进入本目录。

本目录属学科自有，随学科分支提交；Main 只统计与复核质量，不代写轨迹。
