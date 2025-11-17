# -*- coding: utf-8 -*-
"""
MSDS PDF转XML配置文件
"""

import os

# 输出目录配置
OUTPUT_DIR = "./output"
LOG_DIR = "./logs"
TEMPLATE_DIR = "./templates"

# 确保目录存在
for directory in [OUTPUT_DIR, LOG_DIR, TEMPLATE_DIR]:
    os.makedirs(directory, exist_ok=True)

# MSDS文档结构 - 16个章节
MSDS_SECTIONS = [
    "化学品及企业标识",
    "危险性概述",
    "成分/组成信息",
    "急救措施",
    "消防措施",
    "泄漏应急处理",
    "操作处置与储存",
    "接触控制/个体防护",
    "理化特性",
    "稳定性和反应活性",  # 注意：实际PDF中是"活性"而不是"性"
    "毒理学信息",
    "生态学资料",  # 注意：实际PDF中是"资料"而不是"信息"
    "废弃处置",
    "运输信息",
    "法规信息",
    "其他信息"
]

# 关键字段提取规则 - 针对特定PDF格式优化
FIELD_PATTERNS = {
    'chemical_name_cn': [
        r'中文[\s]*名[称]?[:：]\s*([^中文别名：\n\r]+)',
        r'化学品[\s]*中文[\s]*名[称]?[:：]\s*([^中文别名：\n\r]+)',
        r'产品[\s]*名称[:：]\s*([^中文别名：\n\r]+)'
    ],
    'chemical_name_en': [
        r'英文[\s]*名[称]?[:：]\s*([^中文别名：\n\r]+?)(?=英文别名|CAS号|$)',
        r'化学品[\s]*英文[\s]*名[称]?[:：]\s*([^中文别名：\n\r]+?)(?=英文别名|CAS号|$)',
        r'Product\s+name[:：]\s*([^中文别名：\n\r]+?)(?=英文别名|CAS号|$)',
        r'([a-zA-Z0-9,\-\(\)]+(?:trimethylbicyclo|thiocyanatoacetate|hexachloro|phenylethyl)[a-zA-Z0-9,\-\(\)]*)',
        # 处理跨行的英文名称
        r'([a-zA-Z0-9,\-\(\)]*trimethylbicyclo[a-zA-Z0-9,\-\(\)]*hept[a-zA-Z0-9,\-\(\)]*thiocyanatoacetate)',
        r'([a-zA-Z0-9,\-\(\)]*hexachloro[a-zA-Z0-9,\-\(\)]*trinorborn[a-zA-Z0-9,\-\(\)]*ylenedimethyl)',
        r'([a-zA-Z0-9,\-\(\)]*phenylethyl[a-zA-Z0-9,\-\(\)]*isocrotonate)'
    ],
    'synonyms': [
        r'中文[\s]*别名[:：]\s*([^\n\r]+)',
        r'英文[\s]*别名[:：]\s*([^\n\r]+)'
    ],
    'cas_number': [
        r'CAS[\s]*号?[:：]\s*([0-9\-]+)',
        r'CAS\s+No\.?[:：]\s*([0-9\-]+)',
        r'CAS[\s]*Registry[\s]*Number[:：]\s*([0-9\-]+)',
        r'CAS[:：]\s*([0-9\-]+)'
    ],
    'molecular_formula': [
        r'分子式[:：]\s*([A-Za-z0-9]+)',
        r'Molecular\s+Formula[:：]\s*([A-Za-z0-9]+)',
        r'分子式[:：]\s*([^\n\r]+)'
    ],
    'molecular_weight': [
        r'分子量[:：]\s*([0-9\.]+)',
        r'Molecular\s+Weight[:：]\s*([0-9\.]+)',
        r'相对分子质量[:：]\s*([0-9\.]+)',
        r'分子量[:：]\s*([^\n\r]+)'
    ],
    'synonyms': [
        r'别[\s]*名[:：]\s*([^\n\r]+)',
        r'Synonyms?[:：]\s*([^\n\r]+)',
        r'其他[\s]*名称[:：]\s*([^\n\r]+)',
        r'中文[\s]*别名[:：]\s*([^\n\r]+)',
        r'英文[\s]*别名[:：]\s*([^\n\r]+)'
    ],
    'manufacturer': [
        r'生产[\s]*企业[:：]\s*([^\n\r]+)',
        r'制造[\s]*商[:：]\s*([^\n\r]+)',
        r'Manufacturer[:：]\s*([^\n\r]+)',
        r'供应商[:：]\s*([^\n\r]+)'
    ],
    'supplier': [
        r'供应[\s]*商[:：]\s*([^\n\r]+)',
        r'Supplier[:：]\s*([^\n\r]+)',
        r'供应商[:：]\s*([^\n\r]+)'
    ],
    'msds_code': [
        r'技术说明书编码[:：]\s*([^\n\r]+)',
        r'MSDS[\s]*编码[:：]\s*([^\n\r]+)',
        r'说明书[\s]*编码[:：]\s*([^\n\r]+)'
    ]
}

# 批量处理配置
BATCH_CONFIG = {
    'max_workers': 4,  # 并行线程数
    'chunk_size': 100,  # 每批处理文件数
    'timeout': 300,     # 单个文件处理超时（秒）
    'retry_times': 2    # 失败重试次数
}

# 日志配置
LOG_CONFIG = {
    'level': 'INFO',
    'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    'file': os.path.join(LOG_DIR, 'pdf_to_xml.log')
}

# PDF处理配置
PDF_CONFIG = {
    'password': None,       # PDF密码（如果有）
    'extract_images': False,  # 是否提取图片
    'page_range': None,     # 页面范围，None表示全部
    'resolution': 300       # DPI设置
}

# XML生成配置
XML_CONFIG = {
    'encoding': 'utf-8',
    'pretty_print': True,
    'xml_declaration': True,
    'doctype': '<!DOCTYPE msds SYSTEM "msds.dtd">'
}


