# step 1. Pull a docker image with CUDA 8.0 in ubuntu 16.04. 
#         Note: Nvidia provided docker image with cudnn being installed via debian installation.
#         However, the debian installation uses other include and library paths than expected by tensorflow.
#         Thus, tar-file installation was recommended for Ubuntu
$ sudo docker pull nvidia/cuda:8.0-devel-ubuntu16.04

# step 2. Create a docker container with nvidia runtime
#         Note: Training using multiple GPUs was not supported, thus only one GPU was used. 
$ sudo docker run -it --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 --name=gpu_tf \
           --network=host --volume $(pwd):/opt/tf_data IMAGE_ID /bin/bash

# The following steps run in /bin/bash of created docker container

# step 3. Install cudnn 7.0 using tar file installer downloaded from Nvidia
$ tar -xzvf cudnn-8.0-linux=x64-v7.tgz
$ cp /cuda/include/cudnn.h /usr/local/cuda/include
$ cp /cuda/lib64/libcudnn* /usr/local/cuda/lib64
$ chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# step 4. Install Anaconda with Python 3.6 downloaded from Anaconda arxiv
#          Anaconda3-5.1.0 was used which provided Python 3.6.4
#          During installation, Default options were recommended.
$ bash Anaconda3-5.1.0-Linux-x86_64.sh
$ source .bashrc
$ conda list

# step 5. Install bazel 0.11.1 using sh file installer downloaded from bazel github
#          Dependencies were required, see Bazel installation guide
$ apt-get install pkg-config zip g++ zlib1g-dev unzip
$ chmod +x bazel-0.11.1-installer-linux-x86_64.sh
$ ./bazel-0.11.1-installer-linux-x86_64.sh


# step 6. Add PATH and LD_LIBRARY_PATH in ~/.bashrc 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64
export PATH=$PATH:/usr/local/bin
$ source .bashrc

# step 7. Create a conda environment for tensorflow
#          After run ./configure command, check and answer the promopts
#          Make sure python 3.6 was used instead of the newer 3.7
$ conda env create -f <path-to-icg-tensorflow-repo>/anaconda_env_tficg.yml
$ cd /tensorflow_icg
$ source activate tficg
$ ./configure


# step 8. Build tensorflow_icg
#         Note: After finished building, a pip install command in red would be displayed 
#	 pip install /tmp/tensorflow_pkg/tensorflow-1.5.0-cp36-cp36m-linux_x86_64.whl --upgrade
$ bash build.sh
$ source deactivate
$ pip install /tmp/tensorflow_pkg/tensorflow-1.5.0-cp36-cp36m-linux_x86_64.whl --upgrade

# step 9. Test tensorflow_icg and run a pre-trained model for MR image reconstruction
$ python3
>>>import tensorflow as tf
>>>print(help(tf.contrib.icg))
>>>exit()

# step 10. Docker container commit, save to a docker image and distribute
$ sudo docker container ls -a
$ sudo docker commit gpu_tf nvidia/cuda:8.0-devel-ubuntu16.04-cudnn7-tensorflowicg1.5
$ sudo docker image ls -activate
$ sudo docker save image_id > tensorflowicg_mri




