$servicePath = "..\msdsPC\ruoyi-MsdsPc-react\react-ui\src\services\msds"

$files = @(
    "ecology.ts",
    "firstAid.ts",
    "disposal.ts",
    "physicalChemical.ts",
    "toxicology.ts",
    "stabilityReactivity.ts",
    "transport.ts",
    "component.ts",
    "hazard.ts",
    "regulatory.ts",
    "otherInfo.ts"
)

foreach ($file in $files) {
    $filePath = Join-Path $servicePath $file
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        $newContent = $content -replace '\$\{api\}/msds/\$\{msdsId\}', '${api}/${msdsId}'
        
        if ($content -ne $newContent) {
            Set-Content -Path $filePath -Value $newContent -Encoding UTF8 -NoNewline
            Write-Host "✓ Fixed: $file" -ForegroundColor Green
        } else {
            Write-Host "- Skipped: $file (already fixed)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✗ Not found: $file" -ForegroundColor Red
    }
}

Write-Host "`nAll done!" -ForegroundColor Cyan

