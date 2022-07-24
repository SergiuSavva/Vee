FROM nginx:1.16.0-alpine

ADD nginx.conf /etc/nginx/
ADD sites/default.conf /etc/nginx/sites-available/


# ARG ENVIRON -- this will be used if we are hosting on k8s
# ARG PHP_UPSTREAM_CONTAINER=vus-php-fpm-${ENVIRON}
ARG PHP_UPSTREAM_CONTAINER=lrvl-php-fpm
ARG PHP_UPSTREAM_PORT=9000

RUN adduser -S www-data -G www-data

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
&& rm /etc/nginx/conf.d/default.conf

# Will be used in k8s deployment
# ADD application /var/www/html

CMD ["nginx"]

EXPOSE 80