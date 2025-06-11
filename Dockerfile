FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Install system packages and Miniconda
RUN apt-get update && apt-get install -y \
    python3.8 python3.8-dev python3-pip \
    git wget bzip2 curl \
    libgl1 libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    ln -sf /usr/bin/python3.8 /usr/bin/python && \
    ln -sf /usr/bin/python3.8 /usr/bin/python3 && \
    python -m pip install --upgrade pip && \
    $CONDA_DIR/bin/conda clean -afy

# Set working directory
WORKDIR /workspace

# Copy requirements
COPY requirements.txt .

# Setup conda environment and install dependencies
RUN /bin/bash -c "\
    source $CONDA_DIR/etc/profile.d/conda.sh && \
    conda init bash && \
    conda create -n scit python=3.8 -y && \
    echo 'source $CONDA_DIR/etc/profile.d/conda.sh && conda activate scit' >> ~/.bashrc && \
    conda activate scit && \
    pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html && \
    pip install mmcv-full==1.7.1 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11.0/index.html && \
    pip install -r /workspace/requirements.txt && \
    conda clean -afy \
"

# Default shell
CMD ["bash", "-c", "source ~/.bashrc && exec bash"]
