# Docker Compose 快速开始

5 分钟快速上手 Docker 版本的 mcis。

## 前置要求

- Docker
- Docker Compose

## 三步开始

### 1️⃣ 构建镜像

```bash
./scripts/build.sh
```

或手动执行：

```bash
docker-compose build
```

### 2️⃣ 创建输出目录

```bash
mkdir -p output
```

### 3️⃣ 运行优选

#### 方式 A：使用脚本（推荐）

```bash
# IPv4 优选
./scripts/run-ipv4.sh

# IPv6 优选
./scripts/run-ipv6.sh

# 带下载测速
./scripts/run-with-download.sh
```

#### 方式 B：使用 Docker Compose

```bash
# IPv4 优选
docker-compose up mcis-ipv4

# IPv6 优选
docker-compose up mcis-ipv6

# 同时运行
docker-compose up mcis-ipv4 mcis-ipv6
```

#### 方式 C：使用简化配置

```bash
docker-compose -f docker-compose.simple.yml up
```

## 查看结果

```bash
# IPv4 结果
cat output/ipv4-results.txt

# IPv6 结果
cat output/ipv6-results.txt
```

## 常用命令

### 后台运行

```bash
docker-compose up -d mcis-ipv4
```

### 查看日志

```bash
docker-compose logs -f mcis-ipv4
```

### 停止服务

```bash
docker-compose down
```

### 自定义参数

```bash
docker-compose run --rm mcis-ipv4 \
  -v \
  --cidr 1.1.1.0/24 \
  --budget 500 \
  --top 10 \
  --out text
```

## 高级功能

### 自动上传到 DNS

1. 配置 DNS 凭证：

```bash
./scripts/setup-dns.sh
```

2. 运行 DNS 上传服务：

```bash
# Cloudflare
docker-compose --profile dns up mcis-dns-cloudflare

# Vercel
docker-compose --profile dns up mcis-dns-vercel
```

### 定时任务

启动定时任务（每天凌晨 2 点自动运行）：

```bash
docker-compose --profile cron up -d mcis-cron
```

查看定时任务日志：

```bash
docker-compose --profile cron logs -f mcis-cron
```

停止定时任务：

```bash
docker-compose --profile cron down
```

## 故障排查

### 问题：容器无法访问网络

**解决方案**：
- 检查宿主机网络连接
- 增加超时时间：修改 `docker-compose.yml` 中的 `--timeout 5s`

### 问题：权限错误

**解决方案**：
```bash
chmod 777 output
```

### 问题：构建失败

**解决方案**：
```bash
# 清理缓存重新构建
docker-compose build --no-cache
```

## 下一步

- 查看 [完整文档](DOCKER_USAGE.md) 了解更多配置选项
- 查看 [项目 README](readme.md) 了解参数详解
- 修改 `docker-compose.yml` 自定义配置

## 示例输出

```
🚀 开始 IPv4 优选...
================================
[+] Running 1/0
 ✔ Container mcis-ipv4  Created
Attaching to mcis-ipv4
mcis-ipv4  | 2025/01/11 10:30:00 Starting IP optimization...
mcis-ipv4  | 2025/01/11 10:30:05 Progress: 100/2000 (5%)
mcis-ipv4  | 2025/01/11 10:30:10 Progress: 500/2000 (25%)
mcis-ipv4  | 2025/01/11 10:30:15 Progress: 1000/2000 (50%)
mcis-ipv4  | 2025/01/11 10:30:20 Progress: 1500/2000 (75%)
mcis-ipv4  | 2025/01/11 10:30:25 Progress: 2000/2000 (100%)
mcis-ipv4  | 2025/01/11 10:30:25 Optimization complete!

✅ 优选完成！
================================
📄 结果文件: output/ipv4-results.txt
```

## 需要帮助？

- [GitHub Issues](https://github.com/Leo-Mu/montecarlo-ip-searcher/issues)
- [完整文档](DOCKER_USAGE.md)
