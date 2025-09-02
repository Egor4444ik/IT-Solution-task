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

# ДОБАВЛЯЕМ ПУТЬ К ВНУТРЕННЕМУ ПАКЕТУ В PYTHONPATH
ENV PYTHONPATH="/app/solution_site/solution_site:$PYTHONPATH"

# ИСПРАВЛЯЕМ DJANGO_SETTINGS_MODULE (возвращаем оригинальный путь)
RUN sed -i "s/'solution_site.solution_site.settings'/'solution_site.settings'/" /app/solution_site/solution_site/wsgi.py

# ДИАГНОСТИКА: ПРОВЕРЯЕМ, ЧТО ВСЕ РАБОТАЕТ (ИСПРАВЛЕННАЯ ВЕРСИЯ)
RUN echo "=== Testing imports ===" && \
    echo "PYTHONPATH: $PYTHONPATH" && \
    python -c "\
import sys; \
print('Python paths:'); \
[print(f'  {p}') for p in sys.path]; \
print(); \
print('Testing solution_site import:'); \
try: \
    import solution_site; \
    print('  ✓ solution_site imported'); \
    print(f'  Path: {solution_site.__file__}'); \
except Exception as e: \
    print(f'  ✗ Failed: {e}'); \
print(); \
print('Testing solution_site.wsgi import:'); \
try: \
    import solution_site.wsgi; \
    print('  ✓ solution_site.wsgi imported'); \
except Exception as e: \
    print(f'  ✗ Failed: {e}'); \
"

RUN find /app -name "*.py" | grep wsgi
RUN python -c "import solution_site.wsgi; print('WSGI module found')"

WORKDIR /app

EXPOSE 8000

# ТЕПЕРЬ solution_site ДОСТУПЕН КАК КОРНЕВОЙ ПАКЕТ
CMD ["gunicorn", \
    "solution_site.wsgi:application", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]