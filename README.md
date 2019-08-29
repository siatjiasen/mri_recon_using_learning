# mri_recon_using_learning

This script aims to create a docker image with tensorflow-icg for learning based MRI image reconstruction

1. Ubuntu 16.04
2. Nvidia docker 2
3. Cuda 8.0
4. Cudnn 7.0
5. Anaconda3 5.1.0
6. Python 3.6.0
7. Bazel 0.11.1
8. Tensorflow 1.5.0 with icg contribution

Two learning based MRI reconstruction methods:
1. Variational Network
2. Model based Deep Learning
could be realized based on created docker container.

References
VN              - https://github.com/VLOGroup/mri-variationalnetwork
MoDL            - https://github.com/hkaggarwal/modl
Tensorflow_icg  - https://github.com/VLOGroup/tensorflow-icg
Nvidia docker 2 - https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)
