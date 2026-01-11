#!/bin/bash
# IPv6 优选快速启动脚本

set -e

echo "🚀 开始 IPv6 优选..."
echo "================================"

# 创建输出目录
mkdir -p output

# 运行 Docker Compose
docker-compose up mcis-ipv6

echo ""
echo "✅ 优选完成！"
echo "================================"
echo "📄 结果文件: output/ipv6-results.txt"
echo ""
echo "查看结果："
echo "  cat output/ipv6-results.txt"
echo ""
