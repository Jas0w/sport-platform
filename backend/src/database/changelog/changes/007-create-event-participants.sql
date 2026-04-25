--liquibase formatted sql

--changeset sport-platform:007-create-event-participants
--comment: Create event_participants join table linking users to events
CREATE TABLE event_participants (
    event_id  UUID        NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id   UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status    VARCHAR(50) NOT NULL DEFAULT 'confirmed',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (event_id, user_id),
    CONSTRAINT chk_event_participants_status
        CHECK (status IN ('pending', 'confirmed', 'cancelled'))
);
--rollback DROP TABLE IF EXISTS event_participants;
