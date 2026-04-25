# Пошаговая инструкция по запуску Sport Platform

## Содержание

1. [Предварительные требования](#1-предварительные-требования)
2. [Клонирование репозитория](#2-клонирование-репозитория)
3. [Настройка переменных окружения](#3-настройка-переменных-окружения)
4. [Запуск инфраструктуры (Docker Compose)](#4-запуск-инфраструктуры-docker-compose)
5. [Запуск Backend (NestJS)](#5-запуск-backend-nestjs)
6. [Запуск Frontend Web (Next.js)](#6-запуск-frontend-web-nextjs)
7. [Запуск мобильного приложения (Expo)](#7-запуск-мобильного-приложения-expo)
8. [Полный запуск через Docker Compose](#8-полный-запуск-через-docker-compose)
9. [Проверка работоспособности](#9-проверка-работоспособности)
10. [Решение типичных проблем](#10-решение-типичных-проблем)

---

## 1. Предварительные требования

Убедитесь, что на вашей машине установлено следующее программное обеспечение:

| Инструмент | Минимальная версия | Команда проверки |
|---|---|---|
| Node.js | 20+ | `node -v` |
| npm | 10+ | `npm -v` |
| Git | 2.x | `git --version` |
| Docker | 24+ | `docker -v` |
| Docker Compose | 2.x | `docker compose version` |

> **Для мобильной разработки дополнительно требуется:**
> - Android Studio (для Android-эмулятора) или Xcode (для iOS-симулятора, только macOS)
> - Приложение Expo Go на физическом устройстве (Android / iOS)
> - Команды Expo запускаются через `npx expo` — глобальная установка не требуется

---

## 2. Клонирование репозитория

```bash
git clone https://github.com/Jas0w/sport-platform.git
cd sport-platform
```

---

## 3. Настройка переменных окружения

### 3.1 Backend

Создайте файл `backend/.env` на основе шаблона:

```bash
cp backend/.env.example backend/.env
```

Если файл `.env.example` отсутствует, создайте `backend/.env` вручную со следующим содержимым и заполните пустые значения:

```env
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:3000

# PostgreSQL
DATABASE_URL=postgresql://user:password@localhost:5432/sport_platform

# Redis
REDIS_URL=redis://localhost:6379

# Typesense
TYPESENSE_HOST=localhost
TYPESENSE_PORT=8108
TYPESENSE_API_KEY=your_api_key

# JWT
JWT_ACCESS_SECRET=change_me_access_secret
JWT_REFRESH_SECRET=change_me_refresh_secret

# OAuth (Google)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# OAuth (VK)
VK_CLIENT_ID=
VK_CLIENT_SECRET=

# S3 / Yandex Object Storage
S3_ENDPOINT=https://storage.yandexcloud.net
S3_BUCKET=sport-platform-media
S3_ACCESS_KEY=
S3_SECRET_KEY=
S3_REGION=ru-central1

# Firebase (Push Notifications)
FIREBASE_PROJECT_ID=
FIREBASE_PRIVATE_KEY=
FIREBASE_CLIENT_EMAIL=

# YooKassa (Payments)
YOOKASSA_SHOP_ID=
YOOKASSA_SECRET_KEY=

# Yandex Maps
YANDEX_MAPS_API_KEY=

# SendPulse (Email / SMS)
SENDPULSE_API_ID=
SENDPULSE_API_SECRET=
```

> **Обязательно для локального запуска:** `DATABASE_URL`, `REDIS_URL`, `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`.  
> Остальные переменные (OAuth, S3, Firebase и т.д.) нужны только при использовании соответствующих функций.

### 3.2 Frontend Web

Создайте файл `apps/web/.env.local`:

```bash
cp apps/web/.env.example apps/web/.env.local
```

Или создайте вручную:

```env
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_WS_URL=http://localhost:3001
NEXT_PUBLIC_YANDEX_MAPS_API_KEY=

# NextAuth
NEXTAUTH_SECRET=change_me_nextauth_secret
NEXTAUTH_URL=http://localhost:3000

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
```

### 3.3 Мобильное приложение

Создайте файл `apps/mobile/.env`:

```env
EXPO_PUBLIC_API_URL=http://localhost:3001
EXPO_PUBLIC_WS_URL=http://localhost:3001
```

> При тестировании на физическом устройстве замените `localhost` на IP-адрес вашего компьютера в локальной сети, например `http://192.168.1.100:3001`.

---

## 4. Запуск инфраструктуры (Docker Compose)

Запустите только сервисы баз данных и вспомогательных сервисов (без приложений):

```bash
docker compose up -d postgres redis typesense
```

Дождитесь запуска (обычно 10–20 секунд) и проверьте статус:

```bash
docker compose ps
```

Все три сервиса должны иметь статус `running` (или `healthy`).

**Что запускается:**

| Сервис | Технология | Порт |
|---|---|---|
| postgres | PostgreSQL 15 + PostGIS | 5432 |
| redis | Redis 7 | 6379 |
| typesense | Typesense 0.25 | 8108 |

---

## 5. Запуск Backend (NestJS)

### 5.1 Установка зависимостей

```bash
cd backend
npm install
```

### 5.2 Применение миграций базы данных

```bash
npx prisma migrate dev
```

> При первом запуске Prisma создаст все таблицы в PostgreSQL, включая расширение PostGIS.

### 5.3 (Опционально) Заполнение базы тестовыми данными

```bash
npx prisma db seed
```

### 5.4 Запуск в режиме разработки

```bash
npm run start:dev
```

Backend будет доступен по адресу: **http://localhost:3001**

Swagger-документация API (если настроена): **http://localhost:3001/api**

---

## 6. Запуск Frontend Web (Next.js)

Откройте новый терминал:

```bash
cd apps/web
npm install
npm run dev
```

Веб-приложение будет доступно по адресу: **http://localhost:3000**

---

## 7. Запуск мобильного приложения (Expo)

Откройте новый терминал:

```bash
cd apps/mobile
npm install
npx expo start
```

После запуска в терминале появится QR-код. Выберите способ запуска:

- **Физическое устройство**: отсканируйте QR-код приложением Expo Go
- **Android-эмулятор**: нажмите `a` в терминале (требуется запущенный Android Studio AVD)
- **iOS-симулятор (только macOS)**: нажмите `i` в терминале (требуется Xcode)

---

## 8. Полный запуск через Docker Compose

Если вы хотите запустить **всё приложение целиком** через Docker без ручной установки зависимостей:

```bash
docker compose up --build
```

Это запустит:
- PostgreSQL + Redis + Typesense
- Backend (NestJS) — **http://localhost:3001**
- Frontend Web (Next.js) — **http://localhost:3000**

> Убедитесь, что файлы `backend/.env` и `apps/web/.env.local` существуют перед запуском, так как Docker Compose читает их через `env_file`.

Для остановки всех сервисов:

```bash
docker compose down
```

Для полного сброса (включая данные в БД):

```bash
docker compose down -v
```

---

## 9. Проверка работоспособности

После запуска проверьте доступность сервисов:

```bash
# Backend healthcheck
curl http://localhost:3001/health

# Typesense healthcheck
curl http://localhost:8108/health

# PostgreSQL
docker compose exec postgres pg_isready -U user -d sport_platform

# Redis
docker compose exec redis redis-cli ping
```

Ожидаемые ответы:
- Backend: `{"status":"ok"}` (или `200 OK`)
- Typesense: `{"ok":true}`
- PostgreSQL: `sport_platform:5432 - accepting connections`
- Redis: `PONG`

---

## 10. Решение типичных проблем

### `Error: connect ECONNREFUSED 127.0.0.1:5432`
PostgreSQL не запущен. Убедитесь, что выполнили:
```bash
docker compose up -d postgres
```

### `Error: connect ECONNREFUSED 127.0.0.1:6379`
Redis не запущен. Запустите:
```bash
docker compose up -d redis
```

### `PrismaClientInitializationError: Can't reach database server`
Проверьте значение `DATABASE_URL` в `backend/.env`. Оно должно совпадать с настройками в `docker-compose.yml`:
```
DATABASE_URL=postgresql://user:password@localhost:5432/sport_platform
```

### `Error: Migration failed`
Убедитесь, что PostgreSQL запущен и доступен, затем попробуйте сбросить и повторить миграции:
```bash
npx prisma migrate reset
```

### `Port 3000 is already in use`
Завершите процесс, занимающий порт:
```bash
# Linux / macOS
lsof -ti:3000 | xargs kill -9

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### Проблемы с OAuth (Google / VK)
- Проверьте, что `GOOGLE_CLIENT_ID` и `GOOGLE_CLIENT_SECRET` корректно заполнены в `.env`.
- В настройках Google OAuth добавьте `http://localhost:3001/auth/oauth/google/callback` в список разрешённых redirect URI.

### Expo: приложение не подключается к backend
При использовании физического устройства замените `localhost` на IP-адрес вашего ПК:
```bash
# Узнать IP-адрес
# Linux / macOS:
ip addr show | grep "inet "
# Windows:
ipconfig
```
Затем обновите `apps/mobile/.env`:
```env
EXPO_PUBLIC_API_URL=http://192.168.x.x:3001
```
