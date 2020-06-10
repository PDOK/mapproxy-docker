FROM debian:buster-slim
LABEL maintainer="PDOK dev <pdok@kadaster.nl>"

RUN apt-get -y update \
    && apt-get install -y \
               python3-pil \
               python3-yaml \
               python3-lxml \
               python3-shapely \
               python3-virtualenv \
               python3-pip \
               libpcre3 \
               libpcre3-dev \
               libproj13 \
               libgeos-c1v5 \
               libgdal20 \
               git \
    && rm -rf /var/lib/apt/lists/* 

RUN pip3 install Numpy PyYAML boto3 Pillow requests Shapely eventlet gunicorn uwsgi prometheus_client
# 1.12.0
RUN pip3 install git+https://github.com/mapproxy/mapproxy.git@1.12.0

# when overwriting the CMD with a uwsgi command it's good practice to not run it as root
RUN groupadd -g 1337 mapproxy \
    && useradd --shell /bin/bash --gid 1337 -m mapproxy \
    && usermod -a -G sudo mapproxy

RUN apt-get clean

# default dir needed for the cache_data
RUN mkdir -p /srv/mapproxy/cache_data
RUN chmod a+rwx /srv/mapproxy/cache_data

WORKDIR /srv/mapproxy

EXPOSE 80

CMD gunicorn -k gthread --user=1337 --group=1337 --chdir /srv/mapproxy/config --threads=16 --workers=1 -b :80 config:application --no-sendfile --access-logfile '-' --error-logfile '-'