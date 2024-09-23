<h1 id="bkmrk-getting-ready">Getting Ready</h1>
<p id="bkmrk-get-a-ready-an-ubunt">Get ready an Ubuntu VM with <strong>at least 40GB of storage.</strong>&nbsp;</p>
<p id="bkmrk-highly-recommended-t">Highly recommended to have a <strong>clean snapshot of the VM</strong> before proceeding with the installation.</p>
<p id="bkmrk-recommended-to-have-">Recommended to have <strong>at least 8GB of RAM</strong> and at least 4 cores.&nbsp;</p>
<p id="bkmrk-clone-the-github-pro">Clone the GitHub project.&nbsp;</p>
<pre id="bkmrk-git-clone-https%3A%2F%2Fgi"><code class="language-shell">git clone https://github.com/hack-techv2/5G-playground\git clone git@github.com:hack-techv2/5G-playground.git</code></pre>
<h1 id="bkmrk-installing-the-setup">Installing the setup</h1>
<p id="bkmrk-run-the-two-installa">Run the four installation scripts from the /scripts folder.</p>
<p id="bkmrk-note%3A-ensure-the-dir">NOTE: Ensure the directories match the below commands. If not, please make the necessary changes.</p>
## Installing the setup

```bash
chmod +x ./5G-playground/scripts/k8s-install.sh
chmod +x ./5G-playground/scripts/k8s-setup.sh
chmod +x ./5G-playground/scripts/ctfd-install.sh
chmod +x ./5G-playground/scripts/ctfd-setup.sh
```

### Run the scripts from the same directory where the project is cloned

```bash
./5G-playground/scripts/k8s-install.sh
./5G-playground/scripts/k8s-setup.sh
./5G-playground/scripts/ctfd-install.sh

# Wait until the ctfd-install has finished installing before running the ctfd-setup script!

./5G-playground/scripts/ctfd-setup.sh
```
<blockquote id="bkmrk-note%3A-the-ctfd-insta">
<p id="bkmrk-note%3A-the-ctfd-scrip">NOTE: The ctfd-install script does NOT terminate. Read the output in the terminal to determine when the containers are up.&nbsp;</p>
<p>Should be able to see "ctfd-ctfd-1 &nbsp; | db is ready" message.&nbsp;</p>
</blockquote>
<p id="bkmrk-access-ctfd-platform">Access CTFd platform through a browser with <a href="http://127.0.0.1:8000">http://127.0.0.1:8000</a></p>
<p id="bkmrk-the-ctfd-platform-sh">The CTFd platform should be accessible through other VMs with http://[IP]:8000</p>
<blockquote id="bkmrk-admin-account-is-adm">
<p>Admin account is admin:admin</p>
<p>Username: admin</p>
<p>Password: admin</p>
</blockquote>
<p id="bkmrk-"><a href="ctfd-1.png" target="_blank" rel="noopener"><img src="https://github.com/hack-techv2/5G-playground/blob/master/Images/ctfd-1.png" alt="Screenshot 2024-09-16 142328.png"></a></p>
<p id="bkmrk-wait-for-5-10-min-af">Wait for 5-10 min after the installation process has completed for the open5GS setup to be fully functional.</p>
<h1 id="bkmrk-check-everything-is-">Check everything is working</h1>
<p id="bkmrk-check-that-pods-are-">Check that pods are running using&nbsp;</p>
<pre id="bkmrk-microk8s-kubectl-get"><code class="language-shell">microk8s kubectl get pods -n your-namespace\microk8s kubectl get services -n your-namespace\microk8s kubectl get endpoints -A</code></pre>
<p id="bkmrk-check-that-the-netwo">Check that the network is fully functional:</p>
<pre id="bkmrk-kubectl-exec--it-dep"><code class="language-shell">microk8s kubectl -n your-namespace exec -ti deployment/my-ueransim-gnb-ues -- /bin/bash\### inside pod\ip a\ping -I uesimtun0 1.1.1.1\### ip should have interface uesimtun0\### should be able to have WAN connectivity</code></pre>
<p id="bkmrk-example-of-working-s">Example of working setup for microk8s:</p>
<p id="bkmrk--0"><a href="microk8s-working.png" target="_blank" rel="noopener"><img src="https://github.com/hack-techv2/5G-playground/blob/master/Images/microk8s-working.png" alt="image-1726399892823.png" width="524" height="238"></a></p>
<p id="bkmrk-example-of-functiona">Example of functional open5Gs setup:</p>
<p id="bkmrk--1"><a href="open5gs-working.png" target="_blank" rel="noopener"><img src="https://github.com/hack-techv2/5G-playground/blob/master/Images/open5gs-working.png" alt="image-1726408615647.png"></a></p>
<p id="bkmrk-%C2%A0-0">After setting up the infrastructure, prepare another Kali VM as the "attacking machine". Ensure connectivity between the Kali and Ubuntu VM.</p>
<h1 id="bkmrk-troubleshooting">Troubleshooting</h1>
<p id="bkmrk-try-upgrading-the-he">Try upgrading the Helm deployments</p>
<pre id="bkmrk-%23%23%23-if-having-issues"><code class="language-shell">### if having issues with 5G network\microk8s helm upgrade my-open5gs $(pwd)/5G-playground/open5gs-2.2.3/open5gs --namespace your-namespace --values $(pwd)/5G-playground/helms/5gSA-values.yaml\### wait for at least 5 min before running the script for upgrading the GNB\### the open5gs takes time to setup\microk8s helm upgrade my-ueransim-gnb $(pwd)/5G-playground/ueransim-gnb-0.2.6/ueransim-gnb --namespace your-namespace --values $(pwd)/5G-playground/helms/my-gnb-ues-values.yaml\\### if having issues with web server\microk8s helm upgrade phpfpm-nginx-release $(pwd)/5G-playground/phpfpm-nginx-chart --namespace your-namespace</code></pre>
<p id="bkmrk--2">Uninstalling and reinstalling the deployments may work as a last resort</p>
<pre id="bkmrk-%23%23%23-uninstall-helm-c"><code class="language-shell">### uninstall helm charts, when done OR if errors cannot be fixed, uninstall and reinstall\microk8s helm uninstall -n your-namespace phpfpm-nginx-release\microk8s helm uninstall -n your-namespace my-ueransim-gnb\microk8s helm uninstall -n your-namespace my-open5gs\### WAIT for a few minutes before reinstalling the helm charts to ensure proper clean up by microk8s\### if not, prepare for a lot of issues to appear\\microk8s helm install my-open5gs $(pwd)/5G-playground/open5gs-2.2.3/open5gs --namespace your-namespace --values $(pwd)/5G-playground/helms/5gSA-values.yaml\sleep 10s ### best to wait at least 5 minutes before running next command\microk8s helm install my-ueransim-gnb $(pwd)/5G-playground/ueransim-gnb-0.2.6/ueransim-gnb --namespace your-namespace --values $(pwd)/5G-playground/helms/my-gnb-ues-values.yaml\microk8s helm install phpfpm-nginx-release $(pwd)/5G-playground/phpfpm-nginx-chart --namespace your-namespace\</code></pre>
<h5 id="bkmrk-other-errors">Other Errors</h5>
<p id="bkmrk-1.-if-faced-with-the">1. If faced with the below error, simply run <code>newgrp microk8s</code> on the command line.&nbsp;</p>
<pre id="bkmrk-insufficient-permiss"><code class="language-shell">Insufficient permissions to access MicroK8s.\You can either try again with sudo or add the user ubu22 to the 'microk8s' group:\\&nbsp; &nbsp; sudo usermod -a -G microk8s ubu22\&nbsp; &nbsp; sudo chown -R ubu22 ~/.kube\\After this, reload the user groups either via a reboot or by running 'newgrp microk8s'.</code></pre>
<p id="bkmrk-2.%C2%A0when-running-micr">2.&nbsp;When running <code>microk8s kubectl get pods -n your-namespace</code> and faced with the below, the 5G network should not be affected.</p>
<pre id="bkmrk-my-open5gs-populate-"><code class="language-">my-open5gs-populate-f7cc975f5-lh92b        0/1     Unknown   0                20m</code></pre>
