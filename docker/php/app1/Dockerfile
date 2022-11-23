# Build arguments
ARG IMAGE_REGISTRY=xlaporedis
ARG IMAGE_TAG=latest

# Image
FROM ${IMAGE_REGISTRY}/app-base:${IMAGE_TAG}

# Set up the working directory
WORKDIR /var/www/html

CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=9000", "--workers=2"]

EXPOSE 9000
