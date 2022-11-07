# Define default values for variables
COMPOSE_FILE = docker-compose.yml
BASE_IMAGE_DOCKERFILE = ./docker/base/Dockerfile
IMAGE_REGISTRY ?= xlaporedis
NAME_CONTAINER_APP = appnya 
IMAGE_TAG ?= latest

#-----------------------------------------------------------
# Management
#-----------------------------------------------------------
# Build and restart containers
install: build.all up

# Start containers
up:
	docker-compose -f ${COMPOSE_FILE} up -d

up.debug:
	docker-compose -f ${COMPOSE_FILE} up

# start containers
start:
	docker-compose -f ${COMPOSE_FILE} start 

# Stop containers
stop:
	docker-compose -f ${COMPOSE_FILE} stop 

# Stop and delete containers
down:
	docker-compose -f ${COMPOSE_FILE} down --remove-orphans

# Build containers
build:
	docker-compose -f ${COMPOSE_FILE} build

# Build all containers
build.all: build.base build

# Build the base app image
build.base:
	docker build --file ${BASE_IMAGE_DOCKERFILE} --tag ${IMAGE_REGISTRY}/aplikasi-base:${IMAGE_TAG} .

# Show list of running containers
ps:
	docker-compose -f ${COMPOSE_FILE} ps

# Restart containers
restart:
	docker-compose -f ${COMPOSE_FILE} restart

# Reboot containers
reboot: down up

# View output from containers
logs:
	docker-compose -f ${COMPOSE_FILE} logs --tail 500

# Follow output from containers (short of 'follow logs')
fl:
	docker-compose -f ${COMPOSE_FILE} logs --tail 500 -f

# Prune stopped docker containers and dangling images
prune:
	docker system prune

#-----------------------------------------------------------
# Application
#-----------------------------------------------------------

# Enter the app container
app.bash:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} /bin/bash

redis.cli:
	docker-compose -f ${COMPOSE_FILE} exec redis redis-cli

# Restart the app container
restart.app:
	docker-compose -f ${COMPOSE_FILE} restart app

# Alias to restart the app container
ra: restart.app

# Run the tinker service
tinker:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan tinker

# Clear the app cache
cache.clear:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan cache:clear

# Migrate the database
db.migrate:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan migrate

# Alias to migrate the database
migrate: db.migrate

# Rollback the database
db.rollback:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan migrate:rollback

# Seed the database
db.seed:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan db:seed

# Fresh the database state
db.fresh:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan migrate:fresh

# Refresh the database
db.refresh: db.fresh db.seed

# Dump database into file (only for development environment) (TODO: replace file name with env variable)
db.dump:
	docker-compose -f ${COMPOSE_FILE} exec postgres pg_dump -U ${DB_USERNAME} -d ${DB_DATABASE} > ./.docker/postgres/dumps/dump.sql

# TODO: add command to import db dump

# Restart the queue process
queue.restart:
	docker-compose -f ${COMPOSE_FILE} exec queue php artisan queue:restart

# Install composer dependencies
composer.install:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} composer install

# Install composer dependencies from stopped containers
r.composer.install:
	docker-compose -f ${COMPOSE_FILE} run --rm --no-deps app composer install

# Alias to install composer dependencies
ci: composer.install

# Update composer dependencies
composer.update:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} composer update

# Update composer dependencies from stopped containers
r.composer.update:
	docker-compose -f ${COMPOSE_FILE} run --rm --no-deps app composer update

# Alias to update composer dependencies
cu: composer.update

# Show outdated composer dependencies
composer.outdated:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} composer outdated

# PHP composer autoload command
composer.autoload:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} composer dump-autoload

# Generate a symlink to the storage directory
storage.link:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan storage:link --relative

# Give permissions of the storage folder to the www-data
storage.perm:
	sudo chmod -R 755 storage
	sudo chown -R www-data:www-data storage

lognya:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} chown -R $USER:www-data storage \
																				chown -R $USER:www-data bootstrap/cache \
																				chmod -R 775 storage \
																				chmod -R 775 bootstrap/cache

# Give permissions of the storage folder to the current user
storage.perm.me:
	sudo chmod -R 755 storage
	sudo chown -R "$(shell id -u):$(shell id -g)" storage

# Give files ownership to the current user
own.me:
	sudo chown -R "$(shell id -u):$(shell id -g)" .

# Reload the Octane workers
octane.reload:
	docker-compose -f ${COMPOSE_FILE} exec ${NAME_CONTAINER_APP} php artisan octane:reload

# Alias to reload the Octane workers
or: octane.reload
