FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

WORKDIR /app/solution_site

RUN ls -la && pwd

RUN python /app/solution_site/manage.py collectstatic --noinput

EXPOSE 8000

CMD ["python", "/app/solution_site/manage.py", "runserver", "0.0.0.0:8000"]