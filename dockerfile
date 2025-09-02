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

RUN chmod 644 /app/solution_site/solution_site/wsgi.py

EXPOSE 8000

RUN ls

WORKDIR /app

RUN python -c "open('/app/solution_site/solution_site/wsgi.py', 'r').read()"

RUN ls -la /app/solution_site/solution_site/wsgi.py
RUN file /app/solution_site/solution_site/wsgi.py
RUN cat /app/solution_site/solution_site/wsgi.pyution_site/solution_site

RUN echo 'import os\nfrom django.core.wsgi import get_wsgi_application\n\nos.environ.setdefault("DJANGO_SETTINGS_MODULE", "solution_site.settings")\napplication = get_wsgi_application()' > /app/solution_site/solution_site/wsgi.py

CMD ["uwsgi", "--http", "0.0.0.0:8000", "--wsgi-file", "/app/solution_site/solution_site/wsgi.py", "--callable", "application"]