#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
MSDS完整工作流：PDF → XML → 数据库
一键完成：PDF转换 + 数据库导入
"""

import sys
import os
from pathlib import Path
import argparse

def check_dependencies():
    """检查依赖是否安装"""
    missing = []
    
    try:
        import pdfplumber
    except ImportError:
        missing.append('pdfplumber')
    
    try:
        import lxml
    except ImportError:
        missing.append('lxml')
    
    try:
        import tqdm
    except ImportError:
        missing.append('tqdm')
    
    try:
        import mysql.connector
    except ImportError:
        missing.append('mysql-connector-python')
    
    if missing:
        print("=" * 60)
        print("❌ 缺少依赖包:")
        for pkg in missing:
            print(f"   - {pkg}")
        print("\n请运行: pip install -r requirements.txt")
        print("=" * 60)
        return False
    
    return True


def run_pdf_to_xml(pdf_dir: str, xml_dir: str, workers: int = 4) -> bool:
    """步骤1: PDF转XML"""
    from batch_convert import BatchConverter
    
    print("\n" + "=" * 60)
    print("步骤 1/2: PDF转XML")
    print("=" * 60)
    
    try:
        converter = BatchConverter(
            input_dir=pdf_dir,
            output_dir=xml_dir,
            max_workers=workers
        )
        
        converter.convert_batch(skip_existing=True)
        converter.print_summary()
        
        # 检查是否有成功的文件
        if converter.stats['success'] == 0:
            print("\n❌ 没有成功转换的文件，无法继续导入数据库")
            return False
        
        return True
        
    except Exception as e:
        print(f"\n❌ PDF转XML失败: {e}")
        import traceback
        traceback.print_exc()
        return False


def run_xml_to_database(xml_dir: str, db_config: dict) -> bool:
    """步骤2: XML导入数据库"""
    from batch_import_to_database import BatchImporter
    
    print("\n" + "=" * 60)
    print("步骤 2/2: XML导入数据库")
    print("=" * 60)
    
    try:
        importer = BatchImporter(
            xml_dir=xml_dir,
            db_config=db_config
        )
        
        importer.import_batch(skip_existing=True)
        importer.print_summary()
        
        return True
        
    except Exception as e:
        print(f"\n❌ XML导入数据库失败: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    """主函数"""
    parser = argparse.ArgumentParser(
        description='MSDS完整工作流：PDF → XML → 数据库',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  # 完整流程（PDF → 数据库）
  python pdf_to_database_full_workflow.py \\
    -i ../aboutproject/doc \\
    -o ./output \\
    --password your_password
  
  # 使用8个线程加速
  python pdf_to_database_full_workflow.py \\
    -i ../aboutproject/doc \\
    -o ./output \\
    -w 8 \\
    --password your_password
        """
    )
    
    # PDF转XML参数
    parser.add_argument('-i', '--input', required=True, help='输入PDF目录')
    parser.add_argument('-o', '--output', default='./output', help='XML输出目录')
    parser.add_argument('-w', '--workers', type=int, default=4, help='转换线程数')
    
    # 数据库参数
    parser.add_argument('--host', default='localhost', help='数据库主机')
    parser.add_argument('--port', type=int, default=3306, help='数据库端口')
    parser.add_argument('--user', default='root', help='数据库用户名')
    parser.add_argument('--password', required=True, help='数据库密码')
    parser.add_argument('--database', default='msds_management', help='数据库名称')
    
    # 流程控制
    parser.add_argument('--only-convert', action='store_true', help='只执行PDF转XML')
    parser.add_argument('--only-import', action='store_true', help='只执行XML导入数据库')
    
    args = parser.parse_args()
    
    print("=" * 60)
    print("MSDS完整工作流：PDF → XML → 数据库")
    print("=" * 60)
    print(f"\nPDF目录: {args.input}")
    print(f"XML目录: {args.output}")
    print(f"数据库: {args.host}:{args.port}/{args.database}")
    print()
    
    # 检查依赖
    print("检查依赖...")
    if not check_dependencies():
        return 1
    print("✓ 依赖检查通过\n")
    
    # 配置数据库
    db_config = {
        'host': args.host,
        'port': args.port,
        'user': args.user,
        'password': args.password,
        'database': args.database,
        'charset': 'utf8mb4'
    }
    
    # 执行流程
    success = True
    
    # 步骤1: PDF转XML
    if not args.only_import:
        success = run_pdf_to_xml(args.input, args.output, args.workers)
        
        if not success:
            print("\n❌ PDF转XML失败，流程中断")
            return 1
    
    # 步骤2: XML导入数据库
    if not args.only_convert and success:
        success = run_xml_to_database(args.output, db_config)
        
        if not success:
            print("\n❌ XML导入数据库失败")
            return 1
    
    # 完成
    print("\n" + "=" * 60)
    print("✓ 完整流程执行完成！")
    print("=" * 60)
    
    print("\n结果文件:")
    print(f"  - XML文件: {args.output}/")
    print(f"  - 转换报告: {args.output}/conversion_report.json")
    print(f"  - 导入报告: {args.output}/import_report.json")
    print(f"  - 日志文件: logs/pdf_to_xml.log")
    
    return 0


if __name__ == '__main__':
    sys.exit(main())

