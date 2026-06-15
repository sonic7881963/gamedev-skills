---
name: solo-repo-discipline
description: Use when an AI agent shares a git worktree with a human whose editor is open in parallel — uncommitted human edits appear mid-session, the engine editor re-saves files as "churn", commits need landing without PRs, or commit messages / PowerShell scripts get mangled by encoding
---

# 单人仓库协作纪律（人机共用工作区）

## 核心原则

工作区不是只属于 agent 的：用户的引擎编辑器随时在并行保存文件。
**任何"不是我改的"文件都可能是用户的未提交工作**——默认保护，不默认清理。

## 铁律

1. **绝不 `git add -A` / `git add .`**——只显式 stage 自己改动的文件清单。
2. **丢弃任何文件前必须先 `git diff` 逐行确认是纯格式搅动**（uid 添加、字段重排、
   编辑器规范化）。**有任何实质内容差异 → 停手问用户。**
   事故来源：把用户未提交的真实修改当成"编辑器搅动" checkout 丢弃，git 无法恢复
   （内容从未进对象库）。
3. 引擎编辑器（如 Godot `--editor` 无头跑）会重存场景/资源文件——跑完检查
   `git status`，churn 留给用户决定，自己的提交里不夹带。
4. 用户消息说"我改了 X"但磁盘没有 → 可能在编辑器内存里没保存，提醒保存而不是替他改。

## 提交与落地

| 事项 | 做法 |
|---|---|
| commit message 含中文/括号/引号 | pwsh 7+ 基线：单引号 here-string `git commit -m @'...'@` 直接可用（实测安全）；遇罕见分词异常再退回无 BOM UTF-8 临时文件 + `git commit -F` |
| `.ps1` 脚本含中文注释 | pwsh 7+ 基线：UTF-8 即可，无需 BOM（Windows PowerShell 5.1 的 BOM/-F 规则止于本包 v1.1.0，见 README 版本表） |
| 落地方式 | 单人仓库默认**本地合并 + 直接 push**；PR 仪式只留给里程碑（gh 的 OAuth token 可能数小时失效，push 走 git 凭证更稳） |
| 版本标签 | **每次收口必判并显式输出 TAG/NO_TAG+一句理由**（不许静默漏打）；只为"可运行·可回退·有独立价值"的稳定交付点打 tag，纯文档/重构/小修默认不打、连续小改攒批再统一打；semver(fix=patch/可见功能=minor/破坏=major)，用注释 tag 记覆盖范围。**反模式**："攒到里程碑统一打"会因里程碑被递归 scope 撑得永不 close 而漂到零 tag——把判定绑到每次收口这个反复发生的事件 |
| 合并后切分支 | 若 checkout 被未提交文件挡住：`git branch -f <branch> origin/<branch>` 再 checkout 同指针提交——零文件变动，用户改动原样保留 |

## 红线自检

| 念头 | 现实 |
|---|---|
| "这堆 diff 看着像编辑器搅动，直接丢了" | 上一个这么想的 agent 删掉了用户一下午的工作。先 diff。 |
| "add -A 快一点" | 会把用户未提交的半成品一起提交进历史 |
| "checkout 报错挡路，--force 过去" | 挡你的就是用户的未提交工作 |
