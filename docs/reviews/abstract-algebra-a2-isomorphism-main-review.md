# Main review: abstract algebra A2 ring isomorphism theorems

- branch: `codex/abstract-algebra`
- reviewed_commits: `c799118`, `fb4296c`
- reviewed_tip: `fb4296c`
- reviewer: main
- verdict: needs_changes
- reviewed_at: 2026-08-25

## 已通过

- `RingIsomorphism`、核、像、第一同构、商环理想对应和第三同构均使用本库
  `RingHomomorphism`、`TwoSidedIdealSet` 与显式 `quotientRingSet`，没有以 Mathlib
  `RingEquiv`／`Ideal.Quotient` 冒充教材主接口。
- 第一同构和第三同构均给出代表元公式；理想对应明确限制原环理想包含核，满射像的前提也完整。
- 条目没有声称已完成第二同构定理；标题、summary 与现有 Lean 强度一致。
- `RingIsomorphismTheorems` 定向构建通过（8708 jobs）；教材文档精确八段，无禁用占位，
  `git diff --check c799118^..fb4296c` 通过。

## 必须返工

### R1. 两个局部环实例的定义被注册成了全局实例

- `quotientRingSetRing` 与 `ringHomRangeRing` 使用 `@[instance_reducible] def`，随后又声明
  `attribute [local instance] ...`。
- `instance_reducible` 本身已经是全局实例属性；后面的 local attribute 不能撤销此前全局注册，
  与“只在本文件组装标准环结构”的意图不符，也可能让其他模块通过实例搜索意外选择这些构造。
- 期望结果：两个定义都改成普通显式 `def`；若 Lean 提示 class-definition reducibility 风格警告，
  只在定义处局部使用 `set_option warn.classDefReducibility false in`。保留现有
  `attribute [local instance]`，不得新增其他自动实例。
- 验收：扫描文件无 `@[instance_reducible]`，定向构建和第一／第三同构聚合 `#check` 通过。

### R2. 本批没有 handoff，Main 无法安全集成

分支中没有对应 `abstract-algebra-a2-...isomorphism...md` handoff。必须新增 handoff，至少列出：

- 精确接收顺序 `c799118`, `fb4296c` 及 R1 返工提交；
- 新源码、八段文档、Entry id、顶层 import、Registry、RADAR 与 ROADMAP 建议；
- 本库定义与 Mathlib 后端边界、联合导入关键 `#check`、剩余未完成的第二同构定理；
- 明确不得合并整个长期分叉分支，只可 cherry-pick 本窗口。

### R3. 新 Entry 与历史 `abstract-algebra.ring.iso` 的关系未说明

Main 已有 `abstract-algebra.ring.iso`，当前新文档使用 `abstract-algebra.ring.iso-theorems`。两者都
涉及第一同构定理，但新条目进一步承担本库定义迁移、理想对应和第三同构。

handoff 与 `DEFINITION-AUDIT.md` 必须明确：旧 id 是 Mathlib 兼容接口还是待迁移历史条目；新 id
为何是更宽的课程入口；Registry premises／`dependedOnBy` 如何避免两个 id 被描述成同一成果。
不要求把两个 Lean 文件强行挂到同一 Entry，也不得静默删除旧公开接口。

## 审核边界

- 本 review 只覆盖 `c799118`, `fb4296c`；A1 历史迁移及后续整除、PID/UFD 不在范围。
- 不修改 Main 共有文件；返工与 Git 内 review 先在学科分支提交。

## Round 2: 返工复验与教材定义硬门

- reviewed_commit: `12ad82b64536b35fe2a03c949a0fff73afe697ac`
- reviewer: `main`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

### 原 R 项核销

- `RingIsomorphismTheorems.lean` 中商环与像环结构已改为普通定义配合 `local instance`，不再污染
  全局实例搜索；实例作用域问题关闭。
- handoff、Entry 关系说明、定向构建（8708 jobs）、占位扫描与差异检查证据齐备。

### R4. 新教材定义硬门证据不完整

`docs/handoffs/abstract-algebra-a2-ring-isomorphism.md` 尚无逐概念六列表，也没有把公开签名中的
Mathlib 专用结构／class／Prop 逐项归入四类；聚合 `#check` 只覆盖最终定理，没有同时组装本库
定义、一手性质、桥和上层使用者。请按最新 Subject Maintainer ROLE 补齐并提交。

### R5. 核心声明被当前审计器漏审且未披露

当前 `map_entry_to_decl` 漏掉 `structure RingIsomorphism`、`structure TwoSidedIdealCarrier`、带属性的
`quotientRingSetRing`／`ringHomRangeRing` 以及 `noncomputable def`。后续定理被审计不能替代这些核心
定义被审计。请修正声明识别，或逐项列为 Main-side 集成门；随后给出 Entry 唯一映射证据。

### 要求重跑的验证

重跑目标模块闭包、完整定义链聚合 `#check`、声明映射、公理检查、audit、占位扫描和
`git diff --check`，并把本轮原文与处理记录复制进 Git 内 review。

## 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R1 实例作用域 | resolved | `a40754d`：全局实例改为普通定义加局部实例。 |
| R2 handoff | resolved | `12ad82b`：已提交 ring-isomorphism handoff。 |
| R3 Entry 角色 | resolved | `12ad82b`：已说明旧兼容 Entry 与新课程 Entry 的边界。 |
| R4 定义硬门证据 | resolved | 本返工提交：handoff 新增完整六列表、公开签名四类扫描与五条定义链聚合证据。 |
| R5 声明映射 | resolved | 本返工提交：审计器识别结构、属性前缀和声明修饰符；唯一映射 26 个声明且逐项公理探测成功。 |

## Round 2 返工验证记录

- `lake build SandronesLibrary.AbstractAlgebra.RingIsomorphismTheorems`：8708 jobs 通过。
- `/tmp/check_ring_iso_definition_chain.lean`：完整定义、一手性质、承载桥边界与上层使用者全部
  `#check` 通过；五个关键公理查询通过。
- `map_entry_to_decl`：Entry `abstract-algebra.ring.iso-theorems` 唯一映射 26 个不同声明；26 项
  `probe_axioms` 均成功解析。
- 新 Entry 预登记 audit 通过；共享 Registry 尚无 staged quotient 与新 Entry，须由 Main 登记后
  重跑正式单 Entry audit。全量既存 Registry audit 仅报告已知的
  `abstract-algebra.group.product` 文件头问题，与本窗口无关。
- 正式源码无 `sorry`、`admit`、`sorryAx`、`native_decide`，无 `@[instance_reducible]`；
  `git diff --check` 通过。

## Main 最终集成复验

- integrated_tip: `e35f179`
- verdict: `accepted`
- main_reviewed_at: 2026-08-25

第一、第二、第三同构、理想对应、代表元公式和 45 项声明公理探测均通过。Main 已补充
`SubringCarrier` 基础全局实例与局部完整 `Ring` 实例的边界，并使用 `76d770f` 的通用审计器。
