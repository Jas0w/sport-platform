--liquibase formatted sql

--changeset sport-platform:008-create-teams
--comment: Create teams table for sports teams with captain and recruiting status
CREATE TABLE teams (
    id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name         VARCHAR(255) NOT NULL,
    sport        VARCHAR(100) NOT NULL,
    city         VARCHAR(255),
    level        VARCHAR(50),
    captain_id   UUID         NOT NULL REFERENCES users(id),
    max_size     INTEGER,
    is_recruiting BOOLEAN     NOT NULL DEFAULT TRUE,
    description  TEXT,
    avatar       VARCHAR(500),
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_teams_level
        CHECK (level IS NULL OR level IN ('beginner', 'intermediate', 'advanced', 'pro')),
    CONSTRAINT chk_teams_max_size CHECK (max_size IS NULL OR max_size > 0)
);
--rollback DROP TABLE IF EXISTS teams;
