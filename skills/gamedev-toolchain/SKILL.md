---
name: gamedev-toolchain
description: Use when setting up or driving the Claude Code toolchain for Godot game development — deciding which superpowers skill applies at each stage, calling the godot-mcp-enhanced MCP server (screenshots, game bridge, audio, editor), or keeping the toolchain current after upstream updates
---

# 游戏开发工具链协同（superpowers × godot-mcp-enhanced）

## 三件套

| 件 | 作用 | 安装 |
|---|---|---|
| superpowers 插件 | 流程纪律（brainstorm/TDD/计划/调试） | `/plugin marketplace add obra/superpowers-marketplace` |
| godot-mcp-enhanced（MCP） | 引擎闭环（截图/游戏桥/动态 GDScript/场景查询） | `claude mcp add godot -- npx -y godot-mcp-enhanced`，env 设 `GODOT_PATH` |
| 本 skills 包 | 分级工作流+测试模式+协作纪律 | 见仓库 README |

## 阶段 → 工具映射

| 阶段 | 用什么 |
|---|---|
| 新特性起手 | tiered-gamedev-workflow 判级 → L 级走 superpowers:brainstorming |
| 写规格/计划 | L 级：superpowers:writing-plans → superpowers:executing-plans |
| 写代码 | superpowers:test-driven-development + godot-headless-testing |
| 意外失败 | superpowers:systematic-debugging（探针定位） |
| 目测验证 | MCP `screenshot`（capture 无头截场景 / analyze 读图）——注意 2D 项目无头截图
  output_path 必须在项目目录内 |
| 运行时探查 | MCP `game`（game_bridge + get_tree/find_nodes/send_key/monitor） |
| 听音效 | MCP `audio`（audio_play 指定 stream_path） |
| 大范围代码搜索/摸底 | **Explore 子代理**（只回结论不占主上下文；单点已知文件直接读） |
| ≥2 个互不依赖的任务 | superpowers:dispatching-parallel-agents 并行子代理 |
| 提交前全量测试 | 测试 runner **后台运行**（run_in_background），期间备好提交材料，完成自动通知 |
| 提交落地 | solo-repo-discipline |

## MCP 使用要点

- 新版 Claude Code 中 MCP 工具**延迟加载**：工具名出现在可用列表里但 schema 未载入，
  直接调用报 InputValidationError——先用 ToolSearch（如
  `select:mcp__godot__screenshot`）加载 schema 再调用。
- `npx -y` 形态 = 冷启动自动拉最新版；行为突变时先查版本：
  `npm view godot-mcp-enhanced version`（本包内容核对于 **v0.17.2**）。
- 无头截图对纯 2D 场景可能空白（上游已知限制，capture 返回警告）；带 HUD 的场景
  实测可用。多实例管理需 `GODOT_MCP_MULTI_INSTANCE=true`。
- MCP 工具是运行时操作，不持久化——要持久改动就编辑 .tscn/.gd 文件。

## 保持最新（与复盘回路联动）

1. **上游更新**：MCP 行为变化/新能力 → 跑仓库 `UPDATE-CHECKLIST.md` 的冒烟清单 →
   修订本 skill 的能力表与版本号。
2. **本地工作流迭代**：项目 CLAUDE.md 的复盘修订被采纳后，**同步更新本 skills 库
   对应 SKILL.md 并推送**——两边不允许漂移，库是工作流的发布版。
3. **每周定时任务**：用 Claude Code 的 CronCreate（durable 模式）建每周检查——
   `npm view godot-mcp-enhanced version` 与 superpowers 插件版本，和本 skill 的
   "核对于"版本比对，有差异就提醒过一遍 UPDATE-CHECKLIST。注意：cron 只在
   Claude 会话空闲时触发，且 recurring 任务约 7 天自动过期——会话长期开着才有效，
   过期后随手重建（或退回手动：每次上游相关工作开始前查一次版本）。
