FROM pdok/lighttpd:1.4.67-bookworm
LABEL maintainer="PDOK dev <pdok@kadaster.nl>"

USER root

RUN apt update && apt -y install --no-install-recommends \
  gcc \
  git \
  python3-pip \
  python3-dev \
  python3-pil \
  libgeos-dev \
  libgdal-dev \
  libxml2-dev \
  libxslt-dev && \
  apt-get -y --purge autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
RUN pip install -v --break-system-packages --requirement requirements.txt
RUN pip install -v --break-system-packages git+https://github.com/mapproxy/mapproxy.git@3.1.3

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

ENV DEBUG=0
ENV MIN_PROCS=4
ENV MAX_PROCS=8
ENV MAX_LOAD_PER_PROC=1
ENV IDLE_TIMEOUT=20

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/srv/mapproxy/config/lighttpd.conf"]
