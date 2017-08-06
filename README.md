# dada-mail-docker

Provides a Dockerfile to create a Dada-Mail docker image. In combination with a docker-compose.yml it also spawns a MariaDB.
Also see: http://dadamailproject.com/

## Build Image

If you are not using a pre-compiled image from Docker Hub and want to build it yourself, then just do:

  ./build.sh

This takes some time. Afterwards, you can go on starting it.

## First Start

Spawn the server with 

  docker-compose up -d

and visit the url: http://localhost:8080/dada/installer/install.cgi 

