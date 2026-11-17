# A TIC-80 Pro webes lejátszója (tic80.js + tic80.wasm) ugyanabból a commitból, mint a natív image.
# A WarpEngine `tic80` runtime-ja ebből a zipből települ: make runtime && make upload-runtime.
ARG EMSDK_TAG=4.0.10
FROM emscripten/emsdk:${EMSDK_TAG} AS build

ARG TIC80_REF=ae1195a9

RUN apt-get update && apt-get install -y --no-install-recommends ruby rake zip && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/nesbox/TIC-80 /opt/TIC-80 && \
  cd /opt/TIC-80 && git checkout ${TIC80_REF} && git submodule update --init --recursive

RUN cd /opt/TIC-80/build && \
  emcmake cmake -DBUILD_SDLGPU=On -DBUILD_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_WITH_ALL=ON -DBUILD_PRO=On .. && \
  cmake --build . --parallel

RUN mkdir -p /out && cd /opt/TIC-80/build/bin && \
  zip -q /out/tic80-runtime.zip tic80.js tic80.wasm && \
  awk '/TIC_VERSION_(MAJOR|MINOR|REVISION|STATUS) / { gsub(/"/, "", $3); v[$2] = $3 } \
       END { printf "%s.%s.%s%s\n", v["TIC_VERSION_MAJOR"], v["TIC_VERSION_MINOR"], v["TIC_VERSION_REVISION"], v["TIC_VERSION_STATUS"] }' \
       /opt/TIC-80/build/version.h > /out/VERSION

FROM scratch
COPY --from=build /out/ /
