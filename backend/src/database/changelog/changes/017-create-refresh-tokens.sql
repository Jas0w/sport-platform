--liquibase formatted sql

--changeset sport-platform:017-create-refresh-tokens
--comment: Create refresh_tokens table for JWT refresh token rotation
CREATE TABLE refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  VARCHAR(255) NOT NULL UNIQUE,
    expires_at  TIMESTAMPTZ  NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_refresh_tokens_expires_at CHECK (expires_at > created_at)
);
--rollback DROP TABLE IF EXISTS refresh_tokens;
