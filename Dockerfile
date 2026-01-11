# 构建阶段
FROM golang:1.25-alpine AS builder

# 安装必要的构建工具
RUN apk add --no-cache git ca-certificates

# 设置工作目录
WORKDIR /build

# 复制 go.mod 和 go.sum（如果存在）
COPY go.mod go.sum* ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建应用
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o mcis ./cmd/mcis

# 运行阶段
FROM alpine:latest

# 安装 ca-certificates 以支持 HTTPS
RUN apk --no-cache add ca-certificates tzdata

# 设置时区（可选）
ENV TZ=Asia/Shanghai

WORKDIR /app

# 从构建阶段复制二进制文件
COPY --from=builder /build/mcis .

# 复制 CIDR 文件
COPY ipv4cidr.txt ipv6cidr.txt ./

# 创建输出目录
RUN mkdir -p /app/output

# 设置为非 root 用户运行（可选，增强安全性）
RUN addgroup -g 1000 mcis && \
    adduser -D -u 1000 -G mcis mcis && \
    chown -R mcis:mcis /app

USER mcis

# 默认命令
ENTRYPOINT ["/app/mcis"]
CMD ["--help"]
