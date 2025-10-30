#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
仪表盘API测试脚本
用于验证仪表盘返回的数据是否为真实数据而非假数据
"""

import requests
import json
import time

# API基础URL
BASE_URL = "http://localhost:18080"

def test_dashboard_overview():
    """测试仪表盘概览数据"""
    print("测试仪表盘概览数据...")
    
    try:
        # 测试概览API（不需要认证的测试）
        response = requests.get(f"{BASE_URL}/system/dashboard/overview", timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            print("仪表盘概览API响应成功")
            
            # 检查数据结构
            if 'data' in data:
                overview = data['data']
                print(f"文档统计: {overview.get('documentStats', {})}")
                print(f"访问统计: {overview.get('accessStats', {})}")
                print(f"下载统计: {overview.get('downloadStats', {})}")
                print(f"系统统计: {overview.get('systemStats', {})}")
                print(f"化学品统计: {overview.get('chemicalStats', {})}")
                
                # 验证数据是否为真实数据
                doc_stats = overview.get('documentStats', {})
                total_docs = doc_stats.get('total', 0)
                
                if total_docs == 5:  # 根据我们之前查询的结果，应该有5个MSDS文档
                    print("文档总数正确，显示真实数据")
                elif total_docs == 0:
                    print("文档总数为0，可能是数据库查询问题")
                else:
                    print(f"文档总数异常: {total_docs}，可能仍在使用假数据")
                    
            else:
                print("API响应格式不正确")
                
        elif response.status_code == 401:
            print("API需要认证，这是正常的")
        else:
            print(f"API响应失败: {response.status_code}")
            
    except requests.exceptions.RequestException as e:
        print(f"网络请求失败: {e}")
    except Exception as e:
        print(f"测试失败: {e}")

def test_database_connection():
    """测试数据库连接"""
    print("\n测试数据库连接...")
    
    try:
        # 通过Docker执行MySQL查询
        import subprocess
        
        # 查询MSDS文档数量
        cmd = [
            "docker-compose", "exec", "-T", "msdsmysql", 
            "mysql", "-u", "root", "-proot_password", 
            "-e", "USE msds_dev; SELECT COUNT(*) as total_msds FROM msds_main;"
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True, cwd=".")
        
        if result.returncode == 0:
            lines = result.stdout.strip().split('\n')
            if len(lines) > 1:
                count = lines[1].strip()
                print(f"数据库连接正常，MSDS文档数量: {count}")
                
                if count == "5":
                    print("数据库中的MSDS文档数量正确")
                else:
                    print(f"数据库中的MSDS文档数量: {count}")
            else:
                print("数据库查询结果格式异常")
        else:
            print(f"数据库查询失败: {result.stderr}")
            
    except Exception as e:
        print(f"数据库测试失败: {e}")

def main():
    """主函数"""
    print("开始测试仪表盘数据真实性...")
    print("=" * 50)
    
    # 测试数据库连接
    test_database_connection()
    
    # 等待服务启动
    print("\n等待后端服务启动...")
    time.sleep(5)
    
    # 测试仪表盘API
    test_dashboard_overview()
    
    print("\n" + "=" * 50)
    print("测试完成")
    
    print("\n优化总结:")
    print("1. 修改了数据库查询，使用真实的msds_main表")
    print("2. 移除了所有模拟数据生成方法")
    print("3. 更新了访问统计，使用sys_oper_log表")
    print("4. 更新了化学品统计，使用msds_main表")
    print("5. 前端组件已支持真实数据显示")

if __name__ == "__main__":
    main()
