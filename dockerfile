FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    procps net-tools curl\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

#COPY solution_site/ ./solution_site/

#COPY entrypoint.sh /app/entrypoint.sh

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x /app/entrypoint.sh

RUN chmod 644 /app/solution_site/solution_site/wsgi.py

RUN chmod -R 755 /app/solution_site/media

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]