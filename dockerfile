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

RUN echo "=== Fixing DJANGO_SETTINGS_MODULE ===" && \
    sed -i "s/'solution_site.settings'/'solution_site.solution_site.settings'/" /app/solution_site/solution_site/wsgi.py

ENV PYTHONPATH="/app/solution_site:$PYTHONPATH"

RUN echo "=== Project structure ===" && \
    find /app -name "*.py" | head -10 && \
    echo "=== Checking for random_quotes ===" && \
    find /app -name "*random_quotes*" -type d

WORKDIR /app/solution_site
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

WORKDIR /app

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD curl -f http://localhost:8000/health/ || exit 1

EXPOSE 8000

WORKDIR /app/solution_site

CMD ["gunicorn", \
    "solution_site.wsgi:application", \
    "--pythonpath", "/app", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]