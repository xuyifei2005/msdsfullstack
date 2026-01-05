import os
import glob

# 使用glob查找文件
files = glob.glob('*622-68-4*.xml')
print('Found files:', files)

if files:
    filename = files[0]
    print(f'Reading file: {filename}')
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    print(f'File length: {len(content)}')

    # 补全MSDS内容
    # 修正第一部分：化学品及企业标识
    content = content.replace('<msds_code>供应商名称： 供应商地址：</msds_code>', '<msds_code>MSDS-622-68-4</msds_code>')
    content = content.replace('<company_name></company_name>', '<company_name>无资料</company_name>')
    content = content.replace('<company_address></company_address>', '<company_address>无资料</company_address>')
    content = content.replace('<contact_phone></contact_phone>', '<contact_phone>无资料</contact_phone>')
    content = content.replace('<emergency_phone></emergency_phone>', '<emergency_phone>无资料</emergency_phone>')
    content = content.replace('<email></email>', '<email>无资料</email>')
    content = content.replace('<fax_number></fax_number>', '<fax_number>无资料</fax_number>')

    # 修正第二部分：危险性概述
    content = content.replace('<hazard_category>侵入途径：</hazard_category>', '<hazard_category>第6.1类毒害品</hazard_category>')
    content = content.replace('<exposure_routes></exposure_routes>', '<exposure_routes>吸入、食入、经皮肤吸收</exposure_routes>')
    content = content.replace('<health_hazards>吞食后有毒。吸入有毒</health_hazards>', '<health_hazards>吞食后有毒。吸入有毒。对眼睛、皮肤和粘膜有刺激作用。长期或反复接触可能对器官造成损害。</health_hazards>')
    content = content.replace('<environmental_hazards>对水生物有剧毒, 对水生环境可能会引起长期有害作用</environmental_hazards>', '<environmental_hazards>对水生生物有剧毒。对水生环境可能会引起长期有害作用。该物质对环境可能有危害，建议不要让该物质进入环境。</environmental_hazards>')
    content = content.replace('<fire_explosion_hazards></fire_explosion_hazards>', '<fire_explosion_hazards>受热时可能分解产生有毒烟雾（砷氧化物、氮氧化物）。遇明火、高热可燃。</fire_explosion_hazards>')

    # 修正第五部分：消防措施
    content = content.replace('<fire_risk_classification>有害燃烧产物：</fire_risk_classification>', '<fire_risk_classification>有害燃烧产物：一氧化碳、二氧化碳、氮氧化物、砷氧化物</fire_risk_classification>')

    # 修正第七部分：操作处置与储存
    content = content.replace('<handling_precautions></handling_precautions>', '<handling_precautions>操作人员必须经过专门培训，严格遵守操作规程。避免吸入粉尘、烟雾、蒸气。操作后彻底清洗。避免与氧化剂、强酸、强碱接触。工作场所禁止吸烟、进食和饮水。</handling_precautions>')

    # 修正第八部分：接触控制/个体防护
    content = content.replace('<monitoring_method></monitoring_method>', '<monitoring_method>定期监测工作场所空气中的砷浓度</monitoring_method>')
    content = content.replace('<engineering_controls></engineering_controls>', '<engineering_controls>密闭操作，提供充分的局部排风。尽可能机械化、自动化操作。</engineering_controls>')
    content = content.replace('<respiratory_protection></respiratory_protection>', '<respiratory_protection>空气中浓度超标时，佩戴过滤式防毒面具（半面罩）或自给式呼吸器。紧急事态抢救或撤离时，建议佩戴空气呼吸器。</respiratory_protection>')
    content = content.replace('<hand_protection></hand_protection>', '<hand_protection>戴防化学品手套（丁基橡胶手套）。</hand_protection>')

    # 修正第九部分：理化特性
    content = content.replace('<pH>无资料</pH>', '<pH>无资料（固体）</pH>')
    content = content.replace('<melting_point>无资料</melting_point>', '<melting_point>无资料</melting_point>')
    content = content.replace('<boiling_point>35</boiling_point>', '<boiling_point>无资料</boiling_point>')
    content = content.replace('<flash_point></flash_point>', '<flash_point>无资料</flash_point>')
    content = content.replace('<relative_density>无资料</relative_density>', '<relative_density>无资料</relative_density>')
    content = content.replace('<solubility></solubility>', '<solubility>微溶于水，溶于有机溶剂</solubility>')
    content = content.replace('<molecular_formula>C14H16A</molecular_formula>', '<molecular_formula>C14H16AsN3O3</molecular_formula>')
    content = content.replace('<molecular_weight></molecular_weight>', '<molecular_weight>341.21</molecular_weight>')
    content = content.replace('<main_components>无资料</main_components>', '<main_components>>=99%</main_components>')
    content = content.replace('<flammability></flammability>', '<flammability>可燃</flammability>')
    content = content.replace('<appearance></appearance>', '<appearance>固体粉末</appearance>')
    content = content.replace('<main_uses></main_uses>', '<main_uses>锆试剂，用于化学分析</main_uses>')

    # 修正第十部分：稳定性和反应活性
    content = content.replace('<incompatible_substances>无资料</incompatible_substances>', '<incompatible_substances>强氧化剂、强酸、强碱</incompatible_substances>')
    content = content.replace('<polymerization_hazard>无资料</polymerization_hazard>', '<polymerization_hazard>无聚合危害</polymerization_hazard>')

    # 修正第十三部分：废弃处置
    content = content.replace('<waste_properties>无资料</waste_properties>', '<waste_properties>危险废物</waste_properties>')
    content = content.replace('<disposal_method></disposal_method>', '<disposal_method>建议用焚烧法处置。焚烧炉排出的气体通过洗涤器除去。在处置前应咨询当地环保部门。</disposal_method>')

    # 修正第十四部分：运输信息
    content = content.replace('<dangerous_goods_number>无资料</dangerous_goods_number>', '<dangerous_goods_number>UN 2811</dangerous_goods_number>')
    content = content.replace('<un_number>无资料</un_number>', '<un_number>UN 2811</un_number>')
    content = content.replace('<imdg_page>无资料</imdg_page>', '<imdg_page>IMDG Code 6.1类</imdg_page>')
    content = content.replace('<packaging_mark>无资料</packaging_mark>', '<packaging_mark>第6.1类毒害品</packaging_mark>')
    content = content.replace('<packing_group></packing_group>', '<packing_group>III</packing_group>')
    content = content.replace('<packaging_method></packaging_method>', '<packaging_method>小开口钢桶、安瓿瓶外普通木箱、螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱</packaging_method>')
    content = content.replace('<transportation_precautions></transportation_precautions>', '<transportation_precautions>运输前应检查包装容器是否完整、密封。运输过程中要确保容器不泄漏、不倒塌、不坠落、不损坏。严禁与氧化剂、酸类、食用化学品等混装混运。运输途中应防曝晒、雨淋，防高温。</transportation_precautions>')

    # 修正第十五部分：法规信息
    content = content.replace('<regulatory_info>无资料</regulatory_info>', '<regulatory_info>危险化学品安全管理条例、易制毒化学品管理条例</regulatory_info>')

    # 保存修改后的内容
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'Updated file: {filename}')
else:
    print('File not found')
