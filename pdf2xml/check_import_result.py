#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
检查MSDS数据导入结果
"""

import mysql.connector

DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'msds_user',
    'password': 'msds_dev_password',
    'database': 'msds_dev',
    'charset': 'utf8mb4'
}

def check_import_result():
    """检查导入结果"""
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    print("\n" + "=" * 80)
    print("MSDS数据导入结果检查")
    print("=" * 80)
    
    # 1. 主表数据
    cursor.execute("""
        SELECT id, product_name, cas_number, product_english_name, 
               company_name, msds_code, create_time
        FROM msds_main 
        WHERE cas_number = '115-29-7'
    """)
    
    row = cursor.fetchone()
    
    if row:
        print("\n✅ MSDS主表数据:")
        print(f"  ID: {row[0]}")
        print(f"  化学品名称: {row[1]}")
        print(f"  CAS号: {row[2]}")
        print(f"  英文名称: {row[3]}")
        print(f"  企业名称: {row[4]}")
        print(f"  MSDS编号: {row[5]}")
        print(f"  创建时间: {row[6]}")
        
        msds_id = row[0]
        
        # 2. 检查关联表
        print("\n✅ 关联表数据检查:")
        
        tables = [
            ('msds_hazard', '危险性概述'),
            ('msds_component', '成分信息'),
            ('msds_first_aid', '急救措施'),
            ('msds_fire_fighting', '消防措施'),
            ('msds_leak_response', '泄漏应急'),
            ('msds_handling_storage', '操作储存'),
            ('msds_exposure_control', '接触控制'),
            ('msds_physical_chemical', '理化特性'),
            ('msds_stability_reactivity', '稳定性'),
            ('msds_toxicological', '毒理学信息'),
            ('msds_ecological', '生态学信息'),
            ('msds_disposal', '废弃处置'),
            ('msds_transportation', '运输信息'),
            ('msds_regulatory', '法规信息')
        ]
        
        for table, name in tables:
            cursor.execute(f"SELECT COUNT(*) FROM {table} WHERE msds_id = %s", (msds_id,))
            count = cursor.fetchone()[0]
            status = "✓ 有数据" if count > 0 else "✗ 无数据"
            print(f"  {name:15} ({table:30}): {status}")
        
        # 3. 查看理化特性详细数据
        print("\n✅ 理化特性详细数据:")
        cursor.execute("""
            SELECT appearance, melting_point, boiling_point, 
                   relative_density, molecular_formula, molecular_weight,
                   flash_point, solubility
            FROM msds_physical_chemical
            WHERE msds_id = %s
        """, (msds_id,))
        
        phys_row = cursor.fetchone()
        if phys_row:
            print(f"  外观与性状: {phys_row[0] or '无'}")
            print(f"  熔点: {phys_row[1] or '无'}")
            print(f"  沸点: {phys_row[2] or '无'}")
            print(f"  相对密度: {phys_row[3] or '无'}")
            print(f"  分子式: {phys_row[4] or '无'}")
            print(f"  分子量: {phys_row[5] or '无'}")
            print(f"  闪点: {phys_row[6] or '无'}")
            print(f"  溶解性: {phys_row[7] or '无'}")
        
        # 4. 查看危险性概述
        print("\n✅ 危险性概述:")
        cursor.execute("""
            SELECT hazard_category, exposure_routes, 
                   health_hazards, fire_explosion_hazards
            FROM msds_hazard
            WHERE msds_id = %s
        """, (msds_id,))
        
        hazard_row = cursor.fetchone()
        if hazard_row:
            print(f"  危险性类别: {hazard_row[0] or '无'}")
            print(f"  侵入途径: {hazard_row[1] or '无'}")
            print(f"  健康危害: {(hazard_row[2] or '')[:100]}...")
            print(f"  燃爆危险: {hazard_row[3] or '无'}")
        
        # 5. 统计总数据量
        print("\n✅ 数据库统计:")
        cursor.execute("SELECT COUNT(*) FROM msds_main")
        total_main = cursor.fetchone()[0]
        print(f"  主表总记录数: {total_main}")
        
        cursor.execute("""
            SELECT SUM(cnt) FROM (
                SELECT COUNT(*) as cnt FROM msds_hazard
                UNION ALL SELECT COUNT(*) FROM msds_component
                UNION ALL SELECT COUNT(*) FROM msds_first_aid
                UNION ALL SELECT COUNT(*) FROM msds_fire_fighting
                UNION ALL SELECT COUNT(*) FROM msds_physical_chemical
            ) as counts
        """)
        total_related = cursor.fetchone()[0]
        print(f"  关联表总记录数: {total_related or 0}")
        
    else:
        print("\n✗ 未找到CAS号为 115-29-7 的记录")
    
    cursor.close()
    conn.close()
    
    print("\n" + "=" * 80)

if __name__ == '__main__':
    check_import_result()

