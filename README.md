# IT-Solution-task
Проект веб-приложения для отображения цитат из книг и фильмов с возможностью голосования и статистикой просмотров.

## 🚀 Основные функции

- 📜 Просмотр случайных цитат
- 👍👎 Система лайков/дизлайков
- 📊 Статистика просмотров
- 🖼️ Автоматическая генерация иллюстраций к цитатам
- 📱 Адаптивный дизайн

## 🛠 Технологический стек

- **Backend**: Django 4.2
- **Frontend**: HTML5, CSS3, JavaScript
- **База данных**: SQLite (для разработки)
- **Дополнительно**:
  - Pillow для работы с изображениями
  - BeautifulSoup для парсинга изображений
    
## Скрины
![Image alt](https://github.com/Egor4444ik/IT-Solution-task/blob/images/Снимок%20экрана%202025-07-12%20в%2020.53.50.png)
![Image alt](https://github.com/Egor4444ik/IT-Solution-task/blob/images/Снимок%20экрана%202025-07-12%20в%2020.54.13.png)
![Image alt](https://github.com/Egor4444ik/IT-Solution-task/blob/images/Снимок%20экрана%202025-07-12%20в%2020.54.36.png)

## ⚙️ Установка и запуск

1. Клонируйте репозиторий:
```bash
git clone https://github.com/Egor4444ik/IT-Solution-task
cd random-quotes
```
2. Создайте и активируйте виртуальное окружение:
```bash
python -m venv venv
source venv/bin/activate  # Linux/MacOS
venv\Scripts\activate     # Windows
```
3. Установите зависимости:
```bash
pip install -r requirements.txt
```
**Суперпользователь**
  - login: admin
  - password: admin

4.1 Далее либо докер через
4.1.1 Запускаете контейнер
```bash
docker-compose up --build
```
4.1.2 Открываете новый терминал, в нём смотрите запущенные контейнеры
```bash
docker ps
```
4.1.3 Смотрите CONTAINER ID
```bash
docker exec -it <ТУТ CONTAINER ID, НАПРИМЕР: 0b661db20d32> bash
```
4.1.4 Дальше у вас консоль имеет такой вид:
```console
root@0b661db20d32:/app/solution_site#
```
4.1.5 Проводите миграции и создаёте суперпользователя, который сможет выписывать цитаты в админ панель:
```bash
python manage.py migrate
python manage.py createsuperuser
```
4.2 Либо:
```bash
python manage.py runserver
```
5. Откройте в браузере:
```text
http://localhost:8000/random_quotes
```
