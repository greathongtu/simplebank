FROM golang:1.21.1-alpine3.18 AS builder
ARG GOPROXY=https://goproxy.cn,direct
WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8080
CMD ["/app/main"]
