# Topology handoff：AT1-VK3b-09 VanKampenLetterWord

## 范围、基线与权限

- 分支：`codex/topology-foundations`；提交前同步 merge `80582c6`，包含最新 `main@8e53d23`。
- 直接依赖：Main 集成 `dac7c1a`（包含 VK3b-08b `VanKampenRightAnchoredGrid`）。
- 权限：`main-vk3b09-public-surface-approved-dependency-gated.md` 已冻结 11 public / 2 private；08b
  进入 Main 后自动转为 `development_open`。
- 本批只建立 Pushout 字母词、实际环境环路代表和反序 concat 道路，不包含 aligned subdivision、
  kernel 零伦、规范同态单射或最终 van Kampen 同构。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenLetterWord.lean`。
- Entry：`docs/entries/topology/fundamental-group/van-kampen-letter-word.md`，id
  `topology.fundamental-group.van-kampen-letter-word`。
- 顶层 import、Registry、依赖反向缓存、生成索引、ROADMAP 与 RADAR 由 Main 集成。

## 概念链与 Mathlib 角色

| 概念 | 教材语义 | Lean 正式承载／刻画 | Mathlib 角色 | 首个使用者 |
|---|---|---|---|---|
| 单侧字母 | 选择覆盖一侧及其基本群元素 | `BinaryVanKampenLetter` sigma type | `FundamentalGroup` 是语义一致的正式承载 | `binaryVanKampenLetterWord` |
| 有限字母词 | 单侧生成元在 Pushout 中的有序乘积 | `binaryVanKampenLetterWord`；存在性定理 | `Monoid.PushoutI` 是正式 Pushout 承载 | `exists_binaryVanKampenLetterWord` |
| 实际道路代表 | 基本群同伦类的一条基点环路代表 | `fundamentalGroupPathRepresentative_mk` | `Path` 与 `Path.Homotopic.Quotient` 是正式道路／商承载 | `BinaryVanKampenLetter.ambientLoop` |
| 环境环路 | 单侧环路沿包含映入环境空间 | `ambientLoop_apply` | `Path.map` 是正式道路运算 | `binaryVanKampenCanonicalMap_of_letter` |
| 反序拼接环路 | 与群乘法方向匹配的有限道路拼接 | `binaryVanKampenLetterConcatLoop` | `Path.concat` 是正式拼接承载 | 10a dyadic subdivision |
| segment 覆盖标签 | 每个 concat 输入段留在指定覆盖成员 | `binaryVanKampenLetterConcatLoop_segment_mem` | 子类型成员关系为正式承载 | 10a/10b subdivision |

公开签名中的 `FundamentalGroup`、`Path`、`Path.Homotopic.Quotient` 与 `Monoid.PushoutI` 均属于
“语义一致的正式公开承载”；没有桥侧自建替代结构，也没有越级泄漏。`Classical.choice` 只用于
非计算地选择道路代表，属于私有证明机制。

## Public API 与 private plumbing

Entry mapper 精确映射 11 项 public：`BinaryVanKampenLetter`、`binaryVanKampenLetterWord`、
`exists_binaryVanKampenLetterWord`、`fundamentalGroupPathRepresentative`、
`fundamentalGroupPathRepresentative_mk`、`BinaryVanKampenLetter.ambientLoop`、
`binaryVanKampenCanonicalMap_of_letter`、`pathHomotopic_refl_of_fromPath_eq_one`、
`binaryVanKampenLetterConcatLoop`、`BinaryVanKampenLetter.ambientLoop_apply`、
`binaryVanKampenLetterConcatLoop_segment_mem`。

两项 private 是 `binaryVanKampenLetterWord_append` 和
`BinaryVanKampenLetter.ambientLoop_mem_piece`；正式 10--15 候选没有引用它们。它们只分别服务本文件
的乘积分支和最终公开 segment-membership 定理。

## 验证与消费者

- `lake build SandronesLibrary.Topology.VanKampenLetterWord`：1760 jobs，通过且零 warning。
- VK3b-09 aggregate：11 项公开接口、双字母乘法顺序和反序索引计算全部通过。
- 真实直接消费者 `PathConcatDyadicSubdivision.lean` 以正式 09 为 import 编译通过；10--15 候选的
  声明级引用审计确认 11 项公开出口形成后续 subdivision、letter-block、kernel 与最终定理链。
- 代表性公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用占位、私有出口泄漏、重复载体、Entry 映射、冲突标记与 `git diff --check` 在提交前复验。

## 诚实边界

本批没有证明 `binaryVanKampenLetterConcatLoop` 的同伦类等于整个字母词的规范像；也没有从 kernel
条件构造零伦、证明规范同态单射或给出 van Kampen 同构。`Path.concat` 使用 dyadic 断点而非等长
分段，后续必须依赖 VK3b-10 的 dyadic/aligned subdivision，不得把等分网格公式直接套入。
