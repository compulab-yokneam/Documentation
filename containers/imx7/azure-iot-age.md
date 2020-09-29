## Install Azure IoT Edge runtime on CL-SOM-iMX7 based devices

- Docker Engine installation is supported on CL-SOM-iMX7 / IOT-GATE-iMX7 / SBC-IOT-iMX7 [BSP release 6.3](https://www.compulab.com/wp-content/uploads/2020/05/cl-som-imx7-bsp-bin_2020_05_10.zip "BSP release 6.3") or later.
- Docker Engine installation was recently verified on CL-SOM-iMX7 / IOT-GATE-iMX7 / SBC-IOT-iMX7 BSP release 6.3:
	- Kernel is based on 4.14.98
	- Userspace version is Debian Buster 10

### Installation
The full installation procedure is described [here](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge-linux "Azure IoT Edge runtime on Debian"). Below is a short summary and a few necessary tips for smooth installing of Docker Engine.
1.  Install the latest CL-SOM-iMX7 / IOT-GATE-iMX7 / SBC-IOT-iMX7 BSP release using ether  [Automatic](https://mediawiki.compulab.com/w/index.php?title=CL-SOM-iMX7:_Linux:_Automatic_Installation "Automatic") or [Manual](https://mediawiki.compulab.com/w/index.php?title=CL-SOM-iMX7:_Linux:_Manual_Installation "Manual") installation procedure.
2. Switch to the [Moby compatible kernel](https://blog.hypriot.com/post/verify-kernel-container-compatibility/ "Moby compatible kernel"). The following U-Boot command should be used to select the appropriate kernel image:
<pre>
CL-SOM-iMX7 # setenv kernel zImage-moby-comp
CL-SOM-iMX7 # savee
</pre> 
3. [Log in](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX7_and_SBC-IOT-iMX7:_Linux:_Debian#Connection_and_Logging_In "Log in") using either *root* user or *compulab* sudo user.
4. Verify the kernel version:
<pre>
root@cl-debian:~$ uname -a
Linux cl-debian 4.14.98-cl-som-imx7-6.3-moby-comp #1 SMP PREEMPT Thu Apr 23 18:28:02 IDT 2020 armv7l GNU/Linux
</pre>
5. Bring a network iface up, obtain an IP address:
<pre>root@cl-debian:~$ dhclient eth0</pre>
6. Verify your Linux kernel for Moby compatibility:
<pre>
root@cl-debian:~$ apt update
root@cl-debian:~$ apt install --no-install-recommends curl
root@cl-debian:~# curl -sSL https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh -o /opt/check-config.sh
root@cl-debian:~# chmod +x /opt/check-config.sh
root@cl-debian:~# /opt/check-config.sh
...
</pre>
Check that all required features are enabled.

7. Download and install libssl1.0.2 package (not supported by Debian 10):
<pre>
root@cl-debian:~# curl http://ftp.ch.debian.org/debian/pool/main/o/openssl1.0/libssl1.0.2_1.0.2u-1~deb9u1_armhf.deb > /opt/libssl1.0.2_1.0.2u-1~deb9u1_armhf.deb
root@cl-debian:~# dpkg -i /opt/libssl1.0.2_1.0.2u-1~deb9u1_armhf.deb
</pre>
8. Register Microsoft key and software repository feed
<pre>
root@cl-debian:~# curl https://packages.microsoft.com/config/debian/stretch/multiarch/prod.list > /opt/microsoft-prod.list
root@cl-debian:~# cp /opt/microsoft-prod.list /etc/apt/sources.list.d/
root@cl-debian:~# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /opt/microsoft.gpg
root@cl-debian:~# cp /opt/microsoft.gpg /etc/apt/trusted.gpg.d/
</pre>
9. Install the Moby engine
<pre>root@cl-debian:~# apt-get update && apt-get install moby-engine moby-cli</pre>
**Note:** during this step you may see following message:
<pre>
...
Job for docker.service failed because the control process exited with error code.
See "systemctl status docker.service" and "journalctl -xe" for details.
root@cl-debian:~# systemctl status docker.service
��● docker.service - Docker Application Container Engine
   Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
   Active: failed (Result: exit-code) since Thu 2020-04-30 17:11:50 UTC; 18s ago
     Docs: https://docs.docker.com
  Process: 2596 ExecStart=/usr/bin/dockerd -H fd:// (code=exited, status=1/FAILURE)
 Main PID: 2596 (code=exited, status=1/FAILURE)
root@cl-debian:~# journalctl -xe | grep -i docker
...
Apr 30 18:43:24 cl-debian dockerd[3620]: failed to start daemon: Error initializing network controller: error obtaining controller instance: failed to create NAT chain DOCKER: iptables failed: iptables -t nat -N DOCKER: iptables: Operation not supported.
...
</pre>
In this case please perform the next two steps:
10. Setup Debian to use the legacy *iptables*:
<pre>
root@cl-debian:~# update-alternatives --set iptables /usr/sbin/iptables-legacy
root@cl-debian:~# update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
</pre>
11. Restart the docker service
<pre>root@cl-debian:~# systemctl restart docker</pre>
12. Install the Azure IoT Edge Security Daemon
<pre>root@cl-debian:~# apt-get install iotedge</pre>
13. Log into the Azure portal, [create](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-create-through-portal "Create an IoT hub") IoT Hub  and [register](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-register-device "Register an Azure IoT Edge device") an Azure IoT Edge device.
14. Configure the security deamon. Edit the */etc/iotedge/config.yaml* config file, set there the device connection string, generated during device registration:
<pre>
root@cl-debian:~# chmod +w /etc/iotedge/config.yaml
root@cl-debian:~# vi /etc/iotedge/config.yaml
...
</pre>
Please refer to the daemon [configuration](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge-linux#configure-the-security-daemon "Configure the security daemon") webpage for more details.
15. Restart the security deamon
<pre>
root@cl-debian:~# systemctl restart iotedge
root@cl-debian:~# systemctl status iotedge
��● iotedge.service - Azure IoT Edge daemon
   Loaded: loaded (/lib/systemd/system/iotedge.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2020-04-30 19:03:05 UTC; 4min 28s ago
     Docs: man:iotedged(8)
 Main PID: 4202 (iotedged)
    Tasks: 9 (limit: 1623)
   Memory: 2.6M
   CGroup: /system.slice/iotedge.service
           ��└��─4202 /usr/bin/iotedged -c /etc/iotedge/config.yaml
Apr 30 19:07:25 cl-debian iotedged[4202]: 2020-04-30T19:07:25Z [INFO] - Successfully created module edgeAgent
Apr 30 19:07:25 cl-debian iotedged[4202]: 2020-04-30T19:07:25Z [INFO] - Starting module edgeAgent...
Apr 30 19:07:27 cl-debian iotedged[4202]: 2020-04-30T19:07:27Z [INFO] - Successfully started module edgeAgent
Apr 30 19:07:27 cl-debian iotedged[4202]: 2020-04-30T19:07:27Z [INFO] - Checking edge runtime status
Apr 30 19:07:27 cl-debian iotedged[4202]: 2020-04-30T19:07:27Z [INFO] - Edge runtime is running.
Apr 30 19:07:27 cl-debian iotedged[4202]: 2020-04-30T19:07:27Z [INFO] - Checking edge runtime status
Apr 30 19:07:27 cl-debian iotedged[4202]: 2020-04-30T19:07:27Z [INFO] - Edge runtime is running.
Apr 30 19:07:27 cl-debian iotedged[4202]: 2020-04-30T19:07:27Z [INFO] - Checking edge runtime status
Apr 30 19:07:27 cl-debian iotedged[4202]: 2020-04-30T19:07:27Z [INFO] - Edge runtime is running.
Apr 30 19:07:33 cl-debian iotedged[4202]: 2020-04-30T19:07:33Z [INFO] - [work] - - - [2020-04-30 19:07:33.153829878 UTC] "GET /trust-bundle?api-version=2019-01-30 HTTP/1.1" 200 OK 1944 "-" "-" auth_id(-)
</pre>
16. Verify successful installation
<pre>
root@cl-debian:~# iotedge list
NAME           STATUS           DESCRIPTION      CONFIG
edgeAgent        running          Up a minute      mcr.microsoft.com/azureiotedge-agent:1.0
</pre>

### Here you go!
