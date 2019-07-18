FROM python:3.7-slim-stretch
LABEL maintainer="PDOK dev <pdok@kadaster.nl>"

RUN apt-get -y update \
    && apt-get install -y \
               python-pil \
               python-yaml \
               python-lxml \
               python-shapely \
               python-imaging \
               python-virtualenv \
               python-pip \
               libpcre3 \
               libpcre3-dev \
               libproj12 \
               libgeos-c1v5 \
               libgdal20 \
               git \
    && rm -rf /var/lib/apt/lists/* 

RUN pip install PyYAML boto3 Pillow requests Shapely eventlet gunicorn uwsgi prometheus_client
# master for the 1.12-alpha
RUN pip install git+https://github.com/mapproxy/mapproxy.git@master

# when overwriting the CMD with a uwsgi command it's good practice to not run it as root
RUN groupadd -g 1337 mapproxy \
    && useradd --shell /bin/bash --gid 1337 -m mapproxy \
    && usermod -a -G sudo mapproxy

RUN apt-get clean

WORKDIR /srv/mapproxy

EXPOSE 80

CMD gunicorn -k gthread --user=1337 --group=1337 --chdir /srv/mapproxy/config --threads=16 --workers=1 -b :80 config:application --no-sendfile --access-logfile '-' --error-logfile '-'