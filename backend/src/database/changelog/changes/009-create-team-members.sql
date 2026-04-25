--liquibase formatted sql

--changeset sport-platform:009-create-team-members
--comment: Create team_members join table linking users to teams with role and status
CREATE TABLE team_members (
    team_id   UUID        NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    user_id   UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role      VARCHAR(50) NOT NULL DEFAULT 'member',
    status    VARCHAR(50) NOT NULL DEFAULT 'active',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (team_id, user_id),
    CONSTRAINT chk_team_members_role   CHECK (role   IN ('captain', 'member')),
    CONSTRAINT chk_team_members_status CHECK (status IN ('pending', 'active', 'rejected'))
);
--rollback DROP TABLE IF EXISTS team_members;
