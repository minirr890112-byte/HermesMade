# 🛠 Tool Proposals — Index 2026-05-01

Generated: 2026-05-01 | 210 CSDN/Juejin pain signals → 4 tool candidates
Updated: claude-intel-monitor ✅ 真机测试完成, cursor-doctor ✅ 已创建

---

## 评分标准

每项按 4 个维度打分 (1-5):
- **Pain**: 痛点有多真实、多普遍
- **Build**: 实现难度 (5=容易, 1=极难)
- **Viral**: 传播潜力 (SEO/社区自发推广)
- **Monetize**: 变现可能性

---

## ✅ 已完成

### 1. claude-intel-monitor ✅ (v0.1.0)

**一句话**: CLI 基准测试工具，自动检测 Claude/GPT 是否降智

**状态**: 100% 完成 | 真机测试通过

```
$ claude-intel-monitor test --provider deepseek --model deepseek-chat
📊 Overall: 91.1% (27/30)
  📐 Math:      80% (8/10)   🟢 Normal
  🧠 Reasoning: 100% (10/10) 🟢 Normal
  💻 Code:      90% (9/10)   🟢 Normal
⏱ Avg latency: 11.4s
```

**功能**:
- `test` — 跑 30 道基准题 (数学/推理/代码)
- `history` — 查看历史跑分，自动对比基线
- `baseline` — 设置/清除基线
- `watch` — 持续监控模式
- 通过 Rich 表格输出，退化自动告警

**架构**: Provider 层支持 DeepSeek/OpenAI/Anthropic/本地模拟

**已发布路径**: `~/HermesMade/claude-intel-monitor/`

---

### 2. cursor-doctor ✅ (v0.1.0)

**一句话**: Cursor IDE 常见报错/崩溃/配置问题一键诊断 CLI

**状态**: 100% 完成 | 本地测试通过

```
$ cursor-doctor diagnose
✅ Cursor 版本: OK
✅ 系统环境: Python 3.14, Node v22.14, Git 2.50
✅ 内存: 16GB (68% 使用)
✅ 磁盘: 249GB 空闲
✅ 未发现错误日志，Cursor 运行正常

$ cursor-doctor signatures
📋 共 16 条签名，覆盖 6 个分类
  🔴 MCP/Agent 连接 (3) — MCP Client Closed, Shell Parse, 授权过期
  🔴 崩溃 (3) — 白屏, 插件崩溃, OOM
  🟡 AI异常 (3) — 超时, 质量下降, 死循环
  🟡 网络代理 (2) — 代理冲突, GFW
  🟡 配置环境 (3) — 配置损坏, Python, Node.js
  🔵 文件同步 (2) — 同步冲突, File Watcher
```

**功能**:
- `diagnose` — 全面诊断 Cursor + 系统环境
- `fix <category>` — 自动修复 (MCP连接/崩溃/代理/配置)
- `signatures` — 浏览 16 条错误签名
- `match --text "..."` — 匹配错误文本到已知签名

**已发布路径**: `~/HermesMade/cursor-doctor/`

---

## 🟡 待孵化

### 3. agent-debug-tester (2 signals, 🆕 新涌现)

**一句话**: 在多个 Coding Agent 间对比测试代码生成质量

**现状**: 信号量 2 条 (Claude Code 进阶指南, Agent SDK)

**评分**: Pain=2 Build=3 Viral=4 Monetize=4

**建议**: 等下次扫描，信号量 > 10 再启动

---

### 4. ai-pitfalls (57 signals)

**一句话**: 可搜索的 AI 编程踩坑经验库（本地 CLI）

**现状**: 57 条踩坑经验类文章

**评分**: Pain=3 Build=5 Viral=4 Monetize=2

**建议**: 纯数据项目，可以 Git clone 后直接发布为 GitHub Pages

---

## 📦 发布计划

| Tool | 状态 | 信号源 | 下一步 |
|------|------|--------|--------|
| claude-intel-monitor | ✅ 完成 + 真机测试 | 降智 16 条 | GitHub 发布 + README 中英双语 |
| cursor-doctor | ✅ 完成 | Cursor报错 77 条 | GitHub 发布 + 中文 SEO |
| agent-debug-tester | ⏸ 等待 | Coding Agent 2 条 | 下次扫描 >10 条再启动 |
| ai-pitfalls | ⏸ 待定 | 踩坑 57 条 | 等待，简单项目 |

## 趋势分析

| 指标 | 4月26日 | 4月30日 | 5月1日 | 趋势 |
|------|---------|---------|--------|------|
| 总信号量 | 106 | 210 | 210 | 稳定 |
| Cursor报错 | 21 → 77 | 77 | 77 | 🔴 爆发, 已建工具 |
| 降智检测 | 16 | 16 | 16 | 🟢 稳定方向已验证 |
| Coding Agent | 0 | 2 | 2 | 🆕 新方向 |
