This is a simple tool to create local kubernetes cluster.

OS requirements: Linux or MacOS

To be able to use this tool you have to have installed following software:
Virtual Box: https://www.virtualbox.org/wiki/Downloads
Vagrant: https://www.vagrantup.com/downloads.html
Docker: https://www.docker.com/products/docker-desktop

Usage:
    ```./cluster.sh status``` - display cluster status
    ```./cluster.sh create``` - to create the cluser. After executing this command you will be asked to enter number of nodes
    ```./cluster.sh start``` - start previoselly created cluster
    ```./cluster.sh suspend``` - freez current cluster and free used resources
    ```./cluster.sh destroy``` - destroy cluster



Default configs:
    Default configs can be overwritten in Vagrantfile
    network = '192.168.47.0/24'
    cpu_num = 2
    memory = 2048
