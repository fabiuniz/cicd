# Usa uma imagem base oficial do Python
FROM python:3.9-slim

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo de requisitos para o diretório de trabalho
COPY requirements.txt .

# Instala as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código da aplicação
COPY . .

# Expõe a porta 5000
EXPOSE 5000

# Comando corrigido para usar a variável PORT do sistema
CMD gunicorn --bind 0.0.0.0:$PORT app:app --workers 1 --timeout 120