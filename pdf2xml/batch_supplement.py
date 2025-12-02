#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MSDS文件批量补全工具
用于批量补全MSDS XML文件中的缺失字段
"""

import os
import xml.etree.ElementTree as ET
import re
import logging
from pathlib import Path
from typing import Dict, List, Optional
import time

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('msds_supplement.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class MSDSSupplementer:
    """MSDS文件补全器"""
    
    def __init__(self, output_dir: str):
        self.output_dir = Path(output_dir)
        self.processed_count = 0
        self.failed_count = 0
        self.skipped_count = 0
        
    def parse_filename(self, filename: str) -> Dict[str, str]:
        """从文件名解析化学品信息
        
        文件名格式：中文名、英文名、CAS号.xml
        或：中文名,英文名,CAS号.xml
        """
        try:
            # 移除.xml后缀
            name_part = filename.replace('.xml', '')
            
            # 尝试用顿号分隔
            if '、' in name_part:
                parts = name_part.split('、')
            # 尝试用逗号分隔  
            elif ',' in name_part:
                parts = name_part.split(',')
            else:
                logger.warning(f"无法解析文件名: {filename}")
                return {}
                
            if len(parts) >= 3:
                return {
                    'chinese_name': parts[0].strip(),
                    'english_name': parts[1].strip(),
                    'cas_number': parts[2].strip()
                }
            else:
                logger.warning(f"文件名格式不正确: {filename}")
                return {}
                
        except Exception as e:
            logger.error(f"解析文件名失败 {filename}: {e}")
            return {}
    
    def supplement_xml_file(self, file_path: Path) -> bool:
        """补全单个XML文件"""
        try:
            # 解析文件名获取基本信息
            filename = file_path.name
            file_info = self.parse_filename(filename)
            
            if not file_info:
                logger.warning(f"跳过文件（无法解析文件名）: {filename}")
                self.skipped_count += 1
                return False
            
            # 读取XML文件
            tree = ET.parse(file_path)
            root = tree.getroot()
            
            # 找到msds节点
            msds_node = root.find('msds')
            if msds_node is None:
                logger.warning(f"找不到msds节点: {filename}")
                self.skipped_count += 1
                return False
            
            # 补全基本信息
            basic_info = msds_node.find('basic_info')
            if basic_info is not None:
                self.supplement_basic_info(basic_info, file_info)
            
            # 检查是否需要补全其他字段
            self.supplement_other_fields(msds_node, file_info)
            
            # 保存文件
            tree.write(file_path, encoding='utf-8', xml_declaration=True)
            logger.info(f"✓ 补全完成: {filename}")
            self.processed_count += 1
            return True
            
        except Exception as e:
            logger.error(f"✗ 补全失败 {filename}: {e}")
            self.failed_count += 1
            return False
    
    def supplement_basic_info(self, basic_info: ET.Element, file_info: Dict[str, str]):
        """补全基本信息"""
        # 补全产品名称
        product_name = basic_info.find('product_name')
        if product_name is not None and not product_name.text:
            product_name.text = file_info['chinese_name']
        
        # 补全英文名称
        product_english_name = basic_info.find('product_english_name')
        if product_english_name is not None and not product_english_name.text:
            product_english_name.text = file_info['english_name']
        
        # 补全CAS号
        cas_number = basic_info.find('cas_number')
        if cas_number is not None and not cas_number.text:
            cas_number.text = file_info['cas_number']
        
        # 补全别名（使用英文名称作为别名）
        product_alias = basic_info.find('product_alias')
        if product_alias is not None and not product_alias.text:
            product_alias.text = file_info['english_name']
    
    def supplement_other_fields(self, msds_node: ET.Element, file_info: Dict[str, str]):
        """补全其他重要字段"""
        # 补全成分信息
        component_info = msds_node.find('component_info')
        if component_info is not None:
            components = component_info.find('components')
            if components is not None:
                for component in components.findall('component'):
                    component_name = component.find('component_name')
                    if component_name is not None and not component_name.text:
                        component_name.text = file_info['chinese_name']
                    
                    component_cas = component.find('cas_number')
                    if component_cas is not None and not component_cas.text:
                        component_cas.text = file_info['cas_number']
    
    def process_batch(self, start_idx: int, batch_size: int = 100) -> Dict[str, int]:
        """处理一批文件"""
        logger.info(f"开始处理第 {start_idx+1} 到 {start_idx+batch_size} 个文件")
        
        # 读取pending_files.txt获取待处理文件列表
        pending_file = self.output_dir / "pending_files.txt"
        if not pending_file.exists():
            logger.error("找不到pending_files.txt文件")
            return {'processed': 0, 'failed': 0, 'skipped': 0}
        
        try:
            with open(pending_file, 'r', encoding='utf-8') as f:
                all_files = [line.strip() for line in f if line.strip()]
        except Exception as e:
            logger.error(f"读取pending_files.txt失败: {e}")
            return {'processed': 0, 'failed': 0, 'skipped': 0}
        
        # 获取当前批次的文件
        end_idx = min(start_idx + batch_size, len(all_files))
        batch_files = all_files[start_idx:end_idx]
        
        logger.info(f"本批次共 {len(batch_files)} 个文件")
        
        # 处理每个文件
        for i, file_info in enumerate(batch_files):
            if i >= batch_size:
                break
                
            # 解析文件信息
            parts = file_info.split('、') if '、' in file_info else file_info.split(',')
            if len(parts) >= 3:
                xml_filename = parts[-1].strip()  # 最后一个部分是文件名
                xml_file_path = self.output_dir / xml_filename
                
                if xml_file_path.exists():
                    self.supplement_xml_file(xml_file_path)
                else:
                    logger.warning(f"文件不存在: {xml_filename}")
                    self.skipped_count += 1
        
        result = {
            'processed': self.processed_count,
            'failed': self.failed_count,
            'skipped': self.skipped_count
        }
        
        logger.info(f"批次处理完成: 成功={self.processed_count}, 失败={self.failed_count}, 跳过={self.skipped_count}")
        return result
    
    def update_progress_list(self, completed_files: List[str]):
        """更新补全清单"""
        progress_file = self.output_dir / "MSDS补全清单.md"
        
        try:
            # 读取现有内容
            if progress_file.exists():
                with open(progress_file, 'r', encoding='utf-8') as f:
                    content = f.read()
            else:
                content = ""
            
            # 添加新完成的文件
            new_entries = []
            for filename in completed_files:
                file_info = self.parse_filename(filename)
                if file_info:
                    entry = f"- [x] {file_info['chinese_name']}、{file_info['english_name']}、{file_info['cas_number']}.xml"
                    new_entries.append(entry)
            
            if new_entries:
                # 在最新更新说明后添加新条目
                if "最新更新说明" in content:
                    lines = content.split('\n')
                    insert_idx = -1
                    for i, line in enumerate(lines):
                        if "最新更新说明" in line:
                            insert_idx = i + 2  # 跳过标题和空行
                            break
                    
                    if insert_idx != -1:
                        lines[insert_idx:insert_idx] = new_entries
                        new_content = '\n'.join(lines)
                        
                        with open(progress_file, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        
                        logger.info(f"更新补全清单，新增 {len(new_entries)} 个条目")
                        
        except Exception as e:
            logger.error(f"更新补全清单失败: {e}")

def main():
    """主函数"""
    output_dir = r"d:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output"
    
    # 创建补全器
    supplementer = MSDSSupplementer(output_dir)
    
    # 处理第一批文件（1-100）
    logger.info("=== 开始处理MSDS文件补全任务 ===")
    result = supplementer.process_batch(start_idx=0, batch_size=100)
    
    logger.info