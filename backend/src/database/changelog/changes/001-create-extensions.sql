--liquibase formatted sql

--changeset sport-platform:001-create-extensions
--comment: Enable PostGIS extension for geospatial support
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
--rollback DROP EXTENSION IF EXISTS postgis; DROP EXTENSION IF EXISTS pgcrypto;
