#!/bin/bash
# MSDS PDF批量转XML工具 (Linux/Mac)

set -e

echo "==============================================="
echo "MSDS PDF批量转XML工具 (Linux/Mac)"
echo "==============================================="
echo

# 默认参数
INPUT_DIR="../aboutproject/doc"
OUTPUT_DIR="./output"
WORKERS=4

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -i)
            INPUT_DIR="$2"
            shift 2
            ;;
        -o)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -w)
            WORKERS="$2"
            shift 2
            ;;
        -h|--help)
            echo "用法: ./batch_convert.sh [选项]"
            echo
            echo "选项:"
            echo "  -i DIR    输入PDF目录 (默认: ../aboutproject/doc)"
            echo "  -o DIR    输出XML目录 (默认: ./output)"
            echo "  -w NUM    并行线程数 (默认: 4)"
            echo "  -h        显示帮助信息"
            echo
            echo "示例:"
            echo "  ./batch_convert.sh"
            echo "  ./batch_convert.sh -i /path/to/pdfs -o /path/to/xmls -w 8"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            echo "使用 -h 查看帮助"
            exit 1
            ;;
    esac
done

# 检查Python
if ! command -v python3 &> /dev/null; then
    echo "[错误] 未找到Python3，请先安装Python 3.8+"
    exit 1
fi

echo "配置信息:"
echo "  输入目录: $INPUT_DIR"
echo "  输出目录: $OUTPUT_DIR"
echo "  线程数: $WORKERS"
echo

# 检查输入目录
if [ ! -d "$INPUT_DIR" ]; then
    echo "[错误] 输入目录不存在: $INPUT_DIR"
    exit 1
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR" logs

echo "开始批量转换..."
echo

python3 batch_convert.py -i "$INPUT_DIR" -o "$OUTPUT_DIR" -w $WORKERS

echo
echo "==============================================="
echo "批量转换完成"
echo "==============================================="
echo
echo "输出目录: $OUTPUT_DIR"
echo "转换报告: $OUTPUT_DIR/conversion_report.json"
echo "日志文件: ./logs/pdf_to_xml.log"
echo


