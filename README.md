# mapproxy-docker

![GitHub release](https://img.shields.io/github/release/PDOK/mapproxy-docker.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/pdok/mapproxy.svg)

## TL;DR

```docker
docker build -t pdok/mapproxy .
docker run -d -p 80:80 --name mapproxy-example -v `pwd`/examples/config:/srv/mapproxy/config pdok/mapproxy

docker stop mapproxy-example
docker rm mapproxy-example
```

## Introduction

This project aims to fulfill the need for creating a [Docker](https://www.docker.com) base image that can be used in a scalable infrastructure like [Kubernetes](https://kubernetes.io/) and still is easy to use with a single docker run command. That's why we created this docker images containing in which we don't COPY config during the docker build and include "pip install ..  gunicorn uwsgi .."

## What will it do

In it simplist form it will create an [Mapproxy](https://mapproxy.org/) application that is easy to use. The only thing required is to add you own mapproxy.yaml configuration. For more complex deployments like docker-compose and/or kubernetes it will provide a starting point in creating multi-container/pods deployments.

## Usage

### Build

```docker
docker build -t pdok/mapproxy .
```

### Run

This image can be run straight from the commandline. A volumn needs to be mounted on the container directory /srv/mapproxy/config.

```docker
docker run -d -p 80:80 --name mapproxy-example -v `pwd`/examples/config:/srv/mapproxy/config pdok/mapproxy
```

Running the example above will start a empty mapproxy. On the url <http://localhost/demo> the test page can be accessed. Replacing the example mapproxy.yaml with your own will start a mapproxy with that configuration.

## Docker-compose

The docker-compose example file can be found [here](/examples/docker-compose).

## Kubernetes

The kubernetes example deployment can be found [here](/examples/k8s).
