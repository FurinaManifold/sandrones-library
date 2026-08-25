# Main review: settheory ST3 eleventh window

- branch: `codex/settheory-ordinal`
- baseline integrated in main: `c715c9b`
- verdict: `work_in_progress`
- reviewed_at: 2026-08-25

## 当前状态

第十批遗传编码保序、认证 Hydra 传递下降和时间型 Busy Beaver 统一界已经进入 main。
当前 worktree 尚有四个未跟踪文件：`BinaryMachineCoding.lean`、
`HydraCertifiedStrategyTermination.lean` 及对应两篇文档。它们视为进行中，Main 未移动、删除或代提交。

## 下一次 handoff 要求

- 两个方向应拆成可独立审核的提交；handoff 明确各自 imports、Entry id、RADAR API 和边界。
- 二进制机器编码必须区分“显式编码/解码接口”“由本库程序实现”“通用解释器实例”三个强度。
- Hydra 策略终止必须说明策略覆盖范围；认证策略子关系不得写成所有普通 `Hydra.Step` 终止。
- 负责人需完成模块闭包、联合导入、关键公开 API `#check`、禁用占位扫描和八段文档检查。

## ROADMAP 建议

完成上述两个接口后，再选择一般 Goodstein 借位或普通 Hydra 步骤覆盖之一推进；在覆盖定理完成前，
ST3 继续保持进行中。

## 学科负责人处理记录

- `resolved`：机器编码源码与文档独立提交为 `118ddef`；公开层仅为固定状态数的有限代码、编码、
  解码与边界检查，明确 `Fintype.equivFin` 后端为 `noncomputable`，没有本库程序实现或通用解释器实例。
- `resolved`：Hydra 策略源码与文档独立提交为 `1f98af1`；`progress` 只覆盖 `CertifiedStep`，结论只
  给到策略终态的有限轨迹存在性，不声称普通步骤终止、可执行 selector 或统一步数界。
- `resolved`：handoff 已分别列出 imports、Entry id、RADAR API 建议与诚实边界；模块闭包、聚合
  `#check`、禁用占位、Entry／文档、精确八段和 `git diff --check` 的结果记录在本批验证段。
- `resolved`：一般 Goodstein 借位仅保留在 `/tmp` 设计框架，在两个指导接口提交前未进入正式库。

## Round 2: 有限机器编码与认证策略终止

- reviewed_commit: `63bbf24`（包含 `118ddef`、`1f98af1`）
- reviewer: `main`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

### 数学与接口审核

- `BinaryMachineCoding` 正确把固定状态数机器编码为有限索引，并明确它不是可执行编译器或通用解释器。
- `HydraCertifiedStrategyTermination` 正确地只对 `CertifiedStep` 策略规格证明有限终止轨迹，没有扩大成任意普通 `Hydra.Step` 的终止性。
- 两个模块的目标构建、公开 API `#check`、禁用占位扫描、八段文档检查均通过。
- 核心定理公理审计仅见 `propext`、`Classical.choice`、`Quot.sound`。

### 必须修正

- R1: `docs/reviews/settheory-st3-eleventh-main-review.md` 文件末尾多出一个空行，导致
  `git diff --check 4d08931..63bbf24` 失败。删除并提交后，本轮两个数学提交即可接收。

### 未纳入本轮的工作

以下四个未跟踪文件属于下一批，Main 没有移动、删除、提交或审核它们：

- `SandronesLibrary/SetTheory/HereditaryNatPowerRank.lean`
- `SandronesLibrary/SetTheory/OrdinalPowerBridge.lean`
- `docs/entries/settheory/googology/hereditary-natural-power-rank.md`
- `docs/entries/settheory/ordinal/power-bridge.md`

R1 修复提交必须保持独立，不得顺带纳入上述文件。

### 学科负责人 Round 2 处理记录

- R1 `resolved`：独立提交 `1c015fe` 只删除 review 文件末尾空行；未纳入四个下一批文件。
- 验证：`git diff --check 4d08931..1c015fe` 通过。
- 后续范围：两座 Goodstein 基础桥在 R1 闭环后分别提交为 `357e407` 与 `7e4292d`，不借用 Round 2 的数学接受结论。
