# Topology handoff：T4-R3b-A PiecewiseC1 dyadic alignment

## Scope and gate

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`，同步合并提交 `55cc854`；
- direct foundation: shared square-grid extraction commit `16c9041`；
- permission: `main-961f4a6-permissions-expanded.md`，A 为 `development_open`；
- Entry: `topology.homotopy.piecewise-c1-dyadic-alignment`。

本批新增一个 Lean 模块、一篇 Entry 和本 handoff；不修改既有 `PiecewiseC1` 定义，也不修改
`SandronesLibrary.lean`、Registry、ROADMAP、RADAR、Playbook 或生成文件。

## Mathematical result

既有 `Path.PiecewiseC1` 是由整体 C1、Mathlib 中点拼接和端点 cast 生成的 Prop。新
`Path.DyadicC1AtDepth gamma n` 记录同一拼接树已对齐到深度 `n`。公开接口给出：

1. 深度单调加细；
2. 忘记深度得到原 `PiecewiseC1`；
3. 每个 `PiecewiseC1` 证明存在某个 dyadic 深度；
4. 深度 `n` 的每个 `2^n` 网格小段仍 `PiecewiseC1`；
5. 同伦方形上下常值外边和左右端道路 dyadic 小段的四条正则性桥。

不声称任意实断点 subpath 闭合，也不从 Prop 计算最小深度。

## Concept inventory and public signature

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 分段 C1 道路 | 有限条 C1 道路的拼接 | 既有 `Path.PiecewiseC1` | 原三个构造子 | 本库既有正式谓词 | depth recovery | 前提 Entry |
| dyadic 对齐深度 | 所有拼接断点落在共同 `2^-n` 网格 | `Path.DyadicC1AtDepth` | `piecewiseC1` / `exists_dyadicC1AtDepth` | 新 Prop 证书，不替换 carrier | segment theorem | 本 Entry |
| 对齐小段 | 网格相邻点间的子道路 | Mathlib `Path.subpath` | `dyadicSegment_piecewiseC1` | 语义一致正式运算 | raw grid | 本 Entry |
| 同伦方形外边 | 两端道路及两条端点常值道路 | shared square-grid `Path` | 四条 PiecewiseC1 桥 | `Path.Homotopy` 为正式承载 | R3b-F | 本 Entry |

公开签名中的 `Path`、`Path.subpath`、`Path.Homotopy`、`ContDiffOn`、`NormedAddCommGroup` 和
`NormedSpace` 均与教材语义一致并已在本 Entry 或 premise Entry 解释。没有有限维、完备或复结构
泄漏。私有实现使用 affine 参数恒等式、`fun_prop`、`linarith`、`nlinarith`、`omega` 与 cast 搬运，
没有公开新的实现类型。

## Definition-chain and ownership audit

mapper 将唯一 Entry 精确映射到 10 项公开声明，包括核心 `inductive`，并跳过所有 private helper。
聚合验收同时检查正式道路承载、新证书、两个方向桥、网格小段定理、四条方形外边桥和后续消费者。
仓库扫描确认所有新名字无碰撞；模块没有 instance、notation、coercion 或 simp 属性修改。

这是对既有 verified Entry 的 M1 兼容扩展：原源码、构造子与所有公开定理均未修改。回滚只需移除
新线性模块及其后续 R3b 消费者，不需要兼容 alias 或迁移现有调用方。

## Verification

已执行：

- `lake build SandronesLibrary.Topology.PiecewiseC1DyadicAlignment`：2124 jobs，通过；该目标包含本批
  模块的完整依赖闭包，当前 Main 中尚无更高层正式消费者；
- `/tmp/PiecewiseC1DyadicAlignmentAggregate.lean` 同时检查 Mathlib 正式承载、既有 `PiecewiseC1`、
  新证书、两个方向桥、小段定理与四条方形外边消费者，通过；
- mapper 精确得到 1 Entry / 10 public declarations，包括核心 `inductive`；
- 八项代表性公开声明的公理均为 `[propext, Classical.choice, Quot.sound]`；
- placeholder、新 axiom、instance、notation、全名碰撞、冲突标记和 `git diff --check` 扫描通过。

## Honest boundary

本批只建立 dyadic 对齐的正则性证书。它不定义道路积分，不证明二维同伦内部格边分段 C1，也不证明
同伦不变性。后续 B/C/D/E/F 仍按 Main 门独立提交；禁止由本结果恢复全局 relative-`C²` 方形假设。
