# MSDS PDF转XML + 数据库导入完整解决方案

## 项目说明
本工具提供从PDF到数据库的完整MSDS数据处理方案：
1. **PDF → XML转换**: 提取结构化的MSDS信息
2. **XML → 数据库导入**: 将数据导入到MySQL数据库
3. **一键式流程**: 支持端到端自动化处理

## 功能特性
- ✅ 单个PDF文件转换为XML
- ✅ 批量处理多个PDF文件（支持2000+文件）
- ✅ 自动提取MSDS 16个章节的关键信息
- ✅ 生成符合MSDS数据结构的XML格式
- ✅ 支持进度显示和错误日志
- ✅ 多线程并行处理，提高效率
- ✅ **XML数据导入MySQL数据库**
- ✅ **批量数据库导入（自动去重）**
- ✅ **完整字段映射（基于dataupdates_ok.sql）**

## 环境要求
- Python 3.8+
- 依赖库：见 requirements.txt

## 快速开始

### 方案A: 完整流程（PDF → 数据库）⭐ 推荐

```powershell
# 1. 安装依赖（包含数据库连接器）
pip install -r requirements.txt

# 2. 一键完成：PDF转XML + 导入数据库
python pdf_to_database_full_workflow.py -i ../aboutproject/doc -o ./output --password your_db_password
```

### 方案B: 仅PDF转XML

```bash
# 1. 安装依赖
pip install -r requirements.txt

# 2. 单个文件测试
python pdf_to_xml.py --input "test.pdf" --output "./output/test.xml"

# 3. 批量转换
python batch_convert.py --input-dir "../aboutproject/doc" --output-dir "./output"
```

### 方案C: 仅XML导入数据库

```bash
# 单个XML导入
python xml_to_database.py -i ./output/test.xml --password your_db_password

# 批量XML导入
python batch_import_to_database.py -i ./output --password your_db_password
```

## 目录结构
```
pdf2xml/
├── README.md                           # 项目说明
├── 快速入门.md                         # 5分钟入门
├── 使用说明.md                         # 详细文档
├── 数据库导入使用指南.md                # 数据库导入专题
├── FAQ.md                              # 常见问题
├── requirements.txt                    # Python依赖
│
├── pdf_to_xml.py                      # 单文件转换
├── batch_convert.py                   # 批量转换
├── xml_to_database.py                 # 单XML导入数据库 ⭐NEW
├── batch_import_to_database.py        # 批量导入数据库 ⭐NEW
├── pdf_to_database_full_workflow.py   # 完整流程（一键式） ⭐NEW
│
├── msds_parser.py                     # MSDS内容解析器
├── xml_generator.py                   # XML生成器
├── config.py                          # 配置文件
│
├── test_convert.bat/sh                # 测试脚本
├── batch_convert.bat/sh               # 批量转换脚本
├── start_convert.py                   # 简化启动脚本
│
├── output/                            # 输出目录
│   ├── *.xml                         # 生成的XML文件
│   ├── conversion_report.json        # 转换报告
│   └── import_report.json            # 导入报告 ⭐NEW
├── logs/                              # 日志目录
└── templates/                         # XML模板目录
```

## XML输出格式
生成的XML符合MSDS数据结构，包含以下主要字段：
- 化学品名称（中文/英文）
- CAS号
- 分子式
- 分子量
- 危险性分类
- 应急措施
- 等16个章节内容

## 注意事项
1. 确保PDF文件可读（非加密、非损坏）
2. 批量处理时建议使用SSD存储，提高IO速度
3. 大批量处理（>1000个文件）建议分批进行
4. 转换后请检查XML格式和内容完整性

## 常见问题
详见：FAQ.md


