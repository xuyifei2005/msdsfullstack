#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
测试简单的正则表达式匹配
"""

import re

# 真实的文本片段
text = """第一部分：化学品及企业标识
中文名称： (1R,2R,4R)-冰片-2-硫氰基醋酸酯 中文别名： 敌稻瘟
1,7,7-trimethylbicyclo(2,2,1)h
英文名称： 英文别名： thanite
ept-2-yl thiocyanatoacetate
CAS号： 115-31-1 技术说明书编码： MSDS#2743
供应商名称： 供应商地址：
供应商电话： 供应商应急电话：
供应商传真： 供应商Email：
第二部分：危险性概述
危险性类别： 第6.1类毒害品
侵入途径： 吸入 食入 经皮吸收
本品为低毒类杀菌剂。吸入、摄入或经皮肤吸收后会中毒。对眼睛、皮肤、粘膜和上呼吸
健康危害： 道有刺激作用。受热分解释出有毒的氮氧化物和氧化硫烟雾。
环境危害： 无资料
燃爆危险： 本品可燃、具有刺激性
第三部分：成分/组成信息"""

# 测试提取第二部分
patterns = {
    "模式A (精确)": r'第二部分[:：]危险性概述(.*?)(?=第三部分)',
    "模式B (灵活)": r'第二部分[:：]危险性概述(.+?)第三部分',
    "模式C (通用)": r'第二部分：危险性概述\n(.*?)\n第三部分',
}

print("="*80)
print("测试正则表达式匹配 - 提取'第二部分：危险性概述'")
print("="*80)

for name, pattern in patterns.items():
    print(f"\n{name}:")
    print(f"  模式: {pattern}")
    
    match = re.search(pattern, text, re.DOTALL)
    if match:
        content = match.group(1)
        print(f"  状态: 匹配成功")
        print(f"  长度: {len(content)} 字符")
        print(f"  内容: {repr(content[:150])}")
    else:
        print(f"  状态: 匹配失败")


