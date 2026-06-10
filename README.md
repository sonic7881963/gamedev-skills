# gamedev-skills

给 Claude Code 用的游戏开发 skills 包——从一个骑砍式火柴人战斗 demo 的**真实开发**
中提炼（每条规则都对应一次亲眼见过的事故，不是理论）。中文正文，英文触发条件。

## 包含的 Skills

| Skill | 解决什么 |
|---|---|
| **tiered-gamedev-workflow** | 流程重量匹配改动风险：S/M/L 特性分级 + 升级判定 + 永不轻量的底线 + 工作流自我纠错的复盘回路 |
| **godot-headless-testing** | Godot 4 无头测试全套：SceneTree 骨架、看门狗、事件驱动断言、8 条真实事故坑表、并行 runner（25 测 4-7 分钟 → ~65s） |
| **solo-repo-discipline** | 人机共用工作区的 git 纪律：显式 stage、丢弃前 diff、无 BOM commit、本地合并落地、编码坑 |
| **gamedev-toolchain** | superpowers × godot-mcp-enhanced 协同：阶段→工具映射、MCP 能力速查、保持最新机制 |

## 安装

**方式一：插件（推荐）**

```
/plugin marketplace add sonic7881963/gamedev-skills
/plugin install gamedev-skills@gamedev-skills
```

**方式二：手动拷贝（个人 skills 目录）**

```
git clone https://github.com/sonic7881963/gamedev-skills
把 skills/* 拷到 ~/.claude/skills/
```

**配套模板**（拷进你的项目）：
- `templates/run_tests.ps1` → 项目 `tools/`（设 `GODOT_PATH` 环境变量）
- `templates/CLAUDE.md.template` → 填空后存为项目 `CLAUDE.md`

## 依赖与版本（tested against）

| 依赖 | 版本 | 说明 |
|---|---|---|
| [superpowers](https://github.com/obra/superpowers) | 5.1.0 | 流程纪律基座（brainstorm/TDD/计划/调试），本包多处交叉引用 |
| [godot-mcp-enhanced](https://www.npmjs.com/package/godot-mcp-enhanced) | 0.17.2 | 引擎闭环 MCP（`npx -y` 自动更新）；`claude mcp add godot -- npx -y godot-mcp-enhanced` + `GODOT_PATH` |
| Godot | 4.6.x | Windows 注意 GUI 子系统调用方式（skill 内有解法） |
| PowerShell | 5.1 | 模板脚本兼容 5.1（编码坑已处理） |

上游更新后的同步动作见 `UPDATE-CHECKLIST.md`。

## 维护机制

本包不是静态文档：源项目的**复盘回路**（出事故 → 归因 → 最小修订 → 修订记录）
持续产出规则修订，并同步到这里。Watch/Star 获取更新。

## License

MIT
