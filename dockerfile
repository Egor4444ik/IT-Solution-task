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

# ДИАГНОСТИКА СТРУКТУРЫ
RUN echo "=== FINAL STRUCTURE ===" && \
    find /app -name "*.py" | grep -E "(wsgi.py|settings.py)" && \
    echo "=== WSGI FILE ===" && \
    ls -la /app/solution_site/solution_site/wsgi.py && \
    echo "=== PYTHONPATH TEST ===" && \
    PYTHONPATH=/app python -c "import solution_site.solution_site.wsgi; print('SUCCESS: WSGI module found')"

WORKDIR /app/solution_site
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

WORKDIR /app

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD curl -f http://localhost:8000/health/ || exit 1

EXPOSE 8000

# ИСПРАВЛЕННАЯ КОМАНДА GUNICORN
CMD ["gunicorn", \
    "solution_site.solution_site.wsgi:application", \
    "--pythonpath", "/app", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]