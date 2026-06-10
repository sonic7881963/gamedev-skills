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
| 提交落地 | solo-repo-discipline |

## MCP 使用要点

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
3. 建议配一个定期任务（如每周）：检查 `npm view godot-mcp-enhanced version` 与
   superpowers 版本，有更新就提醒过一遍 checklist。
