# Complex analysis maintenance handoff：PrimitiveFromPathIntegral import layering

## Scope and authorization

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`，同步合并提交 `55cc854`；
- authorization: `main-8543797-vk3b15-accepted-r3b-open.md` 将 R3b-C 的开工门明确设为完成 minimal
  primitive import maintenance；`main-961f4a6-permissions-expanded.md` 授权当前负责人迁移 C/E/F；
- classification: import-only maintenance，不修改数学接口。

修改 `SandronesLibrary/ComplexAnalysis/PrimitiveFromPathIntegral.lean` 的直接依赖：删除未使用的本库
最终包 `HomotopyInvariance`，改为该文件实际消费的下层 `Holomorphic` 与 `PathIntegral`；保留 Mathlib
affine-map import。另新增本 handoff。没有修改 Entry 文档、源码声明、证明、namespace、marker、
Registry、ROADMAP、RADAR 或顶层 import。

## Defect and mathematical boundary

该 primitive 模块从未使用 `C2HomotopicWithin` 或 `pathIntegral_eq_of_C2HomotopicWithin`。旧 import 令
“由路径积分端点无关构造原函数”的下层解析模块反向依赖旧 C2 同伦不变性最终包，造成循环式课程
层级错觉。新 imports 是源码实际使用的 `HolomorphicOnTextbook` 与 path-integral API，不改变任何
教材定义或定理强度。

本维护不声称旧 C2 定理错误，也不删除它；只证明 primitive construction 不依赖该最终包。R3b-C
因此可以独立使用既有 `AdmissiblePath`、primitive evaluation 和 endpoint independence 接口。

## Signature, Entry and impact audit

`scripts.check_axioms.map_entry_to_decl` 在修改前后均把同一 Entry
`complex-analysis.cauchy.primitive-from-path-independence-foundation` 映射到同样七项公开声明。所有名称、
参数、返回类型、构造子、属性与证明文本不变；仅源码 fingerprint 需由 Main 集成时刷新。

已完成受影响验证：

- `lake build SandronesLibrary.ComplexAnalysis.AdmissiblePathConnectivity`：2812 jobs，通过；该目标同时
  重建 `PrimitiveFromPathIntegral` 及当前 Main 中唯一直接／传递消费者；
- `/tmp/PrimitiveFromPathIntegralImportLayeringAggregate.lean` 通过消费者 import 检查全部七项 API；
- mapper 仍精确得到同一 Entry / 同样七项公开声明；七项公理均为
  `[propext, Classical.choice, Quot.sound]`；
- 修改后 SandronesLibrary 直接源码闭包只有 `Holomorphic`、`PathIntegral` 与本模块三项，不再到达
  `HomotopyInvariance`、`Goursat` 或 `CauchyTheorem`；
- `git diff` 除 handoff 外严格只有 import replacement；placeholder、冲突标记与 whitespace 扫描通过。

R3b-C 的正式模块作为下一独立提交构建，以保持 maintenance 与新数学批次可分别复验。

## Honest boundary

这是依赖方向维护，不是新数学批次。它不证明连续 PiecewiseC1 同伦不变性，不改变 admissible path
carrier，也不把旧 C2 路线退役。若 Main 的 Registry 存储 source hash，集成者必须按修改后源码重算，
不能沿用旧 fingerprint。
