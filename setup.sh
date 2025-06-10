#!/bin/bash
pip install -r requirements.txt
python setup.py develop
pip install cython
pip install 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
pip install cython_bbox
pip install mmcv-full==1.7.1 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11.0/index.html
pip install -v -e .
