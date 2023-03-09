# Get Mac How to

* With Internet connection

```
bash <(curl -sL https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/mac.sh) 
```

* With out Internet connection

```
cat << eof | tee /tmp/mac.sh
#!/bin/bash

grep -ira  . /sys/class/net/*/address | awk -F"net/" '\$0=\$2'

eof

bash /tmp/mac.sh

```
