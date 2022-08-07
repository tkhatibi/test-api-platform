#!/bin/bash

description() {
    echo "If it's your first usage, it initializes the project; else resets everything";
}

help() {
    echo "Available Options:"

    echo "  -r"
    echo "  Removes everything before start"
    echo
}

run() {
    if [[ " ${@:1} " =~ " -r " ]]; then
        $APP dc down --volumes --remove-orphans
        $APP dc build --pull --no-cache
    fi

    # https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md#editing-permissions-on-linux
    $APP dc run --rm php chown --recursive $(id -u):$(id -g) .

    $APP dcu --build --renew-anon-volumes

    # https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md#fix-chromebrave-ssl
    if [ "$OS" = 'Linux' ]; then
        docker cp $($APP dc ps -q caddy):/data/caddy/pki/authorities/local/root.crt /usr/local/share/ca-certificates/root.crt && sudo update-ca-certificates
    elif [ "$OS" = 'Darwin' ]; then
        docker cp $($APP dc ps -q caddy):/data/caddy/pki/authorities/local/root.crt /tmp/root.crt && sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/root.crt
    fi
}
