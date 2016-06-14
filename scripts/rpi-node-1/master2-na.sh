#!/bin/bash

source /etc/kubernetes/k8s.conf

while true
do
        nc -w2 $K8S_MASTER1_IP 8080 > /dev/null
        m1=$?
        nc -w2 $K8S_MASTER2_IP 8080 > /dev/null
        m2=$?

        if [ $m1 -ne 0 ] && [ $m2 -ne 0 ]; then
                echo "MASTER_IP=$K8S_MASTER3_IP" > /etc/kubernetes/masterip.conf
		sed -i 's/--api-servers=.*/--api-servers=http:\/\/${K8S_MASTER3_IP}:8080 \\/1' /lib/systemd/system/k8s-worker.service
                systemctl daemon-reload
                systemctl stop k8s-worker.service
                systemctl start k8s-worker.service
                /opt/bin/master2-a.sh
                break
        fi
        sleep 2
done
