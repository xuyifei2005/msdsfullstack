import re
from pathlib import Path

# 定义Mapper文件和对应的数据库表
mappers = {
    "MsdsFirstAidMapper.xml": "msds_first_aid",
    "MsdsFireFightingMapper.xml": "msds_fire_fighting",
    "MsdsLeakResponseMapper.xml": "msds_leak_response",
    "MsdsHandlingStorageMapper.xml": "msds_handling_storage",
    "MsdsExposureControlMapper.xml": "msds_exposure_control",
    "MsdsPhysicalChemicalMapper.xml": "msds_physical_chemical",
    "MsdsStabilityReactivityMapper.xml": "msds_stability_reactivity",
    "MsdsToxicologicalMapper.xml": "msds_toxicological",
    "MsdsEcologicalMapper.xml": "msds_ecological",
    "MsdsDisposalMapper.xml": "msds_disposal",
    "MsdsTransportationMapper.xml": "msds_transportation",
    "MsdsRegulatoryMapper.xml": "msds_regulatory",
}

mapper_base_path = Path("../msdsPC/ruoyi-MsdsPc-react/ruoyi-system/src/main/resources/mapper/system")

print("=" * 80)
print("检查所有MSDS Mapper文件的insert语句")
print("=" * 80)

for mapper_file, table_name in mappers.items():
    mapper_path = mapper_base_path / mapper_file
    
    if not mapper_path.exists():
        print(f"\n❌ {mapper_file}: 文件不存在")
        continue
    
    print(f"\n📄 检查: {mapper_file}")
    print(f"   表名: {table_name}")
    
    try:
        with open(mapper_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 查找insert语句
        insert_match = re.search(r'<insert[^>]*id="insertMsds\w+"[^>]*>(.*?)</insert>', content, re.DOTALL)
        
        if not insert_match:
            print("   ⚠️  未找到insert语句")
            continue
        
        insert_content = insert_match.group(1)
        
        # 提取字段列表（从<if test=...>中）
        field_pattern = r'<if test="(\w+) != null[^>]*>(\w+)[,<]'
        fields = re.findall(field_pattern, insert_content)
        
        if not fields:
            print("   ⚠️  未找到字段定义")
            continue
        
        print(f"   ✅ 找到 {len(fields)} 个字段")
        
        # 检查字段映射是否正确（property名 -> column名）
        mismatches = []
        for prop_name, col_name in fields:
            # 将驼峰命名转换为下划线命名
            expected_col_name = re.sub(r'(?<!^)(?=[A-Z])', '_', prop_name).lower()
            
            if col_name != expected_col_name:
                mismatches.append((prop_name, col_name, expected_col_name))
        
        if mismatches:
            print(f"   ❌ 发现 {len(mismatches)} 个字段映射错误:")
            for prop, actual, expected in mismatches[:5]:  # 只显示前5个
                print(f"      - {prop}: {actual} (应为: {expected})")
            if len(mismatches) > 5:
                print(f"      ... 还有 {len(mismatches) - 5} 个错误")
        else:
            print("   ✅ 所有字段映射正确")
    
    except Exception as e:
        print(f"   ❌ 错误: {e}")

print("\n" + "=" * 80)
print("检查完成")
print("=" * 80)

