sudo snap install microk8s --classic --channel=1.30
sudo usermod -a -G microk8s $USER
mkdir -p $(pwd)/.kube
chmod 0700 $(pwd)/.kube
newgrp microk8s

