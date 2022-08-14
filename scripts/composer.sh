#!/bin/bash

description() {
    echo "Executes composer";
}

run() {
    $APP dcx php composer ${@:1}
}
