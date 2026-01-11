#!/bin/bash
# 构建 Docker 镜像脚本

set -e

echo "🔨 构建 Docker 镜像..."
echo "================================"

docker-compose build --no-cache

echo ""
echo "✅ 构建完成！"
echo ""
echo "可用的服务："
echo "  - mcis-ipv4: IPv4 优选"
echo "  - mcis-ipv6: IPv6 优选"
echo "  - mcis-ipv4-download: IPv4 优选 + 下载测速"
echo "  - mcis-dns-cloudflare: 自动上传到 Cloudflare"
echo "  - mcis-dns-vercel: 自动上传到 Vercel"
echo "  - mcis-cron: 定时任务"
echo ""
echo "快速开始："
echo "  docker-compose up mcis-ipv4"
echo ""
