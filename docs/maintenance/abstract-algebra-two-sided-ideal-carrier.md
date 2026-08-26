# 抽象代数双边理想载体维护 RFC

> **Main 状态（2026-08-26）**：I1 已由 `f93cae3` 完成并集成；正式 kernel/map/comap 与商理想
> `OrderIso`、旧接口兼容层、`RingCRT` 真实消费者均复验通过。I2 第三同构迁移现为
> `development_open`；I3 子环与第二同构仍冻结，等待 I2 单独验收。

## 基线、等级与范围

本 RFC 基于 `main@2c67e3c`，维护等级为 **M2**。它只冻结
`RingIsomorphismTheorems.lean` 中重复打包载体的迁移路线，不授权本提交修改 Lean、Entry、
Registry、RADAR、ROADMAP、Examples 或共享文件。

`TwoSidedIdealCarrier R` 仅含 `carrier : Set R` 与
`isTwoSided : TwoSidedIdealSet carrier`。Mathlib 的 `TwoSidedIdeal R` 同样适用于非交换环，
其教材语义正是“含零、对加法和取负封闭、左右吸收乘法的子集”，不是仅适用于交换环的
`Ideal R`。因此重复的是打包载体；`TwoSidedIdealSet` 作为逐项教材判据仍有独立价值，必须保留。

## 可机验语义证据

以下三个 `/tmp` 框架均在 Main 依赖树上以 `lake env lean <file>` 真实编译，exit code 0、
无输出，并经禁用占位搜索确认零 `sorry`、`admit`、`sorryAx`、`native_decide`：

1. `/tmp/sandrones-library/TwoSidedIdealCarrierFramework.lean`：
   - `TwoSidedIdealCarrier R → TwoSidedIdeal R`；
   - `TwoSidedIdeal R → TwoSidedIdealCarrier R`；
   - 两个结构往返恒等式与 carrier 强制转换等式；
   - 旧 `ringHomKernel` 对齐 `TwoSidedIdeal.ker`；
   - 旧 `idealComap` 对齐 `TwoSidedIdeal.comap`；
   - 满射下旧直接像 `idealMapOfSurjective` 对齐 `TwoSidedIdeal.map`。
2. `/tmp/sandrones-library/QuotientIdealOrderEquivFramework.lean`：旧
   `QuotientIdealOrderEquivalence` 与标准 `OrderIso` 双向转换且两个往返恒等。
3. `/tmp/sandrones-library/SubringCarrierFramework.lean`：`SubringCarrier` 与 `Subring`
   双向转换且两个往返恒等；该证据只服务未来 I3，不授权在 I1 顺手迁移子环。

其中 `TwoSidedIdeal.map` 是像集生成的双边理想，旧 `idealMapOfSurjective` 是满射下的直接
集合像。二者的等式不是定义化简：一向用像集包含其生成理想，另一向用旧直接像已是包含全部
生成元的双边理想，再调用 `span_le`。

## 影响图

`TwoSidedIdealCarrier` 的 42 次 Lean 文本引用全部位于
`RingIsomorphismTheorems.lean`，没有跨文件直接消费者。引用形成三层依赖：

1. 核、集合包含序、理想像与逆像；
2. 商环理想保序对应与 `QuotientIdealOrderEquivalence`；
3. 第三同构，以及子环交／和支撑的第二同构。

文档消费者为 iso-theorems Entry、历史 A2 handoff/review、环同构载体 RFC 与 RADAR。
Registry 只记录 CRT 对整个 iso-theorems Entry 的依赖；`RingCRT.lean` 不直接出现
`TwoSidedIdealCarrier`。旧载体还注册 `SetLike`、`LE`、`PartialOrder` 全局实例；正式
`TwoSidedIdeal` 已原生拥有这些结构及完整格、`ker`、`map`、`comap`、`span`，迁移不能为
每个 Mathlib 运算再造本库 alias。

## I1：正式理想对应

I1 的单独回滚点是一个仅修改 `RingIsomorphismTheorems.lean`、其 Entry 与 I1 handoff 的提交：

- 建立旧载体与 `TwoSidedIdeal` 的双向兼容桥、carrier 等式和两个往返恒等；
- 用普通函数 `RingHomomorphism` 到 `RingHom` 的明确打包桥进入正式后端；
- 正式核心直接消费 `TwoSidedIdeal.ker/map/comap`，证明显式商投影上的理想 `OrderIso`；
- 旧 `ringHomKernel`、`idealComap`、`idealMapOfSurjective`、
  `QuotientIdealOrderEquivalence`、`quotientIdealCorrespondence` 保持签名，只在最外层退回；
- 集合级 `ringHomKernelSet`、`TwoSidedIdealSet` 与成员公式继续作为教材展开层。

I1 必须让正式商环理想 `OrderIso` 成为真实上层使用者，不能只添加无人消费的转换桥。若正式
`map` 与旧直接像的 span 等式或商环依赖类型无法组装，则回滚整个 I1 提交，旧接口不受影响。

## I2：第三同构

I2 依赖 I1 已进入 Main。届时第三同构的正式核心直接接受 `TwoSidedIdeal R`，代表元公式由该
核心拥有；旧 `TwoSidedIdealCarrier` 参数版本保持 compatibility wrapper。I2 是独立提交，不能
与 I1 压成一次迁移。

## I3：子环与第二同构

I3 同时依赖 I1、I2 以及 Main 对 `SubringCarrier ↔ Subring` 的独立审核。第二同构最终消费正式
`Subring` 与 `TwoSidedIdeal`；旧载体参数版本仍按外部兼容策略保留。不得在 I1 中顺手迁移
`SubringCarrier`，否则定义链和回滚边界失效。

## 兼容与非目标

- `RingHomomorphism` 是普通函数上的逐项教材谓词；与 `RingHom` 建桥不等于删除该谓词。
- `quotientRingSet` 是本库显式教学商构造，不因采用正式理想载体而删除。
- `QuotientIdealOrderEquivalence` 与 `OrderIso` 无语义差异，正式对应应返回 `OrderIso`；旧结构
  默认保留薄兼容层，不因仓内使用归零自动删除或 deprecate。
- 本 RFC 不处理 `RingEquiv` R2、局部化、一般 `Ideal`、Examples 或任何共享状态。
- 每一波仍须 Main 单独给出 `development_open`；本 docs-only RFC 不隐含 Lean 迁移权限。
