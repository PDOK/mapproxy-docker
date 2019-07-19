# docker-compose

Docker-compose example running mapproxy demo as a uwsgi application with lighttpd as webserver exposing a prometheus metrics end-point.

## TL;DR

```docker-compose
docker-compose up -d
docker-compose down
```

## endpoints

- <http://localhost/mapproxy/demo/>
- <http://localhost/server-status>
- <http://localhost:9117/metrics>
