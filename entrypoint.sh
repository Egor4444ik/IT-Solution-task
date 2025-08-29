#!/bin/bash

# Применяем миграции
python manage.py migrate --noinput

# Собираем статические файлы (на всякий случай)
python manage.py collectstatic --noinput

# Запускаем Gunicorn
exec gunicorn solution_site.wsgi:application --bind 0.0.0.0:8000 --workers 3 --log-level debug --access-logfile - --error-logfile -