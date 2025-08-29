#!/bin/bash
set -e 
set -x 

echo "Applying migrations..."
python manage.py migrate --noinput

echo "Starting Gunicorn..."
exec gunicorn solution_site.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level debug \
    --access-logfile - \
    --error-logfile -