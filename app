#!/bin/bash

export ROOT_PATH=$(cd $(dirname "$0") && pwd)

export APP=$ROOT_PATH/app

export OS=$(uname)

if [[ -z "${APP_ENV}" ]]; then
    export APP_ENV=dev
fi

export PROJECT_NAME="mooney"

export POSTGRES_SERVICE=database

export DOCKER_COMPOSE=$ROOT_PATH/docker-compose.yml

export DOCKER_COMPOSE_OVERRIDE=$ROOT_PATH/docker-compose.$APP_ENV.yml

__log() {
    if [[ -z "$NO_LOG" ]]; then
        echo ${1}
    fi
}

# Setting ENV variables

__export_file_env_vars() {
    ENV_PATH=${1}
    if [ ! -f "$ENV_PATH" ]; then
        __log "Env file not found: $ENV_PATH"
    elif [ ! -s "$ENV_PATH" ]; then
        __log "Env file skipped duo to being empty: $ENV_PATH"
    elif [ "$OS" = 'Linux' ]; then
        export $(grep -v '^#' $ENV_PATH | xargs -d '\n')
    elif [ "$OS" = 'FreeBSD' ]; then
        export $(grep -v '^#' $ENV_PATH | xargs -0)
    fi
}

if [[ ! -v EXPORTED ]] || [ $EXPORTED != $APP_ENV ]; then
    __export_file_env_vars $ROOT_PATH/.env
    __export_file_env_vars $ROOT_PATH/.env.local
    __export_file_env_vars $ROOT_PATH/.env.$APP_ENV
    __export_file_env_vars $ROOT_PATH/.env.$APP_ENV.local
    __log ""
    export DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_SERVICE}:${POSTGRES_PORT}/${POSTGRES_DB}?serverVersion=${POSTGRES_VERSION}
    export EXPORTED=$APP_ENV

    if [[ -z "$XDEBUG_MODE" ]] && [[ "$APP_ENV" = 'dev' ]]; then
        export XDEBUG_MODE=debug
    fi

    if [ "$XDEBUG_MODE" = 'debug' ]; then
        if [ "$OS" = 'Linux' ]; then
            export XDEBUG_CLIENT_HOST=$(hostname -I)
        elif [ "$OS" = 'Darwin' ]; then
            export XDEBUG_CLIENT_HOST=docker.for.mac.localhost
        else
            export XDEBUG_CLIENT_HOST=host.docker.internal
        fi
    fi

    __log "APP_ENV=$APP_ENV"
    __log "DATABASE_URL=$DATABASE_URL"
    __log "XDEBUG_MODE=$XDEBUG_MODE"
    __log "XDEBUG_CLIENT_HOST=$XDEBUG_CLIENT_HOST"
    __log ""
fi


# Handling related command

COMMAND=${1}
ARGS=${@:2}
SCRIPT_EXISTS=false
IS_RUN=false

if [[ ${1} = "help" ]]; then
    COMMAND=${2}
    if [ -f "$ROOT_PATH/scripts/${2}.sh" ]; then
        SCRIPT_EXISTS=true
    fi
elif [ -f "$ROOT_PATH/scripts/${1}.sh" ]; then
    IS_RUN=true
    SCRIPT_EXISTS=true
fi

if $SCRIPT_EXISTS ; then
    source "$ROOT_PATH/scripts/$COMMAND.sh"
    if $IS_RUN ; then
        run $ARGS
    elif [ $(type -t help) == function ]; then
        help
    else
        description
    fi
else
    if [ "$COMMAND" != "" ]; then
        echo "Command '$COMMAND' does not exist."
    fi
    echo "Available Commands:"
    for scriptFileName in $ROOT_PATH/scripts/*
    do
        source $scriptFileName
        echo "  $(basename $scriptFileName .sh): $(description)"
    done
fi
