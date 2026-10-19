# How to debug suspend/resume 

```bash
echo N > /sys/module/printk/parameters/console_suspend
echo 8 > /proc/sys/kernel/sysrq
echo 8 > /proc/sys/kernel/printk
echo 1 > /sys/power/pm_print_times
rtcwake -s 5 -m mem
```
