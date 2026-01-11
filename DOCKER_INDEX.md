# Docker 使用指南索引

欢迎使用 Monte Carlo IP Searcher 的 Docker 版本！本文档帮助你快速找到所需的信息。

## 🎯 我想...

### 快速开始
- **5 分钟上手** → [DOCKER_QUICKSTART.md](DOCKER_QUICKSTART.md)
- **了解基本命令** → [DOCKER_QUICKSTART.md#常用命令](DOCKER_QUICKSTART.md#常用命令)
- **查看示例输出** → [DOCKER_QUICKSTART.md#示例输出](DOCKER_QUICKSTART.md#示例输出)

### 详细使用
- **了解所有服务** → [DOCKER_USAGE.md#服务说明](DOCKER_USAGE.md#服务说明)
- **查看使用场景** → [DOCKER_USAGE.md#使用场景](DOCKER_USAGE.md#使用场景)
- **修改配置参数** → [DOCKER_USAGE.md#配置说明](DOCKER_USAGE.md#配置说明)
- **解决问题** → [DOCKER_USAGE.md#常见问题](DOCKER_USAGE.md#常见问题)

### 高级功能
- **配置 DNS 自动上传** → [DOCKER_USAGE.md#场景-3自动更新-dns-记录](DOCKER_USAGE.md#场景-3自动更新-dns-记录)
- **设置定时任务** → [DOCKER_USAGE.md#场景-4定时自动优选](DOCKER_USAGE.md#场景-4定时自动优选)
- **自定义配置** → [examples/README.md](examples/README.md)
- **CI/CD 集成** → [.github/workflows/docker-example.yml.disabled](.github/workflows/docker-example.yml.disabled)

### 解决问题
- **解决问题** → [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - 详细的故障排查指南
- **常见问题** → [DOCKER_USAGE.md#常见问题](DOCKER_USAGE.md#常见问题)
- **Docker 镜像问题** → [TROUBLESHOOTING.md#问题-2-docker-镜像拉取失败](TROUBLESHOOTING.md#问题-2-docker-镜像拉取失败)
- **网络连接问题** → [TROUBLESHOOTING.md#问题-5-网络连接失败](TROUBLESHOOTING.md#问题-5-网络连接失败)
- **查看所有文件** → [DOCKER_FILES.md](DOCKER_FILES.md)
- **项目总结** → [DOCKER_SUMMARY.md](DOCKER_SUMMARY.md)
- **主项目文档** → [readme.md](readme.md)

## 📚 文档结构

```
DOCKER_INDEX.md (本文件)
├── DOCKER_QUICKSTART.md      ⭐ 新手必读
│   ├── 三步开始
│   ├── 常用命令
│   └── 故障排查
│
├── DOCKER_USAGE.md           📖 完整文档
│   ├── 服务说明
│   ├── 使用场景
│   ├── 配置说明
│   ├── 常见问题
│   └── 高级用法
│
├── DOCKER_FILES.md           🗂️ 文件说明
│   ├── 文件清单
│   ├── 使用流程
│   └── 维护说明
│
├── DOCKER_SUMMARY.md         📊 项目总结
│   ├── 功能概览
│   ├── 快速开始
│   └── 最佳实践
│
└── examples/                 💡 配置示例
    ├── README.md
    └── custom-config.yml
```

## 🚀 快速命令参考

### 基础操作

```bash
# 构建镜像
docker-compose build

# IPv4 优选
docker-compose up mcis-ipv4

# IPv6 优选
docker-compose up mcis-ipv6

# 查看结果
cat output/ipv4-results.txt
```

### 使用脚本

```bash
# 构建
./scripts/build.sh

# IPv4 优选
./scripts/run-ipv4.sh

# IPv6 优选
./scripts/run-ipv6.sh

# 下载测速
./scripts/run-with-download.sh

# DNS 配置
./scripts/setup-dns.sh
```

### 高级功能

```bash
# 下载测速
docker-compose --profile download up mcis-ipv4-download

# DNS 上传（Cloudflare）
docker-compose --profile dns up mcis-dns-cloudflare

# 定时任务
docker-compose --profile cron up -d mcis-cron

# 自定义配置
docker-compose -f examples/custom-config.yml up <service-name>
```

## 🎓 学习路径

### 第一步：快速体验（5 分钟）
1. 阅读 [DOCKER_QUICKSTART.md](DOCKER_QUICKSTART.md)
2. 运行 `./scripts/build.sh`
3. 运行 `./scripts/run-ipv4.sh`
4. 查看 `output/ipv4-results.txt`

### 第二步：深入了解（30 分钟）
1. 阅读 [DOCKER_USAGE.md](DOCKER_USAGE.md)
2. 尝试不同的服务
3. 修改配置参数
4. 查看日志输出

### 第三步：高级应用（1 小时）
1. 配置 DNS 自动上传
2. 设置定时任务
3. 自定义配置文件
4. 集成到 CI/CD

## 🔍 按场景查找

### 场景：我是新手，想快速试用
→ [DOCKER_QUICKSTART.md](DOCKER_QUICKSTART.md)

### 场景：我想优选 IPv4 地址
→ [DOCKER_QUICKSTART.md#3️⃣-运行优选](DOCKER_QUICKSTART.md#3️⃣-运行优选)

### 场景：我想优选 IPv6 地址
→ [DOCKER_QUICKSTART.md#3️⃣-运行优选](DOCKER_QUICKSTART.md#3️⃣-运行优选)

### 场景：我想测试下载速度
→ [DOCKER_USAGE.md#场景-2带下载测速的优选](DOCKER_USAGE.md#场景-2带下载测速的优选)

### 场景：我想自动更新 DNS 记录
→ [DOCKER_USAGE.md#场景-3自动更新-dns-记录](DOCKER_USAGE.md#场景-3自动更新-dns-记录)

### 场景：我想定时自动运行
→ [DOCKER_USAGE.md#场景-4定时自动优选](DOCKER_USAGE.md#场景-4定时自动优选)

### 场景：我想自定义参数
→ [DOCKER_USAGE.md#场景-5自定义参数运行](DOCKER_USAGE.md#场景-5自定义参数运行)

### 场景：我想在 CI/CD 中使用
→ [.github/workflows/docker-example.yml.disabled](.github/workflows/docker-example.yml.disabled)

### 场景：我遇到了问题
→ [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - 详细的故障排查指南  
→ [DOCKER_USAGE.md#常见问题](DOCKER_USAGE.md#常见问题) - 快速问答

## 📋 文件清单

### 必需文件
- ✅ `Dockerfile` - 镜像构建文件
- ✅ `docker-compose.yml` - 主配置文件
- ✅ `.dockerignore` - 忽略文件

### 推荐文件
- 📖 `DOCKER_QUICKSTART.md` - 快速开始
- 📖 `DOCKER_USAGE.md` - 完整文档
- 🔧 `scripts/*.sh` - 便捷脚本

### 可选文件
- 📖 `DOCKER_FILES.md` - 文件说明
- 📖 `DOCKER_SUMMARY.md` - 项目总结
- 💡 `examples/` - 配置示例
- 🤖 `.github/workflows/` - CI/CD 示例

## 🛠️ 工具和脚本

### 构建工具
- `scripts/build.sh` - 构建 Docker 镜像

### 运行工具
- `scripts/run-ipv4.sh` - 运行 IPv4 优选
- `scripts/run-ipv6.sh` - 运行 IPv6 优选
- `scripts/run-with-download.sh` - 运行下载测速

### 配置工具
- `scripts/setup-dns.sh` - DNS 配置向导

## 💡 提示和技巧

### 提示 1：使用脚本更简单
脚本已经封装了常用命令，推荐新手使用：
```bash
./scripts/run-ipv4.sh
```

### 提示 2：查看实时日志
使用 `-f` 参数查看实时日志：
```bash
docker-compose logs -f mcis-ipv4
```

### 提示 3：后台运行
使用 `-d` 参数后台运行：
```bash
docker-compose up -d mcis-ipv4
```

### 提示 4：自定义参数
使用 `docker-compose run` 传入自定义参数：
```bash
docker-compose run --rm mcis-ipv4 -v --cidr 1.1.1.0/24 --top 10
```

### 提示 5：使用简化配置
新手可以使用简化配置：
```bash
docker-compose -f docker-compose.simple.yml up
```

## 🔗 相关链接

- [项目主页](https://github.com/Leo-Mu/montecarlo-ip-searcher)
- [主 README](readme.md)
- [问题反馈](https://github.com/Leo-Mu/montecarlo-ip-searcher/issues)

## 📞 获取帮助

### 文档内查找
1. 查看 [常见问题](DOCKER_USAGE.md#常见问题)
2. 查看 [故障排查](DOCKER_USAGE.md#故障排查)
3. 搜索文档关键词

### 社区支持
1. [GitHub Issues](https://github.com/Leo-Mu/montecarlo-ip-searcher/issues)
2. [GitHub Discussions](https://github.com/Leo-Mu/montecarlo-ip-searcher/discussions)

## 🎉 开始使用

准备好了吗？从这里开始：

1. **新手** → [DOCKER_QUICKSTART.md](DOCKER_QUICKSTART.md)
2. **进阶** → [DOCKER_USAGE.md](DOCKER_USAGE.md)
3. **高级** → [examples/README.md](examples/README.md)

祝你使用愉快！🚀
