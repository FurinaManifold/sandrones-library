# AGENTS.md — 给接手模型的交接文档

> 本文件是**给下一个 AI 模型的工作交接**。读完本文件 + 下面列出的核心文档，
> 你就能无缝接手这个项目。请严格遵循本文件的工作纪律。

## 项目是什么

**Sandrone's Library**：一个"LLM 友好且绝对严格"的数学库。以 mathlib4 为地基，
把**人类思维脉络**（教材层）、**机器可验证的 Lean 形式化**、**双语解释**绑定为
一条条可增量扩展的"事实条目"。**编译器是唯一裁判**。

- 形式化层：`SandronesLibrary/`（Lean 源码，机器可校验）
- 叙述层：`docs/entries/`（每条目的中文解释 + 思维脉络）
- 元数据：`index/registry.json`（依赖图 / 来源 / 状态 / 公理）
- 家族前缀：`analysis.*`、`linear-algebra.*`、`abstract-algebra.*`、`topology.*`、
  `real-analysis.*`、`settheory.*`

## 当前进度（截至交接）

**已验证条目 160 条**，分布：

| 阶段 | 完成情况 |
|---|---|
| **数学分析第一学期** | ✅ 完整（M1 序列 → M5 中值定理） |
| **线性代数第一学期 L1-L4** | ✅ 完整（向量空间/线性映射/行列式/特征值） |
| **抽象代数第一学期 A1-A3** | ✅ 完整（群/环/多项式环） |
| **点集拓扑 T1-T3** | ✅ 完整（拓扑空间/紧致/度量） |
| **数学分析第二学期（测度积分线）** | 🔶 大部分完成（R1 测度/R2 可测函数/R3 收敛定理/R5 微积分基本定理/R5.5 黎曼积分全套） |
| **R5.5 黎曼积分的 Lebesgue 判据** | ⏳ **待续**（黎曼可积 ⟺ 几乎处处连续） |
| **R4 乘积/Lᵖ、R6 多元微积分** | 🔲 待做 |
| **第二学期抽象代数 A3.3-A3.4/A4** | 🔲 待做 |

详见 `docs/ROADMAP-LONGTERM.md` 进度表和 §9。

## 环境与命令

```bash
# 环境：Lean 4.33（lean-toolchain 指定），mathlib4
export PATH="$HOME/.elan/bin:$PATH"
lake build                 # 构建（增量）
lake env lean <file>.lean  # 单文件编译（快速验证）
python3 scripts/audit.py   # 一致性审计（条目 vs 文件 vs 叙述层）
python3 scripts/check_axioms.py --all --fix   # 公理审计（增量，秒级）
python3 scripts/check_axioms.py --all --full  # 公理审计（全量，约50秒）
```

**重要**：改完 `.lean` 后如果外部 `#check` 报 unknown identifier，
先 `rm -f .lake/build/lib/lean/SandronesLibrary/**/*.olean` 再 `lake build`（§1.3 增量缓存坑）。

## ⚠️ 工作纪律（必须遵守，写在 Playbook 顶部）

**大定理必须用"带 sorry 框架法"**：
1. 先立完整定理，内部所有前置引理/子证明用 `sorry` 占位。
2. **每个 sorry 单独列成一个 todo**，逐个解决后填回框架（替换 sorry）才算完成。
3. 组装 = 填元件，不是新证明。中途冒出框架外的新引理 ⟹ 停下补框架，新引理也列成 todo。
4. 禁止带 sorry 提交。

其他铁律：
- **5 次试错法**：同一证明试错 ≥ 5 次 ⟹ 停止盲试，拆成子 todo（带 sorry 框架）。
- **一次 edit 只喂一条引理**，每轮编译通过再下一条。
- **成功即写教训到 Playbook**（§2 意图↔tactic 映射 或 §5 实战教训日志）。
- **命名先查是否撞 mathlib**，加独特前缀（如 `topo_`、`metric_`、`meas_`）。
- **含 |·| 的 goal 不要直接 linarith**（§2.7.0）：先 `abs_le.mp`/`abs_lt.mp` 展开。
- **sSup/sInf 用条件完备版**（csSup_le/le_csInf，§2.7.2），ℝ 不是 CompleteLattice。
- 遇到 `exact` 不匹配先 `exact?` 问编译器（§1.1）。

## 如何新增一个条目（纳入协议）

1. 在对应 `.lean` 文件头注释更新"本文件当前条目"清单。
2. 定义/定理加 docstring，末尾带 `> **Entry**: <家族.子域.名称>`。
3. 编译通过后注册：`index/registry.json` 加记录（含 proof_sha、axioms）。
4. 写叙述层 `docs/entries/<家族>/<子域>/<名称>.md`。
5. 补 RADAR：`docs/MATHLIB-RADAR.md`（每个用到的 mathlib 名登记"谁在用"）。
6. `check_axioms.py --all --fix` + `audit.py` 全过。

完整流程见 `docs/INGESTION_PROTOCOL.md`，字段规范见 `docs/SCHEMA.md`。

## 核心文档速查

| 文档 | 用途 |
|---|---|
| `docs/LEAN-PLAYBOOK.md` | **最优先读**。顶部"⚠️ 最核心方法论"（带 sorry 框架法/5 次试错）+ §0 工作流 + §2 意图↔tactic 映射 + §4 转正/瘦身方法论 |
| `docs/ROADMAP-LONGTERM.md` | 长远批次规划 + 进度表 + 学期分界 + 瘦身维护（§8.2）+ 论文下沉（§8.3） |
| `docs/INGESTION_PROTOCOL.md` | 纳入协议（新增条目的五步流程） |
| `docs/SCHEMA.md` | 条目字段规范 |
| `docs/MATHLIB-RADAR.md` | mathlib 名登记（人话解释 + 谁在用） |
| `docs/DESIGN.md` | 架构设计理念 |

## 当前待办（建议顺序）

1. **`real-analysis.riemann.lebesgue-criterion`**（黎曼可积 ⟺ 几乎处处连续）：已排期。
   mathlib 有 `oscillation f x : ENNReal`（振荡），但无"振荡=0 ⟺ 连续"现成引理，需自证桥。
   用带 sorry 框架法。这是黎曼积分批次的收官。
2. **R4 乘积/Lᵖ**：乘积测度、Fubini/Tonelli、Lᵖ 空间与完备性。
3. **R6 多元微积分**：重积分/换元/曲线曲面积分/Green-Gauss-Stokes。
4. **第二学期抽象代数**：A3.3 域扩张/Galois、A4 模。
5. **瘦身维护**（持续）：按 Playbook §4.1 扫"证明体直接 exact mathlib"的条目，改本库推导。

## GitHub

- 仓库：`FurinaManifold/sandrones-library`
- 凭据：`gh` 已认证（令牌在 `/home/pisquare/czt/github_authkey.txt`，格式 `username:<用户>\nAccess token:<ghp_...>`）
- 提交信息风格：`"<阶段><批>: <主题>（<N> 条）+ 注册/RADAR"` 或 `"瘦身批次N: <条目>"` 等
- 只在你被明确要求时才 push/commit