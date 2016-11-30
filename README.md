# blockchain-container-ethereum
Base Bapp2 Blockchain Docker Container


Dockerfile definition to start with some useful tools - this is the base image for Bapp2

Features:

- solc
- geth
- parity
- nodejs (latest v6)
- ruby (2.3.x)

Plus:

- build-tools package
- A simple script to get the container id (based on the container ip)
- run everything on one container (simple for bootstrapping a full instance that contains both the blockchain process and your app) - you can add an optional redis container per blockchain node/server instance and use that as a cache and/or you can use a shared redis for exchanging messages between nodes/instances, build a pub/sub based system, etc...

### Changelog

- updated to the latest version of parity (1.4.5)



```
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# solc and geth (geth is used just to run attach)
RUN apt-get update      -y --ignore-missing              && \
    apt-get install     -y software-properties-common apt-utils wget  && \
    add-apt-repository  -y ppa:ethereum/ethereum                      && \
    add-apt-repository  -y ppa:ethereum/ethereum-dev                  && \
    apt-get             -y update                                     && \
    apt-get install     -y solc geth

# TODO: run apt clean

# parity
#
RUN wget https://github.com/ethcore/parity/releases/download/v1.3.8/parity_1.3.8-0_amd64.deb && dpkg -i parity_1.3.8-0_amd64.deb

RUN apt-get install -y python curl git unzip

# node 6 from package
#
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

RUN npm i -g coffee-script pm2


# ruby from package
#
RUN apt-get install software-properties-common && \
    apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install ruby2.3 -y  && \
    gem i bundler


# build-essential not always needed (just if your lib has C dependencies)
RUN apt-get install -y build-essential ruby2.3-dev  libsqlite3-dev


# see Dockerfile for example CMD and for the container_id script
```
