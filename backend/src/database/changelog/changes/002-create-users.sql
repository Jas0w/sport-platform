--liquibase formatted sql

--changeset sport-platform:002-create-users
--comment: Create users table with role, profile data and geospatial location
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role            VARCHAR(20)     NOT NULL DEFAULT 'player',
    email           VARCHAR(255)    NOT NULL UNIQUE,
    password_hash   VARCHAR(255),
    name            VARCHAR(255)    NOT NULL,
    avatar          VARCHAR(500),
    city            VARCHAR(255),
    location        GEOGRAPHY(Point, 4326),
    bio             TEXT,
    rating          DECIMAL(3, 2)   NOT NULL DEFAULT 0.00,
    review_count    INTEGER         NOT NULL DEFAULT 0,
    verified        BOOLEAN         NOT NULL DEFAULT FALSE,
    last_active_at  TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_users_role CHECK (role IN ('player', 'coach', 'club', 'organizer', 'admin')),
    CONSTRAINT chk_users_rating CHECK (rating >= 0.00 AND rating <= 5.00)
);
--rollback DROP TABLE IF EXISTS users;
