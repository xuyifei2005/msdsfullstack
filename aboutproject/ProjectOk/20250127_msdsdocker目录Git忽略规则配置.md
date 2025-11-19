# msdsdocker 目录 Git 忽略规则配置

## 完成时间
2025年1月27日

## 任务描述
为 msdsdocker 目录配置 Git 忽略规则，避免将大文件提交到版本控制系统中。

## 主要更改
1. 创建了 msdsdocker/.gitignore 文件
2. 配置了以下忽略规则：
   - Docker 备份文件（msds_backup_*/ 和 *.tar）
   - 数据库文件（msdsdata/mysql/）
   - Docker compose 备份（*.yml.bak 和 *.7z）
   - 临时文件（*.tmp）
   - 日志文件（*.log）
   - 其他大文件（*.iso、*.gz、*.zip、*.rar）

## 优化效果
1. 避免将大型二进制文件提交到 Git 仓库
2. 减少仓库体积
3. 提高 Git 操作性能
4. 防止敏感数据泄露

## 技术要点
1. 使用通配符匹配多种文件类型
2. 针对性忽略数据库和备份文件
3. 保持版本控制系统的轻量级

## 状态
✅ 已完成