# PDF转XML常见问题解答 (FAQ)

## 安装与环境

### Q1: 如何安装Python依赖？
**A:** 在项目目录下运行：
```bash
# Windows
pip install -r requirements.txt

# Linux/Mac
pip3 install -r requirements.txt
```

### Q2: 提示找不到Python命令
**A:** 
- Windows: 确保Python已添加到系统PATH环境变量
- Linux/Mac: 使用`python3`命令而不是`python`
- 检查Python版本: `python --version` (需要3.8+)

### Q3: 依赖安装失败
**A:** 尝试以下方法：
```bash
# 使用国内镜像源
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 升级pip
python -m pip install --upgrade pip

# 使用虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

## 转换问题

### Q4: 转换后XML文件内容为空或缺失很多字段
**A:** 可能的原因和解决方法：
1. **扫描版PDF**: 需要OCR识别
   - 使用专业OCR软件先转换为可搜索PDF
   - 或使用tesseract-ocr库（需额外安装）

2. **PDF加密**: 
   - 先解密PDF
   - 修改`config.py`中的`PDF_CONFIG['password']`

3. **特殊格式**: 
   - 检查PDF是否可正常打开
   - 尝试用其他PDF阅读器重新保存

### Q5: 批量转换时部分文件失败
**A:** 
1. 查看转换报告: `output/conversion_report.json`
2. 查看日志文件: `logs/pdf_to_xml.log`
3. 单独测试失败的文件找出原因
4. 常见失败原因：
   - PDF损坏或加密
   - 文件名包含特殊字符
   - 磁盘空间不足
   - 内存不足

### Q6: 如何提高转换准确率？
**A:** 
1. 确保PDF是文本型而非扫描型
2. 调整`config.py`中的正则表达式模式
3. 针对特定格式的MSDS优化解析规则
4. 使用高质量的PDF源文件

### Q7: 转换速度太慢
**A:** 优化方法：
```bash
# 增加并行线程数
python batch_convert.py -i ./pdfs -o ./output -w 8

# 使用SSD存储
# 关闭详细日志
python batch_convert.py -i ./pdfs -o ./output  # 不加-v参数

# 分批处理
# 每次处理500个文件
```

## 使用技巧

### Q8: 如何只转换新增的PDF文件？
**A:** 默认会跳过已存在的XML文件：
```bash
# 只转换新文件（默认行为）
python batch_convert.py -i ./pdfs -o ./output

# 强制重新转换所有文件
python batch_convert.py -i ./pdfs -o ./output --no-skip
```

### Q9: 如何自定义XML格式？
**A:** 修改`xml_generator.py`中的`build_xml_tree`方法：
```python
def build_xml_tree(self, msds_data: Dict) -> etree.Element:
    root = etree.Element("msds")
    # 自定义XML结构
    ...
    return root
```

### Q10: 如何提取特定章节？
**A:** 修改`config.py`中的`MSDS_SECTIONS`列表：
```python
MSDS_SECTIONS = [
    "化学品及企业标识",
    "危险性概述",
    # 只保留需要的章节
]
```

### Q11: 如何处理中文文件名？
**A:** 
- Windows: 确保使用UTF-8编码
- 文件名过长: 脚本会自动处理
- 特殊字符: 避免使用`< > : " / \ | ? *`

### Q12: 如何验证转换质量？
**A:** 
1. 查看转换报告统计信息
2. 随机抽查几个XML文件
3. 使用XML验证工具
4. 导入数据库后检查字段完整性

## 性能与优化

### Q13: 内存占用过高
**A:** 
```python
# 减少并行线程数
python batch_convert.py -i ./pdfs -o ./output -w 2

# 分批处理
# 将PDF分成多个子目录，分批转换
```

### Q14: 最佳线程数设置
**A:** 
- CPU密集型: 线程数 = CPU核心数
- IO密集型: 线程数 = CPU核心数 * 2
- 推荐: 4-8个线程
- 测试命令: 
```bash
# 测试不同线程数的性能
python batch_convert.py -i ./test -o ./output -w 4
python batch_convert.py -i ./test -o ./output -w 8
```

### Q15: 大批量文件处理建议
**A:** 处理2000+文件时：
1. 分批处理，每批500-1000个
2. 使用SSD存储
3. 定期清理日志文件
4. 监控磁盘空间
5. 建议分多次运行，避免一次性处理

## 错误处理

### Q16: UnicodeDecodeError 错误
**A:** 
```python
# 修改config.py
XML_CONFIG = {
    'encoding': 'utf-8',  # 或 'gbk'
    ...
}
```

### Q17: PermissionError 权限错误
**A:** 
- Windows: 以管理员身份运行
- Linux/Mac: 使用`sudo`或修改文件权限
- 检查文件是否被占用（如PDF正在被阅读器打开）

### Q18: Memory Error 内存错误
**A:** 
- 减少并行线程数
- 关闭其他占用内存的程序
- 分批处理文件
- 增加系统虚拟内存

## 集成与扩展

### Q19: 如何集成到Java后端？
**A:** 两种方式：
1. 通过Java调用Python脚本
```java
ProcessBuilder pb = new ProcessBuilder("python", "pdf_to_xml.py", "-i", pdfPath, "-o", xmlPath);
Process p = pb.start();
```

2. 使用REST API方式（需额外开发）

### Q20: 如何批量导入到数据库？
**A:** 
1. 先批量生成XML
2. 使用Java解析XML导入数据库
3. 或编写Python脚本直接写入数据库
4. 参考: `aboutproject/msdsdatabases/MSDS批量导入操作指南.md`

## 其他

### Q21: 转换后的XML符合什么标准？
**A:** 
- 符合MSDS 16章节结构
- 包含基本信息（化学品名称、CAS号等）
- 可根据需求自定义格式

### Q22: 是否支持其他文件格式？
**A:** 当前只支持PDF格式。如需支持Word/Excel：
- Word: 使用`python-docx`库
- Excel: 使用`openpyxl`库
- 需要额外开发解析器

### Q23: 如何获取技术支持？
**A:** 
1. 查看日志文件: `logs/pdf_to_xml.log`
2. 查看转换报告: `output/conversion_report.json`
3. 提交Issue到项目仓库
4. 提供错误日志和示例PDF文件

---

## 联系方式
如有其他问题，请查看项目文档或提交Issue。


