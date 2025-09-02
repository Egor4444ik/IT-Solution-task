FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# УПРОЩАЕМ СТРУКТУРУ: ПЕРЕМЕЩАЕМ ФАЙЛЫ ИЗ ВНУТРЕННЕЙ ПАПКИ
RUN echo "=== Simplifying project structure ===" && \
    mv /app/solution_site/solution_site/* /app/solution_site/ && \
    rmdir /app/solution_site/solution_site/ && \
    echo "=== New structure ===" && \
    ls -la /app/solution_site/

# ВОССТАНАВЛИВАЕМ ОРИГИНАЛЬНЫЙ DJANGO_SETTINGS_MODULE В WSGI.PY
RUN sed -i "s/'solution_site.solution_site.settings'/'solution_site.settings'/" /app/solution_site/wsgi.py

WORKDIR /app

EXPOSE 8000

# ТЕПЕРЬ ПРОСТАЯ И ПРАВИЛЬНАЯ КОМАНДА
CMD ["gunicorn", \
    "solution_site.wsgi:application", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]