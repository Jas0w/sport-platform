--liquibase formatted sql

--changeset sport-platform:005-create-clubs
--comment: Create clubs table with geospatial location, JSONB for sports, facilities, contacts and working hours
CREATE TABLE clubs (
    id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id      UUID          NOT NULL REFERENCES users(id),
    name          VARCHAR(255)  NOT NULL,
    description   TEXT,
    logo          VARCHAR(500),
    photos        JSONB         NOT NULL DEFAULT '[]',
    address       VARCHAR(500),
    city          VARCHAR(255),
    location      GEOGRAPHY(Point, 4326),
    sports        JSONB         NOT NULL DEFAULT '[]',
    facilities    JSONB         NOT NULL DEFAULT '[]',
    contacts      JSONB         NOT NULL DEFAULT '{}',
    working_hours JSONB         NOT NULL DEFAULT '{}',
    rating        DECIMAL(3, 2) NOT NULL DEFAULT 0.00,
    review_count  INTEGER       NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_clubs_rating CHECK (rating >= 0.00 AND rating <= 5.00)
);
--rollback DROP TABLE IF EXISTS clubs;
