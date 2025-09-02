FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем requirements.txt в /app/
COPY requirements.txt .

# Копируем папку solution_site в /app/solution_site/
COPY solution_site/ ./solution_site/

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/solution_site

RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

EXPOSE 8000

WORKDIR /app

CMD ["uwsgi", "--http", "0.0.0.0:8000", "--module", "solution_site.solution_site.wsgi:application", "--processes", "4", "--threads", "2"]