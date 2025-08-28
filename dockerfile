FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

WORKDIR /app/solution_site

RUN ls -la && pwd

# Собираем статические файлы
RUN python manage.py collectstatic --noinput

# Устанавливаем Gunicorn (если его нет в requirements.txt)
RUN pip install gunicorn

EXPOSE 8000

# Запускаем через Gunicorn для production
CMD ["gunicorn", "solution_site.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]