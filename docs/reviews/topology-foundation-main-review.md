# Main review: topology foundation structure and constructions

- branch: `codex/topology-foundations`
- reviewed_commits: `2e72907`, `73af3b4`, `29d6217`
- reviewed_tip: `29d6217`
- reviewer: main
- verdict: needs_changes
- reviewed_at: 2026-08-25

## 已通过

- `Foundation`、`Constructions`、`MathlibBridge` 定向联合构建通过（708 jobs）。
- `Foundation.lean` 没有导入 Mathlib 拓扑层；开集公理、闭集、邻域、连续与同胚均由本库
  `TextbookTopology` 定义，不是给 Mathlib 术语换名。
- 诱导拓扑、子空间拓扑和积拓扑的构造与连续性结论边界清楚，公开证明未使用禁用占位。
- `structure.md` 与 `constructions.md` 均为精确八段教材文档；源码 Entry id 与文档 id 对应。
- `git diff --check` 通过。

## 必须返工

### R1. Mathlib 桥被标记成实例，与文档和 handoff 的非全局桥承诺冲突

- 证据：`SandronesLibrary/Topology/MathlibBridge.lean` 中 `toMathlib` 使用了
  `@[instance_reducible]`。这是实例属性，不是单纯的可约化提示。
- 同一批 handoff 明确写着“桥不注册为全局实例”，`structure.md` 也告诫不要把桥声明成全局实例；
  当前源码因此与交付契约自相矛盾。
- 该属性对现有公开定理并非必要：`isOpen_toMathlib` 和 `continuous_iff_mathlib` 都已经显式写出
  `τ.toMathlib`。
- 期望结果：删去 `@[instance_reducible]`，保留普通的显式 `def toMathlib`；不要新增任何
  `TopologicalSpace X` 全局或局部自动实例来补偿。
- 验收方法：定向构建三个模块，并核对桥接定理仍通过；扫描确认 `MathlibBridge.lean` 不再给
  `toMathlib` 加 `instance` 类属性。

## 本次审核边界

- 本次只验收上述三个已提交 commit；后续 `RealLine` 与道路批次不在本次 verdict 内。
- 不要求改写已经通过的基础定义与构造证明，不借此扩写道路、同伦或基本群。
- 不修改 Main 共有 imports、Registry、RADAR 或 ROADMAP；仍只在 handoff 中提出接收建议。

## 要求重跑的验证

1. 构建 `Foundation`、`Constructions`、`MathlibBridge`。
2. 聚合导入并 `#check` 显式 `toMathlib`、开集桥和连续桥。
3. 检查两篇文档精确八段、Entry 一一对应、无禁用占位。
4. 运行 `git diff --check`，并在 handoff 中明确列出本次返工提交号。

## 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R1 移除 `toMathlib` 的实例属性 | resolved | `d24d2a8` 删除 `@[instance_reducible]`；未新增任何实例。 |

### 返工验证

- `Foundation`、`Constructions`、`MathlibBridge` 联合构建通过（708 jobs）；单独重建桥通过且无
  class reducibility warning。
- 聚合文件对 `toMathlib`、`isOpen_toMathlib`、`continuous_iff_mathlib` 的 `#check` 通过。
- `MathlibBridge.lean` 中无 `instance_reducible`、`instance`、`local instance` 或 `letI`；普通
  `def toMathlib` 仅由桥定理显式引用。
- 两篇 Entry 均保持精确八段；三个目标模块无禁用占位；`git diff --check` 通过。
