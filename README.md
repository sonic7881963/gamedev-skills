# gamedev-skills

给 Claude Code 用的游戏开发 skills 包——从一个骑砍式火柴人战斗 demo 的**真实开发**
中提炼（每条规则都对应一次亲眼见过的事故，不是理论）。中文正文，英文触发条件。

## 包含的 Skills

| Skill | 解决什么 |
|---|---|
| **tiered-gamedev-workflow** | 流程重量匹配改动风险：S/M/L 特性分级 + 升级判定 + 永不轻量的底线 + 中途升级 |
| **running-subagent-teams** | 子代理团队的运营经济学与纪律：派发简报 + 断点/成本快照 + 模型档位/哨兵 + 落地报告纪律 + 审查右量化 + 长上下文红线 |
| **evolving-workflow-rules** | 工作流自我纠错：复盘回路 + 归因三问 + 入册前把关三检 + 控胀三则 + 常驻特权三分法 + 根基防护 + 记忆审计 |
| **godot-headless-testing** | Godot 4 无头测试全套：SceneTree 骨架、看门狗、事件驱动断言、真实事故坑表、并行 runner（留核+重负载隔离，串行分钟级 → 一两分钟） |
| **solo-repo-discipline** | 人机共用工作区的 git 纪律：显式 stage、丢弃前 diff、here-string 提交、本地合并落地 |
| **gamedev-toolchain** | superpowers × godot-mcp-enhanced 协同：阶段→工具映射、MCP 能力速查、保持最新机制 |

### 通用中文协作 skills（蒸馏自 superpowers-zh）

非源项目提炼，而是从 [superpowers-zh](https://github.com/jnMetaCode/superpowers-zh)（MIT）蒸馏的通用中文编程
辅助——伴随式叠加在 superpowers 的写作/提交/审查技能之上，自动触发（无需手动 `/`）：

| Skill | 解决什么 |
|---|---|
| **chinese-documentation** | 中文技术文档排版：中英空格、全/半角标点、术语保留、去机翻味 |
| **chinese-commit-conventions** | 中文 commit message：Conventional Commits 中文适配（仅写消息部分，不含 npm 工具链） |
| **chinese-code-review** | 中文审查沟通：分级标注 [必须修复/建议修改/仅供参考] + 建议式话术 + 反模式 |

### 设计部门（设计顾问 agents）

`agents/` 下另有 9 个**设计域顾问**（蒸馏自 [claude-code-game-studios](https://github.com/donchitos/claude-code-game-studios)，MIT），补「全是代码执行代理、零设计顾问」的缺口。**装进你项目的 `.claude/agents/`** 即可点名派发；伴随式 skill `design-advisory` 管「何时把哪个顾问拉进来」。

| 议题 | 顾问 |
|---|---|
| 核心循环·机制·MDA·整体平衡 | game-designer |
| 具体公式·曲线·交互矩阵 | systems-designer |
| 货币·掉落·进度·奖励·通胀 | economy-designer |
| 战场/关卡布局·遭遇·节奏 | level-designer |
| HUD·交互·可读性·反馈·引导 | ux-designer |
| 剧情·世界观·角色·ludonarrative | narrative-director |
| 视觉风格·art bible·给美术提需求 | art-director |
| 声音美学·音乐·音效·自适应 | audio-director |
| 「这还是同一款游戏吗」·支柱自洽 | creative-director |

**★ 设计建议没有 oracle**——测试证不了好不好玩 / 平不平衡，顾问产出是框架 + 初稿、**playtest 才是终审**。配套 12 个设计文档模板见 `templates/design/`；部门总览、用法与告诫见 `agents/README.md`。

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
| [superpowers](https://github.com/obra/superpowers) | 6.0.2 | 流程纪律基座（brainstorm/TDD/计划/调试），本包多处交叉引用；6.0 重写 subagent-driven-development（单审合一+脚本化文件交接 review-package/task-brief），14 个 slug 全不变、交叉引用不受影响（已核） |
| [godot-mcp-enhanced](https://www.npmjs.com/package/godot-mcp-enhanced) | 0.18.1 | 引擎闭环 MCP（`npx -y` 自动更新）；`claude mcp add godot -- npx -y godot-mcp-enhanced` + `GODOT_PATH`。**v0.18.0 起工具按组管理（39→27），不在列表的工具用 `manage_tools activate <组>` 启用；旧名走 LEGACY 兼容** |
| Godot | 4.6.x | Windows 注意 GUI 子系统调用方式（skill 内有解法） |
| PowerShell | **7+（pwsh）** | v2.0.0 起基线 pwsh 7+（UTF-8，无 BOM/-F 仪式）；仍在 Windows PowerShell 5.1 上的用户用 **v1.1.0 tag**（最后兼容版，含 BOM/-F 编码规则） |
| Claude Code | 2026-06 新版 harness | MCP 工具延迟加载（先 ToolSearch）、后台任务、子代理、CronCreate——skill 内已适配；旧版 harness 用户这些条目可忽略 |

上游更新后的同步动作见 `UPDATE-CHECKLIST.md`。

## 维护机制

本包不是静态文档：源项目的**复盘回路**（出事故 → 归因 → 最小修订 → 修订记录）
持续产出规则修订，并同步到这里。Watch/Star 获取更新。

**与源项目的关系**：本包是一个活跃开发项目工作流的**脱敏发布物**——源项目的
运行时权威是它自己的 CLAUDE.md（未安装本包时，本包对任何会话零作用力，同步
只是出版不是部署）。让它真正生效的方式：在**新项目**里按上方方式安装为插件
并拷贝模板——这正是本包的设计用途。

## License

MIT
