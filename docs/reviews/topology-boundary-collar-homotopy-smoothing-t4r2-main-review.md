# Main review：T4-R2 边界 collar 道路同伦相对平滑化

- branch: `codex/topology-foundations`
- reviewed_commits: `874cf44`, `59f0ff3`
- integrated_commits: `191a632`, `6c6c716`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

最终定理完整保留了 RFC 决定的四项关键输入：全局连续延拓、延拓与原同伦在闭方形上一致、延拓在
四边某邻域已经 `C²`，以及原同伦像落在指定开集。相对光滑逼近先用紧像的统一开域余量控制像，
再在四边逐点固定；道路同伦重建和双重 `IccExtend` 的闭方形正则性均有独立公开步骤。因此最终
结论不是一个无法检查边界条件的黑箱。

标题、summary 与正文均诚实限定为 boundary-collar 情形。本批没有声称任意连续或分段 `C¹`
边界可以相对平滑，也没有据此解锁复分析的一般连续同伦不变性。学科负责人报告的模块闭包构建、
七条声明映射与公理结果通过 Main 复验；源码无占位。

## 后续权限

- T4-R2 已接收。
- T4-R3 维持 `research_open`；可继续调查一维相对平滑或有限细分积分不变性，但在得到正式桥之前
  不得把复分析的一般连续同伦门标为开放。
- 与本窗口文件所有权不冲突的 AT1-VK1 已另行开放为 `development_open`。
