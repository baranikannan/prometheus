#!/bin/bash
FILE=iso/ubuntu-14.04.5-server-amd64.iso

if ! [ -x "$(command -v packer)" ]; then
  echo 'Error: packer is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v vboxmanage)" ]; then
  echo 'Error: vboxmanage is not installed.' >&2
  exit 1
fi

if [ ! -f "$FILE" ]
then
    echo "Downloading ISO file to avoid repeated download of every time"
    wget -O iso/ubuntu-14.04.5-server-amd64.iso  http://nl.releases.ubuntu.com/releases/14.04.5/ubuntu-14.04.5-server-amd64.iso
fi

#packer build ubuntu-14.04.5.json

vboxmanage import output/packer-ubuntu-14.04.5-amd64.ovf
VBoxManage modifyvm packer-ubuntu-14.04.5-amd64 --nic1 bridged --bridgeadapter1 "en0: Wi-Fi (AirPort)"
VBoxManage startvm packer-ubuntu-14.04.5-amd64
sleep 300
VBoxManage controlvm packer-ubuntu-14.04.5-amd64 poweroff
sleep 100
VBoxManage startvm packer-ubuntu-14.04.5-amd64
echo "script completed"
echo "OS login : kaltura / kaltura"
echo "Prometheus console URL : http://<IP>:9090"
echo "Prometheus Node URL : http://<IP>:9100"
echo "Graphite console URL : http://<IP>"
echo "username:pwd  root:root"
echo "Grafana URL : http://<IP>:3000"
echo "username:pwd  admin:pass123"
echo "Services running: bridge grafana-server prometheus prometheus_node"
echo "Docker instance: graphite"

