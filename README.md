# test-api
API plateform simple API. 

## Start
Initialize the project with `./docker-service.sh initialize`.

## Default ports
* Front on port [8082](http://localhost:8082)
* Front watch server on port [4200](http://localhost:4200)
* Backend on port [8888](http://localhost:8888)
* Postgre Admin on port [5432](http://localhost:5432)

## Commands
```bash
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
```
