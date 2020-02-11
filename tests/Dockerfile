FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt -y install curl build-essential \
    python3.7 \
    python3.8 \
    python3.6  \
    python3-pip \
    python3.8-dev \
    python3.6-dev \
    python3.7-dev


RUN pip3 install virtualenv
WORKDIR /work
COPY utils.sh /work
COPY conda_environment.yml /work
RUN /work/utils.sh install_conda
