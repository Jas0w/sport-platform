--liquibase formatted sql

--changeset sport-platform:016-create-notifications
--comment: Create notifications table for in-app push notifications with JSONB payload
CREATE TABLE notifications (
    id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type       VARCHAR(100) NOT NULL,
    title      VARCHAR(255) NOT NULL,
    body       TEXT,
    data       JSONB        NOT NULL DEFAULT '{}',
    read_at    TIMESTAMPTZ,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
--rollback DROP TABLE IF EXISTS notifications;
