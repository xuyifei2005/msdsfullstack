#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
测试正则表达式匹配
"""

import re

# 模拟的文本
text = """第二部分：危险性概述
危险性类别： 第6.1类毒害品
侵入途径： 吸入 食入 经皮吸收
本品为低毒类杀菌剂。吸入、摄入或经皮肤吸收后会中毒。对眼睛、皮肤、粘膜和上呼吸
健康危害： 道有刺激作用。受热分解释出有毒的氮氧化物和氧化硫烟雾。
环境危害： 无资料
燃爆危险： 本品可燃、具有刺激性
第三部分：成分/组成信息"""

# 测试正则表达式
section_name = "危险性概述"
chinese_num = "二"
next_chinese_num = "三"

patterns = [
    rf'第{chinese_num}部分[:：]{re.escape(section_name)}\s*\n(.*?)(?=第{next_chinese_num}部分[:：]|$)',
    rf'第{chinese_num}部分[:：]{re.escape(section_name)}\n(.*?)(?=第{next_chinese_num}部分)',
    rf'第{chinese_num}部分[:：]{re.escape(section_name)}(.*?)(?=第{next_chinese_num}部分)',
]

print("测试文本:")
print("="*80)
print(text)
print()

for i, pattern in enumerate(patterns, 1):
    print(f"\n模式 {i}: {pattern}")
    print("-"*80)
    
    match = re.search(pattern, text, re.DOTALL | re.MULTILINE)
    if match:
        content = match.group(1)
        print(f"匹配成功！")
        print(f"内容长度: {len(content)} 字符")
        print(f"内容: {repr(content[:200])}")
    else:
        print("匹配失败！")


