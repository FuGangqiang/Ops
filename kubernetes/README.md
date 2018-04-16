# kubernetes 虚拟部署步骤


## 版本

* debian9
* etcd 3.2.15
* docker-ce 17.12.0
* flanneld 0.10.0
* kubernetes 1.9.2


## 节点

IP       | host                    |  service
---------|-------------------------|------------------------------------------------------------------------
10.0.0.2 | kube-master, etcd-node2 | flanneld, kube-apiserver, kube-controller-manager, kube-scheduler, etcd
10.0.0.3 | kube-node3, etcd-node3  | flanneld, docker, kubelet, etcd
10.0.0.4 | kube-node4, etcd-node4  | flanneld, docker, kubelet, etcd
10.0.0.5 | kube-node5              | flanneld, docker, kubelet

注：

* node 尾数命名是按照 ip 末尾数字命名


## 网络

ip block      | name
--------------|--------
172.30.0.0/16 | 集群网络
10.0.0.0/8    | 物理网络


## 虚拟机集群部署步骤

1. 在 github 网站下载所需二进制压缩包
    - [etcd](https://github.com/coreos/etcd/releases)
    - [flanneld](https://github.com/coreos/flannel/releases)
    - [kubernetes-node, kubernetes-server](https://github.com/kubernetes/kubernetes/releases)
1. 修改 `vars/global.yaml` 文件对应的二进制压缩包文件名称
1. 配置 `/etc/ansible/hosts` 文件

    ```
    cat > /etc/ansible/hosts <<EOF
    [etcd]
    10.0.0.2
    10.0.0.3
    10.0.0.4

    [kube-master]
    10.0.0.2

    [kube-node]
    10.0.0.3
    10.0.0.4
    10.0.0.5
    EOF
    ```

1. 配置 `ansible/roles/hosts/files/hosts` 文件

    ```
    127.0.0.1   localhost
    ::1         localhost ip6-localhost ip6-loopback

    10.0.0.2  kube-master
    10.0.0.3  kube-node3
    10.0.0.4  kube-node4
    10.0.0.5  kube-node5

    10.0.0.2  etcd-node2
    10.0.0.3  etcd-node3
    10.0.0.4  etcd-node4
    ```

1. 生成 ssl 密钥

    ```
    cd ansible/roles/cluster/files
    ./generate.sh
    ```

1. 创建 `vagrant` 虚拟机集群

    ```
    vagrant up
    ```

1. 测试所有虚拟机是否正常工作

    ```
    ansible -u root -m ping all
    ```

1. 部署 `kube-cluster`

    ```
    ansible-playbook -u root ansible/kube-cluster.yaml
    ```

1. yaml

    ```
    kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
    ```

1. 部署 `docker私有镜像仓库`

    ```
    https://github.com/vmware/harbor
    ```
