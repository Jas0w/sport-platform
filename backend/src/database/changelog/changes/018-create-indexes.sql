--liquibase formatted sql

--changeset sport-platform:018-create-indexes
--comment: Create performance indexes including GIST spatial indexes for PostGIS columns

-- users
CREATE INDEX idx_users_city         ON users(city);
CREATE INDEX idx_users_role         ON users(role);
CREATE INDEX idx_users_rating       ON users(rating DESC);
CREATE INDEX idx_users_last_active  ON users(last_active_at DESC NULLS LAST);
CREATE INDEX idx_users_location     ON users USING GIST(location);

-- user_sports
CREATE INDEX idx_user_sports_user_id ON user_sports(user_id);
CREATE INDEX idx_user_sports_sport   ON user_sports(sport);

-- user_availability
CREATE INDEX idx_user_availability_user_id ON user_availability(user_id);

-- clubs
CREATE INDEX idx_clubs_owner_id  ON clubs(owner_id);
CREATE INDEX idx_clubs_city      ON clubs(city);
CREATE INDEX idx_clubs_rating    ON clubs(rating DESC);
CREATE INDEX idx_clubs_location  ON clubs USING GIST(location);

-- events
CREATE INDEX idx_events_organizer_id ON events(organizer_id);
CREATE INDEX idx_events_club_id      ON events(club_id);
CREATE INDEX idx_events_sport        ON events(sport);
CREATE INDEX idx_events_status       ON events(status);
CREATE INDEX idx_events_date         ON events(date);
CREATE INDEX idx_events_city         ON events(city);
CREATE INDEX idx_events_location     ON events USING GIST(location);

-- event_participants
CREATE INDEX idx_event_participants_user_id  ON event_participants(user_id);
CREATE INDEX idx_event_participants_status   ON event_participants(status);

-- teams
CREATE INDEX idx_teams_captain_id    ON teams(captain_id);
CREATE INDEX idx_teams_sport         ON teams(sport);
CREATE INDEX idx_teams_city          ON teams(city);
CREATE INDEX idx_teams_is_recruiting ON teams(is_recruiting);

-- team_members
CREATE INDEX idx_team_members_user_id ON team_members(user_id);
CREATE INDEX idx_team_members_status  ON team_members(status);

-- tournaments
CREATE INDEX idx_tournaments_organizer_id ON tournaments(organizer_id);
CREATE INDEX idx_tournaments_club_id      ON tournaments(club_id);
CREATE INDEX idx_tournaments_sport        ON tournaments(sport);
CREATE INDEX idx_tournaments_status       ON tournaments(status);
CREATE INDEX idx_tournaments_start_date   ON tournaments(start_date);
CREATE INDEX idx_tournaments_city         ON tournaments(city);
CREATE INDEX idx_tournaments_location     ON tournaments USING GIST(location);

-- tournament_teams
CREATE INDEX idx_tournament_teams_team_id ON tournament_teams(team_id);

-- conversations
CREATE INDEX idx_conversations_event_id ON conversations(event_id);
CREATE INDEX idx_conversations_team_id  ON conversations(team_id);
CREATE INDEX idx_conversations_type     ON conversations(type);

-- conversation_participants
CREATE INDEX idx_conversation_participants_user_id ON conversation_participants(user_id);

-- messages
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id       ON messages(sender_id);
CREATE INDEX idx_messages_created_at      ON messages(created_at DESC);

-- reviews
CREATE INDEX idx_reviews_from_user_id ON reviews(from_user_id);
CREATE INDEX idx_reviews_to_user_id   ON reviews(to_user_id);
CREATE INDEX idx_reviews_to_club_id   ON reviews(to_club_id);
CREATE INDEX idx_reviews_event_id     ON reviews(event_id);

-- notifications
CREATE INDEX idx_notifications_user_id    ON notifications(user_id);
CREATE INDEX idx_notifications_read_at    ON notifications(read_at) WHERE read_at IS NULL;
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- refresh_tokens
CREATE INDEX idx_refresh_tokens_user_id    ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);

--rollback
--rollback DROP INDEX IF EXISTS idx_users_city;
--rollback DROP INDEX IF EXISTS idx_users_role;
--rollback DROP INDEX IF EXISTS idx_users_rating;
--rollback DROP INDEX IF EXISTS idx_users_last_active;
--rollback DROP INDEX IF EXISTS idx_users_location;
--rollback DROP INDEX IF EXISTS idx_user_sports_user_id;
--rollback DROP INDEX IF EXISTS idx_user_sports_sport;
--rollback DROP INDEX IF EXISTS idx_user_availability_user_id;
--rollback DROP INDEX IF EXISTS idx_clubs_owner_id;
--rollback DROP INDEX IF EXISTS idx_clubs_city;
--rollback DROP INDEX IF EXISTS idx_clubs_rating;
--rollback DROP INDEX IF EXISTS idx_clubs_location;
--rollback DROP INDEX IF EXISTS idx_events_organizer_id;
--rollback DROP INDEX IF EXISTS idx_events_club_id;
--rollback DROP INDEX IF EXISTS idx_events_sport;
--rollback DROP INDEX IF EXISTS idx_events_status;
--rollback DROP INDEX IF EXISTS idx_events_date;
--rollback DROP INDEX IF EXISTS idx_events_city;
--rollback DROP INDEX IF EXISTS idx_events_location;
--rollback DROP INDEX IF EXISTS idx_event_participants_user_id;
--rollback DROP INDEX IF EXISTS idx_event_participants_status;
--rollback DROP INDEX IF EXISTS idx_teams_captain_id;
--rollback DROP INDEX IF EXISTS idx_teams_sport;
--rollback DROP INDEX IF EXISTS idx_teams_city;
--rollback DROP INDEX IF EXISTS idx_teams_is_recruiting;
--rollback DROP INDEX IF EXISTS idx_team_members_user_id;
--rollback DROP INDEX IF EXISTS idx_team_members_status;
--rollback DROP INDEX IF EXISTS idx_tournaments_organizer_id;
--rollback DROP INDEX IF EXISTS idx_tournaments_club_id;
--rollback DROP INDEX IF EXISTS idx_tournaments_sport;
--rollback DROP INDEX IF EXISTS idx_tournaments_status;
--rollback DROP INDEX IF EXISTS idx_tournaments_start_date;
--rollback DROP INDEX IF EXISTS idx_tournaments_city;
--rollback DROP INDEX IF EXISTS idx_tournaments_location;
--rollback DROP INDEX IF EXISTS idx_tournament_teams_team_id;
--rollback DROP INDEX IF EXISTS idx_conversations_event_id;
--rollback DROP INDEX IF EXISTS idx_conversations_team_id;
--rollback DROP INDEX IF EXISTS idx_conversations_type;
--rollback DROP INDEX IF EXISTS idx_conversation_participants_user_id;
--rollback DROP INDEX IF EXISTS idx_messages_conversation_id;
--rollback DROP INDEX IF EXISTS idx_messages_sender_id;
--rollback DROP INDEX IF EXISTS idx_messages_created_at;
--rollback DROP INDEX IF EXISTS idx_reviews_from_user_id;
--rollback DROP INDEX IF EXISTS idx_reviews_to_user_id;
--rollback DROP INDEX IF EXISTS idx_reviews_to_club_id;
--rollback DROP INDEX IF EXISTS idx_reviews_event_id;
--rollback DROP INDEX IF EXISTS idx_notifications_user_id;
--rollback DROP INDEX IF EXISTS idx_notifications_read_at;
--rollback DROP INDEX IF EXISTS idx_notifications_created_at;
--rollback DROP INDEX IF EXISTS idx_refresh_tokens_user_id;
--rollback DROP INDEX IF EXISTS idx_refresh_tokens_expires_at;
