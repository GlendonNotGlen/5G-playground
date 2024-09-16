### CTFd code
# Install Docker via Snap
sudo snap install docker
# Install Git
sudo apt install git
# Clone the CTFd repository into the current working directory
git clone https://github.com/CTFd/CTFd.git $(pwd)/CTFd
# Generate a 64-character secret key and store it in the .ctfd_secret_key file in the CTFd directory
head -c 64 /dev/urandom > $(pwd)/CTFd/.ctfd_secret_key
# Change directory to the CTFd folder in the current working directory
cd $(pwd)/CTFd
# Start CTFd using Docker Compose
sudo docker-compose up
# install config to CTFd 
sudo docker cp $(pwd)/5G-playground/scripts/ctfd-config-v0.2.zip ctfd-ctfd-1:/tmp/
sudo docker exec ctfd-ctfd-1 python manage.py import_ctf /tmp/ctfd-config-v0.2.zip
