#!/usr/bin/env bash

set -e

cd /var/www/laravel
rm -f public/storage

echo 'migrate'
# php artisan migrate

echo 'cache'
php artisan config:cache
php artisan view:cache
php artisan route:cache
php artisan event:cache

php-fpm -F -R
