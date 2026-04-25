--liquibase formatted sql

--changeset sport-platform:003-create-user-sports
--comment: Create user_sports table to store sports and skill levels per user
CREATE TABLE user_sports (
    id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id  UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sport    VARCHAR(100) NOT NULL,
    level    VARCHAR(50)  NOT NULL,
    position VARCHAR(100),
    CONSTRAINT chk_user_sports_level CHECK (level IN ('beginner', 'intermediate', 'advanced', 'pro')),
    CONSTRAINT uq_user_sports UNIQUE (user_id, sport)
);
--rollback DROP TABLE IF EXISTS user_sports;
