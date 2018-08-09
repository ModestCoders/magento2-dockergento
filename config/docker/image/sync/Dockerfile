FROM alpine:3.5
MAINTAINER Juan Alonso <juan.jalogut@gmail.com>

# Install needed packages.
#RUN apt-get -qq update && \
#    apt-get -qq install inotify-tools rsync unison-all && \
#    apt-get clean && \
#    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Alpine doesn't ship with Bash.
RUN apk add --no-cache bash

# Install Unison from source with inotify support + remove compilation tools
ARG UNISON_VERSION=2.48.4
RUN apk add --no-cache --virtual .build-dependencies build-base curl && \
    apk add --no-cache inotify-tools && \
    apk add --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ ocaml && \
    curl -L https://github.com/bcpierce00/unison/archive/$UNISON_VERSION.tar.gz | tar zxv -C /tmp && \
    cd /tmp/unison-${UNISON_VERSION} && \
    sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c && \
    make UISTYLE=text NATIVE=true STATIC=true && \
    cp src/unison src/unison-fsmonitor /usr/local/bin && \
    apk del .build-dependencies ocaml && \
    rm -rf /tmp/unison-${UNISON_VERSION}

COPY scripts/init_sync_config.sh /usr/local/bin/init_sync_config
RUN chmod +x /usr/local/bin/init_sync_config

COPY scripts/sync.sh /usr/local/bin/sync
RUN chmod +x /usr/local/bin/sync

COPY scripts/watch.sh /usr/local/bin/watch
RUN chmod +x /usr/local/bin/watch

RUN addgroup -g 1000 -S app \
 && adduser -u 1000 -D -S -G app app

RUN mkdir -p /home/app/.unison
RUN touch /home/app/unison.log
RUN chown -R app:app /home/app

CMD init_sync_config && tail -f /dev/null