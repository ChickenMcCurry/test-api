#!/usr/bin/env bash
set -o nounset
set -o errexit

OPTIND=1

[ ! -f .env ] && cp .env.dist .env;
source .env


# Common operations
initialize() {
      down
      start
      install
      populate
      gitHooks
}

start() {
    docker-compose -f docker-compose.yaml up -d --remove-orphans
    docker-compose -f docker-compose.yaml ps
}

install() {
  installBack
  populate
  installFront
  buildFront
}

installBack() {
    echo 'Install Back'
    docker-compose -f docker-compose.yaml run --rm -T --user=root --no-deps --entrypoint="/bin/bash -c"  php-fpm "chown 33:33 /var/www -R"
    docker-compose -f docker-compose.yaml run -T --rm --user=www-data --no-deps --entrypoint="/bin/bash -c" php-fpm "composer install --prefer-dist --no-interaction --optimize-autoloader"
}

installFront() {
    echo 'Install Front'
    docker-compose -f docker-compose.yaml run --rm -T --user=root --no-deps --entrypoint="/bin/bash -c"  node "chown 33:33 /var/www -R"
    docker-compose -f docker-compose.yaml run -T --rm --user=www-data --no-deps --entrypoint="/bin/bash -c" node "npm i"
}

populate() {
    echo 'Populate'
    docker-compose -f docker-compose.yaml exec -T --user www-data php-fpm bash -c "bin/console do:sc:up -f &&
                                                                                        bin/console do:fi:lo -n"
}

stop() {
    echo 'Stop docker'
    docker-compose -f docker-compose.yaml stop
}

down() {
    echo 'Down docker'
    docker-compose -f docker-compose.yaml down --remove-orphans
}

buildFront() {
    docker-compose -f docker-compose.yaml exec -T --user www-data node bash -c "npm run build"
}

watchFront() {
    docker-compose -f docker-compose.yaml exec -T --user www-data node bash -c "npm run watch"
}

# Usage info
show_help() {
cat << EOF
Usage:  ${0##*/} [-e] [COMMAND]
Options:
  -e string        Specify env ("test"|"dev") (default "dev")

Commands:
  initialize                  Start the project no matter what state it is in
  start                       Start docker containers
  install                     Run app installation scripts
  installBack                 Run back app installation scripts
  installFront                Run front app installation scripts
  populate                    Load database schema and fixtures
  stop                        Stop docker containers
  down                        Remove docker containers
  buildFront                  Run the build npm task
  watchFront                  Run the watch npm task
EOF
}
# Get cli options
while getopts "he:" opt; do
  case $opt in
    h)
        show_help
        exit 0
        ;;
    e)
        env=".$OPTARG"
        ;;
    *)
        show_help >&2
        exit 1
        ;;
  esac
done

# Shift off the options and optional --.
shift "$((OPTIND-1))"


# Show help if no argument was supplied
if [ $# -eq 0 ]
  then
    show_help >&2
    exit 1
fi

case "$1" in
 initialize)
        initialize
        ;;
 start)
        start
        ;;
 stop)
        stop
        ;;
 down)
        down
        ;;
 restart)
        stop
        start
        ;;
 install)
        install
        ;;
 installBack)
        installBack
        ;;
 populate)
        populate
        ;;
 build)
        buildFront
        ;;
 watch)
        watchFront
        ;;
 *)
        show_help >&2
        exit 1
esac

exit 0
