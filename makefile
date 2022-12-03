SHELL := bash
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJECT_NAME:=cfml_application_template

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

help:
	@echo Development:
	@echo -------------------------------------------------------------------------------
	@echo + dev-build 			- Builds and starts the application in development mode.
	@echo + dev-up 				- Starts the application in development mode.
	@echo + dev-down 			- Removes the applications and all its volumes.
	@echo + dev-stop 			- Does stop the application.
	@echo + dev-db-update		- Updates the database with the newest sql scripts.
	@echo + dev-db-rollback		- Does a rollback to the provided tag.
	@echo + dev-db-tag			- Sets a tag for the current state of the database.
	@echo + dev-scss-compile	- Compiles the scss file to css.
	@echo -------------------------------------------------------------------------------
	@echo
	@echo Production:
	@echo -------------------------------------------------------------------------------
	@echo + prod-build 			- Builds and starts the application in production mode.
	@echo + prod-up 			- Starts the application in production mode.
	@echo + prod-down 			- Removes the applications and all its volumes.
	@echo + prod-stop 			- Does stop the application.
	@echo + prod-db-update		- Updates the database with the newest sql scripts.
	@echo + prod-db-rollback	- Does a rollback to the provided tag.
	@echo + prod-db-tag			- Sets a tag for the current state of the database.
	@echo + prod-scss-compile	- Compiles the scss file to a minified css.	
	@echo -------------------------------------------------------------------------------

.DEFAULT_GOAL := help

.PHONY: dev-build dev-up dev-down dev-stop dev-db-reinit dev-db-update dev-db-rollback dev-db-tag 
.PHONY:	prod-build prod-up prod-down prod-stop prod-db-reinit prod-db-update prod-db-rollback prod-db-tag 

# Development 
dev-build:
	@cd .
	@echo [-] Building application...
	@make dev-scss-compile
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
	@sleep 10
	@clear
	@make dev-db-update
	@clear
	@echo [+] Application got successfully build and started!
	@echo 	
	@echo ------------------------------------------------------
	@echo URL:		http://localhost:3000/
	@echo Mailslurper:	http://localhost:9000
	@echo Lucee Admin:	http://localhost:3000/lucee/admin/server.cfm
	@echo ------------------------------------------------------
	@echo

dev-up:
	@cd .
	@echo [-] Starting application...
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d 
	@sleep 10
	@clear
	@make dev-db-update
	@clear
	@echo [+] Application got successfully started!
	@echo 	
	@echo ------------------------------------------------------
	@echo URL:		http://localhost:3000/
	@echo Mailslurper:	http://localhost:9000
	@echo Lucee Admin:	http://localhost:3000/lucee/admin/server.cfm
	@echo ------------------------------------------------------
	@echo

dev-down:
	@cd .
	@echo [-] Removing application...
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v
	@echo [+] Application got successfully removed!

dev-stop:
	@cd .
	@echo [-] Stopping the application...
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.dev.yml stop
	@echo [+] Application got successfully stopped!

dev-db-reinit:
	@cd .
	@echo [-] Reinit database...
	@echo [-] Drop database...
	@docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://mysql:3306/database?user=user&password=defaultpass" \
	--changelog-file=changelog.xml drop-all
	@echo [+] Drop database successfully!
	@make dev-db-update
	@clear
	@echo [+] Reinit successfully!

dev-db-update:
	@cd .
	@echo [-] Updating database...
	@docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://mysql:3306/database?user=user&password=defaultpass" \
	--changelog-file=changelog.xml update
	@echo [+] Update successfully!
	@clear

dev-db-rollback:
	@cd .
	@echo "Please enter tag you want rollback to:"; \
    read ROLLBACK_TAG; \
	echo "Rollback to tag: " $$ROLLBACK_TAG; \
	docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://mysql:3306/database?user=user&password=defaultpass" \
	--changelog-file=changelog.xml rollback $$ROLLBACK_TAG

dev-db-tag:
	@cd .
	@echo "Please enter the tag you want to create:"; \
    read VERSION; \
	echo "Creating tag: " $$VERSION; \
	docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://mysql:3306/database?user=user&password=defaultpass" \
	--changelog-file=changelog.xml tag $$VERSION
	@echo [+] Tag successfully created!

dev-scss-compile:
	@cd .
	sass app/assets/scss/main.scss app/assets/css/main.css
	@echo "scss compiled!";

# Production 
prod-build:
	@cd .
	@echo [-] Building application...
	@make prod-scss-compile
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
	@sleep 10
	@clear
	@make prod-db-update
	@clear
	@echo [+] Application got successfully build and started!

prod-up:
	@cd .
	@echo [-] Starting application...
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	@sleep 10	
	@clear
	@make prod-db-update
	@clear
	@echo [+] Application got successfully started!

prod-down:
	@cd .
	@echo [-] Removing application...
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.prod.yml down -v
	@echo [+] Application got successfully removed!

prod-stop:
	@cd .
	@echo [-] Stopping the application...
	@COMPOSE_PROJECT_NAME=$(PROJECT_NAME) docker-compose -f docker-compose.yml -f docker-compose.dev.yml stop
	@echo [+] Application got successfully stopped!

prod-db-reinit:
	@cd .
	@echo [-] Reinit database...
	@echo [-] Drop database...
	@docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DATABASE}?user=${MYSQL_USER}&password=${MYSQL_PASSWORD}" \
	--changelog-file=changelog.xml drop-all
	@echo [+] Drop database successfully!
	@make dev-db-update
	@clear
	@echo [+] Reinit successfully!

prod-db-update:
	@cd .
	@echo [-] Updating database...
	@docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DATABASE}?user=${MYSQL_USER}&password=${MYSQL_PASSWORD}" \
	--changelog-file=changelog.xml update
	@echo [+] Update successfully!
	@clear

prod-db-rollback:
	@cd .
	@echo "Please enter tag you want rollback to:"; \
    read ROLLBACK_TAG; \
	echo "Rollback to tag: " $$ROLLBACK_TAG; \
	docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DATABASE}?user=${MYSQL_USER}&password=${MYSQL_PASSWORD}" \
	--changelog-file=changelog.xml rollback $$ROLLBACK_TAG

prod-db-tag:
	@cd .
	@echo "Please enter the tag you want to create:"; \
    read VERSION; \
	echo "Creating tag: " $$VERSION; \
	docker run --rm --network=$(PROJECT_NAME)_backend \
	-v $(ROOT_DIR)/config/liquibase/changelog.xml:/liquibase/changelog.xml \
	-v $(ROOT_DIR)/db/scripts:/liquibase/scripts \
	-v $(ROOT_DIR)/config/liquibase/driver/:/liquibase/lib liquibase/liquibase \
	--url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DATABASE}?user=${MYSQL_USER}&password=${MYSQL_PASSWORD}" \
	--changelog-file=changelog.xml tag $$VERSION
	@echo [+] Tag successfully created!

prod-scss-compile:
	@cd .
	sass app/assets/scss/main.scss app/assets/css/main.css --style compressed --no-source-map
	@echo "scss compiled!";