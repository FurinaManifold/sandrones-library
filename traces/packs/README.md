# `traces/packs/` — 派工上下文包

派子 Agent 之前，由学科负责人用 `scripts/context_pack.py build` 生成，提交到本目录：
`traces/packs/<pack_id>.json`（schema `sandrones-context-pack/1`）。规范见
`docs/LEAN-PLAYBOOK.md` §9；交付门见 `AGENTS.md` §7 第 9 条。

- **唯一手写字段**是 `task.goal_nl`。其余字段（可写/只读路径、前提闭包、冻结签名、
  Playbook 必读节、预算与升级条件）都由脚本从 `AGENTS.md` §3、`index/registry.json`、
  原型 Lean 文件与 `docs/LEAN-PLAYBOOK.md` 推导，负责人不得手改。
- 包里存**指针**（路径、id、行号、哈希），不复制权威源内容。
- `pack_id` 是 join key：子 Agent 的每条 `traces/lean/**` 记录都要带同一个 `pack_id`，
  这样「给了什么上下文 → 试了什么 → 编译器回了什么」才是一条完整训练样本。

```bash
python3 scripts/context_pack.py build --subject analysis --batch AN-MV-R1 \
    --entry analysis.coordinate-integrals.mass-center --role sub-agent \
    --goal-nl "证明平行轴展开的逐坐标版本" \
    --out traces/packs/analysis-AN-MV-R1-analysis.coordinate-integrals.mass-center.json
python3 scripts/context_pack.py show  --pack traces/packs/<pack_id>.json
python3 scripts/context_pack.py check traces/packs/*.json
```

`subject_package.py` 会核对 trace 里引用的 `pack_id` 是否有对应的 pack 文件。
