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

# ПРАВИЛЬНЫЙ PYTHONPATH
ENV PYTHONPATH="/app:$PYTHONPATH"

# ПРОСТАЯ ДИАГНОСТИКА
RUN echo "=== Project structure ===" && \
    find /app -name "*.py" | head -10 && \
    echo "=== WSGI check ===" && \
    python -c "\
try: \
    from solution_site.solution_site import wsgi; \
    print('✓ WSGI module found'); \
except Exception as e: \
    print('✗ Error:', e); \
"

WORKDIR /app/solution_site  # РАБОТАЕМ ИЗ ПАПКИ ПРОЕКТА

EXPOSE 8000

# ПРАВИЛЬНЫЙ ПУТЬ К WSGI
CMD ["gunicorn", "solution_site.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]