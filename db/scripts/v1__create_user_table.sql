--liquibase formatted sql

--changeset username:1 labels:add-table context:add-users-table
CREATE TABLE users  (
  id int(4) NOT NULL AUTO_INCREMENT,
  username varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  email varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (id)
);
--rollback DROP TABLE users;