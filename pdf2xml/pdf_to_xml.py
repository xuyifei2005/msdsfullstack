# -*- coding: utf-8 -*-
"""
PDF转XML单文件处理脚本
"""

import os
import sys
import argparse
import logging
from pathlib import Path
import pdfplumber
from colorlog import ColoredFormatter

from msds_parser import MSDSParser
from xml_generator import XMLGenerator, XMLValidator
from config import LOG_CONFIG, PDF_CONFIG

# 配置彩色日志
def setup_logging(verbose=False):
    """配置日志"""
    log_format = '%(log_color)s%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    
    formatter = ColoredFormatter(
        log_format,
        log_colors={
            'DEBUG': 'cyan',
            'INFO': 'green',
            'WARNING': 'yellow',
            'ERROR': 'red',
            'CRITICAL': 'red,bg_white',
        }
    )
    
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(level=level, handlers=[handler])
    
    # 文件日志
    if LOG_CONFIG.get('file'):
        file_handler = logging.FileHandler(LOG_CONFIG['file'], encoding='utf-8')
        file_handler.setFormatter(logging.Formatter(LOG_CONFIG['format']))
        logging.getLogger().addHandler(file_handler)


def extract_pdf_text(pdf_path: str) -> str:
    """
    从PDF提取文本
    
    Args:
        pdf_path: PDF文件路径
        
    Returns:
        提取的文本内容
    """
    logger = logging.getLogger(__name__)
    logger.info(f"开始提取PDF文本: {pdf_path}")
    
    text_content = ""
    
    try:
        with pdfplumber.open(pdf_path) as pdf:
            logger.info(f"PDF页数: {len(pdf.pages)}")
            
            for i, page in enumerate(pdf.pages, 1):
                logger.debug(f"提取第 {i}/{len(pdf.pages)} 页")
                page_text = page.extract_text()
                
                if page_text:
                    text_content += page_text + "\n\n"
            
            logger.info(f"文本提取完成，总字符数: {len(text_content)}")
            
    except Exception as e:
        logger.error(f"PDF文本提取失败: {e}")
        raise
    
    return text_content


def convert_pdf_to_xml(pdf_path: str, xml_path: str, validate: bool = True) -> bool:
    """
    转换PDF为XML
    
    Args:
        pdf_path: PDF文件路径
        xml_path: XML输出路径
        validate: 是否验证生成的XML
        
    Returns:
        是否成功
    """
    logger = logging.getLogger(__name__)
    
    try:
        # 1. 提取PDF文本
        logger.info("=" * 60)
        logger.info(f"开始转换: {pdf_path}")
        logger.info("=" * 60)
        
        text = extract_pdf_text(pdf_path)
        
        if not text or len(text) < 100:
            logger.warning("提取的文本内容过少，可能是扫描版PDF或提取失败")
            return False
        
        # 2. 解析MSDS信息
        logger.info("开始解析MSDS内容...")
        parser = MSDSParser()
        
        filename = os.path.basename(pdf_path)
        filename_info = parser.extract_from_filename(filename)
        parsed_info = parser.parse(text)
        msds_data = parser.merge_info(parsed_info, filename_info)
        
        # 3. 验证数据完整性
        is_valid, errors = parser.validate(msds_data)
        if not is_valid:
            logger.warning(f"数据验证警告: {', '.join(errors)}")
        
        # 4. 生成XML
        logger.info(f"生成XML文件: {xml_path}")
        generator = XMLGenerator()
        success = generator.generate(msds_data, xml_path)
        
        if not success:
            return False
        
        # 5. 验证XML格式
        if validate:
            logger.info("验证XML格式...")
            is_valid, message = XMLValidator.validate_xml(xml_path)
            
            if is_valid:
                logger.info(f"✓ XML验证通过: {message}")
            else:
                logger.error(f"✗ XML验证失败: {message}")
                return False
        
        logger.info("=" * 60)
        logger.info("转换完成！")
        logger.info("=" * 60)
        
        # 打印摘要信息
        basic_info = msds_data.get('basic_info', {})
        logger.info("MSDS信息摘要:")
        logger.info(f"  化学品名称(中): {basic_info.get('chemical_name_cn', '未提取')}")
        logger.info(f"  化学品名称(英): {basic_info.get('chemical_name_en', '未提取')}")
        logger.info(f"  CAS号: {basic_info.get('cas_number', '未提取')}")
        logger.info(f"  分子式: {basic_info.get('molecular_formula', '未提取')}")
        
        sections = msds_data.get('sections', {})
        filled_sections = len([s for s in sections.values() if s])
        logger.info(f"  章节完整度: {filled_sections}/{len(sections)}")
        
        return True
        
    except Exception as e:
        logger.error(f"转换失败: {e}", exc_info=True)
        return False


def main():
    """主函数"""
    parser = argparse.ArgumentParser(
        description='MSDS PDF转XML工具',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  # 转换单个PDF文件
  python pdf_to_xml.py -i input.pdf -o output.xml
  
  # 指定输出目录（自动生成文件名）
  python pdf_to_xml.py -i input.pdf --output-dir ./output
  
  # 详细模式
  python pdf_to_xml.py -i input.pdf -o output.xml -v
        """
    )
    
    parser.add_argument('-i', '--input', required=True, help='输入PDF文件路径')
    parser.add_argument('-o', '--output', help='输出XML文件路径')
    parser.add_argument('--output-dir', help='输出目录（自动生成文件名）')
    parser.add_argument('--no-validate', action='store_true', help='不验证生成的XML')
    parser.add_argument('-v', '--verbose', action='store_true', help='详细输出模式')
    
    args = parser.parse_args()
    
    # 配置日志
    setup_logging(args.verbose)
    logger = logging.getLogger(__name__)
    
    # 检查输入文件
    if not os.path.exists(args.input):
        logger.error(f"输入文件不存在: {args.input}")
        return 1
    
    # 确定输出路径
    if args.output:
        xml_path = args.output
    elif args.output_dir:
        os.makedirs(args.output_dir, exist_ok=True)
        basename = os.path.splitext(os.path.basename(args.input))[0]
        xml_path = os.path.join(args.output_dir, f"{basename}.xml")
    else:
        logger.error("必须指定 --output 或 --output-dir")
        return 1
    
    # 确保输出目录存在
    output_dir = os.path.dirname(xml_path)
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)
    
    # 执行转换
    success = convert_pdf_to_xml(args.input, xml_path, not args.no_validate)
    
    return 0 if success else 1


if __name__ == '__main__':
    sys.exit(main())


