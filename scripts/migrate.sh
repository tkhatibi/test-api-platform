#!/bin/bash

description() {
    echo "Makes migration files and executes their commands";
}

help() {
    echo "Available Options:"

    echo "  -r"
    echo "  Removes database, creates it again and then executes migrations commands"
    echo
}

run() {
    if [[ " ${@:1} " =~ " -r " ]]; then
        $APP sf doctrine:database:drop --if-exists --force --no-interaction
        $APP sf doctrine:database:create --if-not-exists --no-interaction
    fi
    $APP sf doctrine:migrations:diff \
        --no-interaction \
        --formatted \
        --allow-empty-diff
    $APP sf doctrine:migrations:migrate \
        --allow-no-migration \
        --all-or-nothing \
        --no-interaction
}
