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

WORKDIR /app/solution_site

RUN ls -la && pwd

RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

EXPOSE 8000

CMD ["gunicorn", "solution_site.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]

# Добавляем скрипт
COPY wait_and_check.sh /app/wait_and_check.sh
RUN chmod +x /app/wait_and_check.sh