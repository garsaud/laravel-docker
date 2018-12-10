FROM jguyomard/laravel-php

RUN apk add --no-cache \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libxml2-dev \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd \
    && docker-php-ext-install soap \
    && docker-php-ext-install exif \
    && docker-php-ext-install fileinfo \
    && docker-php-ext-install bcmath \
    && apk del --no-cache \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev

ENTRYPOINT php artisan serve --host="0.0.0.0"
