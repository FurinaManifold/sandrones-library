# Main review：泛函分析与拓扑并行权限审计

- reviewed branches: `codex/functional-analysis-restart@9e7666f`、`codex/topology-foundations@16fe5af`
- baseline: `main@961f4a6`
- verdict: `accepted_no_new_math_submission_permissions_expanded`
- reviewed at: 2026-08-26

## 验收结论

两处分支均为 clean。泛函分支相对 Main 的数学补丁是已接收的 Krein--Milman、均值遍历分解和
Fredholm 第一窗的同义提交；唯一新增内容是 handoff 的同步与验证记录，不构成遗漏的数学批次。
拓扑分支的 VK3b-15a--15c 已分别进入 Main，二开集、道路连通交集版本的 van Kampen 群同构已完成。
因此本轮没有返工项，也不重复 cherry-pick 已集成补丁。

## 扩大后的权限

泛函分析现在维持多条互不重叠的工作线：F4.9 两个消费者均为 `development_open`；F5.6 第二窗为
`development_open`，最终备择为自动解锁的 `research_open`；F5.7 为 `research_open`；F6.1 为
`development_open`，F6.2 为自动解锁的 `research_open`。各线必须独立文件、独立提交和 handoff。

拓扑学除 T4-R3b-square 外，正式开放 AT2 覆盖空间路线。R3b 的 A/B/C/D 可直接形成正式提交，E/F
按 handoff 自动解锁；AT2-C1 为 `development_open`，C2/C3 为依赖前一公开签名的自动解锁窗口。
AT2 不得改写 R3b 或既有 `Path`／覆盖 carrier，具体计算例继续归 Examples。

本轮没有要求负责人承担 Registry、ROADMAP、review 归档或措辞修订；这些由 Main 维护。
