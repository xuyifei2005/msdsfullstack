import xml.etree.ElementTree as ET
import glob

def check_msds_quality(file_path):
    print("=" * 80)
    print(f"质量检查报告: {file_path}")
    print("=" * 80)
    
    issues = []
    warnings = []
    
    try:
        tree = ET.parse(file_path)
        root = tree.getroot()
        
        msds = root.find('msds')
        
        if msds is None:
            issues.append("严重错误: 未找到msds元素")
            return issues, warnings
        
        # 1. 检查标准部分（使用实际标签名称）
        required_sections = {
            'basic_info': '化学品及企业标识',
            'hazard_info': '危险性概述',
            'component_info': '成分/组成信息',
            'first_aid': '急救措施',
            'fire_fighting': '消防措施',
            'leak_response': '泄漏应急处理',
            'handling_storage': '操作处置与储存',
            'exposure_control': '接触控制/个体防护',
            'physical_chemical': '理化特性',
            'stability_reactivity': '稳定性和反应活性',
            'toxicological': '毒理学信息',
            'ecological': '生态学资料',
            'disposal': '废弃处置',
            'transportation': '运输信息',
            'regulatory': '法规信息'
        }
        
        missing_sections = []
        for tag, name in required_sections.items():
            if msds.find(tag) is None:
                missing_sections.append(f"{tag} ({name})")
        
        if missing_sections:
            issues.append(f"严重错误: 缺失标准部分: {', '.join(missing_sections)}")
        else:
            print(f"✓ 所有{len(required_sections)}个标准部分完整")
        
        # 2. 检查msds_code字段（最高优先级）
        basic_info = msds.find('basic_info')
        if basic_info is not None:
            msds_code = basic_info.find('msds_code')
            if msds_code is not None and msds_code.text:
                code = msds_code.text.strip()
                if not code.startswith('MSDS-'):
                    issues.append(f"严重错误: msds_code格式错误: {code}，应为MSDS-CAS号格式")
                else:
                    print(f"✓ msds_code格式正确: {code}")
            else:
                issues.append("严重错误: msds_code字段为空")
        
        # 3. 检查供应商信息标准化（最高优先级）
        supplier_fields = ['company_name', 'company_address', 'contact_phone', 
                         'emergency_phone', 'email', 'fax_number']
        supplier_issues = []
        for field in supplier_fields:
            field_elem = basic_info.find(field) if basic_info else None
            if field_elem is not None:
                if field_elem.text and field_elem.text.strip() != '无资料':
                    supplier_issues.append(f"{field}: '{field_elem.text}'")
        
        if supplier_issues:
            issues.append(f"严重错误: 供应商信息未标准化为'无资料': {', '.join(supplier_issues)}")
        else:
            print("✓ 供应商信息已标准化为'无资料'")
        
        # 4. 检查急救措施内容完整性（高优先级）
        first_aid = msds.find('first_aid')
        if first_aid is not None:
            first_aid_fields = ['eye_contact', 'skin_contact', 'inhalation', 'ingestion']
            first_aid_issues = []
            for field in first_aid_fields:
                field_elem = first_aid.find(field)
                if field_elem is not None:
                    text = field_elem.text or ''
                    text = text.strip()
                    if not text or text == '无资料':
                        first_aid_issues.append(field)
                    elif len(text) < 10:
                        warnings.append(f"警告: {field}内容过短: '{text[:50]}...'")
                    elif '。' not in text and '；' not in text:
                        warnings.append(f"警告: {field}内容可能不完整，缺少句号或分号")
            
            if first_aid_issues:
                issues.append(f"严重错误: 急救措施字段缺失或为'无资料': {', '.join(first_aid_issues)}")
            else:
                print("✓ 急救措施内容完整")
        
        # 5. 检查泄漏应急处理内容（高优先级）
        leak_response = msds.find('leak_response')
        if leak_response is not None:
            emergency_procedures = leak_response.find('emergency_procedures')
            if emergency_procedures is not None:
                text = emergency_procedures.text or ''
                text = text.strip()
                if not text or text == '无资料':
                    issues.append("严重错误: 泄漏应急处理emergency_procedures字段为空或为'无资料'")
                elif '应急处理：' in text and text.count('应急处理：') > 1:
                    warnings.append("警告: emergency_procedures字段可能包含重复的'应急处理：'文本")
                else:
                    print("✓ 泄漏应急处理内容完整")
        
        # 6. 检查操作处置与储存（高优先级）
        handling_storage = msds.find('handling_storage')
        if handling_storage is not None:
            handling_precautions = handling_storage.find('handling_precautions')
            if handling_precautions is not None:
                text = handling_precautions.text or ''
                text = text.strip()
                if not text or text == '无资料':
                    issues.append("严重错误: 操作处置handling_precautions字段为'无资料'")
                else:
                    print("✓ 操作处置内容完整")
        
        # 7. 检查来源信息注释移除（高优先级）
        source_annotations = []
        def check_for_source_annotations(element, path=""):
            if element.text:
                if '来源：' in element.text or '数据来源：' in element.text or \
                   '检索补充' in element.text or '参考数据' in element.text:
                    source_annotations.append(f"{path}: '{element.text[:100]}...'")
            for child in element:
                check_for_source_annotations(child, f"{path}/{child.tag}")
        
        check_for_source_annotations(msds)
        if source_annotations:
            issues.append(f"严重错误: 发现来源注释需要移除: {len(source_annotations)}处")
            for annotation in source_annotations[:3]:
                warnings.append(f"  - {annotation}")
        else:
            print("✓ 已移除所有来源信息注释")
        
        # 8. 检查格式和空格问题（中优先级）
        format_issues = []
        def check_format_issues(element, path=""):
            if element.text:
                text = element.text
                if text.startswith(' ') or text.endswith(' '):
                    format_issues.append(f"{path}: 包含首尾空格")
                if '  ' in text:
                    format_issues.append(f"{path}: 包含多余空格")
            for child in element:
                check_format_issues(child, f"{path}/{child.tag}")
        
        check_format_issues(msds)
        if format_issues:
            warnings.append(f"警告: 发现{len(format_issues)}处格式问题")
            for issue in format_issues[:3]:
                warnings.append(f"  - {issue}")
        else:
            print("✓ 格式和空格检查通过")
        
        # 9. 检查危险性概述信息完整性
        hazard_info = msds.find('hazard_info')
        if hazard_info is not None:
            hazard_fields = ['hazard_category', 'exposure_routes', 'health_hazards', 'fire_explosion_hazards']
            hazard_issues = []
            for field in hazard_fields:
                field_elem = hazard_info.find(field)
                if field_elem is not None:
                    text = field_elem.text or ''
                    text = text.strip()
                    if not text or text == '无资料':
                        hazard_issues.append(field)
            
            if hazard_issues:
                issues.append(f"严重错误: 危险性概述字段缺失或为'无资料': {', '.join(hazard_issues)}")
            else:
                print("✓ 危险性概述信息完整")
        
        # 10. 检查成分/组成信息
        component_info = msds.find('component_info')
        if component_info is not None:
            components = component_info.find('components')
            if components is not None:
                text = components.text or ''
                text = text.strip()
                if not text or text == '无资料':
                    warnings.append("警告: 成分/组成信息components字段为空或为'无资料'")
                else:
                    print("✓ 成分/组成信息完整")
        
        # 11. 检查理化特性数据（中优先级）
        physical_chemical = msds.find('physical_chemical')
        if physical_chemical is not None:
            key_fields = ['melting_point', 'boiling_point', 'flash_point', 'ignition_temperature']
            physical_issues = []
            for field in key_fields:
                field_elem = physical_chemical.find(field)
                if field_elem is not None:
                    text = field_elem.text or ''
                    text = text.strip()
                    if not text or text == '无资料':
                        physical_issues.append(field)
            
            if physical_issues:
                warnings.append(f"警告: 理化特性关键字段为'无资料': {', '.join(physical_issues)}")
            else:
                print("✓ 理化特性数据完整")
        
        # 12. 检查毒理学信息
        toxicological = msds.find('toxicological')
        if toxicological is not None:
            toxic_fields = ['acute_toxicity', 'irritation', 'carcinogenicity']
            toxic_issues = []
            for field in toxic_fields:
                field_elem = toxicological.find(field)
                if field_elem is not None:
                    text = field_elem.text or ''
                    text = text.strip()
                    if not text or text == '无资料':
                        toxic_issues.append(field)
            
            if toxic_issues:
                issues.append(f"严重错误: 毒理学关键字段缺失或为'无资料': {', '.join(toxic_issues)}")
            else:
                print("✓ 毒理学信息完整")
        
        # 13. 检查数据逻辑关系
        melting_point = physical_chemical.find('melting_point') if physical_chemical else None
        boiling_point = physical_chemical.find('boiling_point') if physical_chemical else None
        
        if melting_point is not None and boiling_point is not None:
            try:
                mp_text = melting_point.text or ''
                bp_text = boiling_point.text or ''
                
                if mp_text and bp_text and mp_text != '无资料' and bp_text != '无资料':
                    import re
                    mp_match = re.search(r'(\d+\.?\d*)', mp_text)
                    bp_match = re.search(r'(\d+\.?\d*)', bp_text)
                    
                    if mp_match and bp_match:
                        mp_value = float(mp_match.group(1))
                        bp_value = float(bp_match.group(1))
                        
                        if mp_value >= bp_value:
                            issues.append(f"严重错误: 熔点({mp_text})应低于沸点({bp_text})")
                        else:
                            print("✓ 数据逻辑关系正确（沸点 > 熔点）")
            except Exception as e:
                warnings.append(f"警告: 无法验证熔点和沸点的逻辑关系: {str(e)}")
        
        # 14. 检查CAS号格式
        cas_number = basic_info.find('cas_number') if basic_info else None
        if cas_number is not None and cas_number.text:
            cas = cas_number.text.strip()
            if cas != '无资料':
                parts = cas.split('-')
                if len(parts) != 3:
                    issues.append(f"严重错误: CAS号格式错误: {cas}")
                else:
                    print(f"✓ CAS号格式正确: {cas}")
        
    except Exception as e:
        issues.append(f"严重错误: 解析XML文件时发生异常: {str(e)}")
        import traceback
        traceback.print_exc()
    
    print("\n" + "=" * 80)
    print("检查结果汇总")
    print("=" * 80)
    print(f"严重错误: {len(issues)}")
    print(f"警告: {len(warnings)}")
    
    if issues:
        print("\n严重错误详情:")
        for i, issue in enumerate(issues, 1):
            print(f"  {i}. {issue}")
    
    if warnings:
        print("\n警告详情:")
        for i, warning in enumerate(warnings, 1):
            print(f"  {i}. {warning}")
    
    if not issues and not warnings:
        print("\n✓ 所有检查通过，文档质量良好！")
    elif not issues:
        print("\n✓ 无严重错误，但有警告需要关注")
    else:
        print("\n✗ 存在严重错误，需要修正")
    
    print("=" * 80)
    
    return issues, warnings

# 查找并检查文件
files = glob.glob(r'D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\*622-68-4*.xml')
print(f"找到文件: {files}")

if files:
    file_path = files[0]
    issues, warnings = check_msds_quality(file_path)
else:
    print("未找到匹配的XML文件")
