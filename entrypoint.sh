#!/bin/bash
set -e

cd /app/solution_site || { echo "Error: Cannot change to /app/solution_site directory"; exit 1; }

echo "Applying migrations..."
python manage.py migrate --noinput

echo "Starting Gunicorn..."
exec gunicorn solution_site.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level debug \
    --access-logfile - \
    --error-logfile -