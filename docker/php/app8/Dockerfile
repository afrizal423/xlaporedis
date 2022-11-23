# Build arguments
ARG IMAGE_REGISTRY=xlaporedis
ARG IMAGE_TAG=latest

# Image
FROM ${IMAGE_REGISTRY}/app-base:${IMAGE_TAG}

# Install composer dependencies
RUN composer install

# Dump composer autoload
RUN composer dump-autoload --optimize

# Set up the working directory
WORKDIR /var/www/html

CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=9008", "--workers=2"]

EXPOSE 9008
