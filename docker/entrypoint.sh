#!/usr/bin/env bash

set -e

php artisan package:discover
chown www-data:www-data bootstrap/cache
chown -R www-data:www-data storage/

echo 'migrate'
# php artisan migrate

echo 'cache'
php artisan config:cache
php artisan view:cache
php artisan route:cache
php artisan event:cache

php-fpm -F -R
