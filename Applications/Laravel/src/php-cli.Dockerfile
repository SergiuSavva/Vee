FROM php:8.1-cli-alpine3.16

ARG ENVIRONMENT=production

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

#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# If you need to modify this image, feel free to do it right here.
#
## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2

#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#
WORKDIR /var/www/html

# Below commented code will be used in K8s deployment
ADD ./ /var/www/html

RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html/

CMD ["/usr/local/bin/php", "/var/www/html/artisan", "horizon" ,"-v"]
