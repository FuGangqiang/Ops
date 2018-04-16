#!/bin/sh

for item in "ca" "etcd" "kubernetes" "admin" "kube-proxy"
do
    rm -rf ${item}.csr
    rm -rf ${item}.pem
    rm -rf ${item}-key.pem
done
