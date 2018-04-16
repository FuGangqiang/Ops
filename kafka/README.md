# kafka 虚拟部署步骤


## 操作系统

* debian9


## 节点

IP       | service
---------|-----------------
10.0.0.2 | zookeeper, kafka
10.0.0.3 | zookeeper, kafka
10.0.0.4 | zookeeper, kafka


## 虚拟机集群部署步骤

1. 配置 `/etc/ansible/hosts` 文件

    ```
    cat > /etc/ansible/hosts <<EOF
    [zookeeper]
    10.0.0.2
    10.0.0.3
    10.0.0.4

    [kafka]
    10.0.0.2
    10.0.0.3
    10.0.0.4
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

    10.0.0.2  kafka-node2
    10.0.0.3  kafka-node3
    10.0.0.4  kafka-node4
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
    ansible-playbook -u root ansible/kafka.yaml
    ```
