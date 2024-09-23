# install config to CTFd 
sudo docker cp ctfd-config-v0.3.zip ctfd-ctfd-1:/tmp/
sudo docker exec ctfd-ctfd-1 python manage.py import_ctf /tmp/ctfd-config-v0.3.zip
