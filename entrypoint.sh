#!/bin/sh

cd /app/solution_site/

echo "Environment variables:"
echo "DEBUG: $DEBUG"
echo "ALLOWED_HOSTS: $ALLOWED_HOSTS"
echo "SUPERUSER_USERNAME: $DJANGO_SUPERUSER_USERNAME"
echo "SUPERUSER_EMAIL: $DJANGO_SUPERUSER_EMAIL"
echo "SUPERUSER_PASSWORD: $DJANGO_SUPERUSER_PASSWORD"

echo "Applying database migrations..."
python manage.py migrate --noinput

echo "Creating superuser if needed..."
if [ -n "admin" ] && [ -n "admin@gmail.com" ] && [ -n "securepassword123" ]; then
    python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='$DJANGO_SUPERUSER_USERNAME').exists():
    User.objects.create_superuser('$DJANGO_SUPERUSER_USERNAME', '$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD')
    print('Superuser created successfully.')
else:
    print('Superuser already exists.')
EOF
else
    echo "Superuser credentials not provided. Skipping superuser creation."
fi

echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "Checking Django configuration..."
python manage.py check --deploy --fail-level WARNING

echo "Starting uWSGI server..."
exec uwsgi --http 0.0.0.0:8000 --module solution_site.wsgi:application --master --processes 4 --threads 2