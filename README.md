<div align="center">

<img width="1009" height="485" alt="GoatSec" src="https://github.com/user-attachments/assets/d8f2c198-a6db-4c06-b39a-7d432e4edf4b" />

# GoatsPass

**Локальный менеджер паролей с шифрованием AES-256-GCM**

![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-blue)
![Python](https://img.shields.io/badge/python-3.9%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Encryption](https://img.shields.io/badge/encryption-AES--256--GCM-red)

</div>

---

## Возможности

- AES-256-GCM шифрование всей базы паролей
- Argon2id для хеширования мастер-пароля (fallback на PBKDF2, 600k итераций)
- Автоочистка буфера обмена через 30 секунд
- TOTP / 2FA поддержка
- Генератор паролей и парольных фраз
- Анализ надёжности паролей с подсчётом энтропии
- Категории, теги, избранное и закреплённые записи
- Поиск по всем полям
- Автоблокировка через 5 минут бездействия
- Все данные хранятся только локально
- Работает на Windows и Linux

---

## Быстрый старт

### Linux

```bash
git clone https://github.com/necouncil/GoatsPass
cd GoatsPass
chmod +x install.sh
./install.sh
```

Или запустить напрямую — зависимости установятся автоматически:

```bash
python3 goatspass.py
```

### Windows

**Вариант 1 — Готовый EXE** (Python не нужен):

Скачать `GoatsPass.exe` из раздела [Releases](../../releases) и запустить.

> При первом запуске Windows Defender может показать предупреждение о неизвестном издателе — это стандартное поведение для неподписанных приложений. Исходный код открыт, можно проверить самостоятельно.

**Вариант 2 — Установщик:**

```
Запустить install.bat от имени пользователя
```

**Вариант 3 — Напрямую** (нужен Python 3.9+):

```cmd
python goatspass.py
```

---

## Первый запуск

При первом запуске приложение автоматически устанавливает зависимости (`cryptography`, `argon2-cffi`, `Pillow`). В зависимости от скорости соединения и мощности машины это занимает от 30 секунд до нескольких минут — окно может не реагировать, это нормально. После установки приложение запустится само, повторно открывать его не нужно.

---

## Зависимости

Устанавливаются автоматически при первом запуске:

| Пакет | Назначение |
|-------|-----------|
| `cryptography` | AES-256-GCM шифрование |
| `argon2-cffi` | Хеширование мастер-пароля |
| `Pillow` | Отображение иконки |

Или вручную:

```bash
pip install -r requirements.txt
```

---

## Сборка EXE (Windows)

```cmd
python build_exe.py
```

Готовый `GoatsPass.exe` появится в папке `dist/`. Требует Python и PyInstaller (установится автоматически).

---

## Безопасность

- База данных хранится локально: `~/.local/share/GoatsPass/vault.gp` (Linux) / `%APPDATA%\GoatsPass\vault.gp` (Windows)
- Мастер-пароль никогда не сохраняется на диск
- При 5 неверных попытках ввода — блокировка
- Буфер обмена очищается автоматически через 30 секунд

---

## Структура проекта

```
GoatsPass/
├── goatspass.py      # Основное приложение
├── icon.png          # Иконка приложения
├── requirements.txt  # Python зависимости
├── install.sh        # Установщик Linux
├── install.bat       # Установщик Windows
├── build_exe.py      # Сборка .exe для Windows
└── README.md
```

---

## Скриншоты

<img width="665" height="664" alt="image" src="https://github.com/user-attachments/assets/f2d4b340-86e8-4083-b69f-f03b158baa70" />

<img width="495" height="680" alt="213" src="https://github.com/user-attachments/assets/5d2f991f-b7ef-49db-b416-ceb1e4638fa6" />

<img width="1911" height="339" alt="imag12231e" src="https://github.com/user-attachments/assets/35145716-e65d-4062-8303-a42491506cc7" />

---

## Лицензия

MIT License — используй как хочешь, на свой страх и риск.
