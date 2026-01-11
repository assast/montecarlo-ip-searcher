#!/bin/bash
# 带下载测速的优选脚本

set -e

echo "🚀 开始 IPv4 优选（含下载测速）..."
echo "================================"
echo "⚠️  注意：下载测速会消耗较多时间和流量"
echo ""

# 创建输出目录
mkdir -p output

# 运行 Docker Compose
docker-compose --profile download up mcis-ipv4-download

echo ""
echo "✅ 优选完成！"
echo "================================"
echo "📄 结果文件: output/ipv4-download-results.txt"
echo ""
echo "查看结果："
echo "  cat output/ipv4-download-results.txt"
echo ""
