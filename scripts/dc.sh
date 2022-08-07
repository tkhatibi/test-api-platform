#!/bin/bash

description() {
    echo "Alias for `docker-compose`";
}

run() {
    docker-compose --project-name $PROJECT_NAME --file $DOCKER_COMPOSE --file $DOCKER_COMPOSE_OVERRIDE ${@:1}
}
