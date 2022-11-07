# Build arguments
ARG IMAGE_REGISTRY=xlaporedis
ARG IMAGE_TAG=latest

# Image
FROM ${IMAGE_REGISTRY}/aplikasi-base:${IMAGE_TAG}

# Copy directory project permission ke container
COPY --chown=www-data:www-data . /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000
CMD ["php-fpm"]