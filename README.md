# dada-mail-docker

Provides a Dockerfile to create a Dada-Mail docker image. In combination with a docker-compose.yml it also spawns a MariaDB.
Also see: http://dadamailproject.com/

## First Start

If you don't want to clone this whole repo, just grab the docker-compose.yml:

    curl -L https://raw.githubusercontent.com/andreas-hofmann/dadamail-docker/refs/heads/main/docker-compose.yml > docker-compose.yml

Adjust the values in docker-compose.yml to your needs - specifically the root password and the URL you want to use.

Spawn the server with either

    docker compose up -d

or

    podman compose up -d

and visit your configured `$DADA_URL/mail.cgi`.

## Build Image

If you are not using a pre-compiled image from Docker Hub and want to build it yourself, then just do:

    ./build.sh

This takes some time. Afterwards, you can go on starting it.


Loosely based (and heavily reworked) on the repo found at https://gogs.netdome.biz/netdome/dada-mail-docker.
