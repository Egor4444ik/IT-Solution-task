#!/bin/bash

# Ждем, пока сервер не станет доступен (до 60 секунд)
for i in $(seq 1 60); do
  curl -sSL -f http://localhost:8000/admin/ > /dev/null
  if [ $? -eq 0 ]; then
    echo "Сервер доступен!"
    break
  else
    echo "Сервер еще не готов. Попытка $i/60..."
    sleep 1
  fi
done

# Проверяем, что сервер стал доступен
if [ $? -eq 0 ]; then
  echo "Выполняем проверку curl..."
  curl -v http://localhost:8000/admin/
else
  echo "Сервер не стал доступен после 60 секунд. Проверка не выполнена."
  exit 1  # Выходим с кодом ошибки
fi

exit 0  # Выходим с кодом успеха