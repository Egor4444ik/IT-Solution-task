#!/bin/sh

cd /app/solution_site/

echo "Applying database migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Checking Django configuration..."
python manage.py check --deploy --fail-level WARNING

echo "Starting uWSGI server..."
exec uwsgi --http 0.0.0.0:8000 --module solution_site.wsgi:application --master --processes 4 --threads 2