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

## Web player (WarpEngine runtime)

The catalog plays TIC-80 releases in the browser from the update server's `tic80`
runtime (WarpEngine 3.1+), not from a per-release html export: the current
development builds can no longer fetch an html export template from tic80.com.
`web.Dockerfile` builds the Pro web player (`tic80.js` + `tic80.wasm`, Emscripten)
from the same TIC-80 commit as the native image (`TIC80_REF`), and the Makefile
installs it as a runtime version named after the TIC-80 version (e.g. `1.2.3054-dev`):

```bash
make runtime                                  # dist/tic80-runtime.zip + dist/VERSION
make upload-runtime TOKEN=<application token with the upload scope>
```

The same version sent again with the same files is accepted unchanged; other files
for it are refused. Choose it for new releases in the host initializer
(`runtime :tic80, version: "..."`); the releases already published keep the
version they were published with.

Build the native image with `make image` / `make push`; both pin `TIC80_REF`.
