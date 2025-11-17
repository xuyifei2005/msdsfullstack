#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
正确的MSDS数据导入脚本
将16个章节的数据导入到对应的数据库表中
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
        # 按依赖关系顺序删除
        tables = [
            'msds_component', 'msds_hazard', 'msds_first_aid', 
            'msds_fire_fighting', 'msds_leak_response', 'msds_handling_storage',
            'msds_exposure_control', 'msds_physical_chemical', 'msds_stability_reactivity',
            'msds_toxicological', 'msds_ecological', 'msds_disposal',
            'msds_transportation', 'msds_regulatory', 'msds_main'
        ]
        for table in tables:
            cursor.execute(f"DELETE FROM {table} WHERE 1=1")
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
    """改进的MSDS数据解析 - 分16个章节"""
    data = {}
    
    # 第一部分：化学品及企业标识
    data['main'] = {}
    
    # 中文名称
    match = re.search(r'中文名称[：:]\s+([^\n]+)?\n?([^\n]+)?\s+中文别名', text, re.MULTILINE | re.DOTALL)
    if match:
        name_parts = []
        if match.group(1):
            name_parts.append(match.group(1).strip())
        if match.group(2) and not '中文别名' in match.group(2):
            name_parts.append(match.group(2).strip())
        if name_parts:
            full_name = ''.join(name_parts)
            chinese_only = re.sub(r'[a-zA-Z\(\)\[\]\{\}\-0-9]+', '', full_name).strip()
            data['main']['product_name'] = chinese_only if chinese_only else full_name
    
    # 中文别名
    match = re.search(r'中文别名[：:]\s*([^\n]+?)(?=\s+英文名称|$)', text, re.MULTILINE)
    if match:
        data['main']['product_alias'] = match.group(1).strip()
    
    # 英文名称
    match = re.search(r'英文名称[：:]\s*([^\n]+?)\s+英文别名', text, re.MULTILINE)
    if match:
        data['main']['product_english_name'] = match.group(1).strip()
    
    # CAS号
    match = re.search(r'CAS号[：:]\s*([0-9\-]+)', text)
    if match:
        data['main']['cas_number'] = match.group(1).strip()
    
    # MSDS编号
    match = re.search(r'技术说明书编码[：:]\s*(MSDS#?\d+)', text)
    if match:
        data['main']['msds_code'] = match.group(1).strip()
    
    # 供应商信息
    match = re.search(r'供应商名称[：:]\s+([^\s供][^\n]{2,100}?)(?=\s+供应商|第二部分|$)', text, re.MULTILINE)
    if match:
        value = match.group(1).strip()
        if not value.startswith('供应商'):
            data['main']['company_name'] = value
    
    # 供应商电话
    match = re.search(r'供应商电话[：:]\s+([^\s供][^\n]{2,50}?)(?=\s+供应商|第二部分|$)', text, re.MULTILINE)
    if match:
        value = match.group(1).strip()
        if not value.startswith('供应商'):
            data['main']['contact_phone'] = value
    
    # 第二部分：危险性概述
    data['hazard'] = {}
    
    match = re.search(r'危险性类别[：:]\s*([^\n]+?)(?=\s+侵入途径|$)', text)
    if match:
        data['hazard']['hazard_category'] = match.group(1).strip()
    
    match = re.search(r'侵入途径[：:]\s*([^\n]+?)(?=\s+健康危害|吸入、摄入|$)', text)
    if match:
        data['hazard']['exposure_routes'] = match.group(1).strip()
    
    match = re.search(r'健康危害[：:]\s*(.+?)(?=环境危害[：:]|第三部分)', text, re.MULTILINE | re.DOTALL)
    if match:
        health = match.group(1).strip()
        health = re.sub(r'\s+', ' ', health)
        data['hazard']['health_hazards'] = health
    
    match = re.search(r'环境危害[：:]\s*([^\n]+?)(?=\s+燃爆危险|$)', text)
    if match:
        data['hazard']['environmental_hazards'] = match.group(1).strip()
    
    match = re.search(r'燃爆危险[：:]\s*([^\n]+?)(?=\s+第三部分|$)', text)
    if match:
        data['hazard']['fire_explosion_hazards'] = match.group(1).strip()
    
    # 第三部分：成分/组成信息
    data['component'] = {}
    
    match = re.search(r'有害物成分[：:]\s*([^\n]+)', text)
    if match:
        data['component']['component_name'] = match.group(1).strip()
    
    match = re.search(r'含量[：:]\s*([^\n]+)', text)
    if match:
        data['component']['component_content'] = match.group(1).strip()
    
    # 第四部分：急救措施
    data['first_aid'] = {}
    
    match = re.search(r'皮肤接触[：:]\s*([^\n]+?)(?=\s+眼睛接触|$)', text)
    if match:
        data['first_aid']['skin_contact'] = match.group(1).strip()
    
    match = re.search(r'眼睛接触[：:]\s*([^\n]+?)(?=\s+吸入|$)', text)
    if match:
        data['first_aid']['eye_contact'] = match.group(1).strip()
    
    match = re.search(r'吸入[：:]\s*([^\n]+?)(?=\s+食入|$)', text)
    if match:
        data['first_aid']['inhalation'] = match.group(1).strip()
    
    match = re.search(r'食入[：:]\s*([^\n]+?)(?=\s+第五部分|$)', text)
    if match:
        data['first_aid']['ingestion'] = match.group(1).strip()
    
    # 第五部分：消防措施
    data['fire_fighting'] = {}
    
    match = re.search(r'危险特性[：:]\s*([^\n]+?)(?=\s+建规火险|有害燃烧|$)', text)
    if match:
        data['fire_fighting']['hazard_characteristics'] = match.group(1).strip()
    
    match = re.search(r'有害燃烧产物[：:]\s*([^\n]+?)(?=\s+灭火方法|$)', text)
    if match:
        data['fire_fighting']['harmful_combustion_products'] = match.group(1).strip()
    
    match = re.search(r'灭火方法[：:]\s*([^\n]+?)(?=\s+第六部分|$)', text)
    if match:
        data['fire_fighting']['suitable_extinguishing_media'] = match.group(1).strip()
    
    # 第六部分：泄漏应急处理
    data['leak_response'] = {}
    
    match = re.search(r'应急处理[：:]\s*(.+?)(?=第七部分)', text, re.MULTILINE | re.DOTALL)
    if match:
        emergency = match.group(1).strip()
        emergency = re.sub(r'\s+', ' ', emergency)
        data['leak_response']['emergency_procedures'] = emergency
    
    # 第七部分：操作处置与储存
    data['handling_storage'] = {}
    
    match = re.search(r'操作注意事项[：:]\s*([^\n]+?)(?=\s+储存|$)', text)
    if match:
        data['handling_storage']['handling_precautions'] = match.group(1).strip()
    
    match = re.search(r'储存注意事项[：:]\s*(.+?)(?=第八部分)', text, re.MULTILINE | re.DOTALL)
    if match:
        storage = match.group(1).strip()
        storage = re.sub(r'\s+', ' ', storage)
        data['handling_storage']['storage_precautions'] = storage
    
    # 第八部分：接触控制/个体防护
    data['exposure_control'] = {}
    
    match = re.search(r'中国MAC\(mg/m3\)[：:]\s*([^\n]+)', text)
    if match:
        data['exposure_control']['china_mac'] = match.group(1).strip()
    
    match = re.search(r'前苏联MAC\(mg/m3\)[：:]\s*([^\n]+)', text)
    if match:
        data['exposure_control']['former_soviet_mac'] = match.group(1).strip()
    
    match = re.search(r'工程控制[：:]\s*([^\n]+?)(?=\s+呼吸系统|$)', text)
    if match:
        data['exposure_control']['engineering_controls'] = match.group(1).strip()
    
    match = re.search(r'呼吸系统防护[：:]\s*(.+?)(?=眼睛防护[：:])', text, re.MULTILINE | re.DOTALL)
    if match:
        resp = match.group(1).strip()
        resp = re.sub(r'\s+', ' ', resp)
        data['exposure_control']['respiratory_protection'] = resp
    
    match = re.search(r'眼睛防护[：:]\s*([^\n]+)', text)
    if match:
        data['exposure_control']['eye_protection'] = match.group(1).strip()
    
    match = re.search(r'身体防护[：:]\s*([^\n]+)', text)
    if match:
        data['exposure_control']['body_protection'] = match.group(1).strip()
    
    match = re.search(r'手防护[：:]\s*([^\n]+)', text)
    if match:
        data['exposure_control']['hand_protection'] = match.group(1).strip()
    
    # 第九部分：理化特性
    data['physical_chemical'] = {}
    
    match = re.search(r'熔点\(℃\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['physical_chemical']['melting_point'] = match.group(1).strip()
    
    match = re.search(r'沸点\(℃\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['physical_chemical']['boiling_point'] = match.group(1).strip()
    
    match = re.search(r'闪点\(℃\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['physical_chemical']['flash_point'] = match.group(1).strip()
    
    match = re.search(r'相对密度\(水=1\)[：:]\s*([^\s\n]+)', text)
    if match:
        data['physical_chemical']['relative_density'] = match.group(1).strip()
    
    match = re.search(r'溶解性[：:]\s*([^\n]+?)(?=\s+相对密度|$)', text)
    if match:
        data['physical_chemical']['solubility'] = match.group(1).strip()
    
    match = re.search(r'分子式[：:]\s*([^\s\n]+)', text)
    if match:
        data['physical_chemical']['molecular_formula'] = match.group(1).strip()
    
    match = re.search(r'分子量[：:]\s*([^\s\n]+)', text)
    if match:
        data['physical_chemical']['molecular_weight'] = match.group(1).strip()
    
    # 第十部分：稳定性和反应活性
    data['stability_reactivity'] = {}
    
    match = re.search(r'稳定性[：:]\s*([^\n]+)', text)
    if match:
        data['stability_reactivity']['stability'] = match.group(1).strip()
    
    match = re.search(r'禁配物[：:]\s*([^\n]+)', text)
    if match:
        data['stability_reactivity']['incompatible_substances'] = match.group(1).strip()
    
    match = re.search(r'避免接触的条件[：:]\s*([^\n]+)', text)
    if match:
        data['stability_reactivity']['conditions_to_avoid'] = match.group(1).strip()
    
    match = re.search(r'聚合危害[：:]\s*([^\n]+)', text)
    if match:
        data['stability_reactivity']['polymerization_hazard'] = match.group(1).strip()
    
    match = re.search(r'分解产物[：:]\s*([^\n]+)', text)
    if match:
        data['stability_reactivity']['decomposition_products'] = match.group(1).strip()
    
    # 第十一部分：毒理学信息
    data['toxicological'] = {}
    
    match = re.search(r'急性毒性[：:]\s*(.+?)(?=第十二部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        toxicity = match.group(1).strip()
        toxicity = re.sub(r'\s+', ' ', toxicity)
        data['toxicological']['acute_toxicity'] = toxicity
    
    # 第十二部分：生态学信息
    data['ecological'] = {}
    
    match = re.search(r'生态毒性[：:]\s*([^\n]+)', text)
    if match:
        data['ecological']['ecological_toxicity'] = match.group(1).strip()
    
    # 第十三部分：废弃处置
    data['disposal'] = {}
    
    match = re.search(r'废弃物性质[：:]\s*([^\n]+)', text)
    if match:
        data['disposal']['waste_properties'] = match.group(1).strip()
    
    match = re.search(r'废弃处置方法[：:]\s*(.+?)(?=第十四部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        disposal = match.group(1).strip()
        disposal = re.sub(r'\s+', ' ', disposal)
        data['disposal']['disposal_method'] = disposal
    
    # 第十四部分：运输信息
    data['transportation'] = {}
    
    match = re.search(r'危险货物编号[：:]\s*([^\n]+)', text)
    if match:
        data['transportation']['dangerous_goods_number'] = match.group(1).strip()
    
    match = re.search(r'UN编号[：:]\s*([^\n]+)', text)
    if match:
        data['transportation']['un_number'] = match.group(1).strip()
    
    match = re.search(r'包装类别[：:]\s*([^\n]+)', text)
    if match:
        data['transportation']['packing_group'] = match.group(1).strip()
    
    match = re.search(r'包装方法[：:]\s*(.+?)(?=运输注意事项|第十五部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        packing = match.group(1).strip()
        packing = re.sub(r'\s+', ' ', packing)
        data['transportation']['packaging_method'] = packing
    
    match = re.search(r'运输注意事项[：:]\s*(.+?)(?=第十五部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        transport = match.group(1).strip()
        transport = re.sub(r'\s+', ' ', transport)
        data['transportation']['transportation_precautions'] = transport
    
    # 第十五部分：法规信息
    data['regulatory'] = {}
    
    match = re.search(r'法规信息[：:]\s*(.+?)(?=第十六部分|$)', text, re.MULTILINE | re.DOTALL)
    if match:
        regulations = match.group(1).strip()
        regulations = re.sub(r'\s+', ' ', regulations)
        data['regulatory']['regulatory_info'] = regulations
    
    return data

def import_to_database(conn, data):
    """导入数据到数据库的各个表"""
    cursor = conn.cursor()
    
    try:
        # 1. 插入msds_main表
        main_data = data.get('main', {})
        sql_main = """
        INSERT INTO msds_main (
            cas_number, msds_code, product_name, product_alias, product_english_name,
            company_name, contact_phone, status, is_active, create_time, update_time
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, 'approved', 1, NOW(), NOW())
        """
        values_main = (
            main_data.get('cas_number', ''),
            main_data.get('msds_code', ''),
            main_data.get('product_name', ''),
            main_data.get('product_alias', ''),
            main_data.get('product_english_name', ''),
            main_data.get('company_name', ''),
            main_data.get('contact_phone', '')  # 添加联系电话字段
        )
        cursor.execute(sql_main, values_main)
        msds_id = cursor.lastrowid
        
        print(f"\n✓ msds_main 插入成功 (ID: {msds_id})")
        print(f"  - CAS号: {main_data.get('cas_number', '')}")
        print(f"  - 产品名称: {main_data.get('product_name', '')}")
        
        # 2. 插入msds_hazard表
        hazard_data = data.get('hazard', {})
        if hazard_data:
            sql_hazard = """
            INSERT INTO msds_hazard (
                msds_id, hazard_category, exposure_routes, health_hazards,
                environmental_hazards, fire_explosion_hazards
            ) VALUES (%s, %s, %s, %s, %s, %s)
            """
            values_hazard = (
                msds_id,
                hazard_data.get('hazard_category', ''),
                hazard_data.get('exposure_routes', ''),
                hazard_data.get('health_hazards', ''),
                hazard_data.get('environmental_hazards', ''),
                hazard_data.get('fire_explosion_hazards', '')
            )
            cursor.execute(sql_hazard, values_hazard)
            print(f"✓ msds_hazard 插入成功")
        
        # 3. 插入msds_component表
        component_data = data.get('component', {})
        if component_data.get('component_name'):
            sql_component = """
            INSERT INTO msds_component (
                msds_id, component_name, component_content
            ) VALUES (%s, %s, %s)
            """
            values_component = (
                msds_id,
                component_data.get('component_name', ''),
                component_data.get('component_content', '')
            )
            cursor.execute(sql_component, values_component)
            print(f"✓ msds_component 插入成功")
        
        # 4. 插入msds_first_aid表
        first_aid_data = data.get('first_aid', {})
        if first_aid_data:
            sql_first_aid = """
            INSERT INTO msds_first_aid (
                msds_id, skin_contact, eye_contact, inhalation, ingestion
            ) VALUES (%s, %s, %s, %s, %s)
            """
            values_first_aid = (
                msds_id,
                first_aid_data.get('skin_contact', ''),
                first_aid_data.get('eye_contact', ''),
                first_aid_data.get('inhalation', ''),
                first_aid_data.get('ingestion', '')
            )
            cursor.execute(sql_first_aid, values_first_aid)
            print(f"✓ msds_first_aid 插入成功")
        
        # 5. 插入msds_fire_fighting表
        fire_data = data.get('fire_fighting', {})
        if fire_data:
            sql_fire = """
            INSERT INTO msds_fire_fighting (
                msds_id, hazard_characteristics, harmful_combustion_products,
                suitable_extinguishing_media
            ) VALUES (%s, %s, %s, %s)
            """
            values_fire = (
                msds_id,
                fire_data.get('hazard_characteristics', ''),
                fire_data.get('harmful_combustion_products', ''),
                fire_data.get('suitable_extinguishing_media', '')
            )
            cursor.execute(sql_fire, values_fire)
            print(f"✓ msds_fire_fighting 插入成功")
        
        # 6. 插入msds_leak_response表
        leak_data = data.get('leak_response', {})
        if leak_data:
            sql_leak = """
            INSERT INTO msds_leak_response (
                msds_id, emergency_procedures
            ) VALUES (%s, %s)
            """
            values_leak = (
                msds_id,
                leak_data.get('emergency_procedures', '')
            )
            cursor.execute(sql_leak, values_leak)
            print(f"✓ msds_leak_response 插入成功")
        
        # 7. 插入msds_handling_storage表
        handling_data = data.get('handling_storage', {})
        if handling_data:
            sql_handling = """
            INSERT INTO msds_handling_storage (
                msds_id, handling_precautions, storage_precautions
            ) VALUES (%s, %s, %s)
            """
            values_handling = (
                msds_id,
                handling_data.get('handling_precautions', ''),
                handling_data.get('storage_precautions', '')
            )
            cursor.execute(sql_handling, values_handling)
            print(f"✓ msds_handling_storage 插入成功")
        
        # 8. 插入msds_exposure_control表
        exposure_data = data.get('exposure_control', {})
        if exposure_data:
            sql_exposure = """
            INSERT INTO msds_exposure_control (
                msds_id, china_mac, former_soviet_mac, engineering_controls,
                respiratory_protection, eye_protection, body_protection, hand_protection
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            values_exposure = (
                msds_id,
                exposure_data.get('china_mac', ''),
                exposure_data.get('former_soviet_mac', ''),
                exposure_data.get('engineering_controls', ''),
                exposure_data.get('respiratory_protection', ''),
                exposure_data.get('eye_protection', ''),
                exposure_data.get('body_protection', ''),
                exposure_data.get('hand_protection', '')
            )
            cursor.execute(sql_exposure, values_exposure)
            print(f"✓ msds_exposure_control 插入成功")
        
        # 9. 插入msds_physical_chemical表
        physical_data = data.get('physical_chemical', {})
        if physical_data:
            sql_physical = """
            INSERT INTO msds_physical_chemical (
                msds_id, melting_point, boiling_point, flash_point, relative_density,
                solubility, molecular_formula, molecular_weight
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            values_physical = (
                msds_id,
                physical_data.get('melting_point', ''),
                physical_data.get('boiling_point', ''),
                physical_data.get('flash_point', ''),
                physical_data.get('relative_density', ''),
                physical_data.get('solubility', ''),
                physical_data.get('molecular_formula', ''),
                physical_data.get('molecular_weight', '')
            )
            cursor.execute(sql_physical, values_physical)
            print(f"✓ msds_physical_chemical 插入成功")
        
        # 10. 插入msds_stability_reactivity表
        stability_data = data.get('stability_reactivity', {})
        if stability_data:
            sql_stability = """
            INSERT INTO msds_stability_reactivity (
                msds_id, stability, incompatible_substances, conditions_to_avoid,
                polymerization_hazard, decomposition_products
            ) VALUES (%s, %s, %s, %s, %s, %s)
            """
            values_stability = (
                msds_id,
                stability_data.get('stability', ''),
                stability_data.get('incompatible_substances', ''),
                stability_data.get('conditions_to_avoid', ''),
                stability_data.get('polymerization_hazard', ''),
                stability_data.get('decomposition_products', '')
            )
            cursor.execute(sql_stability, values_stability)
            print(f"✓ msds_stability_reactivity 插入成功")
        
        # 11. 插入msds_toxicological表
        toxicological_data = data.get('toxicological', {})
        if toxicological_data:
            sql_toxicological = """
            INSERT INTO msds_toxicological (
                msds_id, acute_toxicity
            ) VALUES (%s, %s)
            """
            values_toxicological = (
                msds_id,
                toxicological_data.get('acute_toxicity', '')
            )
            cursor.execute(sql_toxicological, values_toxicological)
            print(f"✓ msds_toxicological 插入成功")
        
        # 12. 插入msds_ecological表
        ecological_data = data.get('ecological', {})
        if ecological_data:
            sql_ecological = """
            INSERT INTO msds_ecological (
                msds_id, ecological_toxicity
            ) VALUES (%s, %s)
            """
            values_ecological = (
                msds_id,
                ecological_data.get('ecological_toxicity', '')
            )
            cursor.execute(sql_ecological, values_ecological)
            print(f"✓ msds_ecological 插入成功")
        
        # 13. 插入msds_disposal表
        disposal_data = data.get('disposal', {})
        if disposal_data:
            sql_disposal = """
            INSERT INTO msds_disposal (
                msds_id, waste_properties, disposal_method
            ) VALUES (%s, %s, %s)
            """
            values_disposal = (
                msds_id,
                disposal_data.get('waste_properties', ''),
                disposal_data.get('disposal_method', '')
            )
            cursor.execute(sql_disposal, values_disposal)
            print(f"✓ msds_disposal 插入成功")
        
        # 14. 插入msds_transportation表
        transportation_data = data.get('transportation', {})
        if transportation_data:
            sql_transportation = """
            INSERT INTO msds_transportation (
                msds_id, dangerous_goods_number, un_number, packing_group,
                packaging_method, transportation_precautions
            ) VALUES (%s, %s, %s, %s, %s, %s)
            """
            values_transportation = (
                msds_id,
                transportation_data.get('dangerous_goods_number', ''),
                transportation_data.get('un_number', ''),
                transportation_data.get('packing_group', ''),
                transportation_data.get('packaging_method', ''),
                transportation_data.get('transportation_precautions', '')
            )
            cursor.execute(sql_transportation, values_transportation)
            print(f"✓ msds_transportation 插入成功")
        
        # 15. 插入msds_regulatory表
        regulatory_data = data.get('regulatory', {})
        if regulatory_data:
            sql_regulatory = """
            INSERT INTO msds_regulatory (
                msds_id, regulatory_info
            ) VALUES (%s, %s)
            """
            values_regulatory = (
                msds_id,
                regulatory_data.get('regulatory_info', '')
            )
            cursor.execute(sql_regulatory, values_regulatory)
            print(f"✓ msds_regulatory 插入成功")
        
        conn.commit()
        print(f"\n{'='*60}")
        print(f"✓ 所有数据导入成功！(msds_id: {msds_id})")
        print(f"{'='*60}")
        
    except Exception as e:
        conn.rollback()
        print(f"\n✗ 导入失败: {e}")
        import traceback
        traceback.print_exc()
        raise
    finally:
        cursor.close()

def main():
    """主函数"""
    print("="*60)
    print("MSDS数据导入（分表版本）")
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
        print(f"✓ 解析到 {len(data)} 个章节")
        
        # 导入数据库
        print("\n导入数据到各个表...")
        import_to_database(conn, data)
        
    finally:
        conn.close()

if __name__ == '__main__':
    main()

