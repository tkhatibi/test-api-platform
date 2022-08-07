#!/bin/bash

description() {
    echo "Alias for `docker-compose exec`";
}

run() {
    $APP dc exec ${@:1}
}
