# --- Tahap Build ---
FROM golang:1.20-alpine AS builder
WORKDIR /app

# 1. Instal dependensi sistem yang dibutuhkan Go
RUN apk add --no-cache git ca-certificates

# 2. Atur GOPROXY agar pengambilan dependensi lebih stabil
ENV GOPROXY=https://proxy.golang.org,direct

# 3. Salin file modul dan unduh dependensi
COPY go.mod ./
RUN go mod tidy

# 4. Salin sisa kode dan lakukan build
COPY main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /ouo-service .

# --- Tahap Runtime ---
FROM alpine:latest
WORKDIR /
COPY --from=builder /ouo-service /ouo-service
EXPOSE 8080
CMD ["/ouo-service"]
