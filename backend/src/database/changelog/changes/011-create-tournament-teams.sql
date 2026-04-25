--liquibase formatted sql

--changeset sport-platform:011-create-tournament-teams
--comment: Create tournament_teams join table linking teams to tournaments
CREATE TABLE tournament_teams (
    tournament_id UUID        NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    team_id       UUID        NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (tournament_id, team_id)
);
--rollback DROP TABLE IF EXISTS tournament_teams;
