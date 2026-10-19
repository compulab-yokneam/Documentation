# How to debug suspend/resume 

## 1 
```bash
echo N > /sys/module/printk/parameters/console_suspend
echo 8 > /proc/sys/kernel/sysrq
echo 8 > /proc/sys/kernel/printk
echo 1 > /sys/power/pm_print_times
rtcwake -s 5 -m mem
```
## 2
```
Ctrl+A → F → w     blocked tasks
Ctrl+A → F → t     all task stacks
```
