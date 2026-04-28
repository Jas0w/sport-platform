--liquibase formatted sql

--changeset sport-platform:015-create-reviews
--comment: Create reviews table for user-to-user and user-to-club ratings (1-5 stars)
CREATE TABLE reviews (
    id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    from_user_id UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    to_user_id   UUID        REFERENCES users(id) ON DELETE CASCADE,
    to_club_id   UUID        REFERENCES clubs(id) ON DELETE CASCADE,
    event_id     UUID        REFERENCES events(id) ON DELETE SET NULL,
    rating       SMALLINT    NOT NULL,
    text         TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_reviews_rating CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT chk_reviews_target CHECK (to_user_id IS NOT NULL OR to_club_id IS NOT NULL),
    CONSTRAINT chk_reviews_no_self_review CHECK (from_user_id <> to_user_id)
);
--rollback DROP TABLE IF EXISTS reviews;
