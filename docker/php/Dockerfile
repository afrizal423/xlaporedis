FROM php:8.1.0-fpm

# Update dependencies
RUN apt-get update \
# Install Zip
    && apt-get install -y libzip-dev zip unzip \
    && docker-php-ext-install zip \
# Install Git
    && apt-get install -y git \
# Install Curl
    && apt-get install -y libcurl3-dev curl \
    && docker-php-ext-install curl \
# Install procps (required by Octane)
    && apt-get install -y procps \
# Install EXIF
    && docker-php-ext-install exif \
# Install GD
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ \
    && docker-php-ext-install gd \
# Install Node (v16 LTS) (required by Octane)
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
# Install NPM (required by Octane)
     && npm install -g npm \
# Install PostgreSQL
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
# Install BC Math
    && docker-php-ext-install bcmath \
# Install internationalization functions
    && apt-get install -y zlib1g-dev libicu-dev g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
# Install Redis extension
    && pecl install redis \
    && docker-php-ext-enable redis \
# Install Process Control extension
    && docker-php-ext-install pcntl \
    && docker-php-ext-enable pcntl \
# Install OPcache extension
    && docker-php-ext-install opcache \
# Install Swoole (required by Octane)
    && pecl install swoole \
    && docker-php-ext-enable swoole \
# install libre
    && apt-get install -y --no-install-recommends libreoffice-writer \
# Clean up the apt cache
    && rm -rf /var/lib/apt/lists/*

# Copy PHP configuration
COPY ./docker/php/php.ini "/${PHP_INI_DIR}/php.ini"
COPY ./docker/php/conf.d "/${PHP_INI_DIR}/conf.d"

# Install Composer
COPY --from=composer:2.3.10 /usr/bin/composer /usr/local/bin/composer

# Copy project ke dalam container
COPY ./aplikasi  /var/www/html

# Copy directory project permission ke container
COPY --chown=www-data:www-data ./aplikasi /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Install composer dependencies
RUN composer install

RUN npm install

RUN npm run build
