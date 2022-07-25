# Update Laravel database schema
composer install --no-dev --optimize-autoloader
php artisan migrate
php artisan optimize:clear
