#!/bin/sh

nohup mysqld --skip-networking &
until echo 'create database invoice;' | mysql --protocol=socket -uroot -hlocalhost; do sleep 1; done;
