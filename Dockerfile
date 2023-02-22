FROM debian:buster-slim
LABEL maintainer="PDOK dev <pdok@kadaster.nl>"

# apt-get python3-pip on debian:buster will install python3.7
RUN apt-get -y update \
    && apt-get install -y \
               python3-pip \
               libpcre3 \
               libpcre3-dev \
               libproj13 \
               libgeos-dev \
               libgdal20 \
               git \
               wget \
               zlib1g-dev \
               libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install Numpy PyYAML boto3 Pillow requests Shapely eventlet gunicorn uwsgi prometheus_client lxml azure-storage-blob
# use the PDOK fork of MapProxy. This is MapProxy version 1.13.1 but patched with https://github.com/mapproxy/mapproxy/pull/608
RUN pip3 install git+https://github.com/PDOK/mapproxy.git@pdok-1.13.2-patched-2

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
