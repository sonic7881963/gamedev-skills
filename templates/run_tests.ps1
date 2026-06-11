# Godot 4 无头测试并行运行器(通用模板)。放进项目 tools/ 目录。
# 前提: 测试为 tests/test_*.gd 的 SceneTree 脚本,打印 PASS/FAIL 并 quit(0/1)。
# 用法:
#   .\tools\run_tests.ps1                    # 全量并行(按 CPU 核数分批)
#   .\tools\run_tests.ps1 -Test test_xxx     # 单测
#   .\tools\run_tests.ps1 -Import            # 新增 class_name 后先刷类缓存
# Godot 路径: 传 -GodotPath 或设环境变量 GODOT_PATH。
# 注意: Windows 版 Godot 是 GUI 子系统应用,必须 Start-Process+重定向+WaitForExit;
# SceneTree 测试出脚本错误会挂死主循环,故每测带超时强杀。
# 基线 pwsh 7+(UTF-8,无需 BOM)。Windows PowerShell 5.1 支持止于本包 v1.1.0。

param(
    [string]$Test = "",
    [switch]$Import,
    [string]$GodotPath = $env:GODOT_PATH,
    [int]$TimeoutSec = 150,
    [int]$Throttle = 0,
    # 重负载测试名(长战局/大规模模拟):与全队并行易被 CPU 饥饿拖到看门狗超时,
    # 列进来的会单独末批、只彼此并行。
    [string[]]$HeavyTests = @()
)

if (-not $GodotPath -or -not (Test-Path $GodotPath)) {
    Write-Host "Godot not found. Pass -GodotPath or set GODOT_PATH." -ForegroundColor Red
    exit 2
}
$proj = Split-Path $PSScriptRoot -Parent
$tmp = Join-Path $env:TEMP "godot_tests"
New-Item -ItemType Directory -Force $tmp | Out-Null
# 留 2 核给系统:满核并行会 CPU 饥饿,诱发看门狗超时/时序偶发。
if ($Throttle -le 0) { $Throttle = [Math]::Max(1, [Environment]::ProcessorCount - 2) }

function Start-GodotTest([string]$name) {
    $out = Join-Path $tmp "$name.out.txt"
    $err = Join-Path $tmp "$name.err.txt"
    $p = Start-Process -FilePath $GodotPath `
        -ArgumentList @('--headless', '--script', "res://tests/$name.gd", '--path', "`"$proj`"") `
        -PassThru -NoNewWindow -RedirectStandardOutput $out -RedirectStandardError $err
    return [pscustomobject]@{ Name = $name; Proc = $p; Out = $out; Err = $err }
}

function Report-GodotTest($job) {
    if (-not $job.Proc.WaitForExit($TimeoutSec * 1000)) {
        $job.Proc.Kill()
        Write-Host "$($job.Name)  TIMEOUT" -ForegroundColor Red
        return $false
    }
    $last = Get-Content $job.Out -ErrorAction SilentlyContinue |
        Where-Object { $_ -match 'PASS|FAIL' } | Select-Object -Last 1
    if ($last -match 'PASS') {
        Write-Host "$($job.Name)  $last"
        return $true
    }
    Write-Host "$($job.Name)  $last" -ForegroundColor Red
    $errs = Get-Content $job.Err -ErrorAction SilentlyContinue |
        Where-Object { $_ -match 'SCRIPT ERROR|Parse Error' } | Select-Object -First 3
    if ($errs) { $errs | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkRed } }
    return $false
}

if ($Import) {
    Write-Host "--- refreshing import / class cache..."
    $pi = Start-Process -FilePath $GodotPath -ArgumentList @('--headless', '--import', '--path', "`"$proj`"") `
        -PassThru -NoNewWindow -RedirectStandardOutput (Join-Path $tmp "import.out.txt") `
        -RedirectStandardError (Join-Path $tmp "import.err.txt")
    if (-not $pi.WaitForExit(180000)) { $pi.Kill(); Write-Host "import TIMEOUT" -ForegroundColor Red; exit 2 }
}

if ($Test) {
    $job = Start-GodotTest $Test
    $ok = Report-GodotTest $job
    Get-Content $job.Out -ErrorAction SilentlyContinue | Where-Object { $_ -match 'FAIL' } | Select-Object -First 12
    if ($ok) { exit 0 } else { exit 1 }
}

$all = @(Get-ChildItem (Join-Path $proj "tests") -Filter "test_*.gd" | ForEach-Object { $_.BaseName })
$names = @($all | Where-Object { $HeavyTests -notcontains $_ })
$heavyNames = @($all | Where-Object { $HeavyTests -contains $_ })
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$bad = 0
for ($i = 0; $i -lt $names.Count; $i += $Throttle) {
    $batch = $names[$i..([Math]::Min($i + $Throttle, $names.Count) - 1)]
    $jobs = @($batch | ForEach-Object { Start-GodotTest $_ })
    foreach ($job in $jobs) {
        if (-not (Report-GodotTest $job)) { $bad++ }
    }
}
if ($heavyNames.Count -gt 0) {
    $jobs = @($heavyNames | ForEach-Object { Start-GodotTest $_ })
    foreach ($job in $jobs) {
        if (-not (Report-GodotTest $job)) { $bad++ }
    }
}
$sw.Stop()
Write-Host ("failures: {0}  ({1} tests in {2:n0}s)" -f $bad, $all.Count, $sw.Elapsed.TotalSeconds)
if ($bad -gt 0) { exit 1 } else { exit 0 }
