# 配置示例

本目录包含各种使用场景的配置示例。

## 使用方法

```bash
# 使用自定义配置
docker-compose -f examples/custom-config.yml up <service-name>
```

## 可用配置

### custom-config.yml

包含多种预配置的服务：

1. **mcis-high-performance** - 高性能配置
   - 预算：10000 次探测
   - 并发：500
   - 输出：Top 50 IP
   - 适合：服务器环境，需要高精度结果

2. **mcis-quick-test** - 快速测试配置
   - 预算：500 次探测
   - 并发：100
   - 输出：Top 5 IP
   - 适合：快速验证，开发测试

3. **mcis-specific-cidr** - 特定 CIDR 测试
   - 测试指定的 CIDR 段
   - 适合：针对特定 IP 段优选

4. **mcis-custom-domain** - 自定义域名测试
   - 使用自定义域名和路径
   - 适合：测试特定网站的 CDN

5. **mcis-csv-output** - CSV 输出格式
   - 输出 CSV 格式结果
   - 适合：数据分析和导入表格

## 示例命令

```bash
# 高性能配置
docker-compose -f examples/custom-config.yml up mcis-high-performance

# 快速测试
docker-compose -f examples/custom-config.yml up mcis-quick-test

# 特定 CIDR
docker-compose -f examples/custom-config.yml up mcis-specific-cidr

# 自定义域名
docker-compose -f examples/custom-config.yml up mcis-custom-domain

# CSV 输出
docker-compose -f examples/custom-config.yml up mcis-csv-output
```

## 自定义配置

复制 `custom-config.yml` 并修改参数以适应你的需求：

```yaml
services:
  my-custom-service:
    build: ..
    command: >
      -v
      --cidr-file /app/ipv4cidr.txt
      --budget 3000        # 修改预算
      --top 30             # 修改输出数量
      --concurrency 300    # 修改并发数
      --timeout 4s         # 修改超时时间
      --host example.com   # 修改目标域名
      --out text           # 修改输出格式
      --out-file /app/output/my-results.txt
    volumes:
      - ../output:/app/output
      - ../ipv4cidr.txt:/app/ipv4cidr.txt:ro
    network_mode: host
```

## 参数说明

| 参数 | 说明 | 推荐值 |
|------|------|--------|
| `--budget` | 探测次数 | 快速测试: 500, 常规: 2000, 精确: 5000+ |
| `--top` | 输出 IP 数量 | 5-50 |
| `--concurrency` | 并发数 | 100-500 |
| `--timeout` | 超时时间 | 2s-5s |
| `--download-top` | 下载测速数量 | 0-10 |
| `--out` | 输出格式 | text/jsonl/csv |

## 更多信息

- [Docker 快速开始](../DOCKER_QUICKSTART.md)
- [Docker 完整文档](../DOCKER_USAGE.md)
- [项目主页](../readme.md)
