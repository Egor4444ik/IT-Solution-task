#!/bin/sh
echo "Installing required packages..."
apt-get update
apt-get install -y procps net-tools curl

cd /app/solution_site/

echo "Applying database migrations..."
python manage.py migrate --noinput

echo "Creating superuser if needed..."
if [ -n "admin" ] && [ -n "admin@gmail.com" ] && [ -n "securepassword123" ]; then
    python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@gmail.com', 'securepassword123')
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
#exec uwsgi --http 0.0.0.0:8000 --module solution_site.wsgi:application --master --processes 4 --threads 2
#exec uwsgi --socket :8000 --module solution_site.wsgi:application --master --processes 4 --threads 2 --buffer-size 32768
exec uwsgi --ini uwsgi.ini --buffer-size 32768