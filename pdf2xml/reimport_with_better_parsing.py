#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
重新导入MSDS数据（改进版解析）
"""

import mysql.connector
import re
from xml.etree import ElementTree as ET

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'msds_user',
    'password': 'msds_dev_password',
    'database': 'msds_dev',
    'charset': 'utf8mb4'
}

def clean_database(conn):
    """清空MSDS相关表"""
    cursor = conn.cursor()
    try:
        print("\n清空数据库...")
        cursor.execute("DELETE FROM msds_component WHERE 1=1")
        cursor.execute("DELETE FROM msds_main WHERE 1=1")
        conn.commit()
        print("✓ 数据库已清空")
    except Exception as e:
        conn.rollback()
        print(f"✗ 清空数据库失败: {e}")
        raise
    finally:
        cursor.close()

def extract_section_text(xml_path):
    """从XML提取完整文本"""
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    # 合并所有section的文本
    sections = root.find('sections')
    if sections is None:
        return ""
    
    all_text = []
    for section in sections.findall('section'):
        text = section.text or ''
        if text:
            all_text.append(text)
    
    return '\n'.join(all_text)

def parse_msds_data(text):
    """改进的MSDS数据解析"""
    data = {}
    
    # 第一部分：化学品及企业标识
    # 中文名称 - 特殊处理，可能跨行
    match = re.search(r'中文名称[：:]\s+([^\n]+)?\n?([^\n]+)?\s+中文别名', text, re.MULTILINE | re.DOTALL)
    if match:
        name_parts = []
        if match.group(1):
            name_parts.append(match.group(1).strip())
        if match.group(2) and not '中文别名' in match.group(2):
            name_parts.append(match.group(2).strip())
        if name_parts:
            # 合并成完整名称
            full_name = ''.join(name_parts)
            # 只保留中文部分
            chinese_only = re.sub(r'[a-zA-Z\(\)\[\]\{\}\-0-9]+', '', full_name).strip()
            if chinese_only:
                data['product_name'] = chinese_only
            else:
                data['product_name'] = full_name
    
    # 中文别名
    match = re.search(r'中文别名[：:]\s*([^\n]+?)(?:\s+英文名称|$)', text, re.MULTILINE)
    if match:
        alias = match.group(1).strip()
        # 移除"酸酯；"这类标签文字前缀
        alias = re.sub(r'^[^;；]+[;；]\s*', '', alias)
        data['product_alias'] = alias
    
    # 英文名称 - 提取到英文别名之前
    match = re.search(r'英文名称[：:]\s*([^\n]+?)\s+英文别名', text, re.MULTILINE)
    if match:
        english = match.group(1).strip()
        # 移除尾部可能的换行内容
        english = re.sub(r'\s*-\s*$', '', english)
        data['product_english_name'] = english
    
    # CAS号
    match = re.search(r'CAS号[：:]\s*([0-9\-]+)', text)
    if match:
        data['cas_number'] = match.group(1).strip()
    
    # MSDS编号
    match = re.search(r'技术说明书编码[：:]\s*(MSDS#?\d+)', text)
    if match:
        data['msds_code'] = match.group(1).strip()
    
    # 供应商信息 - 检查是否有实际内容（非空非标签）
    # 如果字段后紧跟着其他"供应商"开头的字段，说明是空的
    match = re.search(r'供应商名称[：:]\s+([^\s供][^\n]{2,100}?)(?=\s+供应商|第二部分|$)', text, re.MULTILINE)
    if match:
        value = match.group(1).strip()
        if not value.startswith('供应商'):
            data['company_name'] = value
    
    # 第二部分：危险性概述
    match = re.search(r'危险性类别[：:]\s*([^\n]+?)(?=\s+侵入途径|$)', text)
    if match:
        data['hazard_category'] = match.group(1).strip()
    
    match = re.search(r'侵入途径[：:]\s*([^\n]+?)(?=\s+健康危害|吸入、摄入|$)', text)
    if match:
        data['exposure_routes'] = match.group(1).strip()
    
    # 健康危害 - 多行内容
    match = re.search(r'健康危害[：:]\s*(.+?)(?=环境危害[：:]|第三部分)', text, re.MULTILINE | re.DOTALL)
    if match:
        health = match.group(1).strip()
        # 清理多余空白
        health = re.sub(r'\s+', ' ', health)
        data['health_hazards'] = health
    
    match = re.search(r'环境危害[：:]\s*([^\n]+?)(?=\s+燃爆危险|$)', text)
    if match:
        data['environmental_hazards'] = match.group(1).strip()
    
    match = re.search(r'燃爆危险[：:]\s*([^\n]+?)(?=\s+第三部分|$)', text)
    if match:
        data['fire_explosion_hazards'] = match.group(1).strip()
    
    # 第三部分：成分信息
    match = re.search(r'有害物成分[：:]\s*([^\n]+)', text)
    if match:
        data['hazardous_components'] = match.group(1).strip()
    
    match = re.search(r'含量[：:]\s*([^\n]+)', text)
    if match:
        data['content_percentage'] = match.group(1).strip()
    
    # 第四部分：急救措施
    match = re.search(r'皮肤接触[：:]\s*([^\n]+?)(?=\s+眼睛接触|$)', text)
    if match:
        data['skin_contact'] = match.group(1).strip()
    
    match = re.search(r'眼睛接触[：:]\s*([^\n]+?)(?=\s+吸入|$)', text)
    if match:
        data['eye_contact'] = match.group(1).strip()
    
    match = re.search(r'吸入[：:]\s*([^\n]+?)(?=\s+食入|$)', text)
    if match:
        data['inhalation'] = match.group(1).strip()
    
    match = re.search(r'食入[：:]\s*([^\n]+?)(?=\s+第五部分|$)', text)
    if match:
        data['ingestion'] = match.group(1).strip()
    
    # 第五部分：消防措施
    match = re.search(r'危险特性[：:]\s*([^\n]+?)(?=\s+建规火险|有害燃烧|$)', text)
    if match:
        data['hazardous_characteristics'] = match.group(1).strip()
    
    match = re.search(r'有害燃烧产物[：:]\s*([^\n]+?)(?=\s+灭火方法|$)', text)
    if match:
        data['hazardous_combustion_products'] = match.group(1).strip()
    
    match = re.search(r'灭火方法[：:]\s*([^\n]+?)(?=\s+第六部分|$)', text)
    if match:
        data['extinguishing_media'] = match.group(1).strip()
    
    # 第六部分：泄漏应急处理
    match = re.search(r'应急处理[：:]\s*(.+?)(?=第七部分)', text, re.MULTILINE | re.DOTALL)
    if match:
        emergency = match.group(1).strip()
        emergency = re.sub(r'\s+', ' ', emergency)
        data['emergency_response'] = emergency
    
    # 第七部分：操作处置与储存
    match = re.search(r'操作注意事项[：:]\s*([^\n]+?)(?=\s+储存|$)', text)
    if match:
        data['handling_precautions'] = match.group(1).strip()
    
    match = re.search(r'储存注意事项[：:]\s*(.+?)(?=第八部分)', text, re.MULTILINE | re.DOTALL)
    if match:
        storage = match.group(1).strip()
        storage = re.sub(r'\s+', ' ', storage)
        data['storage_precautions'] = storage
    
    # 第八部分：接触控制/个体防护
    match = re.search(r'中国MAC\(mg/m3\)[：:]\s*([^\n]+)', text)
    if match:
        data['china_mac'] = match.group(1).strip()
    
    match = re.search(r'工程控制[：:]\s*([^\n]+?)(?=\s+呼吸系统|$)', text)
    if match:
        data['engineering_controls'] = match.group(1).strip()
    
    match = re.search(r'呼吸系统防护[：:]\s*(.+?)(?=眼睛防护[：:])', text, re.MULTILINE | re.DOTALL)
    if match:
        resp = match.group(1).strip()
        resp = re.sub(r'\s+', ' ', resp)
        data['respiratory_protection'] = resp
    
    match = re.search(r'眼睛防护[：:]\s*([^\n]+)', text)
    if match:
        data['eye_protection'] = match.group(1).strip()
    
    match = re.search(r'身体防护[：:]\s*([^\n]+)', text)
    if match:
        data['body_protection'] = match.group(1).strip()
    
    match = re.search(r'手防护[：:]\s*([^\n]+)', text)
    if match:
        data['hand_protection'] = match.group(1).strip()
    
    # 第九部分：理化特性
    match = re.search(r'熔点\(℃\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['melting_point'] = match.group(1).strip()
    
    match = re.search(r'沸点\(℃\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['boiling_point'] = match.group(1).strip()
    
    match = re.search(r'闪点\(℃\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['flash_point'] = match.group(1).strip()
    
    match = re.search(r'相对密度\(水=1\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['relative_density'] = match.group(1).strip()
    
    match = re.search(r'溶解性[：:]\s*([^\n]+?)(?=\s+相对密度|$)', text)
    if match:
        data['solubility'] = match.group(1).strip()
    
    # 第十部分：稳定性和反应活性
    match = re.search(r'稳定性[：:]\s*([^\n]+)', text)
    if match:
        data['stability'] = match.group(1).strip()
    
    match = re.search(r'禁配物[：:]\s*([^\n]+)', text)
    if match:
        data['incompatible_materials'] = match.group(1).strip()
    
    match = re.search(r'避免接触的条件[：:]\s*([^\n]+)', text)
    if match:
        data['conditions_to_avoid'] = match.group(1).strip()
    
    match = re.search(r'聚合危害[：:]\s*([^\n]+)', text)
    if match:
        data['polymerization_hazards'] = match.group(1).strip()
    
    match = re.search(r'分解产物[：:]\s*([^\n]+)', text)
    if match:
        data['decomposition_products'] = match.group(1).strip()
    
    # 第十一部分：毒理学信息
    match = re.search(r'急性毒性[：:]\s*(.+?)(?=第十二部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        toxicity = match.group(1).strip()
        toxicity = re.sub(r'\s+', ' ', toxicity)
        data['acute_toxicity'] = toxicity
    
    # 第十二部分：生态学信息
    match = re.search(r'生态毒性[：:]\s*([^\n]+)', text)
    if match:
        data['ecotoxicity'] = match.group(1).strip()
    
    # 第十三部分：废弃处置
    match = re.search(r'废弃物性质[：:]\s*([^\n]+)', text)
    if match:
        data['waste_nature'] = match.group(1).strip()
    
    match = re.search(r'废弃处置方法[：:]\s*(.+?)(?=第十四部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        disposal = match.group(1).strip()
        disposal = re.sub(r'\s+', ' ', disposal)
        data['disposal_method'] = disposal
    
    # 第十四部分：运输信息
    match = re.search(r'危险货物编号[：:]\s*([^\n]+)', text)
    if match:
        data['dangerous_goods_number'] = match.group(1).strip()
    
    match = re.search(r'UN编号[：:]\s*([^\n]+)', text)
    if match:
        data['un_number'] = match.group(1).strip()
    
    match = re.search(r'包装类别[：:]\s*([^\n]+)', text)
    if match:
        data['packing_group'] = match.group(1).strip()
    
    match = re.search(r'包装方法[：:]\s*(.+?)(?=运输注意事项|第十五部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        packing = match.group(1).strip()
        packing = re.sub(r'\s+', ' ', packing)
        data['packing_method'] = packing
    
    match = re.search(r'运输注意事项[：:]\s*(.+?)(?=第十五部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        transport = match.group(1).strip()
        transport = re.sub(r'\s+', ' ', transport)
        data['transport_precautions'] = transport
    
    # 第十五部分：法规信息
    match = re.search(r'法规信息[：:]\s*(.+?)(?=第十六部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        regulations = match.group(1).strip()
        regulations = re.sub(r'\s+', ' ', regulations)
        data['regulatory_information'] = regulations
    
    return data

def import_to_database(conn, data):
    """导入数据到数据库"""
    cursor = conn.cursor()
    
    try:
        # 插入msds_main表
        sql = """
        INSERT INTO msds_main (
            cas_number, product_name, product_alias, product_english_name, msds_code,
            company_name, company_address, contact_phone, emergency_phone, fax_number, email,
            hazard_category, exposure_routes, health_hazards, environmental_hazards, fire_explosion_hazards,
            skin_contact, eye_contact, inhalation, ingestion,
            hazardous_characteristics, hazardous_combustion_products, extinguishing_media,
            emergency_response,
            handling_precautions, storage_precautions,
            china_mac, engineering_controls, respiratory_protection, eye_protection, body_protection, hand_protection,
            melting_point, boiling_point, flash_point, relative_density, solubility,
            stability, incompatible_materials, conditions_to_avoid, polymerization_hazards, decomposition_products,
            acute_toxicity,
            ecotoxicity,
            waste_nature, disposal_method,
            dangerous_goods_number, un_number, packing_group, packing_method, transport_precautions,
            regulatory_information,
            create_time, update_time
        ) VALUES (
            %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s,
            %s, %s, %s, %s,
            %s, %s, %s,
            %s,
            %s, %s,
            %s, %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s,
            %s,
            %s,
            %s, %s,
            %s, %s, %s, %s, %s,
            %s,
            NOW(), NOW()
        )
        """
        
        values = (
            data.get('cas_number', ''),
            data.get('product_name', ''),
            data.get('product_alias', ''),
            data.get('product_english_name', ''),
            data.get('msds_code', ''),
            data.get('company_name', ''),
            data.get('company_address', ''),
            data.get('contact_phone', ''),
            data.get('emergency_phone', ''),
            data.get('fax_number', ''),
            data.get('email', ''),
            data.get('hazard_category', ''),
            data.get('exposure_routes', ''),
            data.get('health_hazards', ''),
            data.get('environmental_hazards', ''),
            data.get('fire_explosion_hazards', ''),
            data.get('skin_contact', ''),
            data.get('eye_contact', ''),
            data.get('inhalation', ''),
            data.get('ingestion', ''),
            data.get('hazardous_characteristics', ''),
            data.get('hazardous_combustion_products', ''),
            data.get('extinguishing_media', ''),
            data.get('emergency_response', ''),
            data.get('handling_precautions', ''),
            data.get('storage_precautions', ''),
            data.get('china_mac', ''),
            data.get('engineering_controls', ''),
            data.get('respiratory_protection', ''),
            data.get('eye_protection', ''),
            data.get('body_protection', ''),
            data.get('hand_protection', ''),
            data.get('melting_point', ''),
            data.get('boiling_point', ''),
            data.get('flash_point', ''),
            data.get('relative_density', ''),
            data.get('solubility', ''),
            data.get('stability', ''),
            data.get('incompatible_materials', ''),
            data.get('conditions_to_avoid', ''),
            data.get('polymerization_hazards', ''),
            data.get('decomposition_products', ''),
            data.get('acute_toxicity', ''),
            data.get('ecotoxicity', ''),
            data.get('waste_nature', ''),
            data.get('disposal_method', ''),
            data.get('dangerous_goods_number', ''),
            data.get('un_number', ''),
            data.get('packing_group', ''),
            data.get('packing_method', ''),
            data.get('transport_precautions', ''),
            data.get('regulatory_information', '')
        )
        
        cursor.execute(sql, values)
        conn.commit()
        
        print(f"\n✓ 数据导入成功!")
        print(f"  - CAS号: {data.get('cas_number', '')}")
        print(f"  - 产品名称: {data.get('product_name', '')}")
        print(f"  - 中文别名: {data.get('product_alias', '')}")
        print(f"  - 英文名称: {data.get('product_english_name', '')}")
        
    except Exception as e:
        conn.rollback()
        print(f"\n✗ 导入失败: {e}")
        raise
    finally:
        cursor.close()

def main():
    """主函数"""
    print("="*60)
    print("MSDS数据重新导入（改进版解析）")
    print("="*60)
    
    xml_file = 'output/(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.xml'
    
    # 连接数据库
    print("\n连接数据库...")
    conn = mysql.connector.connect(**DB_CONFIG)
    print("✓ 数据库连接成功")
    
    try:
        # 清空数据库
        clean_database(conn)
        
        # 提取并解析XML
        print("\n解析XML文件...")
        text = extract_section_text(xml_file)
        print(f"✓ 提取文本长度: {len(text)} 字符")
        
        # 解析MSDS数据
        print("\n解析MSDS数据...")
        data = parse_msds_data(text)
        print(f"✓ 提取到 {len(data)} 个字段")
        
        # 导入数据库
        print("\n导入数据到数据库...")
        import_to_database(conn, data)
        
        print("\n" + "="*60)
        print("✓ 导入完成！")
        print("="*60)
        
    finally:
        conn.close()

if __name__ == '__main__':
    main()

