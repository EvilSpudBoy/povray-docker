# syntax=docker/dockerfile:1

FROM ubuntu:22.04 AS build

LABEL maintainer="POV-Ray Docker Build"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        ca-certificates \
        git \
        pkg-config \
        libtool \
        libboost-dev \
        libboost-thread-dev \
        libboost-date-time-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        zlib1g-dev \
        libpng-dev \
        libjpeg-dev \
        libtiff-dev \
        libopenexr-dev \
    && rm -rf /var/lib/apt/lists/*

ARG POVRAY_REPO="https://github.com/POV-Ray/povray.git"
ARG POVRAY_REF="3.7-stable"
ARG COMPILED_BY="Docker Builder <docker@example.com>"

WORKDIR /src
RUN git clone --depth 1 --single-branch --branch "${POVRAY_REF}" "${POVRAY_REPO}" povray
WORKDIR /src/povray

RUN cd unix \
    && ./prebuild.sh \
    && cd .. \
    && ./configure COMPILED_BY="${COMPILED_BY}" \
    && make -j"$(nproc)" \
    && make install DESTDIR=/opt/povray-install


FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        libboost-thread1.74.0 \
        libboost-date-time1.74.0 \
        libboost-system1.74.0 \
        libboost-filesystem1.74.0 \
        zlib1g \
        libpng16-16 \
        libjpeg-turbo8 \
        libtiff5 \
        libopenexr25 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/povray-install/ /

WORKDIR /scenes

ENTRYPOINT ["/usr/local/bin/povray"]
CMD ["--help"]
