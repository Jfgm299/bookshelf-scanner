# Usamos una imagen base de Python oficial
FROM python:3.12-slim

# Instalamos utilidades del sistema necesarias para OpenCV y compilación
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Instalamos Poetry
RUN pip install poetry

# Configuramos el directorio de trabajo
WORKDIR /app

# Copiamos la carpeta del backend al contenedor
COPY ./backend /app/backend

# Nos movemos a la carpeta backend
WORKDIR /app/backend

# Configuración crítica: 
# 1. Desactivamos entornos virtuales (no necesarios en Docker)
# 2. Instalamos dependencias. 
# NOTA: Al correr en CPU, PyTorch se ajustará automáticamente o descargará la versión CPU.
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Exponemos el puerto 7860 (Estándar de Hugging Face Spaces)
EXPOSE 7860

# Comando de inicio
# Ajustamos el host a 0.0.0.0 y el puerto a 7860
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
