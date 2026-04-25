--liquibase formatted sql

--changeset sport-platform:004-create-user-availability
--comment: Create user_availability table to store weekly schedule availability
CREATE TABLE user_availability (
    id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id   UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    day       VARCHAR(10)  NOT NULL,
    time_slot VARCHAR(20)  NOT NULL,
    CONSTRAINT chk_user_availability_day
        CHECK (day IN ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun')),
    CONSTRAINT chk_user_availability_time_slot
        CHECK (time_slot IN ('morning', 'afternoon', 'evening', 'night')),
    CONSTRAINT uq_user_availability UNIQUE (user_id, day, time_slot)
);
--rollback DROP TABLE IF EXISTS user_availability;
