FROM FROM_IMAGE:14.04
MAINTAINER Artem Golub <artemgolub@gmail.com>

# Install some project specific stuff.
# Clean up APT when done
RUN apt-get update && \
    apt-get -y -q upgrade && \
    apt-get install --no-install-recommends -q -y \
        python \
        python-pip \
        python-dev \
        python-software-properties \
        uwsgi-plugin-python \
        software-properties-common \
        build-essential \
        libpq-dev \
        git \
        nano \
        wget \
        curl \
        bash \
        dialog \
        net-tools \
        openssh-server \
        openssh-sftp-server \
        nginx \
        curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
