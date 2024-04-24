FROM fedora:40 AS builder

RUN dnf install -y \
    gcc-c++ \
    libstdc++-static \
    make \
    cmake \
    git \
    zlib-devel \
    boost-static \
    glew-devel \
    compat-lua-devel \
    ncurses-devel \
    openal-soft-devel \
    openssl-devel \
    libvorbis-devel \
    physfs-devel; \
    dnf clean all

COPY ./src/ /otclient/src/.
COPY CMakeLists.txt /otclient/.
WORKDIR /otclient/build/
RUN cmake -DCMAKE_CXX_LINK_FLAGS=-no-pie  -DCMAKE_BUILD_TYPE=Release ..
RUN make -j$(nproc)

FROM fedora:40
RUN dnf install -y \
    openal-soft \
    libvorbis \
    compat-lua \
    physfs \
    libglvnd-opengl \
    glew; \
    dnf clean all
COPY --from=builder /otclient/build/otclient /otclient/bin/otclient
COPY ./data/ /otclient/data/.
COPY ./mods/ /otclient/mods/.
COPY ./modules/ /otclient/modules/.
COPY ./init.lua /otclient/.
WORKDIR /otclient
CMD ["./bin/otclient"]
