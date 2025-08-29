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

WORKDIR /app
RUN ls -la  # Покажет что в /app
RUN find . -name "manage.py"  # Найдет manage.py

WORKDIR /app/solution_site

RUN python manage.py collectstatic --noinput
RUN python manage.py migrate


HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD curl -f http://localhost:8000/health/ || exit 1

EXPOSE 8000

CMD ["gunicorn", \
    "solution_site.wsgi:application", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]
