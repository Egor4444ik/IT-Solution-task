#!/bin/bash
set -e 

MANAGE_PY_PATH="/app/solution_site/solution_site/manage.py"

if [ ! -f "$MANAGE_PY_PATH" ]; then
    echo "ERROR: manage.py not found at $MANAGE_PY_PATH"
    echo "Current directory: $(pwd)"
    echo "Directory content:"
    ls -la /app/solution_site/
    echo "Looking for manage.py:"
    find /app -name "manage.py" -type f 
    exit 1
fi

echo "Applying migrations..."
python "$MANAGE_PY_PATH" migrate --noinput

echo "Starting Gunicorn..."

exec gunicorn solution_site.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level debug \
    --access-logfile - \
    --error-logfile -