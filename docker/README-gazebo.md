# Gazebo docker container

These instructions assume you have NVIDIA drivers correctly installed in the host 
machine. And nvidia-modprobe installed as well (sudo apt install nvidia-modprobe).

## Prerequisites
Install nvidia-docker-plugin binary (https://github.com/NVIDIA/nvidia-docker/wiki/Installation)

### About nvidia-docker-plugin
This plugin allows the host video drivers to be used in docker containers
without installing any drivers in the containers themselves.
Once the system requirements are met (nvidia drivers & nvidia-modprobe)
the plugin can be
[installed from a deb](https://github.com/NVIDIA/nvidia-docker/releases)
using `dpkg -i`.
The system should be restarted again after installing the plugin.

* Test the plugin works:
```
# Test nvidia-smi
$ nvidia-docker run --rm nvidia/cuda nvidia-smi
```
* And you should see output similar to this one:

``` 
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 367.57                 Driver Version: 367.57                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 660M    Off  | 0000:01:00.0     N/A |                  N/A |
| N/A   48C    P8    N/A /  N/A |    261MiB /  1990MiB |     N/A      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID  Type  Process name                               Usage      |
|=============================================================================|
|    0                  Not Supported                                         |
+-----------------------------------------------------------------------------+
```

Once the plugin has been used at least once, it should appear in docker info:

```
$ docker info
...
Plugins:
 Volume: local nvidia-docker
 Network: host bridge null
...
```

It should also have created a docker volume after that first test:

```
$ docker volume ls
DRIVER              VOLUME NAME
nvidia-docker       nvidia_driver_367.57
```

More information about the plugin: https://github.com/NVIDIA/nvidia-docker/wiki/nvidia-docker-plugin


## Build
Now, from the docker directory build the docker images, build the main image. 
This is the one that will be used afterwards:
```
$ ./build-images.sh
```
This script will create a set of docker images, namely: 
* gazebo
* nvidia-gazebo
* nvidia-gazebo-ros
* src-cloudsim

Each image is built on top of the others.

## Run
Once the image was built, you can run it by:
```
$ ./run_container.bash gazebo src-cloudsim /bin/bash
```
Among other things, the run_container.sh script will check that you have nvidia-docker-plugin installed
and launch the container with nvidia arguments. 

Once inside the running docker container, you could for example run: 
```
$ gazebo --verbose worlds/pioneer2dx.world
```

## More Info
https://hub.docker.com/_/gazebo/
