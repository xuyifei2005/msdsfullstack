#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
MSDS XML批量导入数据库工具
批量处理output目录下的所有XML文件并导入到数据库
"""

import os
import sys
from pathlib import Path
from tqdm import tqdm
import json
from datetime import datetime

from xml_to_database import MSDSXMLParser, MSDSDatabaseImporter, DB_CONFIG


class BatchImporter:
    """批量导入器"""
    
    def __init__(self, xml_dir: str, db_config: dict):
        self.xml_dir = Path(xml_dir)
        self.db_config = db_config
        
        self.stats = {
            'total': 0,
            'success': 0,
            'failed': 0,
            'skipped': 0,
            'start_time': None,
            'end_time': None
        }
        
        self.failed_files = []
    
    def find_xml_files(self) -> list:
        """查找所有XML文件"""
        xml_files = list(self.xml_dir.glob("**/*.xml"))
        print(f"找到 {len(xml_files)} 个XML文件")
        return xml_files
    
    def import_single_file(self, xml_path: Path, importer: MSDSDatabaseImporter) -> tuple:
        """导入单个XML文件"""
        try:
            # 解析XML
            parser = MSDSXMLParser()
            data = parser.parse_xml_file(str(xml_path))
            
            # 检查必填字段
            cas_number = data.get('basic_info', {}).get('cas_number', '')
            if not cas_number:
                return False, "缺少CAS号"
            
            # 检查是否已存在
            check_sql = "SELECT id FROM msds_main WHERE cas_number = %s"
            importer.cursor.execute(check_sql, (cas_number,))
            existing = importer.cursor.fetchone()
            
            if existing:
                return True, "已存在，跳过"
            
            # 导入数据
            success = importer.import_msds_data(data)
            
            if success:
                return True, "导入成功"
            else:
                return False, "导入失败"
                
        except Exception as e:
            return False, f"异常: {str(e)}"
    
    def import_batch(self, skip_existing: bool = True):
        """批量导入"""
        self.stats['start_time'] = datetime.now()
        
        # 查找所有XML文件
        xml_files = self.find_xml_files()
        self.stats['total'] = len(xml_files)
        
        if not xml_files:
            print("未找到XML文件")
            return
        
        print(f"\n开始批量导入到数据库...")
        print(f"数据库: {self.db_config['host']}:{self.db_config['port']}/{self.db_config['database']}")
        print()
        
        # 连接数据库
        importer = MSDSDatabaseImporter(self.db_config)
        if not importer.connect():
            print("数据库连接失败")
            return
        
        # 批量处理
        with tqdm(total=len(xml_files), desc="导入进度", unit="文件") as pbar:
            for xml_path in xml_files:
                success, message = self.import_single_file(xml_path, importer)
                
                if success:
                    if message == "已存在，跳过":
                        self.stats['skipped'] += 1
                    else:
                        self.stats['success'] += 1
                else:
                    self.stats['failed'] += 1
                    self.failed_files.append({
                        'file': str(xml_path.name),
                        'reason': message
                    })
                
                pbar.update(1)
        
        # 断开数据库连接
        importer.disconnect()
        
        self.stats['end_time'] = datetime.now()
        
        # 保存报告
        self.save_report()
    
    def save_report(self):
        """保存导入报告"""
        report_path = self.xml_dir / "import_report.json"
        
        duration = (self.stats['end_time'] - self.stats['start_time']).total_seconds()
        
        report = {
            'stats': {
                'total': self.stats['total'],
                'success': self.stats['success'],
                'failed': self.stats['failed'],
                'skipped': self.stats['skipped'],
                'success_rate': f"{self.stats['success']/self.stats['total']*100:.2f}%" if self.stats['total'] > 0 else "0%",
                'duration_seconds': duration
            },
            'failed_files': self.failed_files,
            'start_time': self.stats['start_time'].isoformat(),
            'end_time': self.stats['end_time'].isoformat()
        }
        
        with open(report_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, ensure_ascii=False, indent=2)
        
        print(f"\n导入报告已保存: {report_path}")
    
    def print_summary(self):
        """打印导入摘要"""
        print("\n" + "=" * 60)
        print("批量导入完成!")
        print("=" * 60)
        print(f"总文件数: {self.stats['total']}")
        print(f"导入成功: {self.stats['success']}")
        print(f"导入失败: {self.stats['failed']}")
        print(f"跳过文件: {self.stats['skipped']}")
        
        if self.stats['total'] > 0:
            success_rate = self.stats['success'] / self.stats['total'] * 100
            print(f"成功率: {success_rate:.2f}%")
        
        if self.stats['start_time'] and self.stats['end_time']:
            duration = (self.stats['end_time'] - self.stats['start_time']).total_seconds()
            print(f"耗时: {duration:.2f} 秒")
        
        print("=" * 60)
        
        if self.failed_files:
            print("\n失败文件列表:")
            for item in self.failed_files[:10]:
                print(f"  - {item['file']}: {item['reason']}")
            
            if len(self.failed_files) > 10:
                print(f"  ... 还有 {len(self.failed_files) - 10} 个失败文件")


def main():
    """主函数"""
    import argparse
    
    parser = argparse.ArgumentParser(description='MSDS XML批量导入数据库工具')
    parser.add_argument('-i', '--input-dir', default='./output', help='XML文件目录')
    parser.add_argument('--host', default='localhost', help='数据库主机')
    parser.add_argument('--port', type=int, default=3306, help='数据库端口')
    parser.add_argument('--user', default='root', help='数据库用户名')
    parser.add_argument('--password', required=True, help='数据库密码')
    parser.add_argument('--database', default='msds_management', help='数据库名称')
    
    args = parser.parse_args()
    
    # 配置数据库连接
    db_config = {
        'host': args.host,
        'port': args.port,
        'user': args.user,
        'password': args.password,
        'database': args.database,
        'charset': 'utf8mb4'
    }
    
    print("=" * 60)
    print("MSDS XML批量导入数据库工具")
    print("=" * 60)
    
    # 创建批量导入器
    importer = BatchImporter(
        xml_dir=args.input_dir,
        db_config=db_config
    )
    
    # 执行批量导入
    try:
        importer.import_batch(skip_existing=True)
        importer.print_summary()
        return 0
        
    except KeyboardInterrupt:
        print("\n用户中断导入")
        importer.print_summary()
        return 1
    
    except Exception as e:
        print(f"\n批量导入失败: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())

