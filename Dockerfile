FROM hseeberger/scala-sbt:11.0.14.1_1.6.2_2.13.8

# Install make and gcc (for wildcat toolchain)
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

RUN apt-get update && \
    apt-get install -y verilator
