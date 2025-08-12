FROM php:8.4.11-fpm-alpine3.21

RUN apk add -U --no-cache \
        nginx \
        ca-certificates \
        bash \
        sed \
        curl \
        tar \
        git \
        openssl \
        openssh \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libzip-dev \
        unzip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install gd
RUN docker-php-ext-install bcmath ftp mysqli pdo_mysql zip

ENV TERM="xterm" \
    PAGER="more" \
    DB_HOST="mysql" \
    DB_NAME="" \
    DB_USER=""\
    DB_PASS="" \
    PATH="/DATA/bin:$PATH"

COPY files/nginx.conf /etc/nginx/
COPY files/php-fpm.conf /usr/local/etc/
COPY files/php.ini /usr/local/etc/php/
COPY files/run.sh /
RUN chmod +x /run.sh

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp-cli && chown www-data:www-data /usr/bin/wp-cli

EXPOSE 80

VOLUME ["/DATA"]

WORKDIR /DATA

CMD ["/run.sh"]
