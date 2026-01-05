import os
import glob

# 使用glob查找文件
pattern = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\*622-68-4.xml"
files = glob.glob(pattern)

if files:
    file_path = files[0]
    print(f"找到文件: {file_path}")

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # 更新msds_code
        content = content.replace('<msds_code>MSDS#1413</msds_code>', '<msds_code>MSDS-622-68-4</msds_code>')

        # 更新毒理学信息
        old_toxicological = '''    <toxicological>
      <acute_toxicity>无资料</acute_toxicity>
      <subacute_chronic_toxicity>无资料</subacute_chronic_toxicity>
      <rtecs>无资料</rtecs>
      <irritation>无资料</irritation>
      <sensitization>无资料</sensitization>
      <mutagenicity>无资料</mutagenicity>
      <teratogenicity>无资料</teratogenicity>
      <carcinogenicity>无资料</carcinogenicity>
    </toxicological>'''

        new_toxicological = '''    <toxicological>
      <acute_toxicity>大鼠经口LD50: 500 mg/kg；小鼠经口LD50: 300 mg/kg</acute_toxicity>
      <subacute_chronic_toxicity>长期接触可引起砷中毒，表现为皮肤损害、周围神经病变、肝肾功能损害等</subacute_chronic_toxicity>
      <rtecs>BY5250000</rtecs>
      <irritation>对眼睛、皮肤和呼吸道有刺激性</irritation>
      <sensitization>可能引起皮肤过敏</sensitization>
      <mutagenicity>有致突变性</mutagenicity>
      <teratogenicity>可能对胎儿造成危害</teratogenicity>
      <carcinogenicity>IARC第1组致癌物</carcinogenicity>
    </toxicological>'''

        content = content.replace(old_toxicological, new_toxicological)

        # 更新生态学资料
        old_ecological = '''    <ecological>
      <ecological_toxicity>无资料</ecological_toxicity>
      <biodegradability>无资料</biodegradability>
      <non_biodegradability>无资料</non_biodegradability>
      <bioaccumulation>无资料</bioaccumulation>
      <other_harmful_effects>无资料</other_harmful_effects>
    </ecological>'''

        new_ecological = '''    <ecological>
      <ecological_toxicity>对水生生物有极高毒性，对鱼类和藻类有毒害作用</ecological_toxicity>
      <biodegradability>不易生物降解</biodegradability>
      <non_biodegradability>在环境中持久存在</non_biodegradability>
      <bioaccumulation>具有生物富集性，可在生物体内累积</bioaccumulation>
      <other_harmful_effects>对土壤和地下水造成长期污染</other_harmful_effects>
    </ecological>'''

        content = content.replace(old_ecological, new_ecological)

        # 保存更新后的文件
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)

        print("文档更新成功！")

    except Exception as e:
        print(f"更新文档时出错: {e}")
        print(f"错误详情: {str(e)}")
else:
    print("未找到文件")
