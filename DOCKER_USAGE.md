# Docker Compose 使用教程

本文档介绍如何使用 Docker Compose 运行 Monte Carlo IP Searcher (mcis)。

## 目录

- [快速开始](#快速开始)
- [服务说明](#服务说明)
- [使用场景](#使用场景)
- [配置说明](#配置说明)
- [常见问题](#常见问题)

## 快速开始

### 1. 准备工作

确保已安装 Docker 和 Docker Compose：

```bash
# 检查 Docker 版本
docker --version

# 检查 Docker Compose 版本
docker-compose --version
```

### 2. 构建镜像

在项目根目录执行：

```bash
docker-compose build
```

### 3. 创建输出目录

```bash
mkdir -p output
```

### 4. 运行基础服务

#### IPv4 优选

```bash
docker-compose up mcis-ipv4
```

#### IPv6 优选

```bash
docker-compose up mcis-ipv6
```

#### 同时运行 IPv4 和 IPv6

```bash
docker-compose up mcis-ipv4 mcis-ipv6
```

### 5. 查看结果

结果文件会保存在 `./output` 目录：

```bash
# 查看 IPv4 结果
cat output/ipv4-results.txt

# 查看 IPv6 结果
cat output/ipv6-results.txt
```

## 服务说明

### 基础服务

#### mcis-ipv4
- **功能**：IPv4 地址优选
- **输出**：`output/ipv4-results.txt`
- **启动**：`docker-compose up mcis-ipv4`

#### mcis-ipv6
- **功能**：IPv6 地址优选
- **输出**：`output/ipv6-results.txt`
- **启动**：`docker-compose up mcis-ipv6`

### 高级服务（需要指定 profile）

#### mcis-ipv4-download
- **功能**：IPv4 优选 + 下载速度测试
- **输出**：`output/ipv4-download-results.txt`
- **启动**：`docker-compose --profile download up mcis-ipv4-download`

#### mcis-dns-cloudflare
- **功能**：IPv4 优选 + 自动上传到 Cloudflare DNS
- **输出**：`output/ipv4-cf-results.txt`
- **启动**：`docker-compose --profile dns up mcis-dns-cloudflare`
- **前置条件**：需要配置 `.env` 文件

#### mcis-dns-vercel
- **功能**：IPv4 优选 + 自动上传到 Vercel DNS
- **输出**：`output/ipv4-vercel-results.txt`
- **启动**：`docker-compose --profile dns up mcis-dns-vercel`
- **前置条件**：需要配置 `.env` 文件

#### mcis-cron
- **功能**：定时任务（每天凌晨 2 点自动运行）
- **输出**：`output/ipv4-cron-results.txt`
- **启动**：`docker-compose --profile cron up -d mcis-cron`
- **停止**：`docker-compose --profile cron down`

## 使用场景

### 场景 1：一次性优选

适合手动运行，获取当前最优 IP：

```bash
# IPv4 优选
docker-compose up mcis-ipv4

# 查看结果
cat output/ipv4-results.txt
```

### 场景 2：带下载测速的优选

需要更准确的速度评估：

```bash
docker-compose --profile download up mcis-ipv4-download
```

### 场景 3：自动更新 DNS 记录

#### 使用 Cloudflare

1. 复制环境变量模板：
```bash
cp .env.example .env
```

2. 编辑 `.env` 文件，填入你的 Cloudflare 凭证：
```bash
CF_API_TOKEN=your_cloudflare_api_token
CF_ZONE_ID=your_zone_id
```

3. 运行服务：
```bash
docker-compose --profile dns up mcis-dns-cloudflare
```

#### 使用 Vercel

1. 编辑 `.env` 文件：
```bash
VERCEL_TOKEN=your_vercel_token
VERCEL_TEAM_ID=your_team_id  # 可选
```

2. 修改 `docker-compose.yml` 中的 `--dns-zone` 参数为你的域名

3. 运行服务：
```bash
docker-compose --profile dns up mcis-dns-vercel
```

### 场景 4：定时自动优选

适合需要定期更新最优 IP 的场景：

```bash
# 启动定时任务（后台运行）
docker-compose --profile cron up -d mcis-cron

# 查看日志
docker-compose --profile cron logs -f mcis-cron

# 停止定时任务
docker-compose --profile cron down
```

默认每天凌晨 2 点运行。修改时间请编辑 `docker-compose.yml` 中的 cron 表达式。

### 场景 5：自定义参数运行

使用 `docker-compose run` 传入自定义参数：

```bash
# 自定义 CIDR
docker-compose run --rm mcis-ipv4 \
  -v \
  --cidr 1.1.1.0/24 \
  --budget 500 \
  --top 10 \
  --out text

# 自定义域名和路径
docker-compose run --rm mcis-ipv4 \
  -v \
  --cidr-file /app/ipv4cidr.txt \
  --host your-domain.com \
  --path /custom-path \
  --out-file /app/output/custom-results.txt
```

## 配置说明

### 修改默认参数

编辑 `docker-compose.yml` 中对应服务的 `command` 部分：

```yaml
command: >
  -v                                    # 显示详细进度
  --out text                            # 输出格式：text/jsonl/csv
  --cidr-file /app/ipv4cidr.txt        # CIDR 文件路径
  --budget 2000                         # 探测次数
  --top 20                              # 输出前 N 个 IP
  --concurrency 200                     # 并发数
  --timeout 3s                          # 超时时间
  --host example.com                    # 目标域名
  --out-file /app/output/results.txt   # 输出文件
```

### 常用参数说明

| 参数 | 说明 | 默认值 | 示例 |
|------|------|--------|------|
| `--budget` | 总探测次数 | 2000 | `--budget 5000` |
| `--top` | 输出前 N 个 IP | 20 | `--top 50` |
| `--concurrency` | 并发探测数 | 200 | `--concurrency 300` |
| `--timeout` | 单次探测超时 | 3s | `--timeout 5s` |
| `--host` | 目标域名 | example.com | `--host your-domain.com` |
| `--download-top` | 下载测速的 IP 数量 | 5 | `--download-top 10` |
| `--download-bytes` | 下载测试大小（字节） | 50000000 | `--download-bytes 100000000` |

### 使用自定义 CIDR 文件

1. 创建自定义 CIDR 文件：
```bash
cat > custom-cidrs.txt << EOF
# 自定义 CIDR 列表
1.1.0.0/16
1.0.0.0/16
8.8.8.0/24
EOF
```

2. 修改 `docker-compose.yml` 的 volumes 部分：
```yaml
volumes:
  - ./output:/app/output
  - ./custom-cidrs.txt:/app/custom-cidrs.txt:ro
```

3. 修改 command 中的 `--cidr-file` 参数：
```yaml
command: >
  -v
  --out text
  --cidr-file /app/custom-cidrs.txt
  --out-file /app/output/results.txt
```

### 修改输出格式

支持三种输出格式：

#### 1. text（纯文本，易读）
```yaml
command: >
  -v
  --out text
  --out-file /app/output/results.txt
```

#### 2. jsonl（JSON Lines，便于程序处理）
```yaml
command: >
  -v
  --out jsonl
  --out-file /app/output/results.jsonl
```

#### 3. csv（CSV 格式，便于导入表格）
```yaml
command: >
  -v
  --out csv
  --out-file /app/output/results.csv
```

## 常见问题

### Q1: 为什么使用 `network_mode: host`？

A: mcis 需要直连目标 IP 进行测速，使用 host 网络模式可以：
- 避免 Docker 网络层的额外延迟
- 确保测速结果准确
- 支持 IPv6（Docker 默认网络不支持 IPv6）

### Q2: 如何查看运行日志？

```bash
# 实时查看日志
docker-compose logs -f mcis-ipv4

# 查看最近 100 行日志
docker-compose logs --tail=100 mcis-ipv4
```

### Q3: 如何停止正在运行的服务？

```bash
# 停止特定服务
docker-compose stop mcis-ipv4

# 停止所有服务
docker-compose down

# 停止并删除容器
docker-compose down --remove-orphans
```

### Q4: 容器内无法访问网络怎么办？

检查以下几点：
1. 确认宿主机网络正常
2. 检查防火墙设置
3. 尝试使用 `--timeout` 增加超时时间
4. 检查是否有代理设置干扰

### Q5: 如何在后台运行服务？

```bash
# 后台运行
docker-compose up -d mcis-ipv4

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f mcis-ipv4
```

### Q6: 如何更新镜像？

```bash
# 重新构建镜像
docker-compose build --no-cache

# 重启服务
docker-compose up mcis-ipv4
```

### Q7: 输出文件权限问题

如果遇到权限问题，可以：

```bash
# 修改输出目录权限
chmod 777 output

# 或者修改 Dockerfile，去掉 USER mcis 行（不推荐）
```

### Q8: 如何同时运行多个不同配置的任务？

使用 `docker-compose run` 创建临时容器：

```bash
# 任务 1：测试特定 CIDR
docker-compose run --rm --name task1 mcis-ipv4 \
  -v --cidr 1.1.1.0/24 --out-file /app/output/task1.txt

# 任务 2：测试另一个 CIDR
docker-compose run --rm --name task2 mcis-ipv4 \
  -v --cidr 8.8.8.0/24 --out-file /app/output/task2.txt
```

### Q9: 如何集成到 CI/CD 流程？

示例 GitHub Actions 工作流：

```yaml
name: IP Optimization

on:
  schedule:
    - cron: '0 2 * * *'  # 每天凌晨 2 点
  workflow_dispatch:

jobs:
  optimize:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run IP optimization
        run: |
          docker-compose build
          docker-compose up mcis-ipv4
      
      - name: Upload results
        uses: actions/upload-artifact@v3
        with:
          name: optimization-results
          path: output/
```

### Q10: 如何监控定时任务的执行情况？

```bash
# 查看 cron 服务日志
docker-compose --profile cron logs -f mcis-cron

# 进入容器查看 cron 日志
docker exec -it mcis-cron sh
cat /var/log/cron.log  # 如果有配置日志文件
```

## 高级用法

### 组合多个服务

```bash
# 同时运行 IPv4 和 IPv6 优选，并进行下载测速
docker-compose --profile download up mcis-ipv4-download mcis-ipv6
```

### 使用 Docker Compose Override

创建 `docker-compose.override.yml` 覆盖默认配置：

```yaml
version: '3.8'

services:
  mcis-ipv4:
    command: >
      -v
      --out text
      --cidr-file /app/ipv4cidr.txt
      --budget 5000
      --top 50
      --out-file /app/output/ipv4-results.txt
```

### 资源限制

在 `docker-compose.yml` 中添加资源限制：

```yaml
services:
  mcis-ipv4:
    # ... 其他配置 ...
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 1G
        reservations:
          cpus: '1'
          memory: 512M
```

## 故障排查

### 检查容器状态

```bash
docker-compose ps
```

### 查看详细日志

```bash
docker-compose logs --tail=200 mcis-ipv4
```

### 进入容器调试

```bash
docker-compose run --rm --entrypoint sh mcis-ipv4
```

### 测试网络连接

```bash
docker-compose run --rm mcis-ipv4 -v --cidr 1.1.1.1/32 --budget 1
```

## 更多信息

- [项目主页](https://github.com/Leo-Mu/montecarlo-ip-searcher)
- [完整参数说明](readme.md)
- [问题反馈](https://github.com/Leo-Mu/montecarlo-ip-searcher/issues)
