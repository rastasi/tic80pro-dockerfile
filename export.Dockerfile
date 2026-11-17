ARG BASE=git.teletypegames.org/build/tic80pro:2026.11.17
FROM ${BASE}

ARG TIC80_REF=ae1195a9
ARG STUBS_URL=https://github.com/rastasi/tic80pro-dockerfile/releases/download/stubs-${TIC80_REF}
RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/* && \
  mkdir -p /opt/tic80-stubs && cd /opt/tic80-stubs && \
  for stub in tic80-stub-win-x64.exe tic80-stub-linux-x64 tic80-stub-mac-x64; do \
    curl -fsSL --retry 3 -o "$stub" "$STUBS_URL/$stub"; \
  done && ls -l /opt/tic80-stubs
COPY tic80-export /usr/local/bin/tic80-export
RUN chmod +x /usr/local/bin/tic80-export
