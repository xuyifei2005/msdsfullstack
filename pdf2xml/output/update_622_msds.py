import xml.etree.ElementTree as ET
import glob

files = glob.glob(r'D:\\XUYIFEI\\XUPROJECTS\\msdsfullstack\\pdf2xml\\output\\*622-68-4*.xml')
print(f"Found files: {files}")

if files:
    file_path = files[0]
    print(f"Processing file: {file_path}")
    
    tree = ET.parse(file_path)
    root = tree.getroot()
    
    msds = root.find('msds')
    
    if msds:
        product_identification = msds.find('product_identification')
        if product_identification is not None:
            msds_code = product_identification.find('msds_code')
            if msds_code is not None:
                msds_code.text = 'MSDS-622-68-4'
            
            company_name = product_identification.find('company_name')
            if company_name is not None:
                company_name.text = '无资料'
            
            company_address = product_identification.find('company_address')
            if company_address is not None:
                company_address.text = '无资料'
            
            contact_phone = product_identification.find('contact_phone')
            if contact_phone is not None:
                contact_phone.text = '无资料'
            
            emergency_phone = product_identification.find('emergency_phone')
            if emergency_phone is not None:
                emergency_phone.text = '无资料'
            
            email = product_identification.find('email')
            if email is not None:
                email.text = '无资料'
            
            fax_number = product_identification.find('fax_number')
            if fax_number is not None:
                fax_number.text = '无资料'
        
        hazard_overview = msds.find('hazard_overview')
        if hazard_overview is not None:
            hazard_category = hazard_overview.find('hazard_category')
            if hazard_category is not None and (hazard_category.text is None or hazard_category.text.strip() == ''):
                hazard_category.text = '第6.1类毒害品'
            
            exposure_routes = hazard_overview.find('exposure_routes')
            if exposure_routes is not None and (exposure_routes.text is None or exposure_routes.text.strip() == ''):
                exposure_routes.text = '吸入、食入、皮肤接触、眼睛接触'
            
            health_hazards = hazard_overview.find('health_hazards')
            if health_hazards is not None and (health_hazards.text is None or health_hazards.text.strip() == ''):
                health_hazards.text = '吸入有毒。对眼睛、皮肤、粘膜和上呼吸道有刺激作用。长期接触可引起砷中毒，表现为皮肤病变、周围神经病变、肝肾功能损害等。'
            
            fire_explosion_hazards = hazard_overview.find('fire_explosion_hazards')
            if fire_explosion_hazards is not None and (fire_explosion_hazards.text is None or fire_explosion_hazards.text.strip() == ''):
                fire_explosion_hazards.text = '遇明火、高热可燃。受热分解产生有毒的砷氧化物和氮氧化物气体。'
        
        first_aid = msds.find('first_aid')
        if first_aid is not None:
            eye_contact = first_aid.find('eye_contact')
            if eye_contact is not None and (eye_contact.text is None or eye_contact.text.strip() == ''):
                eye_contact.text = '立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。'
            
            skin_contact = first_aid.find('skin_contact')
            if skin_contact is not None and (skin_contact.text is None or skin_contact.text.strip() == ''):
                skin_contact.text = '立即脱去污染的衣着，用大量肥皂水和清水彻底冲洗皮肤。就医。'
            
            inhalation = first_aid.find('inhalation')
            if inhalation is not None and (inhalation.text is None or inhalation.text.strip() == ''):
                inhalation.text = '迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。'
            
            ingestion = first_aid.find('ingestion')
            if ingestion is not None and (ingestion.text is None or ingestion.text.strip() == ''):
                ingestion.text = '立即漱口，禁止催吐。给饮牛奶或蛋清。就医。'
        
        fire_fighting = msds.find('fire_fighting')
        if fire_fighting is not None:
            fire_risk_classification = fire_fighting.find('fire_risk_classification')
            if fire_risk_classification is not None and (fire_risk_classification.text is None or fire_risk_classification.text.strip() == ''):
                fire_risk_classification.text = '第6.1类毒害品'
            
            harmful_combustion_products = fire_fighting.find('harmful_combustion_products')
            if harmful_combustion_products is not None and (harmful_combustion_products.text is None or harmful_combustion_products.text.strip() == ''):
                harmful_combustion_products.text = '砷氧化物、氮氧化物、一氧化碳、二氧化碳'
            
            suitable_extinguishing_media = fire_fighting.find('suitable_extinguishing_media')
            if suitable_extinguishing_media is not None:
                if '合适的灭火介质' in suitable_extinguishing_media.text or '不合适的灭火介质' in suitable_extinguishing_media.text:
                    suitable_extinguishing_media.text = '合适的灭火介质: 干粉、二氧化碳或耐醇泡沫。不合适的灭火介质: 避免用太强烈的水汽灭火，因为它可能会使火苗蔓延分散。灭火时，应佩戴呼吸面具（符合MSHA/NIOSH要求的或相当的）并穿上全身防护服。在安全距离处、有充足防护的情况下灭火。防止消防水污染地表和地下水系统。'
        
        leak_response = msds.find('leak_response')
        if leak_response is not None:
            emergency_procedures = leak_response.find('emergency_procedures')
            if emergency_procedures is not None:
                if emergency_procedures.text is not None and '使用个人' in emergency_procedures.text:
                    emergency_procedures.text = '无火灾状况下的溢漏和泄漏应穿着蒸气防护服，且完全密封。不要触摸或穿越泄漏物。不要触摸破损的容器或泄漏物质除非穿着合适的防护服。保证充分的通风。清除所有点火源。采取防静电措施。迅速将人员撤离到安全区域，远离泄漏区域并处于上风方向。使用个人防护装备。避免吸入粉尘、烟雾。'
        
        handling_storage = msds.find('handling_storage')
        if handling_storage is not None:
            handling_precautions = handling_storage.find('handling_precautions')
            if handling_precautions is not None and (handling_precautions.text is None or handling_precautions.text.strip() == ''):
                handling_precautions.text = '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防尘口罩，戴化学安全防护眼镜，穿防毒物渗透工作服，戴橡胶手套。避免产生粉尘。避免与氧化剂、酸类、碱类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。'
        
        toxicological = msds.find('toxicological')
        if toxicological is not None:
            acute_toxicity = toxicological.find('acute_toxicity')
            if acute_toxicity is not None and (acute_toxicity.text is None or acute_toxicity.text.strip() == ''):
                acute_toxicity.text = '无资料（砷化合物通常具有急性毒性，大鼠经口LD50约为100-500mg/kg）'
            
            irritation = toxicological.find('irritation')
            if irritation is not None and (irritation.text is None or irritation.text.strip() == ''):
                irritation.text = '对眼睛、皮肤和呼吸道有刺激性'
            
            mutagenicity = toxicological.find('mutagenicity')
            if mutagenicity is not None and (mutagenicity.text is None or mutagenicity.text.strip() == ''):
                mutagenicity.text = '砷化合物具有致突变性'
            
            carcinogenicity = toxicological.find('carcinogenicity')
            if carcinogenicity is not None and (carcinogenicity.text is None or carcinogenicity.text.strip() == ''):
                carcinogenicity.text = '砷化合物被IARC列为1类致癌物（对人类致癌）'
            
            teratogenicity = toxicological.find('teratogenicity')
            if teratogenicity is not None and (teratogenicity.text is None or teratogenicity.text.strip() == ''):
                teratogenicity.text = '砷化合物具有生殖毒性和致畸性'
        
        ecological = msds.find('ecological')
        if ecological is not None:
            ecological_toxicity = ecological.find('ecological_toxicity')
            if ecological_toxicity is not None and (ecological_toxicity.text is None or ecological_toxicity.text.strip() == ''):
                ecological_toxicity.text = '对水生生物有极高毒性'
            
            bioaccumulation = ecological.find('bioaccumulation')
            if bioaccumulation is not None and (bioaccumulation.text is None or bioaccumulation.text.strip() == ''):
                bioaccumulation.text = '砷化合物在生物体内有生物富集作用'
    
    tree.write(file_path, encoding='utf-8', xml_declaration=True)
    print(f"File updated successfully: {file_path}")
else:
    print("No matching XML file found")
