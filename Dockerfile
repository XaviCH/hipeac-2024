FROM nvidia/cuda:11.3.1-devel-ubuntu20.04
RUN apt-get update &&\
        DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata &&\
        apt-get install -y --no-install-recommends python3 make g++ git gcc-9 cmake perl autoconf wget ca-certificates libncurses-dev ncurses-dev python3-dev python3-distutils python3-venv swig python3-pip
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 10
RUN apt-get clean
CMD ["/bin/bash"]