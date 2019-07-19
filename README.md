# mapproxy-docker

[![GitHub release](https://img.shields.io/github/release/PDOK/mapproxy-docker.svg)][release]
[![Docker Pulls](https://img.shields.io/docker/pulls/pdok/mapproxy.svg?maxAge=604800)][hub]

## TL;DR

```docker
docker build -t pdok/mapproxy .
docker run -d -p 80:80 --name mapproxy-example -v `pwd`/examples/config:/srv/mapproxy/config pdok/mapproxy

docker stop mapproxy-example
docker rm mapproxy-example
```

## Introduction

This project aims to fulfill two needs:

1. create a [OGC services](http://www.opengeospatial.org/standards) that are deployable on a scalable infrastructure.
2. create a useable [Docker](https://www.docker.com) base image.

Fulfilling the first need the main purpose is to create an Docker base image that eventually can be run on a platform like [Kubernetes](https://kubernetes.io/).

Regarding the second need, finding a usable Mapproxy Docker image is a challenge. Most image rely on old versions of Mapproxy and or Python.

## What will it do

It will create an Mapproxy application that is easy to use. The only thing required to do is to add you own mapproxy.yaml configuration.

## Docker image

The Docker image contains 2 stages:

1. builder
2. service

### builder

The builder stage compiles Mapserver. The Dockerfile contains all the available Mapserver build option explicitly, so it is clear which options are enabled and disabled.

### service

The service stage copies the Mapserver application, build in the first stage the service stage, and configures Lighttpd & the epsg file.

## Usage

### Build

```docker
docker build -t pdok/mapproxy .
```

### Run

This image can be run straight from the commandline. A volumn needs to be mounted on the container directory /srv/data. The mounted volumn needs to contain at least one mapserver *.map file. The name of the mapfile will determine the URL path for the service.

```docker
docker run -d -p 80:80 --name mapserver-example -v `pwd`/examples/config:/srv/mapproxy/config pdok/mapserver
```

Running the example above will start a empty mapproxy. On the url <http://localhost/demo> the test page can be accessed. Replacing the example mapproxy.yaml with your own will start a mapproxy with that configuration.
