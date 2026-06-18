---
name: chinese-commit-conventions
description: Use automatically whenever composing or editing a Git commit message in Chinese — including commits made during superpowers finishing-a-development-branch, subagent-driven-development, and test-driven-development. Provides the Conventional-Commits Chinese style — type table, subject/body rules, BREAKING CHANGE, issue links. Companion overlay to the superpowers git/commit workflows; no manual trigger needed.
---

# 中文提交信息规范（蒸馏版）

> 蒸馏自 superpowers-zh（MIT, jnMetaCode）的 `chinese-commit-conventions`，**只取"写消息"部分**，砍掉 npm 工具链（commitlint / husky / conventional-changelog —— 非 Godot/GDScript 项目所需）。
> **伴随式叠加技能**：凡是要写中文 commit message 时自动套用，无需手动触发。它叠加在 superpowers 的
> `finishing-a-development-branch` / `subagent-driven-development` / `test-driven-development` 等会产生提交的
> 流程之上。
> ⚠️ **子代理盲区**：被派发的子代理（t-core/t-eco 等）跳过 using-superpowers、不一定会自动调到本技能，
> 它们写的提交不保证套用本规范。要让子代理也守此约定，须把提交格式写进控制者的派发 prompt，
> 或落到项目 CLAUDE.md（子代理读得到）。

## 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

**原则：** type 用英文关键字（工具链兼容），scope / subject / body 用中文。

## type 表

| type | 含义 | 示例 |
|------|------|------|
| feat | 新功能 | feat(用户): 新增手机号登录 |
| fix | 修复缺陷 | fix(支付): 修复回调重复处理 |
| docs | 文档变更 | docs: 更新 API 接口文档 |
| style | 代码格式（不影响逻辑） | style: 统一缩进为 2 空格 |
| refactor | 重构（非新功能非修复） | refactor(订单): 拆分订单服务 |
| perf | 性能优化 | perf(列表): 虚拟滚动优化长列表 |
| test | 测试相关 | test(auth): 补充登录单测 |
| chore | 构建/工具/依赖 | chore: 升级 Node 至 v20 |
| ci | 持续集成配置 | ci: 修改 Actions 流程 |
| revert | 回滚提交 | revert: 回滚登录重构 |

## subject 行

- 用动宾短语：「添加 xxx」「修复 xxx」「优化 xxx」
- ≤ 50 字符，末尾**不加句号**
- 禁止无意义描述：`fix: 修了个 bug`、`feat: 更新代码`、`chore: 改了点东西` ✗

## body

说明 **为什么**（背景/原因）+ **怎么做**（技术方案摘要）+ **影响范围**。每行 ≤ 72 字符（约 36 汉字），与标题空一行。

示例：

```
fix(订单): 修复并发下单导致库存超卖

高并发下原有库存扣减逻辑存在竞态条件。
改用 Redis 分布式锁 + 数据库乐观锁双重保障。

影响范围：订单服务、库存服务
测试确认：已通过 500 并发压测

Closes #256
```

## BREAKING CHANGE

不兼容变更必须标注（数据库表结构 / 公共 API 参数返回值 / 配置文件格式 变更时）：

- footer 标注：`BREAKING CHANGE: /api/user/info 返回结构变更，avatar 移入 profile 对象`
- 或 type 后加感叹号：`feat(接口)!: 重构用户信息返回结构`

标注时须写明迁移方法或升级步骤。

## Issue 关联（GitHub）

```
Closes #128
Refs #129, #130
```

## footer（项目约定）

footer 可放 Issue 关联、`Co-Authored-By` 等，按各项目约定填写（如本仓 CLAUDE.md 对提交尾部有要求，以其为准）。

## 提交前自查

- [ ] type 选对、scope 准确描述影响模块
- [ ] subject 是动宾短语、≤ 50 字、末尾无句号、非无意义
- [ ] body 说清了原因 + 方案 + 影响范围
- [ ] 不兼容变更标了 BREAKING CHANGE 并写了迁移方法
- [ ] 关联了相关 Issue
- [ ] 一次提交只做一件事（原子性）
- [ ] 中英文之间有空格
