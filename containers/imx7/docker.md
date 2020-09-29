## Install Docker Engine on CL-SOM-iMX7 based devices

- Docker Engine installation is supported on CL-SOM-iMX7 / IOT-GATE-iMX7 / SBC-IOT-iMX7 [BSP release 6.3](https://www.compulab.com/wp-content/uploads/2020/05/cl-som-imx7-bsp-bin_2020_05_10.zip "BSP release 6.3") or later.
- Docker Engine installation was recently verified on CL-SOM-iMX7 / IOT-GATE-iMX7 / SBC-IOT-iMX7 BSP release 6.3:
	- Kernel is based on 4.14.98
	- Userspace version is Debian Buster 10

### Installation
The full installation procedure is described [here](https://docs.docker.com/engine/install/debian/ "Debian"). Below is a short summary and a few necessary tips for smooth installing of Docker Engine.
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
5. Bring a network iface up, obtain an IP address
<pre>root@cl-debian:~$ dhclient eth0</pre>
6. Verify your Linux kernel for Moby compatibility
<pre>
root@cl-debian:~$ apt update
root@cl-debian:~$ apt install --no-install-recommends curl
root@cl-debian:~# curl -sSL https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh -o /opt/check-config.sh
root@cl-debian:~# chmod +x /opt/check-config.sh
root@cl-debian:~# /opt/check-config.sh
...
</pre>
Check that all required features are enabled.

7. Follow the [Docker](https://docs.docker.com/engine/install/debian/ "Install Docker Engine on Debian") installation procedure for ***armhf*** architecture. Please note you are expected to obtain the following error when you try to install Docker engine:
<pre>
...
dpkg: error processing package docker-ce (--configure):
 installed docker-ce package post-installation script subprocess returned error exit status 1
...
Errors were encountered while processing:
 docker-ce
E: Sub-process /usr/bin/dpkg returned an error code (1)
...
</pre>
8. Setup Debian to use the legacy *iptables*:
<pre>
root@cl-debian:~# update-alternatives --set iptables /usr/sbin/iptables-legacy
root@cl-debian:~# update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
</pre>
9. Install the Docker engine again:
<pre>root@cl-debian:~# apt install docker-ce</pre>
10. Verify installation:
<pre>root@cl-debian:~# docker run hello-world</pre>

### Here you go!
