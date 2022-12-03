--liquibase formatted sql

--changeset username:2 labels:create-record context:add-user-record
INSERT INTO users (username, email)
VALUES ('user1', 'user1@mail.dev');
--rollback DELETE FROM users WHERE username = 'user1';

--changeset username:3 labels:create-record context:add-user-record
INSERT INTO users (username, email)
VALUES ('user2', 'user2@mail.dev');
--rollback DELETE FROM users WHERE username = 'user2';

--changeset username:4 labels:create-record context:add-user-record
INSERT INTO users (username, email)
VALUES ('user3', 'user3@mail.dev');
--rollback DELETE FROM users WHERE username = 'user3';

--changeset username:5 labels:create-record context:add-user-record
INSERT INTO users (username, email)
VALUES ('user4', 'user4@mail.dev');
--rollback DELETE FROM users WHERE username = 'user4';