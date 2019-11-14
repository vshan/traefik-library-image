#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- traefik "$@"
fi

# if our command is a valid Traefik subcommand, let's invoke it through Traefik instead
# (this allows for "docker run traefik version", etc)
if traefik "$1" --help >/dev/null 2>&1
then
    set -- traefik "$@"
else
    echo "= '$1' is not a Traefik command: assuming shell execution." 1>&2
fi

mkdir -p $(dirname ${TRAEFIK_PROVIDERS_FILE_FILENAME})

while true; do
	cp -rf "${TRAEFIK_FILE_MOUNT_DIR}" $(dirname $(dirname ${TRAEFIK_PROVIDERS_FILE_FILENAME}))
        sleep 30
done &

./initfilelock "TRAEFIK_PROVIDERS_FILE_FILENAME" "120" > initfilelock.log

exec "$@"
