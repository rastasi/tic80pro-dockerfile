FROM ubuntu:24.04

# Telepítjük a függőségeket
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  libpipewire-0.3-dev \
  libwayland-dev \
  libsdl2-dev \
  ruby-dev \
  libcurl4-openssl-dev \
  libglvnd-dev \
  libglu1-mesa-dev \
  freeglut3-dev \
  curl \
  lua5.4 \
  && rm -rf /var/lib/apt/lists/*

# TIC-80 forrás letöltése és build; a web.Dockerfile ugyanezt a commitot fordítja webre
ARG TIC80_REF=ae1195a9
RUN git clone https://github.com/nesbox/TIC-80 /opt/TIC-80 && \
  cd /opt/TIC-80 && git checkout ${TIC80_REF} && git submodule update --init --recursive && \
  cd /opt/TIC-80/build && \
  cmake -DBUILD_SDLGPU=On -DBUILD_WITH_ALL=On -DBUILD_PRO=On -DBUILD_STATIC=On .. && \
  cmake --build . --parallel

# PATH-be tesszük a bináris helyét
ENV PATH="/opt/TIC-80/build/bin:${PATH}"

WORKDIR /workspace

CMD ["/bin/bash"]
