--liquibase formatted sql

--changeset sport-platform:013-create-conversation-participants
--comment: Create conversation_participants join table tracking users in a conversation and last read position
CREATE TABLE conversation_participants (
    conversation_id UUID        NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    user_id         UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    last_read_at    TIMESTAMPTZ,
    PRIMARY KEY (conversation_id, user_id)
);
--rollback DROP TABLE IF EXISTS conversation_participants;
