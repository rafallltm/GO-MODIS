# Etapa 1: Build
FROM golang:alpine AS builder

# Instalar dependências necessárias
RUN apk add --no-cache git build-base

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o código-fonte para o contêiner
COPY modis.go .

# Compilar o programa
RUN go build -o modis modis.go

# Etapa 2: Runtime
FROM alpine:latest

# Instalar dependências necessárias para execução
RUN apk add --no-cache lm-sensors

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o binário compilado da etapa de build
COPY --from=builder /app/modis .

# Comando padrão para executar o programa
CMD ["./modis"]