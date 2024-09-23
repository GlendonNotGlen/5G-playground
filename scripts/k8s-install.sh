### Code for installing microk8s, run it BEFORE k8s-setup.sh
sudo snap install microk8s --classic --channel=1.30
# Allow user to run microk8s commands
sudo usermod -a -G microk8s $USER
# Allow user to gain access to the .kube caching directory
mkdir -p ../.kube
chmod 0700 ../.kube
# Apply group changes in the current session
newgrp microk8s

