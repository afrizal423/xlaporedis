# Build arguments
ARG IMAGE_REGISTRY=xlaporedis
ARG IMAGE_TAG=latest

# Image
FROM ${IMAGE_REGISTRY}/app-base:${IMAGE_TAG}

# Set up the working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \    
    cron \
    supervisor

RUN chown -R www-data:www-data /var/log/supervisor

# Tambahkan konfigurasi supervisor
COPY ./docker/spv/supervisor/ /etc/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
