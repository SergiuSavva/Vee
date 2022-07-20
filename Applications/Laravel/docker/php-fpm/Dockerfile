FROM php:8.1-fpm-alpine3.16


ENV AWS_DEFAULT_REGION=eu-west-1


RUN apk --no-cache add \
  git \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev


RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions zip imagick mysqli mbstring pdo pdo_mysql tokenizer xml ctype json bcmath pcntl opcache redis

RUN mkdir -p /var/www/html/

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#
## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2

ADD ./laravel.ini /usr/local/etc/php/conf.d

WORKDIR /var/www/html

# ADD application .

# RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html/

EXPOSE 9000

CMD ["php-fpm"]