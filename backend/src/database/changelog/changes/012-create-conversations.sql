--liquibase formatted sql

--changeset sport-platform:012-create-conversations
--comment: Create conversations table for direct messages and group chats tied to events or teams
CREATE TABLE conversations (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    type       VARCHAR(20) NOT NULL DEFAULT 'direct',
    event_id   UUID        REFERENCES events(id) ON DELETE SET NULL,
    team_id    UUID        REFERENCES teams(id)  ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_conversations_type
        CHECK (type IN ('direct', 'event', 'team'))
);
--rollback DROP TABLE IF EXISTS conversations;
