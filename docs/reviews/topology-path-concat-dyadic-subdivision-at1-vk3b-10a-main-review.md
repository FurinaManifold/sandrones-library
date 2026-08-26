# Main review：AT1-VK3b-10a `Path.concat` dyadic 分段

- branch: `codex/topology-foundations`
- reviewed_commit: `cc2ca97`
- integrated_commit: `96da230`
- reviewer: `main`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-26

## 验收结论

本批正确计算 Mathlib 左结合 `Path.concat` 的 dyadic 断点，以 `2^n` 共同尺度约束方格细分步数，并把
相邻断点间 `subpath` 与对应输入道路作端点相对同伦。三个输入的共同分母 block 长度为 `2,2,4`，明确
排除了错误的等长三分参数化。字母 segment 可提升为相应覆盖成员中的道路并保持代表同伦。

学科提交按旧裁决给出 14 public。Main 在真实 10b 消费审计中发现 scale 正性、numerator 末端和
breakpoint 末端规则有跨模块稳定消费者，直接将三项提升为公开。此后 15a 消费审计又确认
`coe_binaryOpenCoverBasepoint` 是必要的跨模块计算规则；按同目录 amendment，当前最终接口为
18 public / 15 private；
其余半区展开、`Path.trans` 递推和索引分类保持 private。这是 Main 对过窄接口裁决的修正，不是数学
返工。

Main 构建 10a（1761 jobs），补验三个公开计算规则和 `n=3` numerator，并直接编译未修改的完整 10b
候选通过。结论止于 constrained subdivision、dyadic segment、端点相对同伦和 cover membership，
没有提前建立 aligned certificate、cell-label 比较、kernel、单射或 van Kampen 同构。

## 后续权限

10a 已接收。10b `PathConcatAlignedSubdivision` 的依赖门满足并自动转为 `development_open`；11--15
继续等待 10b 以后实际依赖逐批开放。
