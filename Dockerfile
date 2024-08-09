# Use NVIDIA's official CUDA image as the base
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# Install dependencies for building Stockfish
RUN apt-get update && apt-get install -y \
    python3-pip \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/src/app

# Clone the Stockfish submodule
RUN git clone --recurse-submodules https://github.com/pwcarney/stockfisherman.git .
RUN git pull

# Ensure submodules are updated
RUN git submodule update --init --recursive

# Navigate to the Stockfish src directory
WORKDIR /usr/src/app/Stockfish/src

# Build Stockfish
RUN make ARCH=x86-64-sse41-popcnt

# Return to the app directory
WORKDIR /usr/src/app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the entrypoint to Stockfish or your Python script
ENTRYPOINT ["./Stockfish/src/stockfish"]
