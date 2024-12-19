# Etapa 1: Construção (Build)
FROM python:3.11-slim as builder

# Instalar dependências do sistema necessárias para o build
RUN apt-get update && \
    apt-get install -y git curl && \
    apt-get clean

# Clonar o repositório
WORKDIR /app
RUN git clone https://github.com/badtuxx/giropops-senhas.git

# Entrar no diretório do repositório clonado
WORKDIR /app/giropops-senhas/

# Instalar o PIP
RUN apt-get install -y python3-pip

# Instalar as dependências da aplicação
RUN pip install --no-cache-dir -r requirements.txt

# Etapa 2: Imagem final para produção
FROM python:3.11-slim as production

# Instalar Redis e outras dependências do sistema
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Copiar as dependências e o código da etapa de build
COPY --from=builder /app/giropops-senhas /app/giropops-senhas
WORKDIR /app/giropops-senhas

# Definir variável de ambiente REDIS_HOST para o Redis local
ENV REDIS_HOST=redis

# Expor a porta do Flask (se necessário)
EXPOSE 5000

# Iniciar a aplicação Flask
CMD flask run --host=0.0.0.0
