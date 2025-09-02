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

# Correct way to test imports
RUN echo "=== Testing imports ==="
RUN PYTHONPATH=/app python -c "try: import solution_site.solution_site.wsgi; print('SUCCESS: solution_site.solution_site.wsgi imported'); except Exception as e: print(f'ERROR: {e}')"


WORKDIR /app

EXPOSE 8000

CMD ["gunicorn", \
    "wsgi:application", \
    "--pythonpath", "/app", \
    "--bind", "0.0.0.0:8000", \
    "--workers", "3", \
    "--log-level", "debug", \
    "--access-logfile", "-", \
    "--error-logfile", "-"]