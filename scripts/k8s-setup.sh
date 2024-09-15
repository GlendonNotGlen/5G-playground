### Code for installing microk8s, run it AFTER k8s-install.sh
microk8s status --wait-ready
# installation of add-ons
microk8s enable host-access
microk8s enable hostpath-storage
microk8s enable dns
microk8s enable ingress
microk8s enable metallb:192.168.137.240-192.168.137.250
microk8s kubectl apply -f $(pwd)/test1/helms/addresspool.yaml

# using helm charts to set up environment (open5gs and UERANSIM)
microk8s kubectl create namespace your-namespace
microk8s kubectl config set-context --current --namespace=your-namespace
microk8s helm install my-open5gs $(pwd)/test1/open5gs-2.2.3/open5gs --namespace your-namespace --values $(pwd)/test1/helms/5gSA-values.yaml
microk8s helm install my-ueransim-gnb $(pwd)/test1/ueransim-gnb-0.2.6/ueransim-gnb --namespace your-namespace --values $(pwd)/test1/helms/my-gnb-ues-values.yaml

# setting up of vulnerable web server
# requires building of docker image because github maximum file size is 100MB
sudo snap install docker
sudo docker build $(pwd)/test1/php1 -t my-php-app:1.0.0
sudo docker save my-php-app:1.0.0 > $(pwd)/test1/php1/my-php-app.tar
microk8s ctr image import $(pwd)/test1/php1/my-php-app.tar
microk8s helm install phpfpm-nginx-release $(pwd)/test1/phpfpm-nginx-chart --namespace your-namespace


### if there are errors, upgrading the deployment may work sometimes
#microk8s helm upgrade my-open5gs $(pwd)/test1/open5gs-2.2.3/open5gs --namespace your-namespace --values $(pwd)/test1/helms/5gSA-values.yaml
#microk8s helm upgrade my-ueransim-gnb $(pwd)/test1/ueransim-gnb-0.2.6/ueransim-gnb --namespace your-namespace --values $(pwd)/test1/helms/my-gnb-ues-values.yaml
#microk8s helm upgrade phpfpm-nginx-release $(pwd)/test1/phpfpm-nginx-chart --namespace your-namespace


### uninstall helm charts, when done OR if errors cannot be fixed, uninstall and reinstall
#microk8s helm uninstall -n your-namespace phpfpm-nginx-release
#microk8s helm uninstall -n your-namespace my-ueransim-gnb
#microk8s helm uninstall -n your-namespace my-open5gs

