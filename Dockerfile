FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# Install system packages
RUN apt-get update && apt-get install -y \
    python3.8 python3.8-dev python3-pip \
    git wget bzip2 && \
    rm -rf /var/lib/apt/lists/*

# Set Python 3.8 as default
RUN ln -sf /usr/bin/python3.8 /usr/bin/python && \
    ln -sf /usr/bin/python3.8 /usr/bin/python3 && \
    python -m pip install --upgrade pip

# Set working directory
WORKDIR /workspace

# Install Miniconda
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh

# Setup conda, create env, install packages
RUN /bin/bash -c "\
    source $CONDA_DIR/etc/profile.d/conda.sh && \
    conda init bash && \
    conda create -n scit python=3.8 -y && \
    echo 'source $CONDA_DIR/etc/profile.d/conda.sh && conda activate scit' >> ~/.bashrc && \
    conda activate scit && \
    pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html && \
    pip install mmcv-full==1.7.1 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11.0/index.html \
"

# Install requirements
COPY requirements.txt .
RUN /bin/bash -c "source ~/.bashrc && conda activate scit && pip install -r requirements.txt"

# Default shell
CMD ["bash", "-c", "source ~/.bashrc && exec bash"]
