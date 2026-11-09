# --- Tahap Build ---
FROM golang:1.20-alpine AS builder
WORKDIR /app

# 1. Instal git dan ca-certificates (wajib untuk mengunduh modul)
RUN apk add --no-cache git ca-certificates

# 2. Atur GOPROXY dan izinkan go.mod diperbarui otomatis
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOFLAGS=-mod=mod

# 3. Salin go.mod dan jalankan tidy (akan mengunduh dependensi & memperbarui go.mod)
COPY go.mod ./
RUN go mod tidy

# 4. Salin kode utama dan build
COPY main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /ouo-service .

# --- Tahap Runtime ---
FROM alpine:latest
WORKDIR /
COPY --from=builder /ouo-service /ouo-service
EXPOSE 8080
CMD ["/ouo-service"]
