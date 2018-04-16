# mesos 虚拟部署步骤


## 操作系统

* debian9


## 节点

IP       | service
---------|----------------------------------------------------------------
10.0.0.2 | zookeeper, mesos-master, marathon, chronos
10.0.0.3 | zookeeper, mesos-master, marathon, chronos, mesos-slave, docker
10.0.0.4 | zookeeper, mesos-master, marathon, chronos, mesos-slave, docker
10.0.0.5 | mesos-slave, docker, mesos-dns


## 虚拟机集群部署步骤

1. 配置 `/etc/ansible/hosts` 文件

    ```
    cat > /etc/ansible/hosts <<EOF
    [zookeeper]
    10.0.0.2
    10.0.0.3
    10.0.0.4

    [mesos-master]
    10.0.0.2
    10.0.0.3
    10.0.0.4

    [mesos-slave]
    10.0.0.3
    10.0.0.4
    10.0.0.5

    [mesos-frameworks]
    10.0.0.2

    [mesos-dns]
    10.0.0.5
    EOF
    ```

1. 配置 `/etc/hosts` 文件

    ```
    cat > /etc/hosts <<EOF
    127.0.0.1   localhost
    ::1         localhost ip6-localhost ip6-loopback

    10.0.0.2  zookeeper-node2
    10.0.0.3  zookeeper-node3
    10.0.0.4  zookeeper-node4

    10.0.0.2  mesos-master2
    10.0.0.3  mesos-master3
    10.0.0.4  mesos-master4

    10.0.0.3  mesos-slave3
    10.0.0.4  mesos-slave4
    10.0.0.5  mesos-slave5

    10.0.0.2 mesos-frameworks
    10.0.0.5  mesos-dns
    EOF
    ```

1. 创建 `vagrant` 虚拟机集群

    ```
    vagrant up
    ```

1. 测试所有虚拟机是否正常工作

    ```
    ansible -u root -m ping all
    ```

1. 部署 `mesos-cluster`

    ```
    ansible-playbook -u root ansible/mesos-cluster.yaml
    ```

1. 访问 url

* mesos-master ui: http://10.0.0.2:5050
* marathon ui: http://10.0.0.2:8080

1. 部署 `docker私有镜像仓库`

    ```
    https://github.com/vmware/harbor
    ```
