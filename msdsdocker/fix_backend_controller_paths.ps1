$controllerPath = "..\msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\src\main\java\com\ruoyi\web\controller\system"

$fixes = @(
    @{File="MsdsLeakResponseController.java"; Old='@RequestMapping("/system/leakResponse")'; New='@RequestMapping("/system/msds/leakResponse")'},
    @{File="MsdsHandlingStorageController.java"; Old='@RequestMapping("/system/handling")'; New='@RequestMapping("/system/msds/handling")'},
    @{File="MsdsExposureControlController.java"; Old='@RequestMapping("/system/exposure")'; New='@RequestMapping("/system/msds/exposure")'},
    @{File="MsdsStabilityReactivityController.java"; Old='@RequestMapping("/system/stability")'; New='@RequestMapping("/system/msds/stabilityReactivity")'},
    @{File="MsdsToxicologicalController.java"; Old='@RequestMapping("/system/toxicological")'; New='@RequestMapping("/system/msds/toxicological")'},
    @{File="MsdsEcologicalController.java"; Old='@RequestMapping("/system/ecological")'; New='@RequestMapping("/system/msds/ecology")'},
    @{File="MsdsDisposalController.java"; Old='@RequestMapping("/system/disposal")'; New='@RequestMapping("/system/msds/disposal")'},
    @{File="MsdsTransportationController.java"; Old='@RequestMapping("/system/transportation")'; New='@RequestMapping("/system/msds/transport")'},
    @{File="MsdsRegulatoryController.java"; Old='@RequestMapping("/system/regulatory")'; New='@RequestMapping("/system/msds/regulatory")'},
    @{File="MsdsOtherInfoController.java"; Old='@RequestMapping("/system/otherInfo")'; New='@RequestMapping("/system/msds/otherInfo")'}
)

foreach ($fix in $fixes) {
    $filePath = Join-Path $controllerPath $fix.File
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        $newContent = $content -replace [regex]::Escape($fix.Old), $fix.New
        
        if ($content -ne $newContent) {
            Set-Content -Path $filePath -Value $newContent -Encoding UTF8 -NoNewline
            Write-Host "✓ Fixed: $($fix.File)" -ForegroundColor Green
        } else {
            Write-Host "- Skipped: $($fix.File) (already fixed)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✗ Not found: $($fix.File)" -ForegroundColor Red
    }
}

Write-Host "`nAll Controller paths fixed!" -ForegroundColor Cyan
Write-Host "Please restart the backend container to apply changes." -ForegroundColor Yellow

