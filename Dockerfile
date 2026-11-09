FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o /ouo-service .

FROM alpine:latest
WORKDIR /
COPY --from=builder /ouo-service /ouo-service
EXPOSE 8080
CMD ["/ouo-service"]
