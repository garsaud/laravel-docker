FROM alpine:3.8

LABEL maintainer="cyril.garsaud@gmail.com"

ENV COMPOSER_ALLOW_SUPERUSER=1

ADD https://repos.php.earth/alpine/phpearth.rsa.pub \
    /etc/apk/keys/phpearth.rsa.pub

RUN echo "https://repos.php.earth/alpine/v3.8" \
        >> /etc/apk/repositories \
    && apk add --no-cache \
        php7.3 \
        php7.3-apache2 \
        php7.3-bcmath \
        php7.3-bz2 \
        php7.3-calendar \
        php7.3-ctype \
        php7.3-curl \
        php7.3-dom \
        php7.3-exif \
        php7.3-fileinfo \
        php7.3-ftp \
        php7.3-gd \
        php7.3-iconv \
        php7.3-imagick \
        php7.3-json \
        php7.3-mbstring \
        php7.3-opcache \
        php7.3-openssl \
        php7.3-pdo \
        php7.3-pdo_mysql \
        php7.3-pdo_sqlite \
        php7.3-phar \
        php7.3-posix \
        php7.3-session \
        php7.3-shmop \
        php7.3-simplexml \
        php7.3-sqlite3 \
        php7.3-sockets \
        php7.3-sysvmsg \
        php7.3-sysvsem \
        php7.3-sysvshm \
        php7.3-tokenizer \
        php7.3-xml \
        php7.3-xmlreader \
        php7.3-xmlwriter \
        php7.3-zip \
        php7.3-zlib \
        openssl \
        curl \
        ca-certificates \
        npm \
        apache2 \
        rsync \
    && curl -s https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin/ \
        --filename=composer \
    && mkdir -p /run/apache2 /var/www/localhost/public \
    && sed -i 's,/var/www/localhost/htdocs,/var/www/localhost/public,g' \
        /etc/apache2/httpd.conf

WORKDIR /var/www/localhost

ENTRYPOINT httpd -D FOREGROUND
