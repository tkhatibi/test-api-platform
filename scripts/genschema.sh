#!/bin/bash

description() {
    echo "Generates PHP code by schemas defined in api/config/schema.yaml";
}

run() {
    $APP dcx php vendor/bin/schema generate src/ config/schema.yaml ${@:1}
}
