# Laravel Docker

A fast and light web server, configured for Laravel.

## Simple setup

Example of a possible `docker-compose.yml` file, located at the root of your Laravel project:

``` yml
version: '2'

services:
    laravel:
        image: garsaud/laravel
        volumes:
            - ./:/var/www/localhost
        environment:
            - DB_HOST=mysql
            - DB_DATABASE=laravel
            - DB_USERNAME=laravel
            - DB_PASSWORD=laravel
        ports:
            - "8088:80"
        entrypoint: httpd -D FOREGROUND
        container_name: laravel
    mysql:
        image: mariadb
        volumes:
            - ./storage/framework/mysql:/var/lib/mysql
        environment:
            - MYSQL_DATABASE=laravel
            - MYSQL_USER=laravel
            - MYSQL_PASSWORD=laravel
            - MYSQL_ROOT_PASSWORD=laravel
    phpmyadmin:
        image: phpmyadmin/phpmyadmin
        ports:
            - "8089:80"
        links:
            - mysql
        environment:
            - PMA_HOST=mysql
            - PMA_USER=root
            - PMA_PASSWORD=laravel
```

Run it with `docker-compose up -d`, then navigate to:

- web server: http://localhost:8088
- phpmyadmin: http://localhost:8089

On the first run, you will need to run migrations inside the docker container:

```sh
docker exec -it laravel sh
php artisan migrate
```

## Running multiple websites

You will need a reverse proxy to capture and dispatch your requests among the multiple servers.

Here is a possible configuration:

``` yml
version: '2'

services:
    firstwebsite:
        image: garsaud/laravel
        volumes:
            - ./firstwebsite:/var/www/localhost
        environment:
            - DB_HOST=mysql
            - DB_DATABASE=laravel
            - DB_USERNAME=laravel
            - DB_PASSWORD=laravel
        entrypoint: httpd -D FOREGROUND
    secondwebsite:
        image: garsaud/laravel
        volumes:
            - ./secondwebsite:/var/www/localhost
        environment:
            - DB_HOST=mysql
            - DB_DATABASE=laravel
            - DB_USERNAME=laravel
            - DB_PASSWORD=laravel
        entrypoint: httpd -D FOREGROUND
    nginx:
        image: nginx
        volumes:
            - ./nginx.conf:/etc/nginx/conf.d/default.conf
        ports:
            - "80:80"
        command: /bin/bash -c "exec nginx -g 'daemon off;'"
    mysql:
        image: mariadb
        volumes:
            - ./mysql:/var/lib/mysql
        environment:
            - MYSQL_DATABASE=laravel
            - MYSQL_USER=laravel
            - MYSQL_PASSWORD=laravel
            - MYSQL_ROOT_PASSWORD=laravel
    phpmyadmin:
        image: phpmyadmin/phpmyadmin
        ports:
            - "8089:80"
        links:
            - mysql
        environment:
            - PMA_HOST=mysql
            - PMA_USER=root
            - PMA_PASSWORD=laravel
```

…with a nginx.conf file configured this way:

``` nginx
server {
  listen 80;
  server_name firstwebsite;
  location / {
    proxy_pass http://firstwebsite;
  }
}

server {
  listen 80;
  server_name secondwebsite;
  location / {
    proxy_pass http://secondwebsite;
  }
}
```

Just edit your hosts file to point `firstwebsite` and `secondwebsite` to `127.0.0.1` and you’ll be able to reach your laravel instances with http://firstwebsite and http://secondwebsite
