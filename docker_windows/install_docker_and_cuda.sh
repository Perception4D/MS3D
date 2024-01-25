#!/bin/bash

# INSTALLATION SCRIPT FOR WINDOWS 11 WSL2
# From https://grand-challenge.org/documentation/setting-up-wsl-with-gpu-support-for-windows-11/
# WSL2 must be installed first, in command line:
#  > wsl.exe –-install -d Ubuntu
#  > wsl.exe –-update

# In case you get the following error:
#   /sbin/ldconfig.real: /usr/lib/wsl/lib/libcuda.so.1 is not a symbolic link
# To solve it, open cmd as administrator and type:
# > cd C:\Windows\System32\lxss\lib
# > del libcuda.so
# > del libcuda.so.1
# > wsl -e /bin/bash
#   $ ln -s libcuda.so.1.1 libcuda.so.1
#   $ ln -s libcuda.so.1.1 libcuda.so

# INSTALL DOCKER
echo "STEP 1 - DOCKER SUPPORT INSTALLATION"
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker $USER

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

newgrp docker << END

# CHECK DOCKER INSTALL IS OK
docker run hello-world

# GET NVIDIA CONTAINER TOOLKIT
echo "STEP 2 - INSTALL NVIDIA CONTAINER FOR DOCKER"
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2 nvidia-cuda-toolkit
sudo service docker restart

# TEST NVIDIA CUDA WITH CUDA
docker run --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark

# NOW FETCH AND BUILD MS3D DOCKER IMAGES
# Note: we cannot run darrenjkt/openpcdet directly as it contains some libraries (nvidia/cuda/etc) that
# interact with the one we installed locally so we build a new docker image where we delete thos files
# - see https://github.com/NVIDIA/nvidia-docker/issues/1551
echo "STEP 3 - FETCH AND BUILD MS3D DOCKER IMAGES"
docker pull darrenjkt/openpcdet:v0.6.0
docker build -t ms3d - < WSL2Dockerfile

echo "DONE."
echo ""
echo "You can now type ./run_docker to start MS3D docker."
END
