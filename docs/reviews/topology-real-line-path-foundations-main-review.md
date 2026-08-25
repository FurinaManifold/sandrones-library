# Main review: topology real line and path foundations

- branch: `codex/topology-foundations`
- reviewed_commits: `1bfe5fa`, `07c8057`, `a9aa0d7`
- reviewed_tip: `a9aa0d7`
- reviewer: main
- verdict: needs_changes
- reviewed_at: 2026-08-25

## 已通过

- `realLine` 从 ε-邻域直接定义，`UnitInterval` 由本库子空间拓扑构造；核心模块不导入
  `MathlibBridge` 或 Mathlib `Path`。
- `Path` 携带本库连续性和端点数据；常值道路、连续映射下的像、参数反射、逆道路与双重反向
  的数学定义和端点方向正确。
- 三模块联合构建通过（780 jobs）；三篇文档均为精确八段，无禁用占位，
  `git diff --check 29d6217..a9aa0d7` 通过。
- 完整道路拼接、道路代数和同伦尚未完成，foundation 命名与 ROADMAP 施工边界诚实。

## 必须返工

### R1. 逆道路 Entry 当前没有任何 Lean 声明归属

- `Path.lean` 只有 `topology.homotopy.path-definition-foundation` 标记；新增 `Path.symm`、
  `symm_apply`、`symm_symm` 因而被审计器继续归入道路定义条目。
- `topology.homotopy.path-reversal-foundation` 只存在于 Markdown，没有源码 Entry 标记。
- 期望结果：在 `Path.symm` 前添加 reversal foundation 标记，使逆道路三个声明归入新 id，并用
  `map_entry_to_decl` 复核两个 path id 不交叉。

### R2. reversal 文档跨越两个 Lean 文件，不符合单文件公理审计契约

当前 reversal 的标题和 summary 同时把 `RealLine.lean` 中的实数／区间反射与 `Path.lean` 中的
逆道路算作一个 Entry；但 Registry 一条记录只能指向一个 `lean_file`。

建议保持现有文件边界：

- 实数反射、区间反射与连续性继续归 `topology.foundation.real-line`；
- `topology.homotopy.path-reversal-foundation` 只负责 `Path.symm` 及双重反向，premise 依赖
  `topology.foundation.real-line`；同步收窄标题、summary 和八段正文。

### R3. `structure Path` 尚不在公理审计器的声明集合中

源码已把 Entry 标记放在 `structure Path` 前，但当前 `scripts/check_axioms.py` 的声明正则只识别
`theorem|lemma|def`，所以核心 `Path` 结构本身不会被审计。这是 Main 基础设施门，不要求学科负责人
修改共享脚本；但学科 handoff 必须显式记录该门。Main 在集成前需扩展审计器识别 `structure`，
再对 path definition 强制重审，不能只审计后续 `ext/refl/map`。

### R4. 三份 handoff 缺少成果提交号和统一接收顺序

返工后在 handoff 中写出唯一顺序：`1bfe5fa`, `07c8057`, `a9aa0d7`, R1/R2 文档返工提交；明确
基础结构批次已在 main，且完整 `topology.homotopy.path-loop` 仍为施工中。不得把整个分支区间
当作已审核范围。

## 审核边界

- 本 review 只覆盖 tip `a9aa0d7` 及上述三个提交。
- 不审核道路拼接、同伦、同伦等价或基本群。
- 不修改 Main 共有 imports、Registry、RADAR、ROADMAP 或审计脚本。

## 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R1 reversal Entry | resolved | `f5e9a71` 添加独立 Entry；映射结果含三个逆道路声明。 |
| R2 单文件归属 | resolved | `f5e9a71` 收窄文档；reversal 只对应 `Path.lean`。 |
| R3 structure 审计门 | still blocked | Main-side gate；已在 path definition handoff 显式记录。 |
| R4 精确接收顺序 | resolved | 三份 handoff 统一为 `1bfe5fa`, `07c8057`, `a9aa0d7`, `f5e9a71`。 |

### 学科负责人返工验证

- `map_entry_to_decl` 结果：path definition 只含 `Path.ext/refl/map`；path reversal 只含
  `Path.symm/symm_apply/symm_symm`，两个 id 不交叉。
- `lake build SandronesLibrary.Topology.Path` 通过（780 jobs）；reversal 文档保持精确八段；源码无
  禁用占位；`git diff --check` 通过。
- 完整 `topology.homotopy.path-loop` 仍为施工中；`fb66c80` 不在本 review 接收范围。

## Round 2: 返工复验与教材定义硬门

- reviewed_commit: `fdb6367f941eb6a5ebb232f01da2c3e3bfec89c8`
- reviewer: `main`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

### 原 R 项核销

- `f5e9a71` 已让 reversal Entry 只覆盖 `Path.symm`、`symm_apply`、`symm_symm`，不再跨文件或吸入
  definition Entry；R1、R2 可以关闭。
- 三份 handoff 已给出接收顺序，Path 与 RealLine 定向构建（780 jobs）、占位扫描和差异检查通过；
  R4 可以关闭。`fb66c80` 明确排除在本轮之外，Main 不随本窗口接收。

### R3. `Path` 定义审计门仍未关闭

`structure Path` 仍不被当前 `map_entry_to_decl` 识别。Git 内 review 虽已诚实标为 `still blocked`，
但在修正审计器或完成明确的 Main-side 可执行门以前，本窗口不能 accepted。

### R5. `Loop` 与新硬门证据缺失

`abbrev Loop` 同样未被声明映射识别，而 handoff 只披露了 `structure Path`。三份 handoff 还缺逐概念
六列表、公开签名 Mathlib 四类扫描，以及“定义 -> 一手性质 -> 桥 -> 上层使用者”的完整聚合
`#check`。请补齐 `Path`、`Loop`、逆道路和实直线道路相关概念的证据，并明确哪些 Mathlib 名称只是
承载或桥。

### 要求重跑的验证

重跑 Path／RealLine 闭包、完整定义链聚合、声明映射、公理检查、audit、占位扫描与
`git diff --check`，并把本轮原文及处理记录复制进 Git 内 review。

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R1 reversal Entry | resolved | `f5e9a71`：逆道路声明进入独立 Entry。 |
| R2 单文件归属 | resolved | reversal 文档与声明已收敛到 `Path.lean`。 |
| R3 structure 审计门 | pending | `Path` 仍未被映射；并新增未披露的 `Loop` abbrev 门。 |
| R4 精确接收顺序 | resolved | `fdb6367` 已同步三份 handoff；排除 `fb66c80`。 |

### 学科负责人 Round 2 处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R3 structure 审计门 | still blocked | Main-side gate：共享审计器仍不识别 `structure`，学科分支不修改共享脚本。 |
| R5 Loop 声明映射 | resolved | `a353558` 将透明 `abbrev Loop` 改为透明 `def Loop`，并新增 `loopRefl`。 |
| R5 概念与签名证据 | resolved | 三份 handoff 已补概念六列表、Mathlib 四类扫描和定义链聚合证据。 |

### Round 2 返工验证

- `RealLine`／`Path` 闭包构建通过（780 jobs）；完整聚合文件同时 `#check` 实直线、单位区间、
  反射、`Path`、`Loop`、逆道路及其一手性质和真实使用者。
- 声明映射现将 `Loop/loopRefl` 放入 path definition，将三个逆道路声明放入 reversal；`structure
  Path` 仍未识别，且带点声明 `UnitInterval.reflect` 被当前正则截断，二者均诚实列为 Main-side gate。
- 手工 `#print axioms` 覆盖 `Path.ext`、`Loop`、`loopRefl`、`Path.symm_symm`；`audit.py` 通过
  （385 entries）；禁用占位和公开 Mathlib 拓扑泄漏扫描通过；`git diff --check` 通过。

## Main 最终集成复验

- integrated_tip: `f4ef4c5`
- main_gate_commit: `76d770f`
- verdict: `accepted`
- main_reviewed_at: 2026-08-25

Main 审计器现能识别 `structure Path`、`def Loop` 和 `UnitInterval.reflect` 等带点声明；RealLine、
Path、Loop 与逆道路的定义链和公理探测均通过，原 Main-side gate 已关闭。
