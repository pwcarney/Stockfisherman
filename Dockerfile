# Use an official Python image with Ubuntu as the base
FROM python:3.9-slim

# Install dependencies for building Stockfish
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/src/app

# Clone the Stockfish submodule
RUN git clone --recurse-submodules https://github.com/yourusername/stockfisherman.git .

# Navigate to the Stockfish directory
WORKDIR /usr/src/app/Stockfish

# Build Stockfish
RUN make build ARCH=x86-64-modern

# Return to the app directory
WORKDIR /usr/src/app

# Copy any additional project files (e.g., Python scripts, API code)
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the entrypoint to Stockfish or your Python script
ENTRYPOINT ["./Stockfish/src/stockfish"]
# Or, if you want to run a Python script:
# ENTRYPOINT ["python", "your_script.py"]
