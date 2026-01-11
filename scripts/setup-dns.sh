#!/bin/bash
# DNS 配置向导脚本

set -e

echo "🔧 DNS 自动上传配置向导"
echo "================================"
echo ""

# 检查 .env 文件
if [ ! -f .env ]; then
    echo "📝 创建 .env 文件..."
    cp .env.example .env
    echo "✅ 已创建 .env 文件"
    echo ""
fi

echo "请选择 DNS 服务商："
echo "  1) Cloudflare"
echo "  2) Vercel"
echo ""
read -p "请输入选项 (1 或 2): " choice

case $choice in
    1)
        echo ""
        echo "📋 Cloudflare 配置"
        echo "================================"
        echo ""
        read -p "请输入 Cloudflare API Token: " cf_token
        read -p "请输入 Cloudflare Zone ID: " cf_zone
        read -p "请输入子域名前缀 (例如 cf): " subdomain
        
        # 更新 .env 文件
        sed -i.bak "s/CF_API_TOKEN=.*/CF_API_TOKEN=$cf_token/" .env
        sed -i.bak "s/CF_ZONE_ID=.*/CF_ZONE_ID=$cf_zone/" .env
        rm -f .env.bak
        
        echo ""
        echo "✅ 配置完成！"
        echo ""
        echo "运行命令："
        echo "  docker-compose --profile dns up mcis-dns-cloudflare"
        echo ""
        echo "或使用脚本："
        echo "  ./scripts/run-dns-cloudflare.sh"
        ;;
    2)
        echo ""
        echo "📋 Vercel 配置"
        echo "================================"
        echo ""
        read -p "请输入 Vercel Token: " vercel_token
        read -p "请输入域名 (例如 example.com): " domain
        read -p "请输入子域名前缀 (例如 cf): " subdomain
        read -p "请输入 Team ID (可选，直接回车跳过): " team_id
        
        # 更新 .env 文件
        sed -i.bak "s/VERCEL_TOKEN=.*/VERCEL_TOKEN=$vercel_token/" .env
        if [ ! -z "$team_id" ]; then
            sed -i.bak "s/VERCEL_TEAM_ID=.*/VERCEL_TEAM_ID=$team_id/" .env
        fi
        rm -f .env.bak
        
        # 更新 docker-compose.yml 中的域名
        echo ""
        echo "⚠️  请手动编辑 docker-compose.yml，将 mcis-dns-vercel 服务中的"
        echo "   --dns-zone example.com 改为 --dns-zone $domain"
        echo ""
        echo "✅ 配置完成！"
        echo ""
        echo "运行命令："
        echo "  docker-compose --profile dns up mcis-dns-vercel"
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac
