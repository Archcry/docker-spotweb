# Spotweb-Docker

With this image you can easily set-up Spotweb in a docker environment. This image is inspired by [edv/docker-spotweb](https://github.com/edv/docker-spotweb).

## Quick setup using dockerfile

*Spotweb always requires a database server (MySQL), the easiest solution is to use the docker-compose setup. The other option is to manually specify an external server using the ENV variables below.*

`docker run -p 8080:80 --name spotweb -d -v /etc/localtime:/etc/localtime:ro archcry/spotweb`

Provide one or more of the following environment variables to configure the database server (all optional, default values are given below):
* DB_ENGINE (default = `pdo_mysql`)
* DB_HOST (default = `mysql`)
* DB_PORT (default = `3306`)
* DB_NAME (default = `spotweb`)
* DB_USER (default = `spotweb`)
* DB_PASS (default = `spotweb`)

E.g. to configure server with host `some.external.mysql-server.com` and port `6612` do the following:

`docker run -p 8080:80 --name spotweb -d -v /etc/localtime:/etc/localtime:ro -e "DB_HOST=some.external.mysql-server.com" -e "DB_PORT=6612" archcry/spotweb`

## Information

* Spotweb is configured as an open system after running docker-compose up, so everyone who can access can register an account (keep this in mind)
* If you want to use the Spotweb API, create a new user and use the API key associated with that user
* If you would like to save nzb files to disk for (e.g.) SABnzbd to be picked up, configure docker-compose.yml to mount e.g. /nzb to some directory where nzb's need to be saved, and configure Spotweb to save NZB's to this directory on disk
