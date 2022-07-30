FROM ubuntu:kinetic AS build

RUN set -ex \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends \
      build-essential \
      automake \
      autoconf \
      gcc \
      make \
 && apt-get install -y --no-install-recommends \
      libbcg729-0 libbcg729-dev \
      libsndfile1 libsndfile1-dev \
      libsrtp2-1 libsrtp2-dev \
      libsystemd-dev

COPY rtpproxy/ rtpproxy/

RUN set -ex \
 && cd rtpproxy \
 && ./configure --enable-static --disable-shared --disable-systemd --prefix=/dist \
 && make -j 64 \
 && make install

# For minimal scratch images: extract all the system deps. Inspired by:
# https://dev.to/ivan/go-build-a-minimal-docker-image-in-just-three-steps-514i
#RUN set -ex \
# && mkdir -p /dist/lib64 \
# && for F in /dist/bin/* ; do ldd $F | tr -s '[:blank:]' '\n' ; done \
#    | grep '^/' | sort | uniq \
#    | while read -r P ; do \
#        D=$(dirname $P); \
#        [[ -d /dist/$D ]] || mkdir -p /dist/$D; \
#        cp $P /dist/$P ; \
#      done \
# && cp /lib64/ld-linux-x86-64.so.2 /dist/lib64/


#------------------------------------------------------------------------------
# Minimal runtime for RTPproxy
#------------------------------------------------------------------------------
FROM ubuntu:kinetic as rtpproxy

#RUN update-alternatives --install /bin/sh sh /usr/bin/bash 100

COPY --chown=0:0 --from=build \
    /dist/bin/rtpproxy \
    /bin/

#/dist/bin/udp_contention \
#/dist/bin/extractaudio \
#/dist/bin/rtpproxy_debug \
#/dist/bin/makeann \

RUN set -ex \
 && mkdir -p /var/{lib,spool,run}/rtpproxy \
 && chown 65535 /var/{lib,spool,run}/rtpproxy

USER 65535
#EXPOSE 5999/tcp
#EXPOSE 6000-7000/udp
VOLUME ["/var/run/rtpproxy", "/var/lib/rtpproxy"]
WORKDIR /
ENTRYPOINT ["/usr/bin/bash", "-c"]
CMD ["/bin/rtpproxy", "-f", "-s", "/var/run/rtpproxy/control.sock", "-n", "/var/run/rtpproxy/timeout.sock", "/var/run/rtpproxy/pid", "-r", "/var/lib/rtpproxy", "-S", "/var/spool/rtpproxy", "-p", "-m", "6000", "-M", "7000"]

