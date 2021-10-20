# 首先 composer 处理
FROM composer AS composer
COPY database/ /app/database/
COPY composer.json composer.lock /app/
RUN cd /app \
    && composer install \
        --optimize-autoloader \
        --ignore-platform-reqs \
        --prefer-dist \
        --no-interaction \
        --no-plugins \
        --no-scripts \
        --no-dev

RUN ["touch", "index.php"]
CMD ["tail", "-f", "index.php"]

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

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 项目处理
ARG LARAVEL_PATH=/var/www/laravel
WORKDIR ${LARAVEL_PATH}
COPY . ${LARAVEL_PATH}
COPY --from=composer /app/vendor/ ${LARAVEL_PATH}/vendor/
COPY --from=composer /app/composer.json ${LARAVEL_PATH}/composer.json
COPY --from=composer /app/composer.lock ${LARAVEL_PATH}/composer.lock
# RUN cd ${LARAVEL_PATH} \
#     && php artisan package:discover \
#     && chown www-data:www-data bootstrap/cache \
#     && chown -R www-data:www-data storage/

# COPY docker/entrypoint.sh /usr/local/bin/entrypoint
# RUN chmod +x /usr/local/bin/entrypoint
# ENTRYPOINT ["/usr/local/bin/entrypoint"]

# 最后启动 php-fpm 
CMD ["php-fpm", "-F", "-R"]