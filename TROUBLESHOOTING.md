# 故障排查指南

本文档提供常见问题的详细解决方案。

## Docker 相关问题

### 问题 1: Docker daemon 未运行

**错误信息：**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

**解决方案：**

#### macOS
1. 启动 Docker Desktop 应用
2. 等待 Docker 图标显示为绿色（运行中）
3. 重新运行命令

#### Linux
```bash
# 启动 Docker 服务
sudo systemctl start docker

# 设置开机自启
sudo systemctl enable docker

# 检查状态
sudo systemctl status docker
```

#### Windows
1. 启动 Docker Desktop 应用
2. 确保 WSL 2 已正确配置
3. 等待 Docker 启动完成

---

### 问题 2: Docker 镜像拉取失败

**错误信息：**
```
failed to solve: golang:1.25-alpine: failed to resolve source metadata
```

**原因：**
- 网络连接问题
- Docker Hub 访问受限
- 镜像版本不存在

**解决方案：**

#### 方案 1: 使用备用 Dockerfile（推荐）

编辑 `docker-compose.yml`，修改 build 部分：

```yaml
services:
  mcis-ipv4:
    build:
      context: .
      dockerfile: Dockerfile.debian  # 使用 Debian 基础镜像
```

然后重新构建：
```bash
docker-compose build
```

#### 方案 2: 配置镜像加速器（中国大陆用户）

**macOS/Windows (Docker Desktop):**
1. 打开 Docker Desktop
2. 进入 Settings → Docker Engine
3. 添加以下配置：

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.ccs.tencentyun.com"
  ]
}
```

4. 点击 "Apply & Restart"

**Linux:**

编辑 `/etc/docker/daemon.json`：
```bash
sudo nano /etc/docker/daemon.json
```

添加内容：
```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.ccs.tencentyun.com"
  ]
}
```

重启 Docker：
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

#### 方案 3: 使用代理

```bash
# 设置代理环境变量
export HTTP_PROXY=http://your-proxy:port
export HTTPS_PROXY=http://your-proxy:port
export NO_PROXY=localhost,127.0.0.1

# 构建镜像
docker-compose build
```

#### 方案 4: 修改 Dockerfile 使用特定版本

编辑 `Dockerfile`，修改第一行：

```dockerfile
# 使用 Go 1.23（更稳定）
FROM golang:1.23-alpine AS builder

# 或使用最新版本
FROM golang:alpine AS builder
```

---

### 问题 3: 环境变量警告

**警告信息：**
```
The "CF_API_TOKEN" variable is not set. Defaulting to a blank string.
```

**说明：** 这是正常的警告，不影响基础功能。

**解决方案：**

如果不使用 DNS 上传功能，可以忽略这些警告。

如果需要使用 DNS 功能：

1. 复制环境变量模板：
```bash
cp .env.example .env
```

2. 编辑 `.env` 文件，填入你的凭证：
```bash
CF_API_TOKEN=your_token_here
CF_ZONE_ID=your_zone_id_here
```

---

### 问题 4: 权限错误

**错误信息：**
```
Permission denied: '/app/output/results.txt'
```

**解决方案：**

```bash
# 方案 1: 修改输出目录权限
chmod 777 output

# 方案 2: 使用当前用户 ID
# 编辑 docker-compose.yml，添加 user 参数
services:
  mcis-ipv4:
    user: "${UID}:${GID}"
```

---

### 问题 5: 网络连接失败

**错误信息：**
```
All probes failed: ok=false
```

**可能原因：**
- 本地网络问题
- 防火墙拦截
- 目标 IP 不可达
- 超时时间太短

**解决方案：**

1. **检查网络连接：**
```bash
# 测试网络
ping 1.1.1.1

# 测试 HTTPS 连接
curl -I https://example.com
```

2. **增加超时时间：**

编辑 `docker-compose.yml`，修改 `--timeout` 参数：
```yaml
command: >
  -v
  --timeout 5s  # 从 3s 增加到 5s
  --cidr-file /app/ipv4cidr.txt
```

3. **测试单个 IP：**
```bash
docker-compose run --rm mcis-ipv4 \
  -v \
  --cidr 1.1.1.1/32 \
  --budget 1 \
  --timeout 10s
```

4. **检查防火墙：**
```bash
# macOS
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

# Linux
sudo ufw status
```

---

## 构建相关问题

### 问题 6: Go 版本不匹配

**错误信息：**
```
go.mod requires go >= 1.25.5
```

**解决方案：**

修改 `Dockerfile` 使用更新的 Go 版本：

```dockerfile
FROM golang:1.25-alpine AS builder
```

或者修改 `go.mod` 降低版本要求：

```
go 1.23
```

---

### 问题 7: 依赖下载失败

**错误信息：**
```
go: downloading ... timeout
```

**解决方案：**

1. **使用 Go 代理（中国大陆用户）：**

编辑 `Dockerfile`，在 `go mod download` 前添加：

```dockerfile
ENV GOPROXY=https://goproxy.cn,direct
RUN go mod download
```

2. **使用代理：**
```bash
export GOPROXY=https://goproxy.io,direct
docker-compose build
```

---

## 运行相关问题

### 问题 8: 容器立即退出

**检查日志：**
```bash
docker-compose logs mcis-ipv4
```

**常见原因：**
- 命令参数错误
- CIDR 文件不存在
- 输出目录权限问题

**解决方案：**

1. **验证配置：**
```bash
# 检查 CIDR 文件
cat ipv4cidr.txt

# 检查输出目录
ls -la output/
```

2. **使用简化配置测试：**
```bash
docker-compose -f docker-compose.simple.yml up
```

---

### 问题 9: 结果文件为空

**可能原因：**
- 所有探测都失败了
- 输出路径错误
- 容器提前退出

**解决方案：**

1. **查看详细日志：**
```bash
docker-compose logs -f mcis-ipv4
```

2. **使用 stdout 输出：**

修改 `docker-compose.yml`，移除 `--out-file` 参数：
```yaml
command: >
  -v
  --out text
  --cidr-file /app/ipv4cidr.txt
```

3. **测试小范围 CIDR：**
```bash
docker-compose run --rm mcis-ipv4 \
  -v \
  --cidr 1.1.1.0/24 \
  --budget 100 \
  --top 5
```

---

### 问题 10: 下载测速失败

**错误信息：**
```
download: ok=false
```

**解决方案：**

1. **增加超时时间：**
```yaml
--download-timeout 60s  # 从 45s 增加到 60s
```

2. **减少测速数量：**
```yaml
--download-top 3  # 从 5 减少到 3
```

3. **检查网络带宽：**
```bash
# 测试下载速度
curl -o /dev/null https://speed.cloudflare.com/__down?bytes=10000000
```

---

## DNS 上传问题

### 问题 11: DNS 上传失败

**错误信息：**
```
dns upload error: authentication failed
```

**解决方案：**

1. **验证凭证：**

**Cloudflare:**
```bash
# 测试 API Token
curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Vercel:**
```bash
# 测试 Token
curl -X GET "https://api.vercel.com/v2/user" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

2. **检查权限：**
- Cloudflare: Token 需要 Zone.DNS 编辑权限
- Vercel: Token 需要 DNS 记录管理权限

3. **使用配置向导：**
```bash
./scripts/setup-dns.sh
```

---

## 性能问题

### 问题 12: 构建速度慢

**解决方案：**

1. **使用构建缓存：**
```bash
# 不使用 --no-cache
docker-compose build
```

2. **使用多阶段构建：**
已在 Dockerfile 中实现

3. **清理旧镜像：**
```bash
docker system prune -a
```

---

### 问题 13: 运行速度慢

**解决方案：**

1. **增加并发数：**
```yaml
--concurrency 300  # 从 200 增加到 300
```

2. **减少探测次数：**
```yaml
--budget 1000  # 从 2000 减少到 1000
```

3. **使用更快的网络：**
- 确保网络连接稳定
- 避免使用 VPN（除非必要）

---

## 获取帮助

如果以上方案都无法解决你的问题：

1. **查看完整日志：**
```bash
docker-compose logs --tail=200 mcis-ipv4 > logs.txt
```

2. **收集系统信息：**
```bash
docker version
docker-compose version
uname -a
```

3. **提交 Issue：**
- [GitHub Issues](https://github.com/Leo-Mu/montecarlo-ip-searcher/issues)
- 附上日志和系统信息
- 描述复现步骤

4. **查看文档：**
- [Docker 快速开始](DOCKER_QUICKSTART.md)
- [Docker 完整文档](DOCKER_USAGE.md)
- [主项目文档](readme.md)

---

## 调试技巧

### 进入容器调试

```bash
# 进入运行中的容器
docker-compose exec mcis-ipv4 sh

# 运行临时容器
docker-compose run --rm --entrypoint sh mcis-ipv4
```

### 查看容器状态

```bash
# 查看所有容器
docker-compose ps -a

# 查看资源使用
docker stats

# 查看网络
docker network ls
```

### 测试网络连接

```bash
# 在容器内测试
docker-compose run --rm mcis-ipv4 sh -c "ping -c 3 1.1.1.1"
docker-compose run --rm mcis-ipv4 sh -c "wget -O- https://example.com"
```

---

**最后更新：** 2026-01-11
