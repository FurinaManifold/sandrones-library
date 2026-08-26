# Topology handoff：AT1-VK3b-07a FramedGridBoundary

## 范围、基线与权限

- 分支：`codex/topology-foundations`；依赖 Main `0637ee9` 的正式 VK3b-06。
- 开工基线：merge `2ea0edc` 同步到最新 `main@dc81d70`。
- 权限：`main-0637ee9-vk3b06-accepted-07-08-open.md` 的 `development_open`。
- 正式源码 989 行；本批只建立 framed rows、跨行传播与 perimeter relation，不包含 07b gauge
  normalization、08 row anchoring、kernel、单射或同构。
- Main public-surface 预审后由 46 public / 1 private 收缩为 16 public / 32 private。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenFramedGridBoundary.lean`。
- Entry：`topology.fundamental-group.van-kampen-framed-grid-boundary`。
- 顶层 import、Registry、生成索引和 ROADMAP 由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接消费者 |
|---|---|---|
| `FocusedBoundary` | full-row 状态公开字段使用的聚焦边界承载 | 07b 读取 `boundary.after/focus`；构造器均 private |
| `CellVertexFrames` | 小格四顶点群值 frames | 07b、08、12、15 |
| `HorizontalCellFramesCompatible` | 水平公共边的 frame 相容 | 07b、08、12、15 |
| `CellVertexFrames.liftAcrossVertical` | 沿竖边 transitions 提升 frames | 07b |
| `horizontalCellFramesCompatible_liftAcrossVertical` | 提升保持水平相容 | 07b |
| `FramedHorizontalRowPrefixState` | framed 行前缀状态 | 07b inter-module implementation API |
| `framedHorizontalRowPrefixState` | 构造 framed 行前缀 | 07b inter-module implementation API |
| `framedHorizontalFullRowState` | 完整 framed 行 | 07b、08、09、14 |
| `framedHorizontalFullRowState_leftEdge` | 完整行左端高层投影 | 08b |
| `framedHorizontalFullRowState_standard_relation` | 完整行矩形边界关系 | 07b |
| `gridLeftBoundaryWordAt` | 显式左侧累计词 | 最终 perimeter 出口 |
| `gridRightBoundaryWordAt` | 显式右侧累计词 | 最终 perimeter 出口 |
| `gridBottomBoundaryWord` | 显式底侧词 | 最终 perimeter 出口 |
| `gridTopBoundaryWord` | 显式顶侧词，隔离私有完整行构造 | 最终 perimeter 出口 |
| `gridPerimeterWords_standard_relation` | 四侧非交换边界关系 | 07a 最终课程出口 |
| `gridFullBoundary_standard_relation` | 同一高层四侧接口的完整网格名称 | 07a 计算接口 |

`FramedHorizontalRowPrefixState` 两项只因 07a/07b 物理拆批保持可见，不是 08+ 或用户课程主接口；
08a/08b 对所有 row-prefix 名称的源码引用为零。

## Private proof plumbing

32 项 private 包括：`FocusedBoundary.attachRight` 及三个字段 simp；单格 focused 包装与附接；
`mul_eq_one_rotate`；两个 frame-application 桥；递归 prefix 左端投影；canonical frames 及字段 simp；
行提升、指定行 frames、完整行构造与相容证明；相邻行 top/bottom 识别；`twoRowBoundaries_glue`；
`GridRowPrefixState`、递归状态及三个字段恢复 theorem。

最终两个 public 网格定理的签名只出现四个公开 boundary-word 定义，不再泄漏私有
`GridRowPrefixState` 或 `gridFramedFullRowStateAt`。

## 概念与签名分类

`FocusedBoundary`、`CellVertexFrames` 和 framed prefix 是本库有限 telescope 数据；Mathlib 的 `Fin`、
基本群与 Pushout 承载实际群元素。纯群粘合实现没有拓扑参数；网格声明只需要道路连通性，不要求开性
或覆盖全空间。新增 `gridTopBoundaryWord` 只把原本嵌在最终 public signature 中的私有完整行投影封装
成与 left/right/bottom 对称的高层词，不另建 frame 结构。

## 验证

- 正式目标构建：1756 jobs，通过且零 warning。
- 未修改 07b 候选直接消费收缩后的正式 07a：完整编译通过。
- Entry mapper 精确映射 16 public，跳过 32 private。
- 08a/08b 源码 prefix-name 扫描为零。
- aggregate 检查核心 structures、07b implementation bridge、full-row 投影和高层 perimeter 出口；
  代表性公理不超过 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用项、唯一声明和 `git diff --check` 通过。
