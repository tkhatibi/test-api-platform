#!/bin/bash

description() {
    echo "Executes symfony's console";
}

run() {
    $APP dcx php bin/console ${@:1}
}
