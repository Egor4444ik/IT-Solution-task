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

# ИСПРАВЛЯЕМ DJANGO_SETTINGS_MODULE В WSGI.PY
RUN sed -i "s/'solution_site.settings'/'solution_site.solution_site.settings'/" /app/solution_site/solution_site/wsgi.py

WORKDIR /app

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