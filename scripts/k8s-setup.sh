### Code for installing microk8s, run it AFTER k8s-install.sh
microk8s status --wait-ready
# installation of add-ons
microk8s enable host-access
microk8s enable hostpath-storage
microk8s enable dns
microk8s enable ingress
microk8s enable metallb:192.168.137.240-192.168.137.250 ### change this based on IP address of VM


# Get the first IP of the host (assuming it is on the desired interface)
HOST_IP=$(hostname -I | awk '{print $1}')
# Calculate the subnet of the HOST_IP (e.g., 192.168.137.0)
SUBNET=$(echo "$HOST_IP" | awk -F. '{print $1"."$2"."$3".0"}')
### ENSURE THAT HOST IP DOES NOT FALL INTO THIS RANGE
# Define the start and end of the IP range within the same subnet
START_IP=$(echo "$HOST_IP" | awk -F. '{print $1"."$2"."$3".220"}')
END_IP=$(echo "$HOST_IP" | awk -F. '{print $1"."$2"."$3".222"}')
# Generate the addresspool.yaml dynamically with the correct IP range
cat <<EOF > $(pwd)/5G-playground/helms/addresspool.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: custom-addresspool
  namespace: metallb-system
spec: 
  addresses:
  - ${START_IP}-${END_IP}
EOF

# Apply the addresspool.yaml to Kubernetes
microk8s kubectl apply -f $(pwd)/5G-playground/helms/addresspool.yaml

# using helm charts to set up environment (open5gs and UERANSIM)
microk8s kubectl create namespace your-namespace
microk8s kubectl config set-context --current --namespace=your-namespace
microk8s helm install my-open5gs $(pwd)/5G-playground/open5gs-2.2.3/open5gs --namespace your-namespace --values $(pwd)/5G-playground/helms/5gSA-values.yaml
echo "sleeping for 360s for open5gs to set up properly"
sleep 360s
microk8s helm install my-ueransim-gnb $(pwd)/5G-playground/ueransim-gnb-0.2.6/ueransim-gnb --namespace your-namespace --values $(pwd)/5G-playground/helms/my-gnb-ues-values.yaml

# setting up of vulnerable web server
# requires building of docker image because github maximum file size is 100MB
sudo snap install docker
sudo docker build $(pwd)/5G-playground/php1 -t my-php-app:1.0.0
sudo docker save my-php-app:1.0.0 > $(pwd)/5G-playground/php1/my-php-app.tar
microk8s ctr image import $(pwd)/5G-playground/php1/my-php-app.tar



# Get Endpoint IPs from Kubernetes
ENDPOINT_IPS=$(microk8s kubectl get endpoints my-open5gs-webui -o jsonpath='{.subsets[*].addresses[*].ip}')
# Replace the last tuple with '1'
MODIFIED_IPS=$(echo $ENDPOINT_IPS | awk -F'.' '{print $1"."$2"."$3".1"}')

# Generate the values.yaml dynamically
cat <<EOF > $(pwd)/5G-playground/phpfpm-nginx-chart/values.yaml
namespace: your-namespace
phpImage:
  repository: my-php-app
  tag: 1.0.0
nginxImage:
  repository: nginx
  tag: 1.7.9
service:
  type: ClusterIP
  port: 80
  targetPort: 80
ingress:
  enabled: true
  whitelist: "$HOST_IP/32,$MODIFIED_IPS/24"
  host: my-php-app.local
EOF

# actually installing the helm chart for web server
microk8s helm install phpfpm-nginx-release $(pwd)/5G-playground/phpfpm-nginx-chart --namespace your-namespace


### if there are errors, upgrading the deployment may work sometimes
#microk8s helm upgrade my-open5gs $(pwd)/5G-playground/open5gs-2.2.3/open5gs --namespace your-namespace --values $(pwd)/5G-playground/helms/5gSA-values.yaml
#microk8s helm upgrade my-ueransim-gnb $(pwd)/5G-playground/ueransim-gnb-0.2.6/ueransim-gnb --namespace your-namespace --values $(pwd)/5G-playground/helms/my-gnb-ues-values.yaml
#microk8s helm upgrade phpfpm-nginx-release $(pwd)/5G-playground/phpfpm-nginx-chart --namespace your-namespace


### uninstall helm charts, when done OR if errors cannot be fixed, uninstall and reinstall
#microk8s helm uninstall -n your-namespace phpfpm-nginx-release
#microk8s helm uninstall -n your-namespace my-ueransim-gnb
#microk8s helm uninstall -n your-namespace my-open5gs
