FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/solution_site  # РАБОТАЕМ ИЗ ПАПКИ ПРОЕКТА

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Python должен видеть корень проекта
ENV PYTHONPATH="/app:$PYTHONPATH"

RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

EXPOSE 8000

# Запускаем из текущей директории
CMD ["gunicorn", "solution_site.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]