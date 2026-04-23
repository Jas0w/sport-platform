# Sport Platform — Technical Specification for AI Agent

## Project Overview

**Name:** Платформа любительского спорта и поиска партнеров  
**Type:** Web + Mobile application (Freemium SaaS)  
**Delivery:** Online platform  
**Primary Market:** Major Russian cities (initial), international scaling later

---

## Goal

Build a digital platform that connects amateur sports enthusiasts — allowing them to find partners, teams, coaches, clubs, and join or organize events and tournaments.

---

## User Roles

| Role | Description |
|------|-------------|
| `player` | Amateur athlete looking for partners, teams, or events |
| `coach` | Professional or semi-professional coach looking for clients |
| `club` | Sports club or venue looking to fill schedules and attract participants |
| `organizer` | Event/tournament organizer (can be a player or club) |
| `admin` | Platform moderator and administrator |

---

## Core Entities

### User / Player Profile
```ts
{
  id: uuid,
  role: 'player' | 'coach' | 'club' | 'organizer',
  name: string,
  avatar: string (url),
  city: string,
  location: { lat: float, lng: float },
  sports: [
    {
      sport: string,           // e.g. "football", "tennis", "basketball"
      level: 'beginner' | 'intermediate' | 'advanced' | 'pro',
      position?: string,
    }
  ],
  availability: {
    days: string[],            // ["mon", "wed", "fri"]
    timeSlots: string[],       // ["morning", "evening"]
  },
  bio: string,
  rating: float,
  reviewCount: int,
  verified: boolean,
  createdAt: datetime,
}
```

### Club Profile
```ts
{
  id: uuid,
  name: string,
  description: string,
  logo: string (url),
  photos: string[],
  city: string,
  address: string,
  location: { lat: float, lng: float },
  sports: string[],
  facilities: string[],
  contacts: { phone?, email?, website?, telegram? },
  workingHours: object,
  rating: float,
  createdAt: datetime,
}
```

### Event / Game
```ts
{
  id: uuid,
  type: 'open_game' | 'tournament' | 'training' | 'friendly',
  title: string,
  description: string,
  sport: string,
  level: string[],
  city: string,
  location: { lat: float, lng: float },
  address: string,
  date: datetime,
  duration: int,               // minutes
  maxParticipants: int,
  currentParticipants: int,
  price: float,
  currency: 'RUB' | 'USD',
  organizer: User | Club,
  participants: User[],
  status: 'open' | 'full' | 'cancelled' | 'completed',
  createdAt: datetime,
}
```

### Tournament
```ts
{
  id: uuid,
  title: string,
  sport: string,
  format: 'single_elimination' | 'round_robin' | 'group_stage',
  level: string,
  city: string,
  location: { lat: float, lng: float },
  address: string,
  startDate: datetime,
  endDate: datetime,
  registrationDeadline: datetime,
  maxTeams: int,
  teamSize: int,
  prize?: string,
  entryFee: float,
  organizer: User | Club,
  teams: Team[],
  bracket: object,
  status: 'registration' | 'ongoing' | 'completed' | 'cancelled',
  createdAt: datetime,
}
```

### Team
```ts
{
  id: uuid,
  name: string,
  sport: string,
  city: string,
  level: string,
  captain: User,
  members: User[],
  maxSize: int,
  isRecruiting: boolean,
  description: string,
  createdAt: datetime,
}
```

### Message / Chat
```ts
{
  id: uuid,
  conversationId: uuid,
  senderId: uuid,
  text: string,
  attachments?: string[],
  readAt?: datetime,
  createdAt: datetime,
}
```

### Review / Rating
```ts
{
  id: uuid,
  fromUser: uuid,
  toUser: uuid,
  eventId?: uuid,
  rating: int,               // 1-5
  text?: string,
  createdAt: datetime,
}
```

---

## Tech Stack

### Frontend — Web
- **Framework:** Next.js 14+ (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS + shadcn/ui
- **State Management:** Zustand
- **Data Fetching:** TanStack Query (React Query)
- **Real-time:** Socket.io-client
- **Maps:** Yandex Maps JS API (fallback: Leaflet + OpenStreetMap)
- **Forms:** React Hook Form + Zod
- **Auth:** NextAuth.js

### Frontend — Mobile
- **Framework:** React Native (Expo SDK 51+)
- **Language:** TypeScript
- **Styling:** NativeWind
- **State Management:** Zustand
- **Data Fetching:** TanStack Query
- **Real-time:** Socket.io-client
- **Navigation:** Expo Router

### Backend
- **Runtime:** Node.js 20+
- **Framework:** NestJS (TypeScript)
- **API:** REST (primary) + WebSocket (Socket.io)
- **Auth:** JWT (access + refresh tokens) + Passport.js
- **OAuth:** Google, VK, Apple
- **ORM:** Prisma
- **File Upload:** Multer + S3

### Databases
- **Primary DB:** PostgreSQL 15+ with PostGIS extension
- **Cache / Sessions / Pub-Sub:** Redis 7+
- **Search Engine:** Typesense

### Infrastructure
- **Containerization:** Docker + Docker Compose (dev)
- **Cloud:** Yandex Cloud
- **Object Storage:** Yandex Object Storage (S3-compatible)
- **CI/CD:** GitHub Actions

### Third-party Services
| Service | Purpose |
|---------|---------|
| Yandex Maps API | Maps, geocoding, geo-search |
| Firebase Cloud Messaging | Push notifications |
| YooKassa | Payments (RU market) |
| SendPulse | Email / SMS notifications |

---

## Project Structure

```
/
├── apps/
│   ├── web/                  # Next.js web client
│   │   └── app/
│   │       ├── (auth)/
│   │       │   ├── login/
│   │       │   └── register/
│   │       └── (main)/
│   │           ├── dashboard/
│   │           ├── search/
│   │           ├── events/[id]/
│   │           ├── tournaments/[id]/
│   │           ├── teams/[id]/
│   │           ├── profile/[id]/
│   │           ├── clubs/[id]/
│   │           └── chat/[conversationId]/
│   │
│   └── mobile/               # React Native (Expo)
│       └── app/
│           ├── (auth)/
│           └── (tabs)/
│               ├── index.tsx
│               ├── search.tsx
│               ├── events.tsx
│               ├── chat.tsx
│               └── profile.tsx
│
├── packages/
│   ├── api-client/           # Shared typed API client
│   ├── types/                # Shared TypeScript interfaces & DTOs
│   └── utils/                # Shared utility functions
│
└── backend/
    └── src/
        ├── modules/
        │   ├── auth/
        │   ├── users/
        │   ├── clubs/
        │   ├── events/
        │   ├── tournaments/
        │   ├── teams/
        │   ├── search/
        │   ├── chat/
        │   ├── notifications/
        │   ├── reviews/
        │   └── payments/
        ├── common/
        │   ├── guards/
        │   ├── decorators/
        │   ├── filters/
        │   └── interceptors/
        ├── config/
        └── prisma/
```

---

## API Endpoints

### Auth
```
POST   /auth/register
POST   /auth/login
POST   /auth/refresh
POST   /auth/logout
GET    /auth/oauth/google
GET    /auth/oauth/vk
```

### Users
```
GET    /users/me
PATCH  /users/me
GET    /users/:id
GET    /users/:id/reviews
POST   /users/:id/reviews
GET    /users/:id/events
GET    /users/:id/teams
```

### Search
```
GET    /search/players?sport=&level=&city=&lat=&lng=&radius=&page=&limit=
GET    /search/clubs?sport=&city=&lat=&lng=&radius=&page=&limit=
GET    /search/events?sport=&level=&city=&lat=&lng=&date=&type=&page=&limit=
GET    /search/teams?sport=&level=&city=&isRecruiting=&page=&limit=
```

### Events
```
GET    /events
GET    /events/:id
POST   /events
PATCH  /events/:id
DELETE /events/:id
POST   /events/:id/join
DELETE /events/:id/leave
GET    /events/:id/participants
```

### Tournaments
```
GET    /tournaments
GET    /tournaments/:id
POST   /tournaments
PATCH  /tournaments/:id
DELETE /tournaments/:id
GET    /tournaments/:id/bracket
POST   /tournaments/:id/register
DELETE /tournaments/:id/unregister
PATCH  /tournaments/:id/bracket
```

### Teams
```
GET    /teams
GET    /teams/:id
POST   /teams
PATCH  /teams/:id
DELETE /teams/:id
POST   /teams/:id/invite/:userId
POST   /teams/:id/join
PATCH  /teams/:id/members/:userId
DELETE /teams/:id/members/:userId
```

### Clubs
```
GET    /clubs
GET    /clubs/:id
POST   /clubs
PATCH  /clubs/:id
DELETE /clubs/:id
GET    /clubs/:id/events
GET    /clubs/:id/reviews
POST   /clubs/:id/reviews
```

### Chat
```
GET    /chat/conversations
GET    /chat/conversations/:id/messages
POST   /chat/conversations
DELETE /chat/conversations/:id

# WebSocket events:
WS → message:send      { conversationId, text, attachments? }
WS ← message:new       { message }
WS ← message:read      { conversationId, userId }
WS ← user:online       { userId }
WS ← user:offline      { userId }
```

### Notifications
```
GET    /notifications
PATCH  /notifications/:id/read
PATCH  /notifications/read-all
POST   /notifications/push-token
```

### Payments
```
POST   /payments/checkout
GET    /payments/history
POST   /payments/webhook
```

---

## Key Feature Implementation Details

### 1. Geo Search
Use PostGIS `ST_DWithin` for radius-based queries, index spatial columns with `GIST`:

```sql
SELECT * FROM users
WHERE ST_DWithin(
  location::geography,
  ST_MakePoint(:lng, :lat)::geography,
  10000  -- meters
)
AND sport = :sport AND level = :level;
```

### 2. Real-time Chat
- Socket.io with **Redis Adapter** (`@socket.io/redis-adapter`) for horizontal scaling
- Conversation types: direct (1:1) and group (event/team)
- Read receipts + unread counter via Redis

### 3. Partner Search / Matchmaking
- Filter by: `sport`, `level`, `city`, `availability.days`, `availability.timeSlots`, radius
- Sort by: distance, rating, last active
- "Send request" → creates conversation + notification

### 4. Tournament Bracket
- Support: Single Elimination, Round Robin, Group Stage
- Bracket stored as JSONB in PostgreSQL
- Organizer updates scores → bracket auto-advances

### 5. Rating System
- Rate each other after shared confirmed events (1–5 stars)
- "Verified level" badge after 10+ consistent reviews

---

## Authentication & Authorization

- **JWT** — `accessToken` (15 min) + `refreshToken` (30 days, HttpOnly cookie)
- **OAuth 2.0** — Google, VK via Passport.js
- Role-based guards on all sensitive endpoints
- Resource ownership checks on all mutations

---

## Database Schema (Key Tables)

```sql
CREATE EXTENSION IF NOT EXISTS postgis;

users (id, role, email, password_hash, name, avatar, city, location GEOGRAPHY, bio, rating, verified, created_at)
user_sports (id, user_id, sport, level, position)
user_availability (id, user_id, day, time_slot)
clubs (id, owner_id, name, description, logo, address, location GEOGRAPHY, sports[], rating, created_at)
events (id, type, title, sport, level[], organizer_id, location GEOGRAPHY, address, date, duration, max_participants, price, status, created_at)
event_participants (event_id, user_id, status, joined_at)
tournaments (id, title, sport, format, organizer_id, location GEOGRAPHY, start_date, end_date, max_teams, bracket JSONB, status, created_at)
tournament_teams (tournament_id, team_id, registered_at)
teams (id, name, sport, city, level, captain_id, max_size, is_recruiting, created_at)
team_members (team_id, user_id, role, status, joined_at)
conversations (id, type, event_id, team_id, created_at)
conversation_participants (conversation_id, user_id, last_read_at)
messages (id, conversation_id, sender_id, text, attachments[], created_at)
reviews (id, from_user_id, to_user_id, to_club_id, event_id, rating, text, created_at)
notifications (id, user_id, type, title, body, data JSONB, read_at, created_at)
```

---

## Environment Variables

```env
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:3000

DATABASE_URL=postgresql://user:password@localhost:5432/sport_platform

REDIS_URL=redis://localhost:6379

TYPESENSE_HOST=localhost
TYPESENSE_PORT=8108
TYPESENSE_API_KEY=your_api_key

JWT_ACCESS_SECRET=your_access_secret
JWT_REFRESH_SECRET=your_refresh_secret

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
VK_CLIENT_ID=
VK_CLIENT_SECRET=

S3_ENDPOINT=https://storage.yandexcloud.net
S3_BUCKET=sport-platform-media
S3_ACCESS_KEY=
S3_SECRET_KEY=
S3_REGION=ru-central1

FIREBASE_PROJECT_ID=
FIREBASE_PRIVATE_KEY=
FIREBASE_CLIENT_EMAIL=

YOOKASSA_SHOP_ID=
YOOKASSA_SECRET_KEY=

YANDEX_MAPS_API_KEY=

SENDPULSE_API_ID=
SENDPULSE_API_SECRET=
```

---

## Docker Compose (Development)

```yaml
version: '3.9'
services:
  postgres:
    image: postgis/postgis:15-3.4
    environment:
      POSTGRES_DB: sport_platform
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  typesense:
    image: typesense/typesense:0.25.2
    ports:
      - "8108:8108"
    volumes:
      - tsdata:/data
    command: --data-dir /data --api-key=your_api_key --enable-cors

  backend:
    build: ./backend
    ports:
      - "3001:3001"
    depends_on: [postgres, redis, typesense]
    env_file: ./backend/.env

  web:
    build: ./apps/web
    ports:
      - "3000:3000"
    depends_on: [backend]
    env_file: ./apps/web/.env

volumes:
  pgdata:
  tsdata:
```

---

## MVP Scope (Phase 1 — Build This First)

- [ ] User registration & login (email + Google OAuth)
- [ ] Player profile (sports, level, city, availability)
- [ ] Club profile creation and editing
- [ ] Search players by sport, level, city with map view
- [ ] Search clubs by sport, city with map view
- [ ] Create and browse open events/games
- [ ] Join / leave event
- [ ] Create and browse teams, send join request
- [ ] Direct messaging (1:1 chat)
- [ ] Basic rating & review after shared event
- [ ] Push notifications (join request, new message, event reminder)
- [ ] Basic admin panel for content moderation

---

## Out of Scope for MVP (Phase 2+)

- Tournament bracket management
- In-app payments
- Group chats for events/teams
- Recommendation / ML-based matching engine
- PWA / offline mode
- International payment methods
- Analytics dashboard for clubs

---

## Unified API Response Format

Success:
```json
{
  "success": true,
  "data": {},
  "meta": { "page": 1, "total": 100 }
}
```

Error:
```json
{
  "success": false,
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with given ID does not exist"
  }
}
```

---

## Notes for AI Agent

1. Use **Prisma** as ORM — define all models in `schema.prisma` with PostGIS via `prisma-postgis`
2. All location-based queries MUST use PostGIS `ST_DWithin` with GIST spatial indexes
3. NestJS modules are **feature-based** — one module per domain entity
4. Implement **repository pattern** inside NestJS services
5. Use **Typesense** for all user-facing search — sync from PostgreSQL via service hooks on create/update/delete
6. WebSocket gateway uses **Redis Adapter** (`@socket.io/redis-adapter`) from day one
7. File uploads go to S3 — backend generates presigned URLs only
8. Implement **rate limiting** on all public endpoints (NestJS Throttler)
9. Implement **request logging** with correlation IDs
10. Web (`apps/web`) and Mobile (`apps/mobile`) share types and API client via `packages/` monorepo packages
11. TypeScript **strict mode** enabled everywhere
12. ESLint + Prettier + Husky pre-commit hooks configured
13. Unit tests for all service-layer methods (Jest, min 70% coverage)
14. Build MVP scope only — do not implement Phase 2+ features
