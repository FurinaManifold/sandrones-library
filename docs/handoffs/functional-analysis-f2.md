# F2 Banach 三大定理 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`c9faa0f`
- 设计 RFC：`docs/maintenance/functional-analysis-f2-design.md`
- 当前阶段：Baire 窗完成验证；Banach–Steinhaus 待开发

## 范围与边界

- 本批依次覆盖 Baire、Banach–Steinhaus、开映射、闭图和有界逆。
- 正式承载均直接采用语义一致的 Mathlib 接口，不建立平行结构或谓词。
- F3/F4 保持锁定；共有 Registry、RADAR、ROADMAP 和顶层 import 由 Main 集成。

## Baire 窗

- 正式承载：`BaireSpace`；展开为可数稠密开集之交稠密。
- 上层使用者：可数闭集覆盖必有一项具有非空内部。
- `lake build SandronesLibrary.FunctionalAnalysis.Baire`：8708 jobs 通过；只有教材
  `BanachSpace` 语境中的未使用线性结构提示和既有 Topology 格式警告。
- 聚合 `#check` 覆盖 `BaireSpace`、其教材展开和两个公开使用者；Entry 精确映射为两个声明。
- 两个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。
