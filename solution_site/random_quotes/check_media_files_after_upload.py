import os
import subprocess
import sys
from pathlib import Path

def check_media_files():
    """Проверяет существование медиафайлов в контейнере"""
    
    # Путь к проекту (может потребовать корректировки)
    project_dir = Path(__file__).parent
    
    try:
        # Выполняем команду в контейнере
        result = subprocess.run([
            'docker-compose', 'exec', '-T', 'web', 
            'ls', '-la', '/app/solution_site/media/quotes/'
        ], capture_output=True, text=True, cwd=project_dir, timeout=30)
        
        print("=== Результат проверки файлов в контейнере ===")
        print(f"Код возврата: {result.returncode}")
        
        if result.stdout:
            print("Содержимое папки /app/solution_site/media/quotes/:")
            print(result.stdout)
        
        if result.stderr:
            print("Ошибки:")
            print(result.stderr)
            
        # Дополнительная проверка локальной папки
        local_media_path = project_dir / 'media' / 'quotes'
        print(f"\n=== Локальная папка media/quotes/ ===")
        if local_media_path.exists():
            print("Содержимое локальной папки:")
            for file in local_media_path.iterdir():
                print(f"  {file.name} ({file.stat().st_size} bytes)")
        else:
            print("Локальная папка media/quotes/ не существует!")
            
    except subprocess.TimeoutExpired:
        print("Таймаут выполнения команды")
    except FileNotFoundError:
        print("Ошибка: docker-compose не найден")
    except Exception as e:
        print(f"Ошибка при выполнении команды: {e}")

def check_docker_status():
    """Проверяет статус Docker контейнеров"""
    try:
        print("=== Статус Docker контейнеров ===")
        result = subprocess.run(['docker-compose', 'ps'], 
                              capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print(result.stderr)
    except Exception as e:
        print(f"Ошибка при проверке статуса: {e}")

if __name__ == "__main__":
    check_docker_status()
    print("\n" + "="*50 + "\n")
    check_media_files()