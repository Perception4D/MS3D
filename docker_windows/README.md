# How to install/run MS3D in a Docker container on Windows 11?

1. Install CUDA Toolkit 11.8.0
  https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_522.06_windows.exe

2. Enable/Install WSL2
   - If not already installed, follow the instructions here https://learn.microsoft.com/en-us/windows/wsl/install

3. Clone MS3D directory: git@github.com:Perception4D/MS3D.git

4. Install Docker & CUDA in WSL
   - Start WSL2 command line
   - go to MS3D/docker_windows directory
   - run `install_docker_and_cuda.sh`

6. Launch the MS3D docker image
   - run `run_docker.sh`
   - in the docker command line, run `docker_init_commands.sh`

