#!/bin/bash

docker rm ms3d
sudo service docker stop
sudo apt-get remove -y docker-ce docker-ce-cli containerd.io
sudo apt-get remove -y nvidia-docker2 nvidia-cuda-toolkit
sudo apt-get update
