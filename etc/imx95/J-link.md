# Prepare the imx95
* Disable cpuidle; issue this command in the u-boot prompt:
```
setenv boot_opt 'cpuidle.off=1 watchdog.panic_on_timeout=0'; saveenv;
```

# Launch J-LinkExt
```
JLinkExe -device MIMX9596_A55_0 -if JTAG -speed 1000
```

# Launch J-Link GDB Server (Recommended)
* Local:
```
JLinkGDBServer -device iMX95_A55_0 -select USB -if JTAG -speed auto -nohalt -noreset
```
* Remote:

```
JLinkGDBServer -device iMX95_A55_0 -select IP=192.168.2.140 -if JTAG -speed auto -nohalt -noreset
```

#  Connect GDB to the Session
* U-Boot debugging
```
bash
gdb-multiarch u-boot  # Pass your compiled u-boot ELF file to load symbols
(gdb) target remote localhost:2331
(gdb) info registers
(gdb) continue
```
* Linux kernel debugging
```
bashgdb-multiarch vmlinux
(gdb) target remote :2331
(gdb) info registers
(gdb) continue
```

When you hit Ctrl+C in GDB, it sends a standardized core-halt interrupt that Linux understands,<br>
allowing for safe halts and stable continue commands without killing the board.
