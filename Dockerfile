FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# 시스템 패키지 설치
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Python 3.8을 기본 Python으로 설정
RUN ln -sf /usr/bin/python3.8 /usr/bin/python
RUN ln -sf /usr/bin/python3.8 /usr/bin/python3

# pip 업그레이드
RUN python -m pip install --upgrade pip

# 작업 디렉토리 설정
WORKDIR /workspace

# PyTorch 및 기타 필수 패키지 설치
RUN pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install mmcv-full==1.7.1 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11.0/index.html

# 프로젝트 의존성 설치를 위한 requirements.txt 복사 및 설치
COPY requirements.txt .
RUN pip install -r requirements.txt

# 기본 명령어 설정
CMD ["/bin/bash"] 