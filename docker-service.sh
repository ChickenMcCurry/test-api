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

gitHooks() {
    echo "add git hooks"
    cp -R .git-hooks/hooks/ .git/hooks
    chmod -R 744 .git/hooks
    git config core.hooksPath .git/hooks
}

install() {
  installBack
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
                                                                                        bin/console ha:fi:lo -n"
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

csFixer() {
    paths=""
    config=".php_cs.dist"

    if [ "$#" -ge 1 ]; then
        paths="$1"
        docker run --rm --user www-data --env-file=.env -v ${PWD}/app/back:/var/www/test-api/ -w /var/www/test-api/ test-api_php-fpm bash -c "php -l $paths"

        if [ "$#" -eq 2 ]; then
            config="$2"
        fi
    fi
    docker run --rm --user www-data --env-file=.env -v ${PWD}/app/back:/var/www/test-api/ -w /var/www/test-api/ test-api_php-fpm bash -c "vendor/bin/php-cs-fixer fix --config=$config $paths -vv"
}

qualityTestsBack() {
    docker-compose -f docker-compose.yaml up -d php-fpm

    echo -e "\n\n\nCs Fixer : App/"
    docker-compose -f docker-compose.yaml exec -T --user www-data php-fpm vendor/bin/php-cs-fixer fix --config=.php_cs.dist --dry-run --diff -vv

    # Lint PHP files
    docker-compose -f docker-compose.yaml exec -T --user www-data php-fpm php -l src/
    docker-compose -f docker-compose.yaml exec -T --user www-data php-fpm php -l features/

    # Bundles security check
    docker-compose -f docker-compose.yaml exec -T --user www-data php-fpm vendor/bin/security-checker security:check

    docker-compose -f docker-compose.yaml down
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
  gitHooks                    Add hooks precommit
  install                     Run app installation scripts
  installBack                 Run back app installation scripts
  installFront                Run front app installation scripts
  populate                    Load database schema and fixtures
  stop                        Stop docker containers
  down                        Remove docker containers
  buildFront                  Run the build npm task
  watchFront                  Run the watch npm task
  csFixer                     Execute php-cs-fixer and php lint
  qualityTestsBack            Run back quality tests
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
 gitHooks)
        gitHooks
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
 qualityTestsBack)
        qualityTestsBack
        ;;
 build)
        buildFront
        ;;
 watch)
        watchFront
        ;;
 csFixer)
        csFixer
        ;;
 *)
        show_help >&2
        exit 1
esac

exit 0
