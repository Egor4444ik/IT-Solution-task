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
login: admin
password: admin
4. Запустите сервер:
```bash
python manage.py runserver
```
5. Откройте в браузере:
```text
http://localhost:8000/random_quotes
```