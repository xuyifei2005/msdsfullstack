#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""检查数据库结构"""

import mysql.connector

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'msds_user',
    'password': 'msds_dev_password',
    'database': 'msds_dev',
    'charset': 'utf8mb4'
}

def main():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    # 查看所有msds相关的表
    print("="*60)
    print("MSDS相关表")
    print("="*60)
    cursor.execute("SHOW TABLES LIKE 'msds%'")
    tables = cursor.fetchall()
    for table in tables:
        print(f"\n表名: {table[0]}")
        cursor.execute(f"DESCRIBE {table[0]}")
        columns = cursor.fetchall()
        for col in columns:
            print(f"  - {col[0]}: {col[1]}")
    
    cursor.close()
    conn.close()

if __name__ == '__main__':
    main()

