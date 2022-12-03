# CFML Application Template
Template for a modern CFML application with a containerized environment for development and production.
The goal of this template is to help others containerize their CFML applications, both locally and in production.
This template does by no means always represents the state of the art or the best possible solution, but I hope someone can benefit from it.

## Used technologies
- CommandBox - Running the CFML engine Lucee with URL rewrites enabled
- MySQL 5.7 - Database 
- Liquibase - Tool to manage database
- Nginx - Web server
- Mailslurper - SMTP Mail server for local development

## Prerequisites
- Docker and Docker-Compose ([Docker Desktop](https://www.docker.com/products/docker-desktop/))
- [make](https://www.gnu.org/software/make/)
- [sass](https://github.com/sass/sass)

## Getting started
1. Download the MySQL connector needed for Liquibase from [here](https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-8.0.31.zip), unpack the zip and place the `mysql-connector-j-8.0.31.jar` file under this path: `/config/driver/*.jar`.
2. Run `make dev-build` to create a local development environment.
3. Access the application: http://localhost:3000

### Commands

Development:
+ dev-build - Builds and starts the application in development mode.
+ dev-up - Starts the application in development mode.
+ dev-down - Removes the applications and all its volumes.
+ dev-stop - Does stop the application.
+ dev-db-update - Updates the database with the newest sql scripts.
+ dev-db-rollback - Does a rollback to the provided tag.
+ dev-db-tag - Sets a tag for the current state of the database.   
+ dev-scss-compile - Compiles the scss file to css.

Production:
+ prod-build - Builds and starts the application in production mode.
+ prod-up - Starts the application in production mode.
+ prod-down - Removes the applications and all its volumes.
+ prod-stop - Does stop the application.
+ prod-db-update - Updates the database with the newest sql scripts.
+ prod-db-rollback - Does a rollback to the provided tag.
+ prod-db-tag - Sets a tag for the current state of the database.
+ prod-scss-compile - Compiles the scss file to a minified css.