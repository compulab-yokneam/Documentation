## Technician Manual: Linux Watchdog Daemon
The watchdog daemon acts as a safety switch. It continually performs checks and "pets" the system hardware watchdog timer device (/dev/watchdog). If any test fails, or if the operating system freezes completely, the software stops resetting the timer, causing the hardware to hard-reboot the machine to recover it. 

## Part 1: Configuration Guide
All configurations must be added to the primary configuration file located at ``/etc/watchdog.conf``. Open this file using a text editor (e.g., sudo nano /etc/watchdog.conf) and apply the settings detailed below.
## 1. Basic Setup & Kernel Hang Detection
To ensure the watchdog is bound to your physical or virtual watchdog chip and catches system-wide kernel lockups, configure the following core lines:

```
# Core hardware device link
watchdog-device = /dev/watchdog

# Reset time-out interval (checks happen every 5 seconds)
interval = 5

# Catch extreme kernel/CPU overload crashes
max-load-1 = 24
```

* ``watchdog-device``: Maps the service directly to the device node.
* ``max-load-1``: If the 1-minute system load average spikes excessively high (e.g., above 24), the system is considered frozen/unresponsive and will reboot. [8] 

## 2. Block Device Failure Detection
If a disk drive physically fails, drops off the system bus, or stops responding, the watchdog can catch it using the device parameter:

```
# Monitor specific block devices
device = /dev/sda
device = /dev/nvme0n1
```

* How it works: The daemon regularly pings these block devices. If a device becomes completely unreadable or missing, the ping fails, and a reboot is initiated.

## 3. File System Integrity Detection
To catch file systems that have crashed, unmounted unexpectedly, or run out of critical structural indices (inodes), use the file configuration:

```
# Ensure a vital target file exists and is accessible
file = /var/log/messages

# Require at least 1 free inode on critical file system mount points
change = 1 /
change = 1 /var
```

* ``file``: The daemon checks if the file can be opened. If file system corruption makes the file unreadable, the system reboots.
* ``change``: Compares file system attributes (like inode allocation) between intervals. If a vital file system breaks or changes illegally, it triggers a recovery reboot.

## 4. Activating Changes
Once you have edited the file, save it and restart the watchdog daemon:
```
sudo systemctl daemon-reload
sudo systemctl enable --now watchdog
```
------------------------------
## Part 2: Proof-of-Design Sample Tests
Run these tests on a non-production test environment. Warning: Every successful test will immediately crash and reboot the host machine. [2] 
## Test 1: Simulating a Hard Kernel Panic

* Goal: Prove the watchdog hardware recovers a completely locked kernel.
* Execution: Run the following command as root to instantly force a kernel crash:

sudo sync && echo c | sudo tee /proc/sysrq-trigger

* Result: The kernel halts instantly. Because it is frozen, it cannot pet the watchdog. The hardware timer will expire in a few seconds, forcing a clean motherboard reset.

## Test 2: Simulating Daemon/Software Failure

* Goal: Prove that if the watchdog daemon crashes or hangs, the system self-recovers.
* Execution: Kill the daemon forcefully without letting it cleanly shut down its timer path:

sudo killall -9 watchdog

* Result: The system will remain functional for up to 60 seconds (the default hardware timeout boundary). Since the daemon was killed aggressively, it cannot pet the hardware node, resulting in an automatic hardware reset.

## Test 3: Simulating a Broken File System Condition

* Goal: Prove the watchdog catches file-level or structural availability issues.
* Execution: To simulate this without actually breaking a disk, temporarily comment out or rename the file monitored by your ``/etc/watchdog.conf`` file:
  ```
  sudo mv /var/log/messages /var/log/messages.bak
  ```

* Result: Within the next 5 to 10 seconds, the watchdog daemon will notice the configured file is missing. It will intentionally stop feeding the device kernel driver, causing the system to automatically reboot. (Note: Remember to restore the filename using mv /var/log/messages.bak /var/log/messages after the reboot).

### Resources:
[0] [https://share.google/aimode/Jx3ZKv2ldTv0LFzok]
<br>[1] [https://docs.oracle.com](https://docs.oracle.com/en/operating-systems/oracle-linux/9/boot/boot-ConfigWatchdogServ.html)
<br>[2] [https://docs.jethome.com](https://docs.jethome.com/en/controllers/linux/howto/watchdog.html)
<br>[3] [https://unix.stackexchange.com](https://unix.stackexchange.com/questions/714910/what-is-a-good-way-to-test-watchdog-script-or-command-to-deliberately-overload)
<br>[4] [https://docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_virtualization/4.0/html/virtual_machine_management_guide/sect-configuring_a_watchdog)
<br>[5] [https://www.kernel.org](https://www.kernel.org/doc/html/v5.9/watchdog/watchdog-api.html)
<br>[6] [https://www.youtube.com](https://www.youtube.com/shorts/RaBRgHrMprc)
<br>[7] [https://www.youtube.com](https://www.youtube.com/watch?v=4EXPep_fBho&t=220)
<br>[8] [https://docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_virtualization/4.1/html/virtual_machine_management_guide/sect-configuring_a_watchdog)
<br>[9] [https://www.systutorials.com](https://www.systutorials.com/linux-manual-page-8-watchdog/)
<br>[10] [https://developer.toradex.com](https://developer.toradex.com/software/linux-resources/linux-features/watchdog-linux/)
<br>[11] [https://unix.stackexchange.com](https://unix.stackexchange.com/questions/491814/is-it-possible-to-activate-the-watchdog-on-any-linux-machine)
<br>[12] [https://www.crawford-space.co.uk](https://www.crawford-space.co.uk/old_psc/watchdog/watchdog-testing.html)
<br>[13] [https://www.crawford-space.co.uk](https://www.crawford-space.co.uk/old_psc/watchdog/watchdog-testing.html)
<br>[14] [https://linux.die.net](https://linux.die.net/man/5/watchdog.conf)
