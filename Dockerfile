FROM pdok/lighttpd:1.4.85-trixie
LABEL maintainer="PDOK dev <pdok@kadaster.nl>"

USER root

# wget is required for startup probe in mapproxy-operator
# git is required for pip installing mapproxy from git in this Dockerfile
# gcc and python3-dev are required to build uwsgi from source (no wheel available)
# libgdal36 is loaded at runtime by mapproxy (ctypes) for ogr_datasource coverages
# all other dependencies (including GEOS, libxml2, PROJ and Pillow's libraries) are bundled in their wheels
RUN apt-get update && apt-get -y install --no-install-recommends \
  gcc \
  git \
  wget \
  python3-pip \
  python3-dev \
  libgdal36 && \
  apt-get -y --purge autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
RUN pip install -v --break-system-packages --requirement requirements.txt
# using patched version until PR is merged upstream (https://github.com/mapproxy/mapproxy/pull/1556)
# RUN pip install -v --break-system-packages git+https://github.com/mapproxy/mapproxy.git@8.1.0
RUN pip install -v --break-system-packages git+https://github.com/PDOK/mapproxy.git@168e51f9e87904178f88caf8b967fafe22fe8f92

# default dir needed for the cache_data
RUN mkdir -p /srv/mapproxy/cache_data && \
    chmod a+rwx /srv/mapproxy/cache_data

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
