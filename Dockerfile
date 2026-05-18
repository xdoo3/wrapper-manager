FROM --platform=$BUILDPLATFORM golang:1.23 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY . .
RUN go mod tidy
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o wrapper-manager

FROM ubuntu:latest

WORKDIR /root/

COPY --from=builder /app/wrapper-manager .
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
RUN chmod +x ./wrapper-manager

ENTRYPOINT ["./wrapper-manager"]
EXPOSE 8080
