ARG OS_VER=22.04
ARG DPDK_VER=21.11-rc4
ARG OFED_VER=23.10-1.1.9.0
FROM ubuntu:${OS_VER}

WORKDIR /

# Install prerequisite packages
RUN apt-get update && apt-get install -y \
dpkg \
libnl-3-dev \
libnl-route-3-dev \
libnl-3-200 \
libnl-route-3-200 \
udev \
libmnl-dev \
libnuma-dev \
numactl \
libnuma1 \
python3-pkgconfig \
meson \
unzip \
wget \
make \
gcc \
ethtool \
net-tools \
python3-pip \
pciutils \
iputils-ping \
vim \
tcpdump \
kmod \
linux-headers-$(uname -r) \
&& rm -rf /var/lib/apt/lists/*

RUN pip3 install pyelftools

# Install MOFED - If no MOFED version supplied install from upstream 
ARG OFED_VER
ARG OS_VER
RUN if [ "$OFED_VER" != "" ] ; then  cd /root/ && wget https://linux.mellanox.com/public/repo/mlnx_ofed/${OFED_VER}/ubuntu${OS_VER}/x86_64/rdma-core_2307mlnx47-1.2310119_amd64.deb && wget https://linux.mellanox.com/public/repo/mlnx_ofed/${OFED_VER}/ubuntu${OS_VER}/x86_64/libibverbs-dev_2307mlnx47-1.2310119_amd64.deb && wget https://linux.mellanox.com/public/repo/mlnx_ofed/${OFED_VER}/ubuntu${OS_VER}/x86_64/libibverbs1-dbg_2307mlnx47-1.2310119_amd64.deb && wget https://linux.mellanox.com/public/repo/mlnx_ofed/${OFED_VER}/ubuntu${OS_VER}/x86_64/libibverbs1_2307mlnx47-1.2310119_amd64.deb && wget https://linux.mellanox.com/public/repo/mlnx_ofed/${OFED_VER}/ubuntu${OS_VER}/x86_64/ibverbs-providers_2307mlnx47-1.2310119_amd64.deb && wget https://linux.mellanox.com/public/repo/mlnx_ofed/${OFED_VER}/ubuntu${OS_VER}/x86_64/ibverbs-utils_2307mlnx47-1.2310119_amd64.deb ; fi
RUN cd /root/ && dpkg -i *.deb

# Download and compile DPDK
ARG DPDK_VER
RUN cd /usr/src/ &&  wget https://git.dpdk.org/dpdk/snapshot/dpdk-${DPDK_VER}.tar.gz && tar xzvf dpdk-${DPDK_VER}.tar.gz
ENV DPDK_DIR=/usr/src/dpdk-${DPDK_VER}
# Change 'RTE_MAX_LCORE', 128 to 'RTE_MAX_LCORE', 191
RUN cd $DPDK_DIR/x86/ && mv meson.build meson.build.bak && wget https://new-meson.build.raw
RUN cd $DPDK_DIR && meson build && ninja -C build

# Remove unnecessary packages and files
RUN rm -rf /tmp/* && rm /usr/src/dpdk-${DPDK_VER}.tar.gz
