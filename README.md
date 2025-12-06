# TIC-80 Pro Dockerfile

This repository contains a Dockerfile for building and running [TIC-80 Pro](https://tic80.com/) within a Docker container.

## What is TIC-80?

TIC-80 is a fantasy computer where you can make, play and share tiny games. It has built-in tools for development: code, sprites, maps, sound, and music editors.

## Dockerfile Overview

The `Dockerfile` performs the following steps:

1.  **Base Image**: Uses `ubuntu:24.04` as the base operating system.
2.  **Install Dependencies**: Installs essential build tools and libraries required for compiling TIC-80, including `build-essential`, `cmake`, `git`, `libsdl2-dev`, and various other development packages.
3.  **Clone and Build TIC-80**:
    *   Clones the official [TIC-80 repository](https://github.com/nesbox/TIC-80) into `/opt/TIC-80`.
    *   Navigates to the build directory and uses `cmake` to configure the build with `SDLGPU`, `ALL`, `PRO`, and `STATIC` options enabled.
    *   Compiles the project using `cmake --build . --parallel`.
4.  **Set PATH**: Adds the directory containing the compiled TIC-80 binaries (`/opt/TIC-80/build/bin`) to the system's `PATH` environment variable, making the `tic80` command accessible globally within the container.
5.  **Working Directory**: Sets the default working directory inside the container to `/workspace`.
6.  **Default Command**: Sets the default command to `/bin/bash`, allowing users to interact with the container via a shell.

## How to Use

To build the Docker image:

```bash
docker build -t tic80-pro .
```

To run the container and access the TIC-80 environment:

```bash
docker run -it tic80-pro /bin/bash
```

Once inside the container, you can run `tic80` to launch the fantasy console.
