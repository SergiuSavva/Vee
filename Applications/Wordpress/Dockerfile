FROM docker.io/bitnami/wordpress-nginx:6

RUN rm -fr /bitnami/wordpress/*
COPY ./src/ /bitnami/wordpress/

WORKDIR /bitnami/wordpress/