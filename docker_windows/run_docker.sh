#!/bin/bash

# Modify these paths and GPU ids
MS3D_PATH=`pwd`/..
DATA_PATH="${MS3D_PATH}/data"
CODE_PATH="${MS3D_PATH}/"
GPU_ID="0"

ENVS="  --env=NVIDIA_VISIBLE_DEVICES=$GPU_ID
        --env=CUDA_VISIBLE_DEVICES=$GPU_ID
        --env=NVIDIA_DRIVER_CAPABILITIES=all"

VOLUMES="       --volume=$DATA_PATH:/MS3D/data"

# Setup environmetns for pop-up visualization of point cloud (open3d)
#VISUAL="        --env=DISPLAY
#                --env=QT_X11_NO_MITSHM=1
#                --volume=/tmp/.X11-unix:/tmp/.X11-unix"
#xhost +local:docker

echo "Running the docker image [GPUS: ${GPU_ID}]"
docker_image="ms3d"

# Start docker image
docker  run -it --rm \
        $VOLUMES \
        $ENVS \
        $VISUAL \
        --mount type=bind,source=$CODE_PATH,target=/MS3D \
        --runtime=nvidia \
        --gpus $GPU_ID \
        --privileged \
        --net=host \
        --ipc=host \
        --shm-size=30G \
        --workdir=/MS3D \
        $docker_image
