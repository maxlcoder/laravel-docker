# 首先 composer 处理
FROM composer AS composer
COPY composer.json composer.lock /app/
RUN cd /app && composer install --no-scripts

# PHP
FROM php:8.0-fpm

# 安装扩展系统扩展
RUN apt-get update && apt-get install -y \
    vim \
    imagemagick \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev

# 配置 php 扩展
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
# 安装 php 扩展
RUN docker-php-ext-install -j$(nproc) gd pdo_mysql
# 启动 php 扩展
RUN docker-php-ext-enable gd pdo_mysql

# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 项目处理
ARG LARAVEL_PATH=/app
WORKDIR ${LARAVEL_PATH}
COPY . ${LARAVEL_PATH}
COPY --from=composer /app/vendor/ ${LARAVEL_PATH}/vendor/
COPY --from=composer /app/composer.json ${LARAVEL_PATH}/composer.json
COPY --from=composer /app/composer.lock ${LARAVEL_PATH}/composer.lock
