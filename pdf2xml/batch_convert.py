# -*- coding: utf-8 -*-
"""
PDF批量转XML处理脚本
支持多线程并行处理，进度显示，错误重试
"""

import os
import sys
import argparse
import logging
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
import json
from datetime import datetime

from pdf_to_xml import extract_pdf_text, setup_logging
from msds_parser import MSDSParser
from xml_generator import XMLGenerator, XMLValidator
from config import BATCH_CONFIG, OUTPUT_DIR, LOG_DIR


class BatchConverter:
    """批量转换器"""
    
    def __init__(self, input_dir: str, output_dir: str, max_workers: int = None):
        """
        初始化批量转换器
        
        Args:
            input_dir: 输入目录
            output_dir: 输出目录
            max_workers: 最大并行线程数
        """
        self.input_dir = Path(input_dir)
        self.output_dir = Path(output_dir)
        self.max_workers = max_workers or BATCH_CONFIG['max_workers']
        
        self.logger = logging.getLogger(__name__)
        
        # 确保输出目录存在
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # 统计信息
        self.stats = {
            'total': 0,
            'success': 0,
            'failed': 0,
            'skipped': 0,
            'start_time': None,
            'end_time': None
        }
        
        # 失败记录
        self.failed_files = []
    
    def find_pdf_files(self) -> list:
        """查找所有PDF文件"""
        pdf_files = list(self.input_dir.glob("**/*.pdf")) + \
                   list(self.input_dir.glob("**/*.PDF"))
        
        self.logger.info(f"找到 {len(pdf_files)} 个PDF文件")
        return pdf_files
    
    def convert_single_file(self, pdf_path: Path, skip_existing: bool = True) -> tuple[bool, str]:
        """
        转换单个文件
        
        Args:
            pdf_path: PDF文件路径
            skip_existing: 是否跳过已存在的文件
            
        Returns:
            (是否成功, 消息)
        """
        try:
            # 生成输出路径
            relative_path = pdf_path.relative_to(self.input_dir)
            xml_path = self.output_dir / relative_path.with_suffix('.xml')
            
            # 检查是否已存在
            if skip_existing and xml_path.exists():
                return True, "已存在，跳过"
            
            # 确保输出目录存在
            xml_path.parent.mkdir(parents=True, exist_ok=True)
            
            # 提取文本
            text = extract_pdf_text(str(pdf_path))
            
            if not text or len(text) < 100:
                return False, "文本内容过少"
            
            # 解析MSDS
            parser = MSDSParser()
            filename_info = parser.extract_from_filename(pdf_path.name)
            parsed_info = parser.parse(text)
            msds_data = parser.merge_info(parsed_info, filename_info)
            
            # 验证数据
            is_valid, errors = parser.validate(msds_data)
            if not is_valid:
                self.logger.debug(f"数据验证警告 [{pdf_path.name}]: {', '.join(errors)}")
            
            # 生成XML
            generator = XMLGenerator()
            success = generator.generate(msds_data, str(xml_path))
            
            if success:
                return True, "转换成功"
            else:
                return False, "XML生成失败"
                
        except Exception as e:
            return False, f"异常: {str(e)}"
    
    def convert_batch(self, skip_existing: bool = True, retry_failed: bool = True) -> dict:
        """
        批量转换
        
        Args:
            skip_existing: 是否跳过已存在的文件
            retry_failed: 是否重试失败的文件
            
        Returns:
            统计信息字典
        """
        self.stats['start_time'] = datetime.now()
        
        # 查找所有PDF文件
        pdf_files = self.find_pdf_files()
        self.stats['total'] = len(pdf_files)
        
        if not pdf_files:
            self.logger.warning("未找到PDF文件")
            return self.stats
        
        self.logger.info(f"开始批量转换，使用 {self.max_workers} 个线程")
        self.logger.info(f"输入目录: {self.input_dir}")
        self.logger.info(f"输出目录: {self.output_dir}")
        
        # 使用线程池并行处理
        with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            # 提交任务
            future_to_file = {
                executor.submit(self.convert_single_file, pdf_path, skip_existing): pdf_path
                for pdf_path in pdf_files
            }
            
            # 进度条
            with tqdm(total=len(pdf_files), desc="转换进度", unit="文件") as pbar:
                for future in as_completed(future_to_file):
                    pdf_path = future_to_file[future]
                    
                    try:
                        success, message = future.result(timeout=BATCH_CONFIG['timeout'])
                        
                        if success:
                            if message == "已存在，跳过":
                                self.stats['skipped'] += 1
                            else:
                                self.stats['success'] += 1
                        else:
                            self.stats['failed'] += 1
                            self.failed_files.append({
                                'file': str(pdf_path),
                                'reason': message
                            })
                            self.logger.error(f"转换失败 [{pdf_path.name}]: {message}")
                        
                    except Exception as e:
                        self.stats['failed'] += 1
                        self.failed_files.append({
                            'file': str(pdf_path),
                            'reason': f"异常: {str(e)}"
                        })
                        self.logger.error(f"转换异常 [{pdf_path.name}]: {e}")
                    
                    pbar.update(1)
        
        self.stats['end_time'] = datetime.now()
        
        # 保存统计信息
        self.save_report()
        
        return self.stats
    
    def save_report(self):
        """保存转换报告"""
        report_path = self.output_dir / "conversion_report.json"
        
        duration = (self.stats['end_time'] - self.stats['start_time']).total_seconds()
        
        report = {
            'stats': {
                'total': self.stats['total'],
                'success': self.stats['success'],
                'failed': self.stats['failed'],
                'skipped': self.stats['skipped'],
                'success_rate': f"{self.stats['success']/self.stats['total']*100:.2f}%" if self.stats['total'] > 0 else "0%",
                'duration_seconds': duration,
                'files_per_second': self.stats['success'] / duration if duration > 0 else 0
            },
            'failed_files': self.failed_files,
            'start_time': self.stats['start_time'].isoformat(),
            'end_time': self.stats['end_time'].isoformat()
        }
        
        with open(report_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, ensure_ascii=False, indent=2)
        
        self.logger.info(f"转换报告已保存: {report_path}")
    
    def print_summary(self):
        """打印转换摘要"""
        print("\n" + "=" * 60)
        print("批量转换完成!")
        print("=" * 60)
        print(f"总文件数: {self.stats['total']}")
        print(f"转换成功: {self.stats['success']}")
        print(f"转换失败: {self.stats['failed']}")
        print(f"跳过文件: {self.stats['skipped']}")
        
        if self.stats['total'] > 0:
            success_rate = self.stats['success'] / self.stats['total'] * 100
            print(f"成功率: {success_rate:.2f}%")
        
        if self.stats['start_time'] and self.stats['end_time']:
            duration = (self.stats['end_time'] - self.stats['start_time']).total_seconds()
            print(f"耗时: {duration:.2f} 秒")
            
            if duration > 0:
                speed = self.stats['success'] / duration
                print(f"处理速度: {speed:.2f} 文件/秒")
        
        print("=" * 60)
        
        if self.failed_files:
            print("\n失败文件列表:")
            for item in self.failed_files[:10]:  # 只显示前10个
                print(f"  - {Path(item['file']).name}: {item['reason']}")
            
            if len(self.failed_files) > 10:
                print(f"  ... 还有 {len(self.failed_files) - 10} 个失败文件")
            
            print(f"\n详细信息请查看: {self.output_dir}/conversion_report.json")


def main():
    """主函数"""
    parser = argparse.ArgumentParser(
        description='MSDS PDF批量转XML工具',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  # 批量转换目录下所有PDF
  python batch_convert.py -i ../aboutproject/doc -o ./output
  
  # 使用8个线程并行处理
  python batch_convert.py -i ./pdfs -o ./output -w 8
  
  # 不跳过已存在的文件（重新转换）
  python batch_convert.py -i ./pdfs -o ./output --no-skip
        """
    )
    
    parser.add_argument('-i', '--input-dir', required=True, help='输入PDF目录')
    parser.add_argument('-o', '--output-dir', default=OUTPUT_DIR, help='输出XML目录')
    parser.add_argument('-w', '--workers', type=int, help='并行线程数')
    parser.add_argument('--no-skip', action='store_true', help='不跳过已存在的文件')
    parser.add_argument('-v', '--verbose', action='store_true', help='详细输出模式')
    
    args = parser.parse_args()
    
    # 配置日志
    setup_logging(args.verbose)
    logger = logging.getLogger(__name__)
    
    # 检查输入目录
    if not os.path.exists(args.input_dir):
        logger.error(f"输入目录不存在: {args.input_dir}")
        return 1
    
    # 创建批量转换器
    converter = BatchConverter(
        input_dir=args.input_dir,
        output_dir=args.output_dir,
        max_workers=args.workers
    )
    
    # 执行批量转换
    try:
        converter.convert_batch(skip_existing=not args.no_skip)
        converter.print_summary()
        return 0
        
    except KeyboardInterrupt:
        logger.warning("\n用户中断转换")
        converter.print_summary()
        return 1
    
    except Exception as e:
        logger.error(f"批量转换失败: {e}", exc_info=True)
        return 1


if __name__ == '__main__':
    sys.exit(main())


