#!/bin/bash

description() {
    echo "Makes migration files and executes their commands";
}

run() {
    $APP sf doctrine:migrations:diff
    $APP sf doctrine:migrations:migrate
}
