FROM ubuntu:focal
LABEL maintainer="sebastian.stenzel@cryptomator.org"

ENV LANG=C.UTF-8

# Install Build Dependencies
RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get -y --no-install-recommends install curl ca-certificates debhelper devscripts build-essential fakeroot dput \
	&& apt-get clean

# import gpg key
COPY A8240A09.asc /tmp/
RUN gpg -v --batch --import /tmp/A8240A09.asc

# initialize build directory
COPY build.sh /var/build/
COPY debian /var/build/debian/

ENV APPIMG_VERSION=1.5.14 \
	PACKAGE_VERSION=1.5.14 \
	PPA_VERSION=1.5.14-0ppa1 \
	APPIMG_URL=https://github.com/cryptomator/cryptomator/releases/download/1.5.14/cryptomator-1.5.14-x86_64.AppImage \
	GPG_PASSPHRASE=toBeSpecifiedWhenRunningThisContainer

# create debian source package
CMD cd /var/build \
	&& bash /var/build/build.sh
