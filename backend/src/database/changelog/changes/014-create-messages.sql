--liquibase formatted sql

--changeset sport-platform:014-create-messages
--comment: Create messages table for chat messages with optional file attachments (JSONB array)
CREATE TABLE messages (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID        NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id       UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    text            TEXT,
    attachments     JSONB       NOT NULL DEFAULT '[]',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_messages_content CHECK (text IS NOT NULL OR jsonb_array_length(attachments) > 0)
);
--rollback DROP TABLE IF EXISTS messages;
