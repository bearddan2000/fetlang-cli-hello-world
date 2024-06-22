FROM ubuntu:22.04

WORKDIR /workspace

# Install tooling dependencies
RUN apt-get -q update && \
    apt-get -q install -y --no-install-recommends ca-certificates \
        git automake autoconf make clang cmake wget \
        unzip python3 meson

RUN wget -qO /usr/local/bin/ninja.gz https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip

RUN gunzip /usr/local/bin/ninja.gz

RUN chmod a+x /usr/local/bin/ninja

RUN git clone https://github.com/fetlang/fetlang

WORKDIR /workspace/fetlang

RUN meson setup --buildtype=release src build

WORKDIR /workspace/fetlang/build

RUN ninja && ninja test && ninja install

WORKDIR /code
# 
COPY bin .
# 
CMD "./run.sh"