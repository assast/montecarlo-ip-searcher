# Docker 相关文件说明

本文档列出了为支持 Docker Compose 使用而添加的所有文件。

## 核心文件

### Dockerfile
Docker 镜像构建文件，使用多阶段构建优化镜像大小。

**特点**：
- 基于 Alpine Linux，镜像体积小
- 多阶段构建，最终镜像仅包含必要文件
- 非 root 用户运行，增强安全性
- 包含 ca-certificates 支持 HTTPS

### docker-compose.yml
主要的 Docker Compose 配置文件，包含多个预配置服务。

**包含的服务**：
- `mcis-ipv4` - IPv4 优选
- `mcis-ipv6` - IPv6 优选
- `mcis-ipv4-download` - IPv4 优选 + 下载测速
- `mcis-dns-cloudflare` - 自动上传到 Cloudflare DNS
- `mcis-dns-vercel` - 自动上传到 Vercel DNS
- `mcis-cron` - 定时任务服务

### docker-compose.simple.yml
简化版配置文件，适合快速开始。

**用途**：
- 新手入门
- 快速测试
- 最小化配置

### .dockerignore
Docker 构建时忽略的文件列表。

**作用**：
- 减少构建上下文大小
- 加快构建速度
- 避免敏感文件进入镜像

### .env.example
环境变量模板文件。

**包含**：
- Cloudflare API Token 和 Zone ID
- Vercel Token 和 Team ID

## 文档文件

### DOCKER_QUICKSTART.md
快速开始指南，5 分钟上手。

**内容**：
- 三步快速开始
- 常用命令
- 基础故障排查

### DOCKER_USAGE.md
完整的使用文档。

**内容**：
- 详细的服务说明
- 多种使用场景
- 配置参数详解
- 常见问题解答
- 高级用法
- 故障排查

### DOCKER_FILES.md（本文件）
Docker 相关文件的说明文档。

## 脚本文件

所有脚本位于 `scripts/` 目录，已添加执行权限。

### scripts/build.sh
构建 Docker 镜像的脚本。

**用法**：
```bash
./scripts/build.sh
```

### scripts/run-ipv4.sh
快速运行 IPv4 优选的脚本。

**用法**：
```bash
./scripts/run-ipv4.sh
```

### scripts/run-ipv6.sh
快速运行 IPv6 优选的脚本。

**用法**：
```bash
./scripts/run-ipv6.sh
```

### scripts/run-with-download.sh
运行带下载测速的优选脚本。

**用法**：
```bash
./scripts/run-with-download.sh
```

### scripts/setup-dns.sh
DNS 配置向导脚本，交互式配置 DNS 上传功能。

**用法**：
```bash
./scripts/setup-dns.sh
```

**功能**：
- 交互式选择 DNS 服务商
- 自动创建和更新 .env 文件
- 提供后续使用指引

## 示例文件

### examples/custom-config.yml
自定义配置示例文件。

**包含的配置**：
- `mcis-high-performance` - 高性能配置
- `mcis-quick-test` - 快速测试配置
- `mcis-specific-cidr` - 特定 CIDR 测试
- `mcis-custom-domain` - 自定义域名测试
- `mcis-csv-output` - CSV 输出格式

**用法**：
```bash
docker-compose -f examples/custom-config.yml up <service-name>
```

### examples/README.md
示例配置的说明文档。

## CI/CD 文件

### .github/workflows/docker-example.yml.disabled
GitHub Actions 工作流示例（默认禁用）。

**功能**：
- 定时运行 IP 优选
- 手动触发优选
- 自动上传结果
- DNS 自动更新

**启用方法**：
重命名为 `docker-example.yml` 并配置 GitHub Secrets。

## 文件结构

```
.
├── Dockerfile                              # Docker 镜像构建文件
├── docker-compose.yml                      # 主配置文件
├── docker-compose.simple.yml               # 简化配置文件
├── .dockerignore                           # Docker 忽略文件
├── .env.example                            # 环境变量模板
├── DOCKER_QUICKSTART.md                    # 快速开始指南
├── DOCKER_USAGE.md                         # 完整使用文档
├── DOCKER_FILES.md                         # 本文件
├── scripts/
│   ├── build.sh                            # 构建脚本
│   ├── run-ipv4.sh                         # IPv4 运行脚本
│   ├── run-ipv6.sh                         # IPv6 运行脚本
│   ├── run-with-download.sh                # 下载测速脚本
│   └── setup-dns.sh                        # DNS 配置向导
├── examples/
│   ├── README.md                           # 示例说明
│   └── custom-config.yml                   # 自定义配置示例
└── .github/
    └── workflows/
        └── docker-example.yml.disabled     # GitHub Actions 示例
```

## 使用流程

### 新手推荐流程

1. 阅读 [DOCKER_QUICKSTART.md](DOCKER_QUICKSTART.md)
2. 运行 `./scripts/build.sh` 构建镜像
3. 运行 `./scripts/run-ipv4.sh` 开始优选
4. 查看 `output/ipv4-results.txt` 结果

### 进阶使用流程

1. 阅读 [DOCKER_USAGE.md](DOCKER_USAGE.md)
2. 根据需求选择合适的服务
3. 修改 `docker-compose.yml` 自定义参数
4. 使用 `docker-compose up <service-name>` 运行

### DNS 自动上传流程

1. 运行 `./scripts/setup-dns.sh` 配置凭证
2. 使用 `docker-compose --profile dns up <dns-service>` 运行
3. 查看日志确认上传成功

### 定时任务流程

1. 修改 `docker-compose.yml` 中的 cron 表达式
2. 运行 `docker-compose --profile cron up -d mcis-cron`
3. 使用 `docker-compose --profile cron logs -f` 查看日志

## 维护说明

### 更新镜像

```bash
# 重新构建（无缓存）
docker-compose build --no-cache

# 重启服务
docker-compose up <service-name>
```

### 清理资源

```bash
# 停止所有服务
docker-compose down

# 删除镜像
docker-compose down --rmi all

# 删除卷
docker-compose down -v
```

### 查看日志

```bash
# 实时日志
docker-compose logs -f <service-name>

# 最近 100 行
docker-compose logs --tail=100 <service-name>
```

## 常见问题

### Q: 为什么需要这么多文件？

A: 为了支持不同的使用场景和用户需求：
- 新手需要简单的快速开始指南
- 进阶用户需要详细的配置说明
- 自动化需要脚本和 CI/CD 配置
- 不同场景需要不同的配置模板

### Q: 我应该从哪个文件开始？

A: 推荐顺序：
1. [DOCKER_QUICKSTART.md](DOCKER_QUICKSTART.md) - 快速上手
2. [docker-compose.simple.yml](docker-compose.simple.yml) - 简单配置
3. [DOCKER_USAGE.md](DOCKER_USAGE.md) - 深入学习
4. [docker-compose.yml](docker-compose.yml) - 完整功能

### Q: 可以删除某些文件吗？

A: 核心文件（必需）：
- `Dockerfile`
- `docker-compose.yml` 或 `docker-compose.simple.yml`

可选文件：
- 文档文件（`.md`）
- 脚本文件（`scripts/`）
- 示例文件（`examples/`）
- CI/CD 文件（`.github/`）

### Q: 如何自定义配置？

A: 三种方式：
1. 修改 `docker-compose.yml` 中的参数
2. 复制 `examples/custom-config.yml` 并修改
3. 使用 `docker-compose run` 传入自定义参数

## 贡献

如果你有改进建议或发现问题，欢迎：
- 提交 Issue
- 提交 Pull Request
- 分享你的使用经验

## 许可证

与主项目相同，使用 GPL-3.0 许可证。
