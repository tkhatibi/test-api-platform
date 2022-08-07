#!/bin/bash

description() {
    echo "Alias for `docker-compose up`";
}

run() {
    $APP dc up --detach ${@:1}
}
