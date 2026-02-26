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
  && rm -rf /var/lib/apt/lists/*

# TIC-80 forrás letöltése és build
RUN git clone --recursive https://github.com/nesbox/TIC-80 /opt/TIC-80 && \
  cd /opt/TIC-80/build && \
  cmake -DBUILD_SDLGPU=On -DBUILD_WITH_ALL=On -DBUILD_PRO=On -DBUILD_STATIC=On .. && \
  cmake --build . --parallel

# PATH-be tesszük a bináris helyét
ENV PATH="/opt/TIC-80/build/bin:${PATH}"

WORKDIR /workspace

CMD ["/bin/bash"]
