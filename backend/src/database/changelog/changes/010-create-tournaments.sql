--liquibase formatted sql

--changeset sport-platform:010-create-tournaments
--comment: Create tournaments table with bracket support (JSONB), geospatial location and organizer reference
CREATE TABLE tournaments (
    id                    UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    title                 VARCHAR(255)  NOT NULL,
    description           TEXT,
    sport                 VARCHAR(100)  NOT NULL,
    format                VARCHAR(50)   NOT NULL,
    level                 VARCHAR(50),
    organizer_id          UUID          NOT NULL REFERENCES users(id),
    club_id               UUID          REFERENCES clubs(id) ON DELETE SET NULL,
    location              GEOGRAPHY(Point, 4326),
    address               VARCHAR(500),
    city                  VARCHAR(255),
    start_date            TIMESTAMPTZ   NOT NULL,
    end_date              TIMESTAMPTZ   NOT NULL,
    registration_deadline TIMESTAMPTZ,
    max_teams             INTEGER,
    team_size             INTEGER,
    prize                 VARCHAR(500),
    entry_fee             DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    bracket               JSONB         NOT NULL DEFAULT '{}',
    status                VARCHAR(50)   NOT NULL DEFAULT 'registration',
    created_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_tournaments_format
        CHECK (format IN ('single_elimination', 'round_robin', 'group_stage')),
    CONSTRAINT chk_tournaments_status
        CHECK (status IN ('registration', 'ongoing', 'completed', 'cancelled')),
    CONSTRAINT chk_tournaments_level
        CHECK (level IS NULL OR level IN ('beginner', 'intermediate', 'advanced', 'pro')),
    CONSTRAINT chk_tournaments_dates CHECK (end_date > start_date),
    CONSTRAINT chk_tournaments_entry_fee CHECK (entry_fee >= 0),
    CONSTRAINT chk_tournaments_max_teams CHECK (max_teams IS NULL OR max_teams > 0),
    CONSTRAINT chk_tournaments_team_size CHECK (team_size IS NULL OR team_size > 0)
);
--rollback DROP TABLE IF EXISTS tournaments;
