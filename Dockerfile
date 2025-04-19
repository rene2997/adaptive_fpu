FROM hseeberger/scala-sbt:11.0.14.1_1.6.2_2.13.8

# Dependencies for building the toolchain and Verilator
RUN apt-get update && apt-get install -y build-essential make gcc

# Set the container's working directory
WORKDIR /app

# Copy the whole repo so make/sbt/scripts can access it
COPY . .

# Download and extract the toolchain built for Ubuntu 20.04
RUN curl -LO https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2023.11.22/riscv64-elf-ubuntu-20.04-gcc-nightly-2023.11.22-nightly.tar.gz \
 && mkdir -p /opt/riscv \
 && tar -xzf riscv64-elf-ubuntu-20.04-gcc-nightly-2023.11.22-nightly.tar.gz -C /opt/riscv --strip-components=1 \
 && rm riscv64-elf-ubuntu-20.04-gcc-nightly-2023.11.22-nightly.tar.gz


ENV PATH="/opt/riscv/bin:$PATH"

CMD ["/bin/bash"]

RUN apt update && apt install -y gtkwave python iverilog x11-utils



# Install build dependencies for Verilator
RUN apt-get update && \
    apt-get install -y \
    git autoconf g++ flex bison make \
    libfl2 libfl-dev zlib1g-dev \
    libgoogle-perftools-dev numactl perl \
    libexpat1-dev libunwind-dev \
    help2man libbz2-dev \
    libncurses5-dev libncursesw5-dev \
    ccache

# Clone and build Verilator from source
RUN git clone https://github.com/verilator/verilator.git /opt/verilator && \
    cd /opt/verilator && \
    git checkout v5.034 && \
    autoconf && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf /opt/verilator

ENV PATH="/usr/local/bin:$PATH"
