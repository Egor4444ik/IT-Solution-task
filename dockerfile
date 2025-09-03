FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

COPY solution_site/ ./solution_site/

COPY entrypoint.sh /app/entrypoint.sh

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x /app/entrypoint.sh

WORKDIR /app/solution_site

RUN ls

RUN chmod 644 /app/solution_site/solution_site/wsgi.py

EXPOSE 8000

RUN ls

WORKDIR /app

ENTRYPOINT ["/app/entrypoint.sh"]