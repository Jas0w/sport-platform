--liquibase formatted sql

--changeset sport-platform:006-create-events
--comment: Create events table for open games, trainings and friendly matches with geospatial location
CREATE TABLE events (
    id               UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    type             VARCHAR(50)   NOT NULL,
    title            VARCHAR(255)  NOT NULL,
    description      TEXT,
    sport            VARCHAR(100)  NOT NULL,
    levels           JSONB         NOT NULL DEFAULT '[]',
    organizer_id     UUID          NOT NULL REFERENCES users(id),
    club_id          UUID          REFERENCES clubs(id) ON DELETE SET NULL,
    location         GEOGRAPHY(Point, 4326),
    address          VARCHAR(500),
    city             VARCHAR(255),
    date             TIMESTAMPTZ   NOT NULL,
    duration         INTEGER,
    max_participants INTEGER,
    price            DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    currency         VARCHAR(10)   NOT NULL DEFAULT 'RUB',
    status           VARCHAR(50)   NOT NULL DEFAULT 'open',
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_events_type
        CHECK (type IN ('open_game', 'tournament', 'training', 'friendly')),
    CONSTRAINT chk_events_status
        CHECK (status IN ('open', 'full', 'cancelled', 'completed')),
    CONSTRAINT chk_events_currency
        CHECK (currency IN ('RUB', 'USD')),
    CONSTRAINT chk_events_price CHECK (price >= 0),
    CONSTRAINT chk_events_duration CHECK (duration IS NULL OR duration > 0),
    CONSTRAINT chk_events_max_participants CHECK (max_participants IS NULL OR max_participants > 0)
);
--rollback DROP TABLE IF EXISTS events;
