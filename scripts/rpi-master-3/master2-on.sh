#!/bin/bash

source /etc/kubernetes/k8s.conf

while true
do
        nc -w2 $K8S_MASTER1_IP 8080 > /dev/null
        m1=$?
        nc -w2 $K8S_MASTER2_IP 8080 > /dev/null
        m2=$?

        if [ $m1 -ne 0 ] && [ $m2 -eq 0 ]; then
                echo "MASTER_IP=$K8S_MASTER2_IP" > /etc/kubernetes/masterip.conf
                systemctl daemon-reload
                systemctl stop k8s-master.service
                systemctl start k8s-master.service
                /opt/bin/master2-off.sh
                break
	elif [ $m1 -eq 0 ] && [ $m2 -eq 0 ]; then
                /opt/bin/master2-off.sh
                break
        fi
        sleep 2
done
