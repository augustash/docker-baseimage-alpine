FROM alpine:3.12 as rootfs-stage

# environment
ENV ARCH=x86_64
ENV MIRROR=http://dl-cdn.alpinelinux.org/alpine
ENV PACKAGES=alpine-baselayout,alpine-keys,apk-tools,busybox,libc-utils,xz
ENV REL=v3.12

# packages & configure
RUN \
    apk add --update --no-cache bash curl tzdata xz && \
    rm -rf /var/cache/apk/*

# fetch and run builder script from gliderlabs
RUN \
    curl -o /mkimage-alpine.bash -L \
    https://raw.githubusercontent.com/gliderlabs/docker-alpine/master/builder/scripts/mkimage-alpine.bash && \
    chmod +x /mkimage-alpine.bash && \
    ./mkimage-alpine.bash && \
    mkdir /root-out && \
    tar xf /rootfs.tar.xz -C /root-out && \
    sed -i -e 's/^root::/root:!:/' /root-out/etc/shadow

# Runtime stage
FROM scratch
COPY --from=rootfs-stage /root-out/ /

# environment
ARG CONFD_VERSION="0.16.0"
ARG OVERLAY_ARCH="amd64"
ARG OVERLAY_VERSION="2.0.0.1"
ENV PGID="1000"
ENV PUID="501"
ENV HOME="/root" \
    TERM="xterm-color"

# packages & configure
RUN \
    echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies curl tar && \
    echo "**** install runtime packages ****" && \
    apk add --no-cache bash ca-certificates curl coreutils openssl procps shadow tzdata vim && \
    echo "**** add s6 overlay ****" && \
    curl -sSL -o /tmp/s6-overlay.tar.gz \
    "https://github.com/just-containers/s6-overlay/releases/download/v${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
    tar xfz /tmp/s6-overlay.tar.gz -C / && \
    curl -sSL -o /usr/local/bin/confd \
    "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" && \
    chmod +x /usr/local/bin/confd && \
    echo "**** create ash user and make our folders ****" && \
    groupadd -g ${PGID} ash && \
    useradd -u ${PUID} -d /dev/null -s /sbin/nologin -g ash ash && \
    mkdir -p /usr/local/bin /etc/confd/templates /etc/confd/conf.d /etc/confd/init /backups /defaults /src && \
    mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
    echo "**** cleanup ****" && \
    apk del --purge build-dependencies && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# copy root filesystem
COPY rootfs /

# run s6 supervisor
ENTRYPOINT ["/init"]
