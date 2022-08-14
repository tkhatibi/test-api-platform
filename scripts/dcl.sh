#!/bin/bash

description() {
    echo "Alias for `docker-compose logs`";
}

run() {
    $APP dc logs --follow --tail 100 ${@:1}
}
