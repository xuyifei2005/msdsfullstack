$tables = @(
    "msds_component",
    "msds_first_aid",
    "msds_fire_fighting",
    "msds_leak_response",
    "msds_handling_storage",
    "msds_exposure_control",
    "msds_physical_chemical",
    "msds_stability_reactivity",
    "msds_toxicological",
    "msds_ecological",
    "msds_disposal",
    "msds_transportation",
    "msds_regulatory"
)

foreach ($table in $tables) {
    Write-Host "Adding audit fields to $table..." -ForegroundColor Cyan
    docker exec msdsmysql mysql -uroot -proot_password msds_dev -e "ALTER TABLE $table ADD COLUMN create_by VARCHAR(64) DEFAULT '', ADD COLUMN create_time DATETIME NULL, ADD COLUMN update_by VARCHAR(64) DEFAULT '', ADD COLUMN update_time DATETIME NULL" 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] $table" -ForegroundColor Green
    } else {
        Write-Host "  [FAILED] $table" -ForegroundColor Red
    }
}

Write-Host "`nCreating msds_other_info table..." -ForegroundColor Cyan
docker exec msdsmysql mysql -uroot -proot_password msds_dev -e @"
CREATE TABLE IF NOT EXISTS msds_other_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    msds_id BIGINT NOT NULL,
    references TEXT,
    data_sources TEXT,
    form_fill_time DATE,
    form_fill_department VARCHAR(100),
    form_fill_person VARCHAR(100),
    data_audit_unit VARCHAR(100),
    data_audit_person VARCHAR(100),
    technical_review_person VARCHAR(100),
    modification_notes TEXT,
    training_requirements TEXT,
    additional_information TEXT,
    disclaimer TEXT,
    create_by VARCHAR(64) DEFAULT '',
    create_time DATETIME NULL,
    update_by VARCHAR(64) DEFAULT '',
    update_time DATETIME NULL,
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
"@ 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] msds_other_info table created" -ForegroundColor Green
} else {
    Write-Host "  [FAILED] msds_other_info table creation" -ForegroundColor Red
}

Write-Host "`nDone!" -ForegroundColor Green

