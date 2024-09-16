### CTFd code
# Install Docker via Snap
sudo snap install docker
# Install Git
sudo apt install git
# Clone the CTFd repository into the current working directory
git clone https://github.com/CTFd/CTFd.git $(pwd)/CTFd
# Copy custom configuration to the CTFd folder (change nginx port from 80 to 8080)
rm $(pwd)/CTFd/docker-compose.yml
cp $(pwd)/5G-playground/scripts/docker-compose.yml $(pwd)/CTFd/docker-compose.yml
# Generate a 64-character secret key and store it in the .ctfd_secret_key file in the CTFd directory
head -c 64 /dev/urandom > $(pwd)/CTFd/.ctfd_secret_key
# Change directory to the CTFd folder in the current working directory
cd $(pwd)/CTFd
# Start CTFd using Docker Compose
sudo docker-compose up

