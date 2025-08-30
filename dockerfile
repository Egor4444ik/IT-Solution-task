FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    tree \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# ДИАГНОСТИКА СТРУКТУРЫ ПРОЕКТА
RUN echo "=== FULL PROJECT STRUCTURE ===" && \
    tree -a /app || find /app -type f -name "*.py" | head -20

RUN echo "=== SOLUTION_SITE DIRECTORY CONTENTS ===" && \
    ls -la /app/solution_site/

RUN echo "=== INNER SOLUTION_SITE DIRECTORY ===" && \
    ls -la /app/solution_site/solution_site/

RUN echo "=== WSGI.PY CONTENT ===" && \
    cat /app/solution_site/solution_site/wsgi.py

RUN echo "=== PYTHONPATH DIAGNOSTICS ===" && \
    echo "PYTHONPATH: $PYTHONPATH" && \
    echo "=== Testing imports ===" && \
    PYTHONPATH=/app python -c "\
import sys; \
print('Python paths:'); \
[print(p) for p in sys.path]; \
print('=== Trying to import wsgi ==='); \
try: \
    import solution_site.solution_site.wsgi; \
    print('SUCCESS: solution_site.solution_site.wsgi imported'); \
except Exception as e: \
    print(f'ERROR: {e}'); \
    print('=== Trying simple solution_site ==='); \
    try: \
        import solution_site.wsgi; \
        print('SUCCESS: solution_site.wsgi imported'); \
    except Exception as e2: \
        print(f'ERROR: {e2}') \
"

# ИСПРАВЛЯЕМ DJANGO_SETTINGS_MODULE
RUN sed -i "s/'solution_site.settings'/'solution_site.solution_site.settings'/" /app/solution_site/solution_site/wsgi.py

WORKDIR /app

EXPOSE 8000

# КОМАНДА С ПРАВИЛЬНЫМ ПУТЕМ
CMD ["gunicorn", \
    "solution_site.solution_site.wsgi:application", \
    "--pythonpath", "/app", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]