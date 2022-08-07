#!/bin/bash

description() {
    echo "Loads fixtures and executes unit and functional tests";
}

help() {
    echo "Available Options:"

    echo "  -l"
    echo "  Purges database and loads fixtures before testing"
    echo
}

run() {
    if [[ " ${@:1} " =~ " -l " ]]; then
        $APP sf hautelook:fixtures:load --no-interaction --purge-with-truncate
    fi
    $APP dcx php bin/phpunit ${@:1}
}
