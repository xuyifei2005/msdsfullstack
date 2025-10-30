# 修复前端API路径问题
# 将所有 getXxxByMsdsId 函数的 API 路径从 ${api}/${msdsId} 修改为 ${api}/msds/${msdsId}

Write-Host "开始修复前端API路径..." -ForegroundColor Green

# 需要修复的文件列表
$files = @(
    "src/services/msds/fireFighting.ts",
    "src/services/msds/handling.ts",
    "src/services/msds/leakResponse.ts",
    "src/services/msds/otherInfo.ts",
    "src/services/msds/regulatory.ts",
    "src/services/msds/hazard.ts",
    "src/services/msds/component.ts",
    "src/services/msds/transport.ts",
    "src/services/msds/stabilityReactivity.ts",
    "src/services/msds/toxicology.ts",
    "src/services/msds/physicalChemical.ts",
    "src/services/msds/disposal.ts",
    "src/services/msds/firstAid.ts",
    "src/services/msds/ecology.ts",
    "src/services/msds/exposure.ts"
)

$fixedCount = 0
$errorCount = 0

foreach ($file in $files) {
    $fullPath = Join-Path $PSScriptRoot $file
    
    if (Test-Path $fullPath) {
        try {
            # 读取文件内容
            $content = Get-Content -Path $fullPath -Raw -Encoding UTF8
            
            # 修复getXxxByMsdsId函数中的API路径
            # 查找模式：export async function getXxxByMsdsId(msdsId: number) {
            #   return request<...>(`${api}/${msdsId}`, {
            # 替换为：
            #   return request<...>(`${api}/msds/${msdsId}`, {
            
            $pattern = '(export async function get\w+ByMsdsId\(msdsId: number\)\s*\{[^\}]*?return request[^\(]*\(\s*`)(\$\{api\}/)(\$\{msdsId\}`)'
            $replacement = '${1}${2}msds/${3}'
            
            $newContent = $content -replace $pattern, $replacement
            
            # 检查是否有修改
            if ($newContent -ne $content) {
                # 保存文件
                $utf8NoBom = New-Object System.Text.UTF8Encoding $false
                [System.IO.File]::WriteAllText($fullPath, $newContent, $utf8NoBom)
                
                Write-Host "✓ 已修复: $file" -ForegroundColor Cyan
                $fixedCount++
            } else {
                Write-Host "○ 无需修复: $file" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "✗ 修复失败: $file" -ForegroundColor Red
            Write-Host "  错误: $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
    else {
        Write-Host "⚠ 文件不存在: $file" -ForegroundColor Yellow
        $errorCount++
    }
}

Write-Host "`n修复完成!" -ForegroundColor Green
Write-Host "成功修复: $fixedCount 个文件" -ForegroundColor Green
Write-Host "失败/跳过: $errorCount 个文件" -ForegroundColor $(if ($errorCount -eq 0) { "Green" } else { "Red" })

if ($fixedCount -gt 0) {
    Write-Host "`n请重新构建前端:" -ForegroundColor Yellow
    Write-Host "  cd react-ui" -ForegroundColor Cyan
    Write-Host "  npm run build" -ForegroundColor Cyan
}

