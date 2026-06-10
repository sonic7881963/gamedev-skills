---
name: godot-headless-testing
description: Use when writing or debugging automated tests for Godot 4 projects — headless tests hang or time out with no output, animation/physics timing asserts fail intermittently, new class_name types are "not found", a freed object crashes a typed parameter, or the test suite has grown slow
---

# Godot 4 无头测试模式（SceneTree 脚本 + 并行运行）

## 核心原则

测试 = `extends SceneTree` 的无头脚本，自带看门狗、事件驱动断言、确定性环境剥离；
套件并行跑（互不依赖），总时长 = 最慢单测。

## 测试骨架

```gdscript
extends SceneTree
## 一句话说明断言对象。

var _frames := 0
var _fail := 0

func _check(cond: bool, msg: String) -> void:
	if not cond:
		print("FAIL: ", msg)
		_fail += 1

func _initialize() -> void:
	# 搭场景/单位...
	physics_frame.connect(_on_phys)

func _on_phys() -> void:
	_frames += 1
	if _frames > 600:  # 看门狗:脚本错误会中断断言流程,没有它进程挂死主循环
		print("FAILED: watchdog timeout")
		quit(1)
		return
	# 状态机式分阶段断言...
	# 终态: print("PASS: ..."); quit(0) 或 print("FAILED: ", _fail); quit(1)
```

## 坑表（每条都来自真实事故）

| 症状 | 根因 | 解法 |
|---|---|---|
| 测试"跑完"但无输出、拿不到退出码 | Windows 版 Godot 是 GUI 子系统应用 | `Start-Process -PassThru -NoNewWindow -RedirectStandardOutput/-RedirectStandardError` + `WaitForExit(超时)` 强杀；勿直接调用 |
| 进程永不退出 | SceneTree 脚本内的 SCRIPT ERROR 中断当帧断言、quit 永远不执行 | 测试必带帧数看门狗；runner 必带超时强杀 |
| 按帧号等动画/事件的断言偶发失败 | 动画与战斗逻辑走 `_process`（墙钟），物理帧固定步长，启动头几帧引擎卡顿、两钟漂移 1-2 帧 | **事件驱动**：轮询等可观察状态（信号计数/monitoring 翻转）再断言；必须比帧数时给 ≥5 帧裕度 |
| 想冻结某单位但它还是动了一拍 | `queue_free()` 帧末才生效，AI 在当帧已执行 | **入树前**剥离：`unit.remove_child(ai); ai.free()` 再 `add_child(unit)` |
| 测试按名字引用新类型报 "Could not find type" | `--script` 模式不刷新全局类缓存 | 新增 `class_name` 后先跑一次 `--headless --import` |
| freed 对象传入函数直接报错 | typed 参数拒收已释放实例 | 可能收到已释放对象的参数用无类型 `Variant`，先 `is_instance_valid` |
| 战局测试随平衡调参反复翻红 | 断言了"谁赢"——胜负随数值漂移 | **只断言行为**（推进发生/命令生效/位移量）；胜负观察放非门禁脚本 |
| 死亡单位偶发不倒地：空挥无伤害、永远站立 | 状态机特性只测了受击×相位、漏死亡×相位（伤害层守卫造成"死亡已处理"错觉）：死在 WINDUP/READY 死后照常释放，strike 动画顶掉死亡姿势 | 状态机特性的测试清单必须含**中断矩阵**：每个相位 × {受击, 死亡}；死亡须停机所有自驱状态机（halt 且不发 cancel——cancel 会把动画器拍回 locomotion） |
| 套件越来越慢 | 串行起进程，每个 2-4s 启动 + 战局秒级模拟 | 并行 runner：同批起进程逐个收割（见 templates/run_tests.ps1，25 测 4-7 分钟 → ~65s） |

## 确定性环境清单

- 敌我单位入树前剥 AI（手动驱动，时序可控）
- 陪练单位血量拉满（`hp.current_hp = 9999`）防被试招打死
- 信号计数用 lambda 收集（`signal.connect(func(): _count += 1)`），同帧同步断言
- `physics_frame` 信号先于节点物理回调——同帧内的注入+断言不受 AI 干扰

## 纪律

红（单测）→ 绿（单测）→ 并行全量 ×1 → 提交（**REQUIRED**：superpowers:test-driven-development）。
3× 稳定性复跑只在改动时序敏感测试本身时做。意外翻红走 superpowers:systematic-debugging
——写一次性探针打印逐帧状态，定位后删探针，禁止猜改。
