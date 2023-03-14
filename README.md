# mapproxy-docker

[![GitHub license](https://img.shields.io/github/license/PDOK/mapproxy-docker)](https://github.com/PDOK/mapproxy-docker/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/PDOK/mapproxy-docker.svg)](https://github.com/PDOK/mapproxy-docker/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/pdok/mapproxy.svg)](https://hub.docker.com/r/pdok/mapproxy)

## TL;DR

```docker
docker build -t pdok/mapproxy .
docker run --rm -d -p 8080:80 --name mapproxy-example -v `pwd`/examples/config/mapproxy.yaml:/srv/mapproxy/config/mapproxy.yaml pdok/mapproxy

docker stop mapproxy-example
```

## Introduction

This project aims to fulfill the need for creating a
[Docker](https://www.docker.com) base image that can be used in a scalable
infrastructure like [Kubernetes](https://kubernetes.io/) and still is easy to
use with a single docker run command. That's why we created this docker images
containing in which we don't COPY config during the docker build.

## What will it do

In it simplist form it will create an [Mapproxy](https://mapproxy.org/)
application that is easy to use. The only thing required is to add you own
mapproxy.yaml configuration. For more complex deployments like docker-compose
and/or kubernetes it will provide a starting point in creating
multi-container/pods deployments.

## Usage

### Build

```docker
docker build -t pdok/mapproxy .
```

### Run

This image can be run straight from the commandline. The mapproxy config file
needs to be mounted on the container path `/srv/mapproxy/config/mapproxy.yaml`.

```docker
docker run -d -p 80:80 --name mapproxy-example -v `pwd`/examples/config/mapproxy.yaml:/srv/mapproxy/config/mapproxy.yaml pdok/mapproxy
```

Running the example above will start a empty mapproxy. On the url
<http://localhost:8080/mapproxy/demo> the test page can be accessed. Replacing the example
mapproxy.yaml with your own will start a mapproxy with that configuration.

This docker image uses lighttpd as a proxy. It's possible to add additional
lighttpd config by mounting a `include.conf` file on the container path
`/srv/mapproxy/config/include.conf`. It's also possible to provide your
own complete lighttpd config by mounting a `lighttpd.conf` file on the
container path `/srv/mapproxy/config/lighttpd.conf`.

## Environment variables

**DEBUG** Set the log level for both lighttpd and mapproxy to debug. This
results is verbose logging which includes in request logging (Default: 0)

**MIN_PROCS** Sets the minimum fastcgi processes to start (Default: 4)

**MAX_PROCS** Upper limit of fastcgi processes to start (Default: 8)

**MAX_LOAD_PER_PROC** Maximum number of waiting processes on average per
process before a new process is spawned (Default: 1)

**IDLE_TIMEOUT** Number of seconds before a unused process gets
terminated (Default: 20)

## Docker-compose

The docker-compose example file can be found [here](/examples/docker-compose).

## Kubernetes

The kubernetes example deployment can be found [here](/examples/k8s).
