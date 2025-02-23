FROM ubuntu:24.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    git \
    curl \
    && add-apt-repository ppa:ettusresearch/uhd \
    && apt-get update \
    && apt-get install -y \
    fftw-dev \
    libboost-all-dev \
    libuhd-dev \
    uhd-host \
    libairspy-dev \
    libhackrf-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    cmake \
    build-essential \
    clang-format \
    clang-tidy \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Run UHD images downloader
RUN uhd_images_downloader

# Set working directory back to the project
WORKDIR /workspace/radio-telemetry-tracker-dsp4-package

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"