FROM ubuntu:16.04

MAINTAINER Bo Gan <ganb@vmware.com>

USER root

RUN apt-get update && apt-get install -y git python-pip && apt-get clean

ARG CACHEBUST=1

RUN pip install git+https://github.com/ganboing/ovn-kubernetes

COPY entrypoint.bash /entrypoint.bash

ENTRYPOINT /entrypoint.bash
