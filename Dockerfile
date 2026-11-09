FROM golang:1.22-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git ca-certificates
COPY go.mod ./
COPY main.go ./
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o /ouo-service .

FROM alpine:latest
WORKDIR /
COPY --from=builder /ouo-service /ouo-service
EXPOSE 8080
CMD ["/ouo-service"]
