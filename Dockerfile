FROM pdok/lighttpd:1.4.67
LABEL maintainer="PDOK dev <pdok@kadaster.nl>"

USER root

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

COPY requirements.txt requirements.txt
RUN pip3 install --requirement requirements.txt
# use the PDOK fork of MapProxy. This is MapProxy version 1.13.1 but patched with https://github.com/mapproxy/mapproxy/pull/608
RUN pip3 install git+https://github.com/PDOK/mapproxy.git@pdok-1.13.2-patched-2

RUN apt-get clean

# default dir needed for the cache_data
RUN mkdir -p /srv/mapproxy/cache_data
RUN chmod a+rwx /srv/mapproxy/cache_data

WORKDIR /srv/mapproxy

ADD config/lighttpd.conf /srv/mapproxy/config/lighttpd.conf
ADD config/include.conf /srv/mapproxy/config/include.conf
ADD config/log.ini /srv/mapproxy/config/log.ini

ADD config/start.py /srv/mapproxy/start.py
RUN chmod +x start.py

USER www

ENV DEBUG 0
ENV MIN_PROCS 4
ENV MAX_PROCS 8
ENV MAX_LOAD_PER_PROC 1
ENV IDLE_TIMEOUT 20

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/srv/mapproxy/config/lighttpd.conf"]
