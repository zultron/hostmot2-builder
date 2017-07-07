FROM debian:jessie
MAINTAINER John Morris <john@zultron.com>

###################################################################
# Generic apt configuration

ENV TERM dumb

# apt config:  silence warnings and set defaults
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV LC_ALL C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LANG C.UTF-8

# Undefine to use proxy for apt package installation
#ENV HTTP_PROXY http://192.168.1.42:3128/

# turn off recommends on container OS
RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > \
            /etc/apt/apt.conf.d/01norecommend

# use stable Debian mirror
RUN sed -i /etc/apt/sources.list -e 's/deb.debian.org/ftp.debian.org/'

# use http proxy for packages
RUN if test -n "$HTTP_PROXY"; then \
        echo "Acquire::http::proxy \"$HTTP_PROXY\";" > \
	    /etc/apt/apt.conf.d/80proxy; \
    fi

###################################################################
# Configure 3rd-party apt repos, add foreign arches, and update OS

# update Debian OS
RUN apt-get update && \
    apt-get -y upgrade

###################################################################
# Install generic packages

# Stop `dpkg-gencontrol` warnings about flock
RUN apt-get -y install \
        libfile-fcntllock-perl

# Utilities
RUN apt-get -y install \
	locales \
	git \
	bzip2 \
	sharutils \
	net-tools \
	time \
	help2man \
	xvfb \
	xauth \
	python-sphinx \
	wget \
        sudo \
	lftp \
	multistrap \
	debian-keyring

# Dev tools
RUN apt-get install -y \
	build-essential \
	devscripts \
	fakeroot \
	equivs \
	lsb-release \
	less \
	python-debian \
	libtool \
	ccache \
	autoconf \
	automake \
	quilt \
	psmisc \
	pkg-config

# Add packagecloud cli and prune utility
RUN	apt-get install -y python-restkit python-apt rubygems
RUN	gem install package_cloud --no-rdoc --no-ri
ADD	packagecloud/packagecloud-prune.py /usr/bin/packagecloud-prune
ADD	packagecloud/packagecloud-upload.sh /usr/bin/packagecloud-upload
ADD	packagecloud/PackagecloudIo.py /usr/lib/python2.7

# ###########################################
# # Install Xilinx tools

# Libraries needed by the graphical installer
RUN apt-get install -y \
	libstdc++5 \
	libxrender1 \
	libxrandr2 \
	libxcursor1 \
	libxft2 \
	libxi6



###########################################
# Set up environment
#
# Customize the following to match the user's environment

# Set up user ID inside container to match your ID
ENV USER travis
ENV UID 1000
ENV GID 1000
ENV HOME /home/${USER}
ENV SHELL /bin/bash
ENV PATH /usr/lib/ccache:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin
RUN echo "${USER}:x:${UID}:${GID}::${HOME}:${SHELL}" >> /etc/passwd
RUN echo "${USER}:x:${GID}:" >> /etc/group
RUN mkdir /home/$USER && chown $USER:$USER /home/$USER

# More proxy config for git
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY

# Customize the run environment to your taste
# - bash prompt
# - 'ls' alias
RUN sed -i /etc/bash.bashrc \
    -e 's/^PS1=.*/PS1="\\h:\\W\\$ "/' \
    -e '$a alias ls="ls -aFs"'

# Configure sudo, passwordless for everyone
RUN echo "ALL	ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/${USER}
