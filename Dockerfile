FROM debian:bullseye-slim AS downloader
RUN apt-get -y update && apt-get -y install wget && rm -rf /var/lib/apt/lists/*
RUN wget https://buildroot.org/downloads/buildroot-2016.05.tar.gz -O /tmp/buildroot.tar.gz

FROM debian/eol:stretch-slim
ENV DEBIAN_FRONTEND noninteractive

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && apt-get -y install \
	bc \
    build-essential \
    bzip2 \
	bzr \
	cmake \
	cmake-curses-gui \
	cpio \
	git \
	libncurses5-dev \
	locales \
	make \
	python \
	rsync \
	scons \
	tree \
	unzip \
	wget \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/workspace
WORKDIR /root

COPY --from=downloader /tmp/buildroot.tar.gz /root/buildroot.tar.gz
COPY support .
RUN ./build-toolchain.sh
RUN cat ./setup-env.sh >> .bashrc

VOLUME /root/workspace
WORKDIR /root/workspace

CMD ["/bin/bash"]
