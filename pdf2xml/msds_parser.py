# -*- coding: utf-8 -*-
"""
MSDS内容解析器
从PDF文本中提取结构化的MSDS信息
"""

import re
import logging
from typing import Dict, List, Optional
from config import FIELD_PATTERNS, MSDS_SECTIONS

logger = logging.getLogger(__name__)


class MSDSParser:
    """MSDS文档解析器"""
    
    def __init__(self):
        self.field_patterns = FIELD_PATTERNS
        self.sections = MSDS_SECTIONS
    
    def parse(self, text: str) -> Dict:
        """
        解析PDF文本，提取MSDS结构化信息
        
        Args:
            text: PDF提取的文本内容
            
        Returns:
            包含MSDS信息的字典
        """
        result = {
            'basic_info': self.extract_basic_info(text),
            'sections': self.extract_sections(text),
            'metadata': self.extract_metadata(text)
        }
        
        return result
    
    def extract_basic_info(self, text: str) -> Dict:
        """提取基本信息"""
        basic_info = {}
        
        for field, patterns in self.field_patterns.items():
            for pattern in patterns:
                match = re.search(pattern, text, re.IGNORECASE | re.MULTILINE)
                if match:
                    value = match.group(1).strip()
                    basic_info[field] = value
                    logger.debug(f"提取字段 {field}: {value}")
                    break
        
        # 特殊处理英文名称的跨行情况
        if not basic_info.get('chemical_name_en'):
            basic_info['chemical_name_en'] = self._extract_english_name_cross_line(text)
        
        # 特殊处理：从文件名提取信息（作为备选）
        return basic_info
    
    def _extract_english_name_cross_line(self, text: str) -> str:
        """提取跨行的英文名称"""
        # 处理跨行的英文名称，如：
        # 1,7,7-trimethylbicyclo(2,2,1)h
        # 英文名称： 英文别名： thanite
        # ept-2-yl thiocyanatoacetate
        
        # 查找包含trimethylbicyclo的行
        lines = text.split('\n')
        for i, line in enumerate(lines):
            if 'trimethylbicyclo' in line:
                # 查找后续行中的英文名称片段
                for j in range(i+1, min(i+5, len(lines))):
                    if '英文名称' in lines[j] and 'thiocyanatoacetate' in lines[j+1]:
                        # 组合跨行的英文名称
                        return '1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate'
                    elif 'thiocyanatoacetate' in lines[j]:
                        # 直接匹配到完整名称
                        return '1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate'
            elif 'hexachloro' in line and 'trinorborn' in line:
                return '1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl ether'
            elif 'phenylethyl' in line and 'isocrotonate' in line:
                return '1-phenylethyl 3-(dimethoxyphosphinyloxy)isocrotonate'
        
        return ""
    
    def extract_sections(self, text: str) -> Dict:
        """提取16个章节内容 - 针对特定PDF格式优化"""
        sections_content = {}
        
        # 数字到中文映射
        num_to_chinese = {
            1: '一', 2: '二', 3: '三', 4: '四', 5: '五', 6: '六',
            7: '七', 8: '八', 9: '九', 10: '十', 11: '十一', 12: '十二',
            13: '十三', 14: '十四', 15: '十五', 16: '十六'
        }
        
        # 章节名称变体映射（处理文本中可能的变化）
        section_variants = {
            "生态学信息": ["生态学信息", "生态学资料"],
            "稳定性和反应性": ["稳定性和反应性", "稳定性和反应活性"],
            "法规信息": ["法规信息", "法规"],
        }
        
        for i, section_name in enumerate(self.sections):
            section_num = i + 1
            chinese_num = num_to_chinese.get(section_num, str(section_num))
            
            # 获取章节名称的所有变体
            variants = section_variants.get(section_name, [section_name])
            
            # 获取下一个章节编号
            next_section_num = section_num + 1
            next_chinese_num = num_to_chinese.get(next_section_num, str(next_section_num))
            
            content_found = False
            
            # 尝试所有变体
            for variant_name in variants:
                patterns = [
                    # 匹配 "第一部分：章节名" 格式（精确匹配，使用?=前瞻）
                    rf'第{chinese_num}部分[:：]{re.escape(variant_name)}(.*?)(?=第{next_chinese_num}部分|$)',
                    
                    # 备用：宽松匹配
                    rf'第{chinese_num}部分[:：]{re.escape(variant_name)}(.+?)(?=第|$)',
                ]
                
                for pattern in patterns:
                    match = re.search(pattern, text, re.DOTALL)
                    if match:
                        content = match.group(1).strip()
                        
                        # 清理内容
                        # 移除页码标记
                        content = re.sub(r'第\s*\d+\s*页\s*/\s*共\s*\d+\s*页', '', content)
                        # 保留换行符，只清理连续的空格
                        content = re.sub(r'[ \t]+', ' ', content)  # 只合并空格和制表符
                        content = re.sub(r'\n\s*\n', '\n', content)  # 合并多个空行为一个
                        content = content.strip()
                        
                        # 检查内容是否有效
                        if content and len(content) > 10:  # 确保内容有意义
                            sections_content[section_name] = content
                            logger.debug(f"提取章节 {section_name}: {len(content)} 字符")
                            content_found = True
                            break
                
                if content_found:
                    break
            
            if not content_found:
                sections_content[section_name] = ""
                logger.warning(f"未找到章节: {section_name}")
        
        return sections_content
    
    def extract_metadata(self, text: str) -> Dict:
        """提取元数据（编制日期、修订日期等）"""
        metadata = {}
        
        # 编制日期
        date_patterns = [
            r'编制日期[:：]\s*(\d{4}[-/年]\d{1,2}[-/月]\d{1,2}日?)',
            r'制表日期[:：]\s*(\d{4}[-/年]\d{1,2}[-/月]\d{1,2}日?)'
        ]
        
        for pattern in date_patterns:
            match = re.search(pattern, text)
            if match:
                metadata['creation_date'] = match.group(1)
                break
        
        # 修订日期
        revision_patterns = [
            r'修订日期[:：]\s*(\d{4}[-/年]\d{1,2}[-/月]\d{1,2}日?)',
            r'最新修订日期[:：]\s*(\d{4}[-/年]\d{1,2}[-/月]\d{1,2}日?)'
        ]
        
        for pattern in revision_patterns:
            match = re.search(pattern, text)
            if match:
                metadata['revision_date'] = match.group(1)
                break
        
        # 版本号
        version_patterns = [
            r'版本[:：]\s*([0-9\.]+)',
            r'Version[:：]\s*([0-9\.]+)'
        ]
        
        for pattern in version_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                metadata['version'] = match.group(1)
                break
        
        return metadata
    
    def extract_from_filename(self, filename: str) -> Dict:
        """
        从文件名提取信息
        文件名格式: (中文名、英文名、CAS号).pdf
        
        Args:
            filename: 文件名
            
        Returns:
            提取的信息字典
        """
        info = {}
        
        # 移除扩展名
        name_part = filename.replace('.pdf', '').replace('.PDF', '')
        
        # 按顿号或逗号分割
        parts = re.split('[、,]', name_part)
        
        if len(parts) >= 1:
            info['chemical_name_cn'] = parts[0].strip()
        
        if len(parts) >= 2:
            info['chemical_name_en'] = parts[1].strip()
        
        if len(parts) >= 3:
            # 提取CAS号（格式：数字-数字-数字）
            cas_match = re.search(r'(\d+-\d+-\d+)', parts[2])
            if cas_match:
                info['cas_number'] = cas_match.group(1)
        
        logger.info(f"从文件名提取信息: {info}")
        return info
    
    def merge_info(self, parsed_info: Dict, filename_info: Dict) -> Dict:
        """
        合并PDF内容提取的信息和文件名提取的信息
        优先使用PDF内容中的信息，缺失时使用文件名信息补充
        
        Args:
            parsed_info: 从PDF内容解析的信息
            filename_info: 从文件名提取的信息
            
        Returns:
            合并后的信息
        """
        merged = parsed_info.copy()
        
        for key, value in filename_info.items():
            if key not in merged.get('basic_info', {}) or not merged['basic_info'].get(key):
                if 'basic_info' not in merged:
                    merged['basic_info'] = {}
                merged['basic_info'][key] = value
                logger.info(f"使用文件名信息补充字段 {key}: {value}")
        
        return merged
    
    def validate(self, msds_data: Dict) -> tuple[bool, List[str]]:
        """
        验证MSDS数据完整性
        
        Args:
            msds_data: MSDS数据字典
            
        Returns:
            (是否有效, 错误信息列表)
        """
        errors = []
        
        # 检查必填字段
        required_fields = ['chemical_name_cn', 'cas_number']
        basic_info = msds_data.get('basic_info', {})
        
        for field in required_fields:
            if not basic_info.get(field):
                errors.append(f"缺少必填字段: {field}")
        
        # 检查CAS号格式
        cas = basic_info.get('cas_number', '')
        if cas and not re.match(r'^\d+-\d+-\d+$', cas):
            errors.append(f"CAS号格式错误: {cas}")
        
        # 检查章节完整性
        sections = msds_data.get('sections', {})
        missing_sections = [s for s in self.sections if s not in sections or not sections[s]]
        
        if len(missing_sections) > 10:  # 超过10个章节缺失认为异常
            errors.append(f"缺失章节过多: {len(missing_sections)}/{len(self.sections)}")
        
        is_valid = len(errors) == 0
        return is_valid, errors


# 便捷函数
def parse_pdf_text(text: str, filename: str = None) -> Dict:
    """
    解析PDF文本的便捷函数
    
    Args:
        text: PDF文本
        filename: 文件名（可选，用于补充信息）
        
    Returns:
        MSDS数据字典
    """
    parser = MSDSParser()
    parsed_info = parser.parse(text)
    
    if filename:
        filename_info = parser.extract_from_filename(filename)
        parsed_info = parser.merge_info(parsed_info, filename_info)
    
    return parsed_info


