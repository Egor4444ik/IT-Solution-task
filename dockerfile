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

# СОЗДАЕМ СИМЛИНК ДЛЯ ДОСТУПА К SOLUTION_SITE КАК К КОРНЕВОМУ ПАКЕТУ
RUN echo "=== Creating symlink for root-level access ===" && \
    ln -s /app/solution_site/solution_site /app/solution_site_package && \
    echo "Symlink created: /app/solution_site_package -> /app/solution_site/solution_site"

# ИСПРАВЛЯЕМ DJANGO_SETTINGS_MODULE
RUN sed -i "s/'solution_site.settings'/'solution_site_package.settings'/" /app/solution_site/solution_site/wsgi.py

WORKDIR /app

EXPOSE 8000

# ТЕПЕРЬ ПРОСТАЯ КОМАНДА
CMD ["gunicorn", \
    "solution_site_package.wsgi:application", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]